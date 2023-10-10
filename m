Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 810D57C45AE
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 01:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjJJXs5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 19:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344181AbjJJXsy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 19:48:54 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B04294
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 16:48:53 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a7cc433782so13131887b3.3
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 16:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696981732; x=1697586532; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vQStLbyH9gKACNZyLNIgH8hrWADINSCpVawjpRiayj0=;
        b=JM3foGVo3KgFs/r+Pl3+L7eZy8epkZkN7NUzQ+d3ev2I5rsJycKbt77O09jLx1Tzl+
         J4XHILFUua9Qj7m7w5BA1Gc5R2VXFrxDwfT9xZf1Q8olor0bkd8exhHeZbzOEAuTSuWc
         7CxAyP3TGrSlxj6/8uA4fgAG24dWa2e7KbtI0k+nG01EJ6U1ZPkh7La+JfO25KXSnPNe
         cCO6OHuafCGxSM8iD4qUCj76KKH5Ck09zgFo7WkVc9239KeD/4gnTrKpW3XF2NevWyWC
         CUwRAddu5jjfWCyCubnEOHFzsHshZ671Bo4kcmDsaJkofp9oU1q1mSaBDd9pKuk8zJZA
         fv/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696981732; x=1697586532;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vQStLbyH9gKACNZyLNIgH8hrWADINSCpVawjpRiayj0=;
        b=uCaviu7Qxo71ILoOrt4uzmCMJHkfBO8fK/6j8EKg538Iovc6RJpjwUg1P9jcVKIpdg
         3+WWPg2Qq6C7cwC2Ag9qkq5cqv50joAhPOnrDsmeG9YnTcrBlNHcQmk/k3liVvQEIbWx
         WEjzj5duxYIzZHsVOrIzwslvFDih/lhy6u11rEAmcziRLNKoRAdNepyxm8XR/QF72bFS
         ZDttJVFHYRAvGs8vI0VgHwoZZBxHe2S0charP7Z9mw/XDQOctDgx7ukfzmER458UnkgL
         4WtJ840NdKkHFYlbmZ5Z17eOnyG1oAW2nUC5R86s3Ggdy/FJo/53bnZY+L96tpNFuSt6
         WtJA==
X-Gm-Message-State: AOJu0YwecIvlTeeJ/dAgve1FceZSBgg5wJYgW448ZrvARUB58Ec5BvPt
        L1kDki6a7WHXkwTr4pCxgq6iVXNCgbs=
X-Google-Smtp-Source: AGHT+IGrHihBynjvlz6OHSigbF6Wf2hA+hLp+6irCyiVNuTjlNyflwazlCCjGIhhpZbdyyJnosIpog7oRFQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:aa4d:0:b0:5a1:d4a5:7dff with SMTP id
 z13-20020a81aa4d000000b005a1d4a57dffmr379839ywk.6.1696981732579; Tue, 10 Oct
 2023 16:48:52 -0700 (PDT)
Date:   Tue, 10 Oct 2023 16:48:50 -0700
In-Reply-To: <46b73aa3-4776-8d95-b3f4-c2ddf4f0696c@linux.intel.com>
Mime-Version: 1.0
References: <20230913124227.12574-1-binbin.wu@linux.intel.com> <46b73aa3-4776-8d95-b3f4-c2ddf4f0696c@linux.intel.com>
Message-ID: <ZSXi4hUscwMYmrV0@google.com>
Subject: Re: [PATCH v11 00/16] LAM and LASS KVM Enabling
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@aculab.com, robert.hu@linux.intel.com,
        guang.zeng@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 08, 2023, Binbin Wu wrote:
> Hi Sean,
> 
> Does this version of LAM patch set have the chance to be pulled for 6.7?

There's still a chance, but I haven't looked at this version yet, so I can't give
a more confident answer, sorry.  For a variety of reasons, my review time this
cycle has been much more limited than I anticipated.

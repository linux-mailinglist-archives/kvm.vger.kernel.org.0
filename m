Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 937147A51B1
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 20:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbjIRSIG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 14:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjIRSIF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 14:08:05 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F96C11C
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 11:07:47 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59b5d4a8242so57946097b3.0
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 11:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695060466; x=1695665266; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GmTnJV1ADdgeWLSdVtD0/++n9rF2F3zpNnWnlLAWBfc=;
        b=GgolAgTXkgd3VIcWP7ez1fL2XXc6EffJ/lZHJY+CaZmD4jVSs7DGfqajEaHeJcUNuW
         FkavDT6fVgLVQ5xkOGOJJnVLtWhrkkxlS1HxNL7qqHmZ/kzCz7vnHVdVkg9MKC3dEG73
         AOoTgxwQoGiOaYTgW43KnWApZ6N8oLXKjkaxD+mQ+tTSSvG31kNCNO8kTIXcrmPfJ3ZF
         1ObEDp++U8gHy1Ik4SdqWwJVtkmv3UCUicQmXjiJ/R8Ruxmjfu/qsZ4Sd7gxI/ix0M2D
         j67xIjfUbFDe2nJWRSUpW5FDCfcr3Cq1FFFQDtTEi2uBnbDtJD6OHIzX2wn+zgy5S8IK
         IQLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695060466; x=1695665266;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GmTnJV1ADdgeWLSdVtD0/++n9rF2F3zpNnWnlLAWBfc=;
        b=aOyRyydvRYS2CvOU2/RywlmdWGYAXv4sdO2H7IsphIGyb/ve5F1Xtrn3uWaXjshTZW
         X08yQHLIieuk7z9B1Q8pIHNX+S3zbpitTNDFbsekw+G9n6R+/t0ZnYov8uSV2O1zv4At
         Yxb2zHEFHt+tCUKQHMcdLrVx72ShH09RtRz5atOjelzsXvajY2o7y22gQg21H+onLAEe
         geG+jLPQyHgNTWz8BkUFKaG9cSYzkQx0XDrnm6I7igxoUqs8N/GqCF7YRHzUg5KxhfTM
         GneG02MaF6BlGb6jyjGBdaa+Q1VemwVGf0X09YoMNEdFSl4JoF7v3cEdmzP2G2LyeKkM
         qWcg==
X-Gm-Message-State: AOJu0Yz3vFQ0ucBtSFBroL4X8Qovuimo+pUX9zVSYaVSR2iEZgFG0evc
        aGnhyH3vCddRVWlJMMubAt7kTAwxfT4=
X-Google-Smtp-Source: AGHT+IEq7OsCrz76V3mWe/TIshYEHjDRsyEPSR2V+8pZ5m5ogKwdrddivlWbUzqfoZQCwHuHP6FyJ33Wqu8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:af28:0:b0:584:3d8f:a425 with SMTP id
 n40-20020a81af28000000b005843d8fa425mr264367ywh.10.1695060466507; Mon, 18 Sep
 2023 11:07:46 -0700 (PDT)
Date:   Mon, 18 Sep 2023 11:07:44 -0700
In-Reply-To: <CAG48ez0YBOUGnj+N_MBp2WCvp0BLk1o7n6uSH2nrj1z-qgf+0A@mail.gmail.com>
Mime-Version: 1.0
References: <CAG48ez0YBOUGnj+N_MBp2WCvp0BLk1o7n6uSH2nrj1z-qgf+0A@mail.gmail.com>
Message-ID: <ZQiR8IpqOZrOpzHC@google.com>
Subject: Re: KVM nonblocking MMU notifier with KVM_GUEST_USES_PFN looks racy
 [but is currently unused]
From:   Sean Christopherson <seanjc@google.com>
To:     Jann Horn <jannh@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        kernel list <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 18, 2023, Jann Horn wrote:
> Hi!
> 
> I haven't tested this and might be missing something, but I think that
> the MMU notifier for KVM_GUEST_USES_PFN pfncache is currently a bit
> broken. Except that nothing seems to actually use KVM_GUEST_USES_PFN,
> so currently it's not actually a problem?

Yeah, the implementation is busted, and IMO the entire concept is a dead-end[1].
David Steven's series[2] doesn't actually rip out KVM_GUEST_USES_PFN, I'll add
that to the todo list.  There are no users, and I don't expect any to come along,
precisely because it's busted :-)

[1] https://lore.kernel.org/all/ZBEEQtmtNPaEqU1i@google.com
[2] https://lkml.kernel.org/r/20230911021637.1941096-1-stevensd%40google.com

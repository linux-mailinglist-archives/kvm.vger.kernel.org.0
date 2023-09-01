Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58302790383
	for <lists+kvm@lfdr.de>; Sat,  2 Sep 2023 00:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240590AbjIAWDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 18:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350861AbjIAVwT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 17:52:19 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0E01FFD
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 14:49:50 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-68beedc7d7eso3139421b3a.1
        for <kvm@vger.kernel.org>; Fri, 01 Sep 2023 14:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693604990; x=1694209790; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IzrwaMmvE4QKswRKE7C/ju9oj59F13j6HsTSXcpNzv4=;
        b=xDFjhuG41oQNfkoQJz+WpsEDMcKxlKAsgrAMezE76fYrGvDinrjN1A1fT+yvyaBibH
         iqDBxnYR5PaXg3TRnzwoepPe7CVWV5oEwA6Bz5xisWALZnG6MzjLfObPAP7c9ru3vGpM
         iAK7Olbs6SdQ4Yve1Oir8H6mkJwuQybvAHyENbm1PnJXnk43glwpV2PBPn4/r8AuA6UE
         7hhAuLeYuBZfKxsX/c9e4cx8goy6+EpYUvlk/gZ+SwBlVMJqAfeAuQVY5Qv4FJGCrzod
         rkc00z6Ii90jbhVSIQFybk0nfPyQnf5h8f8IUFcrMxYOzsW794PBG6FpABvrySDASvz2
         HSNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693604990; x=1694209790;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IzrwaMmvE4QKswRKE7C/ju9oj59F13j6HsTSXcpNzv4=;
        b=afY5xAr4+E/omyBz2QfCsXTyVKtmVygI3CX/Bh22pMekJEq/fI0Wu+4Rf3/eAy4y9L
         y0jt+beJD6JikgNiDqUUECHCmuhFga93RdfHEaLIfmiEi3b38f77/ezd7GUcDjtRDCs/
         JR01BaCIqpmm4X8LzTEiv8wfLxfcdn0OrSfqB2O21Ygq9tcPRuvOkyUJr7dLOZ/LWzeZ
         +g/DneW5Dch3f/QpXDo1nxJQMlVat9f4kPbjQbJcxb3gN1Els1PHqHStehIN3DQ+NVmd
         Hne3I7VbV05eKbdIyC9gYlEQAhqILz2x4W6skqqCe74KCyZWMMtqFNuzZ3VV4AM7ZbJW
         kMgQ==
X-Gm-Message-State: AOJu0Yy1iH6DQ9H8UO+NzWWd9yOo/mspwAaKDzaWetnH5NjRA9cgivUX
        EPscxx4pFz+uzQMyhzC2xXe4/IpoozU=
X-Google-Smtp-Source: AGHT+IFdj3bDDCq48M7KG/zNXYWh4//YuD/9E5uRPX4l3JXxwBRPDsy7dliE67P4sJX29bsQxAqExeHWqSg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:24cd:b0:68b:dbad:7ae7 with SMTP id
 d13-20020a056a0024cd00b0068bdbad7ae7mr1588120pfv.6.1693604989744; Fri, 01 Sep
 2023 14:49:49 -0700 (PDT)
Date:   Fri, 1 Sep 2023 21:49:48 +0000
In-Reply-To: <5e33618d-1c06-b42a-0755-bf8661895e9b@redhat.com>
Mime-Version: 1.0
References: <20230830000633.3158416-1-seanjc@google.com> <20230830000633.3158416-4-seanjc@google.com>
 <ZPDNielH+HOYV89u@google.com> <CABgObfZoJjz1-CMGCQqNjA8i_DivgevEhw+EqfbD463JAMe_bA@mail.gmail.com>
 <ZPIwtfkVAyFWy41I@google.com> <5e33618d-1c06-b42a-0755-bf8661895e9b@redhat.com>
Message-ID: <ZPJcfAneye3S4fiR@google.com>
Subject: Re: [GIT PULL] KVM: x86: MMU changes for 6.6
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
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

On Fri, Sep 01, 2023, Paolo Bonzini wrote:
> On 9/1/23 20:43, Sean Christopherson wrote:
> > > Ok, I'll apply these by hand.
> > In case you haven't taken care of this already, here's an "official" tested fix.
> > 
> > Like, if you can give your SoB, I'd rather give you full author credit and sub
> > me out entirely.
> 
> I prefer to squash and possibly face Linus's wrath. :)

LOL, works for me, as long as you're taking the bullets. ;-)

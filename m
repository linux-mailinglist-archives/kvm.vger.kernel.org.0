Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEBCE77ED5F
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 00:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347013AbjHPWrD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 18:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347014AbjHPWq7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 18:46:59 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDCC1BF7
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 15:46:57 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bb8caf7312so4077805ad.0
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 15:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692226016; x=1692830816;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=n7a+uEDA5jWim2WjEe90Wh2lZxzibPYDcHdGrkYhrCo=;
        b=3rWoeQRrMGgmiQAR59dF+dosUKDEIxpMJHcGetrQmAYhK7t/p+kJTyRyARgg6NFdIM
         SFj6HTnU3/0HTfd8+Pi25DdHz547vqeGA+sMkVjSFICq45apap82cKChchDfpHsxqiY3
         Cq67uWauPB+TPSB6IjaPnJqQCsmSpnVmdcOEsswdT61h1ykcZn/PWvOExXraCT51rvUB
         Ris6ap9kzZYPhw2d0ojgodh7k26ZB9f6S/JZKn9sb0ph0bf1g4AB0mkykRAyYdH/cX6q
         4hIgZFneL3wAUEmB3o5iHkiOy3y7bkTXxFew/qBiP5eM7Sph6BdaRAQ1IL0drcyMelIW
         +Hug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692226016; x=1692830816;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n7a+uEDA5jWim2WjEe90Wh2lZxzibPYDcHdGrkYhrCo=;
        b=CDDJba/Q/HfQJCgT1fNjfal/5o1bRaoyAjJWNz37P2DTF3RHmZ1Da2wNuKtf1O+u+0
         CbAvjrEOKHbcnYN8zPJFrgwNppOJ6Hh22Xy1Y1Af4Uh8Nc+BkoSPpDqCso9uC67N1nqx
         EW/Vb7d19Chvq9SB6hLLWJ+Rzr39pEvoWaSyuM6z3/HMXjEMRqfwmyKgQjkJog20x6eJ
         eJ4XASnKqN6hN8WS1ZInUEUnH9aucTui2uNZONA5FFUUUZmQ1O87gHAgiwZ307SHVPze
         R9xv6/eG+rF99/eqwSV1hjtgbRW7ekbyhRmJ+8RfaqkqsgwFxZHtSkOb2GzeoPU3kmb+
         Nwsg==
X-Gm-Message-State: AOJu0Yw/IpavLWl3mBqtEmCOdp3qP0fpOSyhFuHEqBOi4lj+oz0B9hTd
        3PqK35PmJPXft/qfy97DzHQ7p65KHeo=
X-Google-Smtp-Source: AGHT+IH0EciIyG+E7fGItbQPNlQ+YZpngXRdFj7vCBCg/vY89U8Bdg91XCR3378skcS2onG2JHZ9RKdEjr8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:27cd:b0:1bc:73a6:8be7 with SMTP id
 km13-20020a17090327cd00b001bc73a68be7mr186093plb.3.1692226016567; Wed, 16 Aug
 2023 15:46:56 -0700 (PDT)
Date:   Wed, 16 Aug 2023 15:46:55 -0700
In-Reply-To: <20230801002127.534020-5-mizhang@google.com>
Mime-Version: 1.0
References: <20230801002127.534020-1-mizhang@google.com> <20230801002127.534020-5-mizhang@google.com>
Message-ID: <ZN1R31uo4FGQfKrQ@google.com>
Subject: Re: [PATCH v3 4/6] KVM: Documentation: Add the missing description
 for tdp_mmu_root_count into kvm_mmu_page
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Xu Yilun <yilun.xu@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 01, 2023, Mingwei Zhang wrote:
> Add the description of tdp_mmu_root_count into kvm_mmu_page description and
> combine it with the description of root_count. tdp_mmu_root_count is an
> atomic counter used only in TDP MMU. Update the doc.
> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> ---
>  Documentation/virt/kvm/x86/mmu.rst | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
> index 17d90974204e..40daf8beb9b1 100644
> --- a/Documentation/virt/kvm/x86/mmu.rst
> +++ b/Documentation/virt/kvm/x86/mmu.rst
> @@ -229,10 +229,14 @@ Shadow pages contain the following information:
>      can be calculated from the gfn field when used.  In addition, when
>      role.direct is set, KVM does not track access permission for each of the
>      gfn. See role.direct and gfn.
> -  root_count:
> -    A counter keeping track of how many hardware registers (guest cr3 or
> -    pdptrs) are now pointing at the page.  While this counter is nonzero, the
> -    page cannot be destroyed.  See role.invalid.
> +  root_count / tdp_mmu_root_count:
> +     root_count is a reference counter for root shadow pages in Shadow MMU.
> +     vCPUs elevate the refcount when getting a shadow page that will be used as
> +     a root page, i.e. page that will be loaded into hardware directly (CR3,
> +     PDPTRs, nCR3 EPTP). Root pages cannot be destroyed while their refcount is
> +     non-zero. See role.invalid. tdp_mmu_root_count is similar but exclusively
> +     used in TDP MMU as an atomic refcount. When the value is non-zero, it
> +     allows vCPUs acquire references while holding mmu_lock for read.

That last sentence is wrong.  *vCPUs* can't acquire references while holding
mmu_lock for read.  And actually, they don't ever put references while holding
for read either.  vCPUs *must* hold mmu_lock for write to obtain a new root,
Not putting references while holding mmu_lock for read is mostly an implementation
quirk.

Maybe replace it with this?

    tdp_mmu_root_count is similar but exclusively used in the TDP MMU as an
    atomic refcount (select TDP MMU flows walk all roots while holding mmu_lock
    for read, e.g. when clearing dirty bits).

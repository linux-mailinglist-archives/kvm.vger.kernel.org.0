Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECCC723095
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 22:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbjFEUBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 16:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjFEUBC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 16:01:02 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1ADF2
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 13:01:01 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b04600cac6so20254445ad.1
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 13:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685995261; x=1688587261;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LuPYpZQoANGWHsbwqH61DHG0i0j2jZ97nfjqkAOX2qw=;
        b=2V4KKudnlkHdWj9IYRf5i3PWTgBuQqeLOdQQfRC/cBjyUX9g+zX5I/93VliURq0os7
         R4FnWqJvx7TGJNTRlGpMprKN0+dNqkWdBYkoUHg7zcj86Mp13o3ItyT17F/llVA8fRyk
         uyRvcVc95strFheLfRuMX1qM/CVZ1gPDOrlXiaNzqaUbF8zlDp/iejHeDiRsm+bZ0Y1N
         nn+B2Cs/eoWsUroam5as3a+uQhbLk2rMg1fFg2O78oynIvclCTiYGBG+xCOie7hn186K
         04rr7qrNHdsWz+DDwm1JO6Xw3mVuEJGk0XbXU4MMg3R3hG1Dp6q3Iw62ZO244zIzOMJk
         AFrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685995261; x=1688587261;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LuPYpZQoANGWHsbwqH61DHG0i0j2jZ97nfjqkAOX2qw=;
        b=N5OUn4/hjZwZWqtUXnBATNu3nawcG+zOQdPF09Nkq/Xtq6kNCMM8peO4xPPV5kIQAT
         0rQ6XpGdRGn/7dg96lwWzqSurMYsuanJ5CQBSFIWGFQolZS1clGlyHF/zNBGdUkrxc/m
         8TOIx52HAdTAdqni8Lyf/aXVgY2Qmpcz40lF8+MQ0Tr3Mgp18IMrAvDlIXZUcY1r3GFM
         uX5sU/AzrkwUjZSzH0//TXYO46KMvyoJInVjcY6i+jEi+IbPrHf/vQa81m2Q2gQrhWtG
         0fCTsUpozi7UOKJcDpEs50A+SIxs5XPKoUnsfCxfBQIBejvryNlEfJGv/oKnd7CBmSf1
         lEAw==
X-Gm-Message-State: AC+VfDywYKiT9rLYAtE+GgD5z31zrLYmcQpxDN/0AP4WcoL4wMQ+J8aR
        qiqTNdplja36sDCAs1PAR6OMp2ghUck=
X-Google-Smtp-Source: ACHHUZ4jtSqeu15kHbopZolL5qbjlkS1Lh6tJRhhFWunpeo8o8vQW1iIjPZeANhZXuu8zD+BBIExO5qoQW0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:8684:b0:1a5:32f3:ca95 with SMTP id
 g4-20020a170902868400b001a532f3ca95mr2114668plo.8.1685995260873; Mon, 05 Jun
 2023 13:01:00 -0700 (PDT)
Date:   Mon, 5 Jun 2023 13:00:59 -0700
In-Reply-To: <20230518091339.1102-3-binbin.wu@linux.intel.com>
Mime-Version: 1.0
References: <20230518091339.1102-1-binbin.wu@linux.intel.com> <20230518091339.1102-3-binbin.wu@linux.intel.com>
Message-ID: <ZH4++07thYZk/AX9@google.com>
Subject: Re: [PATCH v2 2/3] KVM: x86: Fix comments that refer to the out-dated msrs_to_save_all
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 18, 2023, Binbin Wu wrote:
> msrs_to_save_all is out-dated after commit 2374b7310b66
> (KVM: x86/pmu: Use separate array for defining "PMU MSRs to save").
> 
> Update the comments to msrs_to_save_base.
> 
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
>  arch/x86/kvm/x86.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ceb7c5e9cf9e..ca7cff5252ae 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1432,7 +1432,7 @@ EXPORT_SYMBOL_GPL(kvm_emulate_rdpmc);
>   *
>   * The three MSR lists(msrs_to_save, emulated_msrs, msr_based_features)
>   * extract the supported MSRs from the related const lists.
> - * msrs_to_save is selected from the msrs_to_save_all to reflect the
> + * msrs_to_save is selected from the msrs_to_save_base to reflect the

A straight conversion isn't correct, msrs_to_save isn't selected from *just*
msrs_to_save_base.

>   * capabilities of the host cpu. This capabilities test skips MSRs that are
>   * kvm-specific. Those are put in emulated_msrs_all; filtering of emulated_msrs

This "kvm-specific" blurb is also stale.

>   * may depend on host virtualization features rather than host cpu features.
> @@ -1535,7 +1535,7 @@ static const u32 emulated_msrs_all[] = {
>  	 * by arch/x86/kvm/vmx/nested.c based on CPUID or other MSRs.
>  	 * We always support the "true" VMX control MSRs, even if the host
>  	 * processor does not, so I am putting these registers here rather
> -	 * than in msrs_to_save_all.
> +	 * than in msrs_to_save_base.

And this entire comment is rather weird, e.g. I have no idea what MSRs the part
about CPUID and other MSRs is referring to.

Rather than do a blind replacement, how about this?

--
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 5 Jun 2023 12:56:46 -0700
Subject: [PATCH] KVM: x86: Update comments about MSR lists exposed to
 userspace

Refresh comments about msrs_to_save, emulated_msrs, and msr_based_features
to remove stale references left behind by commit 2374b7310b66 (KVM:
x86/pmu: Use separate array for defining "PMU MSRs to save"), and to
better reflect the current reality, e.g. emulated_msrs is no longer just
for MSRs that are "kvm-specific".

Reported-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5ad55ef71433..c77f72cf6dc8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1427,15 +1427,14 @@ int kvm_emulate_rdpmc(struct kvm_vcpu *vcpu)
 EXPORT_SYMBOL_GPL(kvm_emulate_rdpmc);
 
 /*
- * List of msr numbers which we expose to userspace through KVM_GET_MSRS
- * and KVM_SET_MSRS, and KVM_GET_MSR_INDEX_LIST.
- *
- * The three MSR lists(msrs_to_save, emulated_msrs, msr_based_features)
- * extract the supported MSRs from the related const lists.
- * msrs_to_save is selected from the msrs_to_save_all to reflect the
- * capabilities of the host cpu. This capabilities test skips MSRs that are
- * kvm-specific. Those are put in emulated_msrs_all; filtering of emulated_msrs
- * may depend on host virtualization features rather than host cpu features.
+ * The three MSR lists(msrs_to_save, emulated_msrs, msr_based_features) track
+ * the set of MSRs that KVM exposes to userspace through KVM_GET_MSRS,
+ * KVM_SET_MSRS, and KVM_GET_MSR_INDEX_LIST.  msrs_to_save holds MSRs that
+ * require host support, i.e. should be probed via RDMSR.  emulated_msrs holds
+ * MSRs that emulates without strictly requiring host support.
+ * msr_based_features holds MSRs that enumerate features, i.e. are effectively
+ * CPUID leafs.  Note, msr_based_features isn't mutually exclusive with
+ * msrs_to_save and emulated_msrs.
  */
 
 static const u32 msrs_to_save_base[] = {
@@ -1531,11 +1530,11 @@ static const u32 emulated_msrs_all[] = {
 	MSR_IA32_UCODE_REV,
 
 	/*
-	 * The following list leaves out MSRs whose values are determined
-	 * by arch/x86/kvm/vmx/nested.c based on CPUID or other MSRs.
-	 * We always support the "true" VMX control MSRs, even if the host
-	 * processor does not, so I am putting these registers here rather
-	 * than in msrs_to_save_all.
+	 * KVM always supports the "true" VMX control MSRs, even if the host
+	 * does not.  The VMX MSRs as a whole are considered "emulated" as KVM
+	 * doesn't strictly require them to exist in the host (ignoring that
+	 * KVM would refuse to load in the first place if the core set of MSRs
+	 * aren't supported).
 	 */
 	MSR_IA32_VMX_BASIC,
 	MSR_IA32_VMX_TRUE_PINBASED_CTLS,

base-commit: 31b4fc3bc64aadd660c5bfa5178c86a7ba61e0f7
-- 


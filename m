Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8993D6D8DFD
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 05:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235204AbjDFD3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 23:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233867AbjDFD32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 23:29:28 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46334213D
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 20:29:27 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id n13-20020a170902d2cd00b001a22d27406bso20400539plc.13
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 20:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680751767;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h15CORNu9ncNp+50JVcQuXVD3PLOS7VZQZXoeAXoypI=;
        b=YKrkA/XjuX6OGTnY3lclc41AWxFCIYXsmF5hsRRCLlmr/LZ/haCyTj+ldKjCXP8dx/
         Xq2z7o5zczfJZ9cf8f60rjTXF041Ij3mBapglLv595BKKT1dHfwz8ajiynXQgNNrpPED
         RnwEe4tF62B4cDtts0qC/qqvSbw0qTJHgGROg3d+Z4cSQkFptlm3vuTRtZMgf+TmnpP/
         9tGxwCI5eHvVZZW+dtgQV1vu5M3DSvVWbeE6uS7RLNUN1mCSf5RSfdJ4xRmI2+n1pGmJ
         /6D7+hEO8OeHOXEzIgx8VLIOe8wkCFSqtvoc7+/n8OwTC9wqC1LRubCSVkKe7NXzzfwG
         mZ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680751767;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h15CORNu9ncNp+50JVcQuXVD3PLOS7VZQZXoeAXoypI=;
        b=okMaFRlfWkxDzgQwS1fU3A5cUxLHk4Nis/RnDWQyHjlrQt31eHU6UAOmPs7SsYtS3y
         Kjfyr7TP7wI7LwPlJ3ZVl/cm26uCQKejb1Xqp2PgUBtysy3o6dGxZy2IJ6tq4jGkhNTz
         h8BUtD0t1cbKO95MjQbG4VSo3p5qvCHbaHqhNRWBje8KsoYIbv6qv9RXubZfBlytCbjD
         7R/H06oRRS5065Ei82w8hTeU+5Ts68NsfJnXJCtkMylay19keDstWHbenIbmbhleJQim
         uzJYTakKTEc+rpJRAFv415gXEgBU4hSDKUazvgOjNtu/hb+rNl8Wkpa980X8LhXrHLt9
         OB9Q==
X-Gm-Message-State: AAQBX9eonj9t1dWkgJbZl+cr/vkT9UekIazoRS6K6qlxyLlh12nIMgeS
        lEHiTj0ZOvAi/v/euj6Ga1bi5kRNoXw=
X-Google-Smtp-Source: AKy350Y5pJ/sdE/HZdSCmlnnToA2XpgFqtC6nkm7umunJfj4QTc3Sw1KtIh0wSIpP63Yb2wWDL9RYav5Qdc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:9a8b:b0:1a0:6000:7fd0 with SMTP id
 w11-20020a1709029a8b00b001a060007fd0mr3552643plp.5.1680751766855; Wed, 05 Apr
 2023 20:29:26 -0700 (PDT)
Date:   Wed, 5 Apr 2023 20:29:25 -0700
In-Reply-To: <9fbf5b4022d67157d6305bc1811f36d9096c26fc.1680179693.git.houwenlong.hwl@antgroup.com>
Mime-Version: 1.0
References: <9227068821b275ac547eb2ede09ec65d2281fe07.1680179693.git.houwenlong.hwl@antgroup.com>
 <9fbf5b4022d67157d6305bc1811f36d9096c26fc.1680179693.git.houwenlong.hwl@antgroup.com>
Message-ID: <ZC48lSLO417emh/E@google.com>
Subject: Re: [PATCH 2/3] KVM: x86: Don't update KVM PV feature CPUID during
 vCPU running
From:   Sean Christopherson <seanjc@google.com>
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Kechen Lu <kechenl@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Kechen

On Thu, Mar 30, 2023, Hou Wenlong wrote:
> __kvm_update_cpuid_runtime() may be called during vCPU running and KVM
> PV feature CPUID is updated too. But the cached KVM PV feature bitmap is
> not updated. Actually, KVM PV feature CPUID shouldn't be updated,
> otherwise, KVM PV feature would be broken in guest. Currently, only
> KVM_FEATURE_PV_UNHALT is updated, and it's impossible after disallow
> disable HLT exits. However, KVM PV feature CPUID should be updated only
> in KVM_SET_CPUID{,2} ioctl.
> 
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> ---
>  arch/x86/kvm/cpuid.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 6972e0be60fa..af92d3422c79 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -222,6 +222,17 @@ static struct kvm_cpuid_entry2 *kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcp
>  					     vcpu->arch.cpuid_nent);
>  }
>  
> +static void kvm_update_pv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
> +				int nent)
> +{
> +	struct kvm_cpuid_entry2 *best;
> +
> +	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
> +	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
> +		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
> +		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
> +}
> +
>  void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpuid_entry2 *best = kvm_find_kvm_cpuid_features(vcpu);
> @@ -280,11 +291,6 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
>  		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
>  		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>  
> -	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
> -	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
> -		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
> -		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
> -
>  	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
>  		best = cpuid_entry2_find(entries, nent, 0x1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
>  		if (best)
> @@ -402,6 +408,7 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
>  	int r;
>  
>  	__kvm_update_cpuid_runtime(vcpu, e2, nent);
> +	kvm_update_pv_cpuid(vcpu, e2, nent);

Hrm, this will silently conflict with the proposed per-vCPU controls[*].  Though
arguably that patch is buggy and "needs" to toggle PV_UNHALT when userspace
messes with HLT passthrough.  But that doesn't really make sense either because
no guest will react kindly to KVM_FEATURE_PV_UNHALT disappearing.

I really wish this code didn't exist, i.e. that KVM let/forced userspace deal
with correctly defining guest CPUID.

Kechen, is it feasible for your userspace to clear PV_UNHALT when it (might) use
the per-vCPU control?  I.e. can KVM do as this series proposes and update guest
CPUID only on KVM_SET_CPUID{2}?  Dropping the behavior for the per-VM control
is probably not an option as I gotta assume that'd break userspace, but I would
really like to avoid carrying that over to the per-vCPU control, which would get
quite messy and probably can't work anyways.

[*] https://lkml.kernel.org/r/20230121020738.2973-6-kechenl%40nvidia.com

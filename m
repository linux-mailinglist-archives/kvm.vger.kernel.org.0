Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A54F587E7A
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 16:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbiHBO5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 10:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235370AbiHBO5x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 10:57:53 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1DE1EEC9
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 07:57:52 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id w17-20020a17090a8a1100b001f326c73df6so13950981pjn.3
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 07:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=dBnuiKdu4WthPT4ZuUplx30eOhTTtqqaF6B2cSk/UyQ=;
        b=psEKrtShroDo+VkE5iTSlooVNyXfYmgSlA6KYgx76ni4xZuMbRh3wEg2PSd6WyqFcn
         1mVehE9UlGobBwL13y1cxMstd5t0XYI7SYRCPGZvH57qZ7rNeV7EbjwnIrWIsNGZoqh+
         Mqg9bYMC+pKjrwvjmpeWl51csWufsISG0LN+aozQwWbb3EkDNwu96V52ZaSQHZu7/D9h
         SbbW0ptH5HEpfaUCS8cEFPm5X59cfrec0WXIwSr0R0YW6GZ6Ynuns3/yIDP9H2lTjJY8
         EDqNu1eWqMtmmSwjJrfZdYFiZMN2+QXw+m1YEiN1t/yqJ/5FlGDeCAD5qj0TIgwd69WW
         VfRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=dBnuiKdu4WthPT4ZuUplx30eOhTTtqqaF6B2cSk/UyQ=;
        b=mmGH3kNVRBxufxUdxzXoCh/F4487rufQvvWwIfoesPBecXwwABX+9xVfykBV4USEvs
         MjpA1LUhJvGChaC8CTSTZfBdV2zgCLLWTBc+zPFt58Ft3Hg9zapau8HGiCi2qjKKioE5
         iNR2CfjwCb1JfDndA9kzzgP9teyiA6cOK10FVtS37ukWamkRtD2XHu3iRomTJHSIj3FR
         IOjQWa2AceDX/+N9EPVhcBdnGZNP3MA5wwr6uzqd7lhCdONHQ5BqjRM5602lwmOVcH/e
         8q2AsenD/0uAuMzVl92HBAYE4PR0/8byIgv/wUlL4V38Dbp74VrCV3isi9n5Lz0I5iSE
         9Kow==
X-Gm-Message-State: ACgBeo0rx1Duj3oCuhJJDqK7aOS/sFp888cQfRvOBxTVuFrcFItDnWGR
        HU2eJgw1qAr++fhJtNpkM11OlUtPWFHphA==
X-Google-Smtp-Source: AA6agR5RwrqfkmiyTfqXe9VG/f0YcO2GxWF4rOah1awuIVlUkHZyQF1ejfarhiK2g3EmaVhcQlgfqw==
X-Received: by 2002:a17:90b:164d:b0:1f0:31c1:9e88 with SMTP id il13-20020a17090b164d00b001f031c19e88mr25335859pjb.206.1659452271776;
        Tue, 02 Aug 2022 07:57:51 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n3-20020a170902d2c300b0016bdf2220desm5428299plc.263.2022.08.02.07.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 07:57:50 -0700 (PDT)
Date:   Tue, 2 Aug 2022 14:57:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 3/3] KVM: VMX: Adjust number of LBR records for
 PERF_CAPABILITIES at refresh
Message-ID: <Yuk7avLSXXmaufgm@google.com>
References: <20220727233424.2968356-1-seanjc@google.com>
 <20220727233424.2968356-4-seanjc@google.com>
 <dcc187d2-f55b-a5cd-0664-a6fc78b7966f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dcc187d2-f55b-a5cd-0664-a6fc78b7966f@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 02, 2022, Like Xu wrote:
> On 28/7/2022 7:34 am, Sean Christopherson wrote:
> > -bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
> > -{
> > -	struct x86_pmu_lbr *lbr = vcpu_to_lbr_records(vcpu);
> > -
> > -	return lbr->nr && (vcpu_get_perf_capabilities(vcpu) & PMU_CAP_LBR_FMT);
> > -}
> > -
> >   static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
> >   {
> >   	struct x86_pmu_lbr *records = vcpu_to_lbr_records(vcpu);
> > @@ -590,7 +583,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
> >   	bitmap_set(pmu->all_valid_pmc_idx,
> >   		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
> > -	if (cpuid_model_is_consistent(vcpu))
> > +	perf_capabilities = vcpu_get_perf_capabilities(vcpu);
> > +	if (cpuid_model_is_consistent(vcpu) &&
> > +	    (perf_capabilities & PMU_CAP_LBR_FMT))
> >   		x86_perf_get_lbr(&lbr_desc->records);
> 
> As one of evil source to add CPUID walk in the critical path:
> 
> The x86_perf_get_lbr() is one of the perf interfaces, KVM cannot always trust
> that the number of returned lbr_desc->records.nr is always > 0,  and if not,
> we have to tweak perf_capabilities inside KVM which violates user input again.
> 
> Do you have more inputs to address this issue ?

First, drop the unnecessary stub and return value from x86_perf_get_lbr().  KVM
selects PERF_EVENTS, so the stub and thus error path can't be hit.  I'll add
patches to the series to do this.

Second, check the number of perf LBRs in vmx_get_perf_capabilities() and advertise
PMU_CAP_LBR_FMT iff perf fully supports LBRs.

---
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 2 Aug 2022 07:45:33 -0700
Subject: [PATCH] KVM: VMX: Advertise PMU LBRs if and only if perf supports
 LBRs

Advertise LBR support to userspace via MSR_IA32_PERF_CAPABILITIES if and
only if perf fully supports LBRs.  Perf may disable LBRs (by zeroing the
number of LBRs) even on platforms the allegedly support LBRs, e.g. if
probing any LBR MSRs during setup fails.

Fixes: be635e34c284 ("KVM: vmx/pmu: Expose LBR_FMT in the MSR_IA32_PERF_CAPABILITIES")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/capabilities.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index c5e5dfef69c7..d2fdaf888d33 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -404,6 +404,7 @@ static inline bool vmx_pebs_supported(void)
 static inline u64 vmx_get_perf_capabilities(void)
 {
 	u64 perf_cap = PMU_CAP_FW_WRITES;
+	struct x86_pmu_lbr lbr;
 	u64 host_perf_cap = 0;

 	if (!enable_pmu)
@@ -412,7 +413,9 @@ static inline u64 vmx_get_perf_capabilities(void)
 	if (boot_cpu_has(X86_FEATURE_PDCM))
 		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);

-	perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
+	x86_perf_get_lbr(&lbr);
+	if (lbr.nr)
+		perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;

 	if (vmx_pebs_supported()) {
 		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;

base-commit: 1f011a0755c2135b035cdee3b54e3adc426ec95c
--


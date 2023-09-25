Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 923F87ADB2E
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 17:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjIYPSL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 11:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232719AbjIYPSK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 11:18:10 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330DA11B
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 08:18:03 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c61aafab45so24296555ad.3
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 08:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695655082; x=1696259882; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5rKaY95Owlsxg41SeH4L0kjYxBc5VrcPYRfBkmtEvRA=;
        b=gNf2Oj0eQSng3iAwlVAzS6GsBgqZYw+YA5j2Xr0z0m4vQL6u2mL17bb8mXDBesiIoc
         O/D6KTOBjNgH05hzU19YNX6Q0qVVTzzNf3IhSh64nuo1kvEH9HGvXYkCNBvIGpx7QSRD
         QBajdg/1+8OWd2TQAxJfkCJFgkspJMBq/BJF9bcYNwLIYA+00D5H0/AwwH2wkOY5YXAj
         PM+3bxhuosSnaIfU0Ch3yc1jeEdR64B5WCydukb3gfUxV0sO0tKVgLz0/KOnYCDIsUFL
         P6gzGMdHwwk7JZCdWUFWX2+OnbIxiWPmEiruv0QqOGN+X5Dl5cyT+K/of5Dtx17CcwVt
         caBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695655082; x=1696259882;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5rKaY95Owlsxg41SeH4L0kjYxBc5VrcPYRfBkmtEvRA=;
        b=vjD97uC0GiYkeYzjkTKeIf9QlmRCaFX5v/6kFlvi6ETvDMn3M6AZTsukjdCn67ASCP
         4XfGHGq3YW9SERz78G9dMmhjmExr5qRgdGW7ZFGZa6sjcs5dCGZR0JheXbPy8NPjhNeR
         HLg1YplZFdL+Vhcnuw76TNzVLis+MQxjQvErmf0aS4rjrku3etq55l1A4d8aMqDBw2G4
         7e38m02HQTxTNrVPycBTA2pATEuf/49WMfwQDdVUS7A0qda6yjKcxc+McA/sAaN8yi3s
         qw0JF1UbVaRh8O6SkYqwjeUDjRG1CBq88aRk0BG7qVPhZguA6f71OfnODW9QAyrSP/1A
         BftQ==
X-Gm-Message-State: AOJu0Yx98B4YrKQOez3W4JOCZP10FJxxZzgTDS3AE+k3An3xxnV+xNhl
        LCwEXGVJIQJFxv61VPvqZ8EI3VH1CgM=
X-Google-Smtp-Source: AGHT+IEpSuLxns1zW49+7WfQ9DVzb4gkEUn0iiTlI4VNGZbATiaszAUr6UmRitBbKCLPHJQvVabd6SLL7PU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:181:b0:1b8:3c5e:2289 with SMTP id
 z1-20020a170903018100b001b83c5e2289mr63915plg.2.1695655082556; Mon, 25 Sep
 2023 08:18:02 -0700 (PDT)
Date:   Mon, 25 Sep 2023 08:18:01 -0700
In-Reply-To: <20230923102019.29444-1-phil@philjordan.eu>
Mime-Version: 1.0
References: <20230923102019.29444-1-phil@philjordan.eu>
Message-ID: <ZRGkqY+2QQgt2cVq@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86/apic: Gates test_pv_ipi on KVM cpuid,
 not test device
From:   Sean Christopherson <seanjc@google.com>
To:     Phil Dennis-Jordan <phil@philjordan.eu>
Cc:     kvm@vger.kernel.org, lists@philjordan.eu
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 23, 2023, Phil Dennis-Jordan wrote:
> This changes the test for the KVM IPI hypercall API to be skipped if the
> relevant cpuid feature bit is not set or if the KVM cpuid leaf is
> missing, rather than the presence of the test device. The latter is an
> unreliable inference on non-KVM platforms.
> 
> It also adds a skip report when these tests are skipped.
> 
> Signed-off-by: Phil Dennis-Jordan <phil@philjordan.eu>
> ---
>  lib/x86/processor.h | 19 +++++++++++++++++++
>  x86/apic.c          |  9 ++++++++-
>  2 files changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 44f4fd1e..9a4c0d26 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -284,6 +284,13 @@ static inline bool is_intel(void)
>  #define X86_FEATURE_VNMI		(CPUID(0x8000000A, 0, EDX, 25))
>  #define	X86_FEATURE_AMD_PMU_V2		(CPUID(0x80000022, 0, EAX, 0))
>  
> +/*
> + * Hypervisor specific leaves (KVM, ...)
> + * See:
> + * https://kernel.org/doc/html/latest/virt/kvm/x86/cpuid.html
> + */
> +#define	X86_KVM_FEATURE_PV_SEND_IPI  (CPUID(0x40000001, 0, EAX, 11))

We could actually define this using the uapi headers, then there's no need to
reference the kernel docs, e.g.

#define		X86_FEATURE_KVM_PV_SEND_IPI (CPUID(KVM_CPUID_FEATURES, 0, EAX, KVM_FEATURE_PV_SEND_IPI)

> +
>  static inline bool this_cpu_has(u64 feature)
>  {
>  	u32 input_eax = feature >> 32;
> @@ -299,6 +306,18 @@ static inline bool this_cpu_has(u64 feature)
>  	return ((*(tmp + (output_reg % 32))) & (1 << bit));
>  }
>  
> +static inline bool kvm_feature_flags_supported(void)
> +{
> +	struct cpuid c;
> +
> +	c = cpuid_indexed(0x40000000, 0);
> +	return
> +		c.b == 0x4b4d564b
> +		&& c.c == 0x564b4d56
> +		&& c.d == 0x4d

I would much prefer to provide something similar to the kernel's hypervisor_cpuid_base(),
and then use KVM_SIGNATURE to match the signature.  And assert that KVM is placed
at its default base for tests that require KVM paravirt features, i.e. disallow
relocating KVM to e.g. 0x40000100 to make room for Hyper-V.

Something like this (completely untested)

static inline u32 get_hypervisor_cpuid_base(const char *sig)
{
	u32 base, signature[3];

	if (!this_cpu_has(X86_FEATURE_HYPERVISOR))
		return 0;

	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
		cpuid(base, &eax, &signature[0], &signature[1], &signature[2]);

		if (!memcmp(sig, signature, 12))
			return base;
	}

	return 0;
}

static inline bool is_hypervisor_kvm(void)
{
	u32 base = get_hypervisor_cpuid_base(KVM_SIGNATURE);

	if (!base)
		return 0;

	/*
	 * Require that KVM be placed at its default base so that macros can be
	 * used to query individual KVM feature bits.
	 */
	TEST_ASSERT(base == KVM_CPUID_SIGNATURE);
	return true;
}

> +		&& (c.a >= 0x40000001 || c.a == 0);

Why allow 0?  Though I think we probably forego this check entirely.

> +}
> +
>  struct far_pointer32 {
>  	u32 offset;
>  	u16 selector;
> diff --git a/x86/apic.c b/x86/apic.c
> index dd7e7834..525e08fd 100644
> --- a/x86/apic.c
> +++ b/x86/apic.c
> @@ -30,6 +30,11 @@ static bool is_xapic_enabled(void)
>  	return (rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == APIC_EN;
>  }
>  
> +static bool is_kvm_ipi_hypercall_supported(void)
> +{
> +	return kvm_feature_flags_supported() && this_cpu_has(X86_KVM_FEATURE_PV_SEND_IPI);
> +}
> +
>  static void test_lapic_existence(void)
>  {
>  	u8 version;
> @@ -658,8 +663,10 @@ static void test_pv_ipi(void)
>  	int ret;
>  	unsigned long a0 = 0xFFFFFFFF, a1 = 0, a2 = 0xFFFFFFFF, a3 = 0x0;
>  
> -	if (!test_device_enabled())
> +	if (!is_kvm_ipi_hypercall_supported()) {

I would rather open code the two independent checks, e.g.

	if (!is_hypervisor_kvm() || !this_cpu_has(X86_FEATURE_KVM_PV_SEND_IPI))

Or alternatively, provide a generic helper in processor.h to handle the hypervisor
check, e.g.

  static inline this_cpu_has_kvm_feature(...)

Though if we go that route it probably makes sense to play nice with relocating
the base since it would be quite easy to do so.

> +		report_skip("PV IPIs testing (No KVM IPI hypercall flag in cpuid)");
>  		return;
> +	}
>  
>  	asm volatile("vmcall" : "=a"(ret) :"a"(KVM_HC_SEND_IPI), "b"(a0), "c"(a1), "d"(a2), "S"(a3));
>  	report(!ret, "PV IPIs testing");
> -- 
> 2.36.1
> 

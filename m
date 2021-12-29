Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD2D480F7A
	for <lists+kvm@lfdr.de>; Wed, 29 Dec 2021 05:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbhL2EGk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Dec 2021 23:06:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233830AbhL2EGj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Dec 2021 23:06:39 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C08DC061574;
        Tue, 28 Dec 2021 20:06:39 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id i6so8951246pla.0;
        Tue, 28 Dec 2021 20:06:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=ebtivvfuu/iVVYSM7ONpSA//vhmPAPcnb83p5lo/lJc=;
        b=SWhjI98SHfltqdgiWyow7QI72KGG2wVuLjcEtepP+op74FYrFXb1EPC5/S/K+c0P95
         KV4VpfTnYbOdtiW5jcOCBZJqYM9efaHbBQgkstliTiH1SiJVz6TSIa1pBhh+9ulFkiAL
         kpid1wb7s3xL4w/YDmF9C/JSptbzvpGXPCc6ShSRO6vDgHDbJfFqu6EapzTreIsCP7AI
         zJ0qQxQZEMp5X4W60aRmp4yKhX/KHuUuuVU60FreHbNwCkj36awOBQXHWx0g5cmYFYy5
         f6Hhyli3brhYtVBUorvChS7hqkuPe0E0xbclbIKK+SyMDRKDMT7O9Sc8rzIyLdt/ETuF
         dQiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=ebtivvfuu/iVVYSM7ONpSA//vhmPAPcnb83p5lo/lJc=;
        b=GGrr00c5/Cn95Hdthw6g2n7wyWlvF45LsCRiFTDxXE6Tx1WuczNnxXmYa0e64l8qy7
         ZoMxrNO1lhCLIqF8vjGgyUq+yjbvYoJqsFsGVViLsZW/QSOItyXevYPosi4et3Qlb72Y
         8PrjcZe7ex6B7/3AJvQnDqJpvOSIsxpBM8pIClkrLf3cULaUBiAyLIYqwGFECXv0Wn63
         sJ634McaA9VdCTX35DBHYu0mOUvpM+4/OE2ZPFHIpKwTyW2zyI9OpDsyv1gJvYfsXWt9
         d3jIqhKSIfyQlvEMY349/9nSGNDbYrkmIijykrLElEdkWoCi9I+Z6wy51Y9Jud4LIH52
         UpEQ==
X-Gm-Message-State: AOAM532+MVILiCyhwALDXzxNlOqOKSIEYPdzU+b/p1u72ytuh+bc7zjy
        fRCUXkkJfqkfCcGYxoAbDdQ=
X-Google-Smtp-Source: ABdhPJxI+lHyiN4W4B4UkhP6Y1pp+RS1AlU1CURTT2WBjHLXu4TT45MCNJnNiIOc0/u/zonFvosJjA==
X-Received: by 2002:a17:902:e804:b0:149:132e:a23e with SMTP id u4-20020a170902e80400b00149132ea23emr24030931plg.118.1640750798216;
        Tue, 28 Dec 2021 20:06:38 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id c7sm23643104pjs.17.2021.12.28.20.06.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Dec 2021 20:06:37 -0800 (PST)
Message-ID: <d3a9a73f-cdc2-bce0-55e6-e4c9f5c237de@gmail.com>
Date:   Wed, 29 Dec 2021 12:06:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <likexu@tencent.com>,
        Dongli Cao <caodongli@kingsoft.com>,
        Li RongQing <lirongqing@baidu.com>
References: <20211222133428.59977-1-likexu@tencent.com>
 <CALMp9eTgO4XuNHwuxWahZc7jQqZ10DchW8xXvecBH2ovGPLU9g@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH v2] KVM: X86: Emulate APERF/MPERF to report actual vCPU
 frequency
In-Reply-To: <CALMp9eTgO4XuNHwuxWahZc7jQqZ10DchW8xXvecBH2ovGPLU9g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jim,

Thanks for your detailed comments.

On 29/12/2021 9:11 am, Jim Mattson wrote:
> On Wed, Dec 22, 2021 at 5:34 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> From: Like Xu <likexu@tencent.com>
>>
>> The aperf/mperf are used to report current CPU frequency after 7d5905dc14a.
>> But guest kernel always reports a fixed vCPU frequency in the /proc/cpuinfo,
>> which may confuse users especially when turbo is enabled on the host or
>> when the vCPU has a noisy high power consumption neighbour task.
>>
>> Most guests such as Linux will only read accesses to AMPERF msrs, where
>> we can passthrough registers to the vcpu as the fast-path (a performance win)
>> and once any write accesses are trapped, the emulation will be switched to
>> slow-path, which emulates guest APERF/MPERF values based on host values.
>> In emulation mode, the returned MPERF msr value will be scaled according
>> to the TSCRatio value.
>>
>> As a minimum effort, KVM exposes the AMPERF feature when the host TSC
>> has CONSTANT and NONSTOP features, to avoid the need for more code
>> to cover various coner cases coming from host power throttling transitions.
>>
>> The slow path code reveals an opportunity to refactor update_vcpu_amperf()
>> and get_host_amperf() to be more flexible and generic, to cover more
>> power-related msrs.
>>
>> Requested-by: Dongli Cao <caodongli@kingsoft.com>
>> Requested-by: Li RongQing <lirongqing@baidu.com>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>> v1 -> v2 Changelog:
>> - Use MSR_TYPE_R to passthrough as a fast path;
>> - Use [svm|vmx]_set_msr for emulation as a slow path;
>> - Interact MPERF with TSC scaling (Jim Mattson);
>> - Drop bool hw_coord_fb_cap with cpuid check;
>> - Add TSC CONSTANT and NONSTOP cpuid check;
>> - Duplicate static_call(kvm_x86_run) to make the branch predictor happier;
>>
>> Previous:
>> https://lore.kernel.org/kvm/20200623063530.81917-1-like.xu@linux.intel.com/
>>
>>   arch/x86/include/asm/kvm_host.h | 12 +++++
>>   arch/x86/kvm/cpuid.c            |  3 ++
>>   arch/x86/kvm/cpuid.h            | 22 +++++++++
>>   arch/x86/kvm/svm/svm.c          | 15 ++++++
>>   arch/x86/kvm/svm/svm.h          |  2 +-
>>   arch/x86/kvm/vmx/vmx.c          | 18 ++++++-
>>   arch/x86/kvm/x86.c              | 85 ++++++++++++++++++++++++++++++++-
>>   7 files changed, 153 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index ce622b89c5d8..1cad3992439e 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -39,6 +39,8 @@
>>
>>   #define KVM_MAX_VCPUS 1024
>>
>> +#define KVM_MAX_NUM_HWP_MSR 2
>> +
>>   /*
>>    * In x86, the VCPU ID corresponds to the APIC ID, and APIC IDs
>>    * might be larger than the actual number of VCPUs because the
>> @@ -562,6 +564,14 @@ struct kvm_vcpu_hv_stimer {
>>          bool msg_pending;
>>   };
>>
>> +/* vCPU thermal and power context */
>> +struct kvm_vcpu_hwp {
>> +       bool fast_path;
>> +       /* [0], APERF msr, increases with the current/actual frequency */
>> +       /* [1], MPERF msr, increases with a fixed frequency */
> 
> According to the SDM, volume 3, section 18.7.2,
> * The TSC, IA32_MPERF, and IA32_FIXED_CTR2 operate at close to the
> maximum non-turbo frequency, which is equal to the product of scalable
> bus frequency and maximum non-turbo ratio.

For AMD, it will be the P0 frequency.

> 
> It's important to note that IA32_MPERF operates at close to the same
> frequency of the TSC. If that were not the case, your comment
> regarding IA32_APERF would be incorrect.

Yes, how does this look:

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f8f978bc9ec3..d422bf8669ca 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -568,7 +568,7 @@ struct kvm_vcpu_hv_stimer {
  struct kvm_vcpu_hwp {
  	bool fast_path;
  	/* [0], APERF msr, increases with the current/actual frequency */
-	/* [1], MPERF msr, increases with a fixed frequency */
+	/* [1], MPERF msr, increases at the same fixed frequency as the TSC */
  	u64 msrs[KVM_MAX_NUM_HWP_MSR];
  };

> 
> For example, suppose that the TSC frequency were 2.0 GHz, the
> current/actual frequency were 2.2 GHz, and the IA32_MPERF frequency
> were 133 MHz. In that case, the IA32_APERF MSR would increase at 146.3
> MHz.
> 

>> +       u64 msrs[KVM_MAX_NUM_HWP_MSR];
>> +};
>> +
>>   /* Hyper-V synthetic interrupt controller (SynIC)*/
>>   struct kvm_vcpu_hv_synic {
>>          u64 version;
>> @@ -887,6 +897,8 @@ struct kvm_vcpu_arch {
>>          /* AMD MSRC001_0015 Hardware Configuration */
>>          u64 msr_hwcr;
>>
>> +       struct kvm_vcpu_hwp hwp;
>> +
>>          /* pv related cpuid info */
>>          struct {
>>                  /*
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 0b920e12bb6d..e20e5e8c2b3a 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -739,6 +739,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>>                  entry->eax = 0x4; /* allow ARAT */
>>                  entry->ebx = 0;
>>                  entry->ecx = 0;
>> +               /* allow aperf/mperf to report the true vCPU frequency. */
>> +               if (kvm_cpu_cap_has_amperf())
>> +                       entry->ecx |=  (1 << 0);
>>                  entry->edx = 0;
>>                  break;
>>          /* function 7 has additional index. */
>> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
>> index c99edfff7f82..741949b407b7 100644
>> --- a/arch/x86/kvm/cpuid.h
>> +++ b/arch/x86/kvm/cpuid.h
>> @@ -154,6 +154,28 @@ static inline int guest_cpuid_stepping(struct kvm_vcpu *vcpu)
>>          return x86_stepping(best->eax);
>>   }
>>
>> +static inline bool kvm_cpu_cap_has_amperf(void)
>> +{
>> +       return boot_cpu_has(X86_FEATURE_APERFMPERF) &&
>> +               boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
>> +               boot_cpu_has(X86_FEATURE_NONSTOP_TSC);
>> +}
>> +
>> +static inline bool guest_support_amperf(struct kvm_vcpu *vcpu)
>> +{
>> +       struct kvm_cpuid_entry2 *best;
>> +
>> +       if (!kvm_cpu_cap_has_amperf())
>> +               return false;
>> +
>> +       best = kvm_find_cpuid_entry(vcpu, 0x6, 0);
>> +       if (!best || !(best->ecx & 0x1))
>> +               return false;
>> +
>> +       best = kvm_find_cpuid_entry(vcpu, 0x80000007, 0);
>> +       return best && (best->edx & (1 << 8));
> Nit: Use BIT().

Applied.

>> +}
>> +
>>   static inline bool guest_has_spec_ctrl_msr(struct kvm_vcpu *vcpu)
>>   {
>>          return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 5557867dcb69..2873c7f132bd 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -114,6 +114,8 @@ static const struct svm_direct_access_msrs {
>>          { .index = MSR_EFER,                            .always = false },
>>          { .index = MSR_IA32_CR_PAT,                     .always = false },
>>          { .index = MSR_AMD64_SEV_ES_GHCB,               .always = true  },
>> +       { .index = MSR_IA32_MPERF,                      .always = false },
>> +       { .index = MSR_IA32_APERF,                      .always = false },
>>          { .index = MSR_INVALID,                         .always = false },
>>   };
>>
>> @@ -1218,6 +1220,12 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
>>                  /* No need to intercept these MSRs */
>>                  set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
>>                  set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
>> +
>> +               if (guest_support_amperf(vcpu)) {
>> +                       set_msr_interception(vcpu, svm->msrpm, MSR_IA32_MPERF, 1, 0);
>> +                       set_msr_interception(vcpu, svm->msrpm, MSR_IA32_APERF, 1, 0);
>> +                       vcpu->arch.hwp.fast_path = true;
>> +               }
>>          }
>>   }
>>
>> @@ -3078,6 +3086,13 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>>                  svm->msr_decfg = data;
>>                  break;
>>          }
>> +       case MSR_IA32_APERF:
>> +       case MSR_IA32_MPERF:
>> +               if (vcpu->arch.hwp.fast_path) {
>> +                       set_msr_interception(vcpu, svm->msrpm, MSR_IA32_MPERF, 0, 0);
>> +                       set_msr_interception(vcpu, svm->msrpm, MSR_IA32_APERF, 0, 0);
>> +               }
>> +               return kvm_set_msr_common(vcpu, msr);
>>          default:
>>                  return kvm_set_msr_common(vcpu, msr);
>>          }
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index 9f153c59f2c8..ad4659811620 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -27,7 +27,7 @@
>>   #define        IOPM_SIZE PAGE_SIZE * 3
>>   #define        MSRPM_SIZE PAGE_SIZE * 2
>>
>> -#define MAX_DIRECT_ACCESS_MSRS 20
>> +#define MAX_DIRECT_ACCESS_MSRS 22
>>   #define MSRPM_OFFSETS  16
>>   extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>>   extern bool npt_enabled;
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 1d53b8144f83..8998042107d2 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -576,6 +576,9 @@ static bool is_valid_passthrough_msr(u32 msr)
>>          case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 8:
>>          case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
>>                  /* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
>> +       case MSR_IA32_MPERF:
>> +       case MSR_IA32_APERF:
>> +               /* AMPERF MSRs. These are passthrough when all access is read-only. */
> 
> Even if all accesses are read-only, these MSRs cannot be pass-through
> when the 'Use TSC scaling' VM-execution control is set and the TSC
> multiplier is anything other than 1.

If all accesses are read-only, rdmsr will not be trapped and in that case:

The value read is scaled by the TSCRatio value (MSR C000_0104h) for
guest reads, but the underlying counters are not affected. Reads in host
mode or writes to MPERF are not affected. [AMD APM 17.3.2]

> 
> Suppose, for example, that the vCPU has a TSC frequency of 2.2 GHz,
> but it is running on a host with a TSC frequency of 2.0 GHz. The
> effective IA32_MPERF frequency should be the same as the vCPU TSC
> frequency (scaled by the TSC multiplier), rather than the host
> IA32_MPERF frequency.

I guess that Intel's implementation will also imply the effect of
the TSC multiplier for guest reads. Please let me know if I'm wrong.

> 
>>                  return true;
>>          }
>>
>> @@ -2224,7 +2227,14 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>                  }
>>                  ret = kvm_set_msr_common(vcpu, msr_info);
>>                  break;
>> -
>> +       case MSR_IA32_APERF:
>> +       case MSR_IA32_MPERF:
>> +               if (vcpu->arch.hwp.fast_path) {
>> +                       vmx_set_intercept_for_msr(vcpu, MSR_IA32_APERF, MSR_TYPE_RW, true);
>> +                       vmx_set_intercept_for_msr(vcpu, MSR_IA32_MPERF, MSR_TYPE_RW, true);
>> +               }
>> +               ret = kvm_set_msr_common(vcpu, msr_info);
>> +               break;
>>          default:
>>          find_uret_msr:
>>                  msr = vmx_find_uret_msr(vmx, msr_index);
>> @@ -6928,6 +6938,12 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>>                  vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
>>          }
>>
>> +       if (guest_support_amperf(vcpu)) {
>> +               vmx_disable_intercept_for_msr(vcpu, MSR_IA32_MPERF, MSR_TYPE_R);
>> +               vmx_disable_intercept_for_msr(vcpu, MSR_IA32_APERF, MSR_TYPE_R);
>> +               vcpu->arch.hwp.fast_path = true;
>> +       }
>> +
>>          vmx->loaded_vmcs = &vmx->vmcs01;
>>
>>          if (cpu_need_virtualize_apic_accesses(vcpu)) {
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 42bde45a1bc2..7a6355815493 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1376,6 +1376,8 @@ static const u32 msrs_to_save_all[] = {
>>          MSR_F15H_PERF_CTL3, MSR_F15H_PERF_CTL4, MSR_F15H_PERF_CTL5,
>>          MSR_F15H_PERF_CTR0, MSR_F15H_PERF_CTR1, MSR_F15H_PERF_CTR2,
>>          MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
>> +
>> +       MSR_IA32_APERF, MSR_IA32_MPERF,
>>   };
>>
>>   static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
>> @@ -3685,6 +3687,16 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>                          return 1;
>>                  vcpu->arch.msr_misc_features_enables = data;
>>                  break;
>> +       case MSR_IA32_APERF:
>> +       case MSR_IA32_MPERF:
>> +               /* Ignore meaningless value overrides from user space.*/
>> +               if (msr_info->host_initiated)
>> +                       return 0;
> 
> Without these meaningless overrides from userspace, how do we ensure
> that the guest derives the correct IA32_APERF/IA32_MPERF ratio for a

The guest cares about the ratio of the two deltas rather than APERF/MPERF ratio.

Effective frequency = {(APERF − APERF_INIT) / (MPERF − MPERF_INIT)} * P0 frequency

> set of measurements that span a live migration? For that matter, how
> do we ensure that the deltas are even positive?

Once we allow the user space to restore AMPERF msr values different from
the host values, the slow path will be walked and we try to avoid this kind
of case due to overhead, whatever for live migration or pCPU migration.

> 
> For example, suppose that the VM has migrated from a host with an
> IA32_MPERF value of 0x0000123456789abc to a host with an IA32_MPERF
> value of 0x000000123456789a. If the guest sampled IA32_MPERF before
> and after live migration, it would see the counter go backwards, which

Yes, it will happen since without more hints from KVM, the user space
can't be sure if the save/restore time is in the sample period of AMPERF.
And even worse, guest could manipulate reading order of the AMPERF.

The proposal is to *let it happen* because it causes no harm, in the meantime,
what the guest really cares about is the deltas ratio, not the accuracy of
individual msr values, and if the result in this sample is ridiculous, the guest
should go and pick the result from the next sample.

Maybe we could add fault tolerance for AMPERF in the guest, something like
a retry mechnism or just discarding extreme values to follow statistical methods.

The good news is the robustness like Linux guest on this issue is appreciated.
(9a6c2c3c7a73ce315c57c1b002caad6fcc858d0f and more stuff)

Considering that the sampling period of amperf is relatively frequent compared
with the workload runtime and it statistically reports the right vCPU frequency,
do you think this meaningless proposal is acceptable or practicable ?

> should not happen.
> 
>> +               if (!guest_support_amperf(vcpu))
>> +                       return 1;
>> +               vcpu->arch.hwp.msrs[MSR_IA32_APERF - msr] = data;
>> +               vcpu->arch.hwp.fast_path = false;
>> +               break;
>>          default:
>>                  if (kvm_pmu_is_valid_msr(vcpu, msr))
>>                          return kvm_pmu_set_msr(vcpu, msr_info);
>> @@ -4005,6 +4017,17 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>          case MSR_K7_HWCR:
>>                  msr_info->data = vcpu->arch.msr_hwcr;
>>                  break;
>> +       case MSR_IA32_APERF:
>> +       case MSR_IA32_MPERF: {
> ]> +               u64 value;
>> +
>> +               if (!msr_info->host_initiated && !guest_support_amperf(vcpu))
>> +                       return 1;
>> +               value = vcpu->arch.hwp.msrs[MSR_IA32_APERF - msr_info->index];
>> +               msr_info->data = (msr_info->index == MSR_IA32_APERF) ? value :
>> +                       kvm_scale_tsc(vcpu, value, vcpu->arch.tsc_scaling_ratio);
> 
> I think it makes more sense to perform the scaling before storing the
> IA32_MPERF value in vcpu->arch.hwp.msrs[].

Emm, do you really need to add more instruction cycles in the each call
of update_vcpu_amperf() in the critical path vcpu_enter_guest(), since the
calls to kvm_get_msr_commom() are relatively sparse.

Will we get a functional error if we defer the kvm_scale_tsc() operation ?

> 
>> +               break;
>> +       }
>>          default:
>>                  if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
>>                          return kvm_pmu_get_msr(vcpu, msr_info);
>> @@ -9688,6 +9711,53 @@ void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
>>   }
>>   EXPORT_SYMBOL_GPL(__kvm_request_immediate_exit);
>>
>> +static inline void get_host_amperf(u64 msrs[])
>> +{
>> +       rdmsrl(MSR_IA32_APERF, msrs[0]);
>> +       rdmsrl(MSR_IA32_MPERF, msrs[1]);
>> +}
>> +
>> +static inline u64 get_amperf_delta(u64 enter, u64 exit)
>> +{
>> +       if (likely(exit >= enter))
>> +               return exit - enter;
>> +
>> +       return ULONG_MAX - enter + exit;
>> +}
>> +
>> +static inline void update_vcpu_amperf(struct kvm_vcpu *vcpu, u64 adelta, u64 mdelta)
>> +{
>> +       u64 aperf_left, mperf_left, delta, tmp;
>> +
>> +       aperf_left = ULONG_MAX - vcpu->arch.hwp.msrs[0];
>> +       mperf_left = ULONG_MAX - vcpu->arch.hwp.msrs[1];
>> +
>> +       /* Fast path when neither MSR overflows */
>> +       if (adelta <= aperf_left && mdelta <= mperf_left) {
>> +               vcpu->arch.hwp.msrs[0] += adelta;
>> +               vcpu->arch.hwp.msrs[1] += mdelta;
>> +               return;
>> +       }
>> +
>> +       /* When either MSR overflows, both MSRs are reset to zero and continue to increment. */
>> +       delta = min(adelta, mdelta);
>> +       if (delta > aperf_left || delta > mperf_left) {
>> +               tmp = max(vcpu->arch.hwp.msrs[0], vcpu->arch.hwp.msrs[1]);
>> +               tmp = delta - (ULONG_MAX - tmp) - 1;
>> +               vcpu->arch.hwp.msrs[0] = tmp + adelta - delta;
>> +               vcpu->arch.hwp.msrs[1] = tmp + mdelta - delta;
>> +               return;
>> +       }
> 
> I don't believe that the math above is correct in the general case. It
> appears to assume that the counters are running at the same frequency.

Are you saying that if the guest counter is not considered to be running
at the same frequency as the host, we need to wrap mdelta with
kvm_scale_tsc() to accumulate the mdelta difference for a vmentry/exit ?

> The whole point of this exercise is that the counters do not always
> run at the same frequency.
> 
>> +
>> +       if (mdelta > adelta && mdelta > aperf_left) {
>> +               vcpu->arch.hwp.msrs[0] = 0;
>> +               vcpu->arch.hwp.msrs[1] = mdelta - mperf_left - 1;
>> +       } else {
>> +               vcpu->arch.hwp.msrs[0] = adelta - aperf_left - 1;
>> +               vcpu->arch.hwp.msrs[1] = 0;
>> +       }
> 
> I don't understand this code at all. It seems quite unlikely that you

The value of two msr's will affect the other when one overflows:

* When either MSR overflows, both MSRs are reset to zero and
continue to increment. [Intel SDM, CHAPTER 14, 14.2]

> are ever going to catch a wraparound at just the right point for one
> of the MSRs to be 0. Moreover, since the two counters are not counting
> the same thing, it doesn't seem likely that it would ever be correct
> to derive the guest's IA32_APERF value from IA32_MPERF or vice versa.
> 
>> +}
>> +
>>   /*
>>    * Returns 1 to let vcpu_run() continue the guest execution loop without
>>    * exiting to the userspace.  Otherwise, the value will be returned to the
>> @@ -9700,7 +9770,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>>                  dm_request_for_irq_injection(vcpu) &&
>>                  kvm_cpu_accept_dm_intr(vcpu);
>>          fastpath_t exit_fastpath;
>> -
>> +       u64 before[2], after[2];
>>          bool req_immediate_exit = false;
>>
>>          /* Forbid vmenter if vcpu dirty ring is soft-full */
>> @@ -9942,7 +10012,16 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>>                   */
>>                  WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm) != kvm_vcpu_apicv_active(vcpu));
>>
>> -               exit_fastpath = static_call(kvm_x86_run)(vcpu);
>> +               if (likely(vcpu->arch.hwp.fast_path)) {
>> +                       exit_fastpath = static_call(kvm_x86_run)(vcpu);
>> +               } else {
>> +                       get_host_amperf(before);
>> +                       exit_fastpath = static_call(kvm_x86_run)(vcpu);
>> +                       get_host_amperf(after);
>> +                       update_vcpu_amperf(vcpu, get_amperf_delta(before[0], after[0]),
>> +                                          get_amperf_delta(before[1], after[1]));
>> +               }
>> +
> The slow path is awfully expensive here. Shouldn't there also be an
> option to do none of this, if the guest doesn't advertise CPUID.06H:
> ECX[0]?

Yes, it looks pretty good to me and let me figure it out.

> 
>>                  if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
>>                          break;
>>
>> @@ -11138,6 +11217,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>                  vcpu->arch.xcr0 = XFEATURE_MASK_FP;
>>          }
>>
>> +       memset(vcpu->arch.hwp.msrs, 0, sizeof(vcpu->arch.hwp.msrs));
>> +
>>          /* All GPRs except RDX (handled below) are zeroed on RESET/INIT. */
>>          memset(vcpu->arch.regs, 0, sizeof(vcpu->arch.regs));
>>          kvm_register_mark_dirty(vcpu, VCPU_REGS_RSP);
>> --
>> 2.33.1
>>
> 

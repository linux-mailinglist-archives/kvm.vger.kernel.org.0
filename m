Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEAA7419FF
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 23:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbjF1VDg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 17:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbjF1VDa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 17:03:30 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76E31FF5
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 14:03:28 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-34570b2d069so9795ab.1
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 14:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687986208; x=1690578208;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d0cdu9U2U8ASHi6NJW0ECm1JdkHTOWLc1i/nUUY1BF0=;
        b=qALhyPAZRGyS03UfieGmldU5/tdTCQx1STLIWruvHOrdJLpxjqfEe7TD2Qpwd0x3Uy
         7wd46NnG2q+Z8T7BbodPA9sO72eYnQJVBXYdNJ4SCBSGSNSuofpCAXKSBeMIJAHZf0Wz
         n0RqTdu1V8lgBKGtPoUi8VIYcRW95y5JJYXR6/Rjvpt034uJxEoVGaDY1A9Vuc0iAnIN
         JfAvYJt4rENY5iNC4dYQIN3dH8KSA58NMxYI9BE2TFcg9CfWw76GyLJCdI7BJsLOBF7H
         XK8kznEWdQ3NF7T2z8/5WbaJoJUYmQBW4o8OdeCM1z3e3BMp4LGz/SY1qf6Ll4bIYDCd
         FJ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687986208; x=1690578208;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d0cdu9U2U8ASHi6NJW0ECm1JdkHTOWLc1i/nUUY1BF0=;
        b=QHmHrcRkLy/OmjtsU+TrDmPqZqYNO7wLRm+zwtWxmVHXvw6+PBir2JqgPlU2Nxm/aZ
         MBUy4Yoa2Mo5B457JcmcULH+bglfHWDy/0sdhsM0Pm1YggaDJ9y/Us/fJvwPyO3JcGYP
         ZBplluPLt2amX9Vwipgq9By3+I88561atY8bHOirBp47FsVkxoBW5SFoGNpJuqYz++pr
         ++XkPazHKiUB5A/wMeR92r9lFUj+c1AL7smtxrPDVYgZFzsbfoYGuZ3xMkbSMvCC0U1v
         fG27mch0OWPRlD6NqdNMwgWQNCljkEdOLvFhxZ2VJM3wa2VzsOl/d0hl38NT2cHw5yys
         nrGw==
X-Gm-Message-State: AC+VfDz4k/bLXafdbjkpTvm/PJGptv7x9teREBVlflTa/0HERo+piE+U
        qQz9gZIc1NCbI5K3Xg4vvyIIt6t+Rry0mfJLUDHQcw==
X-Google-Smtp-Source: ACHHUZ4VdSsK7Y7KlmfNfqd9ODzVU/nm7ybn2zKWiVMsQ6w53rrUFo7Doxn7k7I2d0+ytyV4iakOHwg3hgKY30HQNpw=
X-Received: by 2002:a05:6e02:1b82:b0:33d:ac65:f95e with SMTP id
 h2-20020a056e021b8200b0033dac65f95emr322693ili.12.1687986207843; Wed, 28 Jun
 2023 14:03:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230530134248.23998-1-cloudliang@tencent.com>
 <20230530134248.23998-4-cloudliang@tencent.com> <ZJybjcyiLQVkSHMC@google.com>
In-Reply-To: <ZJybjcyiLQVkSHMC@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 28 Jun 2023 14:03:13 -0700
Message-ID: <CALMp9eQmux6cip=a+FkLpfmMz2zMuMD6bec-zO2or5HQGZ7Hsw@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] KVM: selftests: Test Intel PMU architectural
 events on gp counters
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jinrong Liang <ljr.kernel@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 1:44=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, May 30, 2023, Jinrong Liang wrote:
> > +/* Guest payload for any performance counter counting */
> > +#define NUM_BRANCHES 10
> > +
> > +static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vc=
pu,
> > +                                               void *guest_code)
> > +{
> > +     struct kvm_vm *vm;
> > +
> > +     vm =3D vm_create_with_one_vcpu(vcpu, guest_code);
> > +     vm_init_descriptor_tables(vm);
> > +     vcpu_init_descriptor_tables(*vcpu);
> > +
> > +     return vm;
> > +}
> > +
> > +static uint64_t run_vcpu(struct kvm_vcpu *vcpu, uint64_t *ucall_arg)
> > +{
> > +     struct ucall uc;
> > +
> > +     vcpu_run(vcpu);
> > +     switch (get_ucall(vcpu, &uc)) {
> > +     case UCALL_SYNC:
> > +             *ucall_arg =3D uc.args[1];
> > +             break;
> > +     case UCALL_DONE:
> > +             break;
> > +     default:
> > +             TEST_ASSERT(false, "Unexpected exit: %s",
> > +                         exit_reason_str(vcpu->run->exit_reason));
>
> TEST_FAIL()
>
> > +     }
> > +     return uc.cmd;
> > +}
> > +
> > +static void intel_guest_run_arch_event(uint8_t version, uint8_t max_gp=
_num,
>
> Unless I'm mistaken, this isn't specific to arch events.  And with a bit =
of
> massaging, it doesn't need to be Intel specific.  Typically we try to avo=
id
> speculatively creating infrastructure, but in this case we *know* AMD has=
 vPMU
> support, and we *know* from KVM-Unit-Tests that accounting for the differ=
ences
> between MSRs on Intel vs. AMD is doable, so we should write code with an =
eye
> toward supporting both AMD and Intel.
>
> And then we can avoid having to prefix so many functions with "intel", e.=
g. this
> can be something like
>
>   static void guest_measure_loop()
>
> or whatever.
>
> > +                                    uint32_t ctr_base_msr, uint64_t ev=
t_code)
> > +{
> > +     uint32_t global_msr =3D MSR_CORE_PERF_GLOBAL_CTRL;
> > +     unsigned int i;
> > +
> > +     for (i =3D 0; i < max_gp_num; i++) {
> > +             wrmsr(ctr_base_msr + i, 0);
> > +             wrmsr(MSR_P6_EVNTSEL0 + i, EVENTSEL_OS | EVENTSEL_EN | ev=
t_code);
> > +             if (version > 1)
> > +                     wrmsr(global_msr, BIT_ULL(i));
> > +
> > +             __asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES})=
);
> > +
> > +             if (version > 1)
> > +                     wrmsr(global_msr, 0);
> > +
> > +             GUEST_SYNC(_rdpmc(i));
> > +     }
> > +
> > +     GUEST_DONE();
> > +}
> > +
> > +static void test_arch_events_cpuid(struct kvm_vcpu *vcpu, uint8_t evt_=
vector,
>
> "vector" is confusing, as "vector" usually refers to a vector number, e.g=
. for
> IRQs and exceptions.  This is the _length_ of a so called vector.  I vote=
 to ignore
> the SDM's use of "vector" in this case and instead call it something like
> arch_events_bitmap_size.  And then arch_events_unavailable_mask?
>
> > +                                uint8_t unavl_mask, uint8_t idx)
> > +{
> > +     struct kvm_cpuid_entry2 *entry;
> > +     uint32_t ctr_msr =3D MSR_IA32_PERFCTR0;
> > +     bool is_supported;
> > +     uint64_t counter_val =3D 0;
> > +
> > +     entry =3D vcpu_get_cpuid_entry(vcpu, 0xa);
> > +     entry->eax =3D (entry->eax & ~EVT_LEN_MASK) |
> > +             (evt_vector << EVT_LEN_OFS_BIT);
>
> EVT_LEN_OFS_BIT can be a KVM_x86_PROPERTY.  And please also add a helper =
to set
> properties, the whole point of the FEATURE and PROPERTY frameworks is to =
avoid
> open coding CPUID manipulations.  E.g.
>
> static inline void vcpu_set_cpuid_property(struct kvm_vcpu *vcpu,
>                                            struct kvm_x86_cpu_property pr=
operty,
>                                            uint32_t value)
> {
>         ...
> }
>
> > +     entry->ebx =3D (entry->ebx & ~EVENTS_MASK) | unavl_mask;
> > +     vcpu_set_cpuid(vcpu);
> > +
> > +     if (vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_W=
RITES)
> > +             ctr_msr =3D MSR_IA32_PMC0;
>
> This can be done in the guest, no?
>
> > +
> > +     /* Arch event x is supported if EBX[x]=3D0 && EAX[31:24]>x */
> > +     is_supported =3D !(entry->ebx & BIT_ULL(idx)) &&
> > +             (((entry->eax & EVT_LEN_MASK) >> EVT_LEN_OFS_BIT) > idx);
>
> Please add a helper for this.
>
> > +
> > +     vcpu_args_set(vcpu, 4, X86_INTEL_PMU_VERSION, X86_INTEL_MAX_GP_CT=
R_NUM,
> > +                   ctr_msr, arch_events[idx]);
> > +
> > +     while (run_vcpu(vcpu, &counter_val) !=3D UCALL_DONE)
> > +             TEST_ASSERT(is_supported =3D=3D !!counter_val,
> > +                         "Unavailable arch event is counting.");
> > +}
> > +
> > +static void intel_check_arch_event_is_unavl(uint8_t idx)
> > +{
> > +     uint8_t eax_evt_vec, ebx_unavl_mask, i, j;
> > +     struct kvm_vcpu *vcpu;
> > +     struct kvm_vm *vm;
> > +
> > +     /*
> > +      * A brute force iteration of all combinations of values is likel=
y to
> > +      * exhaust the limit of the single-threaded thread fd nums, so it=
's
> > +      * tested here by iterating through all valid values on a single =
bit.
> > +      */
> > +     for (i =3D 0; i < ARRAY_SIZE(arch_events); i++) {
> > +             eax_evt_vec =3D BIT_ULL(i);
> > +             for (j =3D 0; j < ARRAY_SIZE(arch_events); j++) {
> > +                     ebx_unavl_mask =3D BIT_ULL(j);
> > +                     vm =3D pmu_vm_create_with_one_vcpu(&vcpu,
> > +                                                      intel_guest_run_=
arch_event);
> > +                     test_arch_events_cpuid(vcpu, eax_evt_vec,
> > +                                            ebx_unavl_mask, idx);
> > +
> > +                     kvm_vm_free(vm);
> > +             }
> > +     }
> > +}
> > +
> > +static void intel_test_arch_events(void)
> > +{
> > +     uint8_t idx;
> > +
> > +     for (idx =3D 0; idx < ARRAY_SIZE(arch_events); idx++) {
> > +             /*
> > +              * Given the stability of performance event recurrence,
> > +              * only these arch events are currently being tested:
> > +              *
> > +              * - Core cycle event (idx =3D 0)
> > +              * - Instruction retired event (idx =3D 1)
> > +              * - Reference cycles event (idx =3D 2)
> > +              * - Branch instruction retired event (idx =3D 5)
> > +              *
> > +              * Note that reference cycles is one event that actually =
cannot
> > +              * be successfully virtualized.
> > +              */

Actually, there is no reason that reference cycles can't be
successfully virtualized. It just can't be done with the current vPMU
infrastructure.

> > +             if (idx > 2 && idx !=3D 5)
>
> As request in a previous patch, use enums, then the need to document the =
magic
> numbers goes away.
>
> > +                     continue;
> > +
> > +             intel_check_arch_event_is_unavl(idx);
> > +     }
> > +}
> > +
> > +static void intel_test_pmu_cpuid(void)
> > +{
> > +     intel_test_arch_events();
>
> Either put the Intel-specific TEST_REQUIRE()s in here, or open code the c=
alls.
> Adding a helper and then splitting code across the helper and its sole ca=
ller is
> unnecessary.
>
> > +}
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +     TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
> > +
> > +     if (host_cpu_is_intel) {
>
> Presumably AMD will be supported at some point, but until then, this need=
s to be
>
>         TEST_REQUIRE(host_cpu_is_intel);
>
> > +             TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
> > +             TEST_REQUIRE(X86_INTEL_PMU_VERSION > 0);
> > +             TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
> > +
> > +             intel_test_pmu_cpuid();
> > +     }
> > +
> > +     return 0;
> > +}
> > --
> > 2.31.1
> >

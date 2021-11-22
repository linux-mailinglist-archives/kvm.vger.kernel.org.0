Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69D045900E
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 15:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235099AbhKVOVF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 09:21:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43581 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232494AbhKVOVA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Nov 2021 09:21:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637590673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b8j4H1c+TO9iY8wgTRJm+897eYK163M/O3MpcRt9QZE=;
        b=UGgM/QHaUtT8c1ROZkCQfogq6MyH1lPn2g/AfJbA1dmtxDuLmZhCAVKgFezW3lfAzDdyIw
        GOX7loSeFymOFlaO2pDHcNNfZSGvyyi4lln6GDRtOYg4KYzEcPdl8Obp3+8NSYFKS98KcA
        /i4Ws1gMVMkNKveOIlpqunsls4UIu9c=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-nRBNjcVDNrujGBsgyy58wg-1; Mon, 22 Nov 2021 09:17:51 -0500
X-MC-Unique: nRBNjcVDNrujGBsgyy58wg-1
Received: by mail-wr1-f71.google.com with SMTP id q7-20020adff507000000b0017d160d35a8so3143919wro.4
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 06:17:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b8j4H1c+TO9iY8wgTRJm+897eYK163M/O3MpcRt9QZE=;
        b=QQHP3ch1wkWmFwAZntqF/CoQjYc9gEXeXGTfkhrcXXUA+iyeA00DaY/oUYW++p5xWg
         e2PlFkzs6SX5VRK2gVWSG6LwRgMGTCIRg/jZIC1vrZnIg7o2271f5kYPkAuTlWnQn88S
         Q8+G8xZlihOUu2DoacqJaDmYsv7uVSxXHjABc3SnXd4myi4sytQKwqPvQdpYJCd2PP2C
         dn+07cSclT6Ce00WV3PAc+dDjNv0eOEtk4Wr6vU0rI3JaXnV1N3uScNYYWhXxbyhF4ZE
         pAtXi5Xa6ZSqmOEa733BpwK8XjCvxmhdDOt4t/ihPG/spVXy9DgqlZoRpEoM9EeB/X7U
         gwiQ==
X-Gm-Message-State: AOAM530jObosaabt+l6ufrZVTZZMXIp1P1hm9seVRJuKQM8iYpsVEs5g
        5BSYSDP9KuPdY3NUlwXlEnbIOiMnYQGqdGbjaWw1iSuszvez/PMhDDkDyN7P/o+YHeWSYEYsY3Y
        T9KrH95JYZjRM
X-Received: by 2002:a7b:cf18:: with SMTP id l24mr23283831wmg.145.1637590670281;
        Mon, 22 Nov 2021 06:17:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxnJNeZThckurE+7VISUfzrDfmt+59fec9BO+umSilZNfBCT9bvtssuapEqB00xQiUHyptvAw==
X-Received: by 2002:a7b:cf18:: with SMTP id l24mr23283760wmg.145.1637590669756;
        Mon, 22 Nov 2021 06:17:49 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id c4sm9147592wrr.37.2021.11.22.06.17.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 06:17:49 -0800 (PST)
Subject: Re: [RFC PATCH v3 29/29] KVM: arm64: selftests: Introduce id_reg_test
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-30-reijiw@google.com>
 <a695d763-b631-e639-3708-2623f4842064@redhat.com>
 <CAAeT=FwmmLJCR-WumnvxjiRuafD_7gr3JjHZWWO5O=jedh2daQ@mail.gmail.com>
From:   Eric Auger <eauger@redhat.com>
Message-ID: <8dfa692e-5aa1-c6b3-55f8-3c2bb83df9cd@redhat.com>
Date:   Mon, 22 Nov 2021 15:17:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAAeT=FwmmLJCR-WumnvxjiRuafD_7gr3JjHZWWO5O=jedh2daQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,
On 11/20/21 7:39 AM, Reiji Watanabe wrote:
>  Hi Eric,
> 
> On Thu, Nov 18, 2021 at 12:34 PM Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Reiji,
>>
>> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
>>> Introduce a test for aarch64 to validate basic behavior of
>>> KVM_GET_ONE_REG and KVM_SET_ONE_REG for ID registers.
>>>
>>> This test runs only when KVM_CAP_ARM_ID_REG_CONFIGURABLE is supported.
>>
>> That's great to get those tests along with the series.
>>
>> There are several tests actually. I would encourage you to drop a short
>> comment along with the each main test to summarize what it does.
> 
> Thank you for the review !
> Yes, I will add short comments for the main test to summarize what it does.
> 
> 
>>> +struct id_reg_test_info {
>>> +     char            *name;
>>> +     uint32_t        id;
>>> +     bool            can_clear;
>>> +     uint64_t        fixed_mask;
>>> +     uint64_t        org_val;
>> nit: original_val? or default_val?
> 
> That is an original (or initial) value that is set by KVM.
> I will change it to original_val.
> 
> 
>>> +void test_pmu_init(struct kvm_vm *vm, uint32_t vcpu)
>> I would remove the test_ prefix as it does not test anything but
>> enhances the initialization instead
> 
> Yes, I agree.
> I will remove test_ prefix from those names.
> 
>>> +{
>>> +     struct kvm_device_attr attr = {
>>> +             .group = KVM_ARM_VCPU_PMU_V3_CTRL,
>>> +             .attr = KVM_ARM_VCPU_PMU_V3_INIT,
>>> +     };
>>> +     vcpu_ioctl(vm, vcpu, KVM_SET_DEVICE_ATTR, &attr);
>>> +}
>>> +
>>> +void test_sve_init(struct kvm_vm *vm, uint32_t vcpu)
>>> +{
>>> +     int feature = KVM_ARM_VCPU_SVE;
>>> +
>>> +     vcpu_ioctl(vm, vcpu, KVM_ARM_VCPU_FINALIZE, &feature);
>>> +}
>>> +
>>> +#define GICD_BASE_GPA                        0x8000000ULL
>>> +#define GICR_BASE_GPA                        0x80A0000ULL
>>> +
>>> +void test_vgic_init(struct kvm_vm *vm, uint32_t vcpu)
>>> +{
>>> +     /* We jsut need to configure gic v3 (we don't use it though) */
>>> +     vgic_v3_setup(vm, 1, GICD_BASE_GPA, GICR_BASE_GPA);
>>> +}
>>> +
>>> +#define      MAX_CAPS        2
>>> +struct feature_test_info {
>>> +     char    *name;  /* Feature Name (Debug information) */
>>> +     struct id_reg_test_info *sreg;  /* ID register for the feature */
>> ID register comprising the feature?
>>> +     int     shift;  /* Field of the ID register for the feature */
>> I guess you mean feature field bit shift
>>> +     int     min;    /* Min value to indicate the feature */
>> Min value that can be assigned to the feature field?
>>> +     bool    is_sign;        /* Is the field signed or unsigned ? */
>>> +     int     ncaps;          /* Number of valid Capabilities in caps[] */
>>> +     long    caps[MAX_CAPS]; /* Capabilities to indicate this feature */
>> I suggest: KVM_CAP_* capabilities requested to test this feature
>>> +     /* struct kvm_enable_cap to use the capability if needed */
>>> +     struct kvm_enable_cap   *opt_in_cap;
>>> +     bool    run_test;       /* Does guest run test for this feature ? */
>> s/run_test/guest_run?
>>> +     /* Initialization function for the feature as needed */
>> extra init sequence needed besides KVM CAP setting?
>>> +     void    (*init_feature)(struct kvm_vm *vm, uint32_t vcpuid);
>>> +     /* struct kvm_vcpu_init to opt-in the feature if needed */
>>> +     struct kvm_vcpu_init    *vcpu_init;
>>> +};
> 
> I am going to fix the comments as follows.
> (Or are any of them still unclear ?)
> 
>     /* ID register that identifies the presence of the feature */
>     struct id_reg_test_info *sreg;
> 
>     /* Bit shift for the field that identifies the presence of the feature */
>     int     shift;
> 
>     /* Min value of the field that indicates the presence of the feature */
>     int     min;    /* Min value to indicate the feature */
> 
>     /* KVM_CAP_* Capabilities to indicates that KVM supports this feature */
>     long    caps[MAX_CAPS]; /* Capabilities to indicate this feature */
> 
>     /* Should the guest check the ID register for this feature ? */
>     bool    run_test;
> 
>     /*
>      * Any extra function to configure the feature if needed.
>      * (e.g. KVM_ARM_VCPU_FINALIZE for SVE)
>      */
>     void    (*init_feature)(struct kvm_vm *vm, uint32_t vcpuid);
> 
>>> +
>>> +/* Test for optin CPU features */
>> opt-in?
> 
> I will fix it.
> 
>>> +static struct feature_test_info feature_test_info_table[] = {
>>> +     {
>>> +             .name = "SVE",
>>> +             .sreg = ID_REG_INFO(ID_AA64PFR0),
>>> +             .shift = ID_AA64PFR0_SVE_SHIFT,
>>> +             .min = 1,
>>> +             .caps = {KVM_CAP_ARM_SVE},
>>> +             .ncaps = 1,
>>> +             .init_feature = test_sve_init,
>>> +             .vcpu_init = &(struct kvm_vcpu_init) {
>>> +                     .features = {1ULL << KVM_ARM_VCPU_SVE},
>>> +             },
>>> +     },
>>> +     {
>>> +             .name = "GIC",
>>> +             .sreg = ID_REG_INFO(ID_AA64PFR0),
>>> +             .shift = ID_AA64PFR0_GIC_SHIFT,
>>> +             .min = 1,
>>> +             .caps = {KVM_CAP_IRQCHIP},
>>> +             .ncaps = 1,
>>> +             .init_feature = test_vgic_init,
>>> +     },
>>> +     {
>>> +             .name = "MTE",
>>> +             .sreg = ID_REG_INFO(ID_AA64PFR1),
>>> +             .shift = ID_AA64PFR1_MTE_SHIFT,
>>> +             .min = 2,
>>> +             .caps = {KVM_CAP_ARM_MTE},
>>> +             .ncaps = 1,
>>> +             .opt_in_cap = &(struct kvm_enable_cap) {
>>> +                             .cap = KVM_CAP_ARM_MTE,
>>> +             },
>>> +     },
>>> +     {
>>> +             .name = "PMUV3",
>>> +             .sreg = ID_REG_INFO(ID_AA64DFR0),
>>> +             .shift = ID_AA64DFR0_PMUVER_SHIFT,
>>> +             .min = 1,
>>> +             .init_feature = test_pmu_init,
>>> +             .caps = {KVM_CAP_ARM_PMU_V3},
>>> +             .ncaps = 1,
>>> +             .vcpu_init = &(struct kvm_vcpu_init) {
>>> +                     .features = {1ULL << KVM_ARM_VCPU_PMU_V3},
>>> +             },
>>> +     },
>>> +     {
>>> +             .name = "PERFMON",
>>> +             .sreg = ID_REG_INFO(ID_DFR0),
>>> +             .shift = ID_DFR0_PERFMON_SHIFT,
>>> +             .min = 3,
>>> +             .init_feature = test_pmu_init,
>>> +             .caps = {KVM_CAP_ARM_PMU_V3},
>>> +             .ncaps = 1,
>>> +             .vcpu_init = &(struct kvm_vcpu_init) {
>>> +                     .features = {1ULL << KVM_ARM_VCPU_PMU_V3},
>>> +             },
>>> +     },
>>> +};
>>> +
>>> +static int walk_id_reg_list(int (*fn)(struct id_reg_test_info *sreg, void *arg),
>>> +                         void *arg)
>>> +{
>>> +     int ret = 0, i;
>>> +
>>> +     for (i = 0; i < ARRAY_SIZE(id_reg_list); i++) {
>>> +             ret = fn(&id_reg_list[i], arg);
>>> +             if (ret)
>>> +                     break;
>> none of your fn() function does return something != 0
> 
> I will change the callback function to return void instead of int.
> 
>>> +     }
>>> +     return ret;
>>> +}
>>> +
>>> +static int guest_code_id_reg_check_one(struct id_reg_test_info *sreg, void *arg)
>>> +{
>>> +     uint64_t val = sreg->read_reg();
>>> +
>>> +     GUEST_ASSERT_2(val == sreg->user_val, sreg->name, sreg->user_val);
>>> +     return 0;
>>> +}
>>> +
>>> +static void guest_code_id_reg_check_all(uint32_t cpu)
>>> +{
>>> +     walk_id_reg_list(guest_code_id_reg_check_one, NULL);
>>> +     GUEST_DONE();
>>> +}
>>> +
>>> +static void guest_code_do_nothing(uint32_t cpu)
>>> +{
>>> +     GUEST_DONE();
>>> +}
>>> +
>>> +static void guest_code_feature_check(uint32_t cpu)
>>> +{
>>> +     int i;
>>> +     struct feature_test_info *finfo;
>>> +
>>> +     for (i = 0; i < ARRAY_SIZE(feature_test_info_table); i++) {
>>> +             finfo = &feature_test_info_table[i];
>>> +             if (finfo->run_test)
>>> +                     guest_code_id_reg_check_one(finfo->sreg, NULL);
>>> +     }
>>> +
>>> +     GUEST_DONE();
>>> +}
>>> +
>>> +static void guest_code_ptrauth_check(uint32_t cpuid)
>>> +{
>>> +     struct id_reg_test_info *sreg = ID_REG_INFO(ID_AA64ISAR1);
>>> +     uint64_t val = sreg->read_reg();
>>> +
>>> +     GUEST_ASSERT_2(val == sreg->user_val, "PTRAUTH", val);
>>> +     GUEST_DONE();
>>> +}
>>> +
>>> +static int reset_id_reg_info_one(struct id_reg_test_info *sreg, void *arg)
>> reset_id_reg_user_val_one()?
> 
> Thanks for the suggestion. I will fix that.
> 
>>> +{
>>> +     sreg->user_val = sreg->org_val;
>>> +     return 0;
>>> +}
>>> +
>>> +static void reset_id_reg_info(void)
>> reset_id_reg_user_val()?
> 
>  I will fix that.
> 
>>> +{
>>> +     walk_id_reg_list(reset_id_reg_info_one, NULL);
>>> +}
>>> +
>>> +static struct kvm_vm *test_vm_create_cap(uint32_t nvcpus,
>>> +             void (*guest_code)(uint32_t), struct kvm_vcpu_init *init,
>>> +             struct kvm_enable_cap *cap)
>>> +{
>>> +     struct kvm_vm *vm;
>>> +     uint32_t cpuid;
>>> +     uint64_t mem_pages;
>>> +
>>> +     mem_pages = DEFAULT_GUEST_PHY_PAGES + DEFAULT_STACK_PGS * nvcpus;
>>> +     mem_pages += mem_pages / (PTES_PER_MIN_PAGE * 2);
>>> +     mem_pages = vm_adjust_num_guest_pages(VM_MODE_DEFAULT, mem_pages);
>>
>>
>>> +
>>> +     vm = vm_create(VM_MODE_DEFAULT,
>>> +             DEFAULT_GUEST_PHY_PAGES + (DEFAULT_STACK_PGS * nvcpus),
>>> +             O_RDWR);
>> mem_pages must be used instead
>>
>> augere@virtlab-arm04:~/UPSTREAM/ML/tools/testing/selftests/kvm#
>> ./aarch64/id_reg_test
>> ==== Test Assertion Failure ====
>>   lib/kvm_util.c:825: vm_adjust_num_guest_pages(vm->mode, npages) == npages
>>   pid=11439 tid=11439 errno=0 - Success
>>      1  0x00000000004068cb: vm_userspace_mem_region_add at kvm_util.c:823
>>      2  0x00000000004071af: vm_create at kvm_util.c:319
>>      3  0x0000000000401afb: test_vm_create_cap at id_reg_test.c:508
>>      4  0x00000000004014a3: test_vm_create at id_reg_test.c:541
>>      5   (inlined by) init_id_reg_info at id_reg_test.c:1110
>>      6   (inlined by) main at id_reg_test.c:1125
>>      7  0x000003ffa7220de3: ?? ??:0
>>      8  0x00000000004015eb: _start at :?
>>   Number of guest pages is not compatible with the host. Try npages=528
> 
> Thank you for catching this (It didn't happen in my usual test environment).
> I will fix this.
> 
>>
>>
>> Don't you want to check the cap in a first place using kvm_check_cap and
>> cap->cap
> 
> It is done by the caller before trying to create the vm.
> 
> 
>>> +     if (cap)
>>> +             vm_enable_cap(vm, cap);
>>> +
>>> +     kvm_vm_elf_load(vm, program_invocation_name);
>>> +
>>> +     if (init && init->target == -1) {
>>> +             struct kvm_vcpu_init preferred;
>>> +
>>> +             vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &preferred);
>>> +             init->target = preferred.target;
>>> +     }
>>> +
>>> +     vm_init_descriptor_tables(vm);
>>> +     for (cpuid = 0; cpuid < nvcpus; cpuid++) {
>>> +             if (init)
>>> +                     aarch64_vcpu_add_default(vm, cpuid, init, guest_code);
>>> +             else
>>> +                     vm_vcpu_add_default(vm, cpuid, guest_code);
>> nit: vm_vcpu_add_default calls aarch64_vcpu_add_default(vm, vcpuid,
>> NULL, guest_code) so you can unconditionnaly call
>> aarch64_vcpu_add_default(vm, cpuid, init, guest_code)
> 
> Oh, thank you ! I will fix that (somehow I overlooked that...).
> 
>>> +
>>> +             vcpu_init_descriptor_tables(vm, cpuid);
>>> +     }
>>> +
>>> +     ucall_init(vm, NULL);
>>> +     return vm;
>>> +}
>>> +
>>> +static struct kvm_vm *test_vm_create(uint32_t nvcpus,
>>> +                                  void (*guest_code)(uint32_t),
>>> +                                  struct kvm_vcpu_init *init)
>>> +{
>>> +     return test_vm_create_cap(nvcpus, guest_code, init, NULL);
>>> +}
>> nit: not sure test_vm_create is needed. By the way it is already called
>> with init = NULL so we can call test_vm_create_cap with 2 NULL args
> 
> I will remove test_vm_create.
> 
> 
>>> +
>>> +static void test_vm_free(struct kvm_vm *vm)
>>> +{
>>> +     ucall_uninit(vm);
>>> +     kvm_vm_free(vm);
>>> +}
>>> +
>>> +#define      TEST_RUN(vm, cpu)       \
>>> +     (test_vcpu_run(__func__, __LINE__, vm, cpu, true))
>>> +
>>> +#define      TEST_RUN_NO_SYNC_DATA(vm, cpu)  \
>>> +     (test_vcpu_run(__func__, __LINE__, vm, cpu, false))
>>> +
>>> +static int test_vcpu_run(const char *test_name, int line,
>>> +                      struct kvm_vm *vm, uint32_t vcpuid, bool sync_data)
>>> +{
>>> +     struct ucall uc;
>>> +     int ret;
>>> +
>>> +     if (sync_data) {
>>> +             sync_global_to_guest(vm, id_reg_list);
>>> +             sync_global_to_guest(vm, feature_test_info_table);
>>> +     }
>>> +
>>> +     vcpu_args_set(vm, vcpuid, 1, vcpuid);
>>> +
>>> +     ret = _vcpu_run(vm, vcpuid);
>>> +     if (ret) {
>>> +             ret = errno;
>>> +             goto sync_exit;
>>> +     }
>>> +
>>> +     switch (get_ucall(vm, vcpuid, &uc)) {
>>> +     case UCALL_SYNC:
>>> +     case UCALL_DONE:
>>> +             ret = 0;
>>> +             break;
>>> +     case UCALL_ABORT:
>>> +             TEST_FAIL(
>>> +                 "%s (%s) at line %d (user %s at line %d), args[3]=0x%lx",
>>> +                 (char *)uc.args[0], (char *)uc.args[2], (int)uc.args[1],
>>> +                 test_name, line, uc.args[3]);
>>> +             break;
>>> +     default:
>>> +             TEST_FAIL("Unexpected guest exit\n");
>>> +     }
>>> +
>>> +sync_exit:
>>> +     if (sync_data) {
>>> +             sync_global_from_guest(vm, id_reg_list);
>>> +             sync_global_from_guest(vm, feature_test_info_table);
>>> +     }
>>> +     return ret;
>>> +}
>>> +
>>> +static int set_id_regs_after_run_test_one(struct id_reg_test_info *sreg,
>>> +                                       void *arg)
>>> +{
>>> +     struct kvm_vm *vm = arg;
>>> +     struct kvm_one_reg one_reg;
>>> +     uint32_t vcpuid = 0;
>>> +     uint64_t reg_val;
>>> +     int ret;
>>> +
>>> +     one_reg.addr = (uint64_t)&reg_val;
>>> +     one_reg.id = KVM_ARM64_SYS_REG(sreg->id);
>>> +
>>> +     vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, &one_reg);
>>> +     if ((reg_val != 0) && (sreg->can_clear)) {
>>> +             reg_val = 0;
>>> +             ret = _vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &one_reg);
>>> +             TEST_ASSERT(ret && errno == EINVAL,
>>> +                         "Changing ID reg value should fail\n");
>>> +     }
>>> +
>>> +     vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, &one_reg);> +   ret = _vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &one_reg);
>>> +     TEST_ASSERT(ret == 0, "Setting the same ID reg value should work\n");
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static int set_id_regs_test_one(struct id_reg_test_info *sreg, void *arg)
>> if it is a test use test_ prefix
> 
> I will fix this.
> 
> 
>>> +{
>>> +     struct kvm_vm *vm = arg;
>>> +     struct kvm_one_reg one_reg;
>>> +     uint32_t vcpuid = 0;
>>> +     uint64_t reg_val;
>>> +
>>> +     one_reg.addr = (uint64_t)&reg_val;
>>> +     reset_id_reg_info();
>>> +
>>> +     one_reg.id = KVM_ARM64_SYS_REG(sreg->id);
>>> +     if (sreg->can_clear) {
>>> +             /* Change the register to 0 when possible */
>>> +             reg_val = 0;
>>> +             vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &one_reg);
>>> +             vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, &one_reg);
>>> +             TEST_ASSERT(reg_val == 0,
>>> +                 "GET(%s) didn't return 0 but 0x%lx", sreg->name, reg_val);
>>> +     }
>>> +
>>> +     /* Check if we can restore the initial value */
>>> +     reg_val = sreg->org_val;
>>> +     vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &one_reg);
>>> +     vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, &one_reg);
>>> +     TEST_ASSERT(reg_val == sreg->org_val,
>>> +                 "GET(%s) didn't return 0x%lx but 0x%lx",
>>> +                 sreg->name, sreg->org_val, reg_val);
>>> +     sreg->user_val = sreg->org_val;
>>> +     return 0;
>>> +}
>>> +
>>> +static void set_id_regs_test(void)
>> if it is a test use test_ prefix
> 
> I will fix this.
> 
>>> +{
>>> +     struct kvm_vm *vm;
>>> +     int ret;
>>> +
>>> +     reset_id_reg_info();
>>> +     vm = test_vm_create(1, guest_code_id_reg_check_all, NULL);
>> add test_vm_free()
> 
> I will fix this.
> 
>>> +
>>> +     ret = walk_id_reg_list(set_id_regs_test_one, vm);
>>> +     assert(!ret);
>>> +
>>> +     ret = TEST_RUN(vm, 0);
>>> +     TEST_ASSERT(!ret, "%s TEST_RUN failed, ret=0x%x", __func__, ret);
>>> +
>>> +     ret = walk_id_reg_list(set_id_regs_after_run_test_one, vm);
>>> +     assert(!ret);
>>> +}
>>> +
>>> +static bool caps_are_supported(long *caps, int ncaps)
>>> +{
>>> +     int i;
>>> +
>>> +     for (i = 0; i < ncaps; i++) {
>>> +             if (kvm_check_cap(caps[i]) <= 0)
>>> +                     return false;
>>> +     }
>>> +     return true;
>>> +}
>>> +
>>> +static void test_feature_ptrauth(void)
>>> +{
>>> +     struct kvm_one_reg one_reg;
>>> +     struct kvm_vcpu_init init;
>>> +     struct kvm_vm *vm = NULL;
>>> +     struct id_reg_test_info *sreg = ID_REG_INFO(ID_AA64ISAR1);
>>> +     uint32_t vcpu = 0;
>>> +     int64_t rval;
>>> +     int ret;
>>> +     int apa, api, gpa, gpi;
>>> +     char *name = "PTRAUTH";
>>> +     long caps[2] = {KVM_CAP_ARM_PTRAUTH_ADDRESS,
>>> +                     KVM_CAP_ARM_PTRAUTH_GENERIC};
>>> +
>>> +     reset_id_reg_info();
>>> +     one_reg.addr = (uint64_t)&rval;
>>> +     one_reg.id = KVM_ARM64_SYS_REG(sreg->id);
>>> +
>>> +     if (caps_are_supported(caps, 2)) {
>>> +
>>> +             /* Test with feature enabled */
>>> +             memset(&init, 0, sizeof(init));
>>> +             init.target = -1;
>>> +             init.features[0] = (1ULL << KVM_ARM_VCPU_PTRAUTH_ADDRESS |
>>> +                                 1ULL << KVM_ARM_VCPU_PTRAUTH_GENERIC);
>>> +             vm = test_vm_create_cap(1, guest_code_ptrauth_check, &init,
>>> +                                     NULL);
>>> +             vcpu_ioctl(vm, vcpu, KVM_GET_ONE_REG, &one_reg);
>>> +             apa = GET_ID_UFIELD(rval, ID_AA64ISAR1_APA_SHIFT);
>>> +             api = GET_ID_UFIELD(rval, ID_AA64ISAR1_API_SHIFT);
>>> +             gpa = GET_ID_UFIELD(rval, ID_AA64ISAR1_GPA_SHIFT);
>>> +             gpi = GET_ID_UFIELD(rval, ID_AA64ISAR1_GPI_SHIFT);
>>> +
>>> +             TEST_ASSERT((apa > 0) || (api > 0),
>>> +                         "Either apa(0x%x) or api(0x%x) must be available",
>>> +                         apa, gpa);
>>> +             TEST_ASSERT((gpa > 0) || (gpi > 0),
>>> +                         "Either gpa(0x%x) or gpi(0x%x) must be available",
>>> +                         gpa, gpi);
>>> +
>>> +             TEST_ASSERT((apa > 0) ^ (api > 0),
>>> +                         "Both apa(0x%x) and api(0x%x) must not be available",
>>> +                         apa, api);
>>> +             TEST_ASSERT((gpa > 0) ^ (gpi > 0),
>>> +                         "Both gpa(0x%x) and gpi(0x%x) must not be available",
>>> +                         gpa, gpi);
>>> +
>>> +             sreg->user_val = rval;
>>> +
>>> +             pr_debug("%s: Test with %s enabled (%s: 0x%lx)\n",
>>> +                      __func__, name, sreg->name, sreg->user_val);
>>> +             ret = TEST_RUN(vm, vcpu);
>>> +             TEST_ASSERT(!ret, "%s:KVM_RUN failed with %s enabled",
>>> +                         __func__, name);
>>> +             test_vm_free(vm);
>>> +     }
>>> +
>>> +     /* Test with feature disabled */
>>> +     reset_id_reg_info();
>>> +
>>> +     vm = test_vm_create(1, guest_code_feature_check, NULL);
>>> +     vcpu_ioctl(vm, vcpu, KVM_GET_ONE_REG, &one_reg);
>>> +
>>> +     apa = GET_ID_UFIELD(rval, ID_AA64ISAR1_APA_SHIFT);
>>> +     api = GET_ID_UFIELD(rval, ID_AA64ISAR1_API_SHIFT);
>>> +     gpa = GET_ID_UFIELD(rval, ID_AA64ISAR1_GPA_SHIFT);
>>> +     gpi = GET_ID_UFIELD(rval, ID_AA64ISAR1_GPI_SHIFT);
>>> +     TEST_ASSERT(!apa && !api && !gpa && !gpi,
>>> +         "apa(0x%x), api(0x%x), gpa(0x%x), gpi(0x%x) must be zero",
>>> +         apa, api, gpa, gpi);
>>> +
>>> +     pr_debug("%s: Test with %s disabled (%s: 0x%lx)\n",
>>> +              __func__, name, sreg->name, sreg->user_val);
>>> +
>>> +     ret = TEST_RUN(vm, vcpu);
>>> +     TEST_ASSERT(!ret, "%s TEST_RUN failed with %s enabled, ret=0x%x",
>>> +                 __func__, name, ret);
>>> +
>>> +     test_vm_free(vm);
>>> +}
>>> +
>>> +static bool feature_caps_are_available(struct feature_test_info *finfo)
>>> +{
>>> +     return ((finfo->ncaps > 0) &&
>>> +             caps_are_supported(finfo->caps, finfo->ncaps));
>>> +}
>>> +
>> comment with short explanation of what the test does
> 
> Yes, I will add a short explanation for each test.
> 
>>> +static void test_feature(struct feature_test_info *finfo)
>>> +{
>>> +     struct id_reg_test_info *sreg = finfo->sreg;
>>> +     struct kvm_one_reg one_reg;
>>> +     struct kvm_vcpu_init init, *initp = NULL;
>>> +     struct kvm_vm *vm = NULL;
>>> +     int64_t fval, reg_val;
>>> +     uint32_t vcpu = 0;
>>> +     bool is_sign = finfo->is_sign;
>>> +     int min = finfo->min;
>>> +     int shift = finfo->shift;
>>> +     int ret;
>>> +
>>> +     pr_debug("%s: %s (reg %s)\n", __func__, finfo->name, sreg->name);
>>> +
>>> +     reset_id_reg_info();
>>> +     finfo->run_test = 1;    /* Indicate that guest runs the test on it */
>>> +     one_reg.addr = (uint64_t)&reg_val;
>>> +     one_reg.id = KVM_ARM64_SYS_REG(sreg->id);
>>> +
>>> +     /* Test with feature enabled if the feature is available */
>> s/if the feature is available/if the feature is exposed in the default
>> ID_REG value and if the capabilities are supported at KVM level
> 
> Thank you for the suggestion. I will fix that.
> 
> 
>>> +void run_test(void)
>>> +{
>>> +     set_id_regs_test();
>>> +     test_feature_all();
>>> +     test_feature_ptrauth();
>>> +     test_feature_frac_all();
>>> +}
>>> +
>> basic comment would be helpful: attempts to clear a given id_reg and
>> populate the id_reg with the original value, and can_clear flag?
> 
> I will add some comments.
> 
>>> +static int init_id_reg_info_one(struct id_reg_test_info *sreg, void *arg)
>>> +{
>>> +     uint64_t reg_val;
>>> +     uint32_t vcpuid = 0;
>>> +     int ret;
>>> +     struct kvm_one_reg one_reg;
>>> +     struct kvm_vm *vm = arg;
>>> +
>>> +     one_reg.addr = (uint64_t)&reg_val;
>>> +     one_reg.id = KVM_ARM64_SYS_REG(sreg->id);
>>> +     vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, &one_reg);
>>> +     sreg->org_val = reg_val;
>>> +     sreg->user_val = reg_val;
>> nit: add a comment for user_val because it is not obvious why you set it
>> to reg_val.
> 
> I will add a comment for it.
> 
>>> +     if (sreg->org_val) {
>>> +             reg_val = 0;
>>> +             ret = _vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &one_reg);
>>> +             if (!ret)
>>> +                     sreg->can_clear = true;
>>> +     }
>>> +
>>> +     pr_debug("%s (0x%x): 0x%lx%s\n", sreg->name, sreg->id,
>>> +              sreg->org_val, sreg->can_clear ? ", can clear" : "");
>>> +
>>> +     return 0;
>>> +}
>>> +
>> add a comment? loop over the idreg list and populates each regid info
>> with the default, user and can_clear value
> 
> I will add a comment for the function.
> 
>>> +static void init_id_reg_info(void)
>>> +{
>>> +     struct kvm_vm *vm;
>>> +
>>> +     vm = test_vm_create(1, guest_code_do_nothing, NULL);
>>> +     walk_id_reg_list(init_id_reg_info_one, vm);
>>> +     test_vm_free(vm);
>>> +}
>>> +
>>> +int main(void)
>>> +{
>>> +
>>> +     setbuf(stdout, NULL);
>>> +
>>> +     if (kvm_check_cap(KVM_CAP_ARM_ID_REG_CONFIGURABLE) <= 0) {
>>> +             print_skip("KVM_CAP_ARM_ID_REG_CONFIGURABLE is not supported\n");
>>> +             exit(KSFT_SKIP);
>>> +     }
>>> +
>>> +     init_id_reg_info();
>>> +     run_test();
>>> +     return 0;
>>> +}
>>>
>>
>> After fixing the mem_pages stuff I get the following error on a cavium
>> machine.
>>
>> augere@virtlab-arm04:~/UPSTREAM/ML/tools/testing/selftests/kvm#
>> ./aarch64/id_reg_test
>> ==== Test Assertion Failure ====
>>   aarch64/id_reg_test.c:814: fval >= min
>>   pid=11692 tid=11692 errno=4 - Interrupted system call
>>      1  0x00000000004028d3: test_feature at id_reg_test.c:813
>>      2   (inlined by) test_feature_all at id_reg_test.c:863
>>      3   (inlined by) run_test at id_reg_test.c:1073
>>      4  0x000000000040156f: main at id_reg_test.c:1124
>>      5  0x000003ffa9420de3: ?? ??:0
>>      6  0x00000000004015eb: _start at :?
>>   PERFMON field of ID_DFR0 is too small (0)
>>
>> Fails on
>> test_feature: PERFMON (reg ID_DFR0)
>>
>> I will do my utmost to further debug
> 
> Thank you for running it in your environment and reporting this !
> This is very interesting...
> 
> It implies that the host's ID_DFR0_EL1.PerfMon is zero or 0xf
> (meaning FEAT_PMUv3 is not implemented) even though the host's
> ID_AA64DFR0_EL1.PMUVer indicates that FEAT_PMUv3 is implemented.
> 
> Would it be possible for you to check values of those two
> registers on the host (not on the guest) to see if both of them
> indicate the presence of FEAT_PMUv3 consistently ?

Here are both values printed in armpmu_register()
[   33.320901] armpmu_register perfmon=0x0 pmuver=0x4

        perfmon =
cpuid_feature_extract_unsigned_field(read_cpuid(ID_DFR0_EL1),
                        ID_DFR0_PERFMON_SHIFT);
        pmuver =
cpuid_feature_extract_unsigned_field(read_cpuid(ID_AA64DFR0_EL1),
                        ID_AA64DFR0_PMUVER_SHIFT);
        printk("%s perfmon=0x%x pmuver=0x%x\n", __func__, perfmon, pmuver);

My machine is a Gigabyte R181-T90 (ThunderX2)

Eric


Eric

> 
> Thanks,
> Reiji
> 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D810C155548
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 11:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgBGKGJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 05:06:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51996 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726642AbgBGKGJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 05:06:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581069968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D4NZi+h363P+5qKPOIAZPmD2180+BMbjcmkv6zLYjc8=;
        b=F/uzBG4Ew+ZH4jYrqHa7l8id10S3IXJb10lpzoBbTfHDru5u5VkAhdO4pXD6cDtE8/5v3J
        8Cok1huYUQZOdvEo2TMVVeYXGpcJak3fShULO7vBX9A4xLcQFbXkZ1rf5Dz86buPFrMvPr
        6UCy1DqExn3q0MGuYILouRq075W+SDw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-uphhDSkzPBeInfzEow0_Eg-1; Fri, 07 Feb 2020 05:06:04 -0500
X-MC-Unique: uphhDSkzPBeInfzEow0_Eg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C709100551A;
        Fri,  7 Feb 2020 10:06:03 +0000 (UTC)
Received: from [10.36.116.37] (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6FB2760BF7;
        Fri,  7 Feb 2020 10:05:55 +0000 (UTC)
Subject: Re: [PATCH v4 3/3] selftests: KVM: SVM: Add vmcall test
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Wei Huang <wei.huang2@amd.com>
Cc:     eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        thuth@redhat.com, drjones@redhat.com
References: <20200206104710.16077-1-eric.auger@redhat.com>
 <20200206104710.16077-4-eric.auger@redhat.com>
 <20200206173931.GC2465308@weiserver.amd.com>
 <556d20b2-d6cf-e13c-635c-809836316b80@oracle.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <ebec5529-1b38-6df9-241b-2326e87a9f8e@redhat.com>
Date:   Fri, 7 Feb 2020 11:05:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <556d20b2-d6cf-e13c-635c-809836316b80@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Krish,
On 2/6/20 8:08 PM, Krish Sadhukhan wrote:
>=20
> On 2/6/20 9:39 AM, Wei Huang wrote:
>> On 02/06 11:47, Eric Auger wrote:
>>> L2 guest calls vmcall and L1 checks the exit status does
>>> correspond.
>>>
>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>>> Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
>> I verified this patch with my AMD box, both with nested=3D1 and nested=
=3D0. I
>> also intentionally changed the assertion of exit_code to a different
>> value (0x082) and the test complained about it. So the test is good.
>>
>> # selftests: kvm: svm_vmcall_test
>> # =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
>> #=C2=A0=C2=A0 x86_64/svm_vmcall_test.c:64: false
>> #=C2=A0=C2=A0 pid=3D2485656 tid=3D2485656 - Interrupted system call
>> #=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0x0000000000401387: main at svm_vmcall_test.c:72
>> #=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0x00007fd0978d71a2: ?? ??:0
>> #=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0x00000000004013ed: _start at ??:?
>> #=C2=A0=C2=A0 Failed guest assert: vmcb->control.exit_code =3D=3D SVM_=
EXIT_VMMCALL
>> # Testing guest mode: PA-bits:ANY, VA-bits:48,=C2=A0 4K pages
>> # Guest physical address width detected: 48
>> not ok 15 selftests: kvm: svm_vmcall_test # exit=3D254
>>
>>> ---
>>>
>>> v3 -> v4:
>>> - remove useless includes
>>> - collected Lin's R-b
>>>
>>> v2 -> v3:
>>> - remove useless comment and add Vitaly's R-b
>>> ---
>>> =C2=A0 tools/testing/selftests/kvm/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
>>> =C2=A0 .../selftests/kvm/x86_64/svm_vmcall_test.c=C2=A0=C2=A0=C2=A0 |=
 79 +++++++++++++++++++
>>> =C2=A0 2 files changed, 80 insertions(+)
>>> =C2=A0 create mode 100644
>>> tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
>>>
>>> diff --git a/tools/testing/selftests/kvm/Makefile
>>> b/tools/testing/selftests/kvm/Makefile
>>> index 2e770f554cae..b529d3b42c02 100644
>>> --- a/tools/testing/selftests/kvm/Makefile
>>> +++ b/tools/testing/selftests/kvm/Makefile
>>> @@ -26,6 +26,7 @@ TEST_GEN_PROGS_x86_64 +=3D x86_64/vmx_dirty_log_tes=
t
>>> =C2=A0 TEST_GEN_PROGS_x86_64 +=3D x86_64/vmx_set_nested_state_test
>>> =C2=A0 TEST_GEN_PROGS_x86_64 +=3D x86_64/vmx_tsc_adjust_test
>>> =C2=A0 TEST_GEN_PROGS_x86_64 +=3D x86_64/xss_msr_test
>>> +TEST_GEN_PROGS_x86_64 +=3D x86_64/svm_vmcall_test
>>> =C2=A0 TEST_GEN_PROGS_x86_64 +=3D clear_dirty_log_test
>>> =C2=A0 TEST_GEN_PROGS_x86_64 +=3D dirty_log_test
>>> =C2=A0 TEST_GEN_PROGS_x86_64 +=3D kvm_create_max_vcpus
>>> diff --git a/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
>>> b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
>>> new file mode 100644
>>> index 000000000000..6d3565aab94e
>>> --- /dev/null
>>> +++ b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
>> Probably rename the file to svm_nested_vmcall_test.c. This matches wit=
h
>> the naming convention of VMX's nested tests. Otherwise people might
>> not know
>> it is a nested one.
>=20
> Is it better to give this file a generic name, say, nsvm_tests or
> something like that, and place all future nested SVM tests in it, rathe=
r
> than creating a separate file for each nested test ?
We had this discussion earlier. See https://lkml.org/lkml/2020/1/21/429

In v1 I proposed a similar framework as kut with sub-tests but it looks
we do not target such kind of tests in kselftests. vmcall test is just a
first dummy test that paves the way for more involved API tests.

Thanks

Eric
>>
>> Everything else looks good.
>>
>>> @@ -0,0 +1,79 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>>> +/*
>>> + * svm_vmcall_test
>>> + *
>>> + * Copyright (C) 2020, Red Hat, Inc.
>>> + *
>>> + * Nested SVM testing: VMCALL
>>> + */
>>> +
>>> +#include "test_util.h"
>>> +#include "kvm_util.h"
>>> +#include "processor.h"
>>> +#include "svm_util.h"
>>> +
>>> +#define VCPU_ID=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 5
>>> +
>>> +static struct kvm_vm *vm;
>>> +
>>> +static inline void l2_vmcall(struct svm_test_data *svm)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 __asm__ __volatile__("vmcall");
>>> +}
>>> +
>>> +static void l1_guest_code(struct svm_test_data *svm)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 #define L2_GUEST_STACK_SIZE 64
>>> +=C2=A0=C2=A0=C2=A0 unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE]=
;
>>> +=C2=A0=C2=A0=C2=A0 struct vmcb *vmcb =3D svm->vmcb;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 /* Prepare for L2 execution. */
>>> +=C2=A0=C2=A0=C2=A0 generic_svm_setup(svm, l2_vmcall,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 &l2_guest_stack[L2_GUEST_STACK_SIZE]);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 run_guest(vmcb, svm->vmcb_gpa);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 GUEST_ASSERT(vmcb->control.exit_code =3D=3D SVM_E=
XIT_VMMCALL);
>>> +=C2=A0=C2=A0=C2=A0 GUEST_DONE();
>>> +}
>>> +
>>> +int main(int argc, char *argv[])
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 vm_vaddr_t svm_gva;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 nested_svm_check_supported();
>>> +
>>> +=C2=A0=C2=A0=C2=A0 vm =3D vm_create_default(VCPU_ID, 0, (void *) l1_=
guest_code);
>>> +=C2=A0=C2=A0=C2=A0 vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpu=
id());
>>> +
>>> +=C2=A0=C2=A0=C2=A0 vcpu_alloc_svm(vm, &svm_gva);
>>> +=C2=A0=C2=A0=C2=A0 vcpu_args_set(vm, VCPU_ID, 1, svm_gva);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 for (;;) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 volatile struct kvm_run *=
run =3D vcpu_state(vm, VCPU_ID);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ucall uc;
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vcpu_run(vm, VCPU_ID);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 TEST_ASSERT(run->exit_rea=
son =3D=3D KVM_EXIT_IO,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n"=
,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 run->exit_reason,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 exit_reason_str(run->exit_reason));
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 switch (get_ucall(vm, VCP=
U_ID, &uc)) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case UCALL_ABORT:
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 T=
EST_ASSERT(false, "%s",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (const char *)uc.args[0]);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /=
* NOT REACHED */
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case UCALL_SYNC:
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 b=
reak;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case UCALL_DONE:
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 g=
oto done;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 default:
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 T=
EST_ASSERT(false,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "Unknown ucall 0x%x.", uc.c=
md);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +done:
>>> +=C2=A0=C2=A0=C2=A0 kvm_vm_free(vm);
>>> +=C2=A0=C2=A0=C2=A0 return 0;
>>> +}
>>
>=20


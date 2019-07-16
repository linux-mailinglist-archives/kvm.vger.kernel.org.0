Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 947D36B024
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 21:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbfGPTy4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 15:54:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47442 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728366AbfGPTy4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 15:54:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GJsUB4006269;
        Tue, 16 Jul 2019 19:54:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type; s=corp-2018-07-02;
 bh=sLmnF/NiAAkIwJgfy1oVJp8Djw84o+vbzNXueeCHiLo=;
 b=U9syMkn1+0QQaXoMzdi0jieOkVnpozhavTmLJPDG6Lp99WKWVDUDPaYnTKY4nyBouSgX
 IRlVQBLY9l2rTHRECdoH1OvCJBeFbEQZjYN1hu3E36iikxdvaeKxdg6FJzHIGyTAejdc
 hYQMwCOhxkrWApAwgID9JDIwc3PyoO12fNiHIPJxDjL0WXqkip7uqW75eN3Fu2L1CnSs
 IezCu75T1yIFRtPGLIhecADdM1QdDvG7mZzXXOs5MvQb/nCZuXLb5ehaQOf97ykZ8zX3
 VZ+bKpg28hv9r6cxqSxBBAlQT4v4Cc6YcPDHtNq7dIHt2qPT87c4R81RinW9FanBnlpM Tg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2tq7xqxk0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 19:54:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GJmJBs147713;
        Tue, 16 Jul 2019 19:52:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2tq5bckpu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 19:52:29 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6GJqQ8S014385;
        Tue, 16 Jul 2019 19:52:26 GMT
Received: from [10.154.167.137] (/10.154.167.137)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jul 2019 19:52:25 +0000
Subject: Re: [Qemu-devel] [patch QEMU] kvm: i386: halt poll control MSR
 support
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <20190603230408.GA7938@amt.cnet>
 <1afdac17-3f86-5e5b-aebc-5311576ddefb@redhat.com>
From:   Mark Kanda <mark.kanda@oracle.com>
Organization: Oracle Corporation
Message-ID: <0c40f676-a2f4-bb45-658e-9758fd02ce36@oracle.com>
Date:   Tue, 16 Jul 2019 14:52:23 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1afdac17-3f86-5e5b-aebc-5311576ddefb@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------4056055330F19C52E1DA679C"
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907160242
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907160244
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a multi-part message in MIME format.
--------------4056055330F19C52E1DA679C
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,

If the host doesn't support halt polling, this patch seems to break 
libvirt save/restore:

"
virsh # save halt-poll-vm halt-poll-vm.sav --running --verbose
Save: [100 %]
Domain halt-poll-vm saved to halt-poll-vm.sav

virsh # restore halt-poll-vm.sav
error: Failed to restore domain from halt-poll-vm.sav
error: operation failed: guest CPU doesn't match specification
"

I believe this occurs because libvirt rejects the restore if there are 
filtered features, which is the case if halt polling is enabled on a 
host which doesn't support it (halt polling is enabled 'by default').

As such, I think we should only enable halt polling if it is supported 
on the host - see the attached patch.

...thoughts?

Thanks,
-Mark

On 7/15/2019 4:23 AM, Paolo Bonzini wrote:
> On 04/06/19 01:04, Marcelo Tosatti wrote:
>> (CC'ing qemu devel)
>>
>> Add support for halt poll control MSR: save/restore, migration
>> and new feature name.
>>
>> The purpose of this MSR is to allow the guest to disable
>> host halt poll.
>>
>> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
>>
>> diff --git a/include/standard-headers/asm-x86/kvm_para.h b/include/standard-headers/asm-x86/kvm_para.h
>> index 35cd8d6..e171514 100644
>> --- a/include/standard-headers/asm-x86/kvm_para.h
>> +++ b/include/standard-headers/asm-x86/kvm_para.h
>> @@ -29,6 +29,7 @@
>>   #define KVM_FEATURE_PV_TLB_FLUSH	9
>>   #define KVM_FEATURE_ASYNC_PF_VMEXIT	10
>>   #define KVM_FEATURE_PV_SEND_IPI	11
>> +#define KVM_FEATURE_POLL_CONTROL	12
>>   
>>   #define KVM_HINTS_REALTIME      0
>>   
>> @@ -47,6 +48,7 @@
>>   #define MSR_KVM_ASYNC_PF_EN 0x4b564d02
>>   #define MSR_KVM_STEAL_TIME  0x4b564d03
>>   #define MSR_KVM_PV_EOI_EN      0x4b564d04
>> +#define MSR_KVM_POLL_CONTROL	0x4b564d05
>>   
>>   struct kvm_steal_time {
>>   	uint64_t steal;
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index c1ab86d..1ca6944 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -903,7 +903,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>>               "kvmclock", "kvm-nopiodelay", "kvm-mmu", "kvmclock",
>>               "kvm-asyncpf", "kvm-steal-time", "kvm-pv-eoi", "kvm-pv-unhalt",
>>               NULL, "kvm-pv-tlb-flush", NULL, "kvm-pv-ipi",
>> -            NULL, NULL, NULL, NULL,
>> +            "kvm-poll-control", NULL, NULL, NULL,
>>               NULL, NULL, NULL, NULL,
>>               NULL, NULL, NULL, NULL,
>>               "kvmclock-stable-bit", NULL, NULL, NULL,
>> @@ -3001,6 +3001,7 @@ static PropValue kvm_default_props[] = {
>>       { "kvm-asyncpf", "on" },
>>       { "kvm-steal-time", "on" },
>>       { "kvm-pv-eoi", "on" },
>> +    { "kvm-poll-control", "on" },
>>       { "kvmclock-stable-bit", "on" },
>>       { "x2apic", "on" },
>>       { "acpi", "off" },
>> @@ -5660,6 +5661,8 @@ static void x86_cpu_initfn(Object *obj)
>>       object_property_add_alias(obj, "kvm_steal_time", obj, "kvm-steal-time", &error_abort);
>>       object_property_add_alias(obj, "kvm_pv_eoi", obj, "kvm-pv-eoi", &error_abort);
>>       object_property_add_alias(obj, "kvm_pv_unhalt", obj, "kvm-pv-unhalt", &error_abort);
>> +    object_property_add_alias(obj, "kvm_poll_control", obj, "kvm-poll-control",
>> +                              &error_abort);
>>       object_property_add_alias(obj, "svm_lock", obj, "svm-lock", &error_abort);
>>       object_property_add_alias(obj, "nrip_save", obj, "nrip-save", &error_abort);
>>       object_property_add_alias(obj, "tsc_scale", obj, "tsc-scale", &error_abort);
>> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
>> index bd06523..21ed2f8 100644
>> --- a/target/i386/cpu.h
>> +++ b/target/i386/cpu.h
>> @@ -1241,6 +1241,7 @@ typedef struct CPUX86State {
>>       uint64_t steal_time_msr;
>>       uint64_t async_pf_en_msr;
>>       uint64_t pv_eoi_en_msr;
>> +    uint64_t poll_control_msr;
>>   
>>       /* Partition-wide HV MSRs, will be updated only on the first vcpu */
>>       uint64_t msr_hv_hypercall;
>> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
>> index 3b29ce5..a5e9cdf 100644
>> --- a/target/i386/kvm.c
>> +++ b/target/i386/kvm.c
>> @@ -1369,6 +1369,8 @@ void kvm_arch_reset_vcpu(X86CPU *cpu)
>>   
>>           hyperv_x86_synic_reset(cpu);
>>       }
>> +    /* enabled by default */
>> +    env->poll_control_msr = 1;
>>   }
>>   
>>   void kvm_arch_do_init_vcpu(X86CPU *cpu)
>> @@ -2059,6 +2061,11 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>>           if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_STEAL_TIME)) {
>>               kvm_msr_entry_add(cpu, MSR_KVM_STEAL_TIME, env->steal_time_msr);
>>           }
>> +
>> +        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_POLL_CONTROL)) {
>> +            kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, env->poll_control_msr);
>> +        }
>> +
>>           if (has_architectural_pmu_version > 0) {
>>               if (has_architectural_pmu_version > 1) {
>>                   /* Stop the counter.  */
>> @@ -2443,6 +2450,9 @@ static int kvm_get_msrs(X86CPU *cpu)
>>       if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_STEAL_TIME)) {
>>           kvm_msr_entry_add(cpu, MSR_KVM_STEAL_TIME, 0);
>>       }
>> +    if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_POLL_CONTROL)) {
>> +        kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
>> +    }
>>       if (has_architectural_pmu_version > 0) {
>>           if (has_architectural_pmu_version > 1) {
>>               kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>> @@ -2677,6 +2687,10 @@ static int kvm_get_msrs(X86CPU *cpu)
>>           case MSR_KVM_STEAL_TIME:
>>               env->steal_time_msr = msrs[i].data;
>>               break;
>> +        case MSR_KVM_POLL_CONTROL: {
>> +            env->poll_control_msr = msrs[i].data;
>> +            break;
>> +        }
>>           case MSR_CORE_PERF_FIXED_CTR_CTRL:
>>               env->msr_fixed_ctr_ctrl = msrs[i].data;
>>               break;
>> diff --git a/target/i386/machine.c b/target/i386/machine.c
>> index 225b5d4..1c23e5e 100644
>> --- a/target/i386/machine.c
>> +++ b/target/i386/machine.c
>> @@ -323,6 +323,14 @@ static bool steal_time_msr_needed(void *opaque)
>>       return cpu->env.steal_time_msr != 0;
>>   }
>>   
>> +/* Poll control MSR enabled by default */
>> +static bool poll_control_msr_needed(void *opaque)
>> +{
>> +    X86CPU *cpu = opaque;
>> +
>> +    return cpu->env.poll_control_msr != 1;
>> +}
>> +
>>   static const VMStateDescription vmstate_steal_time_msr = {
>>       .name = "cpu/steal_time_msr",
>>       .version_id = 1,
>> @@ -356,6 +364,17 @@ static const VMStateDescription vmstate_pv_eoi_msr = {
>>       }
>>   };
>>   
>> +static const VMStateDescription vmstate_poll_control_msr = {
>> +    .name = "cpu/poll_control_msr",
>> +    .version_id = 1,
>> +    .minimum_version_id = 1,
>> +    .needed = poll_control_msr_needed,
>> +    .fields = (VMStateField[]) {
>> +        VMSTATE_UINT64(env.poll_control_msr, X86CPU),
>> +        VMSTATE_END_OF_LIST()
>> +    }
>> +};
>> +
>>   static bool fpop_ip_dp_needed(void *opaque)
>>   {
>>       X86CPU *cpu = opaque;
>> @@ -1062,6 +1081,7 @@ VMStateDescription vmstate_x86_cpu = {
>>           &vmstate_async_pf_msr,
>>           &vmstate_pv_eoi_msr,
>>           &vmstate_steal_time_msr,
>> +        &vmstate_poll_control_msr,
>>           &vmstate_fpop_ip_dp,
>>           &vmstate_msr_tsc_adjust,
>>           &vmstate_msr_tscdeadline,
>>
> 
> Queued, thanks.  Sorry for missing it until now.
> 
> Paolo
> 
> 

--------------4056055330F19C52E1DA679C
Content-Type: text/plain; charset=UTF-8;
 name="0001-Only-enable-the-halt-poll-control-MSR-if-it-is-suppo.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-Only-enable-the-halt-poll-control-MSR-if-it-is-suppo.pa";
 filename*1="tch"

RnJvbSBhYzgzY2I1MmJlM2ZiZTIyNjY0NWU3ODA1MDBhZGI3NjdmOWJjZmQyIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBNYXJrIEthbmRhIDxtYXJrLmthbmRhQG9yYWNsZS5j
b20+CkRhdGU6IFR1ZSwgMTYgSnVsIDIwMTkgMTQ6NDY6MTEgLTA1MDAKU3ViamVjdDogW1BB
VENIIFFFTVVdIE9ubHkgZW5hYmxlIHRoZSBoYWx0IHBvbGwgY29udHJvbCBNU1IgaWYgaXQg
aXMgc3VwcG9ydGVkCiBieSB0aGUgaG9zdAoKVGhlIGhhbHQgcG9sbCBjb250cm9sIE1TUiBz
aG91bGQgb25seSBiZSBlbmFibGVkIG9uIGhvc3RzIHdoaWNoCnN1cHBvcnQgaXQuCgpGaXhl
czogKCJrdm06IGkzODY6IGhhbHQgcG9sbCBjb250cm9sIE1TUiBzdXBwb3J0IikKClNpZ25l
ZC1vZmYtYnk6IE1hcmsgS2FuZGEgPG1hcmsua2FuZGFAb3JhY2xlLmNvbT4KLS0tCiB0YXJn
ZXQvaTM4Ni9jcHUuYyAgICAgfCA4ICsrKysrKystCiB0YXJnZXQvaTM4Ni9rdm0uYyAgICAg
fCAyIC0tCiB0YXJnZXQvaTM4Ni9tYWNoaW5lLmMgfCAxIC0KIDMgZmlsZXMgY2hhbmdlZCwg
NyBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL3RhcmdldC9p
Mzg2L2NwdS5jIGIvdGFyZ2V0L2kzODYvY3B1LmMKaW5kZXggYThiYWZkYjhiOS4uZGFjYmY3
YTlmZSAxMDA2NDQKLS0tIGEvdGFyZ2V0L2kzODYvY3B1LmMKKysrIGIvdGFyZ2V0L2kzODYv
Y3B1LmMKQEAgLTI4MzgsNyArMjgzOCw2IEBAIHN0YXRpYyBQcm9wVmFsdWUga3ZtX2RlZmF1
bHRfcHJvcHNbXSA9IHsKICAgICB7ICJrdm0tYXN5bmNwZiIsICJvbiIgfSwKICAgICB7ICJr
dm0tc3RlYWwtdGltZSIsICJvbiIgfSwKICAgICB7ICJrdm0tcHYtZW9pIiwgIm9uIiB9LAot
ICAgIHsgImt2bS1wb2xsLWNvbnRyb2wiLCAib24iIH0sCiAgICAgeyAia3ZtY2xvY2stc3Rh
YmxlLWJpdCIsICJvbiIgfSwKICAgICB7ICJ4MmFwaWMiLCAib24iIH0sCiAgICAgeyAiYWNw
aSIsICJvZmYiIH0sCkBAIC01MTA5LDYgKzUxMDgsMTMgQEAgc3RhdGljIHZvaWQgeDg2X2Nw
dV9leHBhbmRfZmVhdHVyZXMoWDg2Q1BVICpjcHUsIEVycm9yICoqZXJycCkKICAgICAgICAg
ZW52LT5jcHVpZF94bGV2ZWwyID0gZW52LT5jcHVpZF9taW5feGxldmVsMjsKICAgICB9CiAK
KyAgICAvKiBFbmFibGUgdGhlIGhhbHQgcG9sbCBjb250cm9sIE1TUiBpZiBpdCBpcyBzdXBw
b3J0ZWQgYnkgdGhlIGhvc3QgKi8KKyAgICBpZiAoeDg2X2NwdV9nZXRfc3VwcG9ydGVkX2Zl
YXR1cmVfd29yZChGRUFUX0tWTSwgY3B1LT5taWdyYXRhYmxlKSAmCisgICAgICAgICgxIDw8
IEtWTV9GRUFUVVJFX1BPTExfQ09OVFJPTCkpIHsKKyAgICAgICAgZW52LT5mZWF0dXJlc1tG
RUFUX0tWTV0gfD0gMSA8PCBLVk1fRkVBVFVSRV9QT0xMX0NPTlRST0w7CisgICAgICAgIGVu
di0+cG9sbF9jb250cm9sX21zciA9IDE7CisgICAgfQorCiBvdXQ6CiAgICAgaWYgKGxvY2Fs
X2VyciAhPSBOVUxMKSB7CiAgICAgICAgIGVycm9yX3Byb3BhZ2F0ZShlcnJwLCBsb2NhbF9l
cnIpOwpkaWZmIC0tZ2l0IGEvdGFyZ2V0L2kzODYva3ZtLmMgYi90YXJnZXQvaTM4Ni9rdm0u
YwppbmRleCBjYjIyNjg0MTM5Li44MWRkNWQyYzFiIDEwMDY0NAotLS0gYS90YXJnZXQvaTM4
Ni9rdm0uYworKysgYi90YXJnZXQvaTM4Ni9rdm0uYwpAQCAtMTc5Niw4ICsxNzk2LDYgQEAg
dm9pZCBrdm1fYXJjaF9yZXNldF92Y3B1KFg4NkNQVSAqY3B1KQogCiAgICAgICAgIGh5cGVy
dl94ODZfc3luaWNfcmVzZXQoY3B1KTsKICAgICB9Ci0gICAgLyogZW5hYmxlZCBieSBkZWZh
dWx0ICovCi0gICAgZW52LT5wb2xsX2NvbnRyb2xfbXNyID0gMTsKIH0KIAogdm9pZCBrdm1f
YXJjaF9kb19pbml0X3ZjcHUoWDg2Q1BVICpjcHUpCmRpZmYgLS1naXQgYS90YXJnZXQvaTM4
Ni9tYWNoaW5lLmMgYi90YXJnZXQvaTM4Ni9tYWNoaW5lLmMKaW5kZXggMjAwNzdhOGE1YS4u
OWQ2MDk1YjI2NCAxMDA2NDQKLS0tIGEvdGFyZ2V0L2kzODYvbWFjaGluZS5jCisrKyBiL3Rh
cmdldC9pMzg2L21hY2hpbmUuYwpAQCAtMzk0LDcgKzM5NCw2IEBAIHN0YXRpYyBib29sIHN0
ZWFsX3RpbWVfbXNyX25lZWRlZCh2b2lkICpvcGFxdWUpCiAgICAgcmV0dXJuIGNwdS0+ZW52
LnN0ZWFsX3RpbWVfbXNyICE9IDA7CiB9CiAKLS8qIFBvbGwgY29udHJvbCBNU1IgZW5hYmxl
ZCBieSBkZWZhdWx0ICovCiBzdGF0aWMgYm9vbCBwb2xsX2NvbnRyb2xfbXNyX25lZWRlZCh2
b2lkICpvcGFxdWUpCiB7CiAgICAgWDg2Q1BVICpjcHUgPSBvcGFxdWU7Ci0tIAoyLjIxLjAK
Cg==
--------------4056055330F19C52E1DA679C--

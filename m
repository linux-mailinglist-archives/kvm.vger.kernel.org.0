Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8C4164EFE
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 20:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgBSTgS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 14:36:18 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53338 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726683AbgBSTgS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Feb 2020 14:36:18 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01JJYNuO069413
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2020 14:36:16 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y8uedj4fb-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2020 14:36:15 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Wed, 19 Feb 2020 19:36:13 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 19 Feb 2020 19:36:10 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01JJa6Lf61341922
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 19:36:06 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3AD7E11C052;
        Wed, 19 Feb 2020 19:36:06 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8EEC611C050;
        Wed, 19 Feb 2020 19:36:05 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.166.21])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Feb 2020 19:36:05 +0000 (GMT)
Subject: Re: [PATCH v2 31/42] KVM: s390: protvirt: Report CPU state to
 Ultravisor
To:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20200214222658.12946-1-borntraeger@de.ibm.com>
 <20200214222658.12946-32-borntraeger@de.ibm.com>
 <33cffbe7-9d87-d94f-dc56-6d31ea2e56eb@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Wed, 19 Feb 2020 20:36:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <33cffbe7-9d87-d94f-dc56-6d31ea2e56eb@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20021919-0020-0000-0000-000003ABB331
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021919-0021-0000-0000-00002203B59E
Message-Id: <7e74ad84-b0ae-9dc1-91cc-52be989d6c34@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-19_05:2020-02-19,2020-02-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002190150
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 18.02.20 10:48, David Hildenbrand wrote:
> On 14.02.20 23:26, Christian Borntraeger wrote:
>> From: Janosch Frank <frankja@linux.ibm.com>
>>
>> VCPU states have to be reported to the ultravisor for SIGP
>> interpretation, kdump, kexec and reboot.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
>>  arch/s390/include/asm/uv.h | 15 +++++++++++++++
>>  arch/s390/kvm/kvm-s390.c   |  7 ++++++-
>>  arch/s390/kvm/kvm-s390.h   |  2 ++
>>  arch/s390/kvm/pv.c         | 22 ++++++++++++++++++++++
>>  4 files changed, 45 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
>> index 254d5769d136..7b82881ec3b4 100644
>> --- a/arch/s390/include/asm/uv.h
>> +++ b/arch/s390/include/asm/uv.h
>> @@ -37,6 +37,7 @@
>>  #define UVC_CMD_UNPACK_IMG		0x0301
>>  #define UVC_CMD_VERIFY_IMG		0x0302
>>  #define UVC_CMD_PREPARE_RESET		0x0320
>> +#define UVC_CMD_CPU_SET_STATE		0x0330
>>  #define UVC_CMD_SET_UNSHARE_ALL		0x0340
>>  #define UVC_CMD_PIN_PAGE_SHARED		0x0341
>>  #define UVC_CMD_UNPIN_PAGE_SHARED	0x0342
>> @@ -58,6 +59,7 @@ enum uv_cmds_inst {
>>  	BIT_UVC_CMD_SET_SEC_PARMS = 11,
>>  	BIT_UVC_CMD_UNPACK_IMG = 13,
>>  	BIT_UVC_CMD_VERIFY_IMG = 14,
>> +	BIT_UVC_CMD_CPU_SET_STATE = 17,
>>  	BIT_UVC_CMD_PREPARE_RESET = 18,
>>  	BIT_UVC_CMD_UNSHARE_ALL = 20,
>>  	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
>> @@ -164,6 +166,19 @@ struct uv_cb_unp {
>>  	u64 reserved38[3];
>>  } __packed __aligned(8);
>>  
>> +#define PV_CPU_STATE_OPR	1
>> +#define PV_CPU_STATE_STP	2
>> +#define PV_CPU_STATE_CHKSTP	3
>> +
>> +struct uv_cb_cpu_set_state {
>> +	struct uv_cb_header header;
>> +	u64 reserved08[2];
>> +	u64 cpu_handle;
>> +	u8  reserved20[7];
>> +	u8  state;
>> +	u64 reserved28[5];
>> +};
>> +
>>  /*
>>   * A common UV call struct for calls that take no payload
>>   * Examples:
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index ad84c1144908..5426b01e3da1 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -4396,6 +4396,7 @@ static void __enable_ibs_on_vcpu(struct kvm_vcpu *vcpu)
>>  void kvm_s390_vcpu_start(struct kvm_vcpu *vcpu)
>>  {
>>  	int i, online_vcpus, started_vcpus = 0;
>> +	u16 rc, rrc;
>>  
>>  	if (!is_vcpu_stopped(vcpu))
>>  		return;
>> @@ -4421,7 +4422,8 @@ void kvm_s390_vcpu_start(struct kvm_vcpu *vcpu)
>>  		 */
>>  		__disable_ibs_on_all_vcpus(vcpu->kvm);
>>  	}
>> -
>> +	/* Let's tell the UV that we want to start again */
>> +	kvm_s390_pv_set_cpu_state(vcpu, PV_CPU_STATE_OPR, &rc, &rrc);
>>  	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_STOPPED);
>>  	/*
>>  	 * Another VCPU might have used IBS while we were offline.
>> @@ -4436,6 +4438,7 @@ void kvm_s390_vcpu_stop(struct kvm_vcpu *vcpu)
>>  {
>>  	int i, online_vcpus, started_vcpus = 0;
>>  	struct kvm_vcpu *started_vcpu = NULL;
>> +	u16 rc, rrc;
>>  
>>  	if (is_vcpu_stopped(vcpu))
>>  		return;
>> @@ -4449,6 +4452,8 @@ void kvm_s390_vcpu_stop(struct kvm_vcpu *vcpu)
>>  	kvm_s390_clear_stop_irq(vcpu);
>>  
>>  	kvm_s390_set_cpuflags(vcpu, CPUSTAT_STOPPED);
>> +	/* Let's tell the UV that we successfully stopped the vcpu */
>> +	kvm_s390_pv_set_cpu_state(vcpu, PV_CPU_STATE_STP, &rc, &rrc);
>>  	__disable_ibs_on_vcpu(vcpu);
>>  
>>  	for (i = 0; i < online_vcpus; i++) {
>> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
>> index d5503dd0d1e4..1af1e30beead 100644
>> --- a/arch/s390/kvm/kvm-s390.h
>> +++ b/arch/s390/kvm/kvm-s390.h
>> @@ -218,6 +218,8 @@ int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
>>  			      u16 *rrc);
>>  int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
>>  		       unsigned long tweak, u16 *rc, u16 *rrc);
>> +int kvm_s390_pv_set_cpu_state(struct kvm_vcpu *vcpu, u8 state, u16 *rc,
>> +			      u16 *rrc);
>>  
>>  static inline bool kvm_s390_pv_is_protected(struct kvm *kvm)
>>  {
>> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
>> index 80169a9b43ec..b4bf6b6eb708 100644
>> --- a/arch/s390/kvm/pv.c
>> +++ b/arch/s390/kvm/pv.c
>> @@ -271,3 +271,25 @@ int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
>>  		KVM_UV_EVENT(kvm, 3, "%s", "PROTVIRT VM UNPACK: successful");
>>  	return ret;
>>  }
>> +
>> +int kvm_s390_pv_set_cpu_state(struct kvm_vcpu *vcpu, u8 state, u16 *rc,
>> +			      u16 *rrc)
>> +{
>> +	struct uv_cb_cpu_set_state uvcb = {
>> +		.header.cmd	= UVC_CMD_CPU_SET_STATE,
>> +		.header.len	= sizeof(uvcb),
>> +		.cpu_handle	= kvm_s390_pv_handle_cpu(vcpu),
>> +		.state		= state,
>> +	};
>> +	int cc;
>> +
>> +	if (!kvm_s390_pv_handle_cpu(vcpu))
> 
> I'd actually prefer to move this to the caller. (and sue the _protected
> variant)

ack this makes sense.
> 
>> +		return -EINVAL;
>> +
>> +	cc = uv_call(0, (u64)&uvcb);
>> +	*rc = uvcb.header.rc;
>> +	*rrc = uvcb.header.rrc;
>> +	if (cc)
>> +		return -EINVAL;
> 
> All return values are ignored. warn instead and make this a void function?

Hmm, I think userspace can trigger errors (e.g. invalid state or invalid point in time)
So Warning is not good.  We should actually return an error to userspace I guess.

by requiring user sigp for protvirt we can minimize the changes.
Something like this on top of the current tree


diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 7bc63e0ed740..5c99a0441f70 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2441,6 +2441,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	case KVM_S390_PV_COMMAND: {
 		struct kvm_pv_cmd args;
 
+		/* protvirt means user sigp */
+		kvm->arch.user_cpu_state_ctrl = 1;
 		r = 0;
 		if (!is_prot_virt_host()) {
 			r = -EINVAL;
@@ -3702,17 +3704,17 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 
 	switch (mp_state->mp_state) {
 	case KVM_MP_STATE_STOPPED:
-		kvm_s390_vcpu_stop(vcpu);
+		rc = kvm_s390_vcpu_stop(vcpu);
 		break;
 	case KVM_MP_STATE_OPERATING:
-		kvm_s390_vcpu_start(vcpu);
+		rc = kvm_s390_vcpu_start(vcpu);
 		break;
 	case KVM_MP_STATE_LOAD:
 		if (!kvm_s390_pv_cpu_is_protected(vcpu)) {
 			rc = -ENXIO;
 			break;
 		}
-		kvm_s390_pv_set_cpu_state(vcpu, PV_CPU_STATE_OPR_LOAD);
+		rc = kvm_s390_pv_set_cpu_state(vcpu, PV_CPU_STATE_OPR_LOAD);
 		break;
 	case KVM_MP_STATE_CHECK_STOP:
 		/* fall through - CHECK_STOP and LOAD are not supported yet */
@@ -4444,12 +4446,12 @@ static void __enable_ibs_on_vcpu(struct kvm_vcpu *vcpu)
 	kvm_s390_sync_request(KVM_REQ_ENABLE_IBS, vcpu);
 }
 
-void kvm_s390_vcpu_start(struct kvm_vcpu *vcpu)
+int kvm_s390_vcpu_start(struct kvm_vcpu *vcpu)
 {
-	int i, online_vcpus, started_vcpus = 0;
+	int i, online_vcpus, r= 0, started_vcpus = 0;
 
 	if (!is_vcpu_stopped(vcpu))
-		return;
+		return 0;
 
 	trace_kvm_s390_vcpu_start_stop(vcpu->vcpu_id, 1);
 	/* Only one cpu at a time may enter/leave the STOPPED state. */
@@ -4473,7 +4475,8 @@ void kvm_s390_vcpu_start(struct kvm_vcpu *vcpu)
 		__disable_ibs_on_all_vcpus(vcpu->kvm);
 	}
 	/* Let's tell the UV that we want to start again */
-	kvm_s390_pv_set_cpu_state(vcpu, PV_CPU_STATE_OPR);
+	if (kvm_s390_pv_cpu_is_protected(vcpu))
+		r = kvm_s390_pv_set_cpu_state(vcpu, PV_CPU_STATE_OPR);
 	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_STOPPED);
 	/*
 	 * The real PSW might have changed due to a RESTART interpreted by the
@@ -4488,16 +4491,16 @@ void kvm_s390_vcpu_start(struct kvm_vcpu *vcpu)
 	 */
 	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
 	spin_unlock(&vcpu->kvm->arch.start_stop_lock);
-	return;
+	return r;
 }
 
-void kvm_s390_vcpu_stop(struct kvm_vcpu *vcpu)
+int kvm_s390_vcpu_stop(struct kvm_vcpu *vcpu)
 {
-	int i, online_vcpus, started_vcpus = 0;
+	int i, online_vcpus, r = 0, started_vcpus = 0;
 	struct kvm_vcpu *started_vcpu = NULL;
 
 	if (is_vcpu_stopped(vcpu))
-		return;
+		return 0;
 
 	trace_kvm_s390_vcpu_start_stop(vcpu->vcpu_id, 0);
 	/* Only one cpu at a time may enter/leave the STOPPED state. */
@@ -4509,7 +4512,8 @@ void kvm_s390_vcpu_stop(struct kvm_vcpu *vcpu)
 
 	kvm_s390_set_cpuflags(vcpu, CPUSTAT_STOPPED);
 	/* Let's tell the UV that we successfully stopped the vcpu */
-	kvm_s390_pv_set_cpu_state(vcpu, PV_CPU_STATE_STP);
+	if (kvm_s390_pv_cpu_is_protected(vcpu))
+		r = kvm_s390_pv_set_cpu_state(vcpu, PV_CPU_STATE_STP);
 	__disable_ibs_on_vcpu(vcpu);
 
 	for (i = 0; i < online_vcpus; i++) {
@@ -4528,7 +4532,7 @@ void kvm_s390_vcpu_stop(struct kvm_vcpu *vcpu)
 	}
 
 	spin_unlock(&vcpu->kvm->arch.start_stop_lock);
-	return;
+	return r;
 }
 
 static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index cd05c1bbda0e..e9e1996d643b 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -333,8 +333,8 @@ void kvm_s390_set_tod_clock(struct kvm *kvm,
 long kvm_arch_fault_in_page(struct kvm_vcpu *vcpu, gpa_t gpa, int writable);
 int kvm_s390_store_status_unloaded(struct kvm_vcpu *vcpu, unsigned long addr);
 int kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu, unsigned long addr);
-void kvm_s390_vcpu_start(struct kvm_vcpu *vcpu);
-void kvm_s390_vcpu_stop(struct kvm_vcpu *vcpu);
+int kvm_s390_vcpu_start(struct kvm_vcpu *vcpu);
+int kvm_s390_vcpu_stop(struct kvm_vcpu *vcpu);
 void kvm_s390_vcpu_block(struct kvm_vcpu *vcpu);
 void kvm_s390_vcpu_unblock(struct kvm_vcpu *vcpu);
 bool kvm_s390_vcpu_sie_inhibited(struct kvm_vcpu *vcpu);


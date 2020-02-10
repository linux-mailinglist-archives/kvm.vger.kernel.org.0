Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3F551571C0
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 10:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbgBJJeC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 04:34:02 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17588 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726621AbgBJJeC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Feb 2020 04:34:02 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01A9WccM047434
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2020 04:34:01 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y1tn4f0t9-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2020 04:34:01 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 10 Feb 2020 09:33:58 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 10 Feb 2020 09:33:55 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01A9X00b45351232
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Feb 2020 09:33:00 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC02711C05B;
        Mon, 10 Feb 2020 09:33:53 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74AFD11C050;
        Mon, 10 Feb 2020 09:33:53 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.98.183])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 Feb 2020 09:33:53 +0000 (GMT)
Subject: Re: [PATCH 25/35] KVM: s390: protvirt: Only sync fmt4 registers
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
 <20200207113958.7320-26-borntraeger@de.ibm.com>
 <cbb6ae42-5320-e6cf-214d-a81602a359cf@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Mon, 10 Feb 2020 10:33:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <cbb6ae42-5320-e6cf-214d-a81602a359cf@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20021009-0012-0000-0000-000003856F23
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021009-0013-0000-0000-000021C1E577
Message-Id: <4b676484-100d-694a-fcea-4ab2bd9411e2@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-10_02:2020-02-07,2020-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 phishscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002100076
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09.02.20 16:50, Thomas Huth wrote:
> On 07/02/2020 12.39, Christian Borntraeger wrote:
>> From: Janosch Frank <frankja@linux.ibm.com>
>>
>> A lot of the registers are controlled by the Ultravisor and never
>> visible to KVM. Also some registers are overlayed, like gbea is with
>> sidad, which might leak data to userspace.
>>
>> Hence we sync a minimal set of registers for both SIE formats and then
>> check and sync format 2 registers if necessary.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
>>  arch/s390/kvm/kvm-s390.c | 116 ++++++++++++++++++++++++---------------
>>  1 file changed, 72 insertions(+), 44 deletions(-)
>>
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index f995040102ea..7df48cc942fd 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -3447,9 +3447,11 @@ static void kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
>>  	vcpu->arch.sie_block->gcr[0] = CR0_INITIAL_MASK;
>>  	vcpu->arch.sie_block->gcr[14] = CR14_INITIAL_MASK;
>>  	vcpu->run->s.regs.fpc = 0;
>> -	vcpu->arch.sie_block->gbea = 1;
>> -	vcpu->arch.sie_block->pp = 0;
>> -	vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
>> +	if (!kvm_s390_pv_handle_cpu(vcpu)) {
>> +		vcpu->arch.sie_block->gbea = 1;
>> +		vcpu->arch.sie_block->pp = 0;
>> +		vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
>> +	}
> 
> Technically, this part is not about sync'ing but about reset ... worth
> to mention this in the patch description, too? (or maybe even move to
> the reset patch 34/35 or a new patch?)

Will move into a separate patch. 
> 
> And what about vcpu->arch.sie_block->todpr ? Should that be moved into
> the if-statement, too?

Yes, todpr is not accessible by the KVM and should go in here 


> 
>>  }
>>  
>>  static void kvm_arch_vcpu_ioctl_clear_reset(struct kvm_vcpu *vcpu)
>> @@ -4060,25 +4062,16 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
>>  	return rc;
>>  }
>>  
>> -static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>> +static void sync_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>>  {
>>  	struct runtime_instr_cb *riccb;
>>  	struct gs_cb *gscb;
>>  
>> -	riccb = (struct runtime_instr_cb *) &kvm_run->s.regs.riccb;
>> -	gscb = (struct gs_cb *) &kvm_run->s.regs.gscb;
>>  	vcpu->arch.sie_block->gpsw.mask = kvm_run->psw_mask;
>>  	vcpu->arch.sie_block->gpsw.addr = kvm_run->psw_addr;
>> -	if (kvm_run->kvm_dirty_regs & KVM_SYNC_PREFIX)
>> -		kvm_s390_set_prefix(vcpu, kvm_run->s.regs.prefix);
>> -	if (kvm_run->kvm_dirty_regs & KVM_SYNC_CRS) {
>> -		memcpy(&vcpu->arch.sie_block->gcr, &kvm_run->s.regs.crs, 128);
>> -		/* some control register changes require a tlb flush */
>> -		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
>> -	}
>> +	riccb = (struct runtime_instr_cb *) &kvm_run->s.regs.riccb;
>> +	gscb = (struct gs_cb *) &kvm_run->s.regs.gscb;
> 
> You could leave the riccb and gscb lines at the beginning to make the
> diff a little bit nicer.

ack.
> 
>>  	if (kvm_run->kvm_dirty_regs & KVM_SYNC_ARCH0) {
>> -		kvm_s390_set_cpu_timer(vcpu, kvm_run->s.regs.cputm);
>> -		vcpu->arch.sie_block->ckc = kvm_run->s.regs.ckc;
>>  		vcpu->arch.sie_block->todpr = kvm_run->s.regs.todpr;
>>  		vcpu->arch.sie_block->pp = kvm_run->s.regs.pp;
>>  		vcpu->arch.sie_block->gbea = kvm_run->s.regs.gbea;
>> @@ -4119,6 +4112,47 @@ static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>>  		vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
>>  		vcpu->arch.sie_block->fpf |= kvm_run->s.regs.bpbc ? FPF_BPBC : 0;
>>  	}
>> +	if (MACHINE_HAS_GS) {
>> +		preempt_disable();
>> +		__ctl_set_bit(2, 4);
>> +		if (current->thread.gs_cb) {
>> +			vcpu->arch.host_gscb = current->thread.gs_cb;
>> +			save_gs_cb(vcpu->arch.host_gscb);
>> +		}
>> +		if (vcpu->arch.gs_enabled) {
>> +			current->thread.gs_cb = (struct gs_cb *)
>> +						&vcpu->run->s.regs.gscb;
>> +			restore_gs_cb(current->thread.gs_cb);
>> +		}
>> +		preempt_enable();
>> +	}
>> +	/* SIE will load etoken directly from SDNX and therefore kvm_run */
>> +}
>> +
>> +static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>> +{
>> +	/*
>> +	 * at several places we have to modify our internal view to not do
>> +	 * things that are disallowed by the ultravisor. For example we must
>> +	 * not inject interrupts after specific exits (e.g. 112). We do this
>> +	 * by turning off the MIE bits of our PSW copy. To avoid getting
>> +	 * validity intercepts, we do only accept the condition code from
>> +	 * userspace.
>> +	 */
>> +	vcpu->arch.sie_block->gpsw.mask &= ~PSW_MASK_CC;
>> +	vcpu->arch.sie_block->gpsw.mask |= kvm_run->psw_mask & PSW_MASK_CC;
> 
> I think it would be cleaner to only do this for protected guests. You
> could combine it with the call to sync_regs_fmt2():
> 
> 	if (likely(!kvm_s390_pv_is_protected(vcpu->kvm))) {
> 		sync_regs_fmt2(vcpu, kvm_run);
> 	} else {
> 		vcpu->arch.sie_block->gpsw.mask &= ~PSW_MASK_CC;
> 		vcpu->arch.sie_block->gpsw.mask |= kvm_run->psw_mask &
> 						   PSW_MASK_CC;
> 	}

I like that. 

[...]
>>  static void store_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>> @@ -4161,12 +4203,9 @@ static void store_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>>  	kvm_run->s.regs.cputm = kvm_s390_get_cpu_timer(vcpu);
>>  	kvm_run->s.regs.ckc = vcpu->arch.sie_block->ckc;
>>  	kvm_run->s.regs.todpr = vcpu->arch.sie_block->todpr;
> 
> TODPR handling has been move from sync_regs() to sync_regs_fmt2() ...
> should this here move from store_regs() to store_regs_fmt2(), too?

ack.
> 
> And maybe you should also not read the sie_block->gpsw.addr (and some of
> the control registers) field in store_regs() either, i.e. move the lines
> to store_regs_fmt2()?
> 
>> -	kvm_run->s.regs.pp = vcpu->arch.sie_block->pp;
>> -	kvm_run->s.regs.gbea = vcpu->arch.sie_block->gbea;
>>  	kvm_run->s.regs.pft = vcpu->arch.pfault_token;
>>  	kvm_run->s.regs.pfs = vcpu->arch.pfault_select;
>>  	kvm_run->s.regs.pfc = vcpu->arch.pfault_compare;
>> -	kvm_run->s.regs.bpbc = (vcpu->arch.sie_block->fpf & FPF_BPBC) == FPF_BPBC;
>>  	save_access_regs(vcpu->run->s.regs.acrs);
>>  	restore_access_regs(vcpu->arch.host_acrs);
>>  	/* Save guest register state */
>> @@ -4175,19 +4214,8 @@ static void store_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>>  	/* Restore will be done lazily at return */
>>  	current->thread.fpu.fpc = vcpu->arch.host_fpregs.fpc;
>>  	current->thread.fpu.regs = vcpu->arch.host_fpregs.regs;
>> -	if (MACHINE_HAS_GS) {
>> -		__ctl_set_bit(2, 4);
>> -		if (vcpu->arch.gs_enabled)
>> -			save_gs_cb(current->thread.gs_cb);
>> -		preempt_disable();
>> -		current->thread.gs_cb = vcpu->arch.host_gscb;
>> -		restore_gs_cb(vcpu->arch.host_gscb);
>> -		preempt_enable();
>> -		if (!vcpu->arch.host_gscb)
>> -			__ctl_clear_bit(2, 4);
>> -		vcpu->arch.host_gscb = NULL;
>> -	}
>> -	/* SIE will save etoken directly into SDNX and therefore kvm_run */
>> +	if (likely(!kvm_s390_pv_is_protected(vcpu->kvm)))
>> +		store_regs_fmt2(vcpu, kvm_run);
>>  }
>>  
>>  int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>>
> 
>  Thomas
> 


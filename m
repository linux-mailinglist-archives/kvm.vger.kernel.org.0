Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABD5B15392E
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 20:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgBETil (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 14:38:41 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26468 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727116AbgBETil (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 14:38:41 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 015JbMxX076950
        for <kvm@vger.kernel.org>; Wed, 5 Feb 2020 14:38:40 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xyhn4mgwh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 14:38:39 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Wed, 5 Feb 2020 19:38:37 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 5 Feb 2020 19:38:35 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 015JcXnf51904540
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Feb 2020 19:38:33 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87A48A4053;
        Wed,  5 Feb 2020 19:38:33 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05E3DA4051;
        Wed,  5 Feb 2020 19:38:33 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.26.20])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 Feb 2020 19:38:32 +0000 (GMT)
Subject: Re: [RFCv2 22/37] KVM: s390: protvirt: handle secure guest prefix
 pages
To:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-23-borntraeger@de.ibm.com>
 <8ccf2009-d391-d91b-3088-49e950b94674@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Wed, 5 Feb 2020 20:38:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <8ccf2009-d391-d91b-3088-49e950b94674@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20020519-0008-0000-0000-000003500C15
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020519-0009-0000-0000-00004A709DB0
Message-Id: <926e038e-4662-3b5c-4c58-f8724271290c@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-05_06:2020-02-04,2020-02-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 impostorscore=0 mlxscore=0
 suspectscore=0 priorityscore=1501 malwarescore=0 bulkscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002050149
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05.02.20 12:51, David Hildenbrand wrote:
> On 03.02.20 14:19, Christian Borntraeger wrote:
>> From: Janosch Frank <frankja@linux.ibm.com>
>>
>> The SPX instruction is handled by the ulravisor. We do get a
>> notification intercept, though. Let us update our internal view.
>>
>> In addition to that, when the guest prefix page is not secure, an
>> intercept 112 (0x70) is indicated.  To avoid this for the most common
>> cases, we can make the guest prefix page protected whenever we pin it.
>> We have to deal with 112 nevertheless, e.g. when some host code triggers
>> an export (e.g. qemu dump guest memory). We can simply re-run the
>> pinning logic by doing a no-op prefix change.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  arch/s390/include/asm/kvm_host.h |  1 +
>>  arch/s390/kvm/intercept.c        | 15 +++++++++++++++
>>  arch/s390/kvm/kvm-s390.c         | 14 ++++++++++++++
>>  3 files changed, 30 insertions(+)
>>
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>> index 48f382680755..686b00ced55b 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -225,6 +225,7 @@ struct kvm_s390_sie_block {
>>  #define ICPT_PV_INT_EN	0x64
>>  #define ICPT_PV_INSTR	0x68
>>  #define ICPT_PV_NOTIF	0x6c
>> +#define ICPT_PV_PREF	0x70
>>  	__u8	icptcode;		/* 0x0050 */
>>  	__u8	icptstatus;		/* 0x0051 */
>>  	__u16	ihcpu;			/* 0x0052 */
>> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
>> index d63f9cf10360..ceba0abb1900 100644
>> --- a/arch/s390/kvm/intercept.c
>> +++ b/arch/s390/kvm/intercept.c
>> @@ -451,6 +451,15 @@ static int handle_operexc(struct kvm_vcpu *vcpu)
>>  	return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
>>  }
>>  
>> +static int handle_pv_spx(struct kvm_vcpu *vcpu)
>> +{
>> +	u32 pref = *(u32 *)vcpu->arch.sie_block->sidad;
>> +
>> +	kvm_s390_set_prefix(vcpu, pref);
>> +	trace_kvm_s390_handle_prefix(vcpu, 1, pref);
>> +	return 0;
>> +}
>> +
>>  static int handle_pv_sclp(struct kvm_vcpu *vcpu)
>>  {
>>  	struct kvm_s390_float_interrupt *fi = &vcpu->kvm->arch.float_int;
>> @@ -475,6 +484,8 @@ static int handle_pv_sclp(struct kvm_vcpu *vcpu)
>>  
>>  static int handle_pv_not(struct kvm_vcpu *vcpu)
>>  {
>> +	if (vcpu->arch.sie_block->ipa == 0xb210)
>> +		return handle_pv_spx(vcpu);
>>  	if (vcpu->arch.sie_block->ipa == 0xb220)
>>  		return handle_pv_sclp(vcpu);
>>  
>> @@ -533,6 +544,10 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
>>  	case ICPT_PV_NOTIF:
>>  		rc = handle_pv_not(vcpu);
>>  		break;
>> +	case ICPT_PV_PREF:
>> +		rc = 0;
>> +		kvm_s390_set_prefix(vcpu, kvm_s390_get_prefix(vcpu));
> 
> /me confused
> 
> This is the "request to map prefix" case, right?

right. 
> 
> I'd *really* prefer to have a comment and a manual
> 
> /* request to convert and pin the prefix pages again */
> kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu)

I have no objection, this should also work.
Fixed.


> 
> A TLB flush is IMHO not necessary, as the prefix did not change.
> 
>> +		break;
>>  	default:
>>  		return -EOPNOTSUPP;
>>  	}
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 76303b0f1226..6e74c7afae3a 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -3675,6 +3675,20 @@ static int kvm_s390_handle_requests(struct kvm_vcpu *vcpu)
>>  		rc = gmap_mprotect_notify(vcpu->arch.gmap,
>>  					  kvm_s390_get_prefix(vcpu),
>>  					  PAGE_SIZE * 2, PROT_WRITE);
>> +		if (!rc && kvm_s390_pv_is_protected(vcpu->kvm)) {
>> +			do {
>> +				rc = uv_convert_to_secure(
>> +						vcpu->arch.gmap,
>> +						kvm_s390_get_prefix(vcpu));
>> +			} while (rc == -EAGAIN);
>> +			WARN_ONCE(rc, "Error while importing first prefix page. rc %d", rc);
>> +			do {
>> +				rc = uv_convert_to_secure(
>> +						vcpu->arch.gmap,
>> +						kvm_s390_get_prefix(vcpu) + PAGE_SIZE);
>> +			} while (rc == -EAGAIN);
>> +			WARN_ONCE(rc, "Error while importing second prefix page. rc %d", rc);
> 
> Maybe factor that out into a separate function (e.g., for a single page
> and call that twice).

I will wait until the memory management work is complete (we are almost there).


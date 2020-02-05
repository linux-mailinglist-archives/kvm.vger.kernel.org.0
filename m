Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 595891527B7
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 09:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbgBEIzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 03:55:20 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61312 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727068AbgBEIzT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 03:55:19 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0158ofO5070466
        for <kvm@vger.kernel.org>; Wed, 5 Feb 2020 03:55:18 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xyphvygaw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 03:55:18 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mimu@linux.ibm.com>;
        Wed, 5 Feb 2020 08:55:16 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 5 Feb 2020 08:55:14 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0158tCeM48627896
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Feb 2020 08:55:12 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C658152050;
        Wed,  5 Feb 2020 08:55:12 +0000 (GMT)
Received: from [9.152.99.235] (unknown [9.152.99.235])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6701D5204E;
        Wed,  5 Feb 2020 08:55:12 +0000 (GMT)
Reply-To: mimu@linux.ibm.com
Subject: Re: [RFCv2 14/37] KVM: s390: protvirt: Add interruption injection
 controls
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-15-borntraeger@de.ibm.com>
 <aa5c40bf-2fa9-f52a-716a-518756caf02a@redhat.com>
 <0935f33f-0b9b-d059-516c-ff2849eb4506@de.ibm.com>
From:   Michael Mueller <mimu@linux.ibm.com>
Organization: IBM
Date:   Wed, 5 Feb 2020 09:56:23 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <0935f33f-0b9b-d059-516c-ff2849eb4506@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20020508-4275-0000-0000-0000039E17CE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020508-4276-0000-0000-000038B2414A
Message-Id: <d256ac8e-d9b2-26aa-7cb1-9389ae8deff3@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-05_02:2020-02-04,2020-02-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 suspectscore=0 phishscore=0
 mlxlogscore=877 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002050071
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05.02.20 09:46, Christian Borntraeger wrote:
> 
> On 05.02.20 07:59, Thomas Huth wrote:
>> On 03/02/2020 14.19, Christian Borntraeger wrote:
>>> From: Michael Mueller <mimu@linux.ibm.com>
>>>
>>> Define the interruption injection codes and the related fields in the
>>> sie control block for PVM interruption injection.
>>
>> You seem to only add the details for external interrupts and I/O
>> interrupts here? Maybe mention this in the description ... otherwise it
>> is confusing when you read patch 17 later ... or maybe merge this patch
>> here with patch 17 ?
> 
> What about the following:
> 
> 
> This defines the necessary data structures in the SIE control block to
> inject external and I/O interrupts. We first define the the interrupt
> injection control, which defines the next interrupt to inject. Then we
> define the fields that contain the payload for external and I/O
> interrupts. The definitions for machine checks come in a later patch.

We just made a comment on that in parallel. Ok with me as well. :)

> 
>>
>>> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
>>> ---
>>>   arch/s390/include/asm/kvm_host.h | 25 +++++++++++++++++++++----
>>>   1 file changed, 21 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>>> index 58845b315be0..a45d10d87a8a 100644
>>> --- a/arch/s390/include/asm/kvm_host.h
>>> +++ b/arch/s390/include/asm/kvm_host.h
>>> @@ -222,7 +222,15 @@ struct kvm_s390_sie_block {
>>>   	__u8	icptcode;		/* 0x0050 */
>>>   	__u8	icptstatus;		/* 0x0051 */
>>>   	__u16	ihcpu;			/* 0x0052 */
>>> -	__u8	reserved54[2];		/* 0x0054 */
>>> +	__u8	reserved54;		/* 0x0054 */
>>> +#define IICTL_CODE_NONE		 0x00
>>> +#define IICTL_CODE_MCHK		 0x01
>>> +#define IICTL_CODE_EXT		 0x02
>>> +#define IICTL_CODE_IO		 0x03
>>> +#define IICTL_CODE_RESTART	 0x04
>>> +#define IICTL_CODE_SPECIFICATION 0x10
>>> +#define IICTL_CODE_OPERAND	 0x11
>>> +	__u8	iictl;			/* 0x0055 */
>>>   	__u16	ipa;			/* 0x0056 */
>>>   	__u32	ipb;			/* 0x0058 */
>>>   	__u32	scaoh;			/* 0x005c */
>>> @@ -259,7 +267,8 @@ struct kvm_s390_sie_block {
>>>   #define HPID_KVM	0x4
>>>   #define HPID_VSIE	0x5
>>>   	__u8	hpid;			/* 0x00b8 */
>>> -	__u8	reservedb9[11];		/* 0x00b9 */
>>> +	__u8	reservedb9[7];		/* 0x00b9 */
>>> +	__u32	eiparams;		/* 0x00c0 */
>>>   	__u16	extcpuaddr;		/* 0x00c4 */
>>>   	__u16	eic;			/* 0x00c6 */
>>>   	__u32	reservedc8;		/* 0x00c8 */
>>> @@ -275,8 +284,16 @@ struct kvm_s390_sie_block {
>>>   	__u8	oai;			/* 0x00e2 */
>>>   	__u8	armid;			/* 0x00e3 */
>>>   	__u8	reservede4[4];		/* 0x00e4 */
>>> -	__u64	tecmc;			/* 0x00e8 */
>>> -	__u8	reservedf0[12];		/* 0x00f0 */
>>> +	union {
>>> +		__u64	tecmc;		/* 0x00e8 */
>>> +		struct {
>>> +			__u16	subchannel_id;	/* 0x00e8 */
>>> +			__u16	subchannel_nr;	/* 0x00ea */
>>> +			__u32	io_int_parm;	/* 0x00ec */
>>> +			__u32	io_int_word;	/* 0x00f0 */
>>> +		};
>>> +	} __packed;
>>> +	__u8	reservedf4[8];		/* 0x00f4 */
>>
>> Maybe add a comment to the new struct for which injection type it is
>> good for ... otherwise this might get hard to understand in the future
>> (especially if more stuff gets added like in patch 17).
> 
> Not sure. We usually do not have documentation inside this structure
> for other things.
> 
> 
>> Anyway,
>> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 
> thanks
> 
> 

Michael


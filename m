Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7E07FB469
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 16:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfKMP5Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 10:57:25 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44394 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727001AbfKMP5Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 10:57:25 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xADFeGUH098220
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 10:57:24 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w8mnegvet-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 10:57:23 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mimu@linux.ibm.com>;
        Wed, 13 Nov 2019 15:57:21 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 13 Nov 2019 15:57:18 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xADFvGBv43188410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 15:57:16 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65BEAAE051;
        Wed, 13 Nov 2019 15:57:16 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A1C3AE04D;
        Wed, 13 Nov 2019 15:57:16 +0000 (GMT)
Received: from [9.152.224.49] (unknown [9.152.224.49])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Nov 2019 15:57:15 +0000 (GMT)
Reply-To: mimu@linux.ibm.com
Subject: Re: [RFC 15/37] KVM: s390: protvirt: Add machine-check interruption
 injection controls
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, cohuck@redhat.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-16-frankja@linux.ibm.com>
 <6b0bef57-cbe3-99df-354e-061a12d4cc31@redhat.com>
From:   Michael Mueller <mimu@linux.ibm.com>
Organization: IBM
Date:   Wed, 13 Nov 2019 16:57:15 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <6b0bef57-cbe3-99df-354e-061a12d4cc31@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19111315-0028-0000-0000-000003B695B8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111315-0029-0000-0000-000024799E9C
Message-Id: <7ff507ad-a725-b7b4-6a6e-9ae283a0ffd2@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-13_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911130143
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13.11.19 15:49, Thomas Huth wrote:
> On 24/10/2019 13.40, Janosch Frank wrote:
>> From: Michael Mueller <mimu@linux.ibm.com>
>>
>> The following fields are added to the sie control block type 4:
>>       - Machine Check Interruption Code (mcic)
>>       - External Damage Code (edc)
>>       - Failing Storage Address (faddr)
>>
>> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_host.h | 33 +++++++++++++++++++++++---------
>>   1 file changed, 24 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>> index 63fc32d38aa9..0ab309b7bf4c 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -261,16 +261,31 @@ struct kvm_s390_sie_block {
>>   #define HPID_VSIE	0x5
>>   	__u8	hpid;			/* 0x00b8 */
>>   	__u8	reservedb9[7];		/* 0x00b9 */
>> -	__u32	eiparams;		/* 0x00c0 */
>> -	__u16	extcpuaddr;		/* 0x00c4 */
>> -	__u16	eic;			/* 0x00c6 */
>> +	union {
>> +		struct {
>> +			__u32	eiparams;	/* 0x00c0 */
>> +			__u16	extcpuaddr;	/* 0x00c4 */
>> +			__u16	eic;		/* 0x00c6 */
>> +		};
>> +		__u64	mcic;			/* 0x00c0 */
>> +	} __packed;
>>   	__u32	reservedc8;		/* 0x00c8 */
>> -	__u16	pgmilc;			/* 0x00cc */
>> -	__u16	iprcc;			/* 0x00ce */
>> -	__u32	dxc;			/* 0x00d0 */
>> -	__u16	mcn;			/* 0x00d4 */
>> -	__u8	perc;			/* 0x00d6 */
>> -	__u8	peratmid;		/* 0x00d7 */
>> +	union {
>> +		struct {
>> +			__u16	pgmilc;		/* 0x00cc */
>> +			__u16	iprcc;		/* 0x00ce */
>> +		};
>> +		__u32	edc;			/* 0x00cc */
>> +	} __packed;
>> +	union {
>> +		struct {
>> +			__u32	dxc;		/* 0x00d0 */
>> +			__u16	mcn;		/* 0x00d4 */
>> +			__u8	perc;		/* 0x00d6 */
>> +			__u8	peratmid;	/* 0x00d7 */
>> +		};
>> +		__u64	faddr;			/* 0x00d0 */
>> +	} __packed;
> 
> Maybe drop the __packed keywords since the struct members are naturally
> aligned anyway?
> 
>   Thomas
> 

Thanks, I will give it a try.

Michael


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF3815F789
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 21:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388130AbgBNUNw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 15:13:52 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59996 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387505AbgBNUNw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 15:13:52 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EK4fHw020542
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 15:13:51 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y4qyuj4a7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 15:13:51 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 14 Feb 2020 20:13:48 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 14 Feb 2020 20:13:46 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01EKDi6R35848488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 20:13:44 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE6FBA4057;
        Fri, 14 Feb 2020 20:13:44 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D43D0A4055;
        Fri, 14 Feb 2020 20:13:43 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.191.169])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Feb 2020 20:13:43 +0000 (GMT)
Subject: Re: [PATCH 07/35] KVM: s390: add new variants of UV CALL
To:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
 <20200207113958.7320-8-borntraeger@de.ibm.com>
 <b9988313-74d1-6e68-efef-d012aae30d6d@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Fri, 14 Feb 2020 21:13:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <b9988313-74d1-6e68-efef-d012aae30d6d@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20021420-0020-0000-0000-000003AA3474
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021420-0021-0000-0000-0000220224F6
Message-Id: <bb832871-8caa-30c3-1597-27bce32aa9b4@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_07:2020-02-14,2020-02-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002140146
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14.02.20 19:28, David Hildenbrand wrote:
> On 07.02.20 12:39, Christian Borntraeger wrote:
>> From: Janosch Frank <frankja@linux.ibm.com>
>>
>> This add 2 new variants of the UV CALL.
>>
>> The first variant handles UV CALLs that might have longer busy
>> conditions or just need longer when doing partial completion. We should
>> schedule when necessary.
>>
>> The second variant handles UV CALLs that only need the handle but have
>> no payload (e.g. destroying a VM). We can provide a simple wrapper for
>> those.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
>>  arch/s390/include/asm/uv.h | 59 ++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 59 insertions(+)
>>
>> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
>> index 1b97230a57ba..e1cef772fde1 100644
>> --- a/arch/s390/include/asm/uv.h
>> +++ b/arch/s390/include/asm/uv.h
>> @@ -14,6 +14,7 @@
>>  #include <linux/types.h>
>>  #include <linux/errno.h>
>>  #include <linux/bug.h>
>> +#include <linux/sched.h>
>>  #include <asm/page.h>
>>  #include <asm/gmap.h>
>>  
>> @@ -91,6 +92,19 @@ struct uv_cb_cfs {
>>  	u64 paddr;
>>  } __packed __aligned(8);
>>  
>> +/*
>> + * A common UV call struct for calls that take no payload
>> + * Examples:
>> + * Destroy cpu/config
>> + * Verify
>> + */
>> +struct uv_cb_nodata {
>> +	struct uv_cb_header header;
>> +	u64 reserved08[2];
>> +	u64 handle;
>> +	u64 reserved20[4];
>> +} __packed __aligned(8);
>> +
>>  struct uv_cb_share {
>>  	struct uv_cb_header header;
>>  	u64 reserved08[3];
>> @@ -98,6 +112,31 @@ struct uv_cb_share {
>>  	u64 reserved28;
>>  } __packed __aligned(8);
>>  
>> +/*
>> + * Low level uv_call that takes r1 and r2 as parameter and avoids
>> + * stalls for long running busy conditions by doing schedule
>> + */
>> +static inline int uv_call_sched(unsigned long r1, unsigned long r2)
>> +{
>> +	int cc;
>> +
>> +	do {
>> +		asm volatile(
>> +			"0:	.insn rrf,0xB9A40000,%[r1],%[r2],0,0\n"
> 
> label not necessary

ack
> 
>> +			"		ipm	%[cc]\n"
>> +			"		srl	%[cc],28\n"
>> +			: [cc] "=d" (cc)
>> +			: [r1] "d" (r1), [r2] "d" (r2)
>> +			: "memory", "cc");
> 
> I was wondering if we could reuse uv_call() - something like
> 
> static inline int __uv_call(unsigned long r1, unsigned long r2)
> {
> 	int cc;
> 
> 	asm volatile(
> 		"	.insn rrf,0xB9A40000,%[r1],%[r2],0,0\n"
> 		"		ipm	%[cc]\n"
> 		"		srl	%[cc],28\n"
> 		: [cc] "=d" (cc)
> 		: [r1] "a" (r1), [r2] "a" (r2)
> 		: "memory", "cc");
> 	return cc;
> }
> 
> static inline int uv_call(unsigned long r1, unsigned long r2)
> {
> 	int rc;
> 
> 	do {
> 		cc = __uv_call(unsigned long r1, unsigned long r2);
> 	} while (cc > 1)
> 	return rc;

This will likely generate less efficient assembly code but it is certainly
easier to read. WIll change. 
> }
> 
> static inline int uv_call_sched(unsigned long r1, unsigned long r2)
> {
> 	int rc;
> 
> 	do {
> 		cc = __uv_call(unsigned long r1, unsigned long r2);
> 		cond_resched();
> 	} while (rc > 1)
> 	return rc;
> }

> 
>> +		if (need_resched())
>> +			schedule();
> 
> cond_resched();

ack

> 
>> +	} while (cc > 1);
>> +	return cc;
>> +}
>> +
>> +/*
>> + * Low level uv_call that takes r1 and r2 as parameter
>> + */
> 
> This "r1 and r2" does not sound like relevant news. Same for the other
> variant above.
> 
>>  static inline int uv_call(unsigned long r1, unsigned long r2)
>>  {
>>  	int cc;
>> @@ -113,6 +152,26 @@ static inline int uv_call(unsigned long r1, unsigned long r2)
>>  	return cc;
>>  }
>>  
>> +/*
>> + * special variant of uv_call that only transports the cpu or guest
>> + * handle and the command, like destroy or verify.
>> + */
>> +static inline int uv_cmd_nodata(u64 handle, u16 cmd, u32 *ret)
> 
> uv_call_sched_simple() ?

I think nodata is actually a better description


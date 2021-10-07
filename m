Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65119425182
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 12:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240989AbhJGKxt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 06:53:49 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39366 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240896AbhJGKxs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 06:53:48 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 197A6oHA032239;
        Thu, 7 Oct 2021 06:51:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kx9/9rufNA/SSv/k0X/iuPUjgTXo1BWWvvBwANeENzg=;
 b=VGGNTfTHacuzB5CNRo6moezsz3pEp2Qo3RDt8UqnyScq2KOV7PIUksO4zpTEdJBGKuEv
 qC5Ep7tOltfZ8PvNs72E5avvIlWTFqwcnXChIaTsNuvVHcOikzf58W1WNQ6rjqlqF/fc
 HVE+AeX9BoZ4r1YKq3KT6v/3gwBi6lwAcTAk5Y3l9RHjsb3FRQEyRp3kE3PJ2ZTfQ1Op
 l6isxulU/8jV2m8F1idTFl7Lm1b3wvvyNxLjHaK7QZDIUpZrosInk+Py4f9H7/Nq1c5X
 N6OZZwJgbBP6Jw/kyoU6WaQmcmIu6cQwjUz7cR+juS/apyJM4vy5atXRAKxCKPxJes6u fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bhu9hdtxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 06:51:54 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 197AdIDH029694;
        Thu, 7 Oct 2021 06:51:54 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bhu9hdtx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 06:51:53 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 197AhuIl025542;
        Thu, 7 Oct 2021 10:51:52 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3bef2abqp0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 10:51:52 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 197AkQdu57803030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Oct 2021 10:46:26 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCA02A4078;
        Thu,  7 Oct 2021 10:51:47 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3216AA407B;
        Thu,  7 Oct 2021 10:51:47 +0000 (GMT)
Received: from [9.145.66.140] (unknown [9.145.66.140])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Oct 2021 10:51:47 +0000 (GMT)
Message-ID: <6ed3a080-abfd-c0d0-08d3-5142ff56c960@linux.ibm.com>
Date:   Thu, 7 Oct 2021 12:51:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH v3 7/9] s390x: Add sthyi cc==0 r2+1
 verification
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, seiden@linux.ibm.com, scgl@linux.ibm.com
References: <20211007085027.13050-1-frankja@linux.ibm.com>
 <20211007085027.13050-8-frankja@linux.ibm.com>
 <18a10bec-aee5-700f-9004-b4a200dcebed@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <18a10bec-aee5-700f-9004-b4a200dcebed@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hCpD7yY7uZx0QXs8gOq-YEltQDiYo4he
X-Proofpoint-GUID: zj63pqEXlbmk-5yDNxJCyK8KmvrMDiA-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-07_01,2021-10-07_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 phishscore=0 malwarescore=0 impostorscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110070072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/7/21 11:11, Thomas Huth wrote:
> On 07/10/2021 10.50, Janosch Frank wrote:
>> On success r2 + 1 should be 0, let's also check for that.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> ---
>>    s390x/sthyi.c | 20 +++++++++++---------
>>    1 file changed, 11 insertions(+), 9 deletions(-)
>>
>> diff --git a/s390x/sthyi.c b/s390x/sthyi.c
>> index db90b56f..4b153bf4 100644
>> --- a/s390x/sthyi.c
>> +++ b/s390x/sthyi.c
>> @@ -24,16 +24,16 @@ static inline int sthyi(uint64_t vaddr, uint64_t fcode, uint64_t *rc,
>>    {
>>    	register uint64_t code asm("0") = fcode;
>>    	register uint64_t addr asm("2") = vaddr;
>> -	register uint64_t rc3 asm("3") = 0;
>> +	register uint64_t rc3 asm("3") = 42;
>>    	int cc = 0;
>>    
>> -	asm volatile(".insn rre,0xB2560000,%[r1],%[r2]\n"
>> -		     "ipm	 %[cc]\n"
>> -		     "srl	 %[cc],28\n"
>> -		     : [cc] "=d" (cc)
>> -		     : [code] "d" (code), [addr] "a" (addr), [r1] "i" (r1),
>> -		       [r2] "i" (r2)
>> -		     : "memory", "cc", "r3");
>> +	asm volatile(
>> +		".insn   rre,0xB2560000,%[r1],%[r2]\n"
>> +		"ipm     %[cc]\n"
>> +		"srl     %[cc],28\n"
>> +		: [cc] "=d" (cc), "+d" (rc3)
>> +		: [code] "d" (code), [addr] "a" (addr), [r1] "i" (r1), [r2] "i" (r2)
>> +		: "memory", "cc");
>>    	if (rc)
>>    		*rc = rc3;
>>    	return cc;
>> @@ -139,16 +139,18 @@ static void test_fcode0(void)
>>    	struct sthyi_hdr_sctn *hdr;
>>    	struct sthyi_mach_sctn *mach;
>>    	struct sthyi_par_sctn *par;
>> +	uint64_t rc = 42;
>>    
>>    	/* Zero destination memory. */
>>    	memset(pagebuf, 0, PAGE_SIZE);
>>    
>>    	report_prefix_push("fcode 0");
>> -	sthyi((uint64_t)pagebuf, 0, NULL, 0, 2);
>> +	sthyi((uint64_t)pagebuf, 0, &rc, 0, 2);
>>    	hdr = (void *)pagebuf;
>>    	mach = (void *)pagebuf + hdr->INFMOFF;
>>    	par = (void *)pagebuf + hdr->INFPOFF;
>>    
>> +	report(!rc, "r2 + 1 == 0");
> 
> Could you please check for "rc == CODE_SUCCES" (since we've got that for
> this purpose)?

I'll do one better and also check for !cc

> 
> With that change:
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 

Thanks!

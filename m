Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59DE9478D27
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 15:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236999AbhLQOPO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 09:15:14 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9774 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236980AbhLQOPJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Dec 2021 09:15:09 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BHCJcVr029045;
        Fri, 17 Dec 2021 14:15:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8qkBYpaRN89ZSojweSOZWc3BMZX2xQyNba4Y5Ed4RX8=;
 b=i3zP2HqXw1HhGuojSY8pFsLVIQdQHmCZs8XC8K6mVxzuy3n8/AXSDCqVZdU+Xpp0SRn1
 Vqm3/CrGQQO46xLsjU41C0ytngduaH/x+iJwnPZRpkbqKliM1LRGM5WoMvNmapf7AD74
 OpWvj4lDO5hAGC780ZI1wSe87AYO8I9FrF8oKBRxBLpYikne7Ieuu++eTsv8e3nwA+0U
 8yB7XsSwnaH+b2IvPGdKqNYcsnG+RSPpJOQ/6tmvO9jOQdEZlRN76fFL3dCD5pZ+vPi5
 dVw9RZwmePTFbBoX+M7XNCXKx/aGAWr0+cgc4viAhLAbjE+LrKxeua06PLRdTDj0CKI4 gA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d0tf5jdev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 14:15:09 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BHDtaeT029918;
        Fri, 17 Dec 2021 14:15:08 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d0tf5jddq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 14:15:08 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BHDxYva005842;
        Fri, 17 Dec 2021 14:15:06 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3cy77ps5bg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 14:15:05 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BHEF2rY29557034
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 14:15:02 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B59B5204E;
        Fri, 17 Dec 2021 14:15:02 +0000 (GMT)
Received: from [9.145.65.127] (unknown [9.145.65.127])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1D1C852050;
        Fri, 17 Dec 2021 14:15:02 +0000 (GMT)
Message-ID: <d2658470-8ede-bda7-8857-c2d3334d59ed@linux.ibm.com>
Date:   Fri, 17 Dec 2021 15:15:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH kvm-unit-tests 2/2] s390x: diag288: Improve readability
Content-Language: en-US
To:     Heiko Carstens <hca@linux.ibm.com>, Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <20211217103137.1293092-1-nrb@linux.ibm.com>
 <20211217103137.1293092-3-nrb@linux.ibm.com> <YbxvoacUvh8+2zQ/@osiris>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <YbxvoacUvh8+2zQ/@osiris>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2Fk1GdPJhqGhmeExfQeC2npxg_HilRL0
X-Proofpoint-ORIG-GUID: DlWeaJ1AmLtCDJVw01UyF0D8PR2d-ayF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-17_05,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 impostorscore=0 spamscore=0 mlxlogscore=859 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112170082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/21 12:08, Heiko Carstens wrote:
> On Fri, Dec 17, 2021 at 11:31:37AM +0100, Nico Boehr wrote:
>> Use a more descriptive name instead of the magic number 424 (address of
>> restart new PSW in the lowcore).
>>
>> In addition, add a comment to make it more obvious what the ASM snippet
>> does.
>>
>> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
>> ---
>>   s390x/diag288.c | 7 +++++--
>>   1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/s390x/diag288.c b/s390x/diag288.c
>> index da7b06c365bf..a2c263e38338 100644
>> --- a/s390x/diag288.c
>> +++ b/s390x/diag288.c
>> @@ -94,12 +94,15 @@ static void test_bite(void)
>>   	/* Arm watchdog */
>>   	lc->restart_new_psw.mask = extract_psw_mask() & ~PSW_MASK_EXT;
>>   	diag288(CODE_INIT, 15, ACTION_RESTART);
>> +	/* Wait for restart interruption */
>>   	asm volatile("		larl	0, 1f\n"
>> -		     "		stg	0, 424\n"
>> +		     "		stg	0, %[restart_new_psw]\n"
>>   		     "0:	nop\n"
>>   		     "		j	0b\n"
>>   		     "1:"
>> -		     : : : "0");
>> +		     :
>> +		     : [restart_new_psw] "T" (lc->restart_new_psw.addr)
> 
> Even though it was wrong and missing before: this is an output not an input
> parameter. Also, older compilers might fail if only the "T" constraint is
> given (see gcc commit 3e4be43f69da ("S/390: Memory constraint cleanup")).
> Which means: "=RT" would be correct. To be on the safe side, and to avoid
> that gcc optimizes any potential prior C code away, I'd recommend to use
> "+RT" in this case.

Thanks for clearing that up, those intricate details are quite hard to 
find/remember if you only write inline assembly every few months.

> 
> Also there is an ordering problem here: starting the time bomb before the
> restart psw has been setup is racy. It is unlikely that this fails, but
> still...
> 
> Correct would be to setup the restart psw, and then start the time
> bomb. This would also allow to shorten the runtime of this test case to
> 1 second, instead of the 15 seconds it is running now.

While you are correct, the minimum value of the timer is 15s.
Racing that will be quite hard.

@Nico but yes, while you're at it you could switch that around so I 
don't have to explain that a second time.

> 
> It was all like that before, I know. Just some comments ;)
> 


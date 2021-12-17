Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D19478D2E
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 15:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237016AbhLQOQl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 09:16:41 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36146 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234445AbhLQOQl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Dec 2021 09:16:41 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BHDXixT020649;
        Fri, 17 Dec 2021 14:16:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+SmvR6QlHynmqKIZPBMvZxcyNhOoP7RLGSoxncXSem0=;
 b=oPxOS2EiVGn7CyMdh+h0t9W2i9e1MzBTNIiCxXgmkQBhpz4oAYqEs5JD3ADN7r3NBLle
 S8/qzdR2GbwgX+Y0KxT9vARHfVrOY0RpsoBtbXvuWS724/Gmrx+3pSF2rAZN+wDvSIOQ
 OLbVK4ECYSdGGKzIaLwf4Jku6UMF5RYgmv/Zv6xfch0H/0QpW7RK+WKRn02JHuw5/1pl
 kAch1pTcEK6ohv/6fFkQ2XvLf3PUuHOp//QEjK47bzfKuA70i4X79deC0m2/uMgDBU2X
 AN00UshkJFOALfiIpS5e9AR+GKByonW85+2DNHAn1YzRvtKRxUcjvuE1LXHeuNB3pGNM Xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cyp0604x7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 14:16:40 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BHCkfre032685;
        Fri, 17 Dec 2021 14:16:40 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cyp0604wu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 14:16:40 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BHDSSVp017644;
        Fri, 17 Dec 2021 14:16:38 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3cy7k9s31c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 14:16:38 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BHEGYGx38207852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 14:16:34 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA7575204F;
        Fri, 17 Dec 2021 14:16:34 +0000 (GMT)
Received: from [9.145.65.127] (unknown [9.145.65.127])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6881352050;
        Fri, 17 Dec 2021 14:16:34 +0000 (GMT)
Message-ID: <329aced6-df4f-2802-cbc6-99469c5f9462@linux.ibm.com>
Date:   Fri, 17 Dec 2021 15:16:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH kvm-unit-tests 1/2] s390x: diag288: Add missing clobber
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>,
        kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com
References: <20211217103137.1293092-1-nrb@linux.ibm.com>
 <20211217103137.1293092-2-nrb@linux.ibm.com>
 <3e2035bd-0929-488c-28f3-d8256bec14a4@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <3e2035bd-0929-488c-28f3-d8256bec14a4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QFXic-AZ_Ao_AnP28vHkySnV1Bfk-BKJ
X-Proofpoint-ORIG-GUID: t7Dyj2ZtC-HMovL4E07nmrtpeNnWRXpr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-17_05,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 malwarescore=0 clxscore=1015 mlxlogscore=999 spamscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112170082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/21 14:47, Thomas Huth wrote:
> On 17/12/2021 11.31, Nico Boehr wrote:
>> We clobber r0 and thus should let the compiler know we're doing so.
>>
>> Because we change from basic to extended ASM, we need to change the
>> register names, as %r0 will be interpreted as a token in the assembler
>> template.
>>
>> For consistency, we align with the common style in kvm-unit-tests which
>> is just 0.
>>
>> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
>> ---
>>    s390x/diag288.c | 7 ++++---
>>    1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/s390x/diag288.c b/s390x/diag288.c
>> index 072c04a5cbd6..da7b06c365bf 100644
>> --- a/s390x/diag288.c
>> +++ b/s390x/diag288.c
>> @@ -94,11 +94,12 @@ static void test_bite(void)
>>    	/* Arm watchdog */
>>    	lc->restart_new_psw.mask = extract_psw_mask() & ~PSW_MASK_EXT;
>>    	diag288(CODE_INIT, 15, ACTION_RESTART);
>> -	asm volatile("		larl	%r0, 1f\n"
>> -		     "		stg	%r0, 424\n"
>> +	asm volatile("		larl	0, 1f\n"
>> +		     "		stg	0, 424\n"
> 
> Would it work to use %%r0 instead?

Yes, but I told him that looks weird, so that one is on me.
@claudio @thomas What's your preferred way of dealing with this?

> 
>>    		     "0:	nop\n"
>>    		     "		j	0b\n"
>> -		     "1:");
>> +		     "1:"
>> +		     : : : "0");
>>    	report_pass("restart");
>>    }
> 
> Anyway:
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 


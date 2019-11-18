Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 440B51000ED
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 10:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfKRJEP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 04:04:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7494 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726403AbfKRJEO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Nov 2019 04:04:14 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAI92Ytd107982
        for <kvm@vger.kernel.org>; Mon, 18 Nov 2019 04:04:13 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2waeh83cmm-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 18 Nov 2019 04:04:13 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Mon, 18 Nov 2019 09:04:11 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 18 Nov 2019 09:04:08 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAI9479132834034
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Nov 2019 09:04:08 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D713DA4066;
        Mon, 18 Nov 2019 09:04:07 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0500A405C;
        Mon, 18 Nov 2019 09:04:07 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.77])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 18 Nov 2019 09:04:07 +0000 (GMT)
Subject: Re: [PATCH v1 3/4] s390x:irq: make IRQ handler weak
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com
References: <1573647799-30584-1-git-send-email-pmorel@linux.ibm.com>
 <1573647799-30584-4-git-send-email-pmorel@linux.ibm.com>
 <5fc6450e-ec88-d500-7fc9-9e17e41f2dd0@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Mon, 18 Nov 2019 10:04:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <5fc6450e-ec88-d500-7fc9-9e17e41f2dd0@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19111809-0028-0000-0000-000003B9D455
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111809-0029-0000-0000-0000247CEBCD
Message-Id: <bb6d784e-cceb-98e0-b565-8ec3fc47f2e3@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-18_01:2019-11-15,2019-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 phishscore=0 impostorscore=0 bulkscore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 mlxlogscore=549
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911180082
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019-11-15 08:12, Thomas Huth wrote:
> On 13/11/2019 13.23, Pierre Morel wrote:
>> Having a weak function allows the tests programm to declare its own IRQ
>> handler.
>> This is helpfull when developping I/O tests.
>> ---
>>   lib/s390x/interrupt.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
>> index 7aecfc5..0049194 100644
>> --- a/lib/s390x/interrupt.c
>> +++ b/lib/s390x/interrupt.c
>> @@ -140,7 +140,7 @@ void handle_mcck_int(sregs_t *regs)
>>   		     lc->mcck_old_psw.addr);
>>   }
>>   
>> -void handle_io_int(sregs_t *regs)
>> +__attribute__((weak)) void handle_io_int(sregs_t *regs)
>>   {
>>   	report_abort("Unexpected io interrupt: at %#lx",
>>   		     lc->io_old_psw.addr);
>>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
>
Thanks for the review,

Pierre

-- 
Pierre Morel
IBM Lab Boeblingen


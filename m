Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888544A879F
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 16:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351862AbiBCPXb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 10:23:31 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37234 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231181AbiBCPXa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Feb 2022 10:23:30 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 213EWZlb021052
        for <kvm@vger.kernel.org>; Thu, 3 Feb 2022 15:23:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=4WLsfcPVYHI70hZua1su2/AwziIT9XBRhM68TRdhp3Y=;
 b=GzY2trlBtLkRyv7uWizccnogVohIla5nOHnDa5+kLQz3Sh9I7Ri7m2B6YV7EG/NLO0Yx
 Ml6LDkUisqV6X4FAfpayDRj7LWkg7J1E4FuT5Li5aSChGpoq2oUuCuAVZUyLS53xbRb7
 ZGGCrUVkIfybZXZ0/3m+TB4/NyEUNgbDwRDJtvOgqmZHGGbwLzbHGzNXTWBck/TbPJ+Z
 2kqEGupvx3tEqaZBAHnkNYv7KxJR+HJIry8YmkU1HM+h+SJKfPVCzrvSYI3AzUevwmQ2
 F7XXJcjr8r/oax8t+iA+mIQu6PmS8V46mHOMgj6P3LcqdiNZRPCAkPZ9zL2VkjHneeI/ +Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e04m67w7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 03 Feb 2022 15:23:29 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 213EXsJu025865
        for <kvm@vger.kernel.org>; Thu, 3 Feb 2022 15:23:29 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e04m67w6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 15:23:29 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 213FJaZZ003870;
        Thu, 3 Feb 2022 15:23:27 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3dvvujnkwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 15:23:27 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 213FDUo336569360
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Feb 2022 15:13:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED7DAAE059;
        Thu,  3 Feb 2022 15:23:23 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B846AE045;
        Thu,  3 Feb 2022 15:23:23 +0000 (GMT)
Received: from [9.145.170.250] (unknown [9.145.170.250])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Feb 2022 15:23:23 +0000 (GMT)
Message-ID: <9a38563e-3307-13df-e734-483a31822e08@linux.ibm.com>
Date:   Thu, 3 Feb 2022 16:23:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com, seiden@linux.ibm.com
References: <20220128185449.64936-1-imbrenda@linux.ibm.com>
 <f8f09670-688b-2b12-f09a-860a9edffd54@linux.ibm.com>
 <20220203143712.28b1881e@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 0/5] s390x: smp: avoid hardcoded CPU
 addresses
In-Reply-To: <20220203143712.28b1881e@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Tb61CYmu24pC3RcUBxPHpT8Fx5o2-4rd
X-Proofpoint-GUID: 8V9lgsBpgIAjD7vqPEGxTRbHc-Ghb5fP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-03_05,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 adultscore=0 suspectscore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202030090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/3/22 14:37, Claudio Imbrenda wrote:
> On Thu, 3 Feb 2022 09:45:56 +0100
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> On 1/28/22 19:54, Claudio Imbrenda wrote:
>>> On s390x there are no guarantees about the CPU addresses, except that
>>> they shall be unique. This means that in some environments, it's
>>> possible that there is no match between the CPU address and its
>>> position (index) in the list of available CPUs returned by the system.
>>
>> While I support this patch set I've yet to find an environment where
>> this gave me headaches.
>>
>>>
>>> This series fixes a small bug in the SMP initialization code, adds a
>>> guarantee that the boot CPU will always have index 0, and introduces
>>> some functions to allow tests to use CPU indexes instead of using
>>> hardcoded CPU addresses. This will allow the tests to run successfully
>>> in more environments (e.g. z/VM, LPAR).
>>
>> I'm wondering if we should do it the other way round and make the smp_*
>> functions take a idx instead of a cpu addr. The only instance where this
>> gets a bit ugly is the sigp calls which we would also need to convert.
> 
> yes, in fact this is something I was already planning to do :)

Do you want to add that in a v2 to reduce the additional churn?

> 
> for sigp, we can either convert, or add a wrapper with idx.

How about adding a wrapper to smp.c?

smp_cpu_sigp()
smp_cpu_sigp_retry()


That would fall in line with the naming of the smp functions and it's 
clear that we refer to a specific cpu from the smp lib.

We can then leave the sigp.h functions as is so Nico can use them for 
the invalid addr tests.

> 
>>
>>> Some existing tests are adapted to take advantage of the new
>>> functionalities.
>>>
>>> Claudio Imbrenda (5):
>>>     lib: s390x: smp: add functions to work with CPU indexes
>>>     lib: s390x: smp: guarantee that boot CPU has index 0
>>>     s390x: smp: avoid hardcoded CPU addresses
>>>     s390x: firq: avoid hardcoded CPU addresses
>>>     s390x: skrf: avoid hardcoded CPU addresses
>>>
>>>    lib/s390x/smp.h |  2 ++
>>>    lib/s390x/smp.c | 28 ++++++++++++-----
>>>    s390x/firq.c    | 17 +++++-----
>>>    s390x/skrf.c    |  8 +++--
>>>    s390x/smp.c     | 83 ++++++++++++++++++++++++++-----------------------
>>>    5 files changed, 79 insertions(+), 59 deletions(-)
>>>    
>>
> 


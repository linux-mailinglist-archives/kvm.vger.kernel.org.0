Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8A23F96F1
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 11:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244829AbhH0J1k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 05:27:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8480 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244846AbhH0J1f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 05:27:35 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17R9EWTI118825
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 05:26:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=HVxrT06A059JG5/EG4EZfg7HX3zY2lLjVJ6cjyJfYwY=;
 b=bM/eO/rMZASU7AmfW6H7uWxbWUSh6BkDCqrMcCYmtMT0AJR6CfZYo2t7GBxRGD1Q8xsL
 yZ97WEJzhbYguLm4j2RYmdt+1dWGaTXsNV4LJR02rDip8KmT8yb52pJRF8hOWKvsYkAi
 La5UqHwkMSKChrahxsa0Dd197bNmiV0RB220THP3dkCPpqrlDieF3rRU7mYXs1/3xZPP
 jZuOPZ9P7+fwK4iaTeEQB7Q8j2oBkH8SZublf9qupqvZEkzyjBI4VG7UT7eQbSADUtht
 SF+T2bNYDmD+I0uVzNgJ/4c3C7s0ZscUsaZIW/f698NiBch+iDu4PjQFWgOYU1rS3EZq BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3apw88r80r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 05:26:45 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17R9FU8n128164
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 05:26:45 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3apw88r7yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 05:26:45 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17R9HHiw022165;
        Fri, 27 Aug 2021 09:26:43 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3ajs48k7qj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 09:26:42 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17R9Qd3c51249438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 09:26:39 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D79D4204F;
        Fri, 27 Aug 2021 09:26:39 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28CB542042;
        Fri, 27 Aug 2021 09:26:39 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.164.230])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Aug 2021 09:26:39 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 1/2] Makefile: Fix cscope
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
References: <1629908421-8543-1-git-send-email-pmorel@linux.ibm.com>
 <1629908421-8543-2-git-send-email-pmorel@linux.ibm.com>
 <1dd4c64e-3866-98c9-8178-dbff90dca55f@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <2aaffea2-0a20-1a6d-eebb-69b6cfe6e83c@linux.ibm.com>
Date:   Fri, 27 Aug 2021 11:26:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1dd4c64e-3866-98c9-8178-dbff90dca55f@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6un9Ww1CVd8_F9SWCetbx4qclTo682Vk
X-Proofpoint-GUID: 4rknLbCBE5L4R5Mmz5tv9HdAgFceRm0S
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-27_03:2021-08-26,2021-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108270058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/26/21 7:07 AM, Thomas Huth wrote:
> On 25/08/2021 18.20, Pierre Morel wrote:
>> In Linux, cscope uses a wrong directory.
>> Simply search from the directory where the make is started.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   Makefile | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/Makefile b/Makefile
>> index f7b9f28c..c8b0d74f 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -119,7 +119,7 @@ cscope: cscope_dirs = lib lib/libfdt lib/linux 
>> $(TEST_DIR) $(ARCH_LIBDIRS) lib/a
>>   cscope:
>>       $(RM) ./cscope.*
>>       find -L $(cscope_dirs) -maxdepth 1 \
>> -        -name '*.[chsS]' -exec realpath --relative-base=$(PWD) {} \; 
>> | sort -u > ./cscope.files
>> +        -name '*.[chsS]' -exec realpath --relative-base=. {} \; | 
>> sort -u > ./cscope.files
> 
> Why is $PWD not pointing to the same location as "." ? Are you doing 
> in-tree or out-of-tree builds?
> 
>   Thomas
> 

In tree.
That is the point, why is PWD indicating void ?
I use a bash on s390x.
inside bash PWD shows current directory
GNU Make is 4.2.1 on Ubuntu 18.04

This works on X with redhat and GNU make 3.82

This happens on s390x since:
51b8f0b1 2017-11-23 Andrew Jones Makefile: fix cscope target

So I add Andrew as CC, I did forgot to do before.


Regards,
Pierre




-- 
Pierre Morel
IBM Lab Boeblingen

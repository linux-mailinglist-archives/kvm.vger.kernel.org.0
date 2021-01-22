Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEE73007B1
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 16:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbhAVPo5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 10:44:57 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40744 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728507AbhAVPoO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Jan 2021 10:44:14 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10MFVojC070109;
        Fri, 22 Jan 2021 10:43:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=uYnCMi35/KcFOqiuDHKAf62s0hHueYHvREF4/ce6HRc=;
 b=OcNEptZBAFDQigVHLWwmAlk+RkITjHsUdtM4zho9OZ5YsOId3qdjUeyhshNK1ddig4lx
 rNlIbhPAcY+m7v+DXdOG+ojALPiKntuIIRAoLviITEeTjVmT3sH6Wd6dgPe67bSE+ohO
 yJMFSkWIFATJk4W+lqMsGW7lNZ1Y9MdIHaN8BL3KalyJuHFUa7cp5PxKTntJm60WkUgc
 2C3JgXFT4ANEbvb3X1tBbI5/b3n2pB9jqkn1qRpQYHP2SyF7m5prYWiNbDhJSCEEsqHh
 zRbcqnydhY8G/FthAydKAfKVUOPjJ3E7l2bw5UxTPD8c2Wpnw2kEHvKDoLrlRC7ZDkMt jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36819srjxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 10:43:34 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10MFW3Do070934;
        Fri, 22 Jan 2021 10:43:33 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36819srjvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 10:43:33 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10MFX13T004230;
        Fri, 22 Jan 2021 15:43:29 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 367k0p0pve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 15:43:29 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10MFhKQ035586320
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 15:43:20 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B543511C054;
        Fri, 22 Jan 2021 15:43:26 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 438F611C050;
        Fri, 22 Jan 2021 15:43:26 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.82.252])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Jan 2021 15:43:26 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v5 2/3] s390x: define UV compatible I/O
 allocation
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        drjones@redhat.com, pbonzini@redhat.com
References: <1611322060-1972-1-git-send-email-pmorel@linux.ibm.com>
 <1611322060-1972-3-git-send-email-pmorel@linux.ibm.com>
 <0393eaa1-e3e8-21c4-4e8f-b8dc2cc82983@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <29d73d90-edd8-f482-d020-100b49c97fbf@linux.ibm.com>
Date:   Fri, 22 Jan 2021 16:43:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <0393eaa1-e3e8-21c4-4e8f-b8dc2cc82983@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-22_11:2021-01-21,2021-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 malwarescore=0 impostorscore=0 spamscore=0
 clxscore=1015 suspectscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101220085
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/22/21 3:12 PM, Thomas Huth wrote:
> On 22/01/2021 14.27, Pierre Morel wrote:
>> To centralize the memory allocation for I/O we define
>> the alloc_io_mem/free_io_mem functions which share the I/O
>> memory with the host in case the guest runs with
>> protected virtualization.
>>
>> These functions allocate on a page integral granularity to
>> ensure a dedicated sharing of the allocated objects.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/malloc_io.c | 71 +++++++++++++++++++++++++++++++++++++++++++
>>   lib/s390x/malloc_io.h | 45 +++++++++++++++++++++++++++
>>   s390x/Makefile        |  1 +
>>   3 files changed, 117 insertions(+)
>>   create mode 100644 lib/s390x/malloc_io.c
>>   create mode 100644 lib/s390x/malloc_io.h
> 
> Acked-by: Thomas Huth <thuth@redhat.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBEE432298A
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 12:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbhBWLd1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 06:33:27 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19962 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232244AbhBWLdW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 06:33:22 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11NBED1W172784;
        Tue, 23 Feb 2021 06:32:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0XBfgEU7BZs1NdxFVkqj+s6A3mdt3lFr1nu8j0jr+F4=;
 b=E90njqZwh0Uhx0pekXea+PufpY54ImGoZnh9yVxDRsSmP/lOqs0hLd7fTClEu3oOnH9Z
 D6CffLmJG2xDVggbOtCx2W4L1Xp3I2Xw497G5PBt5vH9NgFIcZrNXjzg36cP7Yvm+dVN
 /2eK78KvcRb7M4GG6g3mFEDaGvlvVowSWWBJLfEd5OCa2KnOf8guW3CmUyQtcdK/S2AL
 KXMsEkL2ObWybGfd7SV8lVbBgy1SqVrt6t921l99iI6X2LaRXwuBUzN4PAz6eLbhDuLR
 8cMW3B7jz0cJnMTHLkfQB4qUWwrGsxFanrih+ZRKXu+DVHfaaqmXDXtC6NUam8UfJ6G9 ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36w0ndrcj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 06:32:40 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11NBHM9e176843;
        Tue, 23 Feb 2021 06:32:39 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36w0ndrch2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 06:32:39 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11NBWLsx009663;
        Tue, 23 Feb 2021 11:32:37 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 36tt282hx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 11:32:37 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11NBWYPt41419134
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 11:32:34 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77F6052057;
        Tue, 23 Feb 2021 11:32:34 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.149.57])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2357D52050;
        Tue, 23 Feb 2021 11:32:34 +0000 (GMT)
Subject: Re: [PATCH v4 1/1] KVM: s390: diag9c (directed yield) forwarding
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com
References: <1613997661-22525-1-git-send-email-pmorel@linux.ibm.com>
 <1613997661-22525-2-git-send-email-pmorel@linux.ibm.com>
 <20210223121444.28543783.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <ceb33789-dad3-4cbc-e9a3-b80c0446bd86@linux.ibm.com>
Date:   Tue, 23 Feb 2021 12:32:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210223121444.28543783.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_05:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0 phishscore=0
 impostorscore=0 suspectscore=0 clxscore=1015 bulkscore=0 adultscore=0
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/23/21 12:14 PM, Cornelia Huck wrote:
> On Mon, 22 Feb 2021 13:41:01 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> When we intercept a DIAG_9C from the guest we verify that the
>> target real CPU associated with the virtual CPU designated by
>> the guest is running and if not we forward the DIAG_9C to the
>> target real CPU.
>>
>> To avoid a diag9c storm we allow a maximal rate of diag9c forwarding.
>>
>> The rate is calculated as a count per second defined as a new
>> parameter of the s390 kvm module: diag9c_forwarding_hz .
>>
>> The default value of 0 is to not forward diag9c.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   Documentation/virt/kvm/s390-diag.rst | 33 ++++++++++++++++++++++++++++
>>   arch/s390/include/asm/kvm_host.h     |  1 +
>>   arch/s390/include/asm/smp.h          |  1 +
>>   arch/s390/kernel/smp.c               |  1 +
>>   arch/s390/kvm/diag.c                 | 31 +++++++++++++++++++++++---
>>   arch/s390/kvm/kvm-s390.c             |  6 +++++
>>   arch/s390/kvm/kvm-s390.h             |  8 +++++++
>>   7 files changed, 78 insertions(+), 3 deletions(-)
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

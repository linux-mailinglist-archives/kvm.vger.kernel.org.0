Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A041347A5D
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 15:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbhCXOMY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 10:12:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7306 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236110AbhCXOL5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Mar 2021 10:11:57 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12OE4RmE189622
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 10:11:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZQLEbGr4exhH37nHVMwEPoxlK9f9OaCagtl9ihA5qCI=;
 b=fDiksexTMd06yviYUJvSCjGXMQtpjjPYnaCVbBFwLqlFrnaSH4gXvNpyQZcMSOLFIPsh
 R21TpE81XjdR0IIeVWTz5Q9Mu41oA9HGDQnHxPynh4ckurZUID4GYQMg0eIBkOhRNCaB
 MUJC/lBQEDeMb42ksi8oUaarP1kmbmzIs1+ni27auTwE7aIfK5FBNrHQ1WeJtMAoMLCE
 4yGJslo09vCNwiLOFpcUReS5uTsy53F7Iw2Nl2GFTI92R7P+Lp5/6SsV5AJQO1nVZnhd
 KTsK8mwZ5q7tsERNdZrTRSCDWnxc2fFR47QJ5nCcFeuLWsjnTimuKk6QnKRUuOGR8kNV nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37g3k0peqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 10:11:56 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12OE4Qto189556
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 10:11:56 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37g3k0pemj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Mar 2021 10:11:52 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12OEBooO019637;
        Wed, 24 Mar 2021 14:11:50 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 37d9d8tah0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Mar 2021 14:11:50 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12OEBms240829330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 14:11:48 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4804E11C04A;
        Wed, 24 Mar 2021 14:11:48 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBF9711C052;
        Wed, 24 Mar 2021 14:11:47 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.181.34])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 24 Mar 2021 14:11:47 +0000 (GMT)
Subject: Re: [kvm-unit-tests RFC 1/2] scripts: Check kvm availability by
 asking qemu
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, lvivier@redhat.com, thuth@redhat.com,
        david@redhat.com, pbonzini@redhat.com, cohuck@redhat.com
References: <20210318124500.45447-1-frankja@linux.ibm.com>
 <20210318124500.45447-2-frankja@linux.ibm.com>
 <20210318153114.ohppqscosrijj7bs@kamzik.brq.redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <b161acba-cb8e-d7a6-cbd3-5567ea065a7c@linux.ibm.com>
Date:   Wed, 24 Mar 2021 15:11:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318153114.ohppqscosrijj7bs@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-24_10:2021-03-24,2021-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103240107
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/18/21 4:31 PM, Andrew Jones wrote:
> On Thu, Mar 18, 2021 at 12:44:59PM +0000, Janosch Frank wrote:
>> The existence of the /dev/kvm character device doesn't imply that the
>> kvm module is part of the kernel or that it's always magically loaded
>> when needed.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  arm/run               | 4 ++--
>>  powerpc/run           | 4 ++--
>>  s390x/run             | 4 ++--
>>  scripts/arch-run.bash | 7 +++++--
>>  x86/run               | 4 ++--
>>  5 files changed, 13 insertions(+), 10 deletions(-)
>>
>> diff --git a/arm/run b/arm/run
>> index a390ca5a..ca2d44e0 100755
>> --- a/arm/run
>> +++ b/arm/run
>> @@ -10,10 +10,10 @@ if [ -z "$STANDALONE" ]; then
>>  fi
>>  processor="$PROCESSOR"
>>  
>> -ACCEL=$(get_qemu_accelerator) ||
>> +qemu=$(search_qemu_binary) ||
>>  	exit $?
>>  
>> -qemu=$(search_qemu_binary) ||
>> +ACCEL=$(get_qemu_accelerator) ||
>>  	exit $?
> 
> How about renaming search_qemu_binary() to set_qemu_accelerator(), which
> would also ensure QEMU is set (if it doesn't error out on failure) and
> then call that from get_qemu_accelerator()? That way we don't need to
> worry about this order of calls nor this lowercase 'qemu' variable being
> set. Also, we can rename get_qemu_accelerator() to set_qemu_accelerator()
> and ensure it sets ACCEL.
> 
> Thanks,
> drew
> 

I've already broken off the accel.bash change and fixed the arch/run
problem but this here will have two wait until after my easter vacation
so don't wait for patches the next ~2 weeks.

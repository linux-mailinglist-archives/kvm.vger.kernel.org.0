Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73180340908
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 16:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbhCRPjp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 11:39:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15144 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231629AbhCRPjl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 11:39:41 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IFXOu4094933
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 11:39:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hN64aERr95JySZRjZliG111Vdcf/72b+9Tjjnl01DkA=;
 b=pwjTcJK+KnqepZl7txyMHWoNlhv0Us1fe3Jmb5egFExCwa6W2dldEsSX6PfI4LDo5QWf
 iKNh+s1d+oqx4Tb2FXPW8tVyBBWyYBlzqOT+ZT/tPvS8jSzPkM7tbQUFrY5rIb7dpgip
 XYhjR2MX5RER5+/EG3YJRwWWSCMvfp9jQ17NHVkRv6GnKcx1ISu3/gwlWA1t/kJ9Sdz/
 D14VUUfjcnYFZTm498PmBd+0nj08+PFrAda0pM3+O61fwKQj6dqu+1tA4EreRIUkuAY8
 h0NUxg5ydKPQA6uVIrC6/kGs11H4pyY6pnR3LPjLcqgzG7hv4ZwHNJQlqwzthRTOse5X Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c07pstxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 11:39:41 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12IFXRSj095294
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 11:39:40 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c07pstwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 11:39:40 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12IFWE4K028791;
        Thu, 18 Mar 2021 15:39:39 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 37brpfrdj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 15:39:38 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12IFdJkR24904044
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 15:39:19 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6987642042;
        Thu, 18 Mar 2021 15:39:36 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0805842041;
        Thu, 18 Mar 2021 15:39:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.24.61])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Mar 2021 15:39:35 +0000 (GMT)
Subject: Re: [kvm-unit-tests RFC 1/2] scripts: Check kvm availability by
 asking qemu
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, lvivier@redhat.com, thuth@redhat.com,
        david@redhat.com, pbonzini@redhat.com, cohuck@redhat.com
References: <20210318124500.45447-1-frankja@linux.ibm.com>
 <20210318124500.45447-2-frankja@linux.ibm.com>
 <20210318153114.ohppqscosrijj7bs@kamzik.brq.redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <b6cf5a10-bb8d-799e-16cf-92c225b39fb8@linux.ibm.com>
Date:   Thu, 18 Mar 2021 16:39:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210318153114.ohppqscosrijj7bs@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_09:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 impostorscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103180111
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

Sure, I was already considering that.

The fact that qemu and ACCEL are basically global and accel is not the
same as ACCEL makes all of this harder to understand than it should be.

> 
> Thanks,
> drew
> 


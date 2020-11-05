Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10552A77DC
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 08:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgKEHSo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 02:18:44 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45666 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726626AbgKEHSn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Nov 2020 02:18:43 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A572peO123179
        for <kvm@vger.kernel.org>; Thu, 5 Nov 2020 02:18:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ITNbgvV6bJ1Y12PQAu+Pmug6V2HlSPrVO8T1nDfkZK4=;
 b=Fo7BVosojQBNoIsbUMtOcD/YN1GIhrLO8q0CNx6D8p6/YUpzXXjdyrVMs1SmtBt5W2bX
 20oVpnqkbCQc0yOz4/ucod9Lv1MCn7qslExmss1FU1Eoxs5esNQhMXExXKkQNEgIAvBO
 E8ugE/LGfdPpM9Lqjjy8G+KYXlY+rigKtYm/wx2SwxQ1N9x8GYyq3udU1Iin/oVufSb8
 c8VXiKtmMzfjs0uFtF7rXJbaHWOb8ST0YnBrh/lqqJFPG1bvVWEkH9dTkfOL6GzM+WUC
 DCU6jwIAg0BecBfTw/vTYwwrvvkFKEfT+KXQh1Uk2p/+b32w12NRJkjNT0ni43CRF9A3 gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34m5dbb3ud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 05 Nov 2020 02:18:42 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A572wbF123903
        for <kvm@vger.kernel.org>; Thu, 5 Nov 2020 02:18:41 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34m5dbb3tr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 02:18:41 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A57IAeW023047;
        Thu, 5 Nov 2020 07:18:40 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 34h01qtmq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 07:18:40 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A57IbvW63504670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Nov 2020 07:18:37 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C4E3A404D;
        Thu,  5 Nov 2020 07:18:37 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5EFF1A4059;
        Thu,  5 Nov 2020 07:18:37 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.167.78])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 Nov 2020 07:18:37 +0000 (GMT)
Subject: Re: [PATCH 09/11] KVM: selftests: Make vm_create_default common
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, frankja@linux.ibm.com, bgardon@google.com,
        peterx@redhat.com
References: <20201104212357.171559-1-drjones@redhat.com>
 <20201104212357.171559-10-drjones@redhat.com>
 <20201104213612.rjykwe7pozcoqbcb@kamzik.brq.redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <c2c57735-2d1c-5abf-c2c0-ed04a19db5a0@de.ibm.com>
Date:   Thu, 5 Nov 2020 08:18:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201104213612.rjykwe7pozcoqbcb@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-05_02:2020-11-05,2020-11-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011050051
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 04.11.20 22:36, Andrew Jones wrote:
> On Wed, Nov 04, 2020 at 10:23:55PM +0100, Andrew Jones wrote:
>> The code is almost 100% the same anyway. Just move it to common
>> and add a few arch-specific helpers.
>>
>> Signed-off-by: Andrew Jones <drjones@redhat.com>
>> ---
>>  .../selftests/kvm/include/aarch64/processor.h |  3 ++
>>  .../selftests/kvm/include/s390x/processor.h   |  4 +++
>>  .../selftests/kvm/include/x86_64/processor.h  |  4 +++
>>  .../selftests/kvm/lib/aarch64/processor.c     | 17 ----------
>>  tools/testing/selftests/kvm/lib/kvm_util.c    | 26 +++++++++++++++
>>  .../selftests/kvm/lib/s390x/processor.c       | 22 -------------
>>  .../selftests/kvm/lib/x86_64/processor.c      | 32 -------------------
>>  7 files changed, 37 insertions(+), 71 deletions(-)
>>
>> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
>> index b7fa0c8551db..5e5849cdd115 100644
>> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
>> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
>> @@ -9,6 +9,9 @@
>>  
>>  #include "kvm_util.h"
>>  
>> +#define PTRS_PER_PAGE(page_size)	((page_size) / 8)
>> +#define min_page_size()			(4096)
>> +#define min_page_shift()		(12)
>>  
>>  #define ARM64_CORE_REG(x) (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
>>  			   KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
>> diff --git a/tools/testing/selftests/kvm/include/s390x/processor.h b/tools/testing/selftests/kvm/include/s390x/processor.h
>> index e0e96a5f608c..0952f53c538b 100644
>> --- a/tools/testing/selftests/kvm/include/s390x/processor.h
>> +++ b/tools/testing/selftests/kvm/include/s390x/processor.h
>> @@ -5,6 +5,10 @@
>>  #ifndef SELFTEST_KVM_PROCESSOR_H
>>  #define SELFTEST_KVM_PROCESSOR_H
>>  
>> +#define PTRS_PER_PAGE(page_size)	((page_size) / 8)
> 
> Doh. I think this 8 is supposed to be a 16 for s390x, considering it
> was dividing by 256 in its version of vm_create_default. I need
> guidance from s390x gurus as to whether or not I should respin though.
> 
> Thanks,
> drew
> 

This is kind of tricky. The last level page table is only 2kb (256 entries = 1MB range).
Depending on whether the page table allocation is clever or not (you can have 2 page
tables in one page) this means that indeed 16 might be better. But then you actually 
want to change the macro name to PTES_PER_PAGE?

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D70E01B76C2
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 15:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgDXNR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 09:17:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64210 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727009AbgDXNRZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 09:17:25 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03ODAs9p080710;
        Fri, 24 Apr 2020 09:17:17 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30k7rn7r6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 09:17:17 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03ODAxgi081249;
        Fri, 24 Apr 2020 09:17:16 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30k7rn7r5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 09:17:16 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03ODFYZH027075;
        Fri, 24 Apr 2020 13:17:15 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 30fs6596s2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 13:17:15 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03ODHC237274996
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 13:17:12 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 409364C044;
        Fri, 24 Apr 2020 13:17:12 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B898E4C04A;
        Fri, 24 Apr 2020 13:17:11 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.14.129])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 24 Apr 2020 13:17:11 +0000 (GMT)
Subject: Re: [PATCH v1 1/1] s390/protvirt: fix compilation issue
To:     Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        cohuck@redhat.com, david@redhat.com,
        kbuild test robot <lkp@intel.com>,
        Philipp Rudo <prudo@linux.ibm.com>
References: <20200423120114.2027410-1-imbrenda@linux.ibm.com>
 <your-ad-here.call-01587646462-ext-4177@work.hours>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Message-ID: <a12b704f-b9b8-6ce8-0f65-5751a69bfdd2@de.ibm.com>
Date:   Fri, 24 Apr 2020 15:17:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <your-ad-here.call-01587646462-ext-4177@work.hours>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_05:2020-04-23,2020-04-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 impostorscore=0 malwarescore=0 suspectscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 23.04.20 14:54, Vasily Gorbik wrote:
> On Thu, Apr 23, 2020 at 02:01:14PM +0200, Claudio Imbrenda wrote:
>> The kernel fails to compile with CONFIG_PROTECTED_VIRTUALIZATION_GUEST
>> set but CONFIG_KVM unset.
>>
>> This patch fixes the issue by making the needed variable always available.
> 
> This statement confuses me a bit.
> 
> It's worth to mention that both arch/s390/boot/uv.c (for the
> decompressor) and arch/s390/kernel/uv.c (for the main kernel) are only
> built when either CONFIG_PROTECTED_VIRTUALIZATION_GUEST or
> CONFIG_KVM is enabled.
> Both arch/s390/boot/Makefile and arch/s390/kernel/Makefile contain:
> obj-$(findstring y, $(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) $(CONFIG_PGSTE))   += uv.o
> 
> So this makes the variable available when
> CONFIG_PROTECTED_VIRTUALIZATION_GUEST or CONFIG_KVM (expressed via
> CONFIG_PGSTE) is enabled. Hence no need for extra conditions for variable
> declaration.
> 
>> Fixes: a0f60f8431999bf5 ("s390/protvirt: Add sysfs firmware interface for Ultravisor information")
>> Reported-by: kbuild test robot <lkp@intel.com>
>> Reported-by: Philipp Rudo <prudo@linux.ibm.com>
>> Suggested-by: Philipp Rudo <prudo@linux.ibm.com>
>> CC: Vasily Gorbik <gor@linux.ibm.com>
>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> ---
>>  arch/s390/boot/uv.c   | 2 --
>>  arch/s390/kernel/uv.c | 3 ++-
>>  2 files changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
>> index 8fde561f1d07..f887a479cdc7 100644
>> --- a/arch/s390/boot/uv.c
>> +++ b/arch/s390/boot/uv.c
>> @@ -7,9 +7,7 @@
>>  #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
>>  int __bootdata_preserved(prot_virt_guest);
>>  #endif
>> -#if IS_ENABLED(CONFIG_KVM)
>>  struct uv_info __bootdata_preserved(uv_info);
>> -#endif
>>  
>>  void uv_query_info(void)
>>  {
>> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
>> index c86d654351d1..4c0677fc8904 100644
>> --- a/arch/s390/kernel/uv.c
>> +++ b/arch/s390/kernel/uv.c
>> @@ -23,10 +23,11 @@
>>  int __bootdata_preserved(prot_virt_guest);
>>  #endif
>>  
>> +struct uv_info __bootdata_preserved(uv_info);
>> +
>>  #if IS_ENABLED(CONFIG_KVM)
>>  int prot_virt_host;
>>  EXPORT_SYMBOL(prot_virt_host);
>> -struct uv_info __bootdata_preserved(uv_info);
>>  EXPORT_SYMBOL(uv_info);
> 
> hm, EXPORT_SYMBOL(uv_info) is not needed without CONFIG_KVM and this saves
> 1 symbol export, but I'd still made EXPORT_SYMBOL follow the declaration
> immediately. Documentation/process/coding-style.rst mentions that only
> for function declarations though.
> 
> Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>

Vasily, I guess you have a pull request soon? Do you want to pick this?


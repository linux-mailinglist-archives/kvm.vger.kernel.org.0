Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D60D44B431E
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 08:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236130AbiBNHxf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 02:53:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbiBNHxe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 02:53:34 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F205B3CB;
        Sun, 13 Feb 2022 23:53:26 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21E7JZNs012533;
        Mon, 14 Feb 2022 07:53:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mh1IZLP6bfXG93wC3OvGri09qFDydygL9MBZFqRC8KM=;
 b=pmwQQS6oWucKrkw5jMSwATYK0rfY2EJDiNpGNOr+DOCeoWX3ePNYKrYuRP8F/hJzGwFq
 FLkOumzO6fZROBipxLaVMTQx0w9+w17jcA448YmJPNxTayecEOUCiqhzYjl401JLShLk
 5wkKZKmaJiVDRRHtJJjIgX8hSm7dOzgr38sauvrq5eGqjMmniFdz5d5ekKoJkxdSKgvs
 o4az+x2IXMO/IGD/D7jOcKnHFzKTKrdBxuQ26pawk2RrmiU6PehkKwXhLrNxZInRqG1T
 MTKV+cyQyU1gkJyOwjRcN41/c9QlEkshBTThHQ6oHbT9XZ2HHp3WEoxfQer4xKW9pvev cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e7c4dq3a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 07:53:25 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21E7pobn024114;
        Mon, 14 Feb 2022 07:53:25 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e7c4dq39t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 07:53:25 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21E7jiPX027153;
        Mon, 14 Feb 2022 07:53:23 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3e64h99vhd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 07:53:23 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21E7rKor44827074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 07:53:20 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BF33A405B;
        Mon, 14 Feb 2022 07:53:20 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22086A4054;
        Mon, 14 Feb 2022 07:53:20 +0000 (GMT)
Received: from [9.171.42.254] (unknown [9.171.42.254])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 14 Feb 2022 07:53:20 +0000 (GMT)
Message-ID: <755f1838-8edf-64bc-0f0b-1ca53adbf8fe@linux.ibm.com>
Date:   Mon, 14 Feb 2022 08:55:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v4 2/4] s390x: stsi: Define vm_is_kvm to be
 used in different tests
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com
References: <20220208132709.48291-1-pmorel@linux.ibm.com>
 <20220208132709.48291-3-pmorel@linux.ibm.com>
 <ea550ac540d29fdf76eb104d05a7016a95f8373b.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <ea550ac540d29fdf76eb104d05a7016a95f8373b.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: z4BqGaJOESoo4THHxLFh_TgXIayDoxMZ
X-Proofpoint-ORIG-GUID: IQg1g-bPpS4NMPFnIYa96GX-kG2uYVU7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_01,2022-02-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140046
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/8/22 16:35, Nico Boehr wrote:
> On Tue, 2022-02-08 at 14:27 +0100, Pierre Morel wrote:
>> We need in several tests to check if the VM we are running in
>> is KVM.
>> Let's add the test.
>>
>> To check the VM type we use the STSI 3.2.2 instruction, let's
>> define it's response structure in a central header.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> 
>> ---
>>   lib/s390x/stsi.h | 32 +++++++++++++++++++++++++++
>>   lib/s390x/vm.c   | 56
>> ++++++++++++++++++++++++++++++++++++++++++++++--
>>   lib/s390x/vm.h   |  3 +++
>>   s390x/stsi.c     | 23 ++------------------
>>   4 files changed, 91 insertions(+), 23 deletions(-)
>>   create mode 100644 lib/s390x/stsi.h
>>
>> diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
>> new file mode 100644
>> index 00000000..9b40664f
>> --- /dev/null
>> +++ b/lib/s390x/stsi.h
>> @@ -0,0 +1,32 @@
>> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> 
> This was taken from stsi.c which is GPL 2 only, so this probably should
> be as well.
> 
>> diff --git a/lib/s390x/vm.c b/lib/s390x/vm.c
>> index a5b92863..38886b76 100644
>> --- a/lib/s390x/vm.c
>> +++ b/lib/s390x/vm.c
>> @@ -12,6 +12,7 @@
>>   #include <alloc_page.h>
>>   #include <asm/arch_def.h>
>>   #include "vm.h"
>> +#include "stsi.h"
>>   
>>   /**
>>    * Detect whether we are running with TCG (instead of KVM)
>> @@ -26,9 +27,13 @@ bool vm_is_tcg(void)
>>          if (initialized)
>>                  return is_tcg;
>>   
>> -       buf = alloc_page();
>> -       if (!buf)
>> +       if (!vm_is_vm()) {
>> +               initialized = true;
>>                  return false;
>> diff --git a/lib/s390x/vm.c b/lib/s390x/vm.c
>> index a5b92863..38886b76 100644
>> --- a/lib/s390x/vm.c
>> +++ b/lib/s390x/vm.c
>> @@ -12,6 +12,7 @@
>>   #include <alloc_page.h>
>>   #include <asm/arch_def.h>
>>   #include "vm.h"
>> +#include "stsi.h"
>>   
>>   /**
>>    * Detect whether we are running with TCG (instead of KVM)
>> @@ -26,9 +27,13 @@ bool vm_is_tcg(void)
>>          if (initialized)
>>                  return is_tcg;
>>   
>> -       buf = alloc_page();
>> -       if (!buf)
>> +       if (!vm_is_vm()) {
>> +               initialized = true;
>>                  return false;
> 
> I would personally prefer return is_tcg here to make it obvious we're
> relying on the previous initalization to false for subsequent calls.

OK

> 
>> +       }
>> +
>> +       buf = alloc_page();
>> +       assert(buf);
>>   
>>          if (stsi(buf, 1, 1, 1))
>>                  goto out;
>> @@ -43,3 +48,50 @@ out:
>>          free_page(buf);
>>          return is_tcg;
>>   }
>> +
>> +/**
>> + * Detect whether we are running with KVM
>> + */
>> +
> 
> No newline here.

ok

> 
>> +bool vm_is_kvm(void)
>> +{
>> +       /* EBCDIC for "KVM/" */
>> +       const uint8_t kvm_ebcdic[] = { 0xd2, 0xe5, 0xd4, 0x61 };
>> +       static bool initialized;
>> +       static bool is_kvm;
> 
> Might make sense to initizalize these to false to make it consistent
> with vm_is_tcg().
> 

OK

-- 
Pierre Morel
IBM Lab Boeblingen

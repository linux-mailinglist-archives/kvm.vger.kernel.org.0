Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3917C74D988
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 17:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbjGJPGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 11:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233475AbjGJPGj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 11:06:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC41B120;
        Mon, 10 Jul 2023 08:06:35 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36AExNtb027240;
        Mon, 10 Jul 2023 15:06:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=aK/3ICWzLRCLnLIiAZjU/F6f+FdlbS9GuzoT0VUFLm8=;
 b=ObcaGd4MSx+FFl/a1G5XiBf6+GHeGccN4TiPar3hBP6j1f2kHmL9+zwMAk+8+kHZGF8L
 2wfYpALy15CIF+Vt/WeEy13tNE3MxSPbEwFQ+mHIj8QhIgVLuiBFjzvfBHU+h24HyfHZ
 ZkCK/JLlbcdDP+geIZ/Loe97HfjvRITmAcMMRTMFLzk4Gw5I7nfCd4mrd1rq0q2l2eOz
 cbMtsVOuFwmF+yMcWQeu1GQAbcfi+27dob7pcWgKinbnfHO4Xvcf/HmfBPojFKiFGdzM
 Rc0JPDuGoyCLxW19Z1HBt+HEt+wK+tfnuK44JdYOZ48JMWARWk+tAQ9p4zoO5T4VF9Gt FQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rrm7qge8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jul 2023 15:06:32 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36AF0H8g029420;
        Mon, 10 Jul 2023 15:06:07 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rrm7qgd00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jul 2023 15:06:07 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36AErbWt016727;
        Mon, 10 Jul 2023 15:05:40 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3rpye599fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jul 2023 15:05:39 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36AF5a3B31785712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jul 2023 15:05:36 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9721C2004B;
        Mon, 10 Jul 2023 15:05:36 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 405D620040;
        Mon, 10 Jul 2023 15:05:36 +0000 (GMT)
Received: from [9.171.90.148] (unknown [9.171.90.148])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 10 Jul 2023 15:05:36 +0000 (GMT)
Message-ID: <76daa0d8-829d-2d48-4d70-92097518d565@linux.ibm.com>
Date:   Mon, 10 Jul 2023 17:05:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, imbrenda@linux.ibm.com,
        thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230601070202.152094-1-nrb@linux.ibm.com>
 <20230601070202.152094-7-nrb@linux.ibm.com>
 <ab1047c5-77f1-d68b-cf05-4bcda44909ed@linux.ibm.com>
 <168899937501.42553.5805213823249646110@t14-nrb>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 6/6] s390x: add a test for SIE without
 MSO/MSL
In-Reply-To: <168899937501.42553.5805213823249646110@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GNYn9_GD3rqK_eRjupLBXAvUOo1cywZ1
X-Proofpoint-ORIG-GUID: nBPkQ7HFpro9icSxvpAjeW6nyKTFva1r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-10_11,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 impostorscore=0 spamscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307100135
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/10/23 16:29, Nico Boehr wrote:
> Quoting Janosch Frank (2023-06-05 11:57:58)
> [...]
>>> diff --git a/s390x/sie-dat.c b/s390x/sie-dat.c
>>> new file mode 100644
>>> index 000000000000..c490a2aa825c
> [...]
>>> +#include <libcflat.h>
>>> +#include <vmalloc.h>
>>> +#include <asm/asm-offsets.h>
>>
>> I only did a cursory glance and wasn't able to see a use for this include.
> 
> Yep, thanks, I cleaned up the includes a bit.
> 
> [...]
>>> +static void test_sie_dat(void)
>>> +{
>>> +     uint8_t r1;
>>> +     bool contents_match;
>>> +     uint64_t test_page_gpa, test_page_hpa;
>>> +     uint8_t *test_page_hva;
>>> +
>>> +     /* guest will tell us the guest physical address of the test buffer */
>>> +     sie(&vm);
>>> +
>>> +     r1 = (vm.sblk->ipa & 0xf0) >> 4;
>>> +     test_page_gpa = vm.save_area.guest.grs[r1];
>>> +     test_page_hpa = virt_to_pte_phys(guest_root, (void*)test_page_gpa);
>>> +     test_page_hva = __va(test_page_hpa);
>>> +     report(vm.sblk->icptcode == ICPT_INST &&
>>> +            (vm.sblk->ipa & 0xFF00) == 0x8300 && vm.sblk->ipb == 0x9c0000,
>>> +            "test buffer gpa=0x%lx hva=%p", test_page_gpa, test_page_hva);
>>
>> You could rebase on my pv_icptdata.h patch.
>> Also the report string and boolean don't really relate to each other.
> 
> Which patch are we talking about? pv_icptdata_check_diag()?
> 
> Note that this is not a PV test, so I guess it's not applicable here?

Ah right, we could extend that but for one use this should be fine.
Let's see if there'll be more SIE tests that need this before building a 
a full intercept check lib.

Could you lower-case the 0xFF00 when you re-spin?

> 
>> Not every exit needs to be a report.
>> Some should rather be asserts() or report_info()s.
> 
> Yeah, I have made report()s where it doesn't make sense to continue assert()s
> 
>>> +     contents_match = true;
>>> +     for (unsigned int i = 0; i < GUEST_TEST_PAGE_COUNT; i++) {
>>> +             uint8_t expected_val = 42 + i;
>>
>> Just because you can doesn't mean that you have to.
>> At least leave a \n when declaring new variables...
> 
> I am a bit confused but I *guess* you wanted me to move the declaration of
> expected_val to the beginning of the function?
> 

Personally I'm not a big fan of declaring variables in the lower 
function body, they are way too easy to overlook.

I dimly remember there being a rule but when I used a few minutes to 
look for it I couldn't find it anymore. Hmmmm, maybe I'm getting old.

> [...]
>>> diff --git a/s390x/snippets/c/sie-dat.c b/s390x/snippets/c/sie-dat.c
>>> new file mode 100644
>>> index 000000000000..e156d0c36c4c
>>> --- /dev/null
>>> +++ b/s390x/snippets/c/sie-dat.c
>>> @@ -0,0 +1,58 @@
>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>> +/*
>>> + * Snippet used by the sie-dat.c test to verify paging without MSO/MSL
>>> + *
>>> + * Copyright (c) 2023 IBM Corp
>>> + *
>>> + * Authors:
>>> + *  Nico Boehr <nrb@linux.ibm.com>
>>> + */
>>> +#include <stddef.h>
>>> +#include <inttypes.h>
>>> +#include <string.h>
>>> +#include <asm-generic/page.h>
>>> +
>>> +/* keep in sync with GUEST_TEST_PAGE_COUNT in s390x/sie-dat.c */
>>> +#define TEST_PAGE_COUNT 10
>>> +static uint8_t test_page[TEST_PAGE_COUNT * PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
>>> +
>>> +/* keep in sync with GUEST_TOTAL_PAGE_COUNT in s390x/sie-dat.c */
>>> +#define TOTAL_PAGE_COUNT 256
>>> +
>>> +static inline void force_exit(void)
>>> +{
>>> +     asm volatile("diag      0,0,0x44\n");
>>> +}
>>> +
>>> +static inline void force_exit_value(uint64_t val)
>>> +{
>>> +     asm volatile(
>>> +             "diag   %[val],0,0x9c\n"
>>> +             : : [val] "d"(val)
>>> +     );
>>> +}
>>
>> It feels like these need to go into a snippet lib.
> 
> A bunch of other tests do similar things, so I'll write a TODO and tackle it in
> a seperate series.

Thanks :)

> 
> [...]
>>> +
>>> +__attribute__((section(".text"))) int main(void)
>>
>> The attribute shouldn't be needed anymore.
> 
> OK, removed.
> 
> [...]
>>> +{
>>> +     uint8_t *invalid_ptr;
>>> +
>>> +     memset(test_page, 0, sizeof(test_page));
>>> +     /* tell the host the page's physical address (we're running DAT off) */
>>> +     force_exit_value((uint64_t)test_page);
>>> +
>>> +     /* write some value to the page so the host can verify it */
>>> +     for (size_t i = 0; i < TEST_PAGE_COUNT; i++)
>>
>> Why is i a size_t type?
> 
> Because it's a suitable unsigned type for use as an array index.
> 
> What should it be instead?

I would have used a standard uint type but to be fair this doesn't kill 
me either.


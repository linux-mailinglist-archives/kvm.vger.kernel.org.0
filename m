Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85C83BBA97
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 11:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhGEJ7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 05:59:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57702 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230000AbhGEJ7Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Jul 2021 05:59:16 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1659X2lw126314;
        Mon, 5 Jul 2021 05:56:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=BBB+JM9FoS16H24W6Rh11ZNhWUdXf8UoqsciLCK509E=;
 b=Tk/c625clzNqV8lI4wNz8pzcGDDK+HuGG7yoss9SsmHxWD1Jjr76aMX6DTizAD7DAzj7
 s+V+tmG19R3jbVO8k7eLxc53QUT3+MhQDon7V9G+h9LX7tyhWCOFQd+IAHRf1i1j7rIz
 Aj64R69pLNmNkqNVLDaIxDyAXhAflOAHXfnNxeg/aClzqroI1Pr2LCBaSk2+yxcVjEdN
 N1ovts7qtm4hY9f/Z+y2aVhYSi4+jODtWVtsDa9MWwlmMpCd5vfvjk8R9spPe5+iGoJj
 QC1xjae8nIkgNt53O84QP3tMeN3KD5CSdS+2gI6bRtQrge2U4s7GfFT0dBn1O5twzFJS 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39ktqdft9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jul 2021 05:56:39 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1659ZE3P133109;
        Mon, 5 Jul 2021 05:56:39 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39ktqdft99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jul 2021 05:56:39 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1659q41b032555;
        Mon, 5 Jul 2021 09:56:37 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 39jfh8rqka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jul 2021 09:56:37 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1659uZxT35914132
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Jul 2021 09:56:35 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BEC8A4051;
        Mon,  5 Jul 2021 09:56:35 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCD16A4053;
        Mon,  5 Jul 2021 09:56:34 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.25.73])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  5 Jul 2021 09:56:34 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: mvpg: Add SIE mvpg test
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210629131841.17319-1-frankja@linux.ibm.com>
 <20210629131841.17319-4-frankja@linux.ibm.com>
 <d4966f2c-89b4-94b7-0dc7-df69534c2d7a@redhat.com>
 <8a742d45-bb49-d130-604a-da1e11150ef3@linux.ibm.com>
 <af215884-ad72-7e2e-cbc7-55a4bd0ee688@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <45fd9a65-f7cd-3159-42fb-0cd69131b2b6@linux.ibm.com>
Date:   Mon, 5 Jul 2021 11:56:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <af215884-ad72-7e2e-cbc7-55a4bd0ee688@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zREEmyXTamqybPPCPZaBGXc6yxmuG8sC
X-Proofpoint-GUID: IV0MKp91i2gRObfzZ9c5vyXV0uz4RFN7
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-05_05:2021-07-02,2021-07-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 clxscore=1015 malwarescore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107050050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/5/21 11:52 AM, Thomas Huth wrote:
> On 05/07/2021 11.37, Janosch Frank wrote:
>> On 7/5/21 9:24 AM, Thomas Huth wrote:
>>> On 29/06/2021 15.18, Janosch Frank wrote:
>>>> Let's also check the PEI values to make sure our VSIE implementation
>>>> is correct.
>>>>
>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>> ---
>>>>    s390x/Makefile                  |   2 +
>>>>    s390x/mvpg-sie.c                | 151 ++++++++++++++++++++++++++++++++
>>>>    s390x/snippets/c/mvpg-snippet.c |  33 +++++++
>>>>    s390x/unittests.cfg             |   3 +
>>>>    4 files changed, 189 insertions(+)
>>>>    create mode 100644 s390x/mvpg-sie.c
>>>>    create mode 100644 s390x/snippets/c/mvpg-snippet.c
>>>>
>>>> diff --git a/s390x/Makefile b/s390x/Makefile
>>>> index ba32f4c..07af26d 100644
>>>> --- a/s390x/Makefile
>>>> +++ b/s390x/Makefile
>>>> @@ -23,6 +23,7 @@ tests += $(TEST_DIR)/sie.elf
>>>>    tests += $(TEST_DIR)/mvpg.elf
>>>>    tests += $(TEST_DIR)/uv-host.elf
>>>>    tests += $(TEST_DIR)/edat.elf
>>>> +tests += $(TEST_DIR)/mvpg-sie.elf
>>>>    
>>>>    tests_binary = $(patsubst %.elf,%.bin,$(tests))
>>>>    ifneq ($(HOST_KEY_DOCUMENT),)
>>>> @@ -82,6 +83,7 @@ snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
>>>>    
>>>>    # perquisites (=guests) for the snippet hosts.
>>>>    # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
>>>> +$(TEST_DIR)/mvpg-sie.elf: snippets = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
>>>>    
>>>>    $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(FLATLIBS)
>>>>    	$(OBJCOPY) -O binary $(patsubst %.gbin,%.o,$@) $@
>>>> diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
>>>> new file mode 100644
>>>> index 0000000..3536c6a
>>>> --- /dev/null
>>>> +++ b/s390x/mvpg-sie.c
>>>> @@ -0,0 +1,151 @@
>>>> +#include <libcflat.h>
>>>> +#include <asm/asm-offsets.h>
>>>> +#include <asm-generic/barrier.h>
>>>> +#include <asm/pgtable.h>
>>>> +#include <mmu.h>
>>>> +#include <asm/page.h>
>>>> +#include <asm/facility.h>
>>>> +#include <asm/mem.h>
>>>> +#include <alloc_page.h>
>>>> +#include <vm.h>
>>>> +#include <sclp.h>
>>>> +#include <sie.h>
>>>> +
>>>> +static u8 *guest;
>>>> +static u8 *guest_instr;
>>>> +static struct vm vm;
>>>> +
>>>> +static uint8_t *src;
>>>> +static uint8_t *dst;
>>>> +static uint8_t *cmp;
>>>> +
>>>> +extern const char _binary_s390x_snippets_c_mvpg_snippet_gbin_start[];
>>>> +extern const char _binary_s390x_snippets_c_mvpg_snippet_gbin_end[];
>>>> +int binary_size;
>>>> +
>>>> +static void sie(struct vm *vm)
>>>> +{
>>>> +	/* Reset icptcode so we don't trip over it below */
>>>> +	vm->sblk->icptcode = 0;
>>>> +
>>>> +	while (vm->sblk->icptcode == 0) {
>>>> +		sie64a(vm->sblk, &vm->save_area);
>>>> +		if (vm->sblk->icptcode == ICPT_VALIDITY)
>>>> +			assert(0);
>>>
>>> Please replace the above two lines with:
>>>
>>> 		assert(vm->sblk->icptcode != ICPT_VALIDITY);
>>
>> Sure
>>
>>>
>>>> +	}
>>>> +	vm->save_area.guest.grs[14] = vm->sblk->gg14;
>>>> +	vm->save_area.guest.grs[15] = vm->sblk->gg15;
>>>> +}
>>>> +
>>>> +static void test_mvpg_pei(void)
>>>> +{
>>>> +	uint64_t **pei_dst = (uint64_t **)((uintptr_t) vm.sblk + 0xc0);
>>>> +	uint64_t **pei_src = (uint64_t **)((uintptr_t) vm.sblk + 0xc8);
>>>> +
>>>> +	report_prefix_push("pei");
>>>> +
>>>> +	report_prefix_push("src");
>>>> +	memset(dst, 0, PAGE_SIZE);
>>>> +	protect_page(src, PAGE_ENTRY_I);
>>>> +	sie(&vm);
>>>> +	report(vm.sblk->icptcode == ICPT_PARTEXEC, "Partial execution");
>>>> +	report((uintptr_t)**pei_src == (uintptr_t)src + PAGE_ENTRY_I, "PEI_SRC correct");
>>>> +	report((uintptr_t)**pei_dst == (uintptr_t)dst, "PEI_DST correct");
>>>> +	unprotect_page(src, PAGE_ENTRY_I);
>>>> +	report(!memcmp(cmp, dst, PAGE_SIZE), "Destination intact");
>>>> +	/*
>>>> +	 * We need to execute the diag44 which is used as a blocker
>>>> +	 * behind the mvpg. It makes sure we fail the tests above if
>>>> +	 * the mvpg wouldn't have intercepted.
>>>> +	 */
>>>> +	sie(&vm);
>>>> +	/* Make sure we intercepted for the diag44 and nothing else */
>>>> +	assert(vm.sblk->icptcode == ICPT_INST &&
>>>> +	       vm.sblk->ipa == 0x8300 && vm.sblk->ipb == 0x440000);
>>>> +	report_prefix_pop();
>>>> +
>>>> +	/* Clear PEI data for next check */
>>>> +	report_prefix_push("dst");
>>>> +	memset((uint64_t *)((uintptr_t) vm.sblk + 0xc0), 0, 16);
>>>> +	memset(dst, 0, PAGE_SIZE);
>>>> +	protect_page(dst, PAGE_ENTRY_I);
>>>> +	sie(&vm);
>>>> +	report(vm.sblk->icptcode == ICPT_PARTEXEC, "Partial execution");
>>>> +	report((uintptr_t)**pei_src == (uintptr_t)src, "PEI_SRC correct");
>>>> +	report((uintptr_t)**pei_dst == (uintptr_t)dst + PAGE_ENTRY_I, "PEI_DST correct");
>>>> +	/* Needed for the memcmp and general cleanup */
>>>> +	unprotect_page(dst, PAGE_ENTRY_I);
>>>> +	report(!memcmp(cmp, dst, PAGE_SIZE), "Destination intact");
>>>> +	report_prefix_pop();
>>>> +
>>>> +	report_prefix_pop();
>>>> +}
>>>
>>> Still quite a lot of magic values in above code ... any chance to introduce
>>> some #defines finally?
>>
>> Currently not really.
>> I added a comment for the diag 44 which should be enough right now. If
>> needed I can add a comment to the pei variables as well.
> 
> Ok, fine for me, we can still clean up later if necessary. Thus with the 
> assert() fixed and the mb() removed:
> 
> Acked-by: Thomas Huth <thuth@redhat.com>
> 

Thanks, I'll fix this up and queue the series

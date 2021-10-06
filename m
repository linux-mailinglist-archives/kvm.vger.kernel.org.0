Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70FEE423ACD
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 11:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237946AbhJFJt0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 05:49:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8966 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229824AbhJFJtZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 05:49:25 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19695ADp003240;
        Wed, 6 Oct 2021 05:47:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bxZvn+T+Wp88jwEmhD2lIEjp+pN9aJs7E73rae4ZIPk=;
 b=dRIqOPZXmNrcazuXINUcSba2hE7FZhRFt2l2YAHCrLlkhAUKZNiXo9ZXAwmSEPuEkMYU
 jRH9zWOyEc948oIn2Qx2Bb5pkKu4yVJqwEL0M9F/HYN+40PQFqJ5zRxPhbHSRfeg19Ta
 P7iek0QvdzSqakDCCV8XELS2Bzcs7Jrh+UUSYp8/lXPncrgABBgkjzm3lzBWCUzaYTVo
 nEdcQQSGKDOgzrkvaE5Ximd7dSQOOGb5uGf/rYjqLRqLzAcMYYGr/jqEoSM/1oeFlMRe
 EF82ct6Pr7H8lMRQCahAbW0z8KLRx2f0+3fPkMfFJYIZqKdz6kyD2a6o2DVfDijsPnDl 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bh2nc84kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 05:47:32 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1969awlX016580;
        Wed, 6 Oct 2021 05:47:32 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bh2nc84k5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 05:47:32 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1969hGDY014719;
        Wed, 6 Oct 2021 09:47:30 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3bef2ab9rb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 09:47:30 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1969lQpJ44696008
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Oct 2021 09:47:26 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9EEDD11C04C;
        Wed,  6 Oct 2021 09:47:26 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 202DC11C058;
        Wed,  6 Oct 2021 09:47:26 +0000 (GMT)
Received: from [9.145.176.174] (unknown [9.145.176.174])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 Oct 2021 09:47:25 +0000 (GMT)
Message-ID: <bf159812-b0da-c33f-b252-fafc89dd384e@linux.ibm.com>
Date:   Wed, 6 Oct 2021 11:47:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH v2 2/2] s390x: Add specification exception
 interception test
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211005091153.1863139-1-scgl@linux.ibm.com>
 <20211005091153.1863139-3-scgl@linux.ibm.com>
 <39131b39-bed8-9d8f-fd8d-32760494e9ec@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <39131b39-bed8-9d8f-fd8d-32760494e9ec@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pe8U6oihH9LorUBRWJD2YSWZmg8Nf1aI
X-Proofpoint-ORIG-GUID: QS56isVyqt0Bpx-NzgNqR0od04bF6bo5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-05_06,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 bulkscore=0 clxscore=1015 mlxscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110060060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/5/21 18:52, Thomas Huth wrote:
> On 05/10/2021 11.11, Janis Schoetterl-Glausch wrote:
>> Check that specification exceptions cause intercepts when
>> specification exception interpretation is off.
>> Check that specification exceptions caused by program new PSWs
>> cause interceptions.
>> We cannot assert that non program new PSW specification exceptions
>> are interpreted because whether interpretation occurs or not is
>> configuration dependent.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
>>    s390x/Makefile             |  2 +
>>    lib/s390x/sie.h            |  1 +
>>    s390x/snippets/c/spec_ex.c | 20 +++++++++
>>    s390x/spec_ex-sie.c        | 83 ++++++++++++++++++++++++++++++++++++++
>>    s390x/unittests.cfg        |  3 ++
>>    5 files changed, 109 insertions(+)
>>    create mode 100644 s390x/snippets/c/spec_ex.c
>>    create mode 100644 s390x/spec_ex-sie.c
>>
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index ef8041a..7198882 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -24,6 +24,7 @@ tests += $(TEST_DIR)/mvpg.elf
>>    tests += $(TEST_DIR)/uv-host.elf
>>    tests += $(TEST_DIR)/edat.elf
>>    tests += $(TEST_DIR)/mvpg-sie.elf
>> +tests += $(TEST_DIR)/spec_ex-sie.elf
>>    
>>    tests_binary = $(patsubst %.elf,%.bin,$(tests))
>>    ifneq ($(HOST_KEY_DOCUMENT),)
>> @@ -85,6 +86,7 @@ snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
>>    # perquisites (=guests) for the snippet hosts.
>>    # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
>>    $(TEST_DIR)/mvpg-sie.elf: snippets = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
>> +$(TEST_DIR)/spec_ex-sie.elf: snippets = $(SNIPPET_DIR)/c/spec_ex.gbin
>>    
>>    $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(FLATLIBS)
>>    	$(OBJCOPY) -O binary $(patsubst %.gbin,%.o,$@) $@
>> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
>> index ca514ef..7ef7251 100644
>> --- a/lib/s390x/sie.h
>> +++ b/lib/s390x/sie.h
>> @@ -98,6 +98,7 @@ struct kvm_s390_sie_block {
>>    	uint8_t		fpf;			/* 0x0060 */
>>    #define ECB_GS		0x40
>>    #define ECB_TE		0x10
>> +#define ECB_SPECI	0x08
>>    #define ECB_SRSI	0x04
>>    #define ECB_HOSTPROTINT	0x02
>>    	uint8_t		ecb;			/* 0x0061 */
>> diff --git a/s390x/snippets/c/spec_ex.c b/s390x/snippets/c/spec_ex.c
>> new file mode 100644
>> index 0000000..bdba4f4
>> --- /dev/null
>> +++ b/s390x/snippets/c/spec_ex.c
>> @@ -0,0 +1,20 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*

>> + *
>> + * Snippet used by specification exception interception test.
>> + */
>> +#include <stdint.h>
>> +#include <asm/arch_def.h>
>> +
>> +__attribute__((section(".text"))) int main(void)
>> +{
>> +	struct lowcore *lowcore = (struct lowcore *) 0;
>> +	uint64_t bad_psw = 0;
>> +
>> +	/* PSW bit 12 has no name or meaning and must be 0 */
>> +	lowcore->pgm_new_psw.mask = 1UL << (63 - 12);
>> +	lowcore->pgm_new_psw.addr = 0xdeadbeee;
>> +	asm volatile ("lpsw %0" :: "Q"(bad_psw));
>> +	return 0;
>> +}
>> diff --git a/s390x/spec_ex-sie.c b/s390x/spec_ex-sie.c
>> new file mode 100644
>> index 0000000..b7e79de
>> --- /dev/null
>> +++ b/s390x/spec_ex-sie.c
>> @@ -0,0 +1,83 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*

>> + *
>> + * Specification exception interception test.
>> + * Checks that specification exception interceptions occur as expected when
>> + * specification exception interpretation is off/on.
>> + */
>> +#include <libcflat.h>
>> +#include <sclp.h>
>> +#include <asm/page.h>
>> +#include <asm/arch_def.h>
>> +#include <alloc_page.h>
>> +#include <vm.h>
>> +#include <sie.h>
>> +
>> +static struct vm vm;
>> +extern const char _binary_s390x_snippets_c_spec_ex_gbin_start[];
>> +extern const char _binary_s390x_snippets_c_spec_ex_gbin_end[];
>> +
>> +static void setup_guest(void)
>> +{
>> +	char *guest;
>> +	int binary_size = ((uintptr_t)_binary_s390x_snippets_c_spec_ex_gbin_end -
>> +			   (uintptr_t)_binary_s390x_snippets_c_spec_ex_gbin_start);
>> +
>> +	setup_vm();
>> +	guest = alloc_pages(8);
>> +	memcpy(guest, _binary_s390x_snippets_c_spec_ex_gbin_start, binary_size);
>> +	sie_guest_create(&vm, (uint64_t) guest, HPAGE_SIZE);
>> +}
>> +
>> +static void reset_guest(void)
>> +{
>> +	vm.sblk->gpsw.addr = PAGE_SIZE * 4;
> 
> Could we please get a #define for this magic PAGE_SIZE * 4 value, with a
> comment mentioning that the value comes from s390x/snippets/c/flat.lds ?
> I know it's already like this in the mvpg-sie.c test, so this could also be
> done in a follow-up patch instead, to fix mvpg-sie.c, too.
> 
> By the way, Janosch, do you remember why it s PAGE_SIZE * 4 and not
> PAGE_SIZE * 2 ? Space for additional SMP lowcores?

I've put the stack on Page 4 because I can't guarantee what people do on 
higher pages so I hope we don't need more than a page or two for the 
stack. It's very much a hack :)

> 
>> +	vm.sblk->gpsw.mask = PSW_MASK_64;
>> +	vm.sblk->icptcode = 0;
>> +}
>> +
>> +static void test_spec_ex_sie(void)
>> +{
>> +	setup_guest();
>> +
>> +	report_prefix_push("SIE spec ex interpretation");
>> +	report_prefix_push("off");
>> +	reset_guest();
>> +	sie(&vm);
>> +	/* interpretation off -> initial exception must cause interception */
>> +	report(vm.sblk->icptcode == ICPT_PROGI
>> +	       && vm.sblk->iprcc == PGM_INT_CODE_SPECIFICATION
>> +	       && vm.sblk->gpsw.addr != 0xdeadbeee,
>> +	       "Received specification exception intercept for initial exception");
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("on");
>> +	vm.sblk->ecb |= ECB_SPECI;
>> +	reset_guest();
>> +	sie(&vm);
>> +	/* interpretation on -> configuration dependent if initial exception causes
>> +	 * interception, but invalid new program PSW must
>> +	 */
>> +	report(vm.sblk->icptcode == ICPT_PROGI
>> +	       && vm.sblk->iprcc == PGM_INT_CODE_SPECIFICATION,
>> +	       "Received specification exception intercept");
>> +	if (vm.sblk->gpsw.addr == 0xdeadbeee)
>> +		report_info("Interpreted initial exception, intercepted invalid program new PSW exception");
>> +	else
>> +		report_info("Did not interpret initial exception");
>> +	report_prefix_pop();
>> +	report_prefix_pop();
>> +}
>> +
>> +int main(int argc, char **argv)
>> +{
>> +	if (!sclp_facilities.has_sief2) {
>> +		report_skip("SIEF2 facility unavailable");
>> +		goto out;
>> +	}
>> +
>> +	test_spec_ex_sie();
>> +out:
>> +	return report_summary();
>> +}
>> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
>> index 9e1802f..3b454b7 100644
>> --- a/s390x/unittests.cfg
>> +++ b/s390x/unittests.cfg
>> @@ -109,3 +109,6 @@ file = edat.elf
>>    
>>    [mvpg-sie]
>>    file = mvpg-sie.elf
>> +
>> +[spec_ex-sie]
>> +file = spec_ex-sie.elf
>>
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 


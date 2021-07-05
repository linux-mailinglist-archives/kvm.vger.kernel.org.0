Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D263BBA88
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 11:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhGEJza (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 05:55:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28809 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230355AbhGEJza (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Jul 2021 05:55:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625478773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AujNyw6Vo3bT0b4TR8sqxMksatL66NowvmyyneksPGg=;
        b=IjK8L2MFHj6BAz89H1cgCTijIHDhssIppeZJb1f71Bybq44VAzoUzGT9fmu1CTZnYBUXMz
        7LT40dPI3z6vs28/IYJfj7gH5nnGH63xzQOLHOhllhH3tvbRJtTy+25F+R1rx3o84zXV9v
        I+kHqkqPksDF3lnElYGVtmM5couPdnQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-vDLMWYKFNsyIRmg9jqHlWQ-1; Mon, 05 Jul 2021 05:52:52 -0400
X-MC-Unique: vDLMWYKFNsyIRmg9jqHlWQ-1
Received: by mail-wm1-f72.google.com with SMTP id m7-20020a05600c4f47b02901ff81a3bb59so1087979wmq.2
        for <kvm@vger.kernel.org>; Mon, 05 Jul 2021 02:52:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AujNyw6Vo3bT0b4TR8sqxMksatL66NowvmyyneksPGg=;
        b=XU00+sV96C7MRXrIHjM+cZVgXTpCtMz2sVFlCQA+0lxYJdGSKq7mqWr6e0ZzuLsaHL
         9NxNntSa7Eto5DYbiJB5uEscdjPz4SLFF45ZWUe1UL27dYGyIfzu8ZWK5N2E+IBo2wX5
         rxV78acHmXXaI4oUBWNTDSm1E9G/CyabAGzZDPYW7DtifPe9vl5tfIMkWmYReYMx1nF2
         8DoCsU4W0grOCj/wPigbe4r2qyyIqldlIp1cb1ZTz3nwipoVM/zizxNjGFzyMInztriW
         bO5/P1mT63oPWRj/tqKFPpbeVTnu2VrkZ8f0NLAjqpRc7tWj2VjeLYaMKUYczwGr0xMc
         xVEQ==
X-Gm-Message-State: AOAM533j91Y4ZVJoiTsdmlKDktSbZXgTpdNcDEiZjsmLR6xuYp4UPJVE
        G7h+D+VjslSaHySSCizRDNlLQwuxbGU4ZXMQTHoGoeL5VXDqd2YLVubDl8N93coXxhFyNwk3HaT
        BltIKat+nmsem
X-Received: by 2002:a7b:c85a:: with SMTP id c26mr10389743wml.100.1625478770875;
        Mon, 05 Jul 2021 02:52:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHfS4sEm+Gz01XrsdGMfLxDP/KIyB3MVEUTJEtxYO61t0ir4p60V5SMJxCZQAEOQTpdihmeg==
X-Received: by 2002:a7b:c85a:: with SMTP id c26mr10389733wml.100.1625478770725;
        Mon, 05 Jul 2021 02:52:50 -0700 (PDT)
Received: from thuth.remote.csb (pd9575e1e.dip0.t-ipconnect.de. [217.87.94.30])
        by smtp.gmail.com with ESMTPSA id x21sm17072006wmj.6.2021.07.05.02.52.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jul 2021 02:52:50 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: mvpg: Add SIE mvpg test
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210629131841.17319-1-frankja@linux.ibm.com>
 <20210629131841.17319-4-frankja@linux.ibm.com>
 <d4966f2c-89b4-94b7-0dc7-df69534c2d7a@redhat.com>
 <8a742d45-bb49-d130-604a-da1e11150ef3@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <af215884-ad72-7e2e-cbc7-55a4bd0ee688@redhat.com>
Date:   Mon, 5 Jul 2021 11:52:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <8a742d45-bb49-d130-604a-da1e11150ef3@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/07/2021 11.37, Janosch Frank wrote:
> On 7/5/21 9:24 AM, Thomas Huth wrote:
>> On 29/06/2021 15.18, Janosch Frank wrote:
>>> Let's also check the PEI values to make sure our VSIE implementation
>>> is correct.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>    s390x/Makefile                  |   2 +
>>>    s390x/mvpg-sie.c                | 151 ++++++++++++++++++++++++++++++++
>>>    s390x/snippets/c/mvpg-snippet.c |  33 +++++++
>>>    s390x/unittests.cfg             |   3 +
>>>    4 files changed, 189 insertions(+)
>>>    create mode 100644 s390x/mvpg-sie.c
>>>    create mode 100644 s390x/snippets/c/mvpg-snippet.c
>>>
>>> diff --git a/s390x/Makefile b/s390x/Makefile
>>> index ba32f4c..07af26d 100644
>>> --- a/s390x/Makefile
>>> +++ b/s390x/Makefile
>>> @@ -23,6 +23,7 @@ tests += $(TEST_DIR)/sie.elf
>>>    tests += $(TEST_DIR)/mvpg.elf
>>>    tests += $(TEST_DIR)/uv-host.elf
>>>    tests += $(TEST_DIR)/edat.elf
>>> +tests += $(TEST_DIR)/mvpg-sie.elf
>>>    
>>>    tests_binary = $(patsubst %.elf,%.bin,$(tests))
>>>    ifneq ($(HOST_KEY_DOCUMENT),)
>>> @@ -82,6 +83,7 @@ snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
>>>    
>>>    # perquisites (=guests) for the snippet hosts.
>>>    # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
>>> +$(TEST_DIR)/mvpg-sie.elf: snippets = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
>>>    
>>>    $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(FLATLIBS)
>>>    	$(OBJCOPY) -O binary $(patsubst %.gbin,%.o,$@) $@
>>> diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
>>> new file mode 100644
>>> index 0000000..3536c6a
>>> --- /dev/null
>>> +++ b/s390x/mvpg-sie.c
>>> @@ -0,0 +1,151 @@
>>> +#include <libcflat.h>
>>> +#include <asm/asm-offsets.h>
>>> +#include <asm-generic/barrier.h>
>>> +#include <asm/pgtable.h>
>>> +#include <mmu.h>
>>> +#include <asm/page.h>
>>> +#include <asm/facility.h>
>>> +#include <asm/mem.h>
>>> +#include <alloc_page.h>
>>> +#include <vm.h>
>>> +#include <sclp.h>
>>> +#include <sie.h>
>>> +
>>> +static u8 *guest;
>>> +static u8 *guest_instr;
>>> +static struct vm vm;
>>> +
>>> +static uint8_t *src;
>>> +static uint8_t *dst;
>>> +static uint8_t *cmp;
>>> +
>>> +extern const char _binary_s390x_snippets_c_mvpg_snippet_gbin_start[];
>>> +extern const char _binary_s390x_snippets_c_mvpg_snippet_gbin_end[];
>>> +int binary_size;
>>> +
>>> +static void sie(struct vm *vm)
>>> +{
>>> +	/* Reset icptcode so we don't trip over it below */
>>> +	vm->sblk->icptcode = 0;
>>> +
>>> +	while (vm->sblk->icptcode == 0) {
>>> +		sie64a(vm->sblk, &vm->save_area);
>>> +		if (vm->sblk->icptcode == ICPT_VALIDITY)
>>> +			assert(0);
>>
>> Please replace the above two lines with:
>>
>> 		assert(vm->sblk->icptcode != ICPT_VALIDITY);
> 
> Sure
> 
>>
>>> +	}
>>> +	vm->save_area.guest.grs[14] = vm->sblk->gg14;
>>> +	vm->save_area.guest.grs[15] = vm->sblk->gg15;
>>> +}
>>> +
>>> +static void test_mvpg_pei(void)
>>> +{
>>> +	uint64_t **pei_dst = (uint64_t **)((uintptr_t) vm.sblk + 0xc0);
>>> +	uint64_t **pei_src = (uint64_t **)((uintptr_t) vm.sblk + 0xc8);
>>> +
>>> +	report_prefix_push("pei");
>>> +
>>> +	report_prefix_push("src");
>>> +	memset(dst, 0, PAGE_SIZE);
>>> +	protect_page(src, PAGE_ENTRY_I);
>>> +	sie(&vm);
>>> +	report(vm.sblk->icptcode == ICPT_PARTEXEC, "Partial execution");
>>> +	report((uintptr_t)**pei_src == (uintptr_t)src + PAGE_ENTRY_I, "PEI_SRC correct");
>>> +	report((uintptr_t)**pei_dst == (uintptr_t)dst, "PEI_DST correct");
>>> +	unprotect_page(src, PAGE_ENTRY_I);
>>> +	report(!memcmp(cmp, dst, PAGE_SIZE), "Destination intact");
>>> +	/*
>>> +	 * We need to execute the diag44 which is used as a blocker
>>> +	 * behind the mvpg. It makes sure we fail the tests above if
>>> +	 * the mvpg wouldn't have intercepted.
>>> +	 */
>>> +	sie(&vm);
>>> +	/* Make sure we intercepted for the diag44 and nothing else */
>>> +	assert(vm.sblk->icptcode == ICPT_INST &&
>>> +	       vm.sblk->ipa == 0x8300 && vm.sblk->ipb == 0x440000);
>>> +	report_prefix_pop();
>>> +
>>> +	/* Clear PEI data for next check */
>>> +	report_prefix_push("dst");
>>> +	memset((uint64_t *)((uintptr_t) vm.sblk + 0xc0), 0, 16);
>>> +	memset(dst, 0, PAGE_SIZE);
>>> +	protect_page(dst, PAGE_ENTRY_I);
>>> +	sie(&vm);
>>> +	report(vm.sblk->icptcode == ICPT_PARTEXEC, "Partial execution");
>>> +	report((uintptr_t)**pei_src == (uintptr_t)src, "PEI_SRC correct");
>>> +	report((uintptr_t)**pei_dst == (uintptr_t)dst + PAGE_ENTRY_I, "PEI_DST correct");
>>> +	/* Needed for the memcmp and general cleanup */
>>> +	unprotect_page(dst, PAGE_ENTRY_I);
>>> +	report(!memcmp(cmp, dst, PAGE_SIZE), "Destination intact");
>>> +	report_prefix_pop();
>>> +
>>> +	report_prefix_pop();
>>> +}
>>
>> Still quite a lot of magic values in above code ... any chance to introduce
>> some #defines finally?
> 
> Currently not really.
> I added a comment for the diag 44 which should be enough right now. If
> needed I can add a comment to the pei variables as well.

Ok, fine for me, we can still clean up later if necessary. Thus with the 
assert() fixed and the mb() removed:

Acked-by: Thomas Huth <thuth@redhat.com>


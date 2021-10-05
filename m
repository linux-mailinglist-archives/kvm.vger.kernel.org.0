Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E24422E6D
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 18:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235045AbhJEQx6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 12:53:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29859 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233825AbhJEQx5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 12:53:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633452726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hCWIjVnMI1KAdvnTPf2E5L4mV/J0fnzfxZ+RvWx9UdE=;
        b=CA51MRy7uHUaIOfRwn82iA3w3A1VY2TzRV3oI8JVKDvpHjiXTcwrz2WEG0y5djZsPeOnVo
        +weRhaEhMK5LuitA00qDmBA/oXf+UuUMOv5UFtvFXww2U2Bl9qb7wBZ5kcQbT84bSUY0N6
        WQfH51I0WGnBeA/r5b9o9HlBAhH/TIg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-D081vvp_Oy2VMLBryrNXAg-1; Tue, 05 Oct 2021 12:52:05 -0400
X-MC-Unique: D081vvp_Oy2VMLBryrNXAg-1
Received: by mail-wr1-f69.google.com with SMTP id l6-20020adfa386000000b00160c4c1866eso39170wrb.4
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 09:52:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hCWIjVnMI1KAdvnTPf2E5L4mV/J0fnzfxZ+RvWx9UdE=;
        b=7TJ7zWD7WHveoh+8UrGB9OgC26JomcW3RiUrrhqoev0i6yXHrZdRfQh+gRR0S7YcG9
         phOY4/DaK0CVUmjU0vFjp/Cvj4ctPcMN89oYQB1C1uVZv3Bf4PWzfpuqI27gtzT7v9Tr
         l0G7mC0ASB/YCLMDBCfbVTyq2ibgG6Z4veYcOB0ibaJ1L9FXAZarfD+yL/iUHJND8ity
         UTGVt9W2xZheO6/zux0jUUYvXOZtmA0wPYQWzRn8ahLlFH8qOPyZTKB97gKGI1j4WdKX
         9E3miPnaYDZ8fvmy7nP47gGCoqXI8LNU8rHfGIavn96OTwZuV/Q2jMdRpXnT3duiOHly
         /Smw==
X-Gm-Message-State: AOAM5338dLcCrB1keaHuU+qgLsTkDYQxUyrYn1mMS1AcpIvun71bejm7
        O44QEUvgO4ojkL7qRe5yJL2TmXLClm/Pro1KXCiLO7d6Dxexum+wktSaAbHnCRh/rgIdrVqdaVg
        /VNnYm9axxOHe
X-Received: by 2002:a5d:670e:: with SMTP id o14mr1132725wru.417.1633452724207;
        Tue, 05 Oct 2021 09:52:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyP6+yKYxuLy/KUt2KDjenBf296VEgNekQi8uSwXl/jgQtFlGJg9bnx31z3cpYKwDLDOUhQWQ==
X-Received: by 2002:a5d:670e:: with SMTP id o14mr1132700wru.417.1633452723977;
        Tue, 05 Oct 2021 09:52:03 -0700 (PDT)
Received: from thuth.remote.csb (p549bb2bd.dip0.t-ipconnect.de. [84.155.178.189])
        by smtp.gmail.com with ESMTPSA id v6sm10428412wrd.71.2021.10.05.09.52.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 09:52:03 -0700 (PDT)
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211005091153.1863139-1-scgl@linux.ibm.com>
 <20211005091153.1863139-3-scgl@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/2] s390x: Add specification exception
 interception test
Message-ID: <39131b39-bed8-9d8f-fd8d-32760494e9ec@redhat.com>
Date:   Tue, 5 Oct 2021 18:52:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211005091153.1863139-3-scgl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/10/2021 11.11, Janis Schoetterl-Glausch wrote:
> Check that specification exceptions cause intercepts when
> specification exception interpretation is off.
> Check that specification exceptions caused by program new PSWs
> cause interceptions.
> We cannot assert that non program new PSW specification exceptions
> are interpreted because whether interpretation occurs or not is
> configuration dependent.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>   s390x/Makefile             |  2 +
>   lib/s390x/sie.h            |  1 +
>   s390x/snippets/c/spec_ex.c | 20 +++++++++
>   s390x/spec_ex-sie.c        | 83 ++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg        |  3 ++
>   5 files changed, 109 insertions(+)
>   create mode 100644 s390x/snippets/c/spec_ex.c
>   create mode 100644 s390x/spec_ex-sie.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index ef8041a..7198882 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -24,6 +24,7 @@ tests += $(TEST_DIR)/mvpg.elf
>   tests += $(TEST_DIR)/uv-host.elf
>   tests += $(TEST_DIR)/edat.elf
>   tests += $(TEST_DIR)/mvpg-sie.elf
> +tests += $(TEST_DIR)/spec_ex-sie.elf
>   
>   tests_binary = $(patsubst %.elf,%.bin,$(tests))
>   ifneq ($(HOST_KEY_DOCUMENT),)
> @@ -85,6 +86,7 @@ snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
>   # perquisites (=guests) for the snippet hosts.
>   # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
>   $(TEST_DIR)/mvpg-sie.elf: snippets = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
> +$(TEST_DIR)/spec_ex-sie.elf: snippets = $(SNIPPET_DIR)/c/spec_ex.gbin
>   
>   $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(FLATLIBS)
>   	$(OBJCOPY) -O binary $(patsubst %.gbin,%.o,$@) $@
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> index ca514ef..7ef7251 100644
> --- a/lib/s390x/sie.h
> +++ b/lib/s390x/sie.h
> @@ -98,6 +98,7 @@ struct kvm_s390_sie_block {
>   	uint8_t		fpf;			/* 0x0060 */
>   #define ECB_GS		0x40
>   #define ECB_TE		0x10
> +#define ECB_SPECI	0x08
>   #define ECB_SRSI	0x04
>   #define ECB_HOSTPROTINT	0x02
>   	uint8_t		ecb;			/* 0x0061 */
> diff --git a/s390x/snippets/c/spec_ex.c b/s390x/snippets/c/spec_ex.c
> new file mode 100644
> index 0000000..bdba4f4
> --- /dev/null
> +++ b/s390x/snippets/c/spec_ex.c
> @@ -0,0 +1,20 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * © Copyright IBM Corp. 2021
> + *
> + * Snippet used by specification exception interception test.
> + */
> +#include <stdint.h>
> +#include <asm/arch_def.h>
> +
> +__attribute__((section(".text"))) int main(void)
> +{
> +	struct lowcore *lowcore = (struct lowcore *) 0;
> +	uint64_t bad_psw = 0;
> +
> +	/* PSW bit 12 has no name or meaning and must be 0 */
> +	lowcore->pgm_new_psw.mask = 1UL << (63 - 12);
> +	lowcore->pgm_new_psw.addr = 0xdeadbeee;
> +	asm volatile ("lpsw %0" :: "Q"(bad_psw));
> +	return 0;
> +}
> diff --git a/s390x/spec_ex-sie.c b/s390x/spec_ex-sie.c
> new file mode 100644
> index 0000000..b7e79de
> --- /dev/null
> +++ b/s390x/spec_ex-sie.c
> @@ -0,0 +1,83 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * © Copyright IBM Corp. 2021
> + *
> + * Specification exception interception test.
> + * Checks that specification exception interceptions occur as expected when
> + * specification exception interpretation is off/on.
> + */
> +#include <libcflat.h>
> +#include <sclp.h>
> +#include <asm/page.h>
> +#include <asm/arch_def.h>
> +#include <alloc_page.h>
> +#include <vm.h>
> +#include <sie.h>
> +
> +static struct vm vm;
> +extern const char _binary_s390x_snippets_c_spec_ex_gbin_start[];
> +extern const char _binary_s390x_snippets_c_spec_ex_gbin_end[];
> +
> +static void setup_guest(void)
> +{
> +	char *guest;
> +	int binary_size = ((uintptr_t)_binary_s390x_snippets_c_spec_ex_gbin_end -
> +			   (uintptr_t)_binary_s390x_snippets_c_spec_ex_gbin_start);
> +
> +	setup_vm();
> +	guest = alloc_pages(8);
> +	memcpy(guest, _binary_s390x_snippets_c_spec_ex_gbin_start, binary_size);
> +	sie_guest_create(&vm, (uint64_t) guest, HPAGE_SIZE);
> +}
> +
> +static void reset_guest(void)
> +{
> +	vm.sblk->gpsw.addr = PAGE_SIZE * 4;

Could we please get a #define for this magic PAGE_SIZE * 4 value, with a 
comment mentioning that the value comes from s390x/snippets/c/flat.lds ?
I know it's already like this in the mvpg-sie.c test, so this could also be 
done in a follow-up patch instead, to fix mvpg-sie.c, too.

By the way, Janosch, do you remember why it s PAGE_SIZE * 4 and not 
PAGE_SIZE * 2 ? Space for additional SMP lowcores?

> +	vm.sblk->gpsw.mask = PSW_MASK_64;
> +	vm.sblk->icptcode = 0;
> +}
> +
> +static void test_spec_ex_sie(void)
> +{
> +	setup_guest();
> +
> +	report_prefix_push("SIE spec ex interpretation");
> +	report_prefix_push("off");
> +	reset_guest();
> +	sie(&vm);
> +	/* interpretation off -> initial exception must cause interception */
> +	report(vm.sblk->icptcode == ICPT_PROGI
> +	       && vm.sblk->iprcc == PGM_INT_CODE_SPECIFICATION
> +	       && vm.sblk->gpsw.addr != 0xdeadbeee,
> +	       "Received specification exception intercept for initial exception");
> +	report_prefix_pop();
> +
> +	report_prefix_push("on");
> +	vm.sblk->ecb |= ECB_SPECI;
> +	reset_guest();
> +	sie(&vm);
> +	/* interpretation on -> configuration dependent if initial exception causes
> +	 * interception, but invalid new program PSW must
> +	 */
> +	report(vm.sblk->icptcode == ICPT_PROGI
> +	       && vm.sblk->iprcc == PGM_INT_CODE_SPECIFICATION,
> +	       "Received specification exception intercept");
> +	if (vm.sblk->gpsw.addr == 0xdeadbeee)
> +		report_info("Interpreted initial exception, intercepted invalid program new PSW exception");
> +	else
> +		report_info("Did not interpret initial exception");
> +	report_prefix_pop();
> +	report_prefix_pop();
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	if (!sclp_facilities.has_sief2) {
> +		report_skip("SIEF2 facility unavailable");
> +		goto out;
> +	}
> +
> +	test_spec_ex_sie();
> +out:
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 9e1802f..3b454b7 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -109,3 +109,6 @@ file = edat.elf
>   
>   [mvpg-sie]
>   file = mvpg-sie.elf
> +
> +[spec_ex-sie]
> +file = spec_ex-sie.elf
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>


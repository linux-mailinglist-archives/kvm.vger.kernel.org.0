Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA26C5086C5
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 13:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377954AbiDTLT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 07:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377942AbiDTLT2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 07:19:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8DBD1403F0
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 04:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650453401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s9Z0SXFr6f7Ryx5xLW/gn1t0pJU586w68GYQ2wHi0yY=;
        b=ffWi5gQB9a/e/qvtFFOp94g6IDrk08ahLwRbOiMW5p5NJoHFNM2UROLGZfZu23y2vds/hI
        UlcG9QjeoED5syhESM1C14IrTakIYUq0YW38oSFdE26HACvuexXzbDrZYOwoir9G/Na9be
        0Cd77LVrUiaFzacxXKmUypH4jDRR2o0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-113-AK4-pU46NQaCM4gAPMYHgQ-1; Wed, 20 Apr 2022 07:16:40 -0400
X-MC-Unique: AK4-pU46NQaCM4gAPMYHgQ-1
Received: by mail-wm1-f69.google.com with SMTP id q188-20020a1c43c5000000b003928f679c42so781282wma.5
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 04:16:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=s9Z0SXFr6f7Ryx5xLW/gn1t0pJU586w68GYQ2wHi0yY=;
        b=I0KWwzJXUnXouIOy1MWxVT7/dFNVxS2xxJ+xhUgNYNX+gAnBBUxvbRA92+16Yvt/zU
         0b1+6WEmF+nBdJLQOqdb3T1VHrfpPJJBzsVGLhCNOgd7kpXL87QXx1fz3cwSbnp3ED1I
         4Ad1a/xFee7hdIlu+azLC4yrFP/6Ve7vasOFwLtHdeo4kiRAFdFv+YKO41Yr+dHFQH/7
         AwUOk9sFWTXpzYFi/TNBSb8P+MbgVX23uw/IUWQDSDDDbWEGVPhc8fK8toHwlIgHp2mT
         uFkwOpkQ5R84muDhWpU6Xn7ivyoFlWKABScpLVcdWZNETQFsmQLHsEZ+16qBMkHoQ4tg
         jxww==
X-Gm-Message-State: AOAM531cDw6YwaeDePXIhKQ2r7iIm96ttjDfz2m/M2GcQJGEXWGRpd2E
        jQ3Ij9P1prH8eMscUB+dfiJ+oh5NKebQOhDOQk0yZN3tJ2bznRt/mfBHCBnc3/CnypTSAy3Xojh
        hveuTqzyG0+if
X-Received: by 2002:a05:6000:18ad:b0:20a:850a:ff81 with SMTP id b13-20020a05600018ad00b0020a850aff81mr15048368wri.547.1650453399447;
        Wed, 20 Apr 2022 04:16:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxOUrAhBGxGcwIPOo8+LKUM2sGJIbbBNfTzwt2ngvBltIA8UeA2qzQObEw3XReEoLd9VfdXIw==
X-Received: by 2002:a05:6000:18ad:b0:20a:850a:ff81 with SMTP id b13-20020a05600018ad00b0020a850aff81mr15048342wri.547.1650453399157;
        Wed, 20 Apr 2022 04:16:39 -0700 (PDT)
Received: from [192.168.8.102] (dynamic-046-114-174-058.46.114.pool.telefonica.de. [46.114.174.58])
        by smtp.gmail.com with ESMTPSA id m65-20020a1ca344000000b0038ec75d90a8sm18446685wme.2.2022.04.20.04.16.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Apr 2022 04:16:38 -0700 (PDT)
Message-ID: <1e8fc64b-33e8-94c5-d577-ec2e6089d7ed@redhat.com>
Date:   Wed, 20 Apr 2022 13:16:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20220413152658.715003-1-nrb@linux.ibm.com>
 <20220413152658.715003-5-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 4/4] s390x: add basic migration test
In-Reply-To: <20220413152658.715003-5-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/04/2022 17.26, Nico Boehr wrote:
> Add a basic migration test for s390x. This tests the guarded-storage registers
> and vector registers are preserved on migration.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   s390x/Makefile      |   1 +
>   s390x/migration.c   | 172 ++++++++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg |   5 ++
>   3 files changed, 178 insertions(+)
>   create mode 100644 s390x/migration.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index f38f442b9cb1..5336ed8ae0b4 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -30,6 +30,7 @@ tests += $(TEST_DIR)/spec_ex-sie.elf
>   tests += $(TEST_DIR)/firq.elf
>   tests += $(TEST_DIR)/epsw.elf
>   tests += $(TEST_DIR)/adtl-status.elf
> +tests += $(TEST_DIR)/migration.elf
>   
>   pv-tests += $(TEST_DIR)/pv-diags.elf
>   
> diff --git a/s390x/migration.c b/s390x/migration.c
> new file mode 100644
> index 000000000000..cd9360bdadec
> --- /dev/null
> +++ b/s390x/migration.c
> @@ -0,0 +1,172 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Migration Test for s390x
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * Authors:
> + *  Nico Boehr <nrb@linux.ibm.com>
> + */
> +#include <libcflat.h>
> +#include <asm/arch_def.h>
> +#include <asm/vector.h>
> +#include <asm/barrier.h>
> +#include <gs.h>
> +#include <bitops.h>
> +#include <smp.h>
> +
> +static struct gs_cb gs_cb;
> +static struct gs_epl gs_epl;
> +
> +/* set by CPU1 to signal it has completed */
> +static int flag_thread_complete;
> +/* set by CPU0 to signal migration has completed */
> +static int flag_migration_complete;
> +
> +static void write_gs_regs(void)
> +{
> +	const unsigned long gs_area = 0x2000000;
> +	const unsigned long gsc = 25; /* align = 32 M, section size = 512K */
> +
> +	gs_cb.gsd = gs_area | gsc;
> +	gs_cb.gssm = 0xfeedc0ffe;
> +	gs_cb.gs_epl_a = (uint64_t) &gs_epl;
> +
> +	load_gs_cb(&gs_cb);
> +}
> +
> +static void check_gs_regs(void)
> +{
> +	struct gs_cb gs_cb_after_migration;
> +
> +	store_gs_cb(&gs_cb_after_migration);
> +
> +	report_prefix_push("guarded-storage registers");
> +
> +	report(gs_cb_after_migration.gsd == gs_cb.gsd, "gsd matches");
> +	report(gs_cb_after_migration.gssm == gs_cb.gssm, "gssm matches");
> +	report(gs_cb_after_migration.gs_epl_a == gs_cb.gs_epl_a, "gs_epl_a matches");
> +
> +	report_prefix_pop();
> +}
> +
> +static void test_func(void)
> +{
> +	uint8_t expected_vec_contents[VEC_REGISTER_NUM][VEC_REGISTER_SIZE];
> +	uint8_t actual_vec_contents[VEC_REGISTER_NUM][VEC_REGISTER_SIZE];
> +	uint8_t *vec_reg;
> +	int i;
> +	int vec_result = 0;
> +
> +	for (i = 0; i < VEC_REGISTER_NUM; i++) {
> +		vec_reg = &expected_vec_contents[i][0];
> +		/* i+1 to avoid zero content */
> +		memset(vec_reg, i + 1, VEC_REGISTER_SIZE);
> +	}
> +
> +	ctl_set_bit(0, CTL0_VECTOR);
> +	ctl_set_bit(2, CTL2_GUARDED_STORAGE);
> +
> +	write_gs_regs();
> +
> +	/*
> +	 * It is important loading the loading point registers and comparing

s/loading point/floating point/

> +	 * their contents occurs in the same inline assembly block. Otherwise,
> +	 * the compiler is allowed to re-use the registers for something else in
> +	 * between.
> +	 * For this very reason, this also runs on a second CPU, so all the
> +	 * complex console stuff can be done in C on the first CPU and here we
> +	 * just need to wait for it to set the flag.
> +	 */
> +	asm inline(
> +		"	.machine z13\n"
> +		/* load vector registers: vlm handles at most 16 registers at a time */
> +		"	vlm 0,15, 0(%[expected_vec_reg])\n"
> +		"	vlm 16,31, 256(%[expected_vec_reg])\n"
> +		/* inform CPU0 we are done, it will request migration */
> +		"	mvhi %[flag_thread_complete], 1\n"
> +		/* wait for migration to finish */
> +		"0:	clfhsi %[flag_migration_complete], 1\n"
> +		"	jnz 0b\n"
> +		/*
> +		 * store vector register contents in actual_vec_reg: vstm
> +		 * handles at most 16 registers at a time
> +		 */
> +		"	vstm 0,15, 0(%[actual_vec_reg])\n"
> +		"	vstm 16,31, 256(%[actual_vec_reg])\n"
> +		/*
> +		 * compare the contents in expected_vec_reg with actual_vec_reg:
> +		 * clc handles at most 256 bytes at a time
> +		 */
> +		"	clc 0(256, %[expected_vec_reg]), 0(%[actual_vec_reg])\n"
> +		"	jnz 1f\n"
> +		"	clc 256(256, %[expected_vec_reg]), 256(%[actual_vec_reg])\n"
> +		"	jnz 1f\n"
> +		/* success */
> +		"	mvhi %[vec_result], 1\n"
> +		"1:"
> +		:
> +		: [expected_vec_reg] "a"(expected_vec_contents),
> +		  [actual_vec_reg] "a"(actual_vec_contents),
> +		  [flag_thread_complete] "Q"(flag_thread_complete),
> +		  [flag_migration_complete] "Q"(flag_migration_complete),
> +		  [vec_result] "Q"(vec_result)
> +		: "v0", "v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9",
> +		  "v10", "v11", "v12", "v13", "v14", "v15", "v16", "v17", "v18",
> +		  "v19", "v20", "v21", "v22", "v23", "v24", "v25", "v26", "v27",
> +		  "v28", "v29", "v30", "v31", "cc", "memory"
> +	);
> +
> +	report(vec_result, "vector contents match");
> +
> +	check_gs_regs();
> +
> +	report(stctg(0) & BIT(CTL0_VECTOR), "ctl0 vector bit set");
> +	report(stctg(2) & BIT(CTL2_GUARDED_STORAGE), "ctl2 guarded-storage bit set");
> +
> +	ctl_clear_bit(0, CTL0_VECTOR);
> +	ctl_clear_bit(2, CTL2_GUARDED_STORAGE);
> +
> +	flag_thread_complete = 1;
> +}
> +
> +int main(void)
> +{
> +	struct psw psw;
> +
> +	/* don't say migrate here otherwise we will migrate right away */
> +	report_prefix_push("migration");
> +
> +	if (smp_query_num_cpus() == 1) {
> +		report_skip("need at least 2 cpus for this test");
> +		goto done;
> +	}
> +
> +	/* Second CPU does the actual tests */
> +	psw.mask = extract_psw_mask();
> +	psw.addr = (unsigned long)test_func;
> +	smp_cpu_setup(1, psw);
> +
> +	/* wait for thread setup */
> +	while(!flag_thread_complete)
> +		mb();
> +	flag_thread_complete = 0;
> +
> +	/* ask migrate_cmd to migrate (it listens for 'migrate') */
> +	puts("Please migrate me\n");

Maybe say: "Please migrate me, then press 'return'" in case somebody runs 
this test manually?

> +	/* wait for migration to finish, we will read a newline */
> +	(void)getchar();
> +
> +	flag_migration_complete = 1;
> +
> +	/* wait for thread to complete assertions */
> +	while(!flag_thread_complete)
> +		mb();
> +
> +	smp_cpu_destroy(1);
> +
> +done:
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 256c71691adc..b456b2881448 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -171,3 +171,8 @@ file = adtl-status.elf
>   smp = 2
>   accel = tcg
>   extra_params = -cpu qemu,gs=off,vx=off
> +
> +[migration]
> +file = migration.elf
> +groups = migration
> +smp = 2

Thanks, looks fine to me now (apart from the two nits)!

Reviewed-by: Thomas Huth <thuth@redhat.com>


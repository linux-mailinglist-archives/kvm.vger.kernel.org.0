Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C4E6D64FD
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 16:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbjDDOQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 10:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235045AbjDDOQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 10:16:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B242129
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 07:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680617761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cxBEJAc8RFoor2xvPbBN5nRCRc3g9X5g/BlRUmLmy+0=;
        b=JHdTPTDnn5/47cWYWykHJBa9t01i6Cp6wVIiYGmFcS3TdKTQdP0Yo09UBqfaGufoPQWHoc
        a1kFvk0YjBmAxdWZlUk7W8vE5ZEJj4g2SzHhmeJImjV8trI31HDez6Jr8hTYS1a6QwJ9nF
        dEslsosL/ljovOPAjDuhZGPQ8bNblfI=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-156-KGz05K4bOLStT59tfaQaGg-1; Tue, 04 Apr 2023 10:15:59 -0400
X-MC-Unique: KGz05K4bOLStT59tfaQaGg-1
Received: by mail-qt1-f198.google.com with SMTP id c14-20020ac87d8e000000b003e38726ec8bso22200961qtd.23
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 07:15:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680617759;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cxBEJAc8RFoor2xvPbBN5nRCRc3g9X5g/BlRUmLmy+0=;
        b=hIP+vecfrQ02cVZ7MEtdd9Op1c9e613S1wslaagZsBQyUm26ROHJm3PBRDF936JW5G
         sar4+u7zHIPZK3zBO9LFZJNfXVDCdiZbh2nZxZ73T4ljqZHrPmpMq/vF3UfIxYO27cXt
         swMxgJfiD3GTCYR7riZ6nTEGM5l9AwctSOSA+783Nep7vUBucpYs4e9tGx18PCIJkhZ3
         W8d5C3xQinby/bUaKb7o379NvDyEfS//ZWnDs3+w9W9+dRam4f+wsMtvCycKzbhLE+1D
         rRUY2j9VZozJYNaLHA0SeIezaljCOyjhAlCj6HfLFBQHM7T7gGVb8X7y4hgeskOSudLR
         gGAQ==
X-Gm-Message-State: AAQBX9fIo7vMFMQP0bfCLIaI+SJhyB7YLpfrZvmj6LIdzpOT2ovcs/IJ
        GoteI628CAK23XTcPcub8HWkg19oCyLhUHshsPhC2TuBDa3uK74fsOSifeZu9ZEsbIg55uR1Uxi
        ZCJEOKsE1HElI
X-Received: by 2002:ad4:5766:0:b0:5ac:96c3:14ca with SMTP id r6-20020ad45766000000b005ac96c314camr4047571qvx.33.1680617759160;
        Tue, 04 Apr 2023 07:15:59 -0700 (PDT)
X-Google-Smtp-Source: AKy350ame7l/nmEFSSNoZMUTUu7bS2oKnaKcxCI/+DNae3sqcldi/7N11zvKfcPffWlb7VQxEUtkhA==
X-Received: by 2002:ad4:5766:0:b0:5ac:96c3:14ca with SMTP id r6-20020ad45766000000b005ac96c314camr4047530qvx.33.1680617758745;
        Tue, 04 Apr 2023 07:15:58 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-178-74.web.vodafone.de. [109.43.178.74])
        by smtp.gmail.com with ESMTPSA id mh10-20020a056214564a00b005dd8b9345d7sm3418525qvb.111.2023.04.04.07.15.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 07:15:58 -0700 (PDT)
Message-ID: <65075e9f-0d32-fc63-0200-3a3ec0c9bf63@redhat.com>
Date:   Tue, 4 Apr 2023 16:15:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, pbonzini@redhat.com,
        andrew.jones@linux.dev, Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20230404113639.37544-1-nrb@linux.ibm.com>
 <20230404113639.37544-12-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests GIT PULL v2 11/14] s390x: Add tests for
 execute-type instructions
In-Reply-To: <20230404113639.37544-12-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/04/2023 13.36, Nico Boehr wrote:
> From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> 
> Test the instruction address used by targets of an execute instruction.
> When the target instruction calculates a relative address, the result is
> relative to the target instruction, not the execute instruction.
> 
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Link: https://lore.kernel.org/r/20230317112339.774659-1-nsg@linux.ibm.com
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   s390x/Makefile      |   1 +
>   s390x/ex.c          | 188 ++++++++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg |   3 +
>   .gitlab-ci.yml      |   1 +
>   4 files changed, 193 insertions(+)
>   create mode 100644 s390x/ex.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index ab146eb..a80db53 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -39,6 +39,7 @@ tests += $(TEST_DIR)/panic-loop-extint.elf
>   tests += $(TEST_DIR)/panic-loop-pgm.elf
>   tests += $(TEST_DIR)/migration-sck.elf
>   tests += $(TEST_DIR)/exittime.elf
> +tests += $(TEST_DIR)/ex.elf
>   
>   pv-tests += $(TEST_DIR)/pv-diags.elf
>   
> diff --git a/s390x/ex.c b/s390x/ex.c
> new file mode 100644
> index 0000000..dbd8030
> --- /dev/null
> +++ b/s390x/ex.c
> @@ -0,0 +1,188 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright IBM Corp. 2023
> + *
> + * Test EXECUTE (RELATIVE LONG).
> + * These instructions execute a target instruction. The target instruction is formed
> + * by reading an instruction from memory and optionally modifying some of its bits.
> + * The execution of the target instruction is the same as if it was executed
> + * normally as part of the instruction sequence, except for the instruction
> + * address and the instruction-length code.
> + */
> +
> +#include <libcflat.h>
> +
> +/*
> + * Accesses to the operand of execute-type instructions are instruction fetches.
> + * Minimum alignment is two, since the relative offset is specified by number of halfwords.
> + */
> +asm (  ".pushsection .text.exrl_targets,\"x\"\n"
> +"	.balign	2\n"
> +"	.popsection\n"
> +);
> +
> +/*
> + * BRANCH AND SAVE, register register variant.
> + * Saves the next instruction address (address from PSW + length of instruction)
> + * to the first register. No branch is taken in this test, because 0 is
> + * specified as target.
> + * BASR does *not* perform a relative address calculation with an intermediate.
> + */
> +static void test_basr(void)
> +{
> +	uint64_t ret_addr, after_ex;
> +
> +	report_prefix_push("BASR");
> +	asm volatile ( ".pushsection .text.exrl_targets\n"
> +		"0:	basr	%[ret_addr],0\n"
> +		"	.popsection\n"
> +
> +		"	larl	%[after_ex],1f\n"
> +		"	exrl	0,0b\n"
> +		"1:\n"
> +		: [ret_addr] "=d" (ret_addr),
> +		  [after_ex] "=d" (after_ex)
> +	);
> +
> +	report(ret_addr == after_ex, "return address after EX");
> +	report_prefix_pop();
> +}
> +
> +/*
> + * BRANCH RELATIVE AND SAVE.
> + * According to PoP (Branch-Address Generation), the address calculated relative
> + * to the instruction address is relative to BRAS when it is the target of an
> + * execute-type instruction, not relative to the execute-type instruction.
> + */
> +static void test_bras(void)
> +{
> +	uint64_t after_target, ret_addr, after_ex, branch_addr;
> +
> +	report_prefix_push("BRAS");
> +	asm volatile ( ".pushsection .text.exrl_targets\n"
> +		"0:	bras	%[ret_addr],1f\n"
> +		"	nopr	%%r7\n"
> +		"1:	larl	%[branch_addr],0\n"
> +		"	j	4f\n"
> +		"	.popsection\n"
> +
> +		"	larl	%[after_target],1b\n"
> +		"	larl	%[after_ex],3f\n"
> +		"2:	exrl	0,0b\n"
> +/*
> + * In case the address calculation is correct, we jump by the relative offset 1b-0b from 0b to 1b.
> + * In case the address calculation is relative to the exrl (i.e. a test failure),
> + * put a valid instruction at the same relative offset from the exrl, so the test continues in a
> + * controlled manner.
> + */
> +		"3:	larl	%[branch_addr],0\n"
> +		"4:\n"
> +
> +		"	.if (1b - 0b) != (3b - 2b)\n"
> +		"	.error	\"right and wrong target must have same offset\"\n"
> +		"	.endif\n"

FWIW, this is failing with Clang 15 for me:

s390x/ex.c:81:4: error: expected absolute expression
                 "       .if (1b - 0b) != (3b - 2b)\n"
                  ^
<inline asm>:12:6: note: instantiated into assembly here
         .if (1b - 0b) != (3b - 2b)
             ^
s390x/ex.c:82:4: error: right and wrong target must have same offset
                 "       .error  \"right and wrong target must have same 
offset\"\n"
                  ^
<inline asm>:13:2: note: instantiated into assembly here
         .error  "right and wrong target must have same offset"
         ^
2 errors generated.

Any easy ways to fix this?

  Thomas


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB716068D4
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 21:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiJTT0A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 15:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiJTTZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 15:25:58 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6665216F746
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 12:25:57 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id j12so236544plj.5
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 12:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l0txel4rQgQ/1yvtJAgYd1gQTIJiJ0FGw7Xn21rHy1k=;
        b=me1coOZbQwOEBh4Wc/85dliMNGD3Yt1vIMCBZ+TEfBIDtcKdtS/e2OsjLODIA1lueS
         iJ7VB2tF+YiLnNTVR6ZdciLbLEOPuA6VWs5SYZ7fQypSDutOBbRHsheRnh2eDoog/Imf
         HNeXQFpbaQkP8aHO5Ad/GhI0pG2E9LUslr6CvesXBWgVFqtkt+hJSw9uMxPzKpAE3YOM
         zQMAKGY4JRjximL3zNtqT6Jp/DpIAacOST20NUCSUqxaHIToaTcuuuxV43jP8yfTqSwb
         NsD+UxDOH2Dd6YlVFza+mkDl1k/55BgFh9jRJ3CEDnhePMtWdXpEIZSOSbewhSx9JSic
         OGtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l0txel4rQgQ/1yvtJAgYd1gQTIJiJ0FGw7Xn21rHy1k=;
        b=Vdc/WZEb2fyuw1cIxrYp2FP+rfVK0y7NNyf+NqAiX9ajsMbv3XompuEV1hpJa+GehS
         /QTd3EtsUvhg1MsMsyYg/8quJb1fBFSg+DxewHlI9AI4NLl4qfbUHBhRTRK3LMEsGIi8
         HjGwcON4sfCSPwYjDmsEwi2BfVCTJhCqydXjLZh1XVOKz6D4GAu93EerAhy9hVNJ0SL8
         BB0Mc8EDKG8klUIHr/W9tKpQ8Ef8muPV0ZfvabsLlUo7O1PE3YmgaUXjhm2OZMvQj7bu
         hXKfySSeUePn/x0OtK8oyQnocYbjSCHeIY6A8RXh3D8UDGEunlcdR6dm/Xg8BtyVk4hx
         e+LQ==
X-Gm-Message-State: ACrzQf2jSK/riCtE0pGpB6K4c3Vx02RV/lWc1yxMxpIRF19AOQASZxVy
        h8X/k6cVp6yu48K7weHxWatNPA==
X-Google-Smtp-Source: AMsMyM4gLehub2Buvq8yoIu9wfUQ3JHuv6U92vOBkRMK0gqskqufMMyXlf1p3FsTE1pp1Qyz+qpQyg==
X-Received: by 2002:a17:90b:1b0b:b0:20d:7c31:e75d with SMTP id nu11-20020a17090b1b0b00b0020d7c31e75dmr17335610pjb.101.1666293956835;
        Thu, 20 Oct 2022 12:25:56 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y16-20020a17090264d000b00176e6f553efsm13122575pli.84.2022.10.20.12.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 12:25:56 -0700 (PDT)
Date:   Thu, 20 Oct 2022 19:25:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 07/16] x86: Add a simple test for SYSENTER
 instruction.
Message-ID: <Y1GgwQDrfg9wd4ej@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
 <20221020152404.283980-8-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020152404.283980-8-mlevitsk@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> Run the test with Intel's vendor ID and in the long mode,
> to test the emulation of this instruction on AMD.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  x86/Makefile.x86_64 |   2 +
>  x86/sysenter.c      | 127 ++++++++++++++++++++++++++++++++++++++++++++
>  x86/unittests.cfg   |   5 ++
>  3 files changed, 134 insertions(+)
>  create mode 100644 x86/sysenter.c
> 
> diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
> index 865da07d..8ce53650 100644
> --- a/x86/Makefile.x86_64
> +++ b/x86/Makefile.x86_64
> @@ -33,6 +33,7 @@ tests += $(TEST_DIR)/vmware_backdoors.$(exe)
>  tests += $(TEST_DIR)/rdpru.$(exe)
>  tests += $(TEST_DIR)/pks.$(exe)
>  tests += $(TEST_DIR)/pmu_lbr.$(exe)
> +tests += $(TEST_DIR)/sysenter.$(exe)
>  
>  
>  ifeq ($(CONFIG_EFI),y)
> @@ -60,3 +61,4 @@ $(TEST_DIR)/hyperv_clock.$(bin): $(TEST_DIR)/hyperv_clock.o
>  $(TEST_DIR)/vmx.$(bin): $(TEST_DIR)/vmx_tests.o
>  $(TEST_DIR)/svm.$(bin): $(TEST_DIR)/svm_tests.o
>  $(TEST_DIR)/svm_npt.$(bin): $(TEST_DIR)/svm_npt.o
> +$(TEST_DIR)/sysenter.o: CFLAGS += -Wa,-mintel64
> diff --git a/x86/sysenter.c b/x86/sysenter.c
> new file mode 100644
> index 00000000..6c32fea4
> --- /dev/null
> +++ b/x86/sysenter.c
> @@ -0,0 +1,127 @@
> +#include "alloc.h"
> +#include "libcflat.h"
> +#include "processor.h"
> +#include "msr.h"
> +#include "desc.h"
> +
> +
> +// undefine this to run the syscall instruction in 64 bit mode.
> +// this won't work on AMD due to disabled code in the emulator.
> +#define COMP32

Why not run the test in both 32-bit and 64-bit mode, and skip the 64-bit mode
version if the vCPU model is AMD?

> +
> +int main(int ac, char **av)
> +{
> +    extern void sysenter_target(void);
> +    extern void test_done(void);

Tabs instead of spaces.

> +
> +    setup_vm();
> +
> +    int gdt_index = 0x50 >> 3;
> +    ulong rax = 0xDEAD;
> +
> +    /* init the sysenter GDT block */
> +    /*gdt64[gdt_index+0] = gdt64[KERNEL_CS >> 3];
> +    gdt64[gdt_index+1] = gdt64[KERNEL_DS >> 3];
> +    gdt64[gdt_index+2] = gdt64[USER_CS >> 3];
> +    gdt64[gdt_index+3] = gdt64[USER_DS >> 3];*/
> +
> +    /* init the sysenter msrs*/
> +    wrmsr(MSR_IA32_SYSENTER_CS, gdt_index << 3);
> +    wrmsr(MSR_IA32_SYSENTER_ESP, 0xAAFFFFFFFF);
> +    wrmsr(MSR_IA32_SYSENTER_EIP, (uint64_t)sysenter_target);
> +
> +    u8 *thunk = (u8*)malloc(50);
> +    u8 *tmp = thunk;
> +
> +    printf("Thunk at 0x%lx\n", (u64)thunk);
> +
> +    /* movabs test_done, %rdx*/
> +    *tmp++ = 0x48; *tmp++ = 0xBA;
> +    *(u64 *)tmp = (uint64_t)test_done; tmp += 8;
> +    /* jmp %%rdx*/
> +    *tmp++ = 0xFF; *tmp++ = 0xe2;
> +
> +    asm volatile (

Can we add a helper sysenter_asm.S or whatever instead of making this a gigantic
inline asm blob?  And then have separate routines for 32-bit vs. 64-bit?  That'd
require a bit of code duplication, but macros could be used to dedup the common
parts if necessary.

And with a .S file, I believe there's no need to dynamically generate the thunk,
e.g. pass the jump target through a GPR that's not modified/used by SYSENTER.

> +#ifdef COMP32
> +        "# switch to comp32, mode prior to running the test\n"
> +        "ljmpl *1f\n"
> +        "1:\n"
> +        ".long 1f\n"
> +        ".long " xstr(KERNEL_CS32) "\n"
> +        "1:\n"
> +        ".code32\n"
> +#else
> +		"# store the 64 bit thunk address to rdx\n"
> +		"mov %[thunk], %%rdx\n"
> +#endif

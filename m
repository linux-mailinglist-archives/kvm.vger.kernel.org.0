Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA995E69A9
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 19:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbiIVRaA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 13:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbiIVR3q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 13:29:46 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E410A2EF15
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 10:29:44 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id a5-20020a17090aa50500b002008eeb040eso5995263pjq.1
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 10:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=WguEn1+R/qy9jxr1AFPqz7xcQwURu+GuGNIMuIHQUEw=;
        b=qEjqUvj2Mg8/Z2skx3OmLcRko6QQick+8tHEty4uB2GcaKela++zWvgoxVtOyRNPw+
         CsZ/bGUkJ6zxHlZWVDIpAy17HJXe6Lsj25F2Jig/Sae1RJfsBzxTlQ12C5nl7sluezh8
         HVuyu49QZPG8W7VPXuj8MuzIerzHxBUw46X5v/z2yUAd3iSvJP/RPNBwMBJN3RYwItkF
         5aN/rEWWH3Kz2UyZH8ncdpMfDAJGbCSBbmxSPH4nXPJg7h4Zh234XdW4OqTuPwZVHOnh
         tgVEAdtPkEqzqiNuMt5M81O05qW5Get8SZH2idrY6v95e0m2wCqfvuKxk7rBihevMXWw
         JVOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=WguEn1+R/qy9jxr1AFPqz7xcQwURu+GuGNIMuIHQUEw=;
        b=q7owYSmXbWfHnCCUUbyhs59HMTvQ05BM0vGmtQa9IXnJYGzSjJwZcTHap1c2ouAjnb
         9lLkAIVZPUQGR44GXhv9qsqF3sBNS00CZ01KieddP8ttz7Twg9swWbCjU8mvs6FioEhv
         EqChECT4wBFU1V/ZNYxXNm3woecsxT4p5Im8op0Ri+ffUCv7eg4fE/nhNm5iHKbXsKpc
         gS83iMckdNWgg/4oHx27KWcocQr5A1fYcAt9rxaI3twe5meShJfzCJrC2Og5O4Q9bjXt
         3DmjN5P8iy7EgBs48vxzuSTC4NsAHiHDq8M2w1ORILzthOTq8niULZcUtL1NQXtJlB8H
         TOJw==
X-Gm-Message-State: ACrzQf3F7pNVe8Wxs431G4B4uCE7/YVH0NpA7R12rW6aDy/HOCRk68r9
        0y3dp29EL1wDJUZbKk12Jd4ICg==
X-Google-Smtp-Source: AMsMyM6ScRrXzJuAgUpgfhwTFZ2YmS97GwSNxB49FtMZDDg6whKaEG/YcmnP47Wff7DpGe1HVfy2FA==
X-Received: by 2002:a17:902:ec8f:b0:177:ff40:19bf with SMTP id x15-20020a170902ec8f00b00177ff4019bfmr4191153plg.141.1663867784082;
        Thu, 22 Sep 2022 10:29:44 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id t11-20020a170902e84b00b001782a6fbcacsm4426077plg.101.2022.09.22.10.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 10:29:43 -0700 (PDT)
Date:   Thu, 22 Sep 2022 10:29:39 -0700
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 1/5] KVM: selftests: Implement memcmp(), memcpy(), and
 memset() for guest use
Message-ID: <Yyybg3DxgLt4NVn+@google.com>
References: <20220908233134.3523339-1-seanjc@google.com>
 <20220908233134.3523339-2-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908233134.3523339-2-seanjc@google.com>
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

On Thu, Sep 08, 2022 at 11:31:30PM +0000, Sean Christopherson wrote:
> Implement memcmp(), memcpy(), and memset() to override the compiler's
> built-in versions in order to guarantee that the compiler won't generate
> out-of-line calls to external functions via the PLT.  This allows the
> helpers to be safely used in guest code, as KVM selftests don't support
> dynamic loading of guest code.
> 
> Steal the implementations from the kernel's generic versions, sans the
> optimizations in memcmp() for unaligned accesses.
> 
> Put the utilities in a separate compilation unit and build with
> -ffreestanding to fudge around a gcc "feature" where it will optimize
> memset(), memcpy(), etc... by generating a recursive call.  I.e. the
> compiler optimizes itself into infinite recursion.  Alternatively, the
> individual functions could be tagged with
> optimize("no-tree-loop-distribute-patterns"), but using "optimize" for
> anything but debug is discouraged, and Linus NAK'd the use of the flag
> in the kernel proper[*].
> 
> https://lore.kernel.org/lkml/CAHk-=wik-oXnUpfZ6Hw37uLykc-_P0Apyn2XuX-odh-3Nzop8w@mail.gmail.com
> 
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Cc: Anup Patel <anup@brainfault.org>
> Cc: Atish Patra <atishp@atishpatra.org>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |  8 ++++-
>  .../selftests/kvm/include/kvm_util_base.h     | 10 ++++++
>  tools/testing/selftests/kvm/lib/kvm_string.c  | 33 +++++++++++++++++++
>  3 files changed, 50 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/kvm/lib/kvm_string.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 4c122f1b1737..92a0c05645b5 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -48,6 +48,8 @@ LIBKVM += lib/rbtree.c
>  LIBKVM += lib/sparsebit.c
>  LIBKVM += lib/test_util.c
>  
> +LIBKVM_STRING += lib/kvm_string.c

Can this file be named lib/string.c instead? This file has nothing to do
with KVM per-se.

> +
>  LIBKVM_x86_64 += lib/x86_64/apic.c
>  LIBKVM_x86_64 += lib/x86_64/handlers.S
>  LIBKVM_x86_64 += lib/x86_64/perf_test_util.c
> @@ -220,7 +222,8 @@ LIBKVM_C := $(filter %.c,$(LIBKVM))
>  LIBKVM_S := $(filter %.S,$(LIBKVM))
>  LIBKVM_C_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_C))
>  LIBKVM_S_OBJ := $(patsubst %.S, $(OUTPUT)/%.o, $(LIBKVM_S))
> -LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ)
> +LIBKVM_STRING_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_STRING))
> +LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ)
>  
>  EXTRA_CLEAN += $(LIBKVM_OBJS) cscope.*
>  
> @@ -231,6 +234,9 @@ $(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c
>  $(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S
>  	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
>  
> +$(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
> +	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c -ffreestanding $< -o $@

A comment here would be helpful to document why LIBKVM_STRING_OBJ needs
a special case.

> +
>  x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
>  $(TEST_GEN_PROGS): $(LIBKVM_OBJS)
>  $(TEST_GEN_PROGS_EXTENDED): $(LIBKVM_OBJS)
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 24fde97f6121..bdb751f4825c 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -173,6 +173,16 @@ struct vm_guest_mode_params {
>  };
>  extern const struct vm_guest_mode_params vm_guest_mode_params[];
>  
> +/*
> + * Override the "basic" built-in string helpers so that they can be used in
> + * guest code.  KVM selftests don't support dynamic loading in guest code and
> + * will jump into the weeds if the compiler decides to insert an out-of-line
> + * call via the PLT.
> + */
> +int memcmp(const void *cs, const void *ct, size_t count);
> +void *memcpy(void *dest, const void *src, size_t count);
> +void *memset(void *s, int c, size_t count);
> +
>  int open_path_or_exit(const char *path, int flags);
>  int open_kvm_dev_path_or_exit(void);
>  unsigned int kvm_check_cap(long cap);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_string.c b/tools/testing/selftests/kvm/lib/kvm_string.c
> new file mode 100644
> index 000000000000..a60d56d4e5b8
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/kvm_string.c
> @@ -0,0 +1,33 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include "kvm_util.h"

Is this include necesary?

> +
> +int memcmp(const void *cs, const void *ct, size_t count)
> +{
> +	const unsigned char *su1, *su2;
> +	int res = 0;
> +
> +	for (su1 = cs, su2 = ct; 0 < count; ++su1, ++su2, count--) {
> +		if ((res = *su1 - *su2) != 0)
> +			break;
> +	}
> +	return res;
> +}
> +
> +void *memcpy(void *dest, const void *src, size_t count)
> +{
> +	char *tmp = dest;
> +	const char *s = src;
> +
> +	while (count--)
> +		*tmp++ = *s++;
> +	return dest;
> +}
> +
> +void *memset(void *s, int c, size_t count)
> +{
> +	char *xs = s;
> +
> +	while (count--)
> +		*xs++ = c;
> +	return s;
> +}
> -- 
> 2.37.2.789.g6183377224-goog
> 

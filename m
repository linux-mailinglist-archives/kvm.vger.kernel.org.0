Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF6F629F08
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 21:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732099AbfEXTYg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 15:24:36 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34896 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732018AbfEXTYf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 15:24:35 -0400
Received: by mail-wr1-f68.google.com with SMTP id m3so11062306wrv.2
        for <kvm@vger.kernel.org>; Fri, 24 May 2019 12:24:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RiLdSm+UzMaJuvEn0wpY5Et6MpVF76OPre2rr2zBWJI=;
        b=bBUYKOxnkiuPaZHZPFdszxESyruWXRL3dDWO5vOaTHUxQ3PQX/H2Bcq+1gtx/GhhKs
         898grMu7sd1zmLL4QNwxvpZT73HQan2+U+iqG3E+sQrDSaLGys4bCM24ZFmpxiHCjWWo
         +KPm7LSZKU1e9H/qGu2cRb4Exov2aL6h8ptoiGz9qCoLwudf2bWPVIRHPR7cndCZWP+n
         XcHdGUz+H69WeyDeA2CzxObw/5A3MTKhaNszJOW4cbAnTNw1jRVa0AJQca88P9KBLbTL
         In4p7vljNhnWKQlVhcqyRCIZvGVoYDsYmqww/CiMzgk/0tT9/x+uXAfIiY7iFSxAb8Ei
         Ngnw==
X-Gm-Message-State: APjAAAXSjoDGDNJ2rVyzh7ZmzQVLIZgWPueX+OlDTWTLIPWX7+wnxm/h
        98a0N0+Bn26l5c8eNn3l7EYqHw==
X-Google-Smtp-Source: APXvYqzoUsvro6Wxw8AqgAHyQuZmdtBdPAud4tFBaOFFnZn+pI/JBoYi0pekaj8lJdnotDCWc9rnoA==
X-Received: by 2002:a5d:5544:: with SMTP id g4mr57306165wrw.327.1558725874185;
        Fri, 24 May 2019 12:24:34 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id j206sm5849863wma.47.2019.05.24.12.24.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 12:24:33 -0700 (PDT)
Subject: Re: [PATCH v2] kvm: selftests: aarch64: compile with warnings on
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, thuth@redhat.com
References: <20190523101634.19720-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f31e5d57-9de0-ea1f-9197-1046d22f99d1@redhat.com>
Date:   Fri, 24 May 2019 21:24:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523101634.19720-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/05/19 12:16, Andrew Jones wrote:
> aarch64 fixups needed to compile with warnings as errors.
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  tools/testing/selftests/kvm/lib/aarch64/processor.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index e8c42506a09d..03abba9495af 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -7,6 +7,8 @@
>  
>  #define _GNU_SOURCE /* for program_invocation_name */
>  
> +#include <linux/compiler.h>
> +
>  #include "kvm_util.h"
>  #include "../kvm_util_internal.h"
>  #include "processor.h"
> @@ -67,15 +69,13 @@ static uint64_t ptrs_per_pgd(struct kvm_vm *vm)
>  	return 1 << (vm->va_bits - shift);
>  }
>  
> -static uint64_t ptrs_per_pte(struct kvm_vm *vm)
> +static uint64_t __maybe_unused ptrs_per_pte(struct kvm_vm *vm)
>  {
>  	return 1 << (vm->page_shift - 3);
>  }
>  
>  void virt_pgd_alloc(struct kvm_vm *vm, uint32_t pgd_memslot)
>  {
> -	int rc;
> -
>  	if (!vm->pgd_created) {
>  		vm_paddr_t paddr = vm_phy_pages_alloc(vm,
>  			page_align(vm, ptrs_per_pgd(vm) * 8) / vm->page_size,
> @@ -181,6 +181,7 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
>  unmapped_gva:
>  	TEST_ASSERT(false, "No mapping for vm virtual address, "
>  		    "gva: 0x%lx", gva);
> +	exit(1);
>  }
>  
>  static void pte_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent, uint64_t page, int level)
> @@ -312,6 +313,6 @@ void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
>  	get_reg(vm, vcpuid, ARM64_CORE_REG(regs.pstate), &pstate);
>  	get_reg(vm, vcpuid, ARM64_CORE_REG(regs.pc), &pc);
>  
> -	fprintf(stream, "%*spstate: 0x%.16llx pc: 0x%.16llx\n",
> +	fprintf(stream, "%*spstate: 0x%.16lx pc: 0x%.16lx\n",
>  		indent, "", pstate, pc);
>  }
> 

Queued, thanks.

Paolo

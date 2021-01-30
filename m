Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36BD530960C
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 15:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbhA3OvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 09:51:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:43628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231974AbhA3OrZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Jan 2021 09:47:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BB6C64E08;
        Sat, 30 Jan 2021 14:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612017985;
        bh=o+3WNYglkThHPhSKrdJW8srYsuSmSW2nWKrt+g1iCRM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BzsZXjecbdIcWDWdnRLOtv217ODlZB1VUe2fOOnj3xh2gnvh6Tnka6gaZCBawYzRx
         sAO7btW3dIc+yoDRyM6KCNBX90SpO4ftnwoXPrWCKZFFH7iXpWUyj+jkHT8yCQh+V0
         0/f3uHMnhZ7msSj9teC7beEDMzJstpIoWjRIi6/BciWud5ivend/H+g6OKU62vjYDV
         svnerj6mOACvvQkVH8T6KatvywhAbzlaB9MH2MBdIS52pDZUzrnQqrPkBAafU4ZC6g
         yudbcwjC7OhAUIkBFhfwrs04Ntc7EbvSvYdfnDADHIGtnVU8dsF+X1leHI6bQnoG76
         s7n0rW+A6OlVA==
Date:   Sat, 30 Jan 2021 16:46:20 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 09/27] x86/sgx: Expose SGX architectural
 definitions to the kernel
Message-ID: <YBVxPCiIC03Ku6EG@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
 <eaa3f31541aaa09064e710e532af2ce7cf60eaa5.1611634586.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eaa3f31541aaa09064e710e532af2ce7cf60eaa5.1611634586.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 26, 2021 at 10:31:01PM +1300, Kai Huang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Expose SGX architectural structures, as KVM will use many of the
> architectural constants and structs to virtualize SGX.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>


Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

> ---
> v2->v3:
> 
>  - Added "Expose SGX architectural structures, as..." to commit message,
>    per Jarkko.
> 
> ---
>  arch/x86/{kernel/cpu/sgx/arch.h => include/asm/sgx_arch.h} | 0
>  arch/x86/kernel/cpu/sgx/encl.c                             | 2 +-
>  arch/x86/kernel/cpu/sgx/sgx.h                              | 2 +-
>  tools/testing/selftests/sgx/defines.h                      | 2 +-
>  4 files changed, 3 insertions(+), 3 deletions(-)
>  rename arch/x86/{kernel/cpu/sgx/arch.h => include/asm/sgx_arch.h} (100%)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/arch.h b/arch/x86/include/asm/sgx_arch.h
> similarity index 100%
> rename from arch/x86/kernel/cpu/sgx/arch.h
> rename to arch/x86/include/asm/sgx_arch.h
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index a78b71447771..68941c349cfe 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -7,7 +7,7 @@
>  #include <linux/shmem_fs.h>
>  #include <linux/suspend.h>
>  #include <linux/sched/mm.h>
> -#include "arch.h"
> +#include <asm/sgx_arch.h>
>  #include "encl.h"
>  #include "encls.h"
>  #include "sgx.h"
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index 5fa42d143feb..509f2af33e1d 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -8,7 +8,7 @@
>  #include <linux/rwsem.h>
>  #include <linux/types.h>
>  #include <asm/asm.h>
> -#include "arch.h"
> +#include <asm/sgx_arch.h>
>  
>  #undef pr_fmt
>  #define pr_fmt(fmt) "sgx: " fmt
> diff --git a/tools/testing/selftests/sgx/defines.h b/tools/testing/selftests/sgx/defines.h
> index 592c1ccf4576..4dd39a003f40 100644
> --- a/tools/testing/selftests/sgx/defines.h
> +++ b/tools/testing/selftests/sgx/defines.h
> @@ -14,7 +14,7 @@
>  #define __aligned(x) __attribute__((__aligned__(x)))
>  #define __packed __attribute__((packed))
>  
> -#include "../../../../arch/x86/kernel/cpu/sgx/arch.h"
> +#include "../../../../arch/x86/include/asm/sgx_arch.h"
>  #include "../../../../arch/x86/include/asm/enclu.h"
>  #include "../../../../arch/x86/include/uapi/asm/sgx.h"
>  
> -- 
> 2.29.2
> 
> 

/Jarkko

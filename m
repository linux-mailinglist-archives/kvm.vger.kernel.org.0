Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36C32FD184
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 14:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730068AbhATMwD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 07:52:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:36858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732954AbhATL7f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 06:59:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81FDA221F8;
        Wed, 20 Jan 2021 11:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611143934;
        bh=a2PgpgESs0aZ44Sl6jNwuZiIBnBCjWPdQZTy4EposRY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LWflU8KuuQZod8VlB/LNFYy7JgkkVbWeQBguIdZSE7ioti9N0sX8zTVQYerh0ppzA
         UaVTgAPyNe4ojRSu3QbhvFCui6+ne0EP+njnuP3myKXfDX95TiMYJVdx6fQReIqKrR
         l7cKSutpfm+Fu+YgNXeAkUEJJhcjHcSZH3d8sJY+avYKKUtol8/Yb1FxQeJ4t5Tg1h
         JNvLom10cEi30HaIoZw1AgqSf829VLS7o2a8qk8rUpOT4jrYuNWAJA93ebKIsiHDkA
         O0e9Z1/tpBpaM3BYtYju9u6aTZw+lqZe9tNIFbafMGyukzJLhjW5mzT4g7+zB5DAQz
         7m3DUBNC+/HBg==
Date:   Wed, 20 Jan 2021 13:58:48 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com
Subject: Re: [RFC PATCH v2 08/26] x86/sgx: Expose SGX architectural
 definitions to the kernel
Message-ID: <YAga+PoOrl9bEQN9@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
 <25746564cb0a719a69b6138d8004b987a5e0bc91.1610935432.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25746564cb0a719a69b6138d8004b987a5e0bc91.1610935432.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 18, 2021 at 04:27:49PM +1300, Kai Huang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> KVM will use many of the architectural constants and structs to
> virtualize SGX.

"Expose SGX architectural structures, as ..."

> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
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

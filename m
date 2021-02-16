Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEE631C572
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 03:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhBPCUR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Feb 2021 21:20:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:34332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230170AbhBPCSX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Feb 2021 21:18:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7907364D9D;
        Tue, 16 Feb 2021 02:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613441859;
        bh=t2/RyPcw+8nihxel+p4teFq31WYwqiof5MQBpXMg0qg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YSGECTNlNpGhpBqq4dPuGaf5L13+59XbBp8/zHKWreHjjFFepypyS16pjxrPX6xOA
         AXEoo+2QHfohPzFEByXm73KFIwDNANoFZn2j0snzX0IWPowIlXEB+/+YcsboKHCBPk
         SLclgug/pPr+ZZ8kf4ZYCe5dr95lOKHBZs907gIaXW8A3w7bVDcXEQ6nAaExkLKe9h
         XBtorFiCIaLaVVuD/DLoaY4CZG/mQIpzqu2mG1mcDJZSZuG5VyDH8F38iFcOMTbZJy
         Dm9qtjmBROwb+TULuwrJK9UpShhxcScficZc93YY/m9lM7MjGycpkf3kc4GhLIuFfp
         Zz88UqrBWwILg==
Date:   Tue, 16 Feb 2021 04:17:26 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        pbonzini@redhat.com, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v5 08/26] x86/sgx: Expose SGX architectural
 definitions to the kernel
Message-ID: <YCsrNqcB1C0Tyxz9@kernel.org>
References: <cover.1613221549.git.kai.huang@intel.com>
 <1d6fe6bd392b604091b57842c15cc5460aa92593.1613221549.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d6fe6bd392b604091b57842c15cc5460aa92593.1613221549.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Feb 14, 2021 at 02:29:10AM +1300, Kai Huang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Expose SGX architectural structures, as KVM will use many of the
> architectural constants and structs to virtualize SGX.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Acked-by: Dave Hansen <dave.hansen@intel.com>
> Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
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

Why not just sgx.h? The postfix is useless.

/Jarkko

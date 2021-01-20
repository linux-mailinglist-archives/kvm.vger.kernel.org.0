Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2802FD0C4
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 13:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730266AbhATMwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 07:52:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:36928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726694AbhATMAL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 07:00:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 232A5221FB;
        Wed, 20 Jan 2021 11:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611143969;
        bh=QGrUfzyBYq3J4ag6Ae00hMg37X96K+kbfkc6zS/WLZ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fkuVBheYIbPk43Pnhu8M/BUbeQUSy2SbkyO6iqEZKBkdZ+Ki8voCLOk/CpOCVBL6p
         /BJWCMASt+xAeosKXnJRBj/friLny52EiE8qjEGRz88dleipg3dL8mHQiZ2IGBQcJF
         BSo8175Apci1IsPOrdt0VPV3GUTR6FAZpoWAGEfROkcjvVkhG3TMdckf83pxefcVI4
         JGZn259as4pSHZkyXezWh/t2qbQ1DAc6AKlQSu8eMby5HrMDVwZv53dk6LBMAqS9mP
         frU+KpC4BSlprN6SROlrO5+8F5YLcNv07FN4WM31KVVT/Ik8MKRA8HEbi7ehJeSin/
         ylqzCXsbu+vFg==
Date:   Wed, 20 Jan 2021 13:59:23 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com
Subject: Re: [RFC PATCH v2 09/26] x86/sgx: Move ENCLS leaf definitions to
 sgx_arch.h
Message-ID: <YAgbGzI0Cuw63JyA@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
 <5a23890a36c31896addfd41bae9211545024f8ba.1610935432.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a23890a36c31896addfd41bae9211545024f8ba.1610935432.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 18, 2021 at 04:27:50PM +1300, Kai Huang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Move the ENCLS leaf definitions to sgx_arch.h so that they can be used
> by KVM.  And because they're architectural.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Acked-by: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko

> ---
>  arch/x86/include/asm/sgx_arch.h | 15 +++++++++++++++
>  arch/x86/kernel/cpu/sgx/encls.h | 15 ---------------
>  2 files changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sgx_arch.h b/arch/x86/include/asm/sgx_arch.h
> index 56b0f8ae3f92..38ef7ce3d3c7 100644
> --- a/arch/x86/include/asm/sgx_arch.h
> +++ b/arch/x86/include/asm/sgx_arch.h
> @@ -22,6 +22,21 @@
>  /* The bitmask for the EPC section type. */
>  #define SGX_CPUID_EPC_MASK	GENMASK(3, 0)
>  
> +enum sgx_encls_function {
> +	ECREATE	= 0x00,
> +	EADD	= 0x01,
> +	EINIT	= 0x02,
> +	EREMOVE	= 0x03,
> +	EDGBRD	= 0x04,
> +	EDGBWR	= 0x05,
> +	EEXTEND	= 0x06,
> +	ELDU	= 0x08,
> +	EBLOCK	= 0x09,
> +	EPA	= 0x0A,
> +	EWB	= 0x0B,
> +	ETRACK	= 0x0C,
> +};
> +
>  /**
>   * enum sgx_return_code - The return code type for ENCLS, ENCLU and ENCLV
>   * %SGX_NOT_TRACKED:		Previous ETRACK's shootdown sequence has not
> diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
> index 443188fe7e70..be5c49689980 100644
> --- a/arch/x86/kernel/cpu/sgx/encls.h
> +++ b/arch/x86/kernel/cpu/sgx/encls.h
> @@ -11,21 +11,6 @@
>  #include <asm/traps.h>
>  #include "sgx.h"
>  
> -enum sgx_encls_function {
> -	ECREATE	= 0x00,
> -	EADD	= 0x01,
> -	EINIT	= 0x02,
> -	EREMOVE	= 0x03,
> -	EDGBRD	= 0x04,
> -	EDGBWR	= 0x05,
> -	EEXTEND	= 0x06,
> -	ELDU	= 0x08,
> -	EBLOCK	= 0x09,
> -	EPA	= 0x0A,
> -	EWB	= 0x0B,
> -	ETRACK	= 0x0C,
> -};
> -
>  /**
>   * ENCLS_FAULT_FLAG - flag signifying an ENCLS return code is a trapnr
>   *
> -- 
> 2.29.2
> 
> 

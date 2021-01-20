Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD272FD186
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 14:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730380AbhATMwK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 07:52:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:37000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727020AbhATMAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 07:00:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B92D2313A;
        Wed, 20 Jan 2021 11:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611143998;
        bh=jFY1srvy9E/vvrifzb+sgdAyyNBynMvdw61RNBimw+o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CvUp3uEhKi6EIX8QwPEM3l6yyGZwkaWPhzNu/Q0A7XN4bBDhkG29bJSSSwxmi81YS
         py7kf42ZimT/5s+gOo2kO5YwsC1CfSvX84ALX+pEMd3PoxOPdZbcSZNTi/ZoTsQZYa
         PdOWJzPy6FZ1ph+zd0z1R88kePYy0md1EGgxwmUkoem5ps0gijuxkp9h9c+/Na2kcy
         wR1K5cXxUu3pgULtnpWXr62p6A1ydeqVXgpb1nQpie7tJIygfDMZq1BLqlW6rdFQrq
         SlEQKFNGDnrk3ijpzyzscPbCE+pr2H2OmRlIN2Of8PylyCXUElJ+U8p3SoJzBQExrh
         /ccbn++nhgAFA==
Date:   Wed, 20 Jan 2021 13:59:52 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v2 10/26] x86/sgx: Add SGX2 ENCLS leaf definitions
 (EAUG, EMODPR and EMODT)
Message-ID: <YAgbOGpKAj7SHobO@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
 <23b8becce4117d4661121b4136d439e89e9b3b01.1610935432.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23b8becce4117d4661121b4136d439e89e9b3b01.1610935432.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 18, 2021 at 04:28:03PM +1300, Kai Huang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Define the ENCLS leafs that are available with SGX2, also referred to as
> Enclave Dynamic Memory Management (EDMM).  The leafs will be used by KVM
> to conditionally expose SGX2 capabilities to guests.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Acked-by: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko

> ---
>  arch/x86/include/asm/sgx_arch.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/include/asm/sgx_arch.h b/arch/x86/include/asm/sgx_arch.h
> index 38ef7ce3d3c7..2323ded379d6 100644
> --- a/arch/x86/include/asm/sgx_arch.h
> +++ b/arch/x86/include/asm/sgx_arch.h
> @@ -35,6 +35,9 @@ enum sgx_encls_function {
>  	EPA	= 0x0A,
>  	EWB	= 0x0B,
>  	ETRACK	= 0x0C,
> +	EAUG	= 0x0D,
> +	EMODPR	= 0x0E,
> +	EMODT	= 0x0F,
>  };
>  
>  /**
> -- 
> 2.29.2
> 
> 

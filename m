Return-Path: <kvm+bounces-42793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FC96A7D350
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 07:06:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE5A3167508
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 05:06:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29078221DB9;
	Mon,  7 Apr 2025 05:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ZCcXAMDA"
X-Original-To: kvm@vger.kernel.org
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3759211A33;
	Mon,  7 Apr 2025 05:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744002386; cv=none; b=Z7pYamfXbvoCmT4VVEUgiimzbix9P8zeTv0Tj0/ZzIHHcVMUftf92Dj7tLx+XApp4j+BHTq7/rfBC/jookmxllvofBmCWH6YYulhfwKFctQacLCQpL58LpJ7zxlI/8PXNeLEpaJrmS5KldxYreHIqVUUNkRCAnd8llDzreQLScI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744002386; c=relaxed/simple;
	bh=q3x3Bn3tMRPQCHENHO+gAPcGM2Et1HxLhfTvQFIcMYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HjKKU8HMBpvDyQbpPv+qhFunA615ynvkEjUtVz+beUARtHXA3uFHr2HR9VfA5x4GYY9J4HQuBMNQ8I4P2cKGl/4RgoRWcxqJQtO44x1Jv9geCymXV8/GtzL5yAw3AAlHsGbHx+V4GgorKKbZW5w6MtnNhE1AYxyMtHTtA6cf/Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ZCcXAMDA; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hRUX8rrpmOkyJiGL4KZMKPZOaOhgJW1xe8y86R4HPLM=; b=ZCcXAMDA89r/LV8XMGmE74DC3Z
	qUcu61u308rZrFHLVFkKE8f2ohOZvNBD6LQLDdnFGTdo4AIe2eKg19pTJR37yxVhi8/bK7BDngQlr
	tc7ieS2Xn4IJ7Hbq83HvKrFwI223TheoMGHn4jvaWFRgjkzcHtkbxWBU/PPMfl2a+fjCeDgti4+FN
	3yjBnyXqR643/bhGhXrGHzPazG0iMoeguKa9HITHxrQKrLuhbVzpgdT9l0Kz+depbsmrPts63mk24
	PL9IEuqA92pLU/0//Y8mT+sJZvVZUZr5dEZ1WNrfRQeSroEZrLtMy1uCf/Aoywp0Uw72uMANkVj2z
	agflauQw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1eg4-00DN8Y-1w;
	Mon, 07 Apr 2025 13:05:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 13:05:44 +0800
Date: Mon, 7 Apr 2025 13:05:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, thomas.lendacky@amd.com,
	john.allen@amd.com, michael.roth@amd.com, dionnaglaze@google.com,
	nikunj@amd.com, ardb@kernel.org, kevinloughlin@google.com,
	Neeraj.Upadhyay@amd.com, aik@amd.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-coco@lists.linux.dev
Subject: Re: [PATCH v7 0/8] Move initializing SEV/SNP functionality to KVM
Message-ID: <Z_NdKF3PllghT2XC@gondor.apana.org.au>
References: <cover.1742850400.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1742850400.git.ashish.kalra@amd.com>

On Mon, Mar 24, 2025 at 09:13:41PM +0000, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Remove initializing SEV/SNP functionality from PSP driver and instead add
> support to KVM to explicitly initialize the PSP if KVM wants to use
> SEV/SNP functionality.
> 
> This removes SEV/SNP initialization at PSP module probe time and does
> on-demand SEV/SNP initialization when KVM really wants to use 
> SEV/SNP functionality. This will allow running legacy non-confidential
> VMs without initializating SEV functionality. 
> 
> The patch-set includes the fix to not continue with SEV INIT if SNP
> INIT fails as RMP table must be initialized before calling SEV INIT
> if host SNP support is enabled.
> 
> This will assist in adding SNP CipherTextHiding support and SEV firmware
> hotloading support in KVM without sharing SEV ASID management and SNP
> guest context support between PSP driver and KVM and keeping all that
> support only in KVM.
> 
> To support SEV firmware hotloading, SEV Shutdown will be done explicitly
> prior to DOWNLOAD_FIRMWARE_EX and SEV INIT post it to work with the
> requirement of SEV to be in UNINIT state for DOWNLOAD_FIRMWARE_EX.
> NOTE: SEV firmware hotloading will only be supported if there are no
> active SEV/SEV-ES guests. 
> 
> v7:
> -  Drop the Fixes: tag for patch 01, as continuing with SEV INIT
> after SNP INIT(_EX) failure will still cause SEV INIT to fail,
> we are simply aborting here after SNP INIT(_EX) failure.
> - Fix commit logs.
> - Add additional reviewed-by's.
> 
> v6:
> - Add fix to not continue with SEV INIT if SNP INIT fails as RMP table 
> must be initialized before calling SEV INIT if host SNP support is enabled.
> - Ensure that for SEV IOCTLs requiring SEV to be initialized, 
> _sev_platform_init_locked() is called instead of __sev_platform_init_locked()
> to ensure that both implicit SNP and SEV INIT is done for these ioctls and
> followed by __sev_firmware_shutdown() to do both SEV and SNP shutdown.
> - Refactor doing SEV and SNP INIT implicitly for specific SEV and SNP
> ioctls into sev_move_to_init_state() and snp_move_to_init_state(). 
> - Ensure correct error code is returned from sev_ioctl_do_pdh_export() 
> if platform is not in INIT state.
> - Remove dev_info() from sev_pci_init() because this would have printed
> a duplicate message.
> 
> v5:
> - To maintain 1-to-1 mapping between the ioctl commands and the SEV/SNP commands, 
> handle the implicit INIT in the same way as SHUTDOWN, which is to use a local error
> for INIT and in case of implicit INIT failures, let the error logs from 
> __sev_platform_init_locked() OR __sev_snp_init_locked() be printed and always return
> INVALID_PLATFORM_STATE as error back to the caller.
> - Add better error logging for SEV/SNP INIT and SHUTDOWN commands.
> - Fix commit logs.
> - Add more acked-by's, reviewed-by's, suggested-by's.
> 
> v4:
> - Rebase on linux-next which has the fix for SNP broken with kvm_amd
> module built-in.
> - Fix commit logs.
> - Add explicit SEV/SNP initialization and shutdown error logs instead
> of using a common exit point.
> - Move SEV/SNP shutdown error logs from callers into __sev_platform_shutdown_locked()
> and __sev_snp_shutdown_locked().
> - Make sure that we continue to support both the probe field and psp_init_on_probe
> module parameter for PSP module to support SEV INIT_EX.
> - Add reviewed-by's.
> 
> v3:
> - Move back to do both SNP and SEV platform initialization at KVM module
> load time instead of SEV initialization on demand at SEV/SEV-ES VM launch
> to prevent breaking QEMU which has a check for SEV to be initialized 
> prior to launching SEV/SEV-ES VMs. 
> - As both SNP and SEV platform initialization and shutdown is now done at
> KVM module load and unload time remove patches for separate SEV and SNP
> platform initialization and shutdown.
> 
> v2:
> - Added support for separate SEV and SNP platform initalization, while
> SNP platform initialization is done at KVM module load time, SEV 
> platform initialization is done on demand at SEV/SEV-ES VM launch.
> - Added support for separate SEV and SNP platform shutdown, both 
> SEV and SNP shutdown done at KVM module unload time, only SEV
> shutdown down when all SEV/SEV-ES VMs have been destroyed, this
> allows SEV firmware hotloading support anytime during system lifetime.
> - Updated commit messages for couple of patches in the series with
> reference to the feedback received on v1 patches.
> 
> Ashish Kalra (8):
>   crypto: ccp: Abort doing SEV INIT if SNP INIT fails
>   crypto: ccp: Move dev_info/err messages for SEV/SNP init and shutdown
>   crypto: ccp: Ensure implicit SEV/SNP init and shutdown in ioctls
>   crypto: ccp: Reset TMR size at SNP Shutdown
>   crypto: ccp: Register SNP panic notifier only if SNP is enabled
>   crypto: ccp: Add new SEV/SNP platform shutdown API
>   KVM: SVM: Add support to initialize SEV/SNP functionality in KVM
>   crypto: ccp: Move SEV/SNP Platform initialization to KVM
> 
>  arch/x86/kvm/svm/sev.c       |  12 ++
>  drivers/crypto/ccp/sev-dev.c | 245 +++++++++++++++++++++++++----------
>  include/linux/psp-sev.h      |   3 +
>  3 files changed, 194 insertions(+), 66 deletions(-)
> 
> -- 
> 2.34.1

Patches 1-6 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt


Return-Path: <kvm+bounces-42891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D444CA7F75A
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 10:11:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B0371751CE
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 08:11:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEDAA2641C8;
	Tue,  8 Apr 2025 08:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="qF9Znl9v"
X-Original-To: kvm@vger.kernel.org
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51982638B0;
	Tue,  8 Apr 2025 08:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744099886; cv=none; b=L991J1/oANK8GSLpgy5OG1ugO7TMSvs2eLDany/q8vDbakxxTLZT8ilc2yQEU1uPP8Thf7/HuOTmEhcDnLG+eyKtQnswa91qK2iwE/F0PSQMVP03qMZST1clG/lB944sl2t2uxI5EUv77dT2HqIe3GSm3AmD+obLz4Hr3+rSIIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744099886; c=relaxed/simple;
	bh=0NFejXXQ5C/Irc7QVCHJxI7ymX8Um1SmC/6y0Sf6bps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MhLrXevYIy/4Ac6cdLcVTNOgBOnoO1jcUaN5nRzW1fJlxMFFgtCQweCWTDrLWrOeaRu7x9VuQFA9wclLu6eSCXx6/0OnT7D4iqzsRbNQrHlWhYI4xMviTMB5U2RrTmNYl+3snc5C9xUWt6JKkOKa6zwASnR2NPfqo66N8lqVrus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=qF9Znl9v; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BJqa6CzCTAkaDv71FdSxwPL/T5p0WkVuqJBIvve0EHU=; b=qF9Znl9vlveOLcfy/Lf7p749Wn
	Ad2WcxwsLLrlScrw70HmNPgSwlIyALU09S/SKeVKLW3Jbv80V8NWledW+PbIakXukYDD/JN2fz6kk
	75Yl2Jd2xiNFF6275NJj6SJq6qMIW3dqZn1Dgg1Wn2IohcDN+E/L4uSJRHTzULexp1d6dxn9nf21t
	hXJ/sACLCgSQPZ/wuaqC+Uhm+QRQLg7ewJqWZOhdlGXbDNe9FoItJRgXBUMnBSKYe6r7AWc+hY7uy
	ti535Pu3O0WZBvEplyNZBD/+ui7rL2HSiSg7o5ntXiCGEBb3+Wh2ltvxdmsA+RstHn78rWHGIFJml
	/bbK1P1Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u242r-00DonW-0E;
	Tue, 08 Apr 2025 16:10:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 08 Apr 2025 16:10:57 +0800
Date: Tue, 8 Apr 2025 16:10:57 +0800
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
Message-ID: <Z_TaEXCXpDM6wa-m@gondor.apana.org.au>
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

Patches 7-8 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt


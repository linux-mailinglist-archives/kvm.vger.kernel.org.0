Return-Path: <kvm+bounces-71133-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sOzJEQNhk2nR4AEAu9opvQ
	(envelope-from <kvm+bounces-71133-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 19:25:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ABFE146F9E
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 19:25:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 658B230205F4
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 18:24:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 349C82DCF45;
	Mon, 16 Feb 2026 18:24:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB41E2737F2;
	Mon, 16 Feb 2026 18:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771266289; cv=none; b=g2FLINoMhEVpSgE+2MZ0edJXCiR71aqOFJNyh6kDxS9GPIVT8p20cfMOnLT8esUJhH3m58/8UKhgtQrVI/7+iBqwRMjaajVMFMLyd3BYZcXI9pzCEPhZQFM5CHMur+Qnk4Gy7dO7R+ty5DvhIIzBfl7qdz7VcjD/BiE7+ehTJWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771266289; c=relaxed/simple;
	bh=e4Xv36F6K4gczFWPbbm/HwoIgQOOiINgmW2tJZCr86Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sRMahjOPPcQaiYOELsA81kZEXxnvHmomZZ27GUD3ZQHV9Gp3L4XByrDAE++yuQ446/ADU88VS1dzp05EaDXowZjnZt4RbUCec8dnKhfdDc2hAQag0vAHC2l9Io4Np4itVaVzaXN6mEfHASGgzZKlZfR1bMYkGV7wexXrQCOjFn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B62C116C6;
	Mon, 16 Feb 2026 18:24:45 +0000 (UTC)
Date: Mon, 16 Feb 2026 18:24:42 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, will@kernel.org, maz@kernel.org,
	broonie@kernel.org, oliver.upton@linux.dev, miko.lenczewski@arm.com,
	kevin.brodsky@arm.com, ardb@kernel.org, suzuki.poulose@arm.com,
	lpieralisi@kernel.org, scott@os.amperecomputing.com,
	joey.gouly@arm.com, yuzenghui@huawei.com, pbonzini@redhat.com,
	shuah@kernel.org, mark.rutland@arm.com, arnd@arndb.de
Subject: Re: [PATCH v12 2/7] arm64: cpufeature: add FEAT_LSUI
Message-ID: <aZNgR6prm0Exzar0@arm.com>
References: <20260121190622.2218669-1-yeoreum.yun@arm.com>
 <20260121190622.2218669-3-yeoreum.yun@arm.com>
 <aYY2CyHWtplQ-fuS@arm.com>
 <aYouAv_EjICIN8oA@arm.com>
 <aYsAaaQgBaLbDSsW@e129823.arm.com>
 <aYtZfpWjRJ1r23nw@arm.com>
 <aYtkbezCx9vW8SHz@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYtkbezCx9vW8SHz@e129823.arm.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71133-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[22];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[catalin.marinas@arm.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9ABFE146F9E
X-Rspamd-Action: no action

On Tue, Feb 10, 2026 at 05:01:33PM +0000, Yeoreum Yun wrote:
> > Why not keep uaccess_enable_privileged() in
> > arch_futex_atomic_op_inuser() and cmpxchg for all cases and make it a
> > no-op if FEAT_LSUI is implemented together with FEAT_PAN?
> 
> This is because I had a assumption FEAT_PAN must be present
> when FEAT_LSUI is presented and this was not considering the virtualisation case.
> and  FEAT_PAN is present uaccess_ttbr0_enable() becomes nop and
> following feedback you gave - https://lore.kernel.org/all/aJ9oIes7LLF3Nsp1@arm.com/
> and the reason you mention last, It doesn't need to call mte_enable_tco().
> 
> That's why I thought it doesn't need to call uaccess_enable_privileged().
> 
> But for a compatibility with SW_PAN, I think we can put only
> uaccess_ttbr0_enable() in arch_futex_atomic_op_inuser() and cmpxchg simply
> instead of adding a new APIs uaccess_enable_futex() and
> by doing this I think has_lsui() can be removed with its WRAN.

Yes, I think you can use uaccess_ttbr0_enable() when we take the
FEAT_LSUI path. What I meant above was for uaccess_enable_privileged()
to avoid PAN disabling if we have FEAT_LSUI as we know all cases would
be executed with user privileges.

Either way, we don't need a new uaccess_enable_futex().

> > BTW, with the removal of uaccess_enable_privileged(), we now get MTE tag
> > checks for the futex operations. I think that's good as it matches the
> > other uaccess ops, though it's a slight ABI change. If we want to
> > preserve the old behaviour, we definitely need
> > uaccess_enable_privileged() that only does mte_enable_tco().
> 
> I think we don't need to preserve the old behaviour. so we can skip
> mte_enable_tco() in case of FEAT_LSUI is presented.

Just spell it out in the commit log that we have a slight ABI change. I
don't think we'll have a problem but it needs at least checking with
some user-space (libc, Android) people.

-- 
Catalin


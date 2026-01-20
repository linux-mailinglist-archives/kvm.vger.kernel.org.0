Return-Path: <kvm+bounces-68654-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sF+4NxD4b2m+UQAAu9opvQ
	(envelope-from <kvm+bounces-68654-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 22:48:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 65B3D4C804
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 22:48:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 83D8BB05DC0
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 21:16:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59E713B52E6;
	Tue, 20 Jan 2026 21:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ViOxTvm/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DC42D1303;
	Tue, 20 Jan 2026 21:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768943768; cv=none; b=A8BCqtNuDg8CDcAuqGzopqhDqD2Vl2rBGgzjnZn4+YmtfvQDDkv7MuZNf1JwjW7mmaRGedQcGCF+VHVL2eZLYPK5E+Brc1EybW2TOBCufqa0UG3chxWpqrKw1/jmLyENAYYWQCdRLLKkVP93pYpRMF1GCDWNUnT9zPAkpyCYTPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768943768; c=relaxed/simple;
	bh=k+AXef9xJ0NMYxE0xeBDoDL6TDip/0guYNTErye5XeE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EMyMFhpJfF9nR77CgWejMs5of20QFeZx3B88IBlBnUaRwhL136AiSXWpMz5AV1zfVLM6mRn+IdDkUd6umHelmdWP/PbGlgzi/BDPAwWnulJBbG2JmAH4VZHIibHpDlWaW+YOyhpC0wNMTe1L19c+Hm+fco3ROy8CGNc+CS9yDSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ViOxTvm/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264A3C16AAE;
	Tue, 20 Jan 2026 21:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768943763;
	bh=k+AXef9xJ0NMYxE0xeBDoDL6TDip/0guYNTErye5XeE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ViOxTvm/wBcqrRmueJcnA2eKsVM7IiLX+iKhZBMtBWp/RG2pbtop2vcWb6ApVoSzc
	 ppGw8yQVNtX5fBIU76SqhbZjAMA00XB4JsFh/5TkfLxxJZ3KWTNe5jR19wYqKTlyii
	 vePMRNc+fVaocz2/WIyg1fDLR+m3Q+gt45QkjwuY8XWAKMQp6J5g8gzoB/2ZuUF74m
	 5/UWws6pLVPOk9qkiYYZ0dnMFLcdpCaHuHHFKqued+U5Kn8gySLomhmG7lqVgR7Rkz
	 2SY1yf46R8DnIsw7Bdq6mVuo5veVy5sFTp1bUZYuYg3tmykv5SJvIovGBCu2ZsoiDy
	 BKqNYbr1op2pA==
Date: Tue, 20 Jan 2026 14:15:58 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH v2 4/6] KVM: arm64: Account for RES1 bits in
 DECLARE_FEAT_MAP() and co
Message-ID: <20260120211558.GA834868@ax162>
References: <20251210173024.561160-1-maz@kernel.org>
 <20251210173024.561160-5-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210173024.561160-5-maz@kernel.org>
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68654-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nathan@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[c0e0000:email,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,framework-amd-ryzen-maxplus-395:email]
X-Rspamd-Queue-Id: 65B3D4C804
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Marc,

On Wed, Dec 10, 2025 at 05:30:22PM +0000, Marc Zyngier wrote:
> None of the registers we manage in the feature dependency infrastructure
> so far has any RES1 bit. This is about to change, as VTCR_EL2 has
> its bit 31 being RES1.
> 
> In order to not fail the consistency checks by not describing a bit,
> add RES1 bits to the set of immutable bits. This requires some extra
> surgery for the FGT handling, as we now need to track RES1 bits there
> as well.
> 
> There are no RES1 FGT bits *yet*. Watch this space.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

After this change in -next as commit c259d763e6b0 ("KVM: arm64: Account
for RES1 bits in DECLARE_FEAT_MAP() and co"), I am seeing several
"undefined behavior" errors on my two arm64 boxes.

  $ journalctl -k -g '(Linux version|kvm)' --no-hostname -o cat
  Linux version 6.19.0-rc4-00014-gc259d763e6b0 (nathan@framework-amd-ryzen-maxplus-395) (aarch64-linux-gcc (GCC) 15.2.0, GNU ld (GNU Binutils) 2.45) #1 SMP PREEMPT_DYNAMIC Tue Jan 20 13:59:52 MST 2026
  kvm [1]: nv: 568 coarse grained trap handlers
  kvm [1]: Undefined hfgrtr_masks behaviour, bits fff7ffffffffffff
  kvm [1]: Undefined hfgwtr_masks behaviour, bits fff7baffe9db39fb
  kvm [1]: Undefined hfgitr_masks behaviour, bits dfffffffffffffff
  kvm [1]: Undefined hdfgrtr_masks behaviour, bits fffdfb3fffcffeff
  kvm [1]: Undefined hdfgwtr_masks behaviour, bits 73f7763bbfbffdbf
  kvm [1]: Undefined hafgrtr_masks behaviour, bits 0003fffffffe001f
  kvm [1]: Undefined hfgrtr2_masks behaviour, bits 0000000000007fff
  kvm [1]: Undefined hfgwtr2_masks behaviour, bits 0000000000007ffd
  kvm [1]: Undefined hfgitr2_masks behaviour, bits 0000000000000003
  kvm [1]: Undefined hdfgrtr2_masks behaviour, bits 0000000001dfffff
  kvm [1]: Undefined hdfgwtr2_masks behaviour, bits 0000000001f9ffbf
  kvm [1]: IPA Size Limit: 44 bits
  kvm [1]: vgic-v2@c0e0000
  kvm [1]: GICv3 sysreg trapping enabled ([C], reduced performance)
  kvm [1]: GIC system register CPU interface enabled
  kvm [1]: vgic interrupt IRQ9
  kvm [1]: Hyp nVHE mode initialized successfully

At the parent change, there are no warnings:

  $ journalctl -k -g '(Linux version|kvm)' --no-hostname -o cat
  Linux version 6.19.0-rc4-00013-ga035001dea37 (nathan@framework-amd-ryzen-maxplus-395) (aarch64-linux-gcc (GCC) 15.2.0, GNU ld (GNU Binutils) 2.45) #1 SMP PREEMPT_DYNAMIC Tue Jan 20 14:05:51 MST 2026
  kvm [1]: nv: 568 coarse grained trap handlers
  kvm [1]: IPA Size Limit: 44 bits
  kvm [1]: vgic-v2@c0e0000
  kvm [1]: GICv3 sysreg trapping enabled ([C], reduced performance)
  kvm [1]: GIC system register CPU interface enabled
  kvm [1]: vgic interrupt IRQ9
  kvm [1]: Hyp nVHE mode initialized successfully

Is this expected? If there is any other information I can provide from
this machine, I am more than happy to do so.

Cheers,
Nathan

# bad: [d08c85ac8894995d4b0d8fb48d2f6a3e53cd79ab] Add linux-next specific files for 20260119
# good: [24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7] Linux 6.19-rc6
git bisect start 'd08c85ac8894995d4b0d8fb48d2f6a3e53cd79ab' '24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7'
# good: [6639b8bb674daa8e7781884a599e971b71aa2520] Merge branch 'for-next' of https://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git
git bisect good 6639b8bb674daa8e7781884a599e971b71aa2520
# good: [28b7eb3c316bddbe6ba570caf68f560ecc06e66a] Merge branch 'for-next' of https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
git bisect good 28b7eb3c316bddbe6ba570caf68f560ecc06e66a
# bad: [7bdf87f63d2577b8eab4f732e33e91d71d3fba4b] Merge branch 'linux-next' of https://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git
git bisect bad 7bdf87f63d2577b8eab4f732e33e91d71d3fba4b
# good: [27eb76f30bfc3d9f2d3f8f4879fb54f788fdbdb9] Merge branch 'for-next' of https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git
git bisect good 27eb76f30bfc3d9f2d3f8f4879fb54f788fdbdb9
# good: [79a02a116a52c96311b04be8051030c8bd730bb8] Merge branch into tip/master: 'x86/cpu'
git bisect good 79a02a116a52c96311b04be8051030c8bd730bb8
# bad: [1e0ce70c66b8f7fb248d1c6b74a4139e5ac452bc] Merge branch 'next' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git
git bisect bad 1e0ce70c66b8f7fb248d1c6b74a4139e5ac452bc
# good: [5d1563869e30923c5a8de291ce63d2fa82e08202] Merge branch 'for-next' of https://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace.git
git bisect good 5d1563869e30923c5a8de291ce63d2fa82e08202
# bad: [c24170ec742d06021ae7f14df9a1885714ab6095] Merge branch kvm-arm64/selftests-6.20 into kvmarm-master/next
git bisect bad c24170ec742d06021ae7f14df9a1885714ab6095
# bad: [80cbfd7174f31010982f065e8ae73bf337992105] KVM: arm64: Honor UX/PX attributes for EL2 S1 mappings
git bisect bad 80cbfd7174f31010982f065e8ae73bf337992105
# good: [9e27085c33cca7ad26bec0af2c17aab072dd802e] KVM: arm64: nv: Respect stage-2 write permssion when setting stage-1 AF
git bisect good 9e27085c33cca7ad26bec0af2c17aab072dd802e
# good: [f1640174c8a769511641bfd5b7da16c4943e2c64] arm64: Convert ID_AA64MMFR0_EL1.TGRAN{4,16,64}_2 to UnsignedEnum
git bisect good f1640174c8a769511641bfd5b7da16c4943e2c64
# bad: [c259d763e6b09a463c85ff6b1d20ede92da48d24] KVM: arm64: Account for RES1 bits in DECLARE_FEAT_MAP() and co
git bisect bad c259d763e6b09a463c85ff6b1d20ede92da48d24
# good: [a035001dea37b885efb934e25057430ae1193d0a] arm64: Convert VTCR_EL2 to sysreg infratructure
git bisect good a035001dea37b885efb934e25057430ae1193d0a
# first bad commit: [c259d763e6b09a463c85ff6b1d20ede92da48d24] KVM: arm64: Account for RES1 bits in DECLARE_FEAT_MAP() and co


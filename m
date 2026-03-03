Return-Path: <kvm+bounces-72536-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oKP9LITzpmkzawAAu9opvQ
	(envelope-from <kvm+bounces-72536-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 15:43:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C93CF1F1B76
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 15:43:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DDC3E317D213
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 14:37:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A56C23DEAD8;
	Tue,  3 Mar 2026 14:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RhIGlnEx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F933C278E;
	Tue,  3 Mar 2026 14:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772548623; cv=none; b=YDr1Hvj87EtSZV1mlE/cBsIYKoWZsKbLt8s2nBEkOMKxVhdTn0TkO6sPkfQLL6EM63ZguqXBUzIP3goKm1NKW/W/dBIFGkONbiO9h5vyc0OBM4GzDXC6M7clq0rfVwj2lE8U6uTPg7PqIn7ecT+nL2RLCmsTtHmv0NvNC7pkXa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772548623; c=relaxed/simple;
	bh=m/46LDof3LqadCUxR8EzTO5Nf7CZ0A3+ar1RNvzBB9o=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VcvGeWaVlRgyrffGl9iQRSfkLiYPbsEjCUn6i77jZWqU8qyxc7Dy9JNgUMbo1UvbzLB0xSxcj7VA9s7uvmVOHqiB6XBBrxK9x+2m0OH+RKX9nIl3LnuHt7U4sbCLPxYc0qISt7DfsFlwOBxqlWEzi7UFN2mlH42MiAFNjbtPBL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RhIGlnEx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62312C116C6;
	Tue,  3 Mar 2026 14:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772548623;
	bh=m/46LDof3LqadCUxR8EzTO5Nf7CZ0A3+ar1RNvzBB9o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RhIGlnExbvHqjrKvCOMAYKyPDILck1mHKuxKeTG/9P6sPpSNVQ6cVGSbL7lVk0eE2
	 9UBoGOLIEh5qWL6s/JISGlQp4mz2iB1ITIS/uvl3pIwQGYg5ONc4wXsEBwsSEjDkaf
	 HiozHmY/lH7MsUI5MKc3IsX58h9FjCaE+SHWEu7RxOJ7OYKS+ZT2t+QKfnIbgpP1mi
	 Z6PxJHzw0gydgaJntW4yn9TDSF7osodkzkreMS3Hwm87DShNUjUQGxPNJEoNYQmCKg
	 DutUnLfDX3IAkSu/QqMQWjQxTmao9OnlpFNO4lH+y/+Py6hImTNQ1TZaVemn0rovDS
	 KiNaUBc0WC6sQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vxQrs-0000000FfAT-4AND;
	Tue, 03 Mar 2026 14:37:01 +0000
Date: Tue, 03 Mar 2026 14:37:00 +0000
Message-ID: <86ecm17zeb.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei
 <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH v12 06/46] arm64: RMI: Define the user ABI
In-Reply-To: <d87ee902-3b5e-4cf9-8b97-d83f8da02a5a@arm.com>
References: <20251217101125.91098-1-steven.price@arm.com>
	<20251217101125.91098-7-steven.price@arm.com>
	<86tsuy8g0u.wl-maz@kernel.org>
	<33053e22-6cc6-4d55-bc7f-01f873a15d28@arm.com>
	<9d702666-72a8-43e4-8ab3-548d8154a529@arm.com>
	<86fr6h838s.wl-maz@kernel.org>
	<d87ee902-3b5e-4cf9-8b97-d83f8da02a5a@arm.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/30.1
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: suzuki.poulose@arm.com, steven.price@arm.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, james.morse@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, joey.gouly@arm.com, alexandru.elisei@arm.com, christoffer.dall@arm.com, tabba@google.com, linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com, gshan@redhat.com, sdonthineni@nvidia.com, alpergun@google.com, aneesh.kumar@kernel.org, fj0570is@fujitsu.com, vannapurve@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Rspamd-Queue-Id: C93CF1F1B76
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72536-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On Tue, 03 Mar 2026 14:23:08 +0000,
Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> 
> On 03/03/2026 13:13, Marc Zyngier wrote:
> > On Mon, 02 Mar 2026 17:13:41 +0000,
> > Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> >> 
> >> More importantly, we have to make sure that the "RMI_PSCI_COMPLETE" is
> >> invoked before both of the following:
> >>    1. The "source" vCPU is run again
> >>    2. More importantly the "target" vCPU is run.
> > 
> > I don't understand why (1) is required. Once the VMM gets the request,
> 
> The underlying issue is, the RMM doesn't have the VCPU object for the
> "target" VCPU, to make the book keeping. Also, please note that for  a
> Realm, PSCI is emulated by the "RMM". Host is obviously notified of the
> "PSCI" changes via EXIT_PSCI (note, it is not SMCCC exit)
>  so that it can be in sync with the real state. And does have a say in
>  CPU_ON. So, before we return to running the "source" CPU,
> Host must provide the target VCPU object and its consent (via
> psci_status) to the RMM. This allows the RMM to emulate the PSCI
> request correctly and also at the same time keep its book keeping
> in tact (i.e., marking the Target VCPU as runnable or not).
> 
> When a "source" VCPU exits to the host with a PSCI_EXIT, the RMM
> marks the source VCPU has a pending PSCI operation, and
> RMI_PSCI_COMPLETE request ticks that off, making it runnable again.

Sure. What I don't get is what this has to happen on the source vcpu
thread. The RMM has absolutely no clue about that, and there should be
no impediment to letting the target vcpu do it as it starts.

Even better, you should be able to do that on the first thread that
reenters the guest, completely removing any RMM knowledge from the
PSCI handling in userspace.

If you can't do that, then please consider fixing the RMM to allow it.

Thanks,

	M.

-- 
Without deviation from the norm, progress is not possible.


Return-Path: <kvm+bounces-69541-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0HvrIuVQe2meDwIAu9opvQ
	(envelope-from <kvm+bounces-69541-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 13:21:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 20924B0058
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 13:21:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CE457300A4F5
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 12:21:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E899437F8B1;
	Thu, 29 Jan 2026 12:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="usnYy/1I"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout02.his.huawei.com (sinmsgout02.his.huawei.com [119.8.177.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF5729DB65
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 12:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769689308; cv=none; b=q3sHrELxIy4qwxUmLnOqf+ODpXQefvXDARoDrP74b8QIbFjs10/bySI02Py3Uh6xrcymxY+i6szJHXle+pG4CKp25rOZ4ztZxWEkFQhibXv3w6pKiklGBxnKNX/9P3PxjHwWlRPDMe6g/CCQQ7aV/jut50AGwzmbquv6BwaN60Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769689308; c=relaxed/simple;
	bh=REowasn8xn/ytBAecJSuaCSFjx7jOXEuszdz8EtTRO0=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g1Qx0xVTzgGahLu9YToXkqE9DrhRHHVdKm7ka9opAikgZxvqYz6d0aZALGSkSgwlkg7qYG1q4rAY6Hlp4AuWzi67k3OspuD0VrJNl8AX4oUdxV1qZa1DLph3oKgFBC2qlvQy9B69CPcq6qnsn3f+MG+SC+V2YiApg3gyCV8FtR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=usnYy/1I; arc=none smtp.client-ip=119.8.177.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=PElI1rsyETN147jyZgm5oFt9PCn+f+EDSDG27bKeDKA=;
	b=usnYy/1IvNKv/ssW9vZHukk49Nj+gETALbUhNsfWuzLc1SdMz2fywO/yoD7DsLRhbu/QzB8VU
	13t+yZ0OrUBzShlCO5kYDnIIdYTbcZAo4Jheh3ngCYBFkfS79/6j/34rdzWklEIMoG3jpXcHV1E
	Qes7yuqlzEm/8+uUskuAC54=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4f1yqW2NdTz1vnKn;
	Thu, 29 Jan 2026 20:19:03 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f1ysf5V1JzJ46BK;
	Thu, 29 Jan 2026 20:20:54 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id E716F40585;
	Thu, 29 Jan 2026 20:21:33 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 29 Jan
 2026 12:21:33 +0000
Date: Thu, 29 Jan 2026 12:21:31 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd
	<nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Timothy Hayes
	<Timothy.Hayes@arm.com>
Subject: Re: [PATCH v4 21/36] KVM: arm64: gic-v5: Check for pending PPIs
Message-ID: <20260129122131.00006a5a@huawei.com>
In-Reply-To: <20260128175919.3828384-22-sascha.bischoff@arm.com>
References: <20260128175919.3828384-1-sascha.bischoff@arm.com>
	<20260128175919.3828384-22-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml500005.china.huawei.com (7.214.145.207)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[huawei.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[huawei.com:s=dkim];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_FROM(0.00)[bounces-69541-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DKIM_TRACE(0.00)[huawei.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:email,huawei.com:email,huawei.com:dkim,huawei.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jonathan.cameron@huawei.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 20924B0058
X-Rspamd-Action: no action

On Wed, 28 Jan 2026 18:04:43 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> This change allows KVM to check for pending PPI interrupts. This has
> two main components:
> 
> First of all, the effective priority mask is calculated.  This is a
> combination of the priority mask in the VPEs ICC_PCR_EL1.PRIORITY and
> the currently running priority as determined from the VPE's
> ICH_APR_EL1. If an interrupt's priority is greater than or equal to
> the effective priority mask, it can be signalled. Otherwise, it
> cannot.
> 
> Secondly, any Enabled and Pending PPIs must be checked against this
> compound priority mask. The reqires the PPI priorities to by synced
> back to the KVM shadow state on WFI entry - this is skipped in general
> operation as it isn't required and is rather expensive. If any Enabled
> and Pending PPIs are of sufficient priority to be signalled, then
> there are pending PPIs. Else, there are not. This ensures that a VPE
> is not woken when it cannot actually process the pending interrupts.
> 
> As the PPI priorities are not synced back to the KVM shadow state on
> every guest exit, they must by synced prior to checking if there are
> pending interrupts for the guest. The sync itself happens in
> vgic_v5_put() if, and only if, the vcpu is entering WFI as this is the
> only case where it is not planned to run the vcpu thread again. If the
> vcpu enters WFI, the vcpu thread will be descheduled and won't be
> rescheduled again until it has a pending interrupt, which is checked
> from kvm_arch_vcpu_runnable().
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>




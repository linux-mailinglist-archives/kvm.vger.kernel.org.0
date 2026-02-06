Return-Path: <kvm+bounces-70407-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WP/ZFOVihWkZBAQAu9opvQ
	(envelope-from <kvm+bounces-70407-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 04:41:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A84C1F9D0C
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 04:41:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6397A3023DD3
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 03:34:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 180593321C8;
	Fri,  6 Feb 2026 03:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ziyao.cc header.i=me@ziyao.cc header.b="l0RmotT0"
X-Original-To: kvm@vger.kernel.org
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB5A265CC2;
	Fri,  6 Feb 2026 03:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770348897; cv=pass; b=dFlWP4IBRi+h25QSy21ihxYdYDlYJmsatbEw51QiJg9DqxX1r95sn7dJf0WIyjmAo7L64UYpNFFl6IPin88nsyVe12/8DgheUAtUMQlC6IYfqR+fAY1OhkRGCcMVSkbtE4WHAGDCOx0oLncRS29eXobvhp4j2SW3AJjGzkP0lcI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770348897; c=relaxed/simple;
	bh=bq/GLY4H/bSUfQB+OfZ0AfftnABf3kW2Lo52g8x5QuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OUzYNNCRwTCPog/SDvcZzS4ebTQ5YViAH2LQ/J/LLE/6rR1oHjYSBaymrtK8Vm66tCS6srnYMgaGSDFswUDQhvoGgVrE4/gWLyVu4IF2++JX0GHwqbOPIFSFMLM8Mmu0AtQMIFceruxTtd/qQlPUg1/QT0PHS55YchBVbX3GQ9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ziyao.cc; spf=pass smtp.mailfrom=ziyao.cc; dkim=pass (1024-bit key) header.d=ziyao.cc header.i=me@ziyao.cc header.b=l0RmotT0; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ziyao.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziyao.cc
ARC-Seal: i=1; a=rsa-sha256; t=1770348882; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=i9b/c2lOBLo9rrmCdp6P10o0NhKtnO+SuKPAUv6YVZW0fwG48stA2+OKmRQfYXPU8JEuw2IkagSPvh437qyXhdsGX2rp/A5+Z9B5Ido5fgBG/LwT+/tgWkJD2CGw2Bu1yqekO30MSCf84Ai81HW/TM5Fphl+0w8iOoZK/MWUcA8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1770348882; h=Content-Type:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=ytVDG181jwZsXmo/aNohS0Ou07+vfJqUMBsLgAw8gs4=; 
	b=LRIhhbi+Pvz1B38XX/5eh0+w3ahrwOqjtw2KsvoPKOUMpcFEeXrwHy0xw8lmkpjWsZkoE4Gq27QYsnSCZJ4xRm41Jet8kcU+bqsdF601Cn2KZOQ3+aNHM+HVVb9pYh8FQB85vIMXT7LGu/J4cboKdFFU+S0cXFgsPUXlyft79T0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=ziyao.cc;
	spf=pass  smtp.mailfrom=me@ziyao.cc;
	dmarc=pass header.from=<me@ziyao.cc>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1770348882;
	s=zmail; d=ziyao.cc; i=me@ziyao.cc;
	h=Date:Date:From:From:To:To:Cc:Cc:Subject:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To:Message-Id:Reply-To;
	bh=ytVDG181jwZsXmo/aNohS0Ou07+vfJqUMBsLgAw8gs4=;
	b=l0RmotT0BY2qgVlTsejdVTlIFv9qiCgSeJlOMwT8mnI1rA/cD/u9VLVzQCrIq6G8
	q5D3GoQQmipOjkACX/1ATgOfASODIy6UyzV1CFIwpVWzqDCLmfw+U3b4oZXFs6SXVj8
	BsduiuNuUKzC8WHthyZV/UQwIJe7bkLQWNG8JTYY=
Received: by mx.zohomail.com with SMTPS id 1770348880707918.1372263152211;
	Thu, 5 Feb 2026 19:34:40 -0800 (PST)
Date: Fri, 6 Feb 2026 03:34:34 +0000
From: Yao Zi <me@ziyao.cc>
To: Song Gao <gaosong@loongson.cn>, maobibo@loongson.cn,
	chenhuacai@kernel.org
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev, kernel@xen0n.name,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/2] LongArch: KVM: Add DMSINTC support irqchip in
 kernel
Message-ID: <aYVhSp_eGBkpXdp-@pie>
References: <20260206012028.3318291-1-gaosong@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206012028.3318291-1-gaosong@loongson.cn>
X-ZohoMailClient: External
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [7.84 / 15.00];
	URIBL_BLACK(7.50)[ziyao.cc:dkim];
	MID_RHS_NOT_FQDN(0.50)[];
	MAILLIST(-0.15)[generic];
	BAD_REP_POLICIES(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70407-lists,kvm=lfdr.de];
	R_DKIM_ALLOW(0.00)[ziyao.cc:s=zmail];
	FROM_HAS_DN(0.00)[];
	GREYLIST(0.00)[pass,body];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[ziyao.cc,quarantine];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[me@ziyao.cc,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[ziyao.cc:+];
	R_SPF_ALLOW(0.00)[+ip4:172.234.253.10:c];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	ARC_ALLOW(0.00)[subspace.kernel.org:s=arc-20240116:i=2];
	NEURAL_SPAM(0.00)[0.987];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[patchew.org:url,ziyao.cc:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A84C1F9D0C
X-Rspamd-Action: add header
X-Spam: Yes

On Fri, Feb 06, 2026 at 09:20:26AM +0800, Song Gao wrote:
> Hi,
> 
> This series  implements the DMSINTC in-kernel irqchip device,
> enables irqfd to deliver MSI to DMSINTC, and supports injecting MSI interrupts
> to the target vCPU.
> applied this series.  use netperf test.
> VM with one CPU and start netserver, host run netperf.
> disable dmsintc
> taskset 0x2f  netperf -H 192.168.122.204 -t UDP_RR  -l 36000
> Local /Remote
> Socket Size   Request  Resp.   Elapsed  Trans.
> Send   Recv   Size     Size    Time     Rate
> bytes  Bytes  bytes    bytes   secs.    per sec   
> 
> 212992 212992 1        1       36000.00   27107.36   
> 
> enable dmsintc
> Local /Remote
> Socket Size   Request  Resp.   Elapsed  Trans.
> Send   Recv   Size     Size    Time     Rate         
> bytes  Bytes  bytes    bytes   secs.    per sec   
> 
> 212992 212992 1        1       36000.00   28831.14  (+6.3%)
> 
> v6: 
>   Fix kvm_device leak in kvm_dmsintc_destroy(). 
> 
> v5:
>   Combine patch2 and patch3
>   Add check msgint feature when register DMSINT device. 
> 
> V4: Rebase and R-b; 
>    replace DINTC to DMSINTC.
> 
> 
> V3: Fix kvm_arch_set_irq_inatomic() missing dmsintc set msi.(patch3)
> 
> V2:
> https://patchew.org/linux/20251128091125.2720148-1-gaosong@loongson.cn/
> 
> Thanks.
> Song Gao
> 
> Song Gao (2):
>   LongArch: KVM: Add DMSINTC device support
>   LongArch: KVM: Add dmsintc inject msi to the dest vcpu

There's a typo in the titles, it should be LoongArch instead of
"LongArch".

Best regards,
Yao Zi


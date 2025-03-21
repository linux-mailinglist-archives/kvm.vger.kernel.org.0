Return-Path: <kvm+bounces-41662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A627AA6BC2D
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 14:57:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4224D3BA3B0
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 13:56:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03BFE7DA6D;
	Fri, 21 Mar 2025 13:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="dHeloZsX"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEE178F29;
	Fri, 21 Mar 2025 13:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742565370; cv=none; b=YlqDtvOv3h1U+nVb206XH09j0vTpIrEJIvSbAzOEVZ5qDziGQe9crxlEU1kVDddZuDX5RvNEwWj9/93ai97bI/LxWUouij3I6s64/i3ZyxyZESLpoMawQb+1qcoSw/rU8eRHXqkDKaQM55JSJxuC6qbhRqbSAFQMExdBAa6SLJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742565370; c=relaxed/simple;
	bh=7RcHMjkdrbinJfjPnW5iZgGqX4CyQw4F4Wh+A0lNNVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GQjapFlHdQ7bgZ/pZDMibR2R7FabneA6L2+E2P1Tuk1p27nRvKKuzG7DQ2nMBlh9ZrxxUupNIgvBsBh4dRGRtoUg6Rq2ip6IspKnuNtaLcRgv+qhXnW1Gr7NkR30zBMQKTVZ18diTxS54akEYki/TXUfvojSeIsNjaK2xJZilbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=dHeloZsX; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3AB9940E021E;
	Fri, 21 Mar 2025 13:56:06 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id XMqA9_VsUkIv; Fri, 21 Mar 2025 13:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1742565361; bh=JFIoIEOMrCTLhKIWLcgf2DqhinhARYhRZdQExDukfN4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dHeloZsX9ymLSlObrluZVBboHORg5h0ggDY8G9HeU4tPHIMCYPre3IFTUcHE6qOx6
	 OQdhWHbL++FRmdP5uizgDuYhZtWYxXYffRfkOK3NXMwaR4LmhO28dISCXOfWDsb+dn
	 Uv1u1m+TijRjUVleu7/4h7ZHJcPbUmEDhBHc/+YKOut+JTQI5cirLqkq3NKYksNGVy
	 +g0lF7dv8TzR8gDgG1Z/zf6+Fhss/ZPt7W+I1ECN1YTVhSeWxoDzQz3fCsOraI9c9S
	 X9chiI0rvcKRdODaMTvBPZ0LoLKVbalQ4YIxMgOrUTBV+Y8dnFLhS7UvmcuAqE0btD
	 R4e6OGu+fACoo3G3q0Dk/lO5+Quzf5zcn849mHt7jLrQ5AuXAn8HBebvfGtdDwWWSf
	 FJTfMjoKggcg7d0tVG6eJT4bNZ7oqJl0iMCLO9tb331nSopxCkDlzLhktgNGrVth0J
	 DItVrg7ubru+2zj7Sky9o7Pojwp3O4RIiF0qzubBuv7ZkdsRbi0bvIfFhvZzxPKhME
	 BByp7IV5lZ1Y1vIHZXdMrfD25D/NJbSA64xr2wEg7t9kwmn8Sd78AS8PWJqUY05hqM
	 7uHW54L4l/wshFi9s2CsmXAoNoxmNvtfRKEyJxl7zx9C40zHkJ5rX0nGi9hI7glLnY
	 CixPf9Om+oywGkbkboJyUahc=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5A72740E0215;
	Fri, 21 Mar 2025 13:55:41 +0000 (UTC)
Date: Fri, 21 Mar 2025 14:55:40 +0100
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org,
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
	naveen.rao@amd.com
Subject: Re: [RFC v2 01/17] x86/apic: Add new driver for Secure AVIC
Message-ID: <20250321135540.GCZ91v3N5bYyR59WjK@fat_crate.local>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-2-Neeraj.Upadhyay@amd.com>
 <20250320155150.GNZ9w5lh9ndTenkr_S@fat_crate.local>
 <a7422464-4571-4eb3-b90c-863d8b74adca@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a7422464-4571-4eb3-b90c-863d8b74adca@amd.com>

On Fri, Mar 21, 2025 at 09:14:15AM +0530, Neeraj Upadhyay wrote:
> Do you think we should handle this case differently and not force select
> AMD_SECURE_AVIC config when AMD_MEM_ENCRYPT config is enabled?

Yeah, you'd have to do some simple CONFIG_AMD_SECURE_AVIC ifdeffery and add
(or not) the flag to SNP_FEATURES_PRESENT, depending...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


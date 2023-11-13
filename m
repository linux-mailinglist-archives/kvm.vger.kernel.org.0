Return-Path: <kvm+bounces-1615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E4DB7EA2D7
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 19:30:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 669561C20964
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 18:30:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 294442374D;
	Mon, 13 Nov 2023 18:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="URdSOo5a"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1B822F0D;
	Mon, 13 Nov 2023 18:30:23 +0000 (UTC)
Received: from mail.alien8.de (mail.alien8.de [IPv6:2a01:4f9:3051:3f93::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB8B172C;
	Mon, 13 Nov 2023 10:30:19 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 849C740E0191;
	Mon, 13 Nov 2023 18:30:17 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id vIR0tkFfDk7P; Mon, 13 Nov 2023 18:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1699900215; bh=QGUJ2C4j4YRZSL/U1xa+aaW+qjnM9Ayip2GHUoCQbrs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=URdSOo5atytuczMmbDY6wONUqVHGwPzBY+Ft6r7t2wqWxYpmjhb8q5WUpOi/bXSA5
	 fJ5TW/gAX2J5Fg3Yrixa37rJaTWaX2xG2GP2Srly/D51K8bIlKWqgqEj1TFiEGKM6B
	 MDKQ3/YghE54YThudVhfA3Jm4PDiKtKqksPmrK+PeJ8FVtgBtNckL3zManei+Pyi1f
	 e3dsFQBcbGTQsF2fhzV/KYCdRhzBSc/UfuYV9q6kZFEK9XxiacsmrtEVwSIQQ6sge8
	 1cjKTmrp4l91XDbS3OkHDBCSMZSAaB8rhMsfg0Zkr8yFHr+jualMdcmrmSLxbxpAMZ
	 gXkKKAduMrUEw3/crCu69g1FUTrLbM+aBp8q5qMu+mb+WVawknTYPZ2PrJzaSLOMzW
	 eI2IleRus14qCFdmSYWN32apAmJBpfkEFdkSEeb44MzcNJ8qVuttPQIBmxH0O9j/17
	 qx2UYOK2bVXxXs8ovE3SvECy+JZz2HeNXN3hh5lL7l0qOQ8EiRVCoXpUT7220lntyq
	 4YAZ2HblHaiSC/1DRV/ic58WOM/BHcuaqykTtiPq+Y5r8Y/7iW+yg7Fd6v/9I/X0jl
	 rL9BIJh+KcXziVjf09XFcoI+uWyBh9S5dBkFNlCLgPKN003pXaJ13c3sMBO5iB4cmR
	 hDLQpgt7qlF5RnhXKZicYwPs=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B6D7140E0171;
	Mon, 13 Nov 2023 18:29:52 +0000 (UTC)
Date: Mon, 13 Nov 2023 19:29:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Xin Li <xin3.li@intel.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
	linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
	peterz@infradead.org, jgross@suse.com, ravi.v.shankar@intel.com,
	mhiramat@kernel.org, andrew.cooper3@citrix.com,
	jiangshanlai@gmail.com, nik.borisov@suse.com
Subject: Re: [PATCH v12 19/37] x86/fred: Update MSR_IA32_FRED_RSP0 during
 task switch
Message-ID: <20231113182947.GEZVJrGyMS4KzQafIK@fat_crate.local>
References: <20231003062458.23552-1-xin3.li@intel.com>
 <20231003062458.23552-20-xin3.li@intel.com>
 <20231113093742.GAZVHuZk9CGTRIfAWb@fat_crate.local>
 <3BFEBDE8-6F90-43A5-AE34-07B0ED0CAAAE@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3BFEBDE8-6F90-43A5-AE34-07B0ED0CAAAE@zytor.com>

On Mon, Nov 13, 2023 at 12:36:04PM -0500, H. Peter Anvin wrote:
> A resource cannot be consumed after the value has been written; this
> is the only necessary level of serialization, equivalent to, say, RAX.

Lemme see if I understand this correctly using this context as an
example: after this MSR_IA32_FRED_RSP0 write, any FRED events determined
to be delivered to level 0 will use this new task stack ptr?

And since the new task is not running yet and the old one isn't running
either, we're fine here. So the "serialization point" I was talking
about above is bollocks.

Close? :)

> A serializing instruction stops the entire pipeline until everything
> has retired and any stores have become globally visible.

Right, we don't need that here.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


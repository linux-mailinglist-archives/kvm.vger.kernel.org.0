Return-Path: <kvm+bounces-57099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F9E5B4AB95
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 13:21:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC412368312
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 11:18:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 092CB322DB9;
	Tue,  9 Sep 2025 11:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="WLQUWme3";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="SldXvu8b"
X-Original-To: kvm@vger.kernel.org
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC4732253F;
	Tue,  9 Sep 2025 11:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757416586; cv=none; b=kt2SPSEzRsM/Kq2gCypINaQjH6GbxV7umwDoojeupZE3fJiTZMm9rEcXWDFoWIMDmr5A0dzMSfD5NldVO7vWAo6xwg0h4POTobZmDe7TkmKuc/30ld/pkQtp/GdGHoIxZAopYkjDwA+Nh4R6K7h22t5rcz255rcptiPKW44FZgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757416586; c=relaxed/simple;
	bh=II4qPqDnhCBPjiIWBkQLj0UWCLPwIx7UBs+NWSzfdqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ih9sFJt4QndQxz2/149HRVbHhpYzcZlXTk7vMarLHnG3vr1ESUq7OYiv5KOImbzMG/c71NYcqyss8LG9EASS03L9wEB2rigHM2DlxKCGw1Bs2Gine/ZiPxL7MEahF6eBnq79iECIVmMhnLvZDK6ga16vQsAO5bbbr5Olr9C8KHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=WLQUWme3; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=SldXvu8b; arc=none smtp.client-ip=202.12.124.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailflow.stl.internal (Postfix) with ESMTP id A393D1300257;
	Tue,  9 Sep 2025 07:16:22 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Tue, 09 Sep 2025 07:16:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1757416582; x=
	1757423782; bh=y2CFYHxP4XfuS02FIGZqf2T6LghC1ieyWzxSlB+944E=; b=W
	LQUWme3KswuewZEa8+qBbMA6MdCjN3eHT4qEvGWF9rBN0kYhij1XzUmBndet4f9c
	31C36cs4+mO5QCBY0RA8NSDI1K/YfvxRky5x6YPWXIwKiPFHz9iw9HtCtJOxVD9r
	fnOosfK1xBGTzqapcTLQZ2U44Aj/nP1YWmbw9/pnjSU1vkIar7CYdnHaQTnDMiGr
	hF99jDeLD5yqFBPJWfaRXzJyITEHM3XKPLf6wMW2EjFhMNPc34GQc88q3bi/0zSV
	poeHyRhZk2X3jwb23ALkS+HpfvIZgU3DUTbKGiCcmq7ScpKxRBFKV3JWFkju4+kJ
	UdZ6KXHUJseAMiBVWxLDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1757416582; x=1757423782; bh=y2CFYHxP4XfuS02FIGZqf2T6LghC1ieyWzx
	SlB+944E=; b=SldXvu8bK88J4YBvm7pgZ0ABTQiTqS66/PbTFSzUgXg620CJxMc
	qk/XtlLgHFAqhw6rCELpOQBXKELRaxvL7tHT8mC3uF6I6qKGImDjuSyO8edbeLOT
	0+PU46EmQ0kh0eSPQUX+xxqLIRZo8DMQ4qO4/2pWXcsivvSUj0Fn5nxNixLEQYud
	D7NeWPGO+9Q9hxWaiE40h+HxLqgwYbFtNTRTTTH1AHCexwY0QqaFhUnOzXYGZqED
	/NBN+HVbZUz2QKBW+UUmdLbik9XS/npnG1WxmqU3n7BxaXWwvPSceB20x+rluGfR
	9eqvl9McZ0Yokb0FocL65NjiyaP2u3KN8hA==
X-ME-Sender: <xms:hQzAaGxyyLXIi_wFHIu53OR9es9XsQs-FLyIMkBilCh9JE7wJSwFJQ>
    <xme:hQzAaFNWQ34rTsqA3Q31qRY3LcwQd3nQexGRUBh-uMgX29cMo2iof_Ou318VxH2dU
    hsbNIItvP5qp01gAPg>
X-ME-Received: <xmr:hQzAaMgewOimRMWKlTpZh1bNQeWmUo2VsA-yuGEYweUkgbMzKhrcLilt3WxQTg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvtddvjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepfeeg
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegurghvvgdrhhgrnhhsvghnsehinh
    htvghlrdgtohhmpdhrtghpthhtohepkhhirhhilhhlrdhshhhuthgvmhhovheslhhinhhu
    gidrihhnthgvlhdrtghomhdprhgtphhtthhopehpsghonhiiihhnihesrhgvughhrghtrd
    gtohhmpdhrtghpthhtohepshgvrghnjhgtsehgohhoghhlvgdrtghomhdprhgtphhtthho
    pegurghvvgdrhhgrnhhsvghnsehlihhnuhigrdhinhhtvghlrdgtohhmpdhrtghpthhtoh
    eprhhitghkrdhprdgvughgvggtohhmsggvsehinhhtvghlrdgtohhmpdhrtghpthhtohep
    ihhsrghkuhdrhigrmhgrhhgrthgrsehinhhtvghlrdgtohhmpdhrtghpthhtohepkhgrih
    drhhhurghnghesihhnthgvlhdrtghomhdprhgtphhtthhopeihrghnrdihrdiihhgrohes
    ihhnthgvlhdrtghomh
X-ME-Proxy: <xmx:hQzAaJtOhaX-9VHvAPaoHTMM32HgiB2BjMMumG6uAO4V12HuakkHgg>
    <xmx:hQzAaEUiNIIjyGqfJBZ6cGLLezz4SD8592jT2QyXDOh1FIHaUHB63g>
    <xmx:hQzAaBbSWL8BbmUNhlt3EmXNMD9gU-_3K8td4P6ZFIM_6vPQl_VQlA>
    <xmx:hQzAaOt_Qpm8x5U3whmPQaPTS0IooKB-ByiBWJ3duQ6REBWUKf8_Bw>
    <xmx:hgzAaHzmNR1EB_XLNGav96q-k2sw2IdE065K6wLKGYcpWpJYpI5Vbkn6>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 9 Sep 2025 07:16:21 -0400 (EDT)
Date: Tue, 9 Sep 2025 12:16:19 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, 
	pbonzini@redhat.com, seanjc@google.com, dave.hansen@linux.intel.com, 
	rick.p.edgecombe@intel.com, isaku.yamahata@intel.com, kai.huang@intel.com, 
	yan.y.zhao@intel.com, chao.gao@intel.com, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Message-ID: <p5tqgxmmwnw2ie6ea2q7b2v7ivbsebyjpucm6csrvl2eghuzw5@bods3pzhyslj>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <2537ad07-6e49-401b-9ffa-63a07740db4a@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2537ad07-6e49-401b-9ffa-63a07740db4a@intel.com>

On Mon, Sep 08, 2025 at 12:17:58PM -0700, Dave Hansen wrote:
> On 6/9/25 12:13, Kirill A. Shutemov wrote:
> > The exact size of the required PAMT memory is determined by the TDX
> > module and may vary between TDX module versions, but currently it is
> > approximately 0.4% of the system memory. This is a significant
> > commitment, especially if it is not known upfront whether the machine
> > will run any TDX guests.
> > 
> > The Dynamic PAMT feature reduces static PAMT allocations. PAMT_1G and
> > PAMT_2M levels are still allocated on TDX module initialization, but the
> > PAMT_4K level is allocated dynamically, reducing static allocations to
> > approximately 0.004% of the system memory.
> 
> I'm beginning to think that this series is barking up the wrong tree.
> 
> >  18 files changed, 702 insertions(+), 108 deletions(-)
> 
> I totally agree that saving 0.4% of memory on a gagillion systems saves
> a gagillion dollars.
> 
> But this series seems to be marching down the path that the savings
> needs to be down at page granularity: If a 2M page doesn't need PAMT
> then it strictly shouldn't have any PAMT. While that's certainly a
> high-utiltiy tact, I can't help but think it may be over complicated.
> 
> What if we just focused on three states:
> 
> 1. System boots, has no DPAMT.
> 2. First TD starts up, all DPAMT gets allocated
> 3. Last TD shuts down, all DPAMT gets freed
> 
> The cases that leaves behind are when the system has a small number of
> TDs packed into a relatively small number of 2M pages. That occurs
> either because they're backing with real huge pages or that they are
> backed with 4k and nicely compacted because memory wasn't fragmented.
> 
> I know our uberscaler buddies are quite fond of those cases and want to
> minimize memory use. But are you folks really going to have that many
> systems which deploy a very small number of small TDs?
> 
> In other words, can we simplify this? Or at least _start_ simpler with v1?

You cannot give all DPAMT memory to TDX module at the start of the first
TD and forget about it. Well you can, if you give up ever mapping guest
memory with 2M pages.

Dynamic PAMT pages are stored into PAMT_2M entry and you cannot have 2M
page and have Dynamic 4K entries stored there at the same time.

You would need to handle at least for promotion/demotion and stash this
memory somewhere while 2M pages used.

And it is going to be very wasteful. With huge pages, in most cases, you
only need dynamic PAMT for control pages. You will have a lot of memory
sitting in stash with zero use.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov


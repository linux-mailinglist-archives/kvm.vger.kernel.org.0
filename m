Return-Path: <kvm+bounces-33057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1D9C9E42D1
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 19:05:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E071816A456
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 18:05:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BB1420D4E9;
	Wed,  4 Dec 2024 17:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="bBw4sB5f";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ID39xCta"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E2F2066FB;
	Wed,  4 Dec 2024 17:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733334799; cv=none; b=fx0ghJRY6mDN0PJf4kUISdqxC6Hs01BRCD4M9y2mOcJDhsmXqzC/ib4RA8pTAAFJuGhp1NAgqNFUNU+z96g8RqCQHOwtrHZld8ECcTZ3Hj6DePh5AEBIOrpTw3N4BKxi63DVSm19Gw9Gp3fjcrGSjbmU7L6nLkAx0GPYhUcGdso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733334799; c=relaxed/simple;
	bh=ILqcDVf0bHvauQ7XevK6gLD0PM4sliITJZefCfN3d7M=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=curxM9IvTaCaK4ozp0ZjhawVMzZEHDEdrHgIxgeRSSPCkYVpegMVprLAXEpo+eEcV2Zy2fdnPgh5kceVK3viycoB3HRyvu4MI3P4LuoSjtzfBhfuFAzQcyyZnDE0K//Dlpk1YCeCTBlXO8EBwWPnBMaL6RWO0IlP4U6VkAJ6ANY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=bBw4sB5f; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ID39xCta; arc=none smtp.client-ip=202.12.124.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfhigh.stl.internal (Postfix) with ESMTP id C9FA925401D6;
	Wed,  4 Dec 2024 12:53:15 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Wed, 04 Dec 2024 12:53:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1733334795;
	 x=1733421195; bh=oWL3XXyWg2R72Xts4Xo78/Yld3x5a5rS9W2B7LxHVzc=; b=
	bBw4sB5fF1//66xy4theRT4CpQxzw3s5cLBTfffQ9ayMk6ETfJIB3wBiKkxxUKqe
	eOPV2q/yPqBubHyc4NSR2pRCeOb9AQJQA20ah2na3448PROrVfSN6eYUtp+1uu9m
	mpX9q8PyOib2MwugiSNQVujN5bfQpQ/LSM5GViT/LP6LTScexhbpFgEa+N3x2Og0
	vlSLKPHsqf1y08NXBnPRpId99vFOIX3nSlD6PiWmc5qKB42+lSw/+VQNCpg/QLO2
	AoFtkZsc9j9W0X1xqFvmIKfg5zQfLE+9JgWIw1UJzKhVOx2GDBtBc3+AIA8u+NFg
	TzZuz1jyXk4HSWhAmw74lg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1733334795; x=
	1733421195; bh=oWL3XXyWg2R72Xts4Xo78/Yld3x5a5rS9W2B7LxHVzc=; b=I
	D39xCtah2vTTGuhlbA9t/sITxspFcf/KKhVlMnK3+VukJ4TJ1AuwKYwh/FAUZkOu
	d2VkE3L6efwSZeP7seb1tl/LtiWXUvwFcZbhlZ30ZNqbBsgM9uU6aLMllsjnGgIM
	T9EzPYUuwME7eOESlyvVbgGRiOukCsU2hqTMm9H0vP82v7jtLezAWBDXlpSfmV+E
	nfq/qAAjbG3YNNF/qVI3jt1WucWTTZj0KwWEG2aqOHp7IC9GZcU2AMP6Ty8DCs0M
	xfZ9gQsLZCTqxZgfWz+x6X6xqGu1rKVIZoqXz/Lk8JTLfAdoavqEzS5i90HZR1Nn
	S1MvhvHgwloabmjWMVtCQ==
X-ME-Sender: <xms:C5dQZ7nPHPngcKCgjcOIGlze3pxEpCxcmEN_6qTZiurDHkFLW2vwTg>
    <xme:C5dQZ-3DZii5BE9w9ywrFCCKBWF_WGm005VRbBPH-dQPKHBwmRDNDYZonj5AWo-oo
    CYkJRqR5sDNwErKYrc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrieehgddutddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddt
    necuhfhrohhmpedftehrnhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrd
    guvgeqnecuggftrfgrthhtvghrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefg
    gfevudegudevledvkefhvdeinecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepudei
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegsphesrghlihgvnhekrdguvgdprh
    gtphhtthhopegtihhmihhnrghghhhisehgnhhuuggurdgtohhmpdhrtghpthhtohepshgv
    rghnjhgtsehgohhoghhlvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgrug
    gvrggurdhorhhgpdhrtghpthhtoheprghnugihsehkvghrnhgvlhdrohhrghdprhgtphht
    thhopegrrhhnugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepnhgrthhhrghnsehkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtphht
    thhopehtghhlgieslhhinhhuthhrohhnihigrdguvg
X-ME-Proxy: <xmx:C5dQZxqypKMmdn8z1HsclNAJM4CcNiDwc7OEXdDcOqQKq0tMt2nwXA>
    <xmx:C5dQZzmd_qVhgjr9Ob8Dm71rqAvaHIq9PxQ77iOxilwOLVT3LSiPCg>
    <xmx:C5dQZ53reQmHWGedkgfzDd-R-cN-eNSsSFbT3Me7oZEV35GdqV3Kmw>
    <xmx:C5dQZyv8Om79-lMZ_NMhYSMhgNhOIByp_JdbHndnWVSjUmuWEHxrAw>
    <xmx:C5dQZ43TGv3WJO3SImfzMCignN7m4hlUF9F9BOs4hlb4htKzHPkmFmCu>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 33EC22220072; Wed,  4 Dec 2024 12:53:15 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 04 Dec 2024 18:52:51 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Nathan Chancellor" <nathan@kernel.org>, "Arnd Bergmann" <arnd@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
 "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>,
 "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Andy Shevchenko" <andy@kernel.org>, "Matthew Wilcox" <willy@infradead.org>,
 "Sean Christopherson" <seanjc@google.com>,
 "Davide Ciminaghi" <ciminaghi@gnudd.com>,
 "Paolo Bonzini" <pbonzini@redhat.com>, kvm@vger.kernel.org
Message-Id: <4a5898f6-f159-4f3e-b352-3a72c23422a2@app.fastmail.com>
In-Reply-To: <20241204170935.GB3356373@thelio-3990X>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-10-arnd@kernel.org>
 <20241204170935.GB3356373@thelio-3990X>
Subject: Re: [PATCH 09/11] x86: rework CONFIG_GENERIC_CPU compiler flags
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, Dec 4, 2024, at 18:09, Nathan Chancellor wrote:
> Hi Arnd,
>
> On Wed, Dec 04, 2024 at 11:30:40AM +0100, Arnd Bergmann wrote:
> ...
>> +++ b/arch/x86/Kconfig.cpu
>> +config X86_64_V1
>> +config X86_64_V2
>> +config X86_64_V3
> ...
>> +++ b/arch/x86/Makefile
>> +        cflags-$(CONFIG_MX86_64_V1)	+= -march=x86-64
>> +        cflags-$(CONFIG_MX86_64_V2)	+= $(call cc-option,-march=x86-64-v2,-march=x86-64)
>> +        cflags-$(CONFIG_MX86_64_V3)	+= $(call cc-option,-march=x86-64-v3,-march=x86-64)
> ...
>> +        rustflags-$(CONFIG_MX86_64_V1)	+= -Ctarget-cpu=x86-64
>> +        rustflags-$(CONFIG_MX86_64_V2)	+= -Ctarget-cpu=x86-64-v2
>> +        rustflags-$(CONFIG_MX86_64_V3)	+= -Ctarget-cpu=x86-64-v3
>
> There appears to be an extra 'M' when using these CONFIGs in Makefile,
> so I don't think this works as is?

Fixed now by adding the 'M' in the Kconfig file, thanks for
noticing it.

      Arnd


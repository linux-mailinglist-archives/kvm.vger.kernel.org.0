Return-Path: <kvm+bounces-33051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E4B89E40AA
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 18:09:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 473DDB3D737
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 16:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D89120DD53;
	Wed,  4 Dec 2024 16:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="PtTIps+U";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Cg4o1o6p"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B08A20C49E;
	Wed,  4 Dec 2024 16:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331467; cv=none; b=QKSR+WMZ4SrHSdpGii6BVjwlBwBOdPehZBfPk2nQYOpFNf1gkVTJQjGUM5ln0EVesVL2TUdmHa5g01D+ZJ+z2ENh+FG6OvYI0142vwBB/HeFFFskL9PWciiTUO8+g95z76e1U3gRAuCnrdkhh5V3l6uw8QduqCXKSOtLNLpsb8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331467; c=relaxed/simple;
	bh=OmlM/m2R322eQUasLFsEn4qvfuYaHqlzq4wwyRr9AzI=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=GLGbWVPO8POuEdfxR0K7BqfeSkITO/0dmhZo3IWKIwyVAHd5RliBSRtGs6Kx7SZYFGaayXcr6b1hdg719P+c/1FLWtz3fk89PwmRemskOuYQDfrlCYuVDZfM7dphiXa0I6pjeA4pg7+08RKDeZX+02Z0j4nyMoPpZ9o90cOQRnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=PtTIps+U; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Cg4o1o6p; arc=none smtp.client-ip=202.12.124.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 149F2254015C;
	Wed,  4 Dec 2024 11:57:44 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Wed, 04 Dec 2024 11:57:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1733331463;
	 x=1733417863; bh=099pZMbdMufqaYvT8JVCnYw+P2j6nx8hhRn2+90AELo=; b=
	PtTIps+UCsVKotZdIq3Vb5EGjxJeDYVVjVhlxIezxJs3zIVVvlRTtDdabWriwYQe
	eeoDyuapPAKkG727iob/P17ovCjT7A2q3p6orJ42XYwcVXs0kfsf9Jw8uSXA90Zj
	+qKNM9J+yJkfL/dmA0Xl88haeCage6owUMr4cDspkLg9/Eqa5gmqS2805eiKYu+O
	xP+7v8xyrf7UnzeWGPPrOUwzIlWCoYleCFq9mIRzikc1D6bwiDsdGrw0zrgJGa62
	A7kgRZ9eYxi+zucqC9uJkLIkipOUzAbnHUE1znsu/OqrjeGzvn1TTQGJ0CKYhyFU
	3cdAmuS4fqZvwH4TCWIClA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1733331463; x=
	1733417863; bh=099pZMbdMufqaYvT8JVCnYw+P2j6nx8hhRn2+90AELo=; b=C
	g4o1o6ps+plM3rodX6KeK6XmYRHlBY2DCMpsyK3vrEm5ZFgRkk1YbfFI688X12zc
	2FNvy8KnCkG4l5ETITWOTWVclqj7h3GEDM3NcnsT5lumrwQxUHT7Nuv3esbi4W2o
	qtZJmRlV412PTLlqik97koc/SGRCp77w/XnpB1LgO7zGKQ/cwN8hnVPSa7dqMNAj
	6rpqwoJgHf4I7Rz5B8PqbJE0UbpeRwrNINHyBeRPMqbxZWt/Azj3gsSfO0nsYQxe
	M/F0y02R/o8ACFMzcA5w5EkGNphh8aO6f0kZGBCMqylq7PhoK9GJq8hilMFt9T3m
	fx1gizxjMy06Bvl9VLz6A==
X-ME-Sender: <xms:B4pQZwH2-bRyh0kTJoJ54SrnH8cROTX-zxWgUpK4H3f6jeaPp0e8Xw>
    <xme:B4pQZ5XAVJAQ3SMzm6rRYLFyzx5N2fkIxHIPoTOppK5Z3xamAqocwVL7pO9JtXSRw
    oeMglLmjSvm0vOaTT8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrieehgdeludcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdpuffr
    tefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnth
    hsucdlqddutddtmdenucfjughrpefoggffhffvvefkjghfufgtgfesthejredtredttden
    ucfhrhhomhepfdetrhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdrug
    gvqeenucggtffrrghtthgvrhhnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffg
    vedugeduveelvdekhfdvieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggvpdhnsggprhgtphhtthhopeduiedp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepsghpsegrlhhivghnkedruggvpdhrtg
    hpthhtohepsghrghgvrhhsthesghhmrghilhdrtghomhdprhgtphhtthhopegtihhmihhn
    rghghhhisehgnhhuuggurdgtohhmpdhrtghpthhtohepshgvrghnjhgtsehgohhoghhlvg
    drtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghp
    thhtoheprghnugihsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrrhhnugeskhgvrh
    hnvghlrdhorhhgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthht
    ohepthhglhigsehlihhnuhhtrhhonhhigidruggv
X-ME-Proxy: <xmx:B4pQZ6I12E9RJSFpcVQytVMbncj0V-KbCsfb7dsz02JNdy-C0ft5HA>
    <xmx:B4pQZyHOeXE0EX2jrxlI2nD7wShbc56CZNxhnMH7GbUnLG2k0ZzBlQ>
    <xmx:B4pQZ2UuvqA9Y8bsXygYD8tj_qd_DXi-IUrCgLv0iJA_oArBgZhbWw>
    <xmx:B4pQZ1MbqyrnFmduXoyASUkmsMglzX_TN-24d_GhcXT8W1CqzkzAQw>
    <xmx:B4pQZzV3aivK60IGJiR_L_0JCtqS6Qommh5vFOZIx8Z0kxNdBRSTqbL5>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 402742220072; Wed,  4 Dec 2024 11:57:43 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 04 Dec 2024 17:55:34 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>, "Brian Gerst" <brgerst@gmail.com>,
 "Arnd Bergmann" <arnd@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
 "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Andy Shevchenko" <andy@kernel.org>, "Matthew Wilcox" <willy@infradead.org>,
 "Sean Christopherson" <seanjc@google.com>,
 "Davide Ciminaghi" <ciminaghi@gnudd.com>,
 "Paolo Bonzini" <pbonzini@redhat.com>, kvm@vger.kernel.org
Message-Id: <13308b89-53d1-4977-970f-81b34f40f070@app.fastmail.com>
In-Reply-To: <A0F192E7-EFD2-4DD4-8E84-764BF7210C6A@zytor.com>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-6-arnd@kernel.org>
 <CAMzpN2joPcvg887tJLF_4SU4aJt+wTGy2M_xaExrozLS-mvXsw@mail.gmail.com>
 <A0F192E7-EFD2-4DD4-8E84-764BF7210C6A@zytor.com>
Subject: Re: [PATCH 05/11] x86: remove HIGHMEM64G support
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, Dec 4, 2024, at 17:37, H. Peter Anvin wrote:
> On December 4, 2024 5:29:17 AM PST, Brian Gerst <brgerst@gmail.com> wrote:
>>>
>>> Removing this also drops the need for PHYS_ADDR_T_64BIT and SWIOTLB.
>>> PAE mode is still required to get access to the 'NX' bit on Atom
>>> 'Pentium M' and 'Core Duo' CPUs.
>
> By the way, there are 64-bit machines which require swiotlb.

What I meant to write here was that CONFIG_X86_PAE no longer
needs to select PHYS_ADDR_T_64BIT and SWIOTLB. I ended up
splitting that change out to patch 06/11 with a better explanation,
so the sentence above is just wrong now and I've removed it
in my local copy now.

Obviously 64-bit kernels still generally need swiotlb.

       Arnd


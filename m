Return-Path: <kvm+bounces-33047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 64F8F9E4077
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 18:04:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 620A0B3190D
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 16:34:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1062C20CCC7;
	Wed,  4 Dec 2024 16:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="Bgz/rgP/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="i3QZhTqh"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9955C1547C3;
	Wed,  4 Dec 2024 16:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733330062; cv=none; b=dOCgEp4FiTsiEajGNqN4gaOvujcO36PJXWET8Y8Q9/vgdtvVKTief9Hfh27NblUXh9umza7u6Bfn3DO0TBABXNMwdKPQrw4w7Ltff2KQbDb2WpJEg2i5IcX3oftJKvV0qBkccEV4V0UMzP1W32F3Wy32Pdc/+njRXyy6wTUHS6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733330062; c=relaxed/simple;
	bh=x78ACWAOEZm++OCDsqG7/c0mVwye3P8tzwVfBS2KS84=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=RpTjS67rY0FZGg3yxOTortPjr+5xQ3sPGUYNfP+efvGLbX1op6ZssskoNXJv6A/F3/fcEpbePZJe1xicSUJiTnrOOq8mcVSg+6BfJcLg/P4+YhoZx8bOr5CuUxsU97LII4iJrcF6fpbIYjf71W80KM02kmH9Pvqyrkv6yMDrxSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=Bgz/rgP/; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=i3QZhTqh; arc=none smtp.client-ip=202.12.124.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfout.stl.internal (Postfix) with ESMTP id 4B62811401D5;
	Wed,  4 Dec 2024 11:34:18 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Wed, 04 Dec 2024 11:34:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1733330058;
	 x=1733416458; bh=Ah70jlP4CTaxYAWVJ4RDilPcmjlaIxhGSKcMYOP92jw=; b=
	Bgz/rgP/rbciUaPGqY2T3BoA6Hn2zEV/kByiE1kyZQG+kfS/TkxHGrVjWOlfxDYe
	8ZH9j2sz2cZ9F2yFj4Of2USSJIFYFI6uDLo7a5j6pqOp3zw1y77xCG9o+s5CouU0
	NYt4X+V92Zmk1CIlQ8OOSiuA/cGNrJlRw9+tLMELy++7d7CuGE3nXUfSbx5CjpSC
	cBylWUXFob1xjRec19aW292Kpq6vsRMo+qPZjm64Hah7zdxM7Nf/HQj9PQ8lwfS8
	BKZyLL8UVf/OYQT9vLXu+EUxyiJ4enKDTkDxWN7OnJSeXaeDxJ0xzlu4muvc3U9t
	NiGSUq166HdOcv5YrGIpWg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1733330058; x=
	1733416458; bh=Ah70jlP4CTaxYAWVJ4RDilPcmjlaIxhGSKcMYOP92jw=; b=i
	3QZhTqhBZKJAh64ysePHTOf5V9j0ogPScaaqrkuI/8qEz0S4w9N63NXsrN+bonbS
	AFxzlYlj10Nn8vT4NRUQUCOzgK81UwvV6a+ceHmTu6TB14eGtUdYJQM+ZNnEH/Zp
	yIATyZITF9MNZQF64PZK8kIFrq4OeEfa8MkRDqi5ykZlDNXK5yucS/czq2o1ARCv
	DOqjPaVQz0gX0cf+BE/uEWO+kZOyGMzHqB+reItDcdnh1teFuJ3Eq2Epqtx8xbVu
	lO7K9H6cJAb4HMZJBiIyTzyXiCMO1jUTmEoPy0FZeUXoMpaIPUvYxDJC2ZALPx9g
	R01wmE0Do74tWgIsLyRcA==
X-ME-Sender: <xms:iYRQZ5P4VkR9mZXjSbymRRoy_dVJGGGO2fgNixTyN1iz5o8b1eRt7Q>
    <xme:iYRQZ78E1iUGLfxfK2V_YNHcB4b8fnvBbhJctOqcnHBkJvbaaKdK9DYZV5G3AuDvV
    ePwdBmGq2WHT8TH6ew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrieehgdekiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdpuffr
    tefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnth
    hsucdlqddutddtmdenucfjughrpefoggffhffvvefkjghfufgtgfesthejredtredttden
    ucfhrhhomhepfdetrhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdrug
    gvqeenucggtffrrghtthgvrhhnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffg
    vedugeduveelvdekhfdvieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggvpdhnsggprhgtphhtthhopeduhedp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepsghpsegrlhhivghnkedruggvpdhrtg
    hpthhtoheptghimhhinhgrghhhihesghhnuhguugdrtghomhdprhgtphhtthhopehsvggr
    nhhjtgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvg
    grugdrohhrghdprhgtphhtthhopegrnhguhieskhgvrhhnvghlrdhorhhgpdhrtghpthht
    oheprghrnhgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehtghhlgieslhhinhhuthhrohhnihigrdguvgdprhgtphht
    thhopehtohhrvhgrlhgusheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhg
X-ME-Proxy: <xmx:iYRQZ4T3112cRzwmCs5KIhZTO7PC40uLVK1f5fb7qcRgieEPEFSXJg>
    <xmx:iYRQZ1tn6Oe_zSU_P3NsbgNWOppvawQfIK1GXrcVLkiEIBvpl84eLw>
    <xmx:iYRQZxeI9_hIN2rr4QXf81ZGygsLT6b28nbbmcqx4dYpgXXdY4YgXQ>
    <xmx:iYRQZx04xE3iirr5QntJttrlCLCtfFrE_z9P1c0P4DvPS10Yw7vZGQ>
    <xmx:ioRQZ82OD2mhqILmQZxp7mH4r5lmE-yzLCstRa81WHTlxPCYuR9p44RM>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 68E422220072; Wed,  4 Dec 2024 11:34:17 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 04 Dec 2024 17:33:57 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Sean Christopherson" <seanjc@google.com>,
 "Arnd Bergmann" <arnd@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
 "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>,
 "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Andy Shevchenko" <andy@kernel.org>, "Matthew Wilcox" <willy@infradead.org>,
 "Davide Ciminaghi" <ciminaghi@gnudd.com>,
 "Paolo Bonzini" <pbonzini@redhat.com>, kvm@vger.kernel.org
Message-Id: <bb9d86e4-4641-4b1b-af9e-7d468dc2e2ee@app.fastmail.com>
In-Reply-To: <Z1B1phcpbiYWLgCD@google.com>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-12-arnd@kernel.org> <Z1B1phcpbiYWLgCD@google.com>
Subject: Re: [PATCH 11/11] x86: drop 32-bit KVM host support
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, Dec 4, 2024, at 16:30, Sean Christopherson wrote:
> On Wed, Dec 04, 2024, Arnd Bergmann wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>> 
>> There are very few 32-bit machines that support KVM, the main exceptions
>> are the "Yonah" Generation Xeon-LV and Core Duo from 2006 and the Atom
>> Z5xx "Silverthorne" from 2008 that were all release just before their
>> 64-bit counterparts.
>> 
>> Using KVM as a host on a 64-bit CPU using a 32-bit kernel generally
>> works fine, but is rather pointless since 64-bit kernels are much better
>> supported and deal better with the memory requirements of VM guests.
>> 
>> Drop all the 32-bit-only portions and the "#ifdef CONFIG_X86_64" checks
>> of the x86 KVM code and add a Kconfig dependency to only allow building
>> this on 64-bit kernels.
>
> While 32-bit KVM doesn't need to be a thing for x86 usage, Paolo 
> expressed concerns
> that dropping 32-bit support on x86 would cause general 32-bit KVM 
> support to
> bitrot horribly.  32-bit x86 doesn't get much testing, but I do at 
> least boot VMs
> with it on a semi-regular basis.  I don't think we can say the same for 
> other
> architectures with 32-bit variants.

I see.

> PPC apparently still has 32-bit users[1][2],

I looked at the links but only see 64-bit users there.

There is KVM support for 32-bit BookE (e500v2, e500mc)
in the PPC85xx and QorIQ P1/P2/P3/P4, and Crystal mentioned
that there might be users, but did not point to anyone
in particular.

The A-EON AmigaOne X5000 and Powerboard Tyche that were
mentioned in the thread as being actively used are both
64-bit QorIQ P5/T2 (e5500, e6500) based. These are the
same platform ("85xx" in Linux, "e500" in qemu), so it's
easy to confuse. We can probably ask again if anyone
cares about removing the 32-bit side of this.

> and 32-bit RISC-V is a thing,

There are many 32-bit RISC-V chips, but all RISC-V
SoCs supported by Linux today are in fact 64-bit.

While there is still talk of adding support for 32-bit
SoCs, the only usecase for those is really to allow
machines with smaller amounts of physical RAM, which
tends to rule out virtualization.

There is one more platform that supports virtualization
on 32-bit CPUs, which is the MIPS P5600 core in the
Baikal T1.

I still think it makes sense to just drop KVM support
for all 32-bit hosts, but I agree that it also
makes sense to keep x86-32 as the last one of those
for testing purposes.

    Arnd


Return-Path: <kvm+bounces-33711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B90549F07C0
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 10:23:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B748282232
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 09:23:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 341A31B21B8;
	Fri, 13 Dec 2024 09:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="jPrxzkDW";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="O3J2GfBs"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBF51B21A2;
	Fri, 13 Dec 2024 09:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081776; cv=none; b=skcpJEK6AHsKiDaVmJ4r4oXFbAuzR/UoADLgmS4GC7bygkUwwo5TAbbt8pUN94o7KOEoOLqs/TrxQxglJimhWgxpwIhETOU5qnUzceM6Fi8wRA0XacuNAjegeAogH+W2p4qCRbVAsQWWHF00aL8rTPyfpSoPxPhX4kqnzijqVIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081776; c=relaxed/simple;
	bh=l7QiCILD+TyAYh5PJNEJ39zLrVWBIrPnLOAuB2a5WaQ=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=ByMb+bcFnv+fBw3sju0ocxvSwGS+kOgCAA1npeT+dCbI5cFNdN3VPnz/HoC63+beOGL7f3/+Ftv3ppOyYYapz+bGmLOXYKvEo8wjzPtgy1r9tLNvf2AMwn+eFqONwOjJThw+QIiw1iG9MoI6gR/Tf+OV1XxKKbJx4uj8UPurjwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=jPrxzkDW; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=O3J2GfBs; arc=none smtp.client-ip=202.12.124.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfhigh.stl.internal (Postfix) with ESMTP id B0E6725401EB;
	Fri, 13 Dec 2024 04:22:51 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Fri, 13 Dec 2024 04:22:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1734081771;
	 x=1734168171; bh=Suh2qqmp5LswXS6UM/NIeYadyUDj4ZrAq9xKXIGb2h0=; b=
	jPrxzkDWUl3aZHiWpcBoRvsXR2+XkpZRfhXJtHWInIubTyhL2qirmziXdiwbVByj
	37KmlWdS8nGgBphp0T19RTCsNtRKK+hLRhyZpXD7xqz8q0ZX+2Gv8ZcdCio9/P7d
	9RZJ2DxPVvlO1ktsiRfJwaosVD01tZtpnb7T+F/dLIz4Mh0ngwfJbQMc5kJ+rov2
	+fijSthBoEwYko7qCCSeafPMNm0jQGZ+XNG43SKu+JiZf+aGCDLGCf5CbN8kC8ti
	oyzNPKT0z1S0OvW8KSruiJtj6cTUH9YgN/5cQYmiDs1wyaWOMtpcUTQ6INLHCRI9
	aLXdn8s6LFtONQ3O9taeJQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1734081771; x=
	1734168171; bh=Suh2qqmp5LswXS6UM/NIeYadyUDj4ZrAq9xKXIGb2h0=; b=O
	3J2GfBsFQXPk/CS3lrNw/2c+Fh6DQZ3psgwQDwf/B/6wK2En1fq1Aypf7BDPFEHb
	L022F8LfZsLo02faH1m7Gj5aWDvJHLoUHsnWn8CItk8UKD9ERyN7XZZMWJv/24CL
	ig86MxOlBgbJYB+LK4bYnv6lXm61XPjezwZfsyTZBcBLduSsRnT74mpaACIxkebW
	QebqzGVTbgK0hZ8Uio+sjmBkdo4uwS9Oa+bcXI9uzKBoz357j0a1iDtn48i07eEU
	mmPj9VOStcKN635SJp6XTHbbGJrT42uKf0AqZcD5LpbeIQgnJ9Q3ra/F4rr9Tb44
	jKlXoc5F7QIb04fEYoAUw==
X-ME-Sender: <xms:6fxbZ8cbkF26afbP7Uw1hkf_H38Fh11oDM-yNJGa6d0PcE2ArF0-Tw>
    <xme:6fxbZ-O5usQ-e87TBG52kyiqtKuQOV6HTMo0BYy4yBr2y4eW1DK8kXdMrV6K9g3wa
    rpdrNvH7EgiYcQngqI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrkeejgddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdpuffr
    tefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnth
    hsucdlqddutddtmdenucfjughrpefoggffhffvvefkjghfufgtgfesthejredtredttden
    ucfhrhhomhepfdetrhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdrug
    gvqeenucggtffrrghtthgvrhhnpeefhfehteffuddvgfeigefhjeetvdekteekjeefkeek
    leffjeetvedvgefhhfeihfenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhn
    uggsrdguvgdpnhgspghrtghpthhtohepfeegpdhmohguvgepshhmthhpohhuthdprhgtph
    htthhopegsphesrghlihgvnhekrdguvgdprhgtphhtthhopehtshgsohhgvghnugesrghl
    phhhrgdrfhhrrghnkhgvnhdruggvpdhrtghpthhtohepghhrrghfsegrmhgriihonhdrtg
    homhdprhgtphhtthhopegrthhishhhphesrghtihhshhhprghtrhgrrdhorhhgpdhrtghp
    thhtoheprghnuhhpsegsrhgrihhnfhgruhhlthdrohhrghdprhgtphhtthhopegthhhrih
    hsthhophhhvgdrlhgvrhhohiestghsghhrohhuphdrvghupdhrtghpthhtohepphgrlhhm
    vghrsegurggssggvlhhtrdgtohhmpdhrtghpthhtoheprghouhesvggvtghsrdgsvghrkh
    gvlhgvhidrvgguuhdprhgtphhtthhopehmphgvsegvlhhlvghrmhgrnhdrihgurdgruh
X-ME-Proxy: <xmx:6fxbZ9hvJ7VrNnQc078U1u83tWUpKSRToRJoa8j-EOWOmJfPtIbcnA>
    <xmx:6fxbZx8bSkAmb-X4rWVJqWoRGnxz-5_y3hCww268KffI1R17L9Mb6Q>
    <xmx:6fxbZ4sqwxKhX4PHX9kgWYlvL_4XeISMqU7mNTF8B1AzNh3AKyQ-3A>
    <xmx:6fxbZ4GbXJg1A10AnazbJxGKFkFv5d7UYbc2TlD2bXO5QedEV7dWYw>
    <xmx:6_xbZ-OU0S3qhPukGD5bhxG0C27mOZ_-l47vOln1qMhT5Yf7FS27cFB3>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 02ED32220072; Fri, 13 Dec 2024 04:22:48 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 13 Dec 2024 10:22:28 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Paolo Bonzini" <pbonzini@redhat.com>, "Arnd Bergmann" <arnd@kernel.org>,
 kvm@vger.kernel.org
Cc: "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>,
 "Huacai Chen" <chenhuacai@kernel.org>,
 "Jiaxun Yang" <jiaxun.yang@flygoat.com>,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Nicholas Piggin" <npiggin@gmail.com>,
 "Christophe Leroy" <christophe.leroy@csgroup.eu>,
 "Naveen N Rao" <naveen@kernel.org>,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Alexander Graf" <graf@amazon.com>, "Crystal Wood" <crwood@redhat.com>,
 "Anup Patel" <anup@brainfault.org>,
 "Atish Patra" <atishp@atishpatra.org>,
 "Paul Walmsley" <paul.walmsley@sifive.com>,
 "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Albert Ou" <aou@eecs.berkeley.edu>,
 "Sean Christopherson" <seanjc@google.com>,
 "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>,
 "Vitaly Kuznetsov" <vkuznets@redhat.com>,
 "David Woodhouse" <dwmw2@infradead.org>, "Paul Durrant" <paul@xen.org>,
 "Marc Zyngier" <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Message-Id: <062f7269-580e-4008-904a-919ca0bda482@app.fastmail.com>
In-Reply-To: <6bc05f3c-f473-480d-b9a2-c8cd3c80a66c@redhat.com>
References: <20241212125516.467123-1-arnd@kernel.org>
 <20241212125516.467123-6-arnd@kernel.org>
 <6bc05f3c-f473-480d-b9a2-c8cd3c80a66c@redhat.com>
Subject: Re: [RFC 5/5] x86: kvm drop 32-bit host support
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

>n Thu, Dec 12, 2024, at 17:27, Paolo Bonzini wrote:
> On 12/12/24 13:55, Arnd Bergmann wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>> 
>> There are very few 32-bit machines that support KVM, the main exceptions
>> are the "Yonah" Generation Xeon-LV and Core Duo from 2006 and the Atom
>> Z5xx "Silverthorne" from 2008 that were all released just before their
>> 64-bit counterparts.
>
> Unlike other architectures where you can't run a "short bitness" kernel 
> at all, or 32-bit systems require hardware enablement that simply does 
> not exist, the x86 situation is a bit different: 32-bit KVM would not be 
> used on 32-bit processors, but on 64-bit kernels running 32-bit kernels; 
> presumably on a machine with 4 or 8 GB of memory, above which you're 
> hurting yourself even more, and for smaller guests where the limitations 
> in userspace address space size don't matter.
>
> Apart from a bunch of CONFIG_X86_64 conditionals, the main issue that 
> KVM has with 32-bit x86 is that they cannot read/write a PTE atomically 
> (i.e. without tearing) and therefore they can't use the newer and more 
> scalable page table management code.  So no objections from me for 
> removing this support, but the justification should be the truth, i.e. 
> developers don't care enough.

Right, I should have updated the description based on the comments
for the first version, especially after separating it from the patches
that make it harder to run 32-bit kernels on 64-bit hardware.

I've updated the changelog now to

    x86: kvm drop 32-bit host support
    
    There are very few 32-bit machines that support KVM, the main exceptions
    are the "Yonah" Generation Xeon-LV and Core Duo from 2006 and the Atom
    Z5xx "Silverthorne" from 2008 that were all released just before their
    64-bit counterparts.
    
    The main usecase for KVM in x86-32 kernels these days is to verify
    that 32-bit KVM is still working, by running it on 64-bit hardware.
    With KVM support on other 32-bit architectures going away, and x86-32
    kernels on 64-bit hardware becoming more limited in available RAM,
    this usecase becomes much less interesting.
    
    Remove this support to make KVM exclusive to 64-bit hosts on all
    architectures, and stop testing 32-bit host mode.
    
    Link: https://lore.kernel.org/all/Z1B1phcpbiYWLgCD@google.com/
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

which assumes that we end up going ahead with the powerpc
patches. Does that work for you?

      Arnd


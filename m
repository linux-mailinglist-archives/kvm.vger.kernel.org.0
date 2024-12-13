Return-Path: <kvm+bounces-33712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1FDD9F07C6
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 10:24:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6991D280A76
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 09:24:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDE291B2184;
	Fri, 13 Dec 2024 09:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="s4TV2CZc";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="gWU5S28d"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153BE130A54;
	Fri, 13 Dec 2024 09:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081832; cv=none; b=IzBvhLbgxcyh4fkVNlHDBMyEahdf/rFXxGrfzeMMmQsipI7nb29fIyVw6rzdSs6di98Joc3R9e1dslLNoI4kfhX65T0aPpOMPeWouEdhSKnMqCj+cavVnPR5wawvHzUCKxKXIiZpUwYQy2Q+eTq44GW/unbxvHart5lc89E3zYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081832; c=relaxed/simple;
	bh=4PaASCo7z4x/EIgb8J8NrVl6PtkEqzSS7UlBm6s0hUo=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=sWOSVKvgN6VEnHdsmSMbBCCPITtPl+9nx4ggfJxxK280tNeDILveb0IVNmruYly6h1SAdEm61nfWf/qOWOZEsqSQJgLjTS8WKX7qU70qdy3aLL3uYhOXdOjuaupSXdUWc7tQBvOEQ0Gy2PN7vHqvlwPAM+jZhQrfmsoNatxS4KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=s4TV2CZc; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=gWU5S28d; arc=none smtp.client-ip=202.12.124.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 54AC925401E6;
	Fri, 13 Dec 2024 04:23:48 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Fri, 13 Dec 2024 04:23:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1734081828;
	 x=1734168228; bh=n3jJEXDlikai5BIZE32F7/anjx2vQjCMi91W2c/0OIU=; b=
	s4TV2CZcFzkScS6acPGBCbdFq7V/Dy9RHjeZpO9D08kgTWi83d99z4rSFRDlfItn
	79LEae3O/sswqtGNjOgw6p7A2uwEeu0rfXX0KGnM24oGxe10TsYGKNa9gjwrHH1M
	77z/q7KtVruOe0OdOi5TRWS78SiFNa+SiVNFQ+rpodntJZ3b8xuSM3Xs5Z+TlZPj
	jYk2eN1Px/XuwrJJme56jgHrfrvdu83wF+LObLjV/zkYuwMf0uA5hR0Zcu2ry91Q
	Ry+Uz0q570BdWx1QqFQRL9PRUaVrmXH8DYuhm9SCjYYBS5lrtdgQP9GSk2sX+/SO
	z2MPOgw3vU3Pc2EnX/A7kQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1734081828; x=
	1734168228; bh=n3jJEXDlikai5BIZE32F7/anjx2vQjCMi91W2c/0OIU=; b=g
	WU5S28dBtpaWIxa/WfM5+DNCtPcxjWDKZ5b2kRMCICSJF1Jbck+yyL1ak4Ck+oF0
	nox2Q2CbaqUmj7XEf9+21T4ImwGeKoHVi5AE+xHWohHrRQcDoHgKvZ4Yr4kY6gni
	YZIOiSrcIdaQcI0AhGo/p4lWcpMTXzfQ5zLFgCQXQPUT1krKF2v2ZDBcSySmQnjw
	BJqoRz6HxfoszAxXbUwIJzPE5lcC5KeaE/0Fici6VhdoTdJ/8znEVN09XLsFhFrI
	al6U/3+bf4zSqkaual62alMbdvj4QXQ12jAo9/gjiXpO0Ig4vhKGaXWuY4LUKeOi
	9cB+GvrtMyfHT96cMjZ9Q==
X-ME-Sender: <xms:I_1bZ3bSMslrR4QcwZjgzRBZ5UKLplvFQPQjA0HoCnQRTVB04lTnEA>
    <xme:I_1bZ2a8d_Q2fZ0Na0kNwzMS2ZkTU1yxsCa3UliYufnRsy7JexVQuLspvw1Yp0hIM
    JzKyNy6s59A2VINbsY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrkeejgddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdpuffr
    tefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnth
    hsucdlqddutddtmdenucfjughrpefoggffhffvvefkjghfufgtgfesthejredtredttden
    ucfhrhhomhepfdetrhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdrug
    gvqeenucggtffrrghtthgvrhhnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffg
    vedugeduveelvdekhfdvieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggvpdhnsggprhgtphhtthhopeefhedp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepsghpsegrlhhivghnkedruggvpdhrtg
    hpthhtohepthhssghoghgvnhgusegrlhhphhgrrdhfrhgrnhhkvghnrdguvgdprhgtphht
    thhopehgrhgrfhesrghmrgiiohhnrdgtohhmpdhrtghpthhtoheprghtihhshhhpsegrth
    hishhhphgrthhrrgdrohhrghdprhgtphhtthhopegrnhhuphessghrrghinhhfrghulhht
    rdhorhhgpdhrtghpthhtoheptghhrhhishhtohhphhgvrdhlvghrohihsegtshhgrhhouh
    hprdgvuhdprhgtphhtthhopehprghlmhgvrhesuggrsggsvghlthdrtghomhdprhgtphht
    thhopegrohhusegvvggtshdrsggvrhhkvghlvgihrdgvughupdhrtghpthhtohepmhhpvg
    esvghllhgvrhhmrghnrdhiugdrrghu
X-ME-Proxy: <xmx:I_1bZ58zp8MDxlCvv9u8Ry7AWm65nv4xnbOyH4IiLbt8eU9JURJk6A>
    <xmx:I_1bZ9pACUTZW8WwPhf4QcxSOuYSxTAQPur06CGzF5qEKPbeOcByjA>
    <xmx:I_1bZyo9cFmEKSDlhBCOYIixy__LIbIAUQqjIMpbNVa2B_j7nEn0sg>
    <xmx:I_1bZzRjXDv_56jhWmo6jXwpR2ylFASCuDSuCjtAjXh0sDj2yp1RYQ>
    <xmx:JP1bZ_ItKkj-d1aQhFXJA5zdxncKJIEWh0breQRKQ_juZTDHL4INUEmF>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id CDDBA2220072; Fri, 13 Dec 2024 04:23:47 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 13 Dec 2024 10:23:27 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Andreas Schwab" <schwab@suse.de>, "Arnd Bergmann" <arnd@kernel.org>
Cc: kvm@vger.kernel.org, "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>,
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
 "Paolo Bonzini" <pbonzini@redhat.com>,
 "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>,
 "Vitaly Kuznetsov" <vkuznets@redhat.com>,
 "David Woodhouse" <dwmw2@infradead.org>, "Paul Durrant" <paul@xen.org>,
 "Marc Zyngier" <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Message-Id: <e67c5757-26be-4fa6-932e-c7e51858081b@app.fastmail.com>
In-Reply-To: <mvm4j39ghrj.fsf@suse.de>
References: <20241212125516.467123-1-arnd@kernel.org>
 <20241212125516.467123-2-arnd@kernel.org> <mvm4j39ghrj.fsf@suse.de>
Subject: Re: [RFC 1/5] mips: kvm: drop support for 32-bit hosts
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, Dec 12, 2024, at 14:20, Andreas Schwab wrote:
> On Dez 12 2024, Arnd Bergmann wrote:
>
>> KVM support on MIPS was added in 2012 with both 32-bit and 32-bit mode
>
> s/32-bit/64-bit/ (once)
>

Fixed now, thanks,

     Arnd


Return-Path: <kvm+bounces-33721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B09259F09BD
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 11:39:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BC37165AC0
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 10:39:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BE5A1C07F1;
	Fri, 13 Dec 2024 10:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="svmWQJ3j";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="YuknyNOf"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35E01BB6B8;
	Fri, 13 Dec 2024 10:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734086367; cv=none; b=Q9eTdT7COK7EglaTZSOGejI2Sqj4wJZkhf2q050GWGj4USbjvjv1doN3CSGJujHQAXzvvtzQ8BvSZ4z+j6fdf/hsfjWV4Icjrkwz9XRhAH0SyZj3O9BpsWkcrAxSwsQ+ZGYKiXOs4GJDOSB0VQrFyS1ldSCUT16TFUDdCtP6Jhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734086367; c=relaxed/simple;
	bh=5vPztbLErzreqdxj+hb/w2bNCy20P+PmpA7UICbvqVM=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=InMx8oHfCTMkREjC6gavh7EzHsjNdUqWTUaq0RLayCWBwqR3bGLk8PQMo+H95MNXFhPRs/Rq3oJNuGPlu+dnGgkThadWzYXEAHusXuQHE3AOKY8BnhcM95Re/XCD1ED1yBUsgchbzA7aLL6wSX+A8EY/XcWYHVxP1Tkbj17pbmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=svmWQJ3j; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=YuknyNOf; arc=none smtp.client-ip=202.12.124.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfout.stl.internal (Postfix) with ESMTP id 22A071140122;
	Fri, 13 Dec 2024 05:39:23 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Fri, 13 Dec 2024 05:39:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1734086362;
	 x=1734172762; bh=Wpmvv7rOIASgAsPA9YY0CjRAOWqGE5dKTI6oeaAjQsA=; b=
	svmWQJ3jUDwyTjtvXgDTfNmPiFm/sT6IfG+8CWL+e1E0AInZhl8p5UKax+wMo35f
	myLPtmB+5yYfSbfyj/qCO006nYOR+kuinLYz6+aoskK3zRfSb85JV0l3V96uAnET
	pUL5M8Qr0xxtZp9+220BHt5P+bvvJjUXpvVzk0kyMdohGdFBKcYoj1yFTAghWPC1
	ESCWm4oC8k7SSnHv/cpM350JLvJEcywzFGM4V3iJTjoFf46WHGRY9e29q7MHCYXX
	f2+l7EHyVfT5KDk9XUHcLA9TdOR+02PGMrSoAqoLlANb3hfm6iQIuIvl1tWOebbn
	OAVZtM7/kB57Am1sK824eA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1734086362; x=
	1734172762; bh=Wpmvv7rOIASgAsPA9YY0CjRAOWqGE5dKTI6oeaAjQsA=; b=Y
	uknyNOfW5x3i4eadPgo0/13SZlOVNBORH13Qea0h68nPo6kac9sVqMg0ipDBnEK+
	MFQITm+eCAlqVHbKJPcqrHEmpfLdUo7pQdjyvwFcpooo7Rvdg+oyJtD9fMZcCin4
	8q1nD8oBrdb4/gMQ/VXQONjCpAv9VJ9bbuyA74xt/rLuyEFP5MzOTsJukoPFb6+u
	wn9PcMaCe5SPCviK6l721qmzQvUGBRMTzD5EWRHZtKNpC87Cgdc2426/OXc2dC77
	3k+RgWkuaG6uj1CG5T4sWtSseDZQxYpf3m575iLl7aUHqNlvl3YyKkUHXTu5dFIK
	NjexF9Xq3oNico1L01Eig==
X-ME-Sender: <xms:2Q5cZ4IbLlfncl3aMEXOK6HmHI6nOUC12FcfLP7-OJjTC4cLykmlVg>
    <xme:2Q5cZ4KeJuscIBl3EXG99ecoSIJTTJYgTogDH5OBBqKxEEtFsgFJyxH5T-Jr7NyC4
    vJxk7jfSfY_Bnb9JO0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrkeejgddukecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdpuffr
    tefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnth
    hsucdlqddutddtmdenucfjughrpefoggffhffvvefkjghfufgtgfesthhqredtredtjeen
    ucfhrhhomhepfdetrhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdrug
    gvqeenucggtffrrghtthgvrhhnpedvhfdvkeeuudevfffftefgvdevfedvleehvddvgeej
    vdefhedtgeegveehfeeljeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggvpdhnsggprhgtphhtthhopeefgedp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepsghpsegrlhhivghnkedruggvpdhrtg
    hpthhtohepthhssghoghgvnhgusegrlhhphhgrrdhfrhgrnhhkvghnrdguvgdprhgtphht
    thhopehgrhgrfhesrghmrgiiohhnrdgtohhmpdhrtghpthhtoheprghtihhshhhpsegrth
    hishhhphgrthhrrgdrohhrghdprhgtphhtthhopegrnhhuphessghrrghinhhfrghulhht
    rdhorhhgpdhrtghpthhtoheptghhrhhishhtohhphhgvrdhlvghrohihsegtshhgrhhouh
    hprdgvuhdprhgtphhtthhopehprghlmhgvrhesuggrsggsvghlthdrtghomhdprhgtphht
    thhopegrohhusegvvggtshdrsggvrhhkvghlvgihrdgvughupdhrtghpthhtohepmhhpvg
    esvghllhgvrhhmrghnrdhiugdrrghu
X-ME-Proxy: <xmx:2Q5cZ4uhEqVwIWmlKABp7YxiWheuNKHklS06rgYgOG5WSbWzSRIdpQ>
    <xmx:2Q5cZ1YWGcG-BZPfYCyspFMyqrkAxbBQc5OhRUdLbZAkQnYR1BMsCw>
    <xmx:2Q5cZ_aKSykWyn1pThE9bHU1SqW6iK2dJnoNTxOIw5XrXs1C4jtuDQ>
    <xmx:2Q5cZxDLsWPmWnp45hCYSbYnVQtJ8mnJdnHhHdy6giGcNrT_ZE5f6Q>
    <xmx:2g5cZ3p36DdJF2lZIuxBVJ6f0_C5j-FvB7wonKJ7qVVUxqJ-OQlXJnSV>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id A9A6A2220072; Fri, 13 Dec 2024 05:39:21 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 13 Dec 2024 11:39:00 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Christophe Leroy" <christophe.leroy@csgroup.eu>,
 "Arnd Bergmann" <arnd@kernel.org>, kvm@vger.kernel.org
Cc: "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>,
 "Huacai Chen" <chenhuacai@kernel.org>,
 "Jiaxun Yang" <jiaxun.yang@flygoat.com>,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Nicholas Piggin" <npiggin@gmail.com>,
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
Message-Id: <e5b03a9f-332f-4a13-84c6-6b739cd5aa25@app.fastmail.com>
In-Reply-To: <3a2fadc3-f594-492f-805a-148043436995@csgroup.eu>
References: <20241212125516.467123-1-arnd@kernel.org>
 <20241212125516.467123-4-arnd@kernel.org>
 <2809dcce-3405-430e-b43d-d75f35bdb7d5@csgroup.eu>
 <3380464f-5db4-487d-936f-1b5503905793@app.fastmail.com>
 <3a2fadc3-f594-492f-805a-148043436995@csgroup.eu>
Subject: Re: [RFC 3/5] powerpc: kvm: drop 32-bit book3s
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 13, 2024, at 11:27, Christophe Leroy wrote:
> Le 13/12/2024 =C3=A0 11:04, Arnd Bergmann a =C3=A9crit=C2=A0:
>> diff --git a/arch/powerpc/kernel/head_32.h b/arch/powerpc/kernel/head=
_32.h
>> index 9cba7dbf58dd..24e89dadc74d 100644
>> --- a/arch/powerpc/kernel/head_32.h
>> +++ b/arch/powerpc/kernel/head_32.h
>> @@ -172,7 +172,6 @@ _ASM_NOKPROBE_SYMBOL(\name\()_virt)
>>   #define	START_EXCEPTION(n, label)		\
>>   	__HEAD;					\
>>   	. =3D n;					\
>> -	DO_KVM n;				\
>>   label:
>>  =20
>>   #else
>
> Then the complete macro should go away because both versions are now=20
> identical:
>
> -#ifdef CONFIG_PPC_BOOK3S
> -#define	START_EXCEPTION(n, label)		\
> -	__HEAD;					\
> -	. =3D n;					\
> -label:
> -
> -#else
>   #define	START_EXCEPTION(n, label)		\
>   	__HEAD;					\
>   	. =3D n;					\
>   label:
>

Thanks, I've folded that change into my patch now.

      Arnd


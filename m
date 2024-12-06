Return-Path: <kvm+bounces-33211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F7129E7005
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 15:27:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 019252859B8
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 14:27:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB2FE207E13;
	Fri,  6 Dec 2024 14:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="K8vAVQb6";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="xeTdk0YH"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77EC2066F0;
	Fri,  6 Dec 2024 14:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733495257; cv=none; b=ZwL8yZiWKdeRmmGN06xRI+sAvUkgf+O8icDXmLtqa6wCDZ2hdBwE7QfsSjJ8ZVJFb56WnTbZ/AH2Tn3nBBXlzIojUdpRDPZeDhdekQ2UDrKYtzsZdx6yGiIINLppfhXyllmKfjJ0bLmaubNLAU1C5/+Vz2DB4TDshNk50GHUzmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733495257; c=relaxed/simple;
	bh=ZUPzAflAexf/FLq9z28Frf2UEeyNEXgAXnT0PsKcJHA=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=FzAooRWXga62vsxRaoQFILQd93uRTZiV2izCxoXZVUcS4QRifc7MQ0vEOF35euFl1dgTvCM2H2/lhffyuLHUw/8IS5DrLr8V7qgaY9z4S2PyOnXGWAKEsx3Xvczzmexg20029croNYW32O3aHLXMpyn5uBh2oncPmUT/Po8hqY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=K8vAVQb6; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=xeTdk0YH; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id C000A11400B9;
	Fri,  6 Dec 2024 09:27:33 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Fri, 06 Dec 2024 09:27:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1733495253;
	 x=1733581653; bh=B76KV/vkki8TJGBgK74Hn6eB0a40IRXA/S3nHIzx62Y=; b=
	K8vAVQb624SPtIqkZotuFOj3/HlSEH3T9u1WweWQTaaZyA+xsBQLx7j1A99Q0JV9
	VxeN/+6d6BFXTmDOsA7B9OM77hcskYKGnFfoGQzyXYE7qk3oKjUXIwXvXvwsSydT
	jjAZ2r3f7eKx0YedYPO/+/udr1efYZDpZD+3plMuXKkVXE9rOXFRL9ouWA25q08d
	GRkMmzd/qRNgyfqmXoxKUK7fTkscsTzeFb9YdaGXaoODEbZn0NLOnDlcLnEFD+Eq
	UdrLjhWLf01KLqMDbpeGtiFEXmL9m2AT1zK+RKJvlT45fHKoh+RB7guT1JDsBsdl
	BgQPIcVAh/ixwpNsfxyqUA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1733495253; x=
	1733581653; bh=B76KV/vkki8TJGBgK74Hn6eB0a40IRXA/S3nHIzx62Y=; b=x
	eTdk0YHw2+uf6rNXrlXzOIUIN8wMFRJlQEq9h0mvDrSyfHGm9FmAOENLwqO21CMB
	a/QmADU+SKnvSmkR76vE5BbFXC7XL91wbLIY4av2T6vOjhZLHWjhlKY+Cn2MlHpZ
	2Pw8m6TuxT5PLEp6IoPrb/WxVsY0dByod1Pl3t5aTfOEp2fpVLIDO9vFMRZqw3Ok
	JMtQPg7IYSFA+QMlDIlx4c+3bXVVef8WaHWSBztND9ah/xFenv6qaeEheQt7VJqs
	CtW27GM3gXjNP5kJ3feN1mnT50WkonE4b489myHWqOa6z3yCviJ2sUXbQW8Zz8Fl
	goONPrBdSDbC1sBGKipQw==
X-ME-Sender: <xms:0wlTZ-477_Rf3sNuwSSL4hDIPZQ1BuiF59CH7NJ5ERHLLXX2riWZEQ>
    <xme:0wlTZ350EiUgFOd_1ww7OA6hH6XBwELimLdvdpVyVk1G57l6_MnEB17zKcvNkK9Xz
    Ei6rRbvM964n4j-u0o>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrieelgdeifecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdpuffr
    tefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnth
    hsucdlqddutddtmdenucfjughrpefoggffhffvvefkjghfufgtgfesthejredtredttden
    ucfhrhhomhepfdetrhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdrug
    gvqeenucggtffrrghtthgvrhhnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffg
    vedugeduveelvdekhfdvieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggvpdhnsggprhgtphhtthhopedujedp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepsghpsegrlhhivghnkedruggvpdhrtg
    hpthhtoheprghnugihrdhshhgvvhgthhgvnhhkohesghhmrghilhdrtghomhdprhgtphht
    thhopehfnhhtohhthhesghhmrghilhdrtghomhdprhgtphhtthhopegtihhmihhnrghghh
    hisehgnhhuuggurdgtohhmpdhrtghpthhtohepshgvrghnjhgtsehgohhoghhlvgdrtgho
    mhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoh
    eprghnugihsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrrhhnugeskhgvrhhnvghl
    rdhorhhgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:1AlTZ9clDf3s5fmDpPycnlOVeW_UnVohub6FXn7c0w9ZTlhMJJDAKA>
    <xmx:1AlTZ7Kyryf9PaHIf2S4IozKjg0R28aGvBv7uspKZTSXEEyI5r6p1g>
    <xmx:1AlTZyLGthSJKXSms5cCGf7S6uRZoLhShOT-tXoYVb2rHrdexh9n4w>
    <xmx:1AlTZ8yEE6x13g6KGT1B6ZOzpnnJBRq1g57Y_7Hd3SvBr26AiNNP4w>
    <xmx:1QlTZz4hprKpicewRMskOb3xHUCGuH1M-EzbUViRNe5-D0M4E7zHHStY>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id DDF1F2220072; Fri,  6 Dec 2024 09:27:31 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 06 Dec 2024 15:27:10 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Ferry Toth" <fntoth@gmail.com>,
 "Andy Shevchenko" <andy.shevchenko@gmail.com>,
 "Arnd Bergmann" <arnd@kernel.org>
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
Message-Id: <3b35b432-8e9e-4499-9beb-25f4f7821572@app.fastmail.com>
In-Reply-To: <d890eecc-97de-4abf-8e0e-b881d5db5c1d@gmail.com>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-9-arnd@kernel.org>
 <CAHp75VfzHmV2anw6C8iSCiwnJc2YNa+1aLDj6Frf9OZyGjD0MQ@mail.gmail.com>
 <d890eecc-97de-4abf-8e0e-b881d5db5c1d@gmail.com>
Subject: Re: [PATCH 08/11] x86: document X86_INTEL_MID as 64-bit-only
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, Dec 6, 2024, at 12:23, Ferry Toth wrote:
> Op 04-12-2024 om 19:55 schreef Andy Shevchenko:
>>
>> It's all other way around (from SW point of view). For unknown reasons
>> Intel decided to release only 32-bit SW and it became the only thing
>> that was heavily tested (despite misunderstanding by some developers
>> that pointed finger to the HW without researching the issue that
>> appears to be purely software in a few cases) _that_ time.  Starting
>> ca. 2017 I enabled 64-bit for Merrifield and from then it's being used
>> by both 32- and 64-bit builds.
>>
>> I'm totally fine to drop 32-bit defaults for Merrifield/Moorefield,
>> but let's hear Ferry who might/may still have a use case for that.
>
> Do to the design of SLM if found (and it is also documented in Intel's 
> HW documentation)
>
> that there is a penalty introduced when executing certain instructions 
> in 64b mode. The one I found
>
> is crc32di, running slower than 2 crc32si in series. Then there are 
> other instructions seem to runs faster in 64b mode.
>
> And there is of course the usual limited memory space than could benefit 
> for 32b mode. I never tried the mixed (x86_32?)
>
> mode. But I am building and testing both i686 and x86_64 for each Edison 
> image.

Hi Ferry,

Thanks a lot for the detailed reply, this is exactly the kind of
information I was hoping to get out of my series, in particular
since we have a lot of the same tradeoffs on low-end 64-bit
Arm platforms, and I've been trying to push users toward running
64-bit kernels on those.

I generally think that it makes a lot of sense to run 32-bit
userspace on memory limited devices, in particular with less
than 512MB, but it's often still useful on devices with 1GB.

Running a 32-bit kernel is usually not worth it if you can
avoid it, and with 1GB of RAM you definitely run into limits
either from using HIGHMEM (with CONFIG_VMSPLIT_3G) or in
user addressing (with any other VMPLIT_*), in addition to the
32-bit kernels just being less well maintained and missing
security features.

Using a 64-bit kernel with CONFIG_COMPAT for 32-bit userspace
tends to be the best combination for a large number of
embedded workloads. As a rough estimate on Arm hardware,
I found that a 64-bit kernel tends to use close to twice
the amount of RAM for itself (vmlinux, slab caches, page
tables, mem_map[]) compared to a 32-bit kernel, but this
should be no more than 10-20% of the total RAM for sensible
workloads as all the interesting bits happen in userland.
I expect the numbers to be similar for x86, but have not
looked in detail.

In userspace there is more variation depending on the type
of application: the base system has a similar 2x ratio, but
once you get into data intensive tasks (file server,
networking, image/video processing, ...) the overhead of
64-bit userspace is lower because the size of the actual
data is the same on both.

For the specific case of the crc32di instruction, I
suspect the in-kernel version of this can be trivially
changed like

diff --git a/arch/x86/crypto/crc32c-intel_glue.c b/arch/x86/crypto/crc32c-intel_glue.c
index 52c5d47ef5a1..60b9b3cab679 100644
--- a/arch/x86/crypto/crc32c-intel_glue.c
+++ b/arch/x86/crypto/crc32c-intel_glue.c
@@ -60,10 +60,10 @@ static u32 __pure crc32c_intel_le_hw(u32 crc, unsigned char const *p, size_t len
 {
        unsigned int iquotient = len / SCALE_F;
        unsigned int iremainder = len % SCALE_F;
-       unsigned long *ptmp = (unsigned long *)p;
+       unsigned int *ptmp = (unsigned int *)p;
 
        while (iquotient--) {
-               asm(CRC32_INST
+               asm("crc32l %1, %0"
                    : "+r" (crc) : "rm" (*ptmp));
                ptmp++;
        }

to get you the faster version, plus some form of
configurability to make sure other CPUs still get the
crc32q version by default.

> I think that should at minimum be useful to catch 32b errors in the 
> kernel in certain areas (shared with other 32b
> archs. So, I would prefer 32b support for this platform to continue.

I can certainly see this both ways, on the one hand I do
care a lot about 32-bit Arm platforms and appreciate the help
in finding issues on 32-bit kernels. On the other hand I
really don't want anyone to waste time testing something that
should never be used in practice and keeping a feature in
the kernel only for the purpose of regression testing that
feature.

The platform is also special enough that I don't see
testing it in 32-bit mode as particularly helpful to
others, and it's unlikely to catch bugs that testing in
KVM won't.

Testing your 32-bit userland with a 64-bit kernel would be
helpful of course to ensure it keeps working for anyone
that had been using 32-bit kernel+userspace if we drop
32-bit kernel support for it.

One related idea that I've discussed before is to have
32-bit kernels refuse to boot on 64-bit hardware and
instead print the URL of a wiki page to explain all of
the above. There would probably have to be whitelist
of platforms that are buggy in 64-bit mode, and a command
line option to revert back to the previous behavior
to allow testing.

       Arnd


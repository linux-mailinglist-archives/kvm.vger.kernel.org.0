Return-Path: <kvm+bounces-56983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D847B49263
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 17:04:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9F9C67A340F
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 15:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FBC230E0DC;
	Mon,  8 Sep 2025 15:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="HDqRDB47"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0513730ACE8;
	Mon,  8 Sep 2025 15:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757343844; cv=none; b=CjE4M/IMgSpoLbgGEX3VJjIJvHcu/1nACP7t1XtOc1Eb4mpnevsZKuwhbAQej6YQy7dFEzaMKNU9D6xprhF8YQ1lGDjb8Wz0ulXKTYLdEvZudwtq8SKqUH7TkXAP2aTBniD+sRvflbiMC4rfbZJp/piPzcA2c3tnd2lL7zotczo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757343844; c=relaxed/simple;
	bh=HGi+oMw2wcRLkxRtf1WqMmGBJnptQWvmxF2SQgOWE44=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GLVKu7tGAt0/csPA0gLU/b6REEY3YbSUGht3jp2dmodQ2pqwu7hoysOWSr1ebnmmEHoRIOZAnYEz3gnNPQN4NWvFFX+DREEEGTpTXzVm/V5iYFvWlnGFjadeoJIqsf23OZP3szSzXz92ll3v0vuot3PVJLRem8XbLkFY8rOnY9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=HDqRDB47 reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E00F640E01A2;
	Mon,  8 Sep 2025 15:03:57 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
	reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Dx_Mcpvo0WRj; Mon,  8 Sep 2025 15:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1757343830; bh=ZqDP/jFE+eeNiZ9/0ak0Uo6t8J44LbT5gL5scXJrlQc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HDqRDB47PMky7RLUBXKoA6kDCZCnyPhpDnieFgQyS4iYOBrtI7OUwZ3P/P24eNpMP
	 RZjYJ7CXQ+RFxfgr3ypDGl3VVhDtMIICPKslKj8nX1uxr5YtP0G6BzLP7lnVaCP2uz
	 p7bJWjVqW4VEJhW1BLa7jJ31az0NgFRIFrZcWa5fl5evBLwFeqA95DyeVJM8leptpe
	 6SLuEuWHCzT5KpmMruEseNLE2tu2D9uaSVUtACO/Llshwf5JjXnDkImumc/aIM+B+M
	 AEHu4tb2lfi7/w+1DGOmLI41Rym4P8hyDfscfmtuPyX2y41zGyVgeaR4idphgX0HkP
	 WuvTaSBeAhUq3HDJ2W2bq2bO3vQUoVx7LbMw1fKNR8WB9AhQRbyADvfUlh7Nv6SDVT
	 9NevJMaKGLr24cBBp7TB16Uw0cBFDHRZpNC8/IoVpRM6xlW0nK6sKCpf6bsU4IjYeD
	 oOtilGcqln6hADP5hfLUS1rjWGwyX/LqZg/rQKq5AIvAYA4D3e2nnQw9g+FiM+B/Wi
	 78Od1JPs8BE1Sdqe70823RvbC7x08GGS7xJl2OIb1/cJrbmFjcd5le4camLhoxJSV1
	 mODF9ClHnVlRWBGyXGWsuLZaaCPl8y65bxGu/Uh6ErE7QG8zq4738FNzELFCfog4vS
	 j4hb6z78v+TQWvdB7mruFrhM=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id D4F9C40E015D;
	Mon,  8 Sep 2025 15:03:07 +0000 (UTC)
Date: Mon, 8 Sep 2025 17:03:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Moger, Babu" <babu.moger@amd.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Cc: corbet@lwn.net, tony.luck@intel.com, Dave.Martin@arm.com,
	james.morse@arm.com, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	kas@kernel.org, rick.p.edgecombe@intel.com,
	akpm@linux-foundation.org, paulmck@kernel.org, frederic@kernel.org,
	pmladek@suse.com, rostedt@goodmis.org, kees@kernel.org,
	arnd@arndb.de, fvdl@google.com, seanjc@google.com,
	thomas.lendacky@amd.com, pawan.kumar.gupta@linux.intel.com,
	perry.yuan@amd.com, manali.shukla@amd.com, sohil.mehta@intel.com,
	xin@zytor.com, Neeraj.Upadhyay@amd.com, peterz@infradead.org,
	tiala@microsoft.com, mario.limonciello@amd.com,
	dapeng1.mi@linux.intel.com, michael.roth@amd.com,
	chang.seok.bae@intel.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
	kvm@vger.kernel.org, peternewman@google.com, eranian@google.com,
	gautham.shenoy@amd.com
Subject: Re: [PATCH v18 05/33] x86/cpufeatures: Add support for Assignable
 Bandwidth Monitoring Counters (ABMC)
Message-ID: <20250908150301.GFaL7wJUiowzdhWUbu@fat_crate.local>
References: <cover.1757108044.git.babu.moger@amd.com>
 <08c0ad5eb21ab2b9a4378f43e59a095572e468d0.1757108044.git.babu.moger@amd.com>
 <fb2d5df6-543f-43da-a86a-05ecf75be46d@intel.com>
 <d3e4ddd7-2ca2-4601-8191-53e00632bf93@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d3e4ddd7-2ca2-4601-8191-53e00632bf93@amd.com>
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 08, 2025 at 09:41:22AM -0500, Moger, Babu wrote:
> > Apologies for not catching this earlier. I double checked to make sur=
e
> > we get this right and I interpret Documentation/process/maintainer-ti=
p.rst
> > to say that "Link:" should be the final tag.
> >=20
>=20
> That=E2=80=99s fine. It wasn=E2=80=99t very clear to me in maintainer-t=
ip.rst.

You don't need to worry about minor things like that - our scripts fix th=
em up
while applying.

As to Link tags, see this here:

https://lore.kernel.org/r/CAHk-=3Dwh5AyuvEhNY9a57v-vwyr7EkPVRUKMPwj92yF_K=
0dJHVg@mail.gmail.com

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


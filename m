Return-Path: <kvm+bounces-3634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F2595805F9C
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 21:42:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B6F81F2120C
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 20:42:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 511CA6A028;
	Tue,  5 Dec 2023 20:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="QeGaBZnV"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D421B9;
	Tue,  5 Dec 2023 12:42:04 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id ED59340E01AD;
	Tue,  5 Dec 2023 20:42:01 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id U3Rl140nQfQX; Tue,  5 Dec 2023 20:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1701808919; bh=tFLgCOsOzpUKWhIWySrPHpuXE9aWdXFU9WqlKDjDD1E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QeGaBZnVxtl8soyFCR6ynfxcMxozgV6Pp/D7wRgcKePhQM1LWW0ZucU9R6S3JOGu6
	 jpNaEDWd64Qf1JfzqoWKPYZDRw9U3NvGtQs+M2AA9kzVLIrmLm6ihNCZFsBY7Nim4R
	 s8+L6R5LXUvo0e3dFozk8VaesIBnYKJQV2fPco1aa0AUIKc/0GEkjeQWcRrUuoAFyP
	 ggrX33sr97pz4X0hXJOlGufvrDaofGHPGcuTiNpNQ9cE4R1eP697PZcW+GlYDsgliP
	 BSWAGRkl/FiJMpvv2lsoeU2zpo69c8NpRo7w0iHT5hyiOj/9cL90T+dwH37ClTMRrZ
	 s5DzjrHkO/Zo8DYy2iB8a1rMxoGTutpdjpYYigK4sbDTcKUZabHv+AMcpNbuDSm/8H
	 GlKD5fPvINKUtxD45zRUMfNasXeBkXlHQXiikWq8YpFyE77KLvXjXS6jjWbH4bIOmG
	 9B7Eb2p6Rml2Nr/H9PJFIJrVLqkSRATy1ileL8GMnnBo84wUCVSP9K4st3ck5STIMm
	 ncvyc8FmtV4Vtgez9Ysi+skdgrrgGDkxSwcRiONrMVbwWSini6qgbXo2ZTpQlRROjo
	 uzMuSuOJQztPjIwoFwigtrThjhMu+J8TnnE/IZajf/Xn1H5ekXJpaJtNoY+81ARyHt
	 p78yOcklBdPKN+YhzejkSMx0=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 85F4D40E0173;
	Tue,  5 Dec 2023 20:41:33 +0000 (UTC)
Date: Tue, 5 Dec 2023 21:41:32 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Brown, Len" <len.brown@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>,
	"bagasdotme@gmail.com" <bagasdotme@gmail.com>,
	"ak@linux.intel.com" <ak@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"Luck, Tony" <tony.luck@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"imammedo@redhat.com" <imammedo@redhat.com>,
	"sagis@google.com" <sagis@google.com>,
	"Gao, Chao" <chao.gao@intel.com>,
	"rafael@kernel.org" <rafael@kernel.org>,
	"sathyanarayanan.kuppuswamy@linux.intel.com" <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Message-ID: <20231205204132.GLZW+K/Ix5sngfmcsY@fat_crate.local>
References: <cover.1699527082.git.kai.huang@intel.com>
 <9e80873fac878aa5d697cbcd4d456d01e1009d1f.1699527082.git.kai.huang@intel.com>
 <20231205142517.GBZW8yzVDEKIVTthSx@fat_crate.local>
 <0db3de96d324710cef469040d88002db429c47e6.camel@intel.com>
 <20231205195637.GHZW+Add3H/gSefAVM@fat_crate.local>
 <2394202d237b4a74440fba1a267652335b53b71d.camel@intel.com>
 <20231205202927.GJZW+IJ0NelvVmEum/@fat_crate.local>
 <0eca4ddc74bc849b68d2ee93411be9b7d6329f0e.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0eca4ddc74bc849b68d2ee93411be9b7d6329f0e.camel@intel.com>

On Tue, Dec 05, 2023 at 08:33:14PM +0000, Huang, Kai wrote:
> Yes I understand what you said.  My point is X86_FEATURE_TDX doesn't suit
> because when it is set, the kernel actually hasn't done any enabling work yet
> thus TDX is not available albeit the X86_FEATURE_TDX is set.

You define a X86_FEATURE flag. You set it *when* TDX is available and
enabled. Then you query that flag. This is how synthetic flags work.

In your patchset, when do you know that TDX is enabled? Point me to the
code place pls.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


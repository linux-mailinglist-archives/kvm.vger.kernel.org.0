Return-Path: <kvm+bounces-4338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EADBA81130D
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 14:37:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2721A1C20F82
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 13:37:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D35992D60F;
	Wed, 13 Dec 2023 13:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="k3ZzSSDZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [IPv6:2a01:4f9:3051:3f93::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0981010C;
	Wed, 13 Dec 2023 05:37:20 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4A62C40E00CB;
	Wed, 13 Dec 2023 13:37:17 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id p0U30yDLCYky; Wed, 13 Dec 2023 13:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1702474635; bh=YsH4/BEojnoqKhDSs/A5b/HEN4SIud9JxkU6bHGIETQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k3ZzSSDZFMpQnaGW9BcncZOs/yVlI6yaQuxN6E4vcYoNlELe7nKhzl5Ik0qVn3oCj
	 j668Gcp+/P66Y/urrTJ/vDsLk9/u6n0FhhoHumDxwbG6N4kzmUxOYTDWxC6/YZ5kwB
	 P2RvyUbZAsO9a2zbTdYt/KEi46RNH17BK36Co1IQx9rA+FmaoEAwEs1YRgnUvX6QOH
	 nwmAuHRJ7f7lFi0bF1U52LiE2eaebb6Euoue6vucw+tjUql0v+bw4niwzaqnyJSzrm
	 oPSXD2Sf5804v4D77oHC+2hj2afMmDhzZcmCBap/0qpDNXkWSeZXPEozTQT7i3DFmy
	 NK1B3CIlO7Mur7agPdg7Cv5V5bYdtCkeOyVunRvDENHpzfqXPztmJASQTJko8b3MWs
	 2pVgAX2EDaCFdMS2yokm6/WC4MaLq34kZHykWEN9B+aNOhe2bBQ68ROFc21zpCATjq
	 Z6izNFCptB7hsGt5LHhLKuYrSpX3KSWtf/S1Ge7HqcvVBElo+FVS4SI2kbg7Ku6yS+
	 +BGSHFFPGfNLsa6Izyhk8ONszw2sMQAzHgctgg1JqPdFFDJJ+zcEm37XpBVmK5W66f
	 MRjOacIFonlsxm3SyICQvheBm5bJfg+y2x7srt0/+ep3HXHJ649sQOVzVCEUe35hmt
	 p2C8L6CILEGJSIBky90kQ8fs=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8F45140E0030;
	Wed, 13 Dec 2023 13:36:33 +0000 (UTC)
Date: Wed, 13 Dec 2023 14:36:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, seanjc@google.com, vkuznets@redhat.com,
	jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
	slp@redhat.com, pgonda@google.com, peterz@infradead.org,
	srinivas.pandruvada@linux.intel.com, rientjes@google.com,
	dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz,
	kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
	marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
	alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
	nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
	liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>,
	Jarkko Sakkinen <jarkko@profian.com>
Subject: Re: [PATCH v10 04/50] x86/cpufeatures: Add SEV-SNP CPU feature
Message-ID: <20231213133628.GEZXmzXFwA1p+crH/5@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-5-michael.roth@amd.com>
 <0b2eb374-356c-46c6-9c4a-9512fbfece7a@redhat.com>
 <20231213131324.GDZXmt9LsMmJZyzCJw@fat_crate.local>
 <40915dc3-4083-4b9f-bc64-7542833566e1@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <40915dc3-4083-4b9f-bc64-7542833566e1@redhat.com>

On Wed, Dec 13, 2023 at 02:31:05PM +0100, Paolo Bonzini wrote:
> Sure, I only queued it because you gave Acked-by for 05/50 and this is an
> obvious dependency.  I would like to get things in as they are ready
> (whenever it makes sense), so if you want to include those two in the x86
> tree for 6.8, that would work for me.

It doesn't make sense to include them into 6.8 because the two alone are
simply dead code in 6.8.

The plan is to put the x86 patches first in the next submission, I'll
pick them up for 6.9 and then give you an immutable branch to apply the
KVM bits ontop. This way it all goes together.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


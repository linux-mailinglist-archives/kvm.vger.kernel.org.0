Return-Path: <kvm+bounces-1872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DBBED7EDB3E
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 06:32:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E21C11C20A47
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 05:32:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58F4CD28C;
	Thu, 16 Nov 2023 05:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BAzyXnv9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED5A196
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 21:31:49 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-53eeb28e8e5so4461a12.1
        for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 21:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1700112708; x=1700717508; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4diCtTL3EivIaKd6Yrty+RIJmvtzTDLTo/nXfRxccPk=;
        b=BAzyXnv9LHq75tPsgaJ3pvn5mvOcfTOaw7Vxzv3Qt6TKXfJpYHxBx4zOnXKgwzHvcv
         zUl050HjJz6yvJutrQKLq4GwbGhIW+aClp0w7e8KVZLYXTJH3SojZ/SMtr0iyzaKEWFO
         Pofb0gId5uugehW8XAIJRbwsaH8FjJfUCzd/Z/Ynnrr1dB89+UBAft7F/ok6BKSEEULf
         VMG/2Ripc/9ofcfxkoBOFwT1UvSDgtrfoVikztw1oXMTzyshUZKNPBqR+mfttu7f0lYe
         LiGX6nI+2f96Jh1HZWA7OiDEcQaD05hLvUzDRsH59fL7Fuf4vtl0g5FQMK2GHl+W4f53
         0dkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700112708; x=1700717508;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4diCtTL3EivIaKd6Yrty+RIJmvtzTDLTo/nXfRxccPk=;
        b=R3aAmSAPj6a2l1VuDVZusy3pIzA0/0qQXRkujvxjDwpZW+mobV0e2Wzeqk6ex0g3qp
         6fKBy8V6+bPf16gTd6in2aIVegmpBhiMe4KLQ2SuchN19wh+/a2YzMLgt3xrYfwcKGDJ
         iUinXEH4SRLsLyiYHCbWZ9STbdTPCy/tedQsoNjt2bZ+/HUR0md+MD6DZWsKHiGE+/j0
         y6VbxftkTgFv/N3K+v4Ov0CWyyj84sPc+Si1qVzrh4Tq39HkUHs7eRHPjzC4jQCsgoCF
         3M4WS+IOzWP00zPoKVHjBx7sD5e3xG0e7uKIN1O0Zko9P+XFdOCLtjvVZHYjwcUvK8qH
         oRPA==
X-Gm-Message-State: AOJu0Yz5GXj2kH5gXLuatQ7Dk8zjep39SkUCCS+XIJeTApIwtssWE5zG
	bp4+8hlSLswu9ElHyEOuSm+RltVbeZGRkFhxTknoKA==
X-Google-Smtp-Source: AGHT+IGOHarkPwgABVlEMIKneg9bFJeC/Sizgt1g86eNBkXhc6lGj6UX9Rcz+JOCTeiCxNp2DrA60v/aOwz4dSqmSxY=
X-Received: by 2002:a05:6402:1bcb:b0:547:3f1:84e0 with SMTP id
 ch11-20020a0564021bcb00b0054703f184e0mr60685edb.7.1700112707847; Wed, 15 Nov
 2023 21:31:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-49-michael.roth@amd.com> <CAAH4kHb=hNH88poYw-fj+ewYgt8F-hseZcRuLDdvbgpSQ5FDZQ@mail.gmail.com>
 <ZS614OSoritrE1d2@google.com> <b9da2fed-b527-4242-a588-7fc3ee6c9070@amd.com>
 <ZS_iS4UOgBbssp7Z@google.com> <20231110220756.7hhiy36jc6jiu7nm@amd.com> <ZU6zGgvfhga0Oiob@google.com>
In-Reply-To: <ZU6zGgvfhga0Oiob@google.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Wed, 15 Nov 2023 21:31:34 -0800
Message-ID: <CAAH4kHYPAiS+_KKhb1=8q=OkS+XBsES8J3K_acJ_5YcNZPi=kA@mail.gmail.com>
Subject: Re: [PATCH v10 48/50] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
To: Sean Christopherson <seanjc@google.com>
Cc: Michael Roth <michael.roth@amd.com>, Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org, 
	linux-coco@lists.linux.dev, linux-mm@kvack.org, linux-crypto@vger.kernel.org, 
	x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, 
	ardb@kernel.org, pbonzini@redhat.com, vkuznets@redhat.com, 
	jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com, 
	slp@redhat.com, pgonda@google.com, peterz@infradead.org, 
	srinivas.pandruvada@linux.intel.com, rientjes@google.com, 
	dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, vbabka@suse.cz, 
	kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com, 
	Brijesh Singh <brijesh.singh@amd.com>, Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"

> > So we're sort of complicating the more common case to support a more niche
> > one (as far as userspace is concerned anyway; as far as kernel goes, your
> > approach is certainly simplest :)).
> >
> > Instead, maybe a compromise is warranted so the requirements on userspace
> > side are less complicated for a more basic deployment:
> >
> >   1) If /dev/sev is used to set a global certificate, then that will be
> >      used unconditionally by KVM, protected by simple dumb mutex during
> >      usage/update.
> >   2) If /dev/sev is not used to set the global certificate is the value
> >      is NULL, we assume userspace wants full responsibility for managing
> >      certificates and exit to userspace to request the certs in the manner
> >      you suggested.
> >
> > Sean, Dionna, would this cover your concerns and address the certificate
> > update use-case?
>
> Honestly, no.  I see zero reason for the kernel to be involved.  IIUC, there's no
> privileged operations that require kernel intervention, which means that shoving
> a global cert into /dev/sev is using the CCP driver as middleman.  Just use a
> userspace daemon.  I have a very hard time believing that passing around large-ish
> blobs of data in userspace isn't already a solved problem.

ping sathyanarayanan.kuppuswamy@linux.intel.com and +Dan Williams

I think for a uniform experience for all coco technologies, we need
someone from Intel to weigh in on supporting auxblob through a similar
vmexit. Whereas the quoting enclave gets its PCK cert installed by the
host, something like the firmware's SBOM [1] could be delivered in
auxblob. The proposal to embed the compressed SBOM binary in a coff
section of the UEFI doesn't get it communicated to user space, so this
is a good place to get that info about the expected TDMR in. The SBOM
proposal itself would need additional modeling in the coRIM profile to
have extra coco-specific measurements or we need to find some other
method of getting this info bundled with the attestation report.

My own plan for SEV-SNP was to have a bespoke signed measurement of
the UEFI in the GUID table, but that doesn't extend to TDX. If we're
looking more at an industry alignment on coRIM for SBOM formats (yes
please), then it'd be great to start getting that kind of info plumbed
to the user in a uniform way that doesn't have to rely on servers
providing the endorsements.

[1] https://uefi.org/blog/firmware-sbom-proposal



-- 
-Dionna Glaze, PhD (she/her)


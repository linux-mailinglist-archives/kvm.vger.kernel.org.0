Return-Path: <kvm+bounces-3637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 66740806152
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 23:05:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E31DAB2126F
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 22:05:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1402A6D1D2;
	Tue,  5 Dec 2023 22:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FSM3mOB7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871FE1B8
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 14:04:57 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-54c77d011acso1143a12.1
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 14:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701813896; x=1702418696; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/xPsXYdPRuMVqnsmnQJ1p0ZibiDuuU0TYtGWS33ZgM4=;
        b=FSM3mOB7N7qlrkkYHsJuLq/r0l7JVdre2PpBK4FcXnhUGblqiLgJrLWYQVqS8t7ZPh
         1ipCvbe7CrT7h4nO2PFn0EmN5boAGl0bkPhBo2130UbDo32orIZAE7I2ISbBBbceHuhm
         Ing6K+/kubIhGW4hSxGXFEgwnuDL9DWrPodk2RxT7asyRupO4hmscJiTajoyDGCxBRiw
         Kp/qgVklEPtCR8Zfg3gEltZE4Qztsz/QhcWWSFFth1LY/ozNhPJpXWJvfpzi5kKSXZ9D
         CwlUFtW/BwJvKa/9w3agneXNuj6yjn79VIdN/2ZUWJlNXRAsjCGUPwAKHr3dbDPjI9Yj
         9aeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701813896; x=1702418696;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/xPsXYdPRuMVqnsmnQJ1p0ZibiDuuU0TYtGWS33ZgM4=;
        b=NpT1DeInxgfKe1JkLK/DxnJFgqOEvN9v2Ip/nloZF4MHu8Ulno4IFfqMKljxYdkd8H
         eK+RssdcrdejwpAyHNCVi73LrWt5UgsKPLfY++SLWKRYOhntIephrEwLHkwmQ7YyBT04
         siFIQVrUWrTohdA6gh7tND4tPop56cSkniIDQJPrzpgSPND7Qfbj8XjBhwctggNBJV9L
         170a2JQ5R+e0z85CIOZyugHnOvscBKPn0f8dQAeDOBfsgae0NB3Al+UwOQZvCMvQzo00
         lBiOZ3ea61lGNMaTUJ0aFRDcqyQECV4D6zkM3++H7JnKbNXYyMcxFBj9rfiyOMIlxeko
         rmbA==
X-Gm-Message-State: AOJu0YyhIxxdsIvuvhhS2kgPxQ4mwLUud9oVpU3XumxBtXYxA8OPZnkh
	1FIwYppzhu3wXbQcLeA6p9jgdAfeOlm/loyGhyV4eQ==
X-Google-Smtp-Source: AGHT+IEnOoiWY23KKyQjfRHwuGfX4CP9fcTkgpJltbeuMXUh11BY17rmT8TNGVgT5UIvk6dxp5zfegre0jIAWGh5Ggc=
X-Received: by 2002:a50:bb03:0:b0:544:466b:3b20 with SMTP id
 y3-20020a50bb03000000b00544466b3b20mr5843ede.5.1701813895835; Tue, 05 Dec
 2023 14:04:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231016132819.1002933-49-michael.roth@amd.com>
 <CAAH4kHb=hNH88poYw-fj+ewYgt8F-hseZcRuLDdvbgpSQ5FDZQ@mail.gmail.com>
 <ZS614OSoritrE1d2@google.com> <b9da2fed-b527-4242-a588-7fc3ee6c9070@amd.com>
 <ZS_iS4UOgBbssp7Z@google.com> <20231110220756.7hhiy36jc6jiu7nm@amd.com>
 <ZU6zGgvfhga0Oiob@google.com> <CAAH4kHYPAiS+_KKhb1=8q=OkS+XBsES8J3K_acJ_5YcNZPi=kA@mail.gmail.com>
 <656e6f0aa1c5_4568a29451@dwillia2-xfh.jf.intel.com.notmuch>
 <CAAH4kHb7cfMetpC=AYy=FjTTve6g0W8NZdeSwQ8uVxkqi2491Q@mail.gmail.com> <656f82b4b1972_45e012944e@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <656f82b4b1972_45e012944e@dwillia2-xfh.jf.intel.com.notmuch>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Tue, 5 Dec 2023 14:04:41 -0800
Message-ID: <CAAH4kHb9O9FeaTmNuNAkhrdrDLJPo8qgD5vNow3w-sY-DA4Ung@mail.gmail.com>
Subject: Re: [PATCH v10 48/50] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
To: Dan Williams <dan.j.williams@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Michael Roth <michael.roth@amd.com>, 
	Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, 
	pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com, 
	luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com, 
	pgonda@google.com, peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com, 
	Brijesh Singh <brijesh.singh@amd.com>, dan.middleton@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 5, 2023 at 12:06=E2=80=AFPM Dan Williams <dan.j.williams@intel.=
com> wrote:
>
> [ add Ard for the SBOM sysfs ABI commentary ]
>
> Dionna Amalie Glaze wrote:
> [..]
> > > > My own plan for SEV-SNP was to have a bespoke signed measurement of
> > > > the UEFI in the GUID table, but that doesn't extend to TDX. If we'r=
e
> > > > looking more at an industry alignment on coRIM for SBOM formats (ye=
s
> > > > please), then it'd be great to start getting that kind of info plum=
bed
> > > > to the user in a uniform way that doesn't have to rely on servers
> > > > providing the endorsements.
> > > >
> > > > [1] https://uefi.org/blog/firmware-sbom-proposal
> > >
> > > Honestly my first reaction for this ABI would be for a new file under
> > > /sys/firmware/efi/efivars or similar.
> >
> > For UEFI specifically that could make sense, yes. Not everyone has
> > been mounting efivars, so it's been a bit of an uphill battle for that
> > one.
>
> I wonder what the concern is with mounting efivarfs vs configfs? In any
> event this seems distinct enough to be its own /sys/firmware/efi/sbom
> file. I would defer to Ard, but I think SBOM is a generally useful
> concept that would be out of place as a blob returned from configfs-tsm.
>
> > Still there's the matter of cached TDI RIMs. NVIDIA would have
>
> I am not immediatly sure what a "TDI RIM" is?
>

I might just be making up terms. Any trusted hardware device that has
its own attestation will (hopefully) have signed reference
measurements, or a Reference Integrity Manifest as TCG calls them.

> > everyone send attestation requests to their servers every quote
> > request in the NRAS architecture, but we're looking at other ways to
>
> "NRAS" does not parse for me either.
>

That would be this https://docs.attestation.nvidia.com/api-docs/nras.html

> > provide reliable attestation without a third party service, albeit
> > with slightly different security properties.
>
> Setting the above confusion aside, I would just say that in general yes,
> the kernel needs to understand its role in an end-to-end attestation
> architecture that is not beholden to a single vendor, but also allows
> the kernel to enforce ABI stability / mitigate regressions based on
> binary format changes.
>

I'm mainly holding on to hope that I don't have to introduce a new
runtime dependency on a service that gives a source of truth about the
software that's running in the VM.
If we can have a GUID table with a flexible size that the host can
request of the guest, then we can version ABI changes with new GUID
entries.
It's a big enough value space without vanity naming opportunities that
we can pretty easily make changes without incurring any guest kernel
changes.

--=20
-Dionna Glaze, PhD (she/her)


Return-Path: <kvm+bounces-71168-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OP0BKNiplGl7GQIAu9opvQ
	(envelope-from <kvm+bounces-71168-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 18:48:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F299E14EBAE
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 18:48:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A4BB630342B1
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 17:47:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0407836F431;
	Tue, 17 Feb 2026 17:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZppstiaU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D2436EABF
	for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 17:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771350473; cv=none; b=O+BmmiatDNAZMyB7LjzA08/TICYV+yA7Qjg4OLyNlkFbOF+MqOeLJwPqbQJdypHtOCbgTdtYQmtpMsb2F9BEiXB3M+1j+HqLai+7fpfGXoZLpdT4wwXdwgjsXVCLq6FUb9jEEyI5v387swQe88QYeDpm5wlJoksmttzn7kTe4XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771350473; c=relaxed/simple;
	bh=Ldc3kA/B8po7HRBL7zpvt1BJaIEwgDG3685rS8QLkdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LzTQc1whg6M8bvcuOBDctv7aGK94LRywZVIkcbbRnmlpcSSBKVpHhwMZg50qODn+d+jOLFhZ6NRvJqKET/dSHTH1W2pNNnv9A5pWY2XPo95kziifNBT9V8WO2/9tBbALLOII7dFwNoZf5dusOU5R4ImHUrT13cnwPr+iE+zIFVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZppstiaU; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8217f2ad01eso446042b3a.2
        for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 09:47:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771350471; x=1771955271; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NzMITkEXZs34lceKZ1bkvJdV8jpP8i6Cd6H1ke9i4qg=;
        b=ZppstiaUMgdxGhYrJCK250bmu3M9qtXXEJzvjNUBaSe3/OFvucS6HjQ4UpIiJ9Py5A
         dRFSD5h+l8n63UQD93tuYuvJPdquc5FUMTVFBcunYehH6X/eYb6ROUXDWff8pldEIwBH
         Ye7GpKqkFbzC51GlX2N2rxyEZ+A0qMZmzNgYCBm3CTVpTJQ+klVrhoYkt9QlfXc+NVoR
         iLooG79GbkeLB2qvDgxg/+dyvwdwHXUxC3Q1v1aN/CIGUGPhrWXvDPh1QqzcWu2PPQK3
         M7x4MgWRRR4eEONtFxzPKmtqOHCv47SnIsimg+DSnyz8z7dcuB08Uyf5cDJd2J8daJ+F
         xJjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771350471; x=1771955271;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NzMITkEXZs34lceKZ1bkvJdV8jpP8i6Cd6H1ke9i4qg=;
        b=ZKHTguw2yidFfqtp0p5OGT6MpPv7Zcf96AyK3HGqBZOLn5j+iYED5YOLAG77TC06Z/
         /Toj/v9KN1BnmT3mzPMqTN07o9SSESoTmDRVHvPNkW3DdnvuTIikYqDH8N3VzNF0Z7P3
         m4yvzLq8lV2vwVXCLzAcSogxOfG1WH49spHGZtO7EVPKOJIcI0rC83+LH79rlGd2V7OM
         ao5xA7hvm5jw6E1bQOMLiLrN0X/AjMpfzd3r+JUNG0jyh9XxYqpPiyZ18cKp1DOSeJ2d
         DyCj66mZ6U/W0v25ld2AwH9DY5K32YTOxEC8cM1dIbGsxQwT0TeIHr0jwXB9TOlrxJDC
         /5FQ==
X-Gm-Message-State: AOJu0Yyky/Qg5Qk1E3HI1tMJDCYDbML2GQ9QWx+Scb0c1sfn/vU/dqTJ
	eQvEBA+oz5QLIw96La5Wcu3ElhTmvW+IX5kH6rO48wARE0C5ermgiF61QqVUxzCW2TI=
X-Gm-Gg: AZuq6aICrN8ziSpS87+hP8YB9mZvHDQpnUVwaZegHjd2ROQ2lOZbUccBmLl7PrOyWko
	IVFaCKn8b8xjsvv8P9mXH7e38ScPXNPA1Pbj1A1VfNDhO4q1rY/IHN8EjBaUOa1khVj1cGBrpKs
	+C4RViR3di10IOuX26SsDOSGAVNK2TpajHI/Rpu1KvPFeY9aHJ7aFMtdNRw/JoQwI+dIfYCm27j
	yPxPB6uxhdy6WDBNNg/ZhvOnrEQBm05J774K9ShTYNskCbCmBb2w3u3RSP9xMtx84lnaZ8nRarz
	j/1mELKGNPqmpRJZMQG7+lDyM3s81zGLTwkuq3Kto2MGNeqwy4+WmwuQM84ftZe4TeJWMfslx0t
	x8+VJGk7eLMIXPtILQI8PSxrkjJP7AEuWAapon4egIEkbGToGd2Ib689PXgYEHSPgPQSSITShF4
	xoVmhowhQ5lQ3BktbZ2wOLYyAFrQ==
X-Received: by 2002:a05:6a21:4916:b0:38b:ebdd:919f with SMTP id adf61e73a8af0-394671145b5mr13583057637.1.1771350471095;
        Tue, 17 Feb 2026 09:47:51 -0800 (PST)
Received: from p14s ([2604:3d09:148c:c800:970a:754:4a36:44d0])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6e5331ba14sm10310210a12.29.2026.02.17.09.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 09:47:50 -0800 (PST)
Date: Tue, 17 Feb 2026 10:47:46 -0700
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH v12 00/46] arm64: Support for Arm CCA in KVM
Message-ID: <aZSpwlZmpjdh3Oxr@p14s>
References: <20251217101125.91098-1-steven.price@arm.com>
 <aY4Sf4lMlWd9LyTo@p14s>
 <55fc4877-666c-4d5f-a167-5692f7cfbd0b@arm.com>
 <9140efaa-dc54-4a1b-8936-3ef876ca9121@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9140efaa-dc54-4a1b-8936-3ef876ca9121@arm.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71168-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	DKIM_TRACE(0.00)[linaro.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mathieu.poirier@linaro.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: F299E14EBAE
X-Rspamd-Action: no action

On Mon, Feb 16, 2026 at 02:27:02PM +0000, Steven Price wrote:
> On 16/02/2026 12:33, Steven Price wrote:
> > On 12/02/2026 17:48, Mathieu Poirier wrote:
> >> Hi Steven,
> >>
> >> On Wed, Dec 17, 2025 at 10:10:37AM +0000, Steven Price wrote:
> >>> This series adds support for running protected VMs using KVM under the
> >>> Arm Confidential Compute Architecture (CCA). I've changed the uAPI
> >>> following feedback from Marc.
> >>>
> >>> The main change is that rather than providing a multiplex CAP and
> >>> expecting the VMM to drive the different stages of realm construction,
> >>> there's now just a minimal interface and KVM performs the necessary
> >>> operations when needed.
> >>>
> >>> This series is lightly tested and is meant as a demonstration of the new
> >>> uAPI. There are a number of (known) rough corners in the implementation
> >>> that I haven't dealt with properly.
> >>>
> >>> In particular please note that this series is still targetting RMM v1.0.
> >>> There is an alpha quality version of RMM v2.0 available[1]. Feedback was
> >>> that there are a number of blockers for merging with RMM v1.0 and so I
> >>> expect to rework this series to support RMM v2.0 before it is merged.
> >>> That will necessarily involve reworking the implementation.
> >>>
> >>> Specifically I'm expecting improvements in:
> >>>
> >>>  * GIC handling - passing state in registers, and allowing the host to
> >>>    fully emulate the GIC by allowing trap bits to be set.
> >>>
> >>>  * PMU handling - again providing flexibility to the host's emulation.
> >>>
> >>>  * Page size/granule size mismatch. RMM v1.0 defines the granule as 4k,
> >>>    RMM v2.0 provide the option for the host to change the granule size.
> >>>    The intention is that Linux would simply set the granule size equal
> >>>    to its page size which will significantly simplify the management of
> >>>    granules.
> >>>
> >>>  * Some performance improvement from the use of range-based map/unmap
> >>>    RMI calls.
> >>>
> >>> This series is based on v6.19-rc1. It is also available as a git
> >>> repository:
> >>>
> >>> https://gitlab.arm.com/linux-arm/linux-cca cca-host/v12
> >>>
> >>> Work in progress changes for kvmtool are available from the git
> >>> repository below:
> >>>
> >>> https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v10
> >>
> >> The first thing to note is that branch cca/v10 does not compile due to function
> >> realm_configure_parameters() not being called anywhere.  Marking the function as
> >> [[maybe_unused]] solved the problem on my side.
> > 
> > This is in the kvmtool code - and yes I agree "work in progress" is a
> > bit generous for the current state of that code, "horrid ugly hacks to
> > get things working" is probably more accurate ;)
> > 
> > The issue here is that the two things that realm_configure_parameters()
> > set up (hash algorithm and RPV) are currently unsupported with the Linux
> > changes, but will need to be reintroduced in the future. So the contents
> > of the functions which set this up (using the old uAPI) are just #if 0'd
> > out.
> > 
> > Depending on the compile flags the code will compile with a warning, but
> > using __attribute__((unused)) would at least make this clear. I'd want
> > to avoid the "[[maybe_unused]]" as it's not used elsewhere in the code
> > base and limits compatibility.
> > 
> >> Using the FVP emulator, booting a Realm that includes EDK2 in its boot stack
> >> worked.  If EDK2 is not part of the boot stack and a kernel is booted directly
> >> from lkvm, mounting the initrd fails.  Looking into this issue further, I see
> >> that from a Realm kernel's perspective, the content of the initrd is either
> >> encrypted or has been trampled on.  
> > 
> > I can reproduce that, a quick fix is to change INITRD_ALIGN:
> > 
> > #define INITRD_ALIGN	SZ_64K
> > 
> > But the code was meant to be able to deal with an unaligned initrd -
> > I'll see if I can figure out what's going wrong.
> 
> Looks like a simple bug in kvm_arm_realm_populate_ram() - it wasn't
> updating the source address when it had to align the start of the
> region. Simple fix below:
> 
> ---8<---
> diff --git a/arm/aarch64/realm.c b/arm/aarch64/realm.c
> --- a/arm/aarch64/realm.c
> +++ b/arm/aarch64/realm.c
> @@ -104,7 +104,7 @@ void kvm_arm_realm_populate_ram(struct kvm *kvm,
> unsigned long start,
> 
>         new_region->start = ALIGN_DOWN(start, SZ_64K);
>         new_region->file_end = ALIGN(start + size, SZ_64K);
> -       new_region->source = source;
> +       new_region->source = source - (start - new_region->start);

That also worked on my side.

> 
>         list_add_tail(&new_region->list, &realm_ram_regions);
>  }
> ---8<---
> 
> Thanks for the pointer, and I'll try to remember to include initrd
> testing in future.
> 

Very well.

Thanks for looking into this.

> Steve
> 


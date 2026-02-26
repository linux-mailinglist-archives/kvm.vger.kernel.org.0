Return-Path: <kvm+bounces-72071-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UD1iJF6foGlVlAQAu9opvQ
	(envelope-from <kvm+bounces-72071-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 20:30:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 00A251AE5C1
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 20:30:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BBB8B305A206
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 19:27:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 919AB44CF55;
	Thu, 26 Feb 2026 19:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="hJ1eiqtB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D192441045
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 19:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772134028; cv=none; b=qH5QS41X06RjRfmzTnOlwc5PwH3tzZ29qSEF2lnE+4Xz1JHxtm+hfuCtrCHEqz9MlJ8FSAP9iORZ3+I/xq+Wx6HpMqsEd5DROlYT36TD/w8ooI+/o5cdVw+3Ej+cKu5ZL8oAuxEhb76Tq2Nw1fq4UugyOgRq/B9vCKLVzd4u/28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772134028; c=relaxed/simple;
	bh=pTOdXcn8havDpB/nGx2tDUoWLjBch4ocjJIaSDJa3XQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fVLM9wa5vDC+w3wPL6uTFk57Vuay7zdQ8+3txtd/BPfyFHPG9wEx2KOIKHFzCH/Yn3TErJ8z2d73LWZCDo5Sbgs60HkjgNhTsoKD7o9FWpelch+o+b9vQd2MqQlQDblImMdB94zywv18a5xa0ZNrHBbql90Z2gmo/a+o7nurNHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=hJ1eiqtB; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-506a747448dso10595341cf.0
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 11:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1772134022; x=1772738822; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ihQ/rPzUFVaXq5y8xpMnCIhxlDxECF6mdQTm7Xamdb4=;
        b=hJ1eiqtBMluNLFzTzgOQwS6SoquoUsuMokHZ02Qts55k9h/bIQ6Si9pbTtn4nQw3ry
         i0cpYT01wyhV1SZbUlZA1689k/gUP71L34IhTuHkjpvcvVdv17TRjKCPtJ+BpSN/sq1j
         w0z3SbfAQeaoXaYWGyi3+yGaT1drR4Ni+IyX1zUPgQYmSTUc8+vLaRGlOsub98u/ugIu
         cuDbDY55nPMsEkEfcXZpUFw1Dd7CT4dr+bG9UNbgZ+ftYD7yLahKs+D5r6bVK8eou05Q
         5T8595G3JMobkYWuuz5q0DwP1qVaNKmK9/ORgRxGcrC3wF8ZD9XU/OlLnhTMwLK5dtnj
         k+kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772134022; x=1772738822;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ihQ/rPzUFVaXq5y8xpMnCIhxlDxECF6mdQTm7Xamdb4=;
        b=p0ONxSc8xpPRmAZpJI06UcgmH7NgERurScZq+9QVLjGWiSuDWDofFz2grAfKDC0yGp
         /edDMIwltkGaKOn4nBr9mK3DGHgmmOv099wT7vAEH1K5nd+bKWEXEf3ryDT5zen1Bibk
         gaMtgLmVVjXsGA6hqz9o8oTvRi3Y/m9+0JsdhBVttkK55xIhV9KwETYty05h6Z31+U7b
         GIVOSHenFlAyGBBGB1rhXr/0Tnmtx/A+lMASdKMwdzdKNVShWOBr37dr6cNCqGNTHV4l
         VSDpWyHv1vu+oyasxUo2URGt8709RgtAKQGGImJdnk9RUbxlR6Uk7diJw6w/lf6aHdkk
         WLVw==
X-Forwarded-Encrypted: i=1; AJvYcCXs6XM4y072No/Fus7/+Io553gk5cQ+zK5uvmI/42/lDuAhMLf/m5lRmTh/pBmaSUQPzIc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+eeVAIIPJXpU2rLmrADyEYDvunebiJolFCI7nBMLirXibz6fV
	1vjZfk7kZdMhk3XdytcvZaYLHefoEk1MeCLyIIYLz+rhyifMhQ3N0CwFuwn/npJZcA4=
X-Gm-Gg: ATEYQzyfFvHnxYz52jJysAtMjWVwqhek1ZnaxX7CmWfCvVo71tFBxBPTNNSUENQ0Yr4
	Knpz68+kGWOMfo61c8W2p2fFx2S6b+V/GKitgJ/Cb2X0po5f/SUaqMYJrP58ZwClzn+ShWqnlC7
	h/EeaW/3QBh40+uuyGVpJ98E6juHF7gmwkGITBRekBd7E7XpABEETeV5BrVbxuEko8Qwc6rMpXF
	OiMvy1UdrSBvkChadN6+6inJkzM/+pZKcZ3tOIqiOKT3UU2X4BYpX3nj6spZzgBgxeWD0dCCUvT
	UxR/pRDig5PGcz53JSDBn/+DRVOfmp50t6jJRgWLZE5FuHHgyXRTXCFb6YB4a1KFMgOVZBDFseu
	UKvD8VhgtdG4QQQ4/FztuGBV3wZrU8kccz81dKmwu5g53cB6YT5DZcDBddVplRWQ0WAPZkaidMA
	2O7ZprvhmkQc85m55bMWg7KHW5MaIYycoLxUGeb4AigNifKNUviE3J3uGkS4SZUAI1iq0/+g07+
	R+9M0Wl
X-Received: by 2002:ac8:7d90:0:b0:501:17a1:4ccf with SMTP id d75a77b69052e-50752714463mr1505241cf.3.1772134022105;
        Thu, 26 Feb 2026 11:27:02 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c73a25e4sm23606076d6.50.2026.02.26.11.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 11:27:01 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vvh0m-00000000ODe-3htA;
	Thu, 26 Feb 2026 15:27:00 -0400
Date: Thu, 26 Feb 2026 15:27:00 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Steve Sistare <steven.sistare@oracle.com>,
	Nicolin Chen <nicolinc@nvidia.com>, iommu@lists.linux.dev,
	linux-coco@lists.linux.dev, Dan Williams <dan.j.williams@intel.com>,
	Santosh Shukla <santosh.shukla@amd.com>,
	"Pratik R . Sampat" <prsampat@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Fuad Tabba <tabba@google.com>, Xu Yilun <yilun.xu@linux.intel.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: Re: [RFC PATCH kernel] iommufd: Allow mapping from KVM's guest_memfd
Message-ID: <20260226192700.GB44359@ziepe.ca>
References: <20260225075211.3353194-1-aik@amd.com>
 <aZ7-tTpobKiCFT5L@google.com>
 <fb10affb-40d5-4558-b64b-0ab22659ccf2@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb10affb-40d5-4558-b64b-0ab22659ccf2@amd.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[ziepe.ca:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72071-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[ziepe.ca:+];
	DMARC_NA(0.00)[ziepe.ca];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@ziepe.ca,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,ziepe.ca:mid,ziepe.ca:dkim]
X-Rspamd-Queue-Id: 00A251AE5C1
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 05:47:50PM +1100, Alexey Kardashevskiy wrote:
> 
> 
> On 26/2/26 00:55, Sean Christopherson wrote:
> > On Wed, Feb 25, 2026, Alexey Kardashevskiy wrote:
> > > For the new guest_memfd type, no additional reference is taken as
> > > pinning is guaranteed by the KVM guest_memfd library.
> > > 
> > > There is no KVM-GMEMFD->IOMMUFD direct notification mechanism as
> > > the assumption is that:
> > > 1) page stage change events will be handled by VMM which is going
> > > to call IOMMUFD to remap pages;
> > > 2) shrinking GMEMFD equals to VM memory unplug and VMM is going to
> > > handle it.
> > 
> > The VMM is outside of the kernel's effective TCB.  Assuming the VMM will always
> > do the right thing is a non-starter.
> 
> Right.
> 
> But, say, for 1), VMM does not the right thing and skips on PSC -
> the AMD host will observe IOMMU fault events - noisy but harmless. I
> wonder if it is different for others though.

ARM is also supposed to be safe as GPT faults are contained, IIRC.

However, it is not like AMD in many important ways here. Critically ARM
has a split guest physical space where the low addresses are all
private and the upper addresses are all shared.

Thus on Linux the iommu should be programed with the shared pages
mapped into the shared address range. It would be wasteful to program
it with large amounts of IOPTEs that are already know to be private.

I think if you are fully doing in-place conversion then you could
program the entire shared address range to point to the memory pool
(eg with 1G huge pages) and rely entirely on the GPT to arbitrate
access. I don't think that is implemented in Linux though?

While on AMD, IIRC, the iommu should be programed with both the shared
and private pages in the respective GPA locations, but due to the RMP
matching insanity you have to keep restructuring the IOPTEs to exactly
match the RMP layout.

I have no idea what Intel needs.

Jason


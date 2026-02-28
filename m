Return-Path: <kvm+bounces-72251-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4GRECKwxomke0wQAu9opvQ
	(envelope-from <kvm+bounces-72251-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 01:07:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BA6B31BF56D
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 01:07:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D903D30ECBCB
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:06:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D87BD3C1F;
	Sat, 28 Feb 2026 00:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="dkzrgaMg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDD170830
	for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 00:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772237194; cv=none; b=CpoaAcofMf6AlEubHLhc01BwgofrM6maHEHPUPjemded2Xu40PY+OE/+QZtkP/ZchxVrdZrekQxXlcd4xoCPR6/JiY95gB5WmSKxhTlMdCFRhekfucraR7HXbBUbxRfAtk7RZU10yDET7coBhKNuWoXH61PhAUp7tZqaMN4EHiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772237194; c=relaxed/simple;
	bh=D9pygYo/MNi4R02Zm4iGOoF0L2rPsDKjb9gvCd6vgKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uLxxDQX/0EBoxf3LuRpWyGNbIgS8isTmHfRNnj1C0xFlNOrl8W4U13Hq83CptTa+ho85jESBAM5p1wuduwzPxQVmk+ENFEGzX51c1pZ//4XOHPgqFUuNPI+pVe8pd3941/67YVyVPMCd3rykrZsifKfNpNykHfUvHdHEW38YGII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=dkzrgaMg; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8cb3dfb3461so253028385a.3
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 16:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1772237192; x=1772841992; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S0PqAr3dacsxbzSna3ChPqWEVOFqnIEsALZmA66GjLs=;
        b=dkzrgaMgalXVIq4VPm3pXWlfPaLhWVRII9QYSEEY7PMPFc8NcZANNZNC5sb+GOcz12
         c1YIlimtlvGmKWT2ED6wfQvN9ZQRaLofd/EeTaL/GSjb+xJ0gZYQ2A/g3qPH1mV+M9my
         v/fNbyTsbn/p7nxxYsCRb5oOWX8kYPvYZx0NVVxr7DQkZjQz8mBfbcP49XDi69hjRWfY
         NxinZF224MnEr73E4RGAntwf7YBh3xXNkhWt6k7rnYdg6j1AY3dVA5Db312Eg3J2k7Dw
         EMgArEKxeb+xKIbp7ibIkmlMZztWdURA3Dz16+kVHBV2WplIeI/PjNlpT/HkFKyjXUnf
         nNjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772237192; x=1772841992;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S0PqAr3dacsxbzSna3ChPqWEVOFqnIEsALZmA66GjLs=;
        b=Vvt+/7P44kIRDap2esmRRbUUjmSUwg2n/Y3uVz1DaCyPSbONxxBc8SAUAeJqvK2WMN
         pqetCox+xj8rdp3GjdK4iVtcEWTb+KRhUvpcgk1HTsInEFQktWmDEJ5xeBh/iu7ecN1B
         tepRsGUqv7GMIoLV7Gqj3h1sJzs97J+Ni5BtdMQcnItT7hI9HwJF50aAp9mireQS1Y0A
         ao4HaKc4met0ctfBw4I4U51lAbY0j9Lf+xfNzA09eYndq6Mjm3XXPWBnauc3zXiMMDFa
         wM5mn699p5ouSEpFI6H2Ktkft+cmFkjxsXWEmNdnKM1272sHCyH1Nz9ayGN0XoGW4BDD
         ut4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWDHi99B+5tXG0LWs1EH5QagtzzH9wvAXWRsbcY34zLTtul/WjMTXBW4Hrm4IOF3muCsbw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwO1yOzeDs4HXC71wOhf6YJ1J+0EMluN92ckn03FSlTxiO/amu2
	6IcsNhcUYAeAsy9xWOjP2s20QOpEISsyw78BdYOrzZjh2CgRU/MaC0XxNxrQI0PLfOI=
X-Gm-Gg: ATEYQzx/jqy6iu+w13JJKIJBQg5edwLLl7QaiT19Gke/Pf4DnbiJ7e/Na+5YTRWcvk7
	rRCXySNhEyPl+9vuO8gwvQ1NgYKu2l+JbQhjKixM1WyHeugnc+I+j708AB+3sLKUEIDhrpXsrNQ
	5HMwUz44nxQRaGuTFcShKGXNPS/6jVz6c1UmxJHvg3boiPQz/j1KBioydtnvJDUdj0v1SNhFzl+
	KHOw+T4ysyH289zqFS8hTJ0NKRaorW395Sc7f6SpQe81Z1xPfvRheg1GU6DO7Ota7OHpS/DKxEy
	9LeC9/BmUTrhFoEBm7xNOTsujIJaN4OhZX5Xmnx9805tzpT/m7WTAcsh4yBPpny7PypZjCIQVx9
	in436SIUCCKoUWt/eaZH17BxeEMXGRC+eCIFJRpysrstgUo9eB3XB55KUlwzq4U2YWq1PEFaC4E
	M/nN/q7F/sYDxbBvGxNLISvVMqi8wCl+xGPPEytOaAnsvoOXiJZAwcJj8shzSZi2kWCJBjUM8oA
	i4Qh5Vq
X-Received: by 2002:a05:620a:1a92:b0:8c7:b0d:df23 with SMTP id af79cd13be357-8cbc8e39692mr613986085a.79.1772237191471;
        Fri, 27 Feb 2026 16:06:31 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf72d3casm601180485a.42.2026.02.27.16.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 16:06:30 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vw7qo-00000001WqD-1LkU;
	Fri, 27 Feb 2026 20:06:30 -0400
Date: Fri, 27 Feb 2026 20:06:30 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Alexey Kardashevskiy <aik@amd.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-pci@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Mike Rapoport <rppt@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Melody Wang <huibo.wang@amd.com>,
	Seongman Lee <augustus92@kaist.ac.kr>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Andi Kleen <ak@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Denis Efremov <efremov@linux.com>,
	Geliang Tang <geliang@kernel.org>,
	Piotr Gregor <piotrgregor@rsyncme.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Arnd Bergmann <arnd@arndb.de>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Yinghai Lu <yinghai@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Kim Phillips <kim.phillips@amd.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Claire Chang <tientzu@chromium.org>, linux-coco@lists.linux.dev,
	iommu@lists.linux.dev, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH kernel 6/9] x86/dma-direct: Stop changing encrypted page
 state for TDISP devices
Message-ID: <20260228000630.GN44359@ziepe.ca>
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-7-aik@amd.com>
 <d8102507-e537-4e7c-8137-082a43fd270d@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8102507-e537-4e7c-8137-082a43fd270d@arm.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[ziepe.ca:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[ziepe.ca:+];
	TAGGED_FROM(0.00)[bounces-72251-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[ziepe.ca];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@ziepe.ca,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_GT_50(0.00)[59];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BA6B31BF56D
X-Rspamd-Action: no action

On Wed, Feb 25, 2026 at 05:08:37PM +0000, Robin Murphy wrote:

> I guess this comes back to the point I just raised on the previous patch -
> the current assumption is that devices cannot access private memory at all,
> and thus phys_to_dma() is implicitly only dealing with the mechanics of how
> the given device accesses shared memory. Once that no longer holds, I don't
> see how we can find the right answer without also consulting the relevant
> state of paddr itself, and that really *should* be able to be commonly
> abstracted across CoCo environments. 

Definately, I think building on this is a good place to start

https://lore.kernel.org/all/20260223095136.225277-2-jiri@resnulli.us/

Probably this series needs to take DMA_ATTR_CC_DECRYPTED and push it
down into the phys_to_dma() and make the swiotlb shared allocation
code force set it.

But what value is stored in the phys_addr_t for shared pages on the
three arches? Does ARM and Intel set the high GPA/IPA bit in the
phys_addr or do they set it through the pgprot? What does AMD do?

ie can we test a bit in the phys_addr_t to reliably determine if it is
shared or private?

> > pci_device_add() enforces the FFFF_FFFF coherent DMA mask so
> > dma_alloc_coherent() fails when SME=on, this is how I ended up fixing
> > phys_to_dma() and not quite sure it is the right fix.

Does AMD have the shared/private GPA split like ARM and Intel do? Ie
shared is always at a high GPA? What is the SME mask?

Jason


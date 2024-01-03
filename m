Return-Path: <kvm+bounces-5588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 143CD82340D
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 19:00:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 68CAEB235A6
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 18:00:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AF5F1C683;
	Wed,  3 Jan 2024 18:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y0/+ZMDa"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53821C28A
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 18:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704304821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q48P5QWzofCocco3NZ1i12qdR2cjUhLN4nZ2fO8zD3Y=;
	b=Y0/+ZMDa83jCTFmx1TFn3J3D/rZtn90CmI2cGGM+e0yer4wYlZ5kSex4hGFwlmcxyx7Lx/
	2pNB3300kuTocnl2X8HadBdKMWCWzQf5MAeibmfGtj429fBBZtiJPC89EZwX3I4B/cK0wc
	jyIttyY3Vu4tSjqDxkmkVv969KkYluw=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-FchHfVrdNjmjibt3BUOiMw-1; Wed, 03 Jan 2024 13:00:20 -0500
X-MC-Unique: FchHfVrdNjmjibt3BUOiMw-1
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-6dc0380f07eso6981067a34.0
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 10:00:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704304820; x=1704909620;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q48P5QWzofCocco3NZ1i12qdR2cjUhLN4nZ2fO8zD3Y=;
        b=qJUgog9Ynj3GeE6+Gn5M7QWYyeNJ77szv6/nYDQH633412eG60FmGSRvaSOSxsnrCl
         iGTDR27+SZvWjoBO08c4F1vjJH9+OXVaz3n9ojCVTvH811zK60nd7DghExJKzd/dAm/1
         MSIUVaYLgGH3wIOCmuxgakpz9ZXpbQ7nV7V8l5J1MTvz+CRpUaZh/zJidYd3kPtIM10L
         7vgd+2ZbGxHXOryhNgpbz4sCB5/FFiPSXn50akXdU2NyuaKsXd2KnS8WwFZ+FTc63+i1
         YZTt/TzNqF2LL95vdkreHdK/kxcLCPB2/GhGEHKpKnpyhndwNQVnL1TRECqBoYoCfCtb
         sg+A==
X-Gm-Message-State: AOJu0YzU7Pp1A9N3XVjVNEwJ/9k1KiBJZB5LbJu7kpHWs5vWRkSBNz4s
	A01PtEwvixhc6cA9pmAaaSOWnQGy6AKKc7DIf5fi/EjDAEF1p1xrsMZf4jtkOOT2bZzQ1BplcpR
	8iG5fG8yNZbczIn508Urk
X-Received: by 2002:a05:6830:349e:b0:6dc:3c65:2a7f with SMTP id c30-20020a056830349e00b006dc3c652a7fmr6003213otu.63.1704304819631;
        Wed, 03 Jan 2024 10:00:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEEnrcYn02XEmEIDEKFS5J+2ENvYFdJ67qmKLK8qDffDVVpRpUZ5pkWF9XzX4EQRd6bhSNjaQ==
X-Received: by 2002:a05:6830:349e:b0:6dc:3c65:2a7f with SMTP id c30-20020a056830349e00b006dc3c652a7fmr6003182otu.63.1704304819321;
        Wed, 03 Jan 2024 10:00:19 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id w5-20020a9d6385000000b006dc0363d57csm2371548otk.6.2024.01.03.10.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jan 2024 10:00:18 -0800 (PST)
Date: Wed, 3 Jan 2024 11:00:16 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 "shameerali.kolothum.thodi@huawei.com"
 <shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
 <kevin.tian@intel.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
 "brett.creeley@amd.com" <brett.creeley@amd.com>, "horms@kernel.org"
 <horms@kernel.org>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
 <cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, "Anuj
 Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 1/1] vfio/nvgrace-gpu: Add vfio pci variant module
 for grace hopper
Message-ID: <20240103110016.5067b42e.alex.williamson@redhat.com>
In-Reply-To: <20240103165727.GQ50406@nvidia.com>
References: <20231217191031.19476-1-ankita@nvidia.com>
	<20231218151717.169f80aa.alex.williamson@redhat.com>
	<BY5PR12MB3763179CAC0406420AB0C9BAB095A@BY5PR12MB3763.namprd12.prod.outlook.com>
	<20240102091001.5fcc8736.alex.williamson@redhat.com>
	<20240103165727.GQ50406@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 3 Jan 2024 12:57:27 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Jan 02, 2024 at 09:10:01AM -0700, Alex Williamson wrote:
> 
> > Yes, it's possible to add support that these ranges honor the memory
> > enable bit, but it's not trivial and unfortunately even vfio-pci isn't
> > a great example of this.  
> 
> We talked about this already, the HW architects here confirm there is
> no issue with reset and memory enable. You will get all 1's on read
> and NOP on write. It doesn't need to implement VMA zap.

We talked about reset, I don't recall that we discussed that coherent
and uncached memory ranges masquerading as PCI BARs here honor the
memory enable bit in the command register.

> > around device reset or relative to the PCI command register.  The
> > variant driver becomes a trivial implementation that masks BARs 2 & 4
> > and exposes the ACPI range as a device specific region with only mmap
> > support.  QEMU can then map the device specific region into VM memory
> > and create an equivalent ACPI table for the guest.  
> 
> Well, no, probably not. There is an NVIDIA specification for how the
> vPCI function should be setup within the VM and it uses the BAR
> method, not the ACPI.

Is this specification available?  It's a shame we've gotten this far
without a reference to it.

> There are a lot of VMMs and OSs this needs to support so it must all
> be consistent. For better or worse the decision was taken for the vPCI
> spec to use BAR not ACPI, in part due to feedback from the broader VMM
> ecosystem, and informed by future product plans.
> 
> So, if vfio does special regions then qemu and everyone else has to
> fix it to meet the spec.

Great, this is the sort of justification and transparency that had not
been previously provided.  It is curious that only within the past
couple months the device ABI changed by adding the uncached BAR, so
this hasn't felt like a firm design.  Also I believe it's been stated
that the driver supports both the bare metal representation of the
device and this model where the coherent memory is mapped as a BAR, so
I'm not sure what obstacles remain or how we're positioned for future
products if take the bare metal approach.

> > I know Jason had described this device as effectively pre-CXL to
> > justify the coherent memory mapping, but it seems like there's still a
> > gap here that we can't simply hand wave that this PCI BAR follows a
> > different set of semantics.    
> 
> I thought all the meaningful differences are fixed now?
> 
> The main remaining issue seems to be around the config space
> emulation?

In the development of the virtio-vfio-pci variant driver we noted that
r/w access to the IO BAR didn't honor the IO bit in the command
register, which was quickly remedied and now returns -EIO if accessed
while disabled.  We were already adding r/w support to the coherent BAR
at the time as vfio doesn't have a means to express a region as only
having mmap support and precedent exists that BAR regions must support
these accesses.  So it was suggested that r/w accesses should also
honor the command register memory enable bit, but of course memory BARs
also support mmap, which snowballs into a much more complicated problem
than we have in the case of the virtio IO BAR.

So where do we go?  Do we continue down the path of emulating full PCI
semantics relative to these emulated BARs?  Does hardware take into
account the memory enable bit of the command register?  Do we
re-evaluate the BAR model for a device specific region?

> > We don't typically endorse complexity in the kernel only for the
> > purpose of avoiding work in userspace.  The absolute minimum should
> > be some justification of the design decision and analysis relative
> > to standard PCI behavior.  Thanks,  
> 
> If we strictly took that view in VFIO a lot of stuff wouldn't be here
> :)
> 
> I've made this argument before and gave up - the ecosystem wants to
> support multiple VMMs and the sanest path to do that is via VFIO
> kernel drivers that plug into existing vfio-pci support in the VMM
> ecosystem.
> 
> From a HW supplier perspective it is quite vexing to have to support
> all these different (and often proprietary!) VMM implementations. It
> is not just top of tree qemu.
> 
> If we instead did complex userspace drivers and userspace emulation of
> config space and so on then things like the IDXD SIOV support would
> look *very* different and not use VFIO at all. That would probably be
> somewhat better for security, but I was convinced it is a long and
> technically complex road.
> 
> At least with this approach the only VMM issue is the NUMA nodes, and
> as we have discussed that hackery is to make up for current Linux
> kernel SW limitations, not actually reflecting anything about the
> HW. If some other OS or future Linux doesn't require the ACPI NUMA
> nodes to create an OS visible NUMA object then the VMM will not
> require any changes.

Yes, I'm satisfied with where we've landed for the NUMA nodes and
generic initiator object.  It's an annoying constraint for management
tools but it's better than the original proposal where nodes
automatically popped into existence based on a vfio-pci device. 

There's certainly a balancing game of complexity in the driver vs
deferring the work to userspace.  From my perspective, I don't have a
good justification for why we're on the emulated BAR path when another
path looks a lot easier.  With the apparent increasing complexity of
emulating the memory enable semantics, I felt we needed to get a better
story there and really look at whether those semantics are worthwhile,
or perhaps as alluded, HW takes this into account (though I'm not sure
how).

I'd suggest we take a look at whether we need to continue to pursue
honoring the memory enable bit for these BARs and make a conscious and
documented decision if we choose to ignore it.  Ideally we could also
make this shared spec that we're implementing to available to the
community to justify the design decisions here.  In the case of
GPUDirect Cliques we had permission to post the spec to the list so it
could be archived to provide a stable link for future reference.
Thanks,

Alex



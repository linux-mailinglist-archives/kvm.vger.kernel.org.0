Return-Path: <kvm+bounces-5604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 10A3582399D
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 01:24:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7043D1F26110
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 00:24:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB5BF4C89;
	Thu,  4 Jan 2024 00:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IRjzeTwm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3797F4432
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 00:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704327871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jPW79gS2Q4P8ctw9avR6IJ5fl8Ns1nGbXMFhQOH5gSA=;
	b=IRjzeTwmLrcWhdUN2phNHARYLWFrrrdafBhXNiHUFawbpkIDTqz6FwWk6+X8piesQ93xwm
	B7U9KH4TCN9oIqHCmY0hhlXGrWbSlBqG1BwB9Opj/teXXzw7ooeixodqROpBaMfN0eTND8
	MshAD50I+l5nBBv2F+8SVZxhG5CEzz4=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-49-3-n6ug2zNxmUSi4yc_L4jg-1; Wed, 03 Jan 2024 19:24:29 -0500
X-MC-Unique: 3-n6ug2zNxmUSi4yc_L4jg-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7ba9fee55d4so1324106239f.1
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 16:24:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704327869; x=1704932669;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jPW79gS2Q4P8ctw9avR6IJ5fl8Ns1nGbXMFhQOH5gSA=;
        b=TmFD28YJpnKzPbcBzwPNUrvqnUWns+Tgpovi/pFafT2tpPSjYUZJBC7n/3mjcXYdh5
         NBlBJCbscga4FEaS8Qv/QO2ldhftJXLQ1LLW0u8X9XSV9zff7u0m4VoqpsOAZFyVmac/
         bNvw41ZxGgzqzrj03mz5CqLJBBmuskG0BES1DsdT3FGvZqwFFFaIv0Axp3E79disk0WJ
         VTit6D/1ZKRZFyWmnvLcEElv5NklBEIzPY0/eyzVUp2/3pbf7eY29TM9dltS8POw5tce
         kQhOJ2xi+c7veNuRuApa1V8hWkqYEbVX88rOiu3/ntRdVXcaTFaxpwVy7au/WmjoiJGd
         0xPA==
X-Gm-Message-State: AOJu0Yzkufi7EYobEfeGiz+xtB8s/pWQq3BMuVv2YOSYnfRwzs1twsaw
	p3d5emrKV8UXp+erW4562XoChR6G8uH9uYrPNznTL1a757YJNvRWFZejTSa4WzuvJQOyP9clPlJ
	gIZWGVdMs8bUAXPn6Geup
X-Received: by 2002:a05:6602:b96:b0:7ba:9b52:51d7 with SMTP id fm22-20020a0566020b9600b007ba9b5251d7mr30855593iob.36.1704327869054;
        Wed, 03 Jan 2024 16:24:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGkousEDb/61LEJsFV53l0IRvnbM9f5cerV0Fovar4DTBIZM3cSDktvcG6KsM+U64Ce/9BetA==
X-Received: by 2002:a05:6602:b96:b0:7ba:9b52:51d7 with SMTP id fm22-20020a0566020b9600b007ba9b5251d7mr30855568iob.36.1704327868764;
        Wed, 03 Jan 2024 16:24:28 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id z4-20020a056638318400b0046d6b3edd2asm4667268jak.132.2024.01.03.16.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jan 2024 16:24:28 -0800 (PST)
Date: Wed, 3 Jan 2024 17:24:26 -0700
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
Message-ID: <20240103172426.0a1f4ae6.alex.williamson@redhat.com>
In-Reply-To: <20240103193356.GU50406@nvidia.com>
References: <20231217191031.19476-1-ankita@nvidia.com>
	<20231218151717.169f80aa.alex.williamson@redhat.com>
	<BY5PR12MB3763179CAC0406420AB0C9BAB095A@BY5PR12MB3763.namprd12.prod.outlook.com>
	<20240102091001.5fcc8736.alex.williamson@redhat.com>
	<20240103165727.GQ50406@nvidia.com>
	<20240103110016.5067b42e.alex.williamson@redhat.com>
	<20240103193356.GU50406@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 3 Jan 2024 15:33:56 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Jan 03, 2024 at 11:00:16AM -0700, Alex Williamson wrote:
> > On Wed, 3 Jan 2024 12:57:27 -0400
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >  =20
> > > On Tue, Jan 02, 2024 at 09:10:01AM -0700, Alex Williamson wrote:
> > >  =20
> > > > Yes, it's possible to add support that these ranges honor the memory
> > > > enable bit, but it's not trivial and unfortunately even vfio-pci is=
n't
> > > > a great example of this.   =20
> > >=20
> > > We talked about this already, the HW architects here confirm there is
> > > no issue with reset and memory enable. You will get all 1's on read
> > > and NOP on write. It doesn't need to implement VMA zap. =20
> >=20
> > We talked about reset, I don't recall that we discussed that coherent
> > and uncached memory ranges masquerading as PCI BARs here honor the
> > memory enable bit in the command register. =20
>=20
> Why do it need to do anything special? If the VM read/writes from
> memory that the master bit is disabled on it gets undefined
> behavior. The system doesn't crash and it does something reasonable.

The behavior is actually defined (6.0.1 Table 7-4):

    Memory Space Enable - Controls a Function's response to Memory
    Space accesses. When this bit is Clear, all received Memory Space
    accesses are caused to be handled as Unsupported Requests. When
    this bit is Set, the Function is enabled to decode the address and
    further process Memory Space accesses.

=46rom there we get into system error handling decisions where some
platforms claim to protect data integrity by generating a fault before
allowing drivers to consume the UR response and others are more lenient.

The former platforms are the primary reason that we guard access to the
device when the memory enable bit is cleared.  It seems we've also
already opened the door somewhat given our VF behavior, where we test
pci_dev.no_command_memory to allow access regardless of the state of
the emulated command register bit.

AIUI, the address space enable bits are primarily to prevent the device
from decoding accesses during BAR sizing operations or prior to BAR
programming.  BAR sizing operations are purely emulated in vfio-pci and
unprogrammed BARs are ignored (ie. not exposed to userspace), so perhaps
as long as it can be guaranteed that an access with the address space
enable bit cleared cannot generate a system level fault, we actually
have no strong argument to strictly enforce the address space bits.

> > > > around device reset or relative to the PCI command register.  The
> > > > variant driver becomes a trivial implementation that masks BARs 2 &=
 4
> > > > and exposes the ACPI range as a device specific region with only mm=
ap
> > > > support.  QEMU can then map the device specific region into VM memo=
ry
> > > > and create an equivalent ACPI table for the guest.   =20
> > >=20
> > > Well, no, probably not. There is an NVIDIA specification for how the
> > > vPCI function should be setup within the VM and it uses the BAR
> > > method, not the ACPI. =20
> >=20
> > Is this specification available?  It's a shame we've gotten this far
> > without a reference to it. =20
>=20
> No, at this point it is internal short form only.
>=20
> > > There are a lot of VMMs and OSs this needs to support so it must all
> > > be consistent. For better or worse the decision was taken for the vPCI
> > > spec to use BAR not ACPI, in part due to feedback from the broader VMM
> > > ecosystem, and informed by future product plans.
> > >=20
> > > So, if vfio does special regions then qemu and everyone else has to
> > > fix it to meet the spec. =20
> >=20
> > Great, this is the sort of justification and transparency that had not
> > been previously provided.  It is curious that only within the past
> > couple months the device ABI changed by adding the uncached BAR, so
> > this hasn't felt like a firm design. =20
>=20
> That is to work around some unfortunate HW defect, and is connected to
> another complex discussion about how ARM memory types need to
> work. Originally people hoped this could simply work transparently but
> it eventually became clear it was not possible for the VM to degrade
> from cachable without VMM help. Thus a mess was born..
>=20
> > Also I believe it's been stated that the driver supports both the
> > bare metal representation of the device and this model where the
> > coherent memory is mapped as a BAR, so I'm not sure what obstacles
> > remain or how we're positioned for future products if take the bare
> > metal approach. =20
>=20
> It could work, but it is not really the direction that was decided on
> for the vPCI functions.
>=20
> > > I thought all the meaningful differences are fixed now?
> > >=20
> > > The main remaining issue seems to be around the config space
> > > emulation? =20
> >=20
> > In the development of the virtio-vfio-pci variant driver we noted that
> > r/w access to the IO BAR didn't honor the IO bit in the command
> > register, which was quickly remedied and now returns -EIO if accessed
> > while disabled.  We were already adding r/w support to the coherent BAR
> > at the time as vfio doesn't have a means to express a region as only
> > having mmap support and precedent exists that BAR regions must support
> > these accesses.  So it was suggested that r/w accesses should also
> > honor the command register memory enable bit, but of course memory BARs
> > also support mmap, which snowballs into a much more complicated problem
> > than we have in the case of the virtio IO BAR. =20
>=20
> I think that has just become too pedantic, accessing the regions with
> the enable bits turned off is broadly undefined behavior. So long as
> the platform doesn't crash, I think it is fine to behave in a simple
> way.
>=20
> There is no use case for providing stronger emulation of this.

As above, I think I can be convinced this is acceptable given that the
platform and device are essentially one in the same here with
understood lack of a system wide error response.

Now I'm wondering if we should do something different with
virtio-vfio-pci.  As a VF, the memory space is effectively always
enabled, governed by the SR-IOV MSE bit on the PF which is assumed to
be static.  It doesn't make a lot of sense to track the IO enable bit
for the emulated IO BAR when the memory BAR is always enabled.  It's a
fairly trivial amount of code though, so it's not harmful either.

> > So where do we go?  Do we continue down the path of emulating full PCI
> > semantics relative to these emulated BARs?  Does hardware take into
> > account the memory enable bit of the command register?  Do we
> > re-evaluate the BAR model for a device specific region? =20
>=20
> It has to come out as a BAR in the VM side so all of this can't be
> avoided. The simple answer is we don't need to care about enables
> because there is no reason to care. VMs don't write to memory with the
> enable turned off because on some platforms you will crash the system
> if you do that.
>=20
> > I'd suggest we take a look at whether we need to continue to pursue
> > honoring the memory enable bit for these BARs and make a conscious and
> > documented decision if we choose to ignore it. =20
>=20
> Let's document it.

Ok, I'd certainly appreciate more background around why it was chosen
to expose the device differently than bare metal in the commit log and
code comments and in particular why we're consciously choosing not to
honor these specific PCI semantics.  Presumably we'd remove the -EIO
from the r/w path based on the memory enable state as well.

> > Ideally we could also make this shared spec that we're implementing
> > to available to the community to justify the design decisions here.
> > In the case of GPUDirect Cliques we had permission to post the spec
> > to the list so it could be archived to provide a stable link for
> > future reference.  Thanks, =20
>=20
> Ideally. I'll see that people consider it at least.

Yep, I think it would have helped move this driver along if such a
document had been shared earlier for the sake of transparency rather
than leaving us to speculate on the motivation and design.  Thanks,

Alex



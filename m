Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F943A4AAD
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 23:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhFKVky (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 17:40:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50234 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229685AbhFKVkx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Jun 2021 17:40:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623447534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C6IliJr15GgETFgAUbqX8vnW2P0SKmHz1sKoUHwwIt0=;
        b=HiQfqxwrRGWYHfW9TwblmbKPwM/aNCEsKpomsKuF7zaAes10uDSgn6PClvufIR0zjzTvia
        IZzbNMbcB31yyaZN3En2M71FPk1/f8KRl4kDREfpCZDIdxyL7YWmj+3Fzc8XL3g507/Zrs
        HzB9xedscD3gkB24i5ceZNVVv0CxUa0=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-TyQdOy7YM3mAYbcCH3_OQQ-1; Fri, 11 Jun 2021 17:38:53 -0400
X-MC-Unique: TyQdOy7YM3mAYbcCH3_OQQ-1
Received: by mail-ot1-f70.google.com with SMTP id 108-20020a9d0bf50000b02903d55be6ada3so2671793oth.22
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 14:38:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=C6IliJr15GgETFgAUbqX8vnW2P0SKmHz1sKoUHwwIt0=;
        b=m/5mvlIop4RN+toiwnkZ2Sh1TveC+6yityoDsxnVHbyNrJcuDUXu0W6fre9ur03bDD
         QGGBXAePtR1InbMzWqjs7hZRyTHxWU0Rwqnmnb18HCsXy4fN6b2SbCHDoWD1yLYi9IM/
         LExIQrpxKra/vJs92lM5KOuBk6y+YLzpmLu3qxHUjeO8ph9sqRMzahpzn0DwDWOM3dHz
         G34IbRnZMhNuJGT6Bgf0iiu7NbNzsTDXkB7nVVQFrMuxPbE8zyTFn+VGA6/BgTfWJ7j4
         8aZrlMRtBvXMarAoUnCoAOs/kwYzKTuW6VSGvUDA1BwjqdnzaZC6bd1nKvXbGpgpqLBF
         Jiag==
X-Gm-Message-State: AOAM530Vtbao+MI08dPB2rrCy9TsWGasExYRjh85IdLUf8P46Ja1QrYu
        Ay+SdQM7kOyfM8sxWawvwUepOB3xelZSkf/wxR0pax/guKnzT2+eEAWfP/+u/gnZdCE+8WRQfe8
        XRlHWGrnVntrr
X-Received: by 2002:a9d:6a09:: with SMTP id g9mr4632033otn.222.1623447532706;
        Fri, 11 Jun 2021 14:38:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzwO4XQwFZq3Ozr9IdXuycDxGMvZKCD+Zij0zifoEX00P3Ubr7a91cRLzdWAkxU+66LHIs2Sg==
X-Received: by 2002:a9d:6a09:: with SMTP id g9mr4632009otn.222.1623447532427;
        Fri, 11 Jun 2021 14:38:52 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id q22sm1467015otl.11.2021.06.11.14.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 14:38:52 -0700 (PDT)
Date:   Fri, 11 Jun 2021 15:38:50 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Jason Wang" <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Robin Murphy" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <20210611153850.7c402f0b.alex.williamson@redhat.com>
In-Reply-To: <BN6PR11MB187579A2F88C77ED2131CEF08C349@BN6PR11MB1875.namprd11.prod.outlook.com>
References: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
        <YMCy48Xnt/aphfh3@8bytes.org>
        <20210609123919.GA1002214@nvidia.com>
        <YMDC8tOMvw4FtSek@8bytes.org>
        <20210609150009.GE1002214@nvidia.com>
        <YMDjfmJKUDSrbZbo@8bytes.org>
        <20210609101532.452851eb.alex.williamson@redhat.com>
        <20210609102722.5abf62e1.alex.williamson@redhat.com>
        <20210609184940.GH1002214@nvidia.com>
        <20210610093842.6b9a4e5b.alex.williamson@redhat.com>
        <BN6PR11MB187579A2F88C77ED2131CEF08C349@BN6PR11MB1875.namprd11.prod.outlook.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 11 Jun 2021 00:58:35 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> Hi, Alex,
> 
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Thursday, June 10, 2021 11:39 PM
> > 
> > On Wed, 9 Jun 2021 15:49:40 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Wed, Jun 09, 2021 at 10:27:22AM -0600, Alex Williamson wrote:
> > >  
> > > > > > It is a kernel decision, because a fundamental task of the kernel is to
> > > > > > ensure isolation between user-space tasks as good as it can. And if a
> > > > > > device assigned to one task can interfer with a device of another task
> > > > > > (e.g. by sending P2P messages), then the promise of isolation is  
> > broken.  
> > > > >
> > > > > AIUI, the IOASID model will still enforce IOMMU groups, but it's not an
> > > > > explicit part of the interface like it is for vfio.  For example the
> > > > > IOASID model allows attaching individual devices such that we have
> > > > > granularity to create per device IOASIDs, but all devices within an
> > > > > IOMMU group are required to be attached to an IOASID before they can  
> > be  
> > > > > used.  
> > >
> > > Yes, thanks Alex
> > >  
> > > > > It's not entirely clear to me yet how that last bit gets
> > > > > implemented though, ie. what barrier is in place to prevent device
> > > > > usage prior to reaching this viable state.  
> > >
> > > The major security checkpoint for the group is on the VFIO side.  We
> > > must require the group before userspace can be allowed access to any
> > > device registers. Obtaining the device_fd from the group_fd does this
> > > today as the group_fd is the security proof.
> > >
> > > Actually, thinking about this some more.. If the only way to get a
> > > working device_fd in the first place is to get it from the group_fd
> > > and thus pass a group-based security check, why do we need to do
> > > anything at the ioasid level?
> > >
> > > The security concept of isolation was satisfied as soon as userspace
> > > opened the group_fd. What do more checks in the kernel accomplish?  
> > 
> > Opening the group is not the extent of the security check currently
> > required, the group must be added to a container and an IOMMU model
> > configured for the container *before* the user can get a devicefd.
> > Each devicefd creates a reference to this security context, therefore
> > access to a device does not exist without such a context.  
> 
> IIUC each device has a default domain when it's probed by iommu driver
> at boot time. This domain includes an empty page table, implying that
> device is already in a security context before it's probed by device driver.

The default domain could be passthrough though, right?

> Now when this device is added to vfio, vfio creates another security 
> context through above sequence. This sequence requires the device to
> switch from default security context to this new one, before it can be
> accessed by user.

This is true currently, we use group semantics with the type1 IOMMU
backend to attach all devices in the group to a secure context,
regardless of the default domain.

> Then I wonder whether it's really necessary. As long as a device is in
> a security context at any time, access to a device can be allowed. The
> user itself should ensure that the access happens only after the device
> creates a reference to the new security context that is desired by this
> user.
>
> Then what does group really bring to us?

By definition an IOMMU group is the smallest set of devices that we
can consider isolated from all other devices.  Therefore devices in a
group are not necessarily isolated from each other.  Therefore if any
device within a group is not isolated, the group is not isolated.  VFIO
needs to know when it's safe to provide userspace access to the device,
but the device isolation is dependent on the group isolation.  The
group is therefore part of this picture whether implicit or explicit.

> With this new proposal we just need to make sure that a device cannot
> be attached to any IOASID before all devices in its group are bound to
> the IOASIDfd. If we want to start with a vfio-like policy, then all devices
> in the group must be attached to the same IOASID. Or as Jason suggests,
> they can attach to different IOASIDs (if in the group due to !ACS) if the
> user wants, or have some devices attached while others detached since
> both are in a security context anyway.

But if it's the device attachment to the IOASID that provides the
isolation and the user might attach a device to multiple IOASIDs within
the same IOASIDfd, and presumably make changes to the mapping of device
to IOASID dynamically, are we interrupting user access around each of
those changes?  How would vfio be able to track this, and not only
track it per device, but for all devices in the group.  Suggesting a
user needs to explicitly attach every device in the group is also a
semantic change versus existing vfio, where other devices in the group
must only be considered to be in a safe state for the group to be
usable.

The default domain may indeed be a solution to the problem, but we need
to enforce a secure default domain for all devices in the group.  To me
that suggests that binding the *group* to an IOASIDfd is the point at
which device access becomes secure.  VFIO should be able to consider
that the IOASIDfd binding has taken over ownership of the DMA context
for the device and it will always be either an empty, isolated, default
domain or a user defined IOASID.

Maybe the model relative to vfio is something like:

 1. bind a group to an IOASIDfd
    VFIO_GROUP_BIND_IOASID_FD(groupfd, ioasidfd)
 2. create an IOASID label for each device
    VFIO_DEVICE_SET_IOASID_LABEL(devicefd, device_ioasid_label)

VFIO can open access to the device after step 1, the IOASIDfd takes
responsibility for the device IOMMU context.  After step 2, shouldn't
the user switch to the IOASID uAPI?  I don't see why vfio would be
involved in attaching devices to specific IOASID contexts within the
IOASIDfd at that point, we might need internal compatibility
interfaces, but a native IOASID user should have all they need to
attach device labels to IOASIDs using the IOASIDfd at this point.

We'll need to figure out what the release model looks like too.  A
group should hold a reference on the IOASIDfd and each open device
should hold a reference on the group so that the isolation of the group
cannot be broken while any device is open.

> > This proposal has of course put the device before the group, which then
> > makes it more difficult for vfio to retroactively enforce security.
> >   
> > > Yes, we have the issue where some groups require all devices to use
> > > the same IOASID, but once someone has the group_fd that is no longer a
> > > security issue. We can fail VFIO_DEVICE_ATTACH_IOASID callss that
> > > don't make sense.  
> > 
> > The groupfd only proves the user has an ownership claim to the devices,
> > it does not itself prove that the devices are in an isolated context.
> > Device access is not granted until that isolated context is configured.
> > 
> > vfio owns the device, so it would make sense for vfio to enforce the
> > security of device access only in a secure context, but how do we know
> > a device is in a secure context?
> > 
> > Is it sufficient to track the vfio device ioctls for attach/detach for
> > an IOASID or will the user be able to manipulate IOASID configuration
> > for a device directly via the IOASIDfd?
> > 
> > What happens on detach?  As we've discussed elsewhere in this thread,
> > revoking access is more difficult than holding a reference to the
> > secure context, but I'm under the impression that moving a device
> > between IOASIDs could be standard practice in this new model.  A device
> > that's detached from a secure context, even temporarily, is a problem.
> > Access to other devices in the same group as a device detached from a
> > secure context is a problem.  
> 
> as long as the device is switched back to the default security context
> after detach then it should be fine.

So long as the default context is secure, and ideally if IOMMU context
switches are atomic.

> > > > > > > Groups should be primarily about isolation security, not about  
> > IOASID  
> > > > > > > matching.  
> > > > > >
> > > > > > That doesn't make any sense, what do you mean by 'IOASID matching'?  
> > > > >
> > > > > One of the problems with the vfio interface use of groups is that we
> > > > > conflate the IOMMU group for both isolation and granularity.  I think
> > > > > what Jason is referring to here is that we still want groups to be the
> > > > > basis of isolation, but we don't want a uAPI that presumes all devices
> > > > > within the group must use the same IOASID.  
> > >
> > > Yes, thanks again Alex
> > >  
> > > > > For example, if a user owns an IOMMU group consisting of
> > > > > non-isolated functions of a multi-function device, they should be
> > > > > able to create a vIOMMU VM where each of those functions has its
> > > > > own address space.  That can't be done today, the entire group
> > > > > would need to be attached to the VM under a PCIe-to-PCI bridge to
> > > > > reflect the address space limitation imposed by the vfio group
> > > > > uAPI model.  Thanks,  
> > > >
> > > > Hmm, likely discussed previously in these threads, but I can't come up
> > > > with the argument that prevents us from making the BIND interface
> > > > at the group level but the ATTACH interface at the device level?  For
> > > > example:
> > > >
> > > >  - VFIO_GROUP_BIND_IOASID_FD
> > > >  - VFIO_DEVICE_ATTACH_IOASID
> > > >
> > > > AFAICT that makes the group ownership more explicit but still allows
> > > > the device level IOASID granularity.  Logically this is just an
> > > > internal iommu_group_for_each_dev() in the BIND ioctl.  Thanks,  
> > >
> > > At a high level it sounds OK.
> > >
> > > However I think your above question needs to be answered - what do we
> > > want to enforce on the iommu_fd and why?
> > >
> > > Also, this creates a problem with the device label idea, we still
> > > need to associate each device_fd with a label, so your above sequence
> > > is probably:
> > >
> > >   VFIO_GROUP_BIND_IOASID_FD(group fd)
> > >   VFIO_BIND_IOASID_FD(device fd 1, device_label)
> > >   VFIO_BIND_IOASID_FD(device fd 2, device_label)
> > >   VFIO_DEVICE_ATTACH_IOASID(..)
> > >
> > > And then I think we are back to where I had started, we can trigger
> > > whatever VFIO_GROUP_BIND_IOASID_FD does automatically as soon as all
> > > of the devices in the group have been bound.  
> > 
> > How to label a device seems like a relatively mundane issue relative to
> > ownership and isolated contexts of groups and devices.  The label is
> > essentially just creating an identifier to device mapping, where the
> > identifier (label) will be used in the IOASID interface, right?  As I  
> 
> Three usages in v2:
> 
> 1) when reporting per-device capability/format info to user;
> 2) when handling device-wide iotlb invalidation from user;
> 3) when reporting device-specific fault data to user;

As above, it seems more complete to me to move attach/detach of devices
to IOASIDs using the labels as well.  Thanks,

Alex


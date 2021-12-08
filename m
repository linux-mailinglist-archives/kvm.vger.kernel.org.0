Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE4246D7B4
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 17:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhLHQKZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 11:10:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:50912 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232138AbhLHQKY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 11:10:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638979612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=msQ0FSkz32V6T/y/AuAdwbJEfVeDV6dpvvMZ28J93Gk=;
        b=VumNgz6NBSwkf9m5HdLxDlbJYCy7gWTJ46NvOzvrVuWOV03PQ5Vz2DE47I73Qf2u9KhGyf
        uOMk1DtVb6qLFcWel+Jw/JY/SDLHVdWYsiX1w/NnbptWXpSnnsDEdeg8yMYeflGE5oPQhB
        x6d+hOqKRoG2I0r8pKa+BhbCY22eQ/M=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-439-b9bQGI2iOsOp6UoCVsFpVg-1; Wed, 08 Dec 2021 11:06:51 -0500
X-MC-Unique: b9bQGI2iOsOp6UoCVsFpVg-1
Received: by mail-ot1-f71.google.com with SMTP id z33-20020a9d24a4000000b00579320f89ecso1077615ota.12
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 08:06:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=msQ0FSkz32V6T/y/AuAdwbJEfVeDV6dpvvMZ28J93Gk=;
        b=qc1uFLYCOXY1/zxXu10RsDna4EZKVjeeWVV4mqE7QaYrgcF/7MGPAJAive9vGEggmw
         bOqIfMCfSanYwT6A97PepZORJHtGy2+TR2wJFJiaSzyfnTj1bprPTAexNdIsh9dapVaq
         rGdrv2A0AhQsxRRN23BLhrLm75li2HsmKhY+84N+OY4ffpX+rVOxBgHP/e6Wujrx/3Bu
         0edFJu0Pwe28RxrIMMw0LMY6BxIogj0gNQN0i4kK8mWnEfvkL0kDqmtwJaF2x1dZuWUg
         C0BbbZLhAIWrQZ90jKaE0MtLS2WjJPCK6ma5bp6rro4+kZ/v9Pd9KD+RBR57DYgcjtsf
         iqTQ==
X-Gm-Message-State: AOAM533bItUPO13sm4eTzinDOHmGBqsYDNEUG5MLqLEwzNyYcoQexEmO
        ZmWbz6YMHmjfua2MJ+AFdYtNBUjstQcdiYhAExUGdm/Y5MP98exLgTPGkYpnn6q2rFNwu8Ja7sc
        KKQ7rjoOCh52/
X-Received: by 2002:a05:6808:1210:: with SMTP id a16mr348246oil.161.1638979610118;
        Wed, 08 Dec 2021 08:06:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwoJipexPgoqhGOL3K0JZuiak0CmykKYiB9ZurxmfVsx7HYyJgucWaZu/zUaxi7Tp4ID2udUw==
X-Received: by 2002:a05:6808:1210:: with SMTP id a16mr348158oil.161.1638979609356;
        Wed, 08 Dec 2021 08:06:49 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e21sm537943ote.72.2021.12.08.08.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 08:06:48 -0800 (PST)
Date:   Wed, 8 Dec 2021 09:06:47 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
Message-ID: <20211208090647.118e6aab.alex.williamson@redhat.com>
In-Reply-To: <20211207155145.GD6385@nvidia.com>
References: <20211130153541.131c9729.alex.williamson@redhat.com>
 <20211201031407.GG4670@nvidia.com>
 <20211201130314.69ed679c@omen>
 <20211201232502.GO4670@nvidia.com>
 <20211203110619.1835e584.alex.williamson@redhat.com>
 <87zgpdu3ez.fsf@redhat.com>
 <20211206173422.GK4670@nvidia.com>
 <87tufltxp0.fsf@redhat.com>
 <20211206191933.GM4670@nvidia.com>
 <87o85su0kv.fsf@redhat.com>
 <20211207155145.GD6385@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 7 Dec 2021 11:51:45 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Dec 07, 2021 at 12:16:32PM +0100, Cornelia Huck wrote:
> > On Mon, Dec 06 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Mon, Dec 06, 2021 at 07:06:35PM +0100, Cornelia Huck wrote:
> > >  
> > >> We're discussing a complex topic here, and we really don't want to
> > >> perpetuate an unclear uAPI. This is where my push for more precise
> > >> statements is coming from.  
> > >
> > > I appreciate that, and I think we've made a big effort toward that
> > > direction.
> > >
> > > Can we have some crisp feedback which statements need SHOULD/MUST/MUST
> > > NOT and come to something?  
> > 
> > I'm not sure what I should actually comment on, some general remarks:  
> 
> You should comment on the paragraphs that prevent you from adding a
> reviewed-by.
> 
> > - If we consider a possible vfio-ccw implementation that will quiesce
> >   the device and not rely on tracking I/O, we need to make the parts
> >   that talk about tracking non-mandatory.  
> 
> I'm not sure what you mean by 'tracking I/O'?
> 
> I thought we were good on ccw?
> 
> > - NDMA sounds like something that needs to be non-mandatory as well.  
> 
> I agree, Alex are we agreed now ?

No.  When last we left our thread, you seemed to be suggesting QEMU
maintains two IOMMU domains, ie. containers, the first of which would
include p2p mappings for all PCI devices, the second would include no
p2p mappings.  Device supporting NDMA get attached to the former,
non-NDMA devices the latter.

So some devices can access all devices via p2p DMA, other devices can
access none.  Are there any bare metal systems that expose such
asymmetric p2p constraints?  I'm not inclined to invent new p2p
scenarios that only exist in VMs.

In addition to creating this asymmetric topology, forcing QEMU to
maintain two containers not only increases the overhead, but doubles
the locked memory requirements for QEMU since our current locked memory
accounting is unfortunately per container.  Then we need to also
consider that multi-device groups exist where a group can only be
attached to one container and also vIOMMU cases where presumably we'd
only get these dual-containers when multiple groups are attached to a
container.  Maybe also worth noting that we cannot atomically move a
device between containers, due to both vfio and often IOMMU constraints
afaik.

So it still seems like the only QEMU policy that we could manage to
document and support would require that non-mandatory NDMA support
implies that migration cannot be enabled by default for any vfio device
and that enabling migration sets in motion a binary policy regarding
p2p mappings across the VM.  I'm still not convinced how supportable
that is, but I can at least imagine explicit per device options that
need to align.

I don't know if lack of NDMA on ccw was Connie's reasoning for making
NDMA non-mandatory, but it seems like NDMA is only relevant to buses
that support DMA, so AIUI it would be just as valid for ccw devices to
report NDMA as a no-op.

> > - The discussion regarding bit group changes has me confused. You seem
> >   to be saying that mlx5 needs that, so it needs to have some mandatory
> >   component; but are actually all devices able to deal with those bits
> >   changing as a group?  
> 
> Yes, all devices can support this as written.
> 
> If you think of the device_state as initiating some action pre bit
> group then we have multiple bit group that can change at once and thus
> multiple actions that can be triggered.
> 
> All devices must support userspace initiating actions one by one in a
> manner that supports the reference flow. 
> 
> Thus, every driver can decompose a request for multiple actions into
> an ordered list of single actions and execute those actions exactly as
> if userspace had issued single actions.
> 
> The precedence follows the reference flow so that any conflicts
> resolve along the path that already has defined behaviors.
> 
> I honestly don't know why this is such a discussion point, beyond
> being a big oversight of the original design.

In my case, because it's still not clearly a universal algorithm, yet
it's being proposed as one.  We already discussed that {!}NDMA
placement is fairly arbitrary and looking at v3 I'm wondering how a
RESUMING -> SAVING|!RUNNING transition works.  For an implementation
that shares a buffer between SAVING and RESUMING, the ordering seems to
suggest the SAVING action has precedence over the !RESUMING action,
which is clearly wrong, but for an implementation where migration data
is read or written to the device directly, the ordering is not such a
concern.
 
> > - In particular, the flow needs definitive markings about what is
> >   mandatory to implement, what is strongly suggested, and what is
> >   optional. It is unclear to me what is really expected, and what is
> >   simply one way to implement it.  
> 
> I'm not sure either, this hasn't been clear at all to me. Alex has
> asked for things to be general and left undefined, but we need some
> minimum definition to actually implement driver/VMM interoperability
> for what we need to do.
> 
> Really what qemu does will set the mandatory to implement.

And therefore anything that works with QEMU is correct and how a driver
gets to that correct result can be implementation specific, depending
on factors like whether device data is buffered or the device is
accessed directly.  We can have a valid, interoperable uAPI without
constraining ourselves to a specific implementation.  Largely I think
that trying to impose an implementation as the specification is the
source of our friction.

> > > The world needs to move forward, we can't debate this endlessly
> > > forever. It is already another 6 weeks past since the last mlx5 driver
> > > posting.  
> > 
> > 6 weeks is already blazingly fast in any vfio migration discussion. /s  
> 
> We've invested a lot of engineer months in this project, it is
> disrespectful to all of this effort to leave us hanging with no clear
> path forward and no actionable review comments after so much
> time. This is another kernel cycle lost.
> 
> > Remember that we have other things to do as well, not all of which will
> > be visible to you.  
> 
> As do we all, but your name is in the maintainer file, and that comes
> with some responsibility.

This is a bit infuriating, responding to it at all is probably ill
advised.  We're all investing a lot of time into this.  We're all
disappointed how the open source use case of the previous
implementation fell apart and nobody else stepped up until now.
Rubbing salt in that wound is not helpful or productive.

Regardless, this implementation has highlighted gaps in the initial
design and it's critical that those known gaps are addressed before we
commit to the design with an in-kernel driver.  Referring to the notes
Connie copied from etherpad, those gaps include uAPI clarification
regarding various device states and accesses allowed in those states,
definition of a quiescent (NDMA) device state, discussion of per-device
dirty state, and documentation such as userspace usage and edge cases.
Only the latter items were specifically requested outside of the header
and previously provided comments questioned if we're not actually
creating contradictory documentation to the uAPI and why clarifications
are not applied to the existing uAPI descriptions.

Personally I'm a bit disappointed to see v3 posted where the diffstat
indicates no uAPI updates, so we actually have no formal definition of
this NDMA state, nor does it feel like we've really come to a
conclusion on that discussion and how it affects userspace.  What is
this documenting if NDMA is not formally part of the uAPI?  More so, it
seems we're just trying to push to get a sign-off, demanding specific
actions to get there.  Isn't that how we got into this situation,
approving the uAPI, or in this case documentation, without an in-kernel
implementation and vetted userspace?  Thanks,

Alex


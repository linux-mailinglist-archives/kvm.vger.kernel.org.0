Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFD645F049
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 16:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353776AbhKZPHT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 10:07:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:35369 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354107AbhKZPFR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 10:05:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637938924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vUXFsZM+dBRxCP7qT6gtQFvAKsiW/+avV4Igsyr1Zgg=;
        b=MRS1uysP6b0c3aHwSbPnhD8wx/ECx4AUVZl3r9b0QMsQoJIyamwfDTLPXsfO6n0/DHnzhL
        4rXuJo2D99VfhmVn0j3JMJXcOGP+0TRL6W3sTS+LRuc1lEhzm5xK6kE7LDaKHXbpI4FFSD
        ++LgphAnFGOFiug2KGmNRV/YKvRgzZ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-481-RTz40yPlPT6Ic5C6zR73BQ-1; Fri, 26 Nov 2021 10:01:59 -0500
X-MC-Unique: RTz40yPlPT6Ic5C6zR73BQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7D5D85B663;
        Fri, 26 Nov 2021 15:01:57 +0000 (UTC)
Received: from localhost (unknown [10.39.193.82])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C1BE5D9C0;
        Fri, 26 Nov 2021 15:01:51 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Documentation for the migration region
In-Reply-To: <20211126130608.GR4670@nvidia.com>
Organization: Red Hat GmbH
References: <0-v1-0ec87874bede+123-vfio_mig_doc_jgg@nvidia.com>
 <87zgpvj6lp.fsf@redhat.com> <20211123165352.GA4670@nvidia.com>
 <87fsrljxwq.fsf@redhat.com> <20211124184020.GM4670@nvidia.com>
 <87a6hsju8v.fsf@redhat.com> <20211125161447.GN4670@nvidia.com>
 <87pmqnhy85.fsf@redhat.com> <20211126130608.GR4670@nvidia.com>
User-Agent: Notmuch/0.33.1 (https://notmuchmail.org)
Date:   Fri, 26 Nov 2021 16:01:49 +0100
Message-ID: <87mtlrhsf6.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 26 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Nov 26, 2021 at 01:56:26PM +0100, Cornelia Huck wrote:
>> On Thu, Nov 25 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:
>> 
>> > On Thu, Nov 25, 2021 at 01:27:12PM +0100, Cornelia Huck wrote:
>> >> On Wed, Nov 24 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:
>> >> 
>> >> > On Wed, Nov 24, 2021 at 05:55:49PM +0100, Cornelia Huck wrote:
>> >> 
>> >> >> What I meant to say: If we give userspace the flexibility to operate
>> >> >> this, we also must give different device types some flexibility. While
>> >> >> subchannels will follow the general flow, they'll probably condense/omit
>> >> >> some steps, as I/O is quite different to PCI there.
>> >> >
>> >> > I would say no - migration is general, no device type should get to
>> >> > violate this spec.  Did you have something specific in mind? There is
>> >> > very little PCI specific here already
>> >> 
>> >> I'm not really thinking about violating the spec, but more omitting
>> >> things that do not really apply to the hardware. For example, it is
>> >> really easy to shut up a subchannel, we don't really need to wait until
>> >> nothing happens anymore, and it doesn't even have MMIO. 
>> >
>> > I've never really looked closely at the s390 mdev drivers..
>> >
>> > What does something like AP even do anyhow? The ioctl handler doesn't
>> > do anything, there is no mmap hook, how does the VFIO userspace
>> > interact with this thing?
>> 
>> For AP, the magic is in the hardware/firmware; the vfio parts are needed
>> to configure what is exposed to a given guest, not for operation. Once
>> it is up, the hardware will handle any instructions directly, the
>> hypervisor will not see them. (Unfortunately, none of the details have
>> public documentation.) I have no idea how this would play with migration.
>
> That is kind of what I thought..
>
> VFIO is all about exposing a device to userspace control, sounds like
> the S390 drivers skipped that step.

Note that what I wrote above is about AP; CCW does indeed trigger
operations like start subchannel from userspace and relays interrupts
back to userspace. AP is just very dissimilar to basically anything
else.

>
> KVM is all about taking what userspace can already control and giving
> it to a guest, in an accelerated way.
>
> Making a bypass where a KVM guest has more capability than the user
> process because VFIO and KVM have been directly coupled completely
> upends the whole logical model.
>
> As we talked with Intel's wbinvd stuff you should have a mental model
> where the VFIO userspace process can do anything the KVM guest can do
> via ioctls on the mdev. KVM is just an accelerated way to do that same
> stuff. Maybe S390 doesn't implement those ioctls, but they are
> logically part of the model.

FWIW, AP had been a pain to model in a way that we could hand the
devices to the guest; if we are supposed to use vfio for this purpose,
the current design is probably the best we can get, at least nobody has
been able to come up with a better way to interact with the interfaces
that we have.

CCW needs a kernel part for translations, as it doesn't have an iommu,
and the I/O instructions are of course privileged (but so are the
instructions for s390 PCI); I think it is quite close to other devices
in other respects, only that it has a more transaction-based model.

> So, for the migration doc, imagine some non-accelerated KVM that was
> intercepting the guest operations and calling the logical ioctls on
> the mdev instead. When we talk about MMIO/PIO/etc it also includes
> mdev operation ioctls too, and by extension any ioctl accelerated
> inside KVM.

I think only AP is the really odd one out here; CCW will likely differ
in some details... I just wanted to make sure that this will not run
counter to the documentation.


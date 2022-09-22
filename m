Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 036715E6079
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 13:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbiIVLHr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 07:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiIVLH0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 07:07:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E7DDCCC2
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 04:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663844804;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=weTzGs+YH5eFOYqu10+XviMcq6i4aHFhLOVdDjBJzEc=;
        b=Kbax5VozaW6EgBVj3S2efrDtw6rL533xjNDiC/iaMgnKSHKiM++aIXjEBsQDlpQuTqIPUd
        vFi2mGbCgOWkbe14Gd8OH6DfkqorI0pPMyxVP+FdcPFHJ7obK+3eH/q1pbKApn3FxPXA/F
        UEGergLxu0gSF/qSj8dI29vJGnkr2UE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-gzxwWZryPyyAG_o4GzxKoA-1; Thu, 22 Sep 2022 07:06:41 -0400
X-MC-Unique: gzxwWZryPyyAG_o4GzxKoA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E6FF294EDEE;
        Thu, 22 Sep 2022 11:06:40 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B3CD492CA5;
        Thu, 22 Sep 2022 11:06:35 +0000 (UTC)
Date:   Thu, 22 Sep 2022 12:06:33 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Laine Stump <laine@redhat.com>
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Message-ID: <YyxBuQwIUdiqGoR3@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <BN9PR11MB52762909D64C1194F4FCB4528C479@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d5e33ebb-29e6-029d-aef4-af5c4478185a@redhat.com>
 <Yyoa+kAJi2+/YTYn@nvidia.com>
 <20220921120649.5d2ff778.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220921120649.5d2ff778.alex.williamson@redhat.com>
User-Agent: Mutt/2.2.6 (2022-06-05)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022 at 12:06:49PM -0600, Alex Williamson wrote:
> [Cc+ Steve, libvirt, Daniel, Laine]
> 
> On Tue, 20 Sep 2022 16:56:42 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> > That really just leaves the accounting, and I'm still not convinced at
> > this must be a critical thing. Linus's latest remarks reported in lwn
> > at the maintainer summit on tracepoints/BPF as ABI seem to support
> > this. Let's see an actual deployed production configuration that would
> > be impacted, and we won't find that unless we move forward.
> 
> I'll try to summarize the proposed change so that we can get better
> advice from libvirt folks, or potentially anyone else managing locked
> memory limits for device assignment VMs.
> 
> Background: when a DMA range, ex. guest RAM, is mapped to a vfio device,
> we use the system IOMMU to provide GPA to HPA translation for assigned
> devices. Unlike CPU page tables, we don't generally have a means to
> demand fault these translations, therefore the memory target of the
> translation is pinned to prevent that it cannot be swapped or
> relocated, ie. to guarantee the translation is always valid.
> 
> The issue is where we account these pinned pages, where accounting is
> necessary such that a user cannot lock an arbitrary number of pages
> into RAM to generate a DoS attack.  Duplicate accounting should be
> resolved by iommufd, but is outside the scope of this discussion.
> 
> Currently, vfio tests against the mm_struct.locked_vm relative to
> rlimit(RLIMIT_MEMLOCK), which reads task->signal->rlim[limit].rlim_cur,
> where task is the current process.  This is the same limit set via the
> setrlimit syscall used by prlimit(1) and reported via 'ulimit -l'.
> 
> Note that in both cases above, we're dealing with a task, or process
> limit and both prlimit and ulimit man pages describe them as such.
> 
> iommufd supposes instead, and references existing kernel
> implementations, that despite the descriptions above these limits are
> actually meant to be user limits and therefore instead charges pinned
> pages against user_struct.locked_vm and also marks them in
> mm_struct.pinned_vm.
> 
> The proposed algorithm is to read the _task_ locked memory limit, then
> attempt to charge the _user_ locked_vm, such that user_struct.locked_vm
> cannot exceed the task locked memory limit.
> 
> This obviously has implications.  AFAICT, any management tool that
> doesn't instantiate assigned device VMs under separate users are
> essentially untenable.  For example, if we launch VM1 under userA and
> set a locked memory limit of 4GB via prlimit to account for an assigned
> device, that works fine, until we launch VM2 from userA as well.  In
> that case we can't simply set a 4GB limit on the VM2 task because
> there's already 4GB charged against user_struct.locked_vm for VM1.  So
> we'd need to set the VM2 task limit to 8GB to be able to launch VM2.
> But not only that, we'd need to go back and also set VM1's task limit
> to 8GB or else it will fail if a DMA mapped memory region is transient
> and needs to be re-mapped.
> 
> Effectively any task under the same user and requiring pinned memory
> needs to have a locked memory limit set, and updated, to account for
> all tasks using pinned memory by that user.

That is pretty unpleasant. Having to update all existing VMs, when
starting a new VM (or hotpluigging a VFIO device to an existing
VM) is something we would never want todo.

Charging this against the user weakens the DoS protection that
we have today from the POV of individual VMs.

Our primary risk is that a single QEMU is compromised and attempts
to impact the host in some way. We want to limit the damage that
an individual QEMU can cause.

Consider 4 VMs each locked with 4 GB. Any single compromised VM
is constrained to only use 4 GB of locked memory.

With the per-user accounting, now any single compromised VM can
use the cummulative 16 GB of locked memory, even though we only
want that VM to be able to use 4 GB.

For a cummulative memory limit, we would expect cgroups to be
the enforcement mechanism. eg consider a machine has 64 GB of
RAM, and we want to reserve 12 GB for host OS ensure, and all
other RAM is for VM usage. A mgmt app wanting such protecton
would set a limit on /machines.slice, at the 52 GB mark, to
reserve the 12 GB for non-VM usage.

Also, the mgmt app accounts for how many VMs it has started on
a host and will not try to launch more VMs than there is RAM
available to support them. Accounting at the user level instead
of the task level, is effectively trying to protect against the
bad mgmt app trying to overcommit the host. That is not really
important, as the mgmt app is so privileged it is already
assumed to be a trusted host component akin to a root acocunt.

So per-user locked mem accounting looks like a regression in
our VM isolation abilities compared to the per-task accounting.

> How does this affect known current use cases of locked memory
> management for assigned device VMs?

It will affect every single application using libvirt today, with
the possible exception of KubeVirt. KubeVirt puts each VM in a
separate container, and if they have userns enabled, those will
each get distinct UIDs for accounting purposes.

I expect every other usage of libvrit to be affected, unless the
mgmt app has gone out of its way to configure a dedicated UID for
each QEMU - I'm not aware of any which do this.

> Does qemu://system by default sandbox into per VM uids or do they all
> use the qemu user by default.  I imagine qemu://session mode is pretty
> screwed by this, but I also don't know who/where locked limits are
> lifted for such VMs.  Boxes, who I think now supports assigned device
> VMs, could also be affected.

In a out of the box config qemu:///system will always run all VMs
under the user:group pairing  qemu:qemu.

Mgmt apps can requested a dedicated UID per VM in the XML config,
but I'm not aware of any doing this. Someone might, but we should
assume the majority will not.

IOW, it affects essentially all libvirt usage of VFIO.

> > So, I still like 2 because it yields the smallest next step before we
> > can bring all the parallel work onto the list, and it makes testing
> > and converting non-qemu stuff easier even going forward.
> 
> If a vfio compatible interface isn't transparently compatible, then I
> have a hard time understanding its value.  Please correct my above
> description and implications, but I suspect these are not just
> theoretical ABI compat issues.  Thanks,



With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


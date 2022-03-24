Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D43B4E5D34
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 03:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245692AbiCXC3n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 22:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241187AbiCXC3l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 22:29:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 81B62AE6D
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 19:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648088887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/KUDKLVvjygLeBTT0eVfF3geljZl7YbpoTaiW+XQm0Q=;
        b=GU5VroRN1XwMHNca5pkEtnILw7icSVTjMYaAiSuS/48I+2d70s9S/WUA2Z6A6Ppb8DRGxa
        CS93BmdoWPla/v9gVKnANFISMylSFvkusUrbhZY5pErDRtoASCEoDNFsJKbdAisrj9Q3p1
        YGbYUadxW/jBBe95t9L4IS/rorSQC+s=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-W1U3xN9oNi289Gl0x2TRZg-1; Wed, 23 Mar 2022 22:28:06 -0400
X-MC-Unique: W1U3xN9oNi289Gl0x2TRZg-1
Received: by mail-lj1-f200.google.com with SMTP id 20-20020a05651c009400b002462f08f8d2so1289423ljq.2
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 19:28:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/KUDKLVvjygLeBTT0eVfF3geljZl7YbpoTaiW+XQm0Q=;
        b=mKwhcdGKeCWruZaEOGuuyyjtPGF9LQ6RPUd+nZZxJNd+hij9sdJLBBDSmr7Sd+rL48
         zVDdN6ZbuOc3gfCip/hFCTfzRy86jaJuJXmLfgrl3s05puyayYXoJ6CNVWCwvkAmnDIh
         biqSV7AeUGpcIcqkLxU6QZ3HhxPQp97IRK9xHX3AnZCp/rCd1lJr3D6oKiAn4OuN7zNr
         hyZyAf/XOgujUyxfWnY6yipbEdc0pJPTV5Nzyto3TEefXHuYf38kVi/VJNEOkJlvXJmX
         yxoCIO7MQvwMSGZv9UXnIXLFnsA9lqmHIQ4jhFuSwz+gV0B8tuuurseD65Y81i3qWb2u
         v+7g==
X-Gm-Message-State: AOAM5307kkedM4x8DQtMIE+ya6n9K8tYr1tokKLeu5GW+Mx2l+NH+HqL
        I6lYtNBb4vBYDn6EvZuzlK9Vx6siGY0Vqy+/YnJFvmOyloV+ByT5NLbxLCPqM46lpeVgSrPre5N
        uYeCsETeTFd9AKur/uBEh/vxaLZjT
X-Received: by 2002:a05:651c:90a:b0:249:5d82:fe9c with SMTP id e10-20020a05651c090a00b002495d82fe9cmr2445246ljq.300.1648088884965;
        Wed, 23 Mar 2022 19:28:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnjKLKjHY9uWnHx/TA9Gava27jWlJlmXoIDkg+GZtCSCllUFMt+xcEGKO5PhHkexhbWr/iC1mcK/EZo2h8bNA=
X-Received: by 2002:a05:651c:90a:b0:249:5d82:fe9c with SMTP id
 e10-20020a05651c090a00b002495d82fe9cmr2445228ljq.300.1648088884765; Wed, 23
 Mar 2022 19:28:04 -0700 (PDT)
MIME-Version: 1.0
References: <4-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com> <808a871b3918dc067031085de3e8af6b49c6ef89.camel@linux.ibm.com>
 <20220322145741.GH11336@nvidia.com> <20220322092923.5bc79861.alex.williamson@redhat.com>
 <20220322161521.GJ11336@nvidia.com> <BN9PR11MB5276BED72D82280C0A4C6F0C8C199@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276BED72D82280C0A4C6F0C8C199@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 24 Mar 2022 10:27:53 +0800
Message-ID: <CACGkMEutpbOc_+5n3SDuNDyHn19jSH4ukSM9i0SUgWmXDydxnA@mail.gmail.com>
Subject: Re: [PATCH RFC 04/12] kernel/user: Allow user::locked_vm to be usable
 for iommufd
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 24, 2022 at 10:12 AM Tian, Kevin <kevin.tian@intel.com> wrote:
>
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, March 23, 2022 12:15 AM
> >
> > On Tue, Mar 22, 2022 at 09:29:23AM -0600, Alex Williamson wrote:
> >
> > > I'm still picking my way through the series, but the later compat
> > > interface doesn't mention this difference as an outstanding issue.
> > > Doesn't this difference need to be accounted in how libvirt manages VM
> > > resource limits?
> >
> > AFACIT, no, but it should be checked.
> >
> > > AIUI libvirt uses some form of prlimit(2) to set process locked
> > > memory limits.
> >
> > Yes, and ulimit does work fully. prlimit adjusts the value:
> >
> > int do_prlimit(struct task_struct *tsk, unsigned int resource,
> >               struct rlimit *new_rlim, struct rlimit *old_rlim)
> > {
> >       rlim = tsk->signal->rlim + resource;
> > [..]
> >               if (new_rlim)
> >                       *rlim = *new_rlim;
> >
> > Which vfio reads back here:
> >
> > drivers/vfio/vfio_iommu_type1.c:        unsigned long pfn, limit =
> > rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> > drivers/vfio/vfio_iommu_type1.c:        unsigned long limit =
> > rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> >
> > And iommufd does the same read back:
> >
> >       lock_limit =
> >               task_rlimit(pages->source_task, RLIMIT_MEMLOCK) >>
> > PAGE_SHIFT;
> >       npages = pages->npinned - pages->last_npinned;
> >       do {
> >               cur_pages = atomic_long_read(&pages->source_user-
> > >locked_vm);
> >               new_pages = cur_pages + npages;
> >               if (new_pages > lock_limit)
> >                       return -ENOMEM;
> >       } while (atomic_long_cmpxchg(&pages->source_user->locked_vm,
> > cur_pages,
> >                                    new_pages) != cur_pages);
> >
> > So it does work essentially the same.
> >
> > The difference is more subtle, iouring/etc puts the charge in the user
> > so it is additive with things like iouring and additively spans all
> > the users processes.
> >
> > However vfio is accounting only per-process and only for itself - no
> > other subsystem uses locked as the charge variable for DMA pins.
> >
> > The user visible difference will be that a limit X that worked with
> > VFIO may start to fail after a kernel upgrade as the charge accounting
> > is now cross user and additive with things like iommufd.
> >
> > This whole area is a bit peculiar (eg mlock itself works differently),
> > IMHO, but with most of the places doing pins voting to use
> > user->locked_vm as the charge it seems the right path in today's
> > kernel.
> >
> > Ceratinly having qemu concurrently using three different subsystems
> > (vfio, rdma, iouring) issuing FOLL_LONGTERM and all accounting for
> > RLIMIT_MEMLOCK differently cannot be sane or correct.
> >
> > I plan to fix RDMA like this as well so at least we can have
> > consistency within qemu.
> >
>
> I have an impression that iommufd and vfio type1 must use
> the same accounting scheme given the management stack
> has no insight into qemu on which one is actually used thus
> cannot adapt to the subtle difference in between. in this
> regard either we start fixing vfio type1 to use user->locked_vm
> now or have iommufd follow vfio type1 for upward compatibility
> and then change them together at a later point.
>
> I prefer to the former as IMHO I don't know when will be a later
> point w/o certain kernel changes to actually break the userspace
> policy built on a wrong accounting scheme...

I wonder if the kernel is the right place to do this. We have new uAPI
so management layer can know the difference of the accounting in
advance by

-device vfio-pci,iommufd=on

?

>
> Thanks
> Kevin
>


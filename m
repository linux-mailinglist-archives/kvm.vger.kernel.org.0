Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFFEE4E5DB7
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 04:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238484AbiCXDwm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 23:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbiCXDwl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 23:52:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BDDF295A13
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 20:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648093862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V7NhbFMhYxIOK3QQQY7EdzshZjWLB3YvUuiYy4wdKbE=;
        b=JKQlkKw51QGR/OtqsqdaCilEr0vips7f61msuJqZ1fbCH1woswrmo1X6FyQMGX7aFLiXzz
        GZseWXjZu2Ky9TNxtGCLMCcfnsq5141Lz+wdP63TNQna0thNiZDdjfvFOgpp/wpQ+qaSvE
        Ir/sU9T9bNgN54mpHoLYduC2DDonjSk=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-5E-zyCIyMGmNlsJjpVB57Q-1; Wed, 23 Mar 2022 23:51:01 -0400
X-MC-Unique: 5E-zyCIyMGmNlsJjpVB57Q-1
Received: by mail-lf1-f70.google.com with SMTP id i25-20020ac25239000000b0044a3f56e059so1257278lfl.15
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 20:51:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V7NhbFMhYxIOK3QQQY7EdzshZjWLB3YvUuiYy4wdKbE=;
        b=OdZ76YaoczkpMjh8Nj0P30pk06K3tK3BGQF83ItijN3dz5fylppv1UoymfPuQEdQlD
         3g6S3hYv4Cul1UO/46/ZhmLqPgRwruiNXogLFzFyT8AoHQ5apMZTYcrtlKeGnuem5GUU
         Qc51R+Yx4KN0Lu5ZVC6wUDCIT9p9Yvnat7HrM05OIiCiPm6EReh830XC8u70DoJ+NAI3
         XYlj1wCodKcqP1+IxQR1HvnXpSICdTvYXSK+1RUkbf5EDZWSsEcWtnQj8kpu1CuE3LGf
         JI3iG374nSwwc5BNxIjUD2Ts5prKB0Vb0/DGdhlzeMV7//Urr0r8lwW56W6GNEufjGkb
         PwpA==
X-Gm-Message-State: AOAM5306buaWOmwDnTvOKdoLzJgCT1WjA8e5x5NWWtDBqVhcgAsQBK6j
        MEPTRwSik/MNCrLe5Q+w4w2B6G64p5OR5ucokCuWFm/BXDighVYxN3JzzhSdFFRufjCr1xuucUf
        V1pcPL8fhOQNQkBC9y07KS74un9Yb
X-Received: by 2002:a2e:9b96:0:b0:249:8705:8f50 with SMTP id z22-20020a2e9b96000000b0024987058f50mr2738934lji.73.1648093859537;
        Wed, 23 Mar 2022 20:50:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYtKGYWcSY2Sgu56bZylQAsgrviUPcGmGWq1IhXvSpUyuWowTqG56BQkHyORMkrCBcteqM6RkdCUvWbY7A7Lg=
X-Received: by 2002:a2e:9b96:0:b0:249:8705:8f50 with SMTP id
 z22-20020a2e9b96000000b0024987058f50mr2738901lji.73.1648093859240; Wed, 23
 Mar 2022 20:50:59 -0700 (PDT)
MIME-Version: 1.0
References: <4-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com> <808a871b3918dc067031085de3e8af6b49c6ef89.camel@linux.ibm.com>
 <20220322145741.GH11336@nvidia.com> <20220322092923.5bc79861.alex.williamson@redhat.com>
 <20220322161521.GJ11336@nvidia.com> <BN9PR11MB5276BED72D82280C0A4C6F0C8C199@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CACGkMEutpbOc_+5n3SDuNDyHn19jSH4ukSM9i0SUgWmXDydxnA@mail.gmail.com>
 <BN9PR11MB5276E3566D633CEE245004D08C199@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CACGkMEvTmCFqAsc4z=2OXOdr7X--0BSDpH06kCiAP5MHBjaZtg@mail.gmail.com> <BN9PR11MB5276ECF1F1C7D0A80DA086D18C199@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276ECF1F1C7D0A80DA086D18C199@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 24 Mar 2022 11:50:47 +0800
Message-ID: <CACGkMEtpWemw6tj=suxNjvSHuixyzhMJBYmqdbhQkinuWNADCQ@mail.gmail.com>
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 24, 2022 at 11:15 AM Tian, Kevin <kevin.tian@intel.com> wrote:
>
> > From: Jason Wang <jasowang@redhat.com>
> > Sent: Thursday, March 24, 2022 10:57 AM
> >
> > On Thu, Mar 24, 2022 at 10:42 AM Tian, Kevin <kevin.tian@intel.com> wrote:
> > >
> > > > From: Jason Wang <jasowang@redhat.com>
> > > > Sent: Thursday, March 24, 2022 10:28 AM
> > > >
> > > > On Thu, Mar 24, 2022 at 10:12 AM Tian, Kevin <kevin.tian@intel.com>
> > wrote:
> > > > >
> > > > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > > > Sent: Wednesday, March 23, 2022 12:15 AM
> > > > > >
> > > > > > On Tue, Mar 22, 2022 at 09:29:23AM -0600, Alex Williamson wrote:
> > > > > >
> > > > > > > I'm still picking my way through the series, but the later compat
> > > > > > > interface doesn't mention this difference as an outstanding issue.
> > > > > > > Doesn't this difference need to be accounted in how libvirt manages
> > VM
> > > > > > > resource limits?
> > > > > >
> > > > > > AFACIT, no, but it should be checked.
> > > > > >
> > > > > > > AIUI libvirt uses some form of prlimit(2) to set process locked
> > > > > > > memory limits.
> > > > > >
> > > > > > Yes, and ulimit does work fully. prlimit adjusts the value:
> > > > > >
> > > > > > int do_prlimit(struct task_struct *tsk, unsigned int resource,
> > > > > >               struct rlimit *new_rlim, struct rlimit *old_rlim)
> > > > > > {
> > > > > >       rlim = tsk->signal->rlim + resource;
> > > > > > [..]
> > > > > >               if (new_rlim)
> > > > > >                       *rlim = *new_rlim;
> > > > > >
> > > > > > Which vfio reads back here:
> > > > > >
> > > > > > drivers/vfio/vfio_iommu_type1.c:        unsigned long pfn, limit =
> > > > > > rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> > > > > > drivers/vfio/vfio_iommu_type1.c:        unsigned long limit =
> > > > > > rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> > > > > >
> > > > > > And iommufd does the same read back:
> > > > > >
> > > > > >       lock_limit =
> > > > > >               task_rlimit(pages->source_task, RLIMIT_MEMLOCK) >>
> > > > > > PAGE_SHIFT;
> > > > > >       npages = pages->npinned - pages->last_npinned;
> > > > > >       do {
> > > > > >               cur_pages = atomic_long_read(&pages->source_user-
> > > > > > >locked_vm);
> > > > > >               new_pages = cur_pages + npages;
> > > > > >               if (new_pages > lock_limit)
> > > > > >                       return -ENOMEM;
> > > > > >       } while (atomic_long_cmpxchg(&pages->source_user->locked_vm,
> > > > > > cur_pages,
> > > > > >                                    new_pages) != cur_pages);
> > > > > >
> > > > > > So it does work essentially the same.
> > > > > >
> > > > > > The difference is more subtle, iouring/etc puts the charge in the user
> > > > > > so it is additive with things like iouring and additively spans all
> > > > > > the users processes.
> > > > > >
> > > > > > However vfio is accounting only per-process and only for itself - no
> > > > > > other subsystem uses locked as the charge variable for DMA pins.
> > > > > >
> > > > > > The user visible difference will be that a limit X that worked with
> > > > > > VFIO may start to fail after a kernel upgrade as the charge accounting
> > > > > > is now cross user and additive with things like iommufd.
> > > > > >
> > > > > > This whole area is a bit peculiar (eg mlock itself works differently),
> > > > > > IMHO, but with most of the places doing pins voting to use
> > > > > > user->locked_vm as the charge it seems the right path in today's
> > > > > > kernel.
> > > > > >
> > > > > > Ceratinly having qemu concurrently using three different subsystems
> > > > > > (vfio, rdma, iouring) issuing FOLL_LONGTERM and all accounting for
> > > > > > RLIMIT_MEMLOCK differently cannot be sane or correct.
> > > > > >
> > > > > > I plan to fix RDMA like this as well so at least we can have
> > > > > > consistency within qemu.
> > > > > >
> > > > >
> > > > > I have an impression that iommufd and vfio type1 must use
> > > > > the same accounting scheme given the management stack
> > > > > has no insight into qemu on which one is actually used thus
> > > > > cannot adapt to the subtle difference in between. in this
> > > > > regard either we start fixing vfio type1 to use user->locked_vm
> > > > > now or have iommufd follow vfio type1 for upward compatibility
> > > > > and then change them together at a later point.
> > > > >
> > > > > I prefer to the former as IMHO I don't know when will be a later
> > > > > point w/o certain kernel changes to actually break the userspace
> > > > > policy built on a wrong accounting scheme...
> > > >
> > > > I wonder if the kernel is the right place to do this. We have new uAPI
> > >
> > > I didn't get this. This thread is about that VFIO uses a wrong accounting
> > > scheme and then the discussion is about the impact of fixing it to the
> > > userspace.
> >
> > It's probably too late to fix the kernel considering it may break the userspace.
> >
> > > I didn't see the question on the right place part.
> >
> > I meant it would be easier to let userspace know the difference than
> > trying to fix or workaround in the kernel.
>
> Jason already plans to fix RDMA which will also leads to user-aware
> impact when Qemu uses both VFIO and RDMA. Why is VFIO so special
> and left behind to carry the legacy misdesign?

It's simply because we don't want to break existing userspace. [1]

>
> >
> > >
> > > > so management layer can know the difference of the accounting in
> > > > advance by
> > > >
> > > > -device vfio-pci,iommufd=on
> > > >
> > >
> > > I suppose iommufd will be used once Qemu supports it, as long as
> > > the compatibility opens that Jason/Alex discussed in another thread
> > > are well addressed. It is not necessarily to be a control knob exposed
> > > to the caller.
> >
> > It has a lot of implications if we do this, it means iommufd needs to
> > inherit all the userspace noticeable behaviour as well as the "bugs"
> > of VFIO.
> >
> > We know it's easier to find the difference than saying no difference.
> >
>
> In the end vfio type1 will be replaced by iommufd compat layer. With
> that goal in mind iommufd has to inherit type1 behaviors.

So the compatibility should be provided by the compat layer instead of
the core iommufd.

And I wonder what happens if iommufd is used by other subsystems like
vDPA. Does it mean vDPA needs to inherit type1 behaviours? If yes, do
we need a per subsystem new uAPI to expose this capability? If yes,
why can't VFIO have such an API then we don't even need the compat
layer at all?

Thanks

[1] https://lkml.org/lkml/2012/12/23/75

>
> Thanks
> Kevin


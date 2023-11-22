Return-Path: <kvm+bounces-2237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 612247F3AF9
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 02:02:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8446A1C20DFA
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 01:02:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0415117D2;
	Wed, 22 Nov 2023 01:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eLMHczCs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB88D49;
	Tue, 21 Nov 2023 17:02:26 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-5491eb3fb63so642154a12.3;
        Tue, 21 Nov 2023 17:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700614944; x=1701219744; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zXAWsG9iOloHUdNE5mm3jXIIiOW32R7yz4554A63aDM=;
        b=eLMHczCsRfIWigC0JaCWX2LtiHgJciEgTtYQlM5KAfWfgmyAhJRqY9RyRiBBpV6fHM
         wX+T01wPqSGwvZTehVtM//1Pxdhmfs+4P98Fh8iDhr519bfkTbuSThZYNOQhmVqom34d
         Yq+ve7Pzfti2hcCeZdc8F2ZDbjML12T7vpQcrxux+tYISEeu2FqlrpiE633WTjGnm7Nx
         W1TqEFESlR6QFe1Cxszaz8xOYpd+XB8h8SdQYgeGCtuSLTK6D8DoeF5mYubHaL8FielN
         nAB0iYiXv6DioEa9+a997TQnrbbOP31K0oETz2ZAG656GGGFXudzM2+ItluXVMvkNCAh
         T8bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700614944; x=1701219744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zXAWsG9iOloHUdNE5mm3jXIIiOW32R7yz4554A63aDM=;
        b=S+W3xZ9qlGsZFVZgH+184gy7YWPRjb3dLzO2xptKQjRu8zCmCaC/7ZR9h5Ne6ixwSn
         XYV+2Q0NzSL34uQuVFzm2KVPE6CVtTvzLj6hMsywuU+xoCKD5FURTqke8R3rq6cVqfIz
         x1ZyvUNZz+0EqM1ZPUXcuVxRMNBMMaX+u2qxaFfcVyd2SoQp5Q0QySl476szoQHHoiDX
         4nwiK0K+v5WwpiPgavRewPwS1ddSgadPBgLTO/arr+46Kckx1hUBUZicXszAcJWQPwdY
         IrG5qAsDcCiOcnOkubYNCO2VXAys+edQtdEsQMtTPkHgjU7G53oozfhFDlF/e+5mavIa
         ZoMw==
X-Gm-Message-State: AOJu0YyurhzwGdtBMBM0lOZs7aMb3hjghQw74LRXryF7VTFDkjJuOSOZ
	z5aW5pT1lF0VL/KLiOyRYPFL49We+qwVGFSAB1M=
X-Google-Smtp-Source: AGHT+IFAAdSEYQU+FjN4tYW+dYheU4U1L4a17RYKBvYXsMva3YuIChgqqiL7+fiTRx2WV4Qr3vc5DWuiTLVP4mKrrMs=
X-Received: by 2002:a50:ed89:0:b0:548:5fa3:1483 with SMTP id
 h9-20020a50ed89000000b005485fa31483mr630561edr.6.1700614944335; Tue, 21 Nov
 2023 17:02:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231115020209.4665-1-yaozhenguo@jd.com> <20231117152746.3aa55d68.alex.williamson@redhat.com>
In-Reply-To: <20231117152746.3aa55d68.alex.williamson@redhat.com>
From: Zhenguo Yao <yaozhenguo1@gmail.com>
Date: Wed, 22 Nov 2023 09:02:13 +0800
Message-ID: <CA+WzAR=7R=JPeu4+-ojgfjM7vgP5pcg7fS0yU_CRaLzNSdRaLA@mail.gmail.com>
Subject: Re: [PATCH V1] vfio: add attach_group_by_node to control behavior of
 attaching group to domain
To: Alex Williamson <alex.williamson@redhat.com>
Cc: yaozhenguo@jd.com, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Wenchao Yao <yaowenchao@jd.com>, ZiHan Zhou <zhouzihan30@jd.com>, Jason Gunthorpe <jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Understood, thanks=EF=BC=81

Alex Williamson <alex.williamson@redhat.com> =E4=BA=8E2023=E5=B9=B411=E6=9C=
=8818=E6=97=A5=E5=91=A8=E5=85=AD 06:27=E5=86=99=E9=81=93=EF=BC=9A
>
> On Wed, 15 Nov 2023 10:02:09 +0800
> yaozhenguo <yaozhenguo1@gmail.com> wrote:
>
> > From: Zhenguo Yao <yaozhenguo1@gmail.com>
> >
> > Groups will attach to one iommu_domain if ops and enforce_cache_coheren=
cy
> > are equal. And all the iommu hardware share one pagetable by default.
> > There are performance issue in some scenarios. For example:
> > Host hardware topopy:
> >
> > node0 + PCIe RP0 ---+ GPU A100
> >       |         |---+ GPU A100
> >       |               |---+ NIC Mellanox CX6
> >       |               |---+ NIC Mellanox CX6
> >       + PCIe RP1 ---+ GPU A100
> >                 |---+ GPU A100
> >                       |---+ NIC Mellanox CX6
> >                 |---+ NIC Mellanox CX6
> > node1 + PCIe RP0 ---+ GPU A100
> >       |         |---+ GPU A100
> >       |               |---+ NIC Mellanox CX6
> >       |               |---+ NIC Mellanox CX6
> >       + PCIe RP1 ---+ GPU A100
> >                 |---+ GPU A100
> >                       |---+ NIC Mellanox CX6
> >                 |---+ NIC Mellanox CX6
> >
> > We passthrough all NICs and GPU to VM, and emulate host hardware topopy=
.
> > Mellanox CX6 ATS feature is enabled, GPU direct RDMA enabled.
> > We test NCCL allreduce in VM at different cases.
> >
> > Case1: allreduce test use 4nic and 4GPU in numa0.
> > Case2=EF=BC=9Aallreduce test use 4nic and 4GPU in numa1.
> > case3: allreduce test use 8nic and 8GPU.
> >
> > the result are below:
> >
> > |        | algbw (GB/S) |
> > | ------ | -------------|
> > | case1  | 24           |
> > | case2  | 32           |
> > | case3  | 45           |
> >
> > We checked that IOMMU pagetable is allocated in numa1 when VM boot up.
> > So, if IOTLB miss happan, IOMMU hardware in numa0 will access remote
> > pagetable in numa1. This will drop performance. After apply this patch =
and
> > attach_group_by_node is 1. Group in same node will attach to one domain=
.
> > IOMMU will access there local pagetable. Performance is improved:
> >
> > |        | algbw (GB/S) |
> > | ------ | -------------|
> > | case1  | 32           |
> > | case2  | 32           |
> > | case3  | 63           |
> >
> > Signed-off-by: Zhenguo Yao <yaozhenguo1@gmail.com>
> > Co-developed-by: Wenchao Yao <yaowenchao@jd.com>
> > Signed-off-by: Wenchao Yao <yaowenchao@jd.com>
> > Co-developed-by: ZiHan Zhou <zhouzihan30@jd.com>
> > Signed-off-by: ZiHan Zhou <zhouzihan30@jd.com>
> > ---
> >  drivers/iommu/intel/iommu.c     |  8 +++++++-
> >  drivers/vfio/vfio_iommu_type1.c | 33 +++++++++++++++++++++------------
> >  include/linux/iommu.h           |  1 +
> >  3 files changed, 29 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> > index 3531b95..2c6d8f0 100644
> > --- a/drivers/iommu/intel/iommu.c
> > +++ b/drivers/iommu/intel/iommu.c
> > @@ -569,8 +569,10 @@ void domain_update_iommu_cap(struct dmar_domain *d=
omain)
> >        * If RHSA is missing, we should default to the device numa domai=
n
> >        * as fall back.
> >        */
> > -     if (domain->nid =3D=3D NUMA_NO_NODE)
> > +     if (domain->nid =3D=3D NUMA_NO_NODE) {
> >               domain->nid =3D domain_update_device_node(domain);
> > +             domain->domain.nid =3D domain->nid;
> > +     }
> >
> >       /*
> >        * First-level translation restricts the input-address to a
> > @@ -1767,6 +1769,7 @@ static struct dmar_domain *alloc_domain(unsigned =
int type)
> >               return NULL;
> >
> >       domain->nid =3D NUMA_NO_NODE;
> > +     domain->domain.nid =3D NUMA_NO_NODE;
> >       if (first_level_by_default(type))
> >               domain->use_first_level =3D true;
> >       domain->has_iotlb_device =3D false;
> > @@ -1808,6 +1811,8 @@ int domain_attach_iommu(struct dmar_domain *domai=
n, struct intel_iommu *iommu)
> >       info->refcnt    =3D 1;
> >       info->did       =3D num;
> >       info->iommu     =3D iommu;
> > +     domain->nid     =3D iommu->node;
> > +     domain->domain.nid     =3D iommu->node;
> >       curr =3D xa_cmpxchg(&domain->iommu_array, iommu->seq_id,
> >                         NULL, info, GFP_ATOMIC);
> >       if (curr) {
> > @@ -1837,6 +1842,7 @@ void domain_detach_iommu(struct dmar_domain *doma=
in, struct intel_iommu *iommu)
> >               clear_bit(info->did, iommu->domain_ids);
> >               xa_erase(&domain->iommu_array, iommu->seq_id);
> >               domain->nid =3D NUMA_NO_NODE;
> > +             domain->domain.nid =3D NUMA_NO_NODE;
> >               domain_update_iommu_cap(domain);
> >               kfree(info);
> >       }
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_=
type1.c
> > index eacd6ec..6a5641e 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -59,6 +59,11 @@
> >  module_param_named(dma_entry_limit, dma_entry_limit, uint, 0644);
> >  MODULE_PARM_DESC(dma_entry_limit,
> >                "Maximum number of user DMA mappings per container (6553=
5).");
> > +static uint attach_group_by_node;
> > +module_param_named(attach_group_by_node,
> > +             attach_group_by_node, uint, 0644);
> > +MODULE_PARM_DESC(attach_group_by_node,
> > +              "Attach group to domain when it's in same node");
> >
> >  struct vfio_iommu {
> >       struct list_head        domain_list;
> > @@ -2287,19 +2292,23 @@ static int vfio_iommu_type1_attach_group(void *=
iommu_data,
> >               if (d->domain->ops =3D=3D domain->domain->ops &&
> >                   d->enforce_cache_coherency =3D=3D
> >                           domain->enforce_cache_coherency) {
> > -                     iommu_detach_group(domain->domain, group->iommu_g=
roup);
> > -                     if (!iommu_attach_group(d->domain,
> > -                                             group->iommu_group)) {
> > -                             list_add(&group->next, &d->group_list);
> > -                             iommu_domain_free(domain->domain);
> > -                             kfree(domain);
> > -                             goto done;
> > -                     }
> > +                     if ((attach_group_by_node =3D=3D 1 &&
> > +                             d->domain->nid =3D=3D domain->domain->nid=
) ||
> > +                             attach_group_by_node =3D=3D 0) {
> > +                             iommu_detach_group(domain->domain, group-=
>iommu_group);
> > +                             if (!iommu_attach_group(d->domain,
> > +                                                     group->iommu_grou=
p)) {
> > +                                     list_add(&group->next, &d->group_=
list);
> > +                                     iommu_domain_free(domain->domain)=
;
> > +                                     kfree(domain);
> > +                                     goto done;
> > +                             }
> >
> > -                     ret =3D iommu_attach_group(domain->domain,
> > -                                              group->iommu_group);
> > -                     if (ret)
> > -                             goto out_domain;
> > +                             ret =3D iommu_attach_group(domain->domain=
,
> > +                                             group->iommu_group);
> > +                             if (ret)
> > +                                     goto out_domain;
> > +                     }
> >               }
> >       }
> >
> > diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> > index ec289c1..c1330ed 100644
> > --- a/include/linux/iommu.h
> > +++ b/include/linux/iommu.h
> > @@ -123,6 +123,7 @@ struct iommu_domain {
> >                       int users;
> >               };
> >       };
> > +     int nid;
> >  };
> >
> >  static inline bool iommu_is_dma_domain(struct iommu_domain *domain)
>
> As I understand what's being done here, we're duplicating
> dmar_domain.nid to iommu_domain.nid, then when enabled by this new
> module option, we'll use this node id as part of the match to determine
> whether to create a new domain within the same container context or
> re-use an existing domain, which may have non-favorably locality.
>
> If we're going to implement a node id on the iommu_domain, it should
> replace the existing use of node id in the device specific structure
> and not simply duplicate it.  This should also account for non-VT-d use
> cases as well, for example AMD IOMMU also has a nid field on their
> protection_domain structure.  Alternatively this might be implemented
> through iommu_domain_ops so we could query the node association for a
> domain.
>
> I question whether we need this solution at all though.  AIUI the
> initial domain is allocated in proximity to the initial group.  The
> problem comes when the user asks to add an additional group into the
> same container.  Another valid solution would be that the user
> recognizes that these groups are not within the same locality and
> creates a separate container for this group.  In fact, if we're using
> QEMU here and created a q35 VM with vIOMMU, each device would have a
> separate address space and therefore a separate container and we'd
> already avoid the issue this patch tries to solve.
>
> Separate containers per QEMU AddressSpace are a requirement, but QEMU
> might also implement a policy to not re-use vfio containers between
> virtual nodes such that if each locality were mapped to separate PXBs
> with unique proximities, then simply reflecting the physical locality
> into the VM would be sufficient to avoid this non-optimal domain
> allocation placement.
>
> In any case, the type1 vfio IOMMU backend is in the early stages of
> deprecation, so any choices we make here would also need to be reflected
> in IOMMUFD, both in the compatibility and native interfaces.  Thanks,
>
> Alex
>


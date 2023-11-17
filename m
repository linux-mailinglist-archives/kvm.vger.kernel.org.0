Return-Path: <kvm+bounces-1982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 20A787EFB61
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 23:28:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 87B43B20C7E
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 22:28:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A79EA4652C;
	Fri, 17 Nov 2023 22:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZnCQf9k4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3346BD4F
	for <kvm@vger.kernel.org>; Fri, 17 Nov 2023 14:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700260071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AiZjKSvYvhsu7/NaT39ijvKLN1v9uLeQ5qahPEsXOuA=;
	b=ZnCQf9k4zl/e/3iE77Lbp7oWlxMuRaBMNi8/RIPyEwGmgFOWuj1Fe/MPG4TZSU4HcOejbo
	7mrDNKzfNcMC+rBEfuMOBuZLcLMZTnVmNXnGrl7bVOpXMpG0/F092h5YMECmPbyGXKuu6j
	2yZMA/rjcSibka8Z7WQttknMot6Q9wo=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-100-LP7m5RK-O9CbBIK4AyRUgA-1; Fri, 17 Nov 2023 17:27:50 -0500
X-MC-Unique: LP7m5RK-O9CbBIK4AyRUgA-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-421ace48f00so26412161cf.2
        for <kvm@vger.kernel.org>; Fri, 17 Nov 2023 14:27:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700260069; x=1700864869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AiZjKSvYvhsu7/NaT39ijvKLN1v9uLeQ5qahPEsXOuA=;
        b=Is1KoOnentN7uood3uxWIeRAHsbNmwADPCQL/guTpyiL4rpGw5hAxDq5Z69kfOmFzs
         O9zGTMmK17SG9fzzTDv8rIhkrxK2DS5cIvYjo+5yOBmoT1QnMnqdiU7aG/KMDa8hxBAa
         1mzcGOeBwh388HXRn5khCKKyfoX7gF8PTiWGVOUlwM15AWSbYW6VsaLigT7WizTuoYG9
         Vy5KPs4bXPWFeykw/eMZNaWI4HkcLHHn7MajCAC0xf767cCJHMBfg3euuyIzN2MyxZo3
         2L6B1m+B/iX/k989oV6AKWwrBj+dO1f7nJa0rQhuh3jGzZNrunmHo35DLxeYdp1KZrMw
         wOzA==
X-Gm-Message-State: AOJu0YxMhoLo3KdLm9jy8jNorjgPGxABmfFGInMZzNZOsOI586sny/rk
	/HbdzKRl8vRpZtaZyd6iW5OK+85doly8wlERqAXtsiy24pxeW6zvJLw4pnmVLp84gjU4C9rERJM
	uTUsh6//yhlcS
X-Received: by 2002:a05:622a:489:b0:418:134f:17f4 with SMTP id p9-20020a05622a048900b00418134f17f4mr1220635qtx.22.1700260069493;
        Fri, 17 Nov 2023 14:27:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG3FkLYOtTnQ+GMh7ZthjKHMc/IDRfHJKSpZF/RA1Mg2kREUnam2d8pU1JSK/6NXHglK6YeCg==
X-Received: by 2002:a05:622a:489:b0:418:134f:17f4 with SMTP id p9-20020a05622a048900b00418134f17f4mr1220612qtx.22.1700260069175;
        Fri, 17 Nov 2023 14:27:49 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id i2-20020ac84882000000b004166905aa2asm881752qtq.28.2023.11.17.14.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Nov 2023 14:27:48 -0800 (PST)
Date: Fri, 17 Nov 2023 15:27:46 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: yaozhenguo <yaozhenguo1@gmail.com>
Cc: yaozhenguo@jd.com, dwmw2@infradead.org, baolu.lu@linux.intel.com,
 joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Wenchao Yao <yaowenchao@jd.com>, ZiHan Zhou <zhouzihan30@jd.com>, Jason
 Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH V1] vfio: add attach_group_by_node to control behavior
 of attaching group to domain
Message-ID: <20231117152746.3aa55d68.alex.williamson@redhat.com>
In-Reply-To: <20231115020209.4665-1-yaozhenguo@jd.com>
References: <20231115020209.4665-1-yaozhenguo@jd.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Nov 2023 10:02:09 +0800
yaozhenguo <yaozhenguo1@gmail.com> wrote:

> From: Zhenguo Yao <yaozhenguo1@gmail.com>
>=20
> Groups will attach to one iommu_domain if ops and enforce_cache_coherency
> are equal. And all the iommu hardware share one pagetable by default.
> There are performance issue in some scenarios. For example:
> Host hardware topopy:
>=20
> node0 + PCIe RP0 ---+ GPU A100
>       |         |---+ GPU A100
>       |	        |---+ NIC Mellanox CX6
>       |	        |---+ NIC Mellanox CX6
>       + PCIe RP1 ---+ GPU A100
>                 |---+ GPU A100
>       	        |---+ NIC Mellanox CX6
>                 |---+ NIC Mellanox CX6
> node1 + PCIe RP0 ---+ GPU A100
>       |         |---+ GPU A100
>       |	        |---+ NIC Mellanox CX6
>       |	        |---+ NIC Mellanox CX6
>       + PCIe RP1 ---+ GPU A100
>                 |---+ GPU A100
>       	        |---+ NIC Mellanox CX6
>                 |---+ NIC Mellanox CX6
>=20
> We passthrough all NICs and GPU to VM, and emulate host hardware topopy.
> Mellanox CX6 ATS feature is enabled, GPU direct RDMA enabled.
> We test NCCL allreduce in VM at different cases.
>=20
> Case1: allreduce test use 4nic and 4GPU in numa0.
> Case2=EF=BC=9Aallreduce test use 4nic and 4GPU in numa1.
> case3: allreduce test use 8nic and 8GPU.
>=20
> the result are below:
>=20
> |        | algbw (GB/S) |
> | ------ | -------------|
> | case1  | 24           |
> | case2  | 32           |
> | case3  | 45           |
>=20
> We checked that IOMMU pagetable is allocated in numa1 when VM boot up.
> So, if IOTLB miss happan, IOMMU hardware in numa0 will access remote
> pagetable in numa1. This will drop performance. After apply this patch and
> attach_group_by_node is 1. Group in same node will attach to one domain.
> IOMMU will access there local pagetable. Performance is improved:
>=20
> |        | algbw (GB/S) |
> | ------ | -------------|
> | case1  | 32           |
> | case2  | 32           |
> | case3  | 63           |
>=20
> Signed-off-by: Zhenguo Yao <yaozhenguo1@gmail.com>
> Co-developed-by: Wenchao Yao <yaowenchao@jd.com>
> Signed-off-by: Wenchao Yao <yaowenchao@jd.com>
> Co-developed-by: ZiHan Zhou <zhouzihan30@jd.com>
> Signed-off-by: ZiHan Zhou <zhouzihan30@jd.com>
> ---
>  drivers/iommu/intel/iommu.c     |  8 +++++++-
>  drivers/vfio/vfio_iommu_type1.c | 33 +++++++++++++++++++++------------
>  include/linux/iommu.h           |  1 +
>  3 files changed, 29 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 3531b95..2c6d8f0 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -569,8 +569,10 @@ void domain_update_iommu_cap(struct dmar_domain *dom=
ain)
>  	 * If RHSA is missing, we should default to the device numa domain
>  	 * as fall back.
>  	 */
> -	if (domain->nid =3D=3D NUMA_NO_NODE)
> +	if (domain->nid =3D=3D NUMA_NO_NODE) {
>  		domain->nid =3D domain_update_device_node(domain);
> +		domain->domain.nid =3D domain->nid;
> +	}
> =20
>  	/*
>  	 * First-level translation restricts the input-address to a
> @@ -1767,6 +1769,7 @@ static struct dmar_domain *alloc_domain(unsigned in=
t type)
>  		return NULL;
> =20
>  	domain->nid =3D NUMA_NO_NODE;
> +	domain->domain.nid =3D NUMA_NO_NODE;
>  	if (first_level_by_default(type))
>  		domain->use_first_level =3D true;
>  	domain->has_iotlb_device =3D false;
> @@ -1808,6 +1811,8 @@ int domain_attach_iommu(struct dmar_domain *domain,=
 struct intel_iommu *iommu)
>  	info->refcnt	=3D 1;
>  	info->did	=3D num;
>  	info->iommu	=3D iommu;
> +	domain->nid     =3D iommu->node;
> +	domain->domain.nid     =3D iommu->node;
>  	curr =3D xa_cmpxchg(&domain->iommu_array, iommu->seq_id,
>  			  NULL, info, GFP_ATOMIC);
>  	if (curr) {
> @@ -1837,6 +1842,7 @@ void domain_detach_iommu(struct dmar_domain *domain=
, struct intel_iommu *iommu)
>  		clear_bit(info->did, iommu->domain_ids);
>  		xa_erase(&domain->iommu_array, iommu->seq_id);
>  		domain->nid =3D NUMA_NO_NODE;
> +		domain->domain.nid =3D NUMA_NO_NODE;
>  		domain_update_iommu_cap(domain);
>  		kfree(info);
>  	}
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_ty=
pe1.c
> index eacd6ec..6a5641e 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -59,6 +59,11 @@
>  module_param_named(dma_entry_limit, dma_entry_limit, uint, 0644);
>  MODULE_PARM_DESC(dma_entry_limit,
>  		 "Maximum number of user DMA mappings per container (65535).");
> +static uint attach_group_by_node;
> +module_param_named(attach_group_by_node,
> +		attach_group_by_node, uint, 0644);
> +MODULE_PARM_DESC(attach_group_by_node,
> +		 "Attach group to domain when it's in same node");
> =20
>  struct vfio_iommu {
>  	struct list_head	domain_list;
> @@ -2287,19 +2292,23 @@ static int vfio_iommu_type1_attach_group(void *io=
mmu_data,
>  		if (d->domain->ops =3D=3D domain->domain->ops &&
>  		    d->enforce_cache_coherency =3D=3D
>  			    domain->enforce_cache_coherency) {
> -			iommu_detach_group(domain->domain, group->iommu_group);
> -			if (!iommu_attach_group(d->domain,
> -						group->iommu_group)) {
> -				list_add(&group->next, &d->group_list);
> -				iommu_domain_free(domain->domain);
> -				kfree(domain);
> -				goto done;
> -			}
> +			if ((attach_group_by_node =3D=3D 1 &&
> +				d->domain->nid =3D=3D domain->domain->nid) ||
> +				attach_group_by_node =3D=3D 0) {
> +				iommu_detach_group(domain->domain, group->iommu_group);
> +				if (!iommu_attach_group(d->domain,
> +							group->iommu_group)) {
> +					list_add(&group->next, &d->group_list);
> +					iommu_domain_free(domain->domain);
> +					kfree(domain);
> +					goto done;
> +				}
> =20
> -			ret =3D iommu_attach_group(domain->domain,
> -						 group->iommu_group);
> -			if (ret)
> -				goto out_domain;
> +				ret =3D iommu_attach_group(domain->domain,
> +						group->iommu_group);
> +				if (ret)
> +					goto out_domain;
> +			}
>  		}
>  	}
> =20
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index ec289c1..c1330ed 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -123,6 +123,7 @@ struct iommu_domain {
>  			int users;
>  		};
>  	};
> +	int nid;
>  };
> =20
>  static inline bool iommu_is_dma_domain(struct iommu_domain *domain)

As I understand what's being done here, we're duplicating
dmar_domain.nid to iommu_domain.nid, then when enabled by this new
module option, we'll use this node id as part of the match to determine
whether to create a new domain within the same container context or
re-use an existing domain, which may have non-favorably locality.

If we're going to implement a node id on the iommu_domain, it should
replace the existing use of node id in the device specific structure
and not simply duplicate it.  This should also account for non-VT-d use
cases as well, for example AMD IOMMU also has a nid field on their
protection_domain structure.  Alternatively this might be implemented
through iommu_domain_ops so we could query the node association for a
domain.

I question whether we need this solution at all though.  AIUI the
initial domain is allocated in proximity to the initial group.  The
problem comes when the user asks to add an additional group into the
same container.  Another valid solution would be that the user
recognizes that these groups are not within the same locality and
creates a separate container for this group.  In fact, if we're using
QEMU here and created a q35 VM with vIOMMU, each device would have a
separate address space and therefore a separate container and we'd
already avoid the issue this patch tries to solve.

Separate containers per QEMU AddressSpace are a requirement, but QEMU
might also implement a policy to not re-use vfio containers between
virtual nodes such that if each locality were mapped to separate PXBs
with unique proximities, then simply reflecting the physical locality
into the VM would be sufficient to avoid this non-optimal domain
allocation placement.

In any case, the type1 vfio IOMMU backend is in the early stages of
deprecation, so any choices we make here would also need to be reflected
in IOMMUFD, both in the compatibility and native interfaces.  Thanks,

Alex



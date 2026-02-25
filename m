Return-Path: <kvm+bounces-71905-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mNkuKCyKn2nYcgQAu9opvQ
	(envelope-from <kvm+bounces-71905-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 00:47:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C452619F10A
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 00:47:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 091163061606
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 23:47:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 745F63859C2;
	Wed, 25 Feb 2026 23:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iHFyE8Gr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150C33859C5
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 23:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772063261; cv=pass; b=QSRbJWPftLDhbes+xsHhJwqsEpFyjm0mJ79KUoBxlYTtumAzhmbEW9Z2WIvebORXNs7YbUraj9L0+TM2hi1Iz00co2NkP8PlrDySmVAg07IplCLajxV6V6lcSxA6YOmiH5UcCuM/ouE+SjOqcp6caA40D0FmW1n42M7EI+yI8uQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772063261; c=relaxed/simple;
	bh=AT78Wt0eT2zEhvIauIIQBwA2YGKTG+vqCGVD1OoaXIs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jAqeMVDJIuLbomBAW1rR2KhPJR0gZYQeT5AfWdNYfOPFWMMxjFPMNfkGjhjEBN+ZgdbSpGN1zPJcyZ4gmgKXimIHcy+XtrMUXAqkJ+VspUYsiPMRWIc3AdqrsbsBbyn7VCp9YMFGygRKSGeM7fzGHU/Djlo/+/G5uXsX53Fz4V0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iHFyE8Gr; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5069a785ed2so119731cf.1
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 15:47:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772063258; cv=none;
        d=google.com; s=arc-20240605;
        b=WWuyNw4fSOr3nb0CqwEoj7/jaGxbavnPjA0t8PlQFPCbmgtBb0/9DLdFNiOHioKiAF
         8ZoaIqDuz1+LdLM/Uzr7sE+v7MNESj6amL+G8i3fAgBemiz2Oi/6XjHLe3HIEeUi2veG
         8U21IgLZnzHX9mualx62NO9WyDOwBZvivBakJz9AZl9jjCiSegdlkw9EDBmj+uNT7Zx5
         +hzgYBWG2eOIVe1ObzjyXIZOxPTqjeTnm1NLYDAAkdhgaCDpQuFocQXmtAb4GyXw6ItQ
         +AuglHlUN/J1isAaCkRVBzqKWlhOHe+Z/5YD9Vg/noxcN03WZPhDM1OLBx6x3MYGYz/y
         rQ+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xihrM+qx5MuAAtwb//a3SSpna7Wq86u+HZR71tsZhaw=;
        fh=Wn3Q2R+xB/nyXFn2P9q5dsbs27I/GJZD0L3SSvEt/H8=;
        b=fT4X7BJi/Gpqbp8Xh/CLA+F+5AvcTP1WgEeB86XSXjqMwwCOCH/Sn6KWWT+uIT8ESB
         YcR6KTyHFtLmxvyD6GHqbaR7JkCjMqndlvY70fQiD1ufuUDwRIgKVHlQtrNdAZztvN1O
         jSzEvXTIEidzjy75H1bRfY1gcY/gB6ci2XjtbJhES0xfXIwzUKBiJd7JGXh3XGdXObnj
         HI3bAuxVEqVBvMOOnUToE43ZTomeP0LV6AsvOyIWWk5iU+zb04aWXfc42nN1tMNewf3V
         NaY18Iqo3jVTbWgXLXmV7k7N/NZ4RJMxxo3pDS5/YpkDYiEWM5F9SFgKow3v1+GrFObp
         au4A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772063258; x=1772668058; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xihrM+qx5MuAAtwb//a3SSpna7Wq86u+HZR71tsZhaw=;
        b=iHFyE8GrEbwgiP+4ah+Fh0UwetGgFw43H46QtCkMZEWZkU2BytHZ2iT1MgavwBsfkF
         tR2/1Nhv5dK5OfotN97JGf8Nw/UQFi8qffQ6Dw0FQUI/5wsmROpuUFEe/dKTmtZIKPlD
         /4AyWFe/IAU4nDmi4cmfLUsVE8wflDQIjTm4tuibx8/GOBPb6trDumLzI6VWcUSm2vPm
         CZbvb9QSM1y9oj5NsP4K2pixcVyf+0BpreJaPf7gCjAsdVTS8E/V0uweFFxILgd86ezZ
         QJM13U67KevlY/T7HGdZnpQApeAxxhD+5UKKQv81wUdbBlvE+r5KVTl0b3OzvcJGkPQ0
         Sbuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772063258; x=1772668058;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xihrM+qx5MuAAtwb//a3SSpna7Wq86u+HZR71tsZhaw=;
        b=tu7Aufjc5LEiL1XR4sEwuf4pJnEWT3/SrfIaZcKO7vsC69OL01TrCFwuiU7IFFXURm
         nbOCbwolwgcAs/sZs2Nacfa2D7ZBp6Rbk5Z4wC2nTm4s7ucxaVg8qf3vAK6tUl4p442p
         swdqwODb5eRiLTsMiXyqDofqeXDx0+QrSUmtnGOPJmwQoVSoy3an8iFRWiiZt6JBezA3
         sTYOKJSabNMTnugCnpvL+j6rCX/XohtXfUTNtnds2EQpuF7AFa+Y4UIfqgimOynKMBKS
         h1jmIcfpBWn3hisIs0nG0NQ2wQOW7ZOWsQJy0UkUpgarr0e6iWHuhlYtnvOFiTcHyIxb
         E8Gw==
X-Forwarded-Encrypted: i=1; AJvYcCVgnetpoDj4p4K6Am+43JOjGhzgOIxAWP+uGPL+YmVYsXyHSmq4W409pH8R+9cdqxDb9c8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrxPd/x8h4gtO0NKrvXBMtYRuhbgrz9YteNYhMq5MQQ/Io2Cv7
	bU5X/o1rRTSF5iuq5lR/MJ9lMoZeGFh6jROc0HQn+ClPYdipSVX6EV0z3McMVZa5+O8l3BVtJYk
	0sl0fB5reahU86dzCD04xpBZbC+BX0pHBI4qCN/Jz
X-Gm-Gg: ATEYQzylbgQKhHHAizAa1vcPi5rR2vv2ln1ef2GNsR/WrZWfaELu8Wo+0+EbIctVSfc
	o0g5R5HbMqJKdN1toEOp5SFpjqoyUzFuoN52U1+X+4HxsOlkhV02frW4IlokilS3oMldtUPl4FT
	FD3JfN5gKhQdMOwDaRDrAe5LVuWNLrl+L623d4ngNoP3Xd/u+CsqH28JRuAOoOnfAI8SmBfuNhf
	swVP39TQXjiZ7kPGIIfduDocS4WrrtNOkcxPX4niY2r7PDZFublhhtcxiKhqVrS+Z7wFryHEidC
	JDxB0fXeOJZZ1anEc5QSEL2x96SNdjyDIZSxEbRuUA==
X-Received: by 2002:ac8:5f54:0:b0:4ff:bffa:d9e4 with SMTP id
 d75a77b69052e-50745515e41mr2093821cf.13.1772063257216; Wed, 25 Feb 2026
 15:47:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260203220948.2176157-1-skhawaja@google.com> <20260203220948.2176157-12-skhawaja@google.com>
In-Reply-To: <20260203220948.2176157-12-skhawaja@google.com>
From: Samiullah Khawaja <skhawaja@google.com>
Date: Wed, 25 Feb 2026 15:47:25 -0800
X-Gm-Features: AaiRm511ZJBpkaV9wmA-RH05nfIWQ50SOIU0KuxecKWG6gusqGy0i7t3N7GbdiA
Message-ID: <CAAywjhS2pFC01ayqy0VLwPLrw8w8zaFukKMQ+OB09_BSxYOJYw@mail.gmail.com>
Subject: Re: [PATCH 11/14] iommufd-lu: Persist iommu hardware pagetables for
 live update
To: David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: YiFei Zhu <zhuyifei@google.com>, Robin Murphy <robin.murphy@arm.com>, 
	Kevin Tian <kevin.tian@intel.com>, Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Saeed Mahameed <saeedm@nvidia.com>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Parav Pandit <parav@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>, William Tu <witu@nvidia.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Pranjal Shrivastava <praan@google.com>, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71905-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[25];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[skhawaja@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: C452619F10A
X-Rspamd-Action: no action

On Tue, Feb 3, 2026 at 2:10=E2=80=AFPM Samiullah Khawaja <skhawaja@google.c=
om> wrote:
>
> From: YiFei Zhu <zhuyifei@google.com>
>
> The caller is expected to mark each HWPT to be preserved with an ioctl
> call, with a token that will be used in restore. At preserve time, each
> HWPT's domain is then called with iommu_domain_preserve to preserve the
> iommu domain.
>
> The HWPTs containing dma mappings backed by unpreserved memory should
> not be preserved. During preservation check if the mappings contained in
> the HWPT being preserved are only file based and all the files are
> preserved.
>
> The memfd file preservation check is not enough when preserving iommufd.
> The memfd might have shrunk between the mapping and memfd preservation.
> This means that if it shrunk some pages that are right now pinned due to
> iommu mappings are not preserved with the memfd. Only allow iommufd
> preservation when all the iopt_pages are file backed and the memory file
> was seal sealed during mapping. This guarantees that all the pages that
> were backing memfd when it was mapped are preserved.
>
> Once HWPT is preserved the iopt associated with the HWPT is made
> immutable. Since the map and unmap ioctls operates directly on iopt,
> which contains an array of domains, while each hwpt contains only one
> domain. The logic then becomes that mapping and unmapping is prohibited
> if any of the domains in an iopt belongs to a preserved hwpt. However,
> tracing to the hwpt through the domain is a lot more tedious than
> tracing through the ioas, so if an hwpt is preserved, hwpt->ioas->iopt
> is made immutable.
>
> When undoing this (making the iopts mutable again), there's never
> a need to make some iopts mutable and some kept immutable, since
> the undo only happen on unpreserve and error path of preserve.
> Simply iterate all the ioas and clear the immutability flag on all
> their iopts.
>
> Signed-off-by: YiFei Zhu <zhuyifei@google.com>
> Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
> ---
>  drivers/iommu/iommufd/io_pagetable.c    |  17 ++
>  drivers/iommu/iommufd/io_pagetable.h    |   1 +
>  drivers/iommu/iommufd/iommufd_private.h |  25 ++
>  drivers/iommu/iommufd/liveupdate.c      | 300 ++++++++++++++++++++++++
>  drivers/iommu/iommufd/main.c            |  14 +-
>  drivers/iommu/iommufd/pages.c           |   8 +
>  include/linux/kho/abi/iommufd.h         |  39 +++
>  7 files changed, 403 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/kho/abi/iommufd.h
>
> diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd=
/io_pagetable.c
> index 436992331111..43e8a2443793 100644
> --- a/drivers/iommu/iommufd/io_pagetable.c
> +++ b/drivers/iommu/iommufd/io_pagetable.c
> @@ -270,6 +270,11 @@ static int iopt_alloc_area_pages(struct io_pagetable=
 *iopt,
>         }
>
>         down_write(&iopt->iova_rwsem);
> +       if (iopt_lu_map_immutable(iopt)) {
> +               rc =3D -EBUSY;
> +               goto out_unlock;
> +       }
> +
>         if ((length & (iopt->iova_alignment - 1)) || !length) {
>                 rc =3D -EINVAL;
>                 goto out_unlock;
> @@ -328,6 +333,7 @@ static void iopt_abort_area(struct iopt_area *area)
>                 WARN_ON(area->pages);
>         if (area->iopt) {
>                 down_write(&area->iopt->iova_rwsem);
> +               WARN_ON(iopt_lu_map_immutable(area->iopt));
>                 interval_tree_remove(&area->node, &area->iopt->area_itree=
);
>                 up_write(&area->iopt->iova_rwsem);
>         }
> @@ -755,6 +761,12 @@ static int iopt_unmap_iova_range(struct io_pagetable=
 *iopt, unsigned long start,
>  again:
>         down_read(&iopt->domains_rwsem);
>         down_write(&iopt->iova_rwsem);
> +
> +       if (iopt_lu_map_immutable(iopt)) {
> +               rc =3D -EBUSY;
> +               goto out_unlock_iova;
> +       }
> +
>         while ((area =3D iopt_area_iter_first(iopt, start, last))) {
>                 unsigned long area_last =3D iopt_area_last_iova(area);
>                 unsigned long area_first =3D iopt_area_iova(area);
> @@ -1398,6 +1410,11 @@ int iopt_cut_iova(struct io_pagetable *iopt, unsig=
ned long *iovas,
>         int i;
>
>         down_write(&iopt->iova_rwsem);
> +       if (iopt_lu_map_immutable(iopt)) {
> +               up_write(&iopt->iova_rwsem);
> +               return -EBUSY;
> +       }
> +
>         for (i =3D 0; i < num_iovas; i++) {
>                 struct iopt_area *area;
>
> diff --git a/drivers/iommu/iommufd/io_pagetable.h b/drivers/iommu/iommufd=
/io_pagetable.h
> index 14cd052fd320..b64cb4cf300c 100644
> --- a/drivers/iommu/iommufd/io_pagetable.h
> +++ b/drivers/iommu/iommufd/io_pagetable.h
> @@ -234,6 +234,7 @@ struct iopt_pages {
>                 struct {                        /* IOPT_ADDRESS_FILE */
>                         struct file *file;
>                         unsigned long start;
> +                       u32 seals;
>                 };
>                 /* IOPT_ADDRESS_DMABUF */
>                 struct iopt_pages_dmabuf dmabuf;
> diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iomm=
ufd/iommufd_private.h
> index 6424e7cea5b2..f8366a23999f 100644
> --- a/drivers/iommu/iommufd/iommufd_private.h
> +++ b/drivers/iommu/iommufd/iommufd_private.h
> @@ -94,6 +94,9 @@ struct io_pagetable {
>         /* IOVA that cannot be allocated, struct iopt_reserved */
>         struct rb_root_cached reserved_itree;
>         u8 disable_large_pages;
> +#ifdef CONFIG_IOMMU_LIVEUPDATE
> +       bool lu_map_immutable;
> +#endif
>         unsigned long iova_alignment;
>  };
>
> @@ -712,12 +715,34 @@ iommufd_get_vdevice(struct iommufd_ctx *ictx, u32 i=
d)
>  }
>
>  #ifdef CONFIG_IOMMU_LIVEUPDATE
> +int iommufd_liveupdate_register_lufs(void);
> +int iommufd_liveupdate_unregister_lufs(void);
> +
>  int iommufd_hwpt_lu_set_preserve(struct iommufd_ucmd *ucmd);
> +static inline bool iopt_lu_map_immutable(const struct io_pagetable *iopt=
)
> +{
> +       return iopt->lu_map_immutable;
> +}
>  #else
> +static inline int iommufd_liveupdate_register_lufs(void)
> +{
> +       return 0;
> +}
> +
> +static inline int iommufd_liveupdate_unregister_lufs(void)
> +{
> +       return 0;
> +}
> +
>  static inline int iommufd_hwpt_lu_set_preserve(struct iommufd_ucmd *ucmd=
)
>  {
>         return -ENOTTY;
>  }
> +
> +static inline bool iopt_lu_map_immutable(const struct io_pagetable *iopt=
)
> +{
> +       return false;
> +}
>  #endif
>
>  #ifdef CONFIG_IOMMUFD_TEST
> diff --git a/drivers/iommu/iommufd/liveupdate.c b/drivers/iommu/iommufd/l=
iveupdate.c
> index ae74f5b54735..ec11ae345fe7 100644
> --- a/drivers/iommu/iommufd/liveupdate.c
> +++ b/drivers/iommu/iommufd/liveupdate.c
> @@ -4,9 +4,15 @@
>
>  #include <linux/file.h>
>  #include <linux/iommufd.h>
> +#include <linux/kexec_handover.h>
> +#include <linux/kho/abi/iommufd.h>
>  #include <linux/liveupdate.h>
> +#include <linux/iommu-lu.h>
> +#include <linux/mm.h>
> +#include <linux/pci.h>
>
>  #include "iommufd_private.h"
> +#include "io_pagetable.h"
>
>  int iommufd_hwpt_lu_set_preserve(struct iommufd_ucmd *ucmd)
>  {
> @@ -47,3 +53,297 @@ int iommufd_hwpt_lu_set_preserve(struct iommufd_ucmd =
*ucmd)
>         return rc;
>  }
>
> +static void iommufd_set_ioas_mutable(struct iommufd_ctx *ictx)
> +{
> +       struct iommufd_object *obj;
> +       struct iommufd_ioas *ioas;
> +       unsigned long index;
> +
> +       xa_lock(&ictx->objects);
> +       xa_for_each(&ictx->objects, index, obj) {
> +               if (obj->type !=3D IOMMUFD_OBJ_IOAS)
> +                       continue;
> +
> +               ioas =3D container_of(obj, struct iommufd_ioas, obj);
> +
> +               /*
> +                * Not taking any IOAS lock here. All writers take LUO
> +                * session mutex, and this writer racing with readers is =
not
> +                * really a problem.
> +                */
> +               WRITE_ONCE(ioas->iopt.lu_map_immutable, false);
> +       }
> +       xa_unlock(&ictx->objects);
> +}
> +
> +static int check_iopt_pages_preserved(struct liveupdate_session *s,
> +                                     struct iommufd_hwpt_paging *hwpt)
> +{
> +       u32 req_seals =3D F_SEAL_SEAL | F_SEAL_GROW | F_SEAL_SHRINK;
> +       struct iopt_area *area;
> +       int ret;
> +
> +       for (area =3D iopt_area_iter_first(&hwpt->ioas->iopt, 0, ULONG_MA=
X); area;
> +            area =3D iopt_area_iter_next(area, 0, ULONG_MAX)) {
> +               struct iopt_pages *pages =3D area->pages;
> +
> +               /* Only allow file based mapping */
> +               if (pages->type !=3D IOPT_ADDRESS_FILE)
> +                       return -EINVAL;
> +
> +               /*
> +                * When this memory file was mapped it should be sealed a=
nd seal
> +                * should be sealed. This means that since mapping was do=
ne the
> +                * memory file was not grown or shrink and the pages bein=
g used
> +                * until now remain pinnned and preserved.
> +                */
> +               if ((pages->seals & req_seals) !=3D req_seals)
> +                       return -EINVAL;
> +
> +               /* Make sure that the file was preserved. */
> +               ret =3D liveupdate_get_token_outgoing(s, pages->file, NUL=
L);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +static int iommufd_save_hwpts(struct iommufd_ctx *ictx,
> +                             struct iommufd_lu *iommufd_lu,
> +                             struct liveupdate_session *session)
> +{
> +       struct iommufd_hwpt_paging *hwpt, **hwpts =3D NULL;
> +       struct iommu_domain_ser *domain_ser;
> +       struct iommufd_hwpt_lu *hwpt_lu;
> +       struct iommufd_object *obj;
> +       unsigned int nr_hwpts =3D 0;
> +       unsigned long index;
> +       unsigned int i;
> +       int rc =3D 0;
> +
> +       if (iommufd_lu) {
> +               hwpts =3D kcalloc(iommufd_lu->nr_hwpts, sizeof(*hwpts),
> +                               GFP_KERNEL);
> +               if (!hwpts)
> +                       return -ENOMEM;
> +       }
> +
> +       xa_lock(&ictx->objects);
> +       xa_for_each(&ictx->objects, index, obj) {
> +               if (obj->type !=3D IOMMUFD_OBJ_HWPT_PAGING)
> +                       continue;
> +
> +               hwpt =3D container_of(obj, struct iommufd_hwpt_paging, co=
mmon.obj);
> +               if (!hwpt->lu_preserve)
> +                       continue;
> +
> +               if (hwpt->ioas) {
> +                       /*
> +                        * Obtain exclusive access to the IOAS and IOPT w=
hile we
> +                        * set immutability
> +                        */
> +                       mutex_lock(&hwpt->ioas->mutex);
> +                       down_write(&hwpt->ioas->iopt.domains_rwsem);
> +                       down_write(&hwpt->ioas->iopt.iova_rwsem);
> +
> +                       hwpt->ioas->iopt.lu_map_immutable =3D true;
> +
> +                       up_write(&hwpt->ioas->iopt.iova_rwsem);
> +                       up_write(&hwpt->ioas->iopt.domains_rwsem);
> +                       mutex_unlock(&hwpt->ioas->mutex);
> +               }
> +
> +               if (!hwpt->common.domain) {
> +                       rc =3D -EINVAL;
> +                       xa_unlock(&ictx->objects);
> +                       goto out;
> +               }
> +
> +               if (!iommufd_lu) {
> +                       rc =3D check_iopt_pages_preserved(session, hwpt);
> +                       if (rc) {
> +                               xa_unlock(&ictx->objects);
> +                               goto out;
> +                       }
> +               } else if (iommufd_lu) {
> +                       hwpts[nr_hwpts] =3D hwpt;
> +                       hwpt_lu =3D &iommufd_lu->hwpts[nr_hwpts];
> +
> +                       hwpt_lu->token =3D hwpt->lu_token;
> +                       hwpt_lu->reclaimed =3D false;
> +               }
> +
> +               nr_hwpts++;
> +       }
> +       xa_unlock(&ictx->objects);
> +
> +       if (WARN_ON(iommufd_lu && iommufd_lu->nr_hwpts !=3D nr_hwpts)) {
> +               rc =3D -EFAULT;
> +               goto out;
> +       }
> +
> +       if (iommufd_lu) {
> +               /*
> +                * iommu_domain_preserve may sleep and must be called
> +                * outside of xa_lock
> +                */
> +               for (i =3D 0; i < nr_hwpts; i++) {
> +                       hwpt =3D hwpts[i];
> +                       hwpt_lu =3D &iommufd_lu->hwpts[i];
> +
> +                       rc =3D iommu_domain_preserve(hwpt->common.domain,=
 &domain_ser);
> +                       if (rc < 0)
> +                               goto out;
> +
> +                       hwpt_lu->domain_data =3D __pa(domain_ser);
> +               }
> +       }
> +
> +       rc =3D nr_hwpts;
> +
> +out:
> +       kfree(hwpts);
> +       return rc;
> +}
> +
> +static int iommufd_liveupdate_preserve(struct liveupdate_file_op_args *a=
rgs)
> +{
> +       struct iommufd_ctx *ictx =3D iommufd_ctx_from_file(args->file);
> +       struct iommufd_lu *iommufd_lu;
> +       size_t serial_size;
> +       void *mem;
> +       int rc;
> +
> +       if (IS_ERR(ictx))
> +               return PTR_ERR(ictx);
> +
> +       rc =3D iommufd_save_hwpts(ictx, NULL, args->session);
> +       if (rc < 0)
> +               goto err_ioas_mutable;
> +
> +       serial_size =3D struct_size(iommufd_lu, hwpts, rc);
> +
> +       mem =3D kho_alloc_preserve(serial_size);
> +       if (!mem) {
> +               rc =3D -ENOMEM;
> +               goto err_ioas_mutable;
> +       }
> +
> +       iommufd_lu =3D mem;
> +       iommufd_lu->nr_hwpts =3D rc;
> +       rc =3D iommufd_save_hwpts(ictx, iommufd_lu, args->session);
> +       if (rc < 0)
> +               goto err_free;
> +
> +       args->serialized_data =3D virt_to_phys(iommufd_lu);
> +       iommufd_ctx_put(ictx);
> +       return 0;
> +
> +err_free:
> +       kho_unpreserve_free(mem);
> +err_ioas_mutable:
> +       iommufd_set_ioas_mutable(ictx);
> +       iommufd_ctx_put(ictx);
> +       return rc;
> +}
> +
> +static int iommufd_liveupdate_freeze(struct liveupdate_file_op_args *arg=
s)
> +{
> +       /* No-Op; everything should be made read-only */
> +       return 0;
> +}
> +
> +static void iommufd_liveupdate_unpreserve(struct liveupdate_file_op_args=
 *args)
> +{
> +       struct iommufd_ctx *ictx =3D iommufd_ctx_from_file(args->file);
> +       struct iommufd_hwpt_paging *hwpt;
> +       struct iommufd_object *obj;
> +       unsigned long index;
> +
> +       if (WARN_ON(IS_ERR(ictx)))
> +               return;
> +
> +       xa_lock(&ictx->objects);
> +       xa_for_each(&ictx->objects, index, obj) {
> +               if (obj->type !=3D IOMMUFD_OBJ_HWPT_PAGING)
> +                       continue;
> +
> +               hwpt =3D container_of(obj, struct iommufd_hwpt_paging, co=
mmon.obj);
> +               if (!hwpt->lu_preserve)
> +                       continue;
> +               if (!hwpt->common.domain)
> +                       continue;
> +
> +               iommu_domain_unpreserve(hwpt->common.domain);
> +       }
> +       xa_unlock(&ictx->objects);
> +
> +       kho_unpreserve_free(phys_to_virt(args->serialized_data));
> +
> +       iommufd_set_ioas_mutable(ictx);
> +       iommufd_ctx_put(ictx);
> +}
> +
> +static int iommufd_liveupdate_retrieve(struct liveupdate_file_op_args *a=
rgs)
> +{
> +       return -EOPNOTSUPP;
> +}
> +
> +static bool iommufd_liveupdate_can_finish(struct liveupdate_file_op_args=
 *args)
> +{
> +       return false;
> +}
> +
> +static void iommufd_liveupdate_finish(struct liveupdate_file_op_args *ar=
gs)
> +{
> +}
> +
> +static bool iommufd_liveupdate_can_preserve(struct liveupdate_file_handl=
er *handler,
> +                                           struct file *file)
> +{
> +       struct iommufd_ctx *ictx =3D iommufd_ctx_from_file(file);
> +
> +       if (IS_ERR(ictx))
> +               return false;
> +
> +       iommufd_ctx_put(ictx);
> +       return true;
> +}
> +
> +static struct liveupdate_file_ops iommufd_lu_file_ops =3D {
> +       .can_preserve =3D iommufd_liveupdate_can_preserve,
> +       .preserve =3D iommufd_liveupdate_preserve,
> +       .unpreserve =3D iommufd_liveupdate_unpreserve,
> +       .freeze =3D iommufd_liveupdate_freeze,
> +       .retrieve =3D iommufd_liveupdate_retrieve,
> +       .can_finish =3D iommufd_liveupdate_can_finish,
> +       .finish =3D iommufd_liveupdate_finish,
> +};
> +
> +static struct liveupdate_file_handler iommufd_lu_handler =3D {
> +       .compatible =3D IOMMUFD_LUO_COMPATIBLE,
> +       .ops =3D &iommufd_lu_file_ops,
> +};
> +
> +int iommufd_liveupdate_register_lufs(void)
> +{
> +       int ret;
> +
> +       ret =3D liveupdate_register_file_handler(&iommufd_lu_handler);
> +       if (ret)
> +               return ret;
> +
> +       ret =3D iommu_liveupdate_register_flb(&iommufd_lu_handler);
> +       if (ret)
> +               liveupdate_unregister_file_handler(&iommufd_lu_handler);
> +
> +       return ret;
> +}
> +
> +int iommufd_liveupdate_unregister_lufs(void)
> +{
> +       WARN_ON(iommu_liveupdate_unregister_flb(&iommufd_lu_handler));
> +
> +       return liveupdate_unregister_file_handler(&iommufd_lu_handler);
> +}
> diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
> index e1a9b3051f65..d7683244c67a 100644
> --- a/drivers/iommu/iommufd/main.c
> +++ b/drivers/iommu/iommufd/main.c
> @@ -775,11 +775,21 @@ static int __init iommufd_init(void)
>                 if (ret)
>                         goto err_misc;
>         }
> +
> +       if (IS_ENABLED(CONFIG_IOMMU_LIVEUPDATE)) {
> +               ret =3D iommufd_liveupdate_register_lufs();

Alex Williamson pointed out in the vfio-pci preservation series that
registering the file handler in module init/exit would make the module
unloadable as LUO takes a reference on it. That problem will occur
here also as the registration is being done in module_init. For
iommufd, the register/unregister can be moved to iommufd open/release.
Register on first iommufd open and unregister on last iommufd close,
basically a kref that gets inc/dec on open/release.

https://lore.kernel.org/all/20260225143328.35be89f6@shazbot.org/
> +               if (ret)
> +                       goto err_vfio_misc;
> +       }
> +
>         ret =3D iommufd_test_init();
>         if (ret)
> -               goto err_vfio_misc;
> +               goto err_lufs;
>         return 0;
>
> +err_lufs:
> +       if (IS_ENABLED(CONFIG_IOMMU_LIVEUPDATE))
> +               iommufd_liveupdate_unregister_lufs();
>  err_vfio_misc:
>         if (IS_ENABLED(CONFIG_IOMMUFD_VFIO_CONTAINER))
>                 misc_deregister(&vfio_misc_dev);
> @@ -791,6 +801,8 @@ static int __init iommufd_init(void)
>  static void __exit iommufd_exit(void)
>  {
>         iommufd_test_exit();
> +       if (IS_ENABLED(CONFIG_IOMMU_LIVEUPDATE))
> +               iommufd_liveupdate_unregister_lufs();
>         if (IS_ENABLED(CONFIG_IOMMUFD_VFIO_CONTAINER))
>                 misc_deregister(&vfio_misc_dev);
>         misc_deregister(&iommu_misc_dev);
> diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.=
c
> index dbe51ecb9a20..cc0e3265ba4e 100644
> --- a/drivers/iommu/iommufd/pages.c
> +++ b/drivers/iommu/iommufd/pages.c
> @@ -55,6 +55,7 @@
>  #include <linux/overflow.h>
>  #include <linux/slab.h>
>  #include <linux/sched/mm.h>
> +#include <linux/memfd.h>
>  #include <linux/vfio_pci_core.h>
>
>  #include "double_span.h"
> @@ -1420,6 +1421,7 @@ struct iopt_pages *iopt_alloc_file_pages(struct fil=
e *file,
>
>  {
>         struct iopt_pages *pages;
> +       int seals;
>
>         pages =3D iopt_alloc_pages(start_byte, length, writable);
>         if (IS_ERR(pages))
> @@ -1427,6 +1429,12 @@ struct iopt_pages *iopt_alloc_file_pages(struct fi=
le *file,
>         pages->file =3D get_file(file);
>         pages->start =3D start - start_byte;
>         pages->type =3D IOPT_ADDRESS_FILE;
> +
> +       pages->seals =3D 0;
> +       seals =3D memfd_get_seals(file);
> +       if (seals > 0)
> +               pages->seals =3D seals;
> +
>         return pages;
>  }
>
> diff --git a/include/linux/kho/abi/iommufd.h b/include/linux/kho/abi/iomm=
ufd.h
> new file mode 100644
> index 000000000000..f7393ac78aa9
> --- /dev/null
> +++ b/include/linux/kho/abi/iommufd.h
> @@ -0,0 +1,39 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +/*
> + * Copyright (C) 2025, Google LLC
> + * Author: Samiullah Khawaja <skhawaja@google.com>
> + */
> +
> +#ifndef _LINUX_KHO_ABI_IOMMUFD_H
> +#define _LINUX_KHO_ABI_IOMMUFD_H
> +
> +#include <linux/mutex_types.h>
> +#include <linux/compiler.h>
> +#include <linux/types.h>
> +
> +/**
> + * DOC: IOMMUFD Live Update ABI
> + *
> + * This header defines the ABI for preserving the state of an IOMMUFD fi=
le
> + * across a kexec reboot using LUO.
> + *
> + * This interface is a contract. Any modification to any of the serializ=
ation
> + * structs defined here constitutes a breaking change. Such changes requ=
ire
> + * incrementing the version number in the IOMMUFD_LUO_COMPATIBLE string.
> + */
> +
> +#define IOMMUFD_LUO_COMPATIBLE "iommufd-v1"
> +
> +struct iommufd_hwpt_lu {
> +       u32 token;
> +       u64 domain_data;
> +       bool reclaimed;
> +} __packed;
> +
> +struct iommufd_lu {
> +       unsigned int nr_hwpts;
> +       struct iommufd_hwpt_lu hwpts[];
> +};
> +
> +#endif /* _LINUX_KHO_ABI_IOMMUFD_H */
> --
> 2.53.0.rc2.204.g2597b5adb4-goog
>


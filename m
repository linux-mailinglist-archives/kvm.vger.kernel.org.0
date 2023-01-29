Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3E9067FD06
	for <lists+kvm@lfdr.de>; Sun, 29 Jan 2023 07:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbjA2GDI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Jan 2023 01:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbjA2GDG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Jan 2023 01:03:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F7722DE7
        for <kvm@vger.kernel.org>; Sat, 28 Jan 2023 22:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674972142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G+y0lNUe2D3FZqvZZMcDdGneE6tCR0dFmD5Cj+Ac+co=;
        b=YvIV1iewCrbw3wBYBARhLg0s9HQKXGUTeaBlhrMsgzTc/RDwnyG3PbIopdGvz75XY9IAef
        aE1LR1mB2lzA1chcDA2nkbXaPZtVJwOaYhWl+/+FzvQjh2TXFwSQAvhULHvMwocm6J1Ol0
        /z/Y8Ux0PIA6g3HVRpMO+5m7SzCjsH8=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-643-G2ccRi1JMvGGFAB0xoLBFg-1; Sun, 29 Jan 2023 01:02:20 -0500
X-MC-Unique: G2ccRi1JMvGGFAB0xoLBFg-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-16364c64654so2340849fac.10
        for <kvm@vger.kernel.org>; Sat, 28 Jan 2023 22:02:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G+y0lNUe2D3FZqvZZMcDdGneE6tCR0dFmD5Cj+Ac+co=;
        b=3T5RWb771+86ANqQiWJX4o+E4euvUftHVy1HqtJUOXBTkkmf4anHoQcyY5kNMBVHKD
         PKNFgFk65cdhj4OHUemwPNIGEAuzisQZXd5Svfd2QADn+JSQvahNH+8ZKT97WDkgRajf
         lf6FkO1Lhr3TGAmhCwyZCEWbTPUiT1nvsNn5/sme/w9QsVrMrgO9aYB19PkOvEJTP+jo
         /82pY5uZBu84ASceQ7Z6zPMiNnmlUW48MDfi8GZL8TkNycE3JIr5APxAXy2HNpyNjbne
         o6P+zRdT20k4H1xQQUOr722bFjFpTNter69sh5McomeetDdtvewq08U75SDIqEq6Y2Nr
         ZyrQ==
X-Gm-Message-State: AO0yUKWcH+idI0UooVXEb8/OvTCxDv1mpgJGGGdoR2k7BclbrqIBcLs4
        fW4qtBl8CLlMp0P1C8s5lexbuYNBILSDGor8q0PTO82x5pKjFnfePDkVfXE0c+y3h9FYWviijdk
        C5DYH6rwZdw95SiNJrHlBYr4++Oyk
X-Received: by 2002:a4a:3457:0:b0:517:7850:6483 with SMTP id n23-20020a4a3457000000b0051778506483mr942oof.3.1674972139677;
        Sat, 28 Jan 2023 22:02:19 -0800 (PST)
X-Google-Smtp-Source: AK7set8mW0JZ/n8lyZTTpcC67kMpT2Kinp8/MANimSerBoRFqCNzWu7WVdXpOca4BzGXE3JkgQMmFmJ+hFInW8+aXt4=
X-Received: by 2002:a4a:3457:0:b0:517:7850:6483 with SMTP id
 n23-20020a4a3457000000b0051778506483mr940oof.3.1674972139474; Sat, 28 Jan
 2023 22:02:19 -0800 (PST)
MIME-Version: 1.0
References: <20230128031740.166743-1-sunnanyong@huawei.com>
In-Reply-To: <20230128031740.166743-1-sunnanyong@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Sun, 29 Jan 2023 14:02:08 +0800
Message-ID: <CACGkMEtMAFMbhPnaaTwGRFofPM-p8ceKzAUbD2AFBz=fbR6hYQ@mail.gmail.com>
Subject: Re: [PATCH] vhost/vdpa: Add MSI translation tables to iommu for
 software-managed MSI
To:     Nanyong Sun <sunnanyong@huawei.com>
Cc:     joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
        mst@redhat.com, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        wangrong68@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 28, 2023 at 10:25 AM Nanyong Sun <sunnanyong@huawei.com> wrote:
>
> From: Rong Wang <wangrong68@huawei.com>
>
> Once enable iommu domain for one device, the MSI
> translation tables have to be there for software-managed MSI.
> Otherwise, platform with software-managed MSI without an
> irq bypass function, can not get a correct memory write event
> from pcie, will not get irqs.
> The solution is to obtain the MSI phy base address from
> iommu reserved region, and set it to iommu MSI cookie,
> then translation tables will be created while request irq.
>
> Signed-off-by: Rong Wang <wangrong68@huawei.com>
> Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
> ---
>  drivers/iommu/iommu.c |  1 +
>  drivers/vhost/vdpa.c  | 53 ++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 51 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index de91dd88705b..f6c65d5d8e2b 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2623,6 +2623,7 @@ void iommu_get_resv_regions(struct device *dev, struct list_head *list)
>         if (ops->get_resv_regions)
>                 ops->get_resv_regions(dev, list);
>  }
> +EXPORT_SYMBOL_GPL(iommu_get_resv_regions);
>
>  /**
>   * iommu_put_resv_regions - release resered regions
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index ec32f785dfde..31d3e9ed4cfa 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -1103,6 +1103,48 @@ static ssize_t vhost_vdpa_chr_write_iter(struct kiocb *iocb,
>         return vhost_chr_write_iter(dev, from);
>  }
>
> +static bool vhost_vdpa_check_sw_msi(struct list_head *dev_resv_regions, phys_addr_t *base)
> +{
> +       struct iommu_resv_region *region;
> +       bool ret = false;
> +
> +       list_for_each_entry(region, dev_resv_regions, list) {
> +               /*
> +                * The presence of any 'real' MSI regions should take
> +                * precedence over the software-managed one if the
> +                * IOMMU driver happens to advertise both types.
> +                */
> +               if (region->type == IOMMU_RESV_MSI) {
> +                       ret = false;
> +                       break;
> +               }
> +
> +               if (region->type == IOMMU_RESV_SW_MSI) {
> +                       *base = region->start;
> +                       ret = true;
> +               }
> +       }
> +
> +       return ret;
> +}

Can we unify this with what VFIO had?

> +
> +static int vhost_vdpa_get_msi_cookie(struct iommu_domain *domain, struct device *dma_dev)
> +{
> +       struct list_head dev_resv_regions;
> +       phys_addr_t resv_msi_base = 0;
> +       int ret = 0;
> +
> +       INIT_LIST_HEAD(&dev_resv_regions);
> +       iommu_get_resv_regions(dma_dev, &dev_resv_regions);
> +
> +       if (vhost_vdpa_check_sw_msi(&dev_resv_regions, &resv_msi_base))
> +               ret = iommu_get_msi_cookie(domain, resv_msi_base);
> +
> +       iommu_put_resv_regions(dma_dev, &dev_resv_regions);
> +
> +       return ret;
> +}
> +
>  static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
>  {
>         struct vdpa_device *vdpa = v->vdpa;
> @@ -1128,11 +1170,16 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
>
>         ret = iommu_attach_device(v->domain, dma_dev);
>         if (ret)
> -               goto err_attach;
> +               goto err_alloc_domain;
>
> -       return 0;
> +       ret = vhost_vdpa_get_msi_cookie(v->domain, dma_dev);

Do we need to check the overlap mapping and record it in the interval
tree (as what VFIO did)?

Thanks

> +       if (ret)
> +               goto err_attach_device;
>
> -err_attach:
> +       return 0;
> +err_attach_device:
> +       iommu_detach_device(v->domain, dma_dev);
> +err_alloc_domain:
>         iommu_domain_free(v->domain);
>         return ret;
>  }
> --
> 2.25.1
>


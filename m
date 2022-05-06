Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9E351DC5F
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 17:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443087AbiEFPqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 11:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351151AbiEFPqm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 11:46:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9E11C6D398
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 08:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651851777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1JuktvDsk0ZFHVCemJ5erXSbfyghWe36Oqb7RUgkJcM=;
        b=afwdWGRu4g4cazD33gDZ+ubpq/+49kWhtG0N6xQ5YgVlGkrmjbTgb4Guhw3KvmxgxNu4CS
        v6rnB+nTnn2bRcqlhjho+sPd3ZmQL9bUWRYmcdykWo4H2Gv+2SN5Y7D4huyquWkkMePfcD
        bd328sslsKEDS6h6XGlsT+d0t/CoSJo=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-K_SrPUQgMBmqBjgCNkEY_A-1; Fri, 06 May 2022 11:42:56 -0400
X-MC-Unique: K_SrPUQgMBmqBjgCNkEY_A-1
Received: by mail-io1-f70.google.com with SMTP id s129-20020a6b2c87000000b00657c1a3b52fso5177172ios.21
        for <kvm@vger.kernel.org>; Fri, 06 May 2022 08:42:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=1JuktvDsk0ZFHVCemJ5erXSbfyghWe36Oqb7RUgkJcM=;
        b=D2ot+G6H08y5lEw0Iyk5aQoKBSW5asUx2zWhUbz+tCl7gf6hvny3ytV63E5VJ62OzJ
         IhoNlr4VhLT0PiKlZw3ZoV1ydqH2tmPKhleEFn/anef0OUaFOhQeHsjeq2WU1OoS/cst
         Nezsx0sYT5IMjrNRuwg7urF0nNWqHbfEBlyzZpKhuYgW40tBZVHzM4A/Xdw0ohlJ4vvP
         D15sg6qT/MzIx9HaVb77Jr2CSb1IZR/pGMMRt2GbGJX6s40QYKXyS0HrfNcExu7vAF+V
         +sqUEKze8GFt7LuQuDDCj8vF5IwkY/0o0zrb3dx00Dd9XUK+JmrzXe7wZoFhlYugImII
         MefQ==
X-Gm-Message-State: AOAM532FT14je95NpSDjqxoQx73BHZpiyRaVghKk0sicrZ9ZB8n1bVwq
        NMoh9Kxm9JTydCCPmLHsi1pAIOnIMQjg4l12qJe3ksnSfzdqlpm28AnkJWU243vtsViVwwo9xvx
        sRVTDGWXVAPeF
X-Received: by 2002:a05:6602:2d49:b0:645:dcf0:3151 with SMTP id d9-20020a0566022d4900b00645dcf03151mr1575307iow.61.1651851775161;
        Fri, 06 May 2022 08:42:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPoJSduN+jmGjc4qWZGrmyj0kOyA2oDUwSPLk/S2l+X+b8QcpPYt04xnr3l6eTrO8X+OniPw==
X-Received: by 2002:a05:6602:2d49:b0:645:dcf0:3151 with SMTP id d9-20020a0566022d4900b00645dcf03151mr1575290iow.61.1651851774937;
        Fri, 06 May 2022 08:42:54 -0700 (PDT)
Received: from redhat.com ([98.55.18.59])
        by smtp.gmail.com with ESMTPSA id v4-20020a5ec104000000b0065a47e16f4bsm1310327iol.29.2022.05.06.08.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 08:42:54 -0700 (PDT)
Date:   Fri, 6 May 2022 09:42:53 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH v4 1/2] vfio/pci: Have all VFIO PCI drivers store the
 vfio_pci_core_device in drvdata
Message-ID: <20220506094253.38a16c1b.alex.williamson@redhat.com>
In-Reply-To: <1-v4-c841817a0349+8f-vfio_get_from_dev_jgg@nvidia.com>
References: <0-v4-c841817a0349+8f-vfio_get_from_dev_jgg@nvidia.com>
        <1-v4-c841817a0349+8f-vfio_get_from_dev_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  5 May 2022 20:21:39 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Having a consistent pointer in the drvdata will allow the next patch to
> make use of the drvdata from some of the core code helpers.
> 
> Use a WARN_ON inside vfio_pci_core_enable() to detect drivers that miss
> this.

Stale comment, I'll

s/vfio_pci_core_enable/vfio_pci_core_register_device/

on commit.  Looks ok otherwise.  Thanks,

Alex

> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 15 +++++++++++----
>  drivers/vfio/pci/mlx5/main.c                   | 15 +++++++++++----
>  drivers/vfio/pci/vfio_pci.c                    |  2 +-
>  drivers/vfio/pci/vfio_pci_core.c               |  4 ++++
>  4 files changed, 27 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 767b5d47631a49..e92376837b29e6 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -337,6 +337,14 @@ static int vf_qm_cache_wb(struct hisi_qm *qm)
>  	return 0;
>  }
>  
> +static struct hisi_acc_vf_core_device *hssi_acc_drvdata(struct pci_dev *pdev)
> +{
> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
> +
> +	return container_of(core_device, struct hisi_acc_vf_core_device,
> +			    core_device);
> +}
> +
>  static void vf_qm_fun_reset(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>  			    struct hisi_qm *qm)
>  {
> @@ -962,7 +970,7 @@ hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
>  
>  static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
>  {
> -	struct hisi_acc_vf_core_device *hisi_acc_vdev = dev_get_drvdata(&pdev->dev);
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hssi_acc_drvdata(pdev);
>  
>  	if (hisi_acc_vdev->core_device.vdev.migration_flags !=
>  				VFIO_MIGRATION_STOP_COPY)
> @@ -1274,11 +1282,10 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
>  					  &hisi_acc_vfio_pci_ops);
>  	}
>  
> +	dev_set_drvdata(&pdev->dev, &hisi_acc_vdev->core_device);
>  	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
>  	if (ret)
>  		goto out_free;
> -
> -	dev_set_drvdata(&pdev->dev, hisi_acc_vdev);
>  	return 0;
>  
>  out_free:
> @@ -1289,7 +1296,7 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
>  
>  static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
>  {
> -	struct hisi_acc_vf_core_device *hisi_acc_vdev = dev_get_drvdata(&pdev->dev);
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hssi_acc_drvdata(pdev);
>  
>  	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
>  	vfio_pci_core_uninit_device(&hisi_acc_vdev->core_device);
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index bbec5d288fee97..9f59f5807b8ab1 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -39,6 +39,14 @@ struct mlx5vf_pci_core_device {
>  	struct mlx5_vf_migration_file *saving_migf;
>  };
>  
> +static struct mlx5vf_pci_core_device *mlx5vf_drvdata(struct pci_dev *pdev)
> +{
> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
> +
> +	return container_of(core_device, struct mlx5vf_pci_core_device,
> +			    core_device);
> +}
> +
>  static struct page *
>  mlx5vf_get_migration_page(struct mlx5_vf_migration_file *migf,
>  			  unsigned long offset)
> @@ -505,7 +513,7 @@ static int mlx5vf_pci_get_device_state(struct vfio_device *vdev,
>  
>  static void mlx5vf_pci_aer_reset_done(struct pci_dev *pdev)
>  {
> -	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
> +	struct mlx5vf_pci_core_device *mvdev = mlx5vf_drvdata(pdev);
>  
>  	if (!mvdev->migrate_cap)
>  		return;
> @@ -614,11 +622,10 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>  		}
>  	}
>  
> +	dev_set_drvdata(&pdev->dev, &mvdev->core_device);
>  	ret = vfio_pci_core_register_device(&mvdev->core_device);
>  	if (ret)
>  		goto out_free;
> -
> -	dev_set_drvdata(&pdev->dev, mvdev);
>  	return 0;
>  
>  out_free:
> @@ -629,7 +636,7 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>  
>  static void mlx5vf_pci_remove(struct pci_dev *pdev)
>  {
> -	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
> +	struct mlx5vf_pci_core_device *mvdev = mlx5vf_drvdata(pdev);
>  
>  	vfio_pci_core_unregister_device(&mvdev->core_device);
>  	vfio_pci_core_uninit_device(&mvdev->core_device);
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 58839206d1ca7f..e34db35b8d61a1 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -151,10 +151,10 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  		return -ENOMEM;
>  	vfio_pci_core_init_device(vdev, pdev, &vfio_pci_ops);
>  
> +	dev_set_drvdata(&pdev->dev, vdev);
>  	ret = vfio_pci_core_register_device(vdev);
>  	if (ret)
>  		goto out_free;
> -	dev_set_drvdata(&pdev->dev, vdev);
>  	return 0;
>  
>  out_free:
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 06b6f3594a1316..65587fd5c021bb 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1821,6 +1821,10 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>  	struct pci_dev *pdev = vdev->pdev;
>  	int ret;
>  
> +	/* Drivers must set the vfio_pci_core_device to their drvdata */
> +	if (WARN_ON(vdev != dev_get_drvdata(&vdev->pdev->dev)))
> +		return -EINVAL;
> +
>  	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
>  		return -EINVAL;
>  


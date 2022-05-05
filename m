Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF6051C6C6
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383002AbiEESOd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382358AbiEESOc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:14:32 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.133.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2454C5AEE7
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 11:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651774251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yg9tBKo8YwX+geciglVyDpc4Di77rGlf8zvzYq5AfM0=;
        b=g23LhMKJcj0Ne63mw7zCnNKA2+Jvf0K55WFACQNdpftt2VVKDl/MAypZr34+h8WIS44LKJ
        HKABloVRcZAIMEmetVuI/pj0EWBaY19hVL4j6aPacZitFVQrw7zhMvgYprivW4tDsDziR4
        H2R3HMpgdzL+EH5LHD2HG7m0/++Wb4U=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-362-ojH6WdXPNvmoPFpewwJeXw-1; Thu, 05 May 2022 14:10:50 -0400
X-MC-Unique: ojH6WdXPNvmoPFpewwJeXw-1
Received: by mail-io1-f69.google.com with SMTP id i66-20020a6bb845000000b00657bac76fb4so3408786iof.15
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 11:10:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=yg9tBKo8YwX+geciglVyDpc4Di77rGlf8zvzYq5AfM0=;
        b=YhKh3D1VkgV19xHDLrM4oxuXi++P4vmtVucdo8ALjEWsKebqgIGNabqtF4WyJ7MJWa
         cWBDtCwQ6NU5QQ1PTco9AUcFRAcgxrkfYMYh5AOzb3vUti7L8uIKf/mqW+m2lf5WCC5P
         Sp4wxwS1P3mGtKddVgxyIxymKAIl3uHNB2+PiRL9CLrw21aZgK1fP+I0zRpYzImUfI85
         r1rvdlzhuKRXKZHmi7zA5sqGdRNHodAjBrzlGU1Ve64Rh4RXeA5bWsTbGC1hNblPPG7S
         tIMcA0bps1liFXQ+2pr/ygn/7Zpfu2JA/YSRZobxPW/DtpEGnY3cA/ZL4K6sjXlRL99F
         lOQA==
X-Gm-Message-State: AOAM531LhYd1HGEYop86DwISP8JCAXNq5AsBhYAPbMlZ3KcFUgBTnmsd
        1cLzdv7gEN7JavcLuja35NugLbXslq7TtmQw4Df6CThCk9HSWGvtL/FoAfC/VKakI7/8f5zuIZH
        usIXknMC/BaZr
X-Received: by 2002:a02:c88d:0:b0:32b:a357:71bb with SMTP id m13-20020a02c88d000000b0032ba35771bbmr2873586jao.203.1651774249437;
        Thu, 05 May 2022 11:10:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyN/l50QErwSm6JC2Tv6gRa6W7CxjDuoGUQE9AVrmHcG6jgpEj4AhBQnmeKAXYCoFew5k6h3A==
X-Received: by 2002:a02:c88d:0:b0:32b:a357:71bb with SMTP id m13-20020a02c88d000000b0032ba35771bbmr2873573jao.203.1651774249167;
        Thu, 05 May 2022 11:10:49 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id ci10-20020a0566383d8a00b0032b3a7817d6sm656180jab.154.2022.05.05.11.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 11:10:48 -0700 (PDT)
Date:   Thu, 5 May 2022 12:10:47 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH v3 1/2] vfio/pci: Have all VFIO PCI drivers store the
 vfio_pci_core_device in drvdata
Message-ID: <20220505121047.5b798dd6.alex.williamson@redhat.com>
In-Reply-To: <1-v3-4adf6c1b8e7c+170-vfio_get_from_dev_jgg@nvidia.com>
References: <0-v3-4adf6c1b8e7c+170-vfio_get_from_dev_jgg@nvidia.com>
        <1-v3-4adf6c1b8e7c+170-vfio_get_from_dev_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  4 May 2022 16:01:47 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Having a consistent pointer in the drvdata will allow the next patch to
> make use of the drvdata from some of the core code helpers.
> 
> Use a WARN_ON inside vfio_pci_core_enable() to detect drivers that miss
> this.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 14 +++++++++++---
>  drivers/vfio/pci/mlx5/main.c                   | 14 +++++++++++---
>  drivers/vfio/pci/vfio_pci_core.c               |  4 ++++
>  3 files changed, 26 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 767b5d47631a49..665691967a030c 100644
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
> @@ -1278,7 +1286,7 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
>  	if (ret)
>  		goto out_free;
>  
> -	dev_set_drvdata(&pdev->dev, hisi_acc_vdev);
> +	dev_set_drvdata(&pdev->dev, &hisi_acc_vdev->core_device);
>  	return 0;
>  
>  out_free:
> @@ -1289,7 +1297,7 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
>  
>  static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
>  {
> -	struct hisi_acc_vf_core_device *hisi_acc_vdev = dev_get_drvdata(&pdev->dev);
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hssi_acc_drvdata(pdev);
>  
>  	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
>  	vfio_pci_core_uninit_device(&hisi_acc_vdev->core_device);
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index bbec5d288fee97..3391f965abd9f0 100644
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
> @@ -618,7 +626,7 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>  	if (ret)
>  		goto out_free;
>  
> -	dev_set_drvdata(&pdev->dev, mvdev);
> +	dev_set_drvdata(&pdev->dev, &mvdev->core_device);
>  	return 0;
>  
>  out_free:
> @@ -629,7 +637,7 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>  
>  static void mlx5vf_pci_remove(struct pci_dev *pdev)
>  {
> -	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
> +	struct mlx5vf_pci_core_device *mvdev = mlx5vf_drvdata(pdev);
>  
>  	vfio_pci_core_unregister_device(&mvdev->core_device);
>  	vfio_pci_core_uninit_device(&mvdev->core_device);
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 06b6f3594a1316..53ad39d617653d 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -262,6 +262,10 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>  	u16 cmd;
>  	u8 msix_pos;
>  
> +	/* Drivers must set the vfio_pci_core_device to their drvdata */
> +	if (WARN_ON(vdev != dev_get_drvdata(&vdev->pdev->dev)))
> +		return -EINVAL;
> +

The ordering seems off, if we only validate in the core enable function
then we can only guarantee drvdata is correct once the user has opened
the device.  However, we start invoking power management controls,
which Abhishek proposes moving to runtime pm, from the core register
device function.  Therefore we've not validated drvdata for anything we
might do in the background, not under the direction of the user.

I'd also rather see the variant driver fail to register with the core
than to see a failure opening the device an arbitrary time later.
Thanks,

Alex

>  	vfio_pci_set_power_state(vdev, PCI_D0);
>  
>  	/* Don't allow our initial saved state to include busmaster */


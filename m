Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE0D433ED7
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 20:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbhJSS5b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 14:57:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51720 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231355AbhJSS5a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Oct 2021 14:57:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634669717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C9pInqT0x8tL+gZeRj+uARHfyBEVwwnUEmKq2gOLQEY=;
        b=hY50/xoU1NjO0sJNrJ57cxo1XZOFcm2DWJldATI0/Sv1gZs34+admk90IXSemXjVsrBW5S
        aa0JaGByHy56u0L1thiy2mKmGEIWkz7j9BUnqDzrQbFv20R7GQxRLSEhdVXFDiFN8BHnwi
        UubDlnlVdGpOETgihHgsPn2qxKGOSgk=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-GChjsJaBMMKzuyxuG6rl1A-1; Tue, 19 Oct 2021 14:55:15 -0400
X-MC-Unique: GChjsJaBMMKzuyxuG6rl1A-1
Received: by mail-ot1-f71.google.com with SMTP id b7-20020a0568301de700b0054e351e751aso2287706otj.11
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 11:55:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C9pInqT0x8tL+gZeRj+uARHfyBEVwwnUEmKq2gOLQEY=;
        b=hE8i6+wn7If93YnNH6mLZ1hKyTBS+mTZhOMzYdPvDSx3ROjg6qAdn0AajPocybsyU5
         FThjR4d6HCygQ+iTnO/WonaMd1O/aMPfjOS9yFvzXql9Wf0zd5N8E9fxGHAIvWQ9mEtq
         5rCQpt+mvmCsTTkL/Orc8Q1SDNwUhQjvnRXW5gR8d6Mfz54moeWya5e3teQaHUSeklBS
         60Blx6iiOLwkEvM04wD4w5VtYvdvBY3cMxZHy0IvOWLaiUtIQMJLDnPlES78ulP5PXHS
         2IqZd4+aNVDjwFelfOCWIzKGHN2pwQpewWlcRLkFkXsVzHxFRbj5+/s0cMsP7QqfLl13
         p/ig==
X-Gm-Message-State: AOAM533/iGCwDvu5D3JMbc1tHlmdPlsn4o5/AG8fHTGDt7+suRUdUx3v
        LT+CIGUoq/IXDI7Ra0/mm/wXzkgbC+6DLO+D4JGKI9imAWNXGqZUONU6IhSBQATcitk/+lMEbQD
        YIgjP14pEz4Kt
X-Received: by 2002:a05:6830:3184:: with SMTP id p4mr6660767ots.219.1634669714999;
        Tue, 19 Oct 2021 11:55:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyYuYWzej6WRwpFRe+xeU0VckgFTXZrx1wHyJQOQaSjSBmKomLO/QW64NjjAECvHkUqbcqg2A==
X-Received: by 2002:a05:6830:3184:: with SMTP id p4mr6660750ots.219.1634669714770;
        Tue, 19 Oct 2021 11:55:14 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id l1sm2328995oic.30.2021.10.19.11.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 11:55:14 -0700 (PDT)
Date:   Tue, 19 Oct 2021 12:55:13 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <bhelgaas@google.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V2 mlx5-next 14/14] vfio/mlx5: Use its own PCI
 reset_done error handler
Message-ID: <20211019125513.4e522af9.alex.williamson@redhat.com>
In-Reply-To: <20211019105838.227569-15-yishaih@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
        <20211019105838.227569-15-yishaih@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 Oct 2021 13:58:38 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> Register its own handler for pci_error_handlers.reset_done and update
> state accordingly.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/vfio/pci/mlx5/main.c | 33 ++++++++++++++++++++++++++++++++-
>  1 file changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index 621b7fc60544..b759c6e153b6 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -58,6 +58,7 @@ struct mlx5vf_pci_core_device {
>  	/* protect migartion state */
>  	struct mutex state_mutex;
>  	struct mlx5vf_pci_migration_info vmig;
> +	struct work_struct work;
>  };
>  
>  static int mlx5vf_pci_unquiesce_device(struct mlx5vf_pci_core_device *mvdev)
> @@ -615,6 +616,27 @@ static const struct vfio_device_ops mlx5vf_pci_ops = {
>  	.match = vfio_pci_core_match,
>  };
>  
> +static void mlx5vf_reset_work_handler(struct work_struct *work)
> +{
> +	struct mlx5vf_pci_core_device *mvdev =
> +		container_of(work, struct mlx5vf_pci_core_device, work);
> +
> +	mutex_lock(&mvdev->state_mutex);
> +	mlx5vf_reset_mig_state(mvdev);

I see this calls mlx5vf_reset_vhca_state() but how does that unfreeze
and unquiesce the device as necessary to get back to _RUNNING?

> +	mvdev->vmig.vfio_dev_state = VFIO_DEVICE_STATE_RUNNING;
> +	mutex_unlock(&mvdev->state_mutex);
> +}
> +
> +static void mlx5vf_pci_aer_reset_done(struct pci_dev *pdev)
> +{
> +	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
> +
> +	if (!mvdev->migrate_cap)
> +		return;
> +
> +	schedule_work(&mvdev->work);

This seems troublesome, how long does userspace poll the device state
after reset to get back to _RUNNING?  Seems we at least need a
flush_work() call when userspace reads the device state.  Thanks,

Alex

> +}
> +
>  static int mlx5vf_pci_probe(struct pci_dev *pdev,
>  			    const struct pci_device_id *id)
>  {
> @@ -634,6 +656,8 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>  			if (MLX5_CAP_GEN(mdev, migration)) {
>  				mvdev->migrate_cap = 1;
>  				mutex_init(&mvdev->state_mutex);
> +				INIT_WORK(&mvdev->work,
> +					  mlx5vf_reset_work_handler);
>  			}
>  			mlx5_vf_put_core_dev(mdev);
>  		}
> @@ -656,6 +680,8 @@ static void mlx5vf_pci_remove(struct pci_dev *pdev)
>  {
>  	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
>  
> +	if (mvdev->migrate_cap)
> +		cancel_work_sync(&mvdev->work);
>  	vfio_pci_core_unregister_device(&mvdev->core_device);
>  	vfio_pci_core_uninit_device(&mvdev->core_device);
>  	kfree(mvdev);
> @@ -668,12 +694,17 @@ static const struct pci_device_id mlx5vf_pci_table[] = {
>  
>  MODULE_DEVICE_TABLE(pci, mlx5vf_pci_table);
>  
> +const struct pci_error_handlers mlx5vf_err_handlers = {
> +	.reset_done = mlx5vf_pci_aer_reset_done,
> +	.error_detected = vfio_pci_aer_err_detected,
> +};
> +
>  static struct pci_driver mlx5vf_pci_driver = {
>  	.name = KBUILD_MODNAME,
>  	.id_table = mlx5vf_pci_table,
>  	.probe = mlx5vf_pci_probe,
>  	.remove = mlx5vf_pci_remove,
> -	.err_handler = &vfio_pci_core_err_handlers,
> +	.err_handler = &mlx5vf_err_handlers,
>  };
>  
>  static void __exit mlx5vf_pci_cleanup(void)


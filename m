Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A96CD518ABD
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 19:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240098AbiECRPQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 13:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238946AbiECRPM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 13:15:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B73671CB2C
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 10:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651597898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PmDpcAKRURnYViq/lT/qk3yWWoPeoPeLoyR0xccq8g0=;
        b=OVrN68JxCuXd78k32SJL0CvGSnYSDyf1ulZad/gsZreO+T1BvFkQkDHr3LVVLhIO8f/x6p
        4/7EnviCqP0ekD9rKOcKvtwjgkVbIPqMWu67ActN5ZAu0aPPaYI2LWK4LR/9X0bmRWvkNe
        YQPVrpeVRTRWzuWIIRm9ChdMfoSkoH8=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-EVMfGqPQPwaoQ1xcc0uZKQ-1; Tue, 03 May 2022 13:11:27 -0400
X-MC-Unique: EVMfGqPQPwaoQ1xcc0uZKQ-1
Received: by mail-il1-f197.google.com with SMTP id j16-20020a056e02125000b002cc39632ab9so9325462ilq.9
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 10:11:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=PmDpcAKRURnYViq/lT/qk3yWWoPeoPeLoyR0xccq8g0=;
        b=WXWQ8mg4lQQS8fuslNlrf2fI+qYAIw/ZMA4Y4k/uTAWjjYnV9rFKOKNntGsN5TXA4H
         F1CfJkNfr+GI+4gYyzMu1bxjmTWRlMoW+cG5bjY2p72Y9i1gnFIsDIb9v56CktaCME4R
         zvgUChCZLjBaZ/XhD0JyI2Ocog53F8EIW+3eLh05LRDUaX/TTRLWDH0SrsQ3Ju1uNuve
         BkkCd48aD0hIjdW6DMVGOHHREkLCFVn6Aa/WgZLYCd9qdfFyqyJmW8a/wWXCY4a8wXQD
         vS4U1DqOKcqa3NPuL/pc2TeImvfVvPvny/wcBK0qWq2PjCQiYTGjTD8JZcDwD1oZA15S
         Rq7Q==
X-Gm-Message-State: AOAM532qzDtOg0lQGjidHAsFNteUu+LsDtRm3OXxiKnrMfMUfc3pTdk7
        41cUQuIuft0MnLrdfTLwH/ikj6viDlaDMQVNZ27iOZeJ8FutsS7OJnwL2YvJtXBAM5heoP4gZVG
        uH9GrEIB+2Mq9
X-Received: by 2002:a92:3405:0:b0:2c8:70ad:fa86 with SMTP id b5-20020a923405000000b002c870adfa86mr6944738ila.268.1651597887006;
        Tue, 03 May 2022 10:11:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7d7yOwkgKoHubTk3YAA9A5VeFfPMRsv66nBH6pKBak6btih6TX9vYxf5tX3YhN+5w9tPJ4w==
X-Received: by 2002:a92:3405:0:b0:2c8:70ad:fa86 with SMTP id b5-20020a923405000000b002c870adfa86mr6944714ila.268.1651597886678;
        Tue, 03 May 2022 10:11:26 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id r2-20020a92c502000000b002cde6e352e2sm3578912ilg.44.2022.05.03.10.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 10:11:25 -0700 (PDT)
Date:   Tue, 3 May 2022 11:11:24 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v3 4/8] vfio/pci: Add support for setting driver data
 inside core layer
Message-ID: <20220503111124.38b07a9e.alex.williamson@redhat.com>
In-Reply-To: <20220425092615.10133-5-abhsahu@nvidia.com>
References: <20220425092615.10133-1-abhsahu@nvidia.com>
        <20220425092615.10133-5-abhsahu@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Apr 2022 14:56:11 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> The vfio driver is divided into two layers: core layer (implemented in
> vfio_pci_core.c) and parent driver (For example, vfio_pci, mlx5_vfio_pci,
> hisi_acc_vfio_pci, etc.). All the parent driver calls dev_set_drvdata()
> and assigns its own structure as driver data. Some of the callback
> functions are implemented in the core layer and these callback functions
> provide the reference of 'struct pci_dev' or 'struct device'. Currently,
> we use vfio_device_get_from_dev() which provides reference to the
> vfio_device for a device. But this function follows long path to extract
> the same. There are few cases, where we don't need to go through this
> long path if we get this through drvdata.
> 
> This patch moves the setting of drvdata inside the core layer. If we see
> the current implementation of parent driver structure implementation,
> then 'struct vfio_pci_core_device' is a first member so the pointer of
> the parent structure and 'struct vfio_pci_core_device' should be the same.
> 
> struct hisi_acc_vf_core_device {
>     struct vfio_pci_core_device core_device;
>     ...
> };
> 
> struct mlx5vf_pci_core_device {
>     struct vfio_pci_core_device core_device;
>     ...
> };
> 
> The vfio_pci.c uses 'struct vfio_pci_core_device' itself.
> 
> To support getting the drvdata in both the layers, we can put the
> restriction to make 'struct vfio_pci_core_device' as a first member.
> Also, vfio_pci_core_register_device() has this validation which makes sure
> that this prerequisite is always satisfied.
> 
> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  4 ++--
>  drivers/vfio/pci/mlx5/main.c                  |  3 +--
>  drivers/vfio/pci/vfio_pci.c                   |  4 ++--
>  drivers/vfio/pci/vfio_pci_core.c              | 24 ++++++++++++++++---
>  include/linux/vfio_pci_core.h                 |  7 +++++-
>  5 files changed, 32 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 767b5d47631a..c76c09302a8f 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -1274,11 +1274,11 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
>  					  &hisi_acc_vfio_pci_ops);
>  	}
>  
> -	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
> +	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device,
> +					    hisi_acc_vdev);
>  	if (ret)
>  		goto out_free;
>  
> -	dev_set_drvdata(&pdev->dev, hisi_acc_vdev);
>  	return 0;
>  
>  out_free:
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index bbec5d288fee..8689248f66f3 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -614,11 +614,10 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>  		}
>  	}
>  
> -	ret = vfio_pci_core_register_device(&mvdev->core_device);
> +	ret = vfio_pci_core_register_device(&mvdev->core_device, mvdev);
>  	if (ret)
>  		goto out_free;
>  
> -	dev_set_drvdata(&pdev->dev, mvdev);
>  	return 0;
>  
>  out_free:
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 2b047469e02f..e0f8027c5cd8 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -151,10 +151,10 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  		return -ENOMEM;
>  	vfio_pci_core_init_device(vdev, pdev, &vfio_pci_ops);
>  
> -	ret = vfio_pci_core_register_device(vdev);
> +	ret = vfio_pci_core_register_device(vdev, vdev);
>  	if (ret)
>  		goto out_free;
> -	dev_set_drvdata(&pdev->dev, vdev);
> +
>  	return 0;
>  
>  out_free:
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 1271728a09db..953ac33b2f5f 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1822,9 +1822,11 @@ void vfio_pci_core_uninit_device(struct vfio_pci_core_device *vdev)
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_uninit_device);
>  
> -int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
> +int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev,
> +				  void *driver_data)
>  {
>  	struct pci_dev *pdev = vdev->pdev;
> +	struct device *dev = &pdev->dev;
>  	int ret;
>  
>  	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
> @@ -1843,6 +1845,17 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>  		return -EBUSY;
>  	}
>  
> +	/*
> +	 * The 'struct vfio_pci_core_device' should be the first member of the
> +	 * of the structure referenced by 'driver_data' so that it can be
> +	 * retrieved with dev_get_drvdata() inside vfio-pci core layer.
> +	 */
> +	if ((struct vfio_pci_core_device *)driver_data != vdev) {
> +		pci_warn(pdev, "Invalid driver data\n");
> +		return -EINVAL;
> +	}

It seems a bit odd to me to add a driver_data arg to the function,
which is actually required to point to the same thing as the existing
function arg.  Is this just to codify the requirement?  Maybe others
can suggest alternatives.

We also need to collaborate with Jason's patch:

https://lore.kernel.org/all/0-v2-0f36bcf6ec1e+64d-vfio_get_from_dev_jgg@nvidia.com/

(and maybe others)

If we implement a change like proposed here that vfio-pci-core sets
drvdata then we don't need for each variant driver to implement their
own wrapper around err_handler or err_detected as Jason proposes in the
linked patch.  Thanks,

Alex

> +	dev_set_drvdata(dev, driver_data);
> +
>  	if (pci_is_root_bus(pdev->bus)) {
>  		ret = vfio_assign_device_set(&vdev->vdev, vdev);
>  	} else if (!pci_probe_reset_slot(pdev->slot)) {
> @@ -1856,10 +1869,10 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>  	}
>  
>  	if (ret)
> -		return ret;
> +		goto out_drvdata;
>  	ret = vfio_pci_vf_init(vdev);
>  	if (ret)
> -		return ret;
> +		goto out_drvdata;
>  	ret = vfio_pci_vga_init(vdev);
>  	if (ret)
>  		goto out_vf;
> @@ -1890,6 +1903,8 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>  		vfio_pci_set_power_state(vdev, PCI_D0);
>  out_vf:
>  	vfio_pci_vf_uninit(vdev);
> +out_drvdata:
> +	dev_set_drvdata(dev, NULL);
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_register_device);
> @@ -1897,6 +1912,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_register_device);
>  void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
>  {
>  	struct pci_dev *pdev = vdev->pdev;
> +	struct device *dev = &pdev->dev;
>  
>  	vfio_pci_core_sriov_configure(pdev, 0);
>  
> @@ -1907,6 +1923,8 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
>  
>  	if (!disable_idle_d3)
>  		vfio_pci_set_power_state(vdev, PCI_D0);
> +
> +	dev_set_drvdata(dev, NULL);
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
>  
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 505b2a74a479..3c7d65e68340 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -225,7 +225,12 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev);
>  void vfio_pci_core_init_device(struct vfio_pci_core_device *vdev,
>  			       struct pci_dev *pdev,
>  			       const struct vfio_device_ops *vfio_pci_ops);
> -int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev);
> +/*
> + * The 'struct vfio_pci_core_device' should be the first member
> + * of the structure referenced by 'driver_data'.
> + */
> +int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev,
> +				  void *driver_data);
>  void vfio_pci_core_uninit_device(struct vfio_pci_core_device *vdev);
>  void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev);
>  int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn);


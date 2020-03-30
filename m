Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B030C1977E5
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 11:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgC3JbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 05:31:05 -0400
Received: from foss.arm.com ([217.140.110.172]:48362 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728385AbgC3JbF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 05:31:05 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 61F1231B;
        Mon, 30 Mar 2020 02:31:04 -0700 (PDT)
Received: from [192.168.3.111] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C5D83F52E;
        Mon, 30 Mar 2020 02:31:03 -0700 (PDT)
Subject: Re: [PATCH v3 kvmtool 14/32] virtio: Don't ignore initialization
 failures
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
 <20200326152438.6218-15-alexandru.elisei@arm.com>
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Autocrypt: addr=andre.przywara@arm.com; prefer-encrypt=mutual; keydata=
 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
 i4aIXCH3Wv6K
Organization: ARM Ltd.
Message-ID: <9cb9e14b-ab07-48ec-819f-11fe727c88b1@arm.com>
Date:   Mon, 30 Mar 2020 10:30:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200326152438.6218-15-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 26/03/2020 15:24, Alexandru Elisei wrote:
> Don't ignore an error in the bus specific initialization function in
> virtio_init; don't ignore the result of virtio_init; and don't return 0
> in virtio_blk__init and virtio_scsi__init when we encounter an error.
> Hopefully this will save some developer's time debugging faulty virtio
> devices in a guest.
> 
> To take advantage of the cleanup function virtio_blk__exit, we have
> moved appending the new device to the list before the call to
> virtio_init.
> 
> To safeguard against this in the future, virtio_init has been annoted
> with the compiler attribute warn_unused_result.

This is a good idea, but actually triggers an unrelated, long standing
bug in vesa.c (on x86):
hw/vesa.c: In function ‘vesa__init’:
hw/vesa.c:77:3: error: ignoring return value of ‘ERR_PTR’, declared with
attribute warn_unused_result [-Werror=unused-result]
   ERR_PTR(-errno);
   ^
cc1: all warnings being treated as errors

So could you add the missing "return" statement in that line, to fix
that bug?
I see that this gets rectified two patches later, but for the sake of
bisect-ability it would be good to keep this compilable all the way through.

> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  include/kvm/kvm.h        |  1 +
>  include/kvm/virtio.h     |  7 ++++---
>  include/linux/compiler.h |  2 +-
>  virtio/9p.c              |  9 ++++++---
>  virtio/balloon.c         | 10 +++++++---
>  virtio/blk.c             | 14 +++++++++-----
>  virtio/console.c         | 11 ++++++++---
>  virtio/core.c            |  9 +++++----
>  virtio/net.c             | 32 ++++++++++++++++++--------------
>  virtio/scsi.c            | 14 +++++++++-----
>  10 files changed, 68 insertions(+), 41 deletions(-)
> 
> diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> index 7a738183d67a..c6dc6ef72d11 100644
> --- a/include/kvm/kvm.h
> +++ b/include/kvm/kvm.h
> @@ -8,6 +8,7 @@
>  
>  #include <stdbool.h>
>  #include <linux/types.h>
> +#include <linux/compiler.h>
>  #include <time.h>
>  #include <signal.h>
>  #include <sys/prctl.h>
> diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
> index 19b913732cd5..3a311f54f2a5 100644
> --- a/include/kvm/virtio.h
> +++ b/include/kvm/virtio.h
> @@ -7,6 +7,7 @@
>  #include <linux/virtio_pci.h>
>  
>  #include <linux/types.h>
> +#include <linux/compiler.h>
>  #include <linux/virtio_config.h>
>  #include <sys/uio.h>
>  
> @@ -204,9 +205,9 @@ struct virtio_ops {
>  	int (*reset)(struct kvm *kvm, struct virtio_device *vdev);
>  };
>  
> -int virtio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
> -		struct virtio_ops *ops, enum virtio_trans trans,
> -		int device_id, int subsys_id, int class);
> +int __must_check virtio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
> +			     struct virtio_ops *ops, enum virtio_trans trans,
> +			     int device_id, int subsys_id, int class);
>  int virtio_compat_add_message(const char *device, const char *config);
>  const char* virtio_trans_name(enum virtio_trans trans);
>  
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index 898420b81aec..a662ba0a5c68 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -14,7 +14,7 @@
>  #define __packed	__attribute__((packed))
>  #define __iomem
>  #define __force
> -#define __must_check
> +#define __must_check	__attribute__((warn_unused_result))
>  #define unlikely
>  
>  #endif
> diff --git a/virtio/9p.c b/virtio/9p.c
> index ac70dbc31207..b78f2b3f0e09 100644
> --- a/virtio/9p.c
> +++ b/virtio/9p.c
> @@ -1551,11 +1551,14 @@ int virtio_9p_img_name_parser(const struct option *opt, const char *arg, int uns
>  int virtio_9p__init(struct kvm *kvm)
>  {
>  	struct p9_dev *p9dev;
> +	int r;
>  
>  	list_for_each_entry(p9dev, &devs, list) {
> -		virtio_init(kvm, p9dev, &p9dev->vdev, &p9_dev_virtio_ops,
> -			    VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_9P,
> -			    VIRTIO_ID_9P, PCI_CLASS_9P);
> +		r = virtio_init(kvm, p9dev, &p9dev->vdev, &p9_dev_virtio_ops,
> +				VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_9P,
> +				VIRTIO_ID_9P, PCI_CLASS_9P);
> +		if (r < 0)
> +			return r;
>  	}
>  
>  	return 0;
> diff --git a/virtio/balloon.c b/virtio/balloon.c
> index 0bd16703dfee..8e8803fed607 100644
> --- a/virtio/balloon.c
> +++ b/virtio/balloon.c
> @@ -264,6 +264,8 @@ struct virtio_ops bln_dev_virtio_ops = {
>  
>  int virtio_bln__init(struct kvm *kvm)
>  {
> +	int r;
> +
>  	if (!kvm->cfg.balloon)
>  		return 0;
>  
> @@ -273,9 +275,11 @@ int virtio_bln__init(struct kvm *kvm)
>  	bdev.stat_waitfd	= eventfd(0, 0);
>  	memset(&bdev.config, 0, sizeof(struct virtio_balloon_config));
>  
> -	virtio_init(kvm, &bdev, &bdev.vdev, &bln_dev_virtio_ops,
> -		    VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_BLN,
> -		    VIRTIO_ID_BALLOON, PCI_CLASS_BLN);
> +	r = virtio_init(kvm, &bdev, &bdev.vdev, &bln_dev_virtio_ops,
> +			VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_BLN,
> +			VIRTIO_ID_BALLOON, PCI_CLASS_BLN);
> +	if (r < 0)
> +		return r;
>  
>  	if (compat_id == -1)
>  		compat_id = virtio_compat_add_message("virtio-balloon", "CONFIG_VIRTIO_BALLOON");
> diff --git a/virtio/blk.c b/virtio/blk.c
> index f267be1563dc..4d02d101af81 100644
> --- a/virtio/blk.c
> +++ b/virtio/blk.c
> @@ -306,6 +306,7 @@ static struct virtio_ops blk_dev_virtio_ops = {
>  static int virtio_blk__init_one(struct kvm *kvm, struct disk_image *disk)
>  {
>  	struct blk_dev *bdev;
> +	int r;
>  
>  	if (!disk)
>  		return -EINVAL;
> @@ -323,12 +324,14 @@ static int virtio_blk__init_one(struct kvm *kvm, struct disk_image *disk)
>  		.kvm			= kvm,
>  	};
>  
> -	virtio_init(kvm, bdev, &bdev->vdev, &blk_dev_virtio_ops,
> -		    VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_BLK,
> -		    VIRTIO_ID_BLOCK, PCI_CLASS_BLK);
> -
>  	list_add_tail(&bdev->list, &bdevs);
>  
> +	r = virtio_init(kvm, bdev, &bdev->vdev, &blk_dev_virtio_ops,
> +			VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_BLK,
> +			VIRTIO_ID_BLOCK, PCI_CLASS_BLK);
> +	if (r < 0)
> +		return r;
> +
>  	disk_image__set_callback(bdev->disk, virtio_blk_complete);
>  
>  	if (compat_id == -1)
> @@ -359,7 +362,8 @@ int virtio_blk__init(struct kvm *kvm)
>  
>  	return 0;
>  cleanup:
> -	return virtio_blk__exit(kvm);
> +	virtio_blk__exit(kvm);
> +	return r;
>  }
>  virtio_dev_init(virtio_blk__init);
>  
> diff --git a/virtio/console.c b/virtio/console.c
> index f1be02549222..e0b98df37965 100644
> --- a/virtio/console.c
> +++ b/virtio/console.c
> @@ -230,12 +230,17 @@ static struct virtio_ops con_dev_virtio_ops = {
>  
>  int virtio_console__init(struct kvm *kvm)
>  {
> +	int r;
> +
>  	if (kvm->cfg.active_console != CONSOLE_VIRTIO)
>  		return 0;
>  
> -	virtio_init(kvm, &cdev, &cdev.vdev, &con_dev_virtio_ops,
> -		    VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_CONSOLE,
> -		    VIRTIO_ID_CONSOLE, PCI_CLASS_CONSOLE);
> +	r = virtio_init(kvm, &cdev, &cdev.vdev, &con_dev_virtio_ops,
> +			VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_CONSOLE,
> +			VIRTIO_ID_CONSOLE, PCI_CLASS_CONSOLE);
> +	if (r < 0)
> +		return r;
> +
>  	if (compat_id == -1)
>  		compat_id = virtio_compat_add_message("virtio-console", "CONFIG_VIRTIO_CONSOLE");
>  
> diff --git a/virtio/core.c b/virtio/core.c
> index e10ec362e1ea..f5b3c07fc100 100644
> --- a/virtio/core.c
> +++ b/virtio/core.c
> @@ -259,6 +259,7 @@ int virtio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>  		int device_id, int subsys_id, int class)
>  {
>  	void *virtio;
> +	int r;
>  
>  	switch (trans) {
>  	case VIRTIO_PCI:
> @@ -272,7 +273,7 @@ int virtio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>  		vdev->ops->init			= virtio_pci__init;
>  		vdev->ops->exit			= virtio_pci__exit;
>  		vdev->ops->reset		= virtio_pci__reset;
> -		vdev->ops->init(kvm, dev, vdev, device_id, subsys_id, class);
> +		r = vdev->ops->init(kvm, dev, vdev, device_id, subsys_id, class);
>  		break;
>  	case VIRTIO_MMIO:
>  		virtio = calloc(sizeof(struct virtio_mmio), 1);
> @@ -285,13 +286,13 @@ int virtio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>  		vdev->ops->init			= virtio_mmio_init;
>  		vdev->ops->exit			= virtio_mmio_exit;
>  		vdev->ops->reset		= virtio_mmio_reset;
> -		vdev->ops->init(kvm, dev, vdev, device_id, subsys_id, class);
> +		r = vdev->ops->init(kvm, dev, vdev, device_id, subsys_id, class);
>  		break;
>  	default:
> -		return -1;
> +		r = -1;
>  	};
>  
> -	return 0;
> +	return r;
>  }
>  
>  int virtio_compat_add_message(const char *device, const char *config)
> diff --git a/virtio/net.c b/virtio/net.c
> index 091406912a24..425c13ba1136 100644
> --- a/virtio/net.c
> +++ b/virtio/net.c
> @@ -910,7 +910,7 @@ done:
>  
>  static int virtio_net__init_one(struct virtio_net_params *params)
>  {
> -	int i, err;
> +	int i, r;
>  	struct net_dev *ndev;
>  	struct virtio_ops *ops;
>  	enum virtio_trans trans = VIRTIO_DEFAULT_TRANS(params->kvm);
> @@ -920,10 +920,8 @@ static int virtio_net__init_one(struct virtio_net_params *params)
>  		return -ENOMEM;
>  
>  	ops = malloc(sizeof(*ops));
> -	if (ops == NULL) {
> -		err = -ENOMEM;
> -		goto err_free_ndev;
> -	}
> +	if (ops == NULL)
> +		return -ENOMEM;
>  
>  	list_add_tail(&ndev->list, &ndevs);

As mentioned in the reply to the v2 version, I think this is still
leaking memory here.

The rest looks fine.

Cheers,
Andre

>  
> @@ -969,8 +967,10 @@ static int virtio_net__init_one(struct virtio_net_params *params)
>  				   virtio_trans_name(trans));
>  	}
>  
> -	virtio_init(params->kvm, ndev, &ndev->vdev, ops, trans,
> -		    PCI_DEVICE_ID_VIRTIO_NET, VIRTIO_ID_NET, PCI_CLASS_NET);
> +	r = virtio_init(params->kvm, ndev, &ndev->vdev, ops, trans,
> +			PCI_DEVICE_ID_VIRTIO_NET, VIRTIO_ID_NET, PCI_CLASS_NET);
> +	if (r < 0)
> +		return r;
>  
>  	if (params->vhost)
>  		virtio_net__vhost_init(params->kvm, ndev);
> @@ -979,19 +979,17 @@ static int virtio_net__init_one(struct virtio_net_params *params)
>  		compat_id = virtio_compat_add_message("virtio-net", "CONFIG_VIRTIO_NET");
>  
>  	return 0;
> -
> -err_free_ndev:
> -	free(ndev);
> -	return err;
>  }
>  
>  int virtio_net__init(struct kvm *kvm)
>  {
> -	int i;
> +	int i, r;
>  
>  	for (i = 0; i < kvm->cfg.num_net_devices; i++) {
>  		kvm->cfg.net_params[i].kvm = kvm;
> -		virtio_net__init_one(&kvm->cfg.net_params[i]);
> +		r = virtio_net__init_one(&kvm->cfg.net_params[i]);
> +		if (r < 0)
> +			goto cleanup;
>  	}
>  
>  	if (kvm->cfg.num_net_devices == 0 && kvm->cfg.no_net == 0) {
> @@ -1007,10 +1005,16 @@ int virtio_net__init(struct kvm *kvm)
>  		str_to_mac(kvm->cfg.guest_mac, net_params.guest_mac);
>  		str_to_mac(kvm->cfg.host_mac, net_params.host_mac);
>  
> -		virtio_net__init_one(&net_params);
> +		r = virtio_net__init_one(&net_params);
> +		if (r < 0)
> +			goto cleanup;
>  	}
>  
>  	return 0;
> +
> +cleanup:
> +	virtio_net__exit(kvm);
> +	return r;
>  }
>  virtio_dev_init(virtio_net__init);
>  
> diff --git a/virtio/scsi.c b/virtio/scsi.c
> index 1ec78fe0945a..16a86cb7e0e6 100644
> --- a/virtio/scsi.c
> +++ b/virtio/scsi.c
> @@ -234,6 +234,7 @@ static void virtio_scsi_vhost_init(struct kvm *kvm, struct scsi_dev *sdev)
>  static int virtio_scsi_init_one(struct kvm *kvm, struct disk_image *disk)
>  {
>  	struct scsi_dev *sdev;
> +	int r;
>  
>  	if (!disk)
>  		return -EINVAL;
> @@ -260,12 +261,14 @@ static int virtio_scsi_init_one(struct kvm *kvm, struct disk_image *disk)
>  	strlcpy((char *)&sdev->target.vhost_wwpn, disk->wwpn, sizeof(sdev->target.vhost_wwpn));
>  	sdev->target.vhost_tpgt = strtol(disk->tpgt, NULL, 0);
>  
> -	virtio_init(kvm, sdev, &sdev->vdev, &scsi_dev_virtio_ops,
> -		    VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_SCSI,
> -		    VIRTIO_ID_SCSI, PCI_CLASS_BLK);
> -
>  	list_add_tail(&sdev->list, &sdevs);
>  
> +	r = virtio_init(kvm, sdev, &sdev->vdev, &scsi_dev_virtio_ops,
> +			VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_SCSI,
> +			VIRTIO_ID_SCSI, PCI_CLASS_BLK);
> +	if (r < 0)
> +		return r;
> +
>  	virtio_scsi_vhost_init(kvm, sdev);
>  
>  	if (compat_id == -1)
> @@ -302,7 +305,8 @@ int virtio_scsi_init(struct kvm *kvm)
>  
>  	return 0;
>  cleanup:
> -	return virtio_scsi_exit(kvm);
> +	virtio_scsi_exit(kvm);
> +	return r;
>  }
>  virtio_dev_init(virtio_scsi_init);
>  
> 


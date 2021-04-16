Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C22361C18
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 11:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240873AbhDPIrl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 04:47:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22412 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240844AbhDPIrj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 16 Apr 2021 04:47:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618562834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wRo3dX7HZBf9pYjFq5ETZzrsfm6Cv5K3vSoaAXFlhHU=;
        b=RGFBwfBXHKejp9MKQemsIL/7+/3duF8+rG3tczerdGGiMiE/P8HHaVtiQAOPAAUKTi+/Hd
        RH8odz+40r9XDG2aic9o/VY3oZIcymGdD4dzBb39sGShNFJeXgiqU8ClxYGutxXCbMze1V
        36IP0unVy4eA2k0gNHm/ObfJx72SwNw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-BVsuNyr6NkaaoHijXwWqSg-1; Fri, 16 Apr 2021 04:47:11 -0400
X-MC-Unique: BVsuNyr6NkaaoHijXwWqSg-1
Received: by mail-ed1-f72.google.com with SMTP id i25-20020a50fc190000b0290384fe0dab00so1063615edr.6
        for <kvm@vger.kernel.org>; Fri, 16 Apr 2021 01:47:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wRo3dX7HZBf9pYjFq5ETZzrsfm6Cv5K3vSoaAXFlhHU=;
        b=YJXR2lHDgBIX0aa2u68Hb3afxIEpT/TR78eJaELmyShFHENCHU6+5yASpnwOjGsieI
         rUre+CzjbhIghDaezg7HfLbVBv3aGmXu/Ebrju+/VgPE726aIB0AIw3fp44t/sTOfflG
         ZHtL7z4E0ehGvrzkZJmk4cQ8WpaInl9150eua1te2Ze4pxRlJQAKjnSizwFb8/YeGgQo
         7bmQmqKtm4Jhd/4Dbo9VKGv6ty1ABpgABR9jmq5s75YDwA2Ca9GJ4f+XnarZ/5+/UCZc
         xGYwOSZNRsfGXnAlVoevjF4Z2U3AOHOJh6HabAsiGd7d6ugPFZH0Z8y4FAZo1gHFBJxO
         3a2w==
X-Gm-Message-State: AOAM531qMU/zyl/4FfYcv/NjCoSA1qJUuA1qf2Zqdj9tHlixZAjb+xt+
        SubrKZimLClZdcWW/sAimG28VOKTCRgceggNPiNU0fjbJNK+rM5mvZCsN0a4xupsCGCvO0gzP1r
        7ZFd9dccCEFdY
X-Received: by 2002:a50:8fe6:: with SMTP id y93mr8637328edy.224.1618562830125;
        Fri, 16 Apr 2021 01:47:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwh1Zl2ub3jfnrnRMGdIeGAkIGOzcVmqwkMtbMOyGQ3+DRwPr4tDakxV4LySH2DCPUs/c6RYw==
X-Received: by 2002:a50:8fe6:: with SMTP id y93mr8637313edy.224.1618562829919;
        Fri, 16 Apr 2021 01:47:09 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id k9sm3617309eje.102.2021.04.16.01.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 01:47:09 -0700 (PDT)
Date:   Fri, 16 Apr 2021 10:47:07 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 2/3] vDPA/ifcvf: enable Intel C5000X-PL virtio-block
 for vDPA
Message-ID: <20210416084707.ruqzvg4airzkkc2t@steredhat>
References: <20210416071628.4984-1-lingshan.zhu@intel.com>
 <20210416071628.4984-3-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210416071628.4984-3-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 16, 2021 at 03:16:27PM +0800, Zhu Lingshan wrote:
>This commit enabled Intel FPGA SmartNIC C5000X-PL virtio-block
>for vDPA.
>
>Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>---
> drivers/vdpa/ifcvf/ifcvf_base.h |  8 +++++++-
> drivers/vdpa/ifcvf/ifcvf_main.c | 19 ++++++++++++++++++-
> 2 files changed, 25 insertions(+), 2 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
>index 1c04cd256fa7..0111bfdeb342 100644
>--- a/drivers/vdpa/ifcvf/ifcvf_base.h
>+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>@@ -15,6 +15,7 @@
> #include <linux/pci_regs.h>
> #include <linux/vdpa.h>
> #include <uapi/linux/virtio_net.h>
>+#include <uapi/linux/virtio_blk.h>
> #include <uapi/linux/virtio_config.h>
> #include <uapi/linux/virtio_pci.h>
>
>@@ -28,7 +29,12 @@
> #define C5000X_PL_SUBSYS_VENDOR_ID	0x8086
> #define C5000X_PL_SUBSYS_DEVICE_ID	0x0001
>
>-#define IFCVF_SUPPORTED_FEATURES \
>+#define C5000X_PL_BLK_VENDOR_ID		0x1AF4
>+#define C5000X_PL_BLK_DEVICE_ID		0x1001
>+#define C5000X_PL_BLK_SUBSYS_VENDOR_ID	0x8086
>+#define C5000X_PL_BLK_SUBSYS_DEVICE_ID	0x0002
>+
>+#define IFCVF_NET_SUPPORTED_FEATURES \
> 		((1ULL << VIRTIO_NET_F_MAC)			| \
> 		 (1ULL << VIRTIO_F_ANY_LAYOUT)			| \
> 		 (1ULL << VIRTIO_F_VERSION_1)			| \
>diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
>index 469a9b5737b7..376b2014916a 100644
>--- a/drivers/vdpa/ifcvf/ifcvf_main.c
>+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>@@ -168,10 +168,23 @@ static struct ifcvf_hw *vdpa_to_vf(struct vdpa_device *vdpa_dev)
>
> static u64 ifcvf_vdpa_get_features(struct vdpa_device *vdpa_dev)
> {
>+	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
> 	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>+	struct pci_dev *pdev = adapter->pdev;
>+
> 	u64 features;
>
>-	features = ifcvf_get_features(vf) & IFCVF_SUPPORTED_FEATURES;
>+	switch (vf->dev_type) {
>+	case VIRTIO_ID_NET:
>+		features = ifcvf_get_features(vf) & IFCVF_NET_SUPPORTED_FEATURES;
>+		break;
>+	case VIRTIO_ID_BLOCK:
>+		features = ifcvf_get_features(vf);
>+		break;
>+	default:
>+		features = 0;
>+		IFCVF_ERR(pdev, "VIRTIO ID %u not supported\n", vf->dev_type);
>+	}
>
> 	return features;
> }
>@@ -517,6 +530,10 @@ static struct pci_device_id ifcvf_pci_ids[] = {
> 			 C5000X_PL_DEVICE_ID,
> 			 C5000X_PL_SUBSYS_VENDOR_ID,
> 			 C5000X_PL_SUBSYS_DEVICE_ID) },
>+	{ PCI_DEVICE_SUB(C5000X_PL_BLK_VENDOR_ID,
>+			 C5000X_PL_BLK_DEVICE_ID,
>+			 C5000X_PL_BLK_SUBSYS_VENDOR_ID,
>+			 C5000X_PL_BLK_SUBSYS_DEVICE_ID) },
>
> 	{ 0 },
> };
>-- 
>2.27.0
>


Return-Path: <kvm+bounces-30-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDA857DAE2B
	for <lists+kvm@lfdr.de>; Sun, 29 Oct 2023 21:17:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13D812814EC
	for <lists+kvm@lfdr.de>; Sun, 29 Oct 2023 20:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC74F111A9;
	Sun, 29 Oct 2023 20:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XmDrj7NX"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C1328F9
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 20:17:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20D3AC
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 13:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698610652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q6nQ/uPmqXrILOSIy8EDaFkLr4tKSdMkC7He2nMFTXw=;
	b=XmDrj7NXTcKoopPkfyEDuivCO73Z1pl43nCpYgr9acxBA67uCIEwUwfS11kkT//iR4kFBQ
	XjSLNPFqNhNtEGk54ylLN1mMwLyjhJ2mHoKPG6Unya7bQI6d2eK3ZwM9owTmnQNR+/xicW
	JnNxxNb45EU/cdr2ZM5nppFgFzunG60=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-Ft9dsR0WMGqCadM4gTwZHg-1; Sun, 29 Oct 2023 16:17:28 -0400
X-MC-Unique: Ft9dsR0WMGqCadM4gTwZHg-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9ae0bf9c0a9so255797766b.3
        for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 13:17:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698610647; x=1699215447;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q6nQ/uPmqXrILOSIy8EDaFkLr4tKSdMkC7He2nMFTXw=;
        b=MGviX8gRhScTK7QonLwk8N26c+wHG4UK2aGvAjt8wU/zIqW1OvZ/d/1eMldq1H0yGH
         ujqke/6zBMsJ4yfSJt7SNjgkCtN8J9eNPf1CBS2AJGDCph3x9FLYCBwolNn79Dtmq3Ee
         K9vXIxAaVcIQLY7tbwoiDZANJ0u6C5kOvh/PvqAhxDslSNdxPVwNi4ZehiG03XYB4Nue
         CqcAEX8x4dYsyhDwlVAUUTzM18W3LReYK8Brt/1quQjePwe6fnPYAF9ADB1g10tmVKmp
         WYApjfZxIhYS7BRjIiMcCsRgoAUwGyxGpczAFCrjrirtvkw69q6a5nc6QqyKXnnl2KY4
         tqmg==
X-Gm-Message-State: AOJu0YzVFBFH3IOjQv6So4bY71NK6zQMwpZblu4nFYqnRQamTk/ayhJc
	z1ByDjUunvsLw7VDZJi2MvgJUPGJ6GBwlu/fXUebVWtoccnXAyyqgaAhjJzPcOAORiLmW3w8SZ4
	1yV/MWXIZP9nX
X-Received: by 2002:a17:907:31c8:b0:9a1:891b:6eed with SMTP id xf8-20020a17090731c800b009a1891b6eedmr6713922ejb.76.1698610647708;
        Sun, 29 Oct 2023 13:17:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8IKgGkLVvf6ym0XSYuQ6eR4W1aZCo630KEUhtmQx5tH0RQPV6TJseigiQ9aspXaXugV45GA==
X-Received: by 2002:a17:907:31c8:b0:9a1:891b:6eed with SMTP id xf8-20020a17090731c800b009a1891b6eedmr6713903ejb.76.1698610647356;
        Sun, 29 Oct 2023 13:17:27 -0700 (PDT)
Received: from redhat.com ([2a02:14f:16f:5c91:cfe8:a545:4338:bf76])
        by smtp.gmail.com with ESMTPSA id y25-20020a170906471900b0099bcd1fa5b0sm4864404ejq.192.2023.10.29.13.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Oct 2023 13:17:26 -0700 (PDT)
Date: Sun, 29 Oct 2023 16:17:20 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: alex.williamson@redhat.com, jasowang@redhat.com, jgg@nvidia.com,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
	kevin.tian@intel.com, joao.m.martins@oracle.com,
	si-wei.liu@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V2 vfio 5/9] virtio-pci: Initialize the supported admin
 commands
Message-ID: <20231029160750-mutt-send-email-mst@kernel.org>
References: <20231029155952.67686-1-yishaih@nvidia.com>
 <20231029155952.67686-6-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231029155952.67686-6-yishaih@nvidia.com>

On Sun, Oct 29, 2023 at 05:59:48PM +0200, Yishai Hadas wrote:
> Initialize the supported admin commands upon activating the admin queue.
> 
> The supported commands are saved as part of the admin queue context, it
> will be used by the next patches from this series.
> 
> Note:
> As we don't want to let upper layers to execute admin commands before
> that this initialization step was completed, we set ref count to 1 only
> post of that flow and use a non ref counted version command for this
> internal flow.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/virtio/virtio_pci_common.h |  1 +
>  drivers/virtio/virtio_pci_modern.c | 77 +++++++++++++++++++++++++++++-
>  2 files changed, 77 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
> index a21b9ba01a60..9e07e556a51a 100644
> --- a/drivers/virtio/virtio_pci_common.h
> +++ b/drivers/virtio/virtio_pci_common.h
> @@ -46,6 +46,7 @@ struct virtio_pci_admin_vq {
>  	struct virtio_pci_vq_info info;
>  	struct completion flush_done;
>  	refcount_t refcount;
> +	u64 supported_cmds;
>  	/* Name of the admin queue: avq.$index. */
>  	char name[10];
>  	u16 vq_index;
> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
> index ccd7a4d9f57f..25e27aa79cab 100644
> --- a/drivers/virtio/virtio_pci_modern.c
> +++ b/drivers/virtio/virtio_pci_modern.c
> @@ -19,6 +19,9 @@
>  #define VIRTIO_RING_NO_LEGACY
>  #include "virtio_pci_common.h"
>  
> +static int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
> +				    struct virtio_admin_cmd *cmd);
> +

I don't much like forward declarations. Just order functions sensibly
and they will not be needed.

>  static u64 vp_get_features(struct virtio_device *vdev)
>  {
>  	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
> @@ -59,6 +62,42 @@ vp_modern_avq_set_abort(struct virtio_pci_admin_vq *admin_vq, bool abort)
>  	WRITE_ONCE(admin_vq->abort, abort);
>  }
>  
> +static void virtio_pci_admin_init_cmd_list(struct virtio_device *virtio_dev)
> +{
> +	struct virtio_pci_device *vp_dev = to_vp_device(virtio_dev);
> +	struct virtio_admin_cmd cmd = {};
> +	struct scatterlist result_sg;
> +	struct scatterlist data_sg;
> +	__le64 *data;
> +	int ret;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return;
> +
> +	sg_init_one(&result_sg, data, sizeof(*data));
> +	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_QUERY);
> +	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
> +	cmd.result_sg = &result_sg;
> +
> +	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
> +	if (ret)
> +		goto end;
> +
> +	sg_init_one(&data_sg, data, sizeof(*data));
> +	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_USE);
> +	cmd.data_sg = &data_sg;
> +	cmd.result_sg = NULL;
> +
> +	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
> +	if (ret)
> +		goto end;
> +
> +	vp_dev->admin_vq.supported_cmds = le64_to_cpu(*data);
> +end:
> +	kfree(data);
> +}
> +
>  static void vp_modern_avq_activate(struct virtio_device *vdev)
>  {
>  	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
> @@ -67,6 +106,7 @@ static void vp_modern_avq_activate(struct virtio_device *vdev)
>  	if (!virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ))
>  		return;
>  
> +	virtio_pci_admin_init_cmd_list(vdev);
>  	init_completion(&admin_vq->flush_done);
>  	refcount_set(&admin_vq->refcount, 1);
>  	vp_modern_avq_set_abort(admin_vq, false);
> @@ -562,6 +602,35 @@ static bool vp_get_shm_region(struct virtio_device *vdev,
>  	return true;
>  }
>  
> +static int __virtqueue_exec_admin_cmd(struct virtio_pci_admin_vq *admin_vq,
> +				    struct scatterlist **sgs,
> +				    unsigned int out_num,
> +				    unsigned int in_num,
> +				    void *data,
> +				    gfp_t gfp)
> +{
> +	struct virtqueue *vq;
> +	int ret, len;
> +
> +	vq = admin_vq->info.vq;
> +
> +	ret = virtqueue_add_sgs(vq, sgs, out_num, in_num, data, gfp);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (unlikely(!virtqueue_kick(vq)))
> +		return -EIO;
> +
> +	while (!virtqueue_get_buf(vq, &len) &&
> +	       !virtqueue_is_broken(vq))
> +		cpu_relax();
> +
> +	if (virtqueue_is_broken(vq))
> +		return -EIO;
> +
> +	return 0;
> +}
> +


This is tolerable I guess but it might pin the CPU for a long time.
The difficulty is handling suprize removal well which we currently
don't do with interrupts. I would say it's ok as is but add
a TODO comments along the lines of /* TODO: use interrupts once these virtqueue_is_broken */

>  static int virtqueue_exec_admin_cmd(struct virtio_pci_admin_vq *admin_vq,
>  				    struct scatterlist **sgs,
>  				    unsigned int out_num,
> @@ -653,7 +722,13 @@ static int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
>  		in_num++;
>  	}
>  
> -	ret = virtqueue_exec_admin_cmd(&vp_dev->admin_vq, sgs,
> +	if (cmd->opcode == VIRTIO_ADMIN_CMD_LIST_QUERY ||
> +	    cmd->opcode == VIRTIO_ADMIN_CMD_LIST_USE)
> +		ret = __virtqueue_exec_admin_cmd(&vp_dev->admin_vq, sgs,
> +				       out_num, in_num,
> +				       sgs, GFP_KERNEL);
> +	else
> +		ret = virtqueue_exec_admin_cmd(&vp_dev->admin_vq, sgs,
>  				       out_num, in_num,
>  				       sgs, GFP_KERNEL);
>  	if (ret) {
> -- 
> 2.27.0



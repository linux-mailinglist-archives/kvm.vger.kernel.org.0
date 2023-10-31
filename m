Return-Path: <kvm+bounces-157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15EC07DC7E4
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 09:09:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFE1C28172F
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 08:09:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1627D11195;
	Tue, 31 Oct 2023 08:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="STtG9uty"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D2110A38
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 08:09:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EB0A6
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 01:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698739762;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jy3I56vt9/uDV72QxxQPe8LI+zhUzBIbi4Hc8Vv7wTE=;
	b=STtG9utyhwZHWYZgRiNxALH8XrJbiypAWz6QvtEkce6x3FmE8yDESO3kOPanUsRzuKWGqN
	VubRM2yiVSCAlKQfcqbje1vpVZJ5F+2JAwV1IGbVDJFdr08L9UXyzoZaCumO7EtPqf3wrZ
	NFZjSeOdg/jsOId7xGiMBZ+ZtVDpRaI=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-493-YNmdX4khO2-GTHVVC1Fzhg-1; Tue, 31 Oct 2023 04:09:21 -0400
X-MC-Unique: YNmdX4khO2-GTHVVC1Fzhg-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2c50ef18b04so53399001fa.1
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 01:09:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698739760; x=1699344560;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jy3I56vt9/uDV72QxxQPe8LI+zhUzBIbi4Hc8Vv7wTE=;
        b=xLSt7+WD+T490Qs+7elVqxhuvOAU3y4mgjuKrHQyJDWqs1qkyq3pfc0Qz/srFkr7lL
         ebe+9zrFBGZlAKdhVpttDt/WxRq6nG+moNIFjsLSfPBl96qYwofaBS53JbTUOhLddQtr
         wXV2FfQeE4MZYL3I97WFBxLNnzNIuFXiNq+azk2dRP2f2SRvosC9Va3GvIomPRPcgKQD
         dm/2v1+yh2AqHAEybMFxIMN+ztL6vq3+YN4uHI4ZbUDou8LAvgb7ElJDtupk04Oy8gKZ
         oxcbDlfJ8Vf9yU5eK0nKplka6lEkhOlGZ2PW/neMhmtpfGwWCu/dPgOzgcJTAwd9+ZkO
         NVeQ==
X-Gm-Message-State: AOJu0YxOT/2dia7p48k5UUKCHUwCkdmoiXOkwrx+4s7UYDaMpUTwQunB
	Y6/b5vn5tgpPdS73kX7QER9EuuYso3aUTrL9CXbb1xOmzbBv5M2xm3Py50UY6jrM5pWuoN8w2Vk
	Jjg6vIxOxBtsP
X-Received: by 2002:a2e:3a07:0:b0:2c5:1623:66b8 with SMTP id h7-20020a2e3a07000000b002c5162366b8mr9030610lja.12.1698739759759;
        Tue, 31 Oct 2023 01:09:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGKSJXM9VJBXAsv6oq0Y/bSSa58zgIBpMoVuWC2INoZcw9Lr4oDvPtP13yAwI7ScSSrljneNg==
X-Received: by 2002:a2e:3a07:0:b0:2c5:1623:66b8 with SMTP id h7-20020a2e3a07000000b002c5162366b8mr9030595lja.12.1698739759360;
        Tue, 31 Oct 2023 01:09:19 -0700 (PDT)
Received: from redhat.com ([2.52.26.150])
        by smtp.gmail.com with ESMTPSA id bx31-20020a05651c199f00b002c0d9d83f71sm116228ljb.62.2023.10.31.01.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 01:09:18 -0700 (PDT)
Date: Tue, 31 Oct 2023 04:09:13 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: alex.williamson@redhat.com, jasowang@redhat.com, jgg@nvidia.com,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
	kevin.tian@intel.com, joao.m.martins@oracle.com,
	si-wei.liu@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V2 vfio 6/9] virtio-pci: Introduce APIs to execute legacy
 IO admin commands
Message-ID: <20231031040403-mutt-send-email-mst@kernel.org>
References: <20231029155952.67686-1-yishaih@nvidia.com>
 <20231029155952.67686-7-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231029155952.67686-7-yishaih@nvidia.com>

On Sun, Oct 29, 2023 at 05:59:49PM +0200, Yishai Hadas wrote:
> Introduce APIs to execute legacy IO admin commands.
> 
> It includes: io_legacy_read/write for both common and the device
> registers, io_legacy_notify_info.
> 
> In addition, exposing an API to check whether the legacy IO commands are
> supported. (i.e. virtio_pci_admin_has_legacy_io()).
> 
> Those APIs will be used by the next patches from this series.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/virtio/virtio_pci_common.c |  11 ++
>  drivers/virtio/virtio_pci_common.h |   2 +
>  drivers/virtio/virtio_pci_modern.c | 241 +++++++++++++++++++++++++++++
>  include/linux/virtio_pci_admin.h   |  21 +++
>  4 files changed, 275 insertions(+)
>  create mode 100644 include/linux/virtio_pci_admin.h
> 
> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
> index 6b4766d5abe6..212d68401d2c 100644
> --- a/drivers/virtio/virtio_pci_common.c
> +++ b/drivers/virtio/virtio_pci_common.c
> @@ -645,6 +645,17 @@ static struct pci_driver virtio_pci_driver = {
>  	.sriov_configure = virtio_pci_sriov_configure,
>  };
>  
> +struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev)
> +{
> +	struct virtio_pci_device *pf_vp_dev;
> +
> +	pf_vp_dev = pci_iov_get_pf_drvdata(pdev, &virtio_pci_driver);
> +	if (IS_ERR(pf_vp_dev))
> +		return NULL;
> +
> +	return &pf_vp_dev->vdev;
> +}
> +
>  module_pci_driver(virtio_pci_driver);
>  
>  MODULE_AUTHOR("Anthony Liguori <aliguori@us.ibm.com>");
> diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
> index 9e07e556a51a..07d4f863ac44 100644
> --- a/drivers/virtio/virtio_pci_common.h
> +++ b/drivers/virtio/virtio_pci_common.h
> @@ -156,4 +156,6 @@ static inline void virtio_pci_legacy_remove(struct virtio_pci_device *vp_dev)
>  int virtio_pci_modern_probe(struct virtio_pci_device *);
>  void virtio_pci_modern_remove(struct virtio_pci_device *);
>  
> +struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev);
> +
>  #endif
> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
> index 25e27aa79cab..def0f2de6091 100644
> --- a/drivers/virtio/virtio_pci_modern.c
> +++ b/drivers/virtio/virtio_pci_modern.c
> @@ -15,6 +15,7 @@
>   */
>  
>  #include <linux/delay.h>
> +#include <linux/virtio_pci_admin.h>
>  #define VIRTIO_PCI_NO_LEGACY
>  #define VIRTIO_RING_NO_LEGACY
>  #include "virtio_pci_common.h"
> @@ -794,6 +795,246 @@ static void vp_modern_destroy_avq(struct virtio_device *vdev)
>  	vp_dev->del_vq(&vp_dev->admin_vq.info);
>  }
>  
> +#define VIRTIO_LEGACY_ADMIN_CMD_BITMAP \
> +	(BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE) | \
> +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ) | \
> +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE) | \
> +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ) | \
> +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO))
> +
> +/*
> + * virtio_pci_admin_has_legacy_io - Checks whether the legacy IO
> + * commands are supported
> + * @dev: VF pci_dev
> + *
> + * Returns true on success.
> + */
> +bool virtio_pci_admin_has_legacy_io(struct pci_dev *pdev)
> +{
> +	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
> +	struct virtio_pci_device *vp_dev;
> +
> +	if (!virtio_dev)
> +		return false;
> +
> +	if (!virtio_has_feature(virtio_dev, VIRTIO_F_ADMIN_VQ))
> +		return false;
> +
> +	vp_dev = to_vp_device(virtio_dev);
> +
> +	if ((vp_dev->admin_vq.supported_cmds & VIRTIO_LEGACY_ADMIN_CMD_BITMAP) ==
> +		VIRTIO_LEGACY_ADMIN_CMD_BITMAP)
> +		return true;
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(virtio_pci_admin_has_legacy_io);
> +
> +static int virtio_pci_admin_legacy_io_write(struct pci_dev *pdev, u16 opcode,
> +					    u8 offset, u8 size, u8 *buf)
> +{
> +	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
> +	struct virtio_admin_cmd_legacy_wr_data *data;
> +	struct virtio_admin_cmd cmd = {};
> +	struct scatterlist data_sg;
> +	int vf_id;
> +	int ret;
> +
> +	if (!virtio_dev)
> +		return -ENODEV;
> +
> +	vf_id = pci_iov_vf_id(pdev);
> +	if (vf_id < 0)
> +		return vf_id;
> +
> +	data = kzalloc(sizeof(*data) + size, GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	data->offset = offset;
> +	memcpy(data->registers, buf, size);
> +	sg_init_one(&data_sg, data, sizeof(*data) + size);
> +	cmd.opcode = cpu_to_le16(opcode);
> +	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
> +	cmd.group_member_id = cpu_to_le64(vf_id + 1);
> +	cmd.data_sg = &data_sg;
> +	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
> +
> +	kfree(data);
> +	return ret;
> +}


> +
> +/*
> + * virtio_pci_admin_legacy_io_write_common - Write common legacy registers
> + * of a member device
> + * @dev: VF pci_dev
> + * @offset: starting byte offset within the registers to write to
> + * @size: size of the data to write
> + * @buf: buffer which holds the data
> + *
> + * Returns 0 on success, or negative on failure.
> + */
> +int virtio_pci_admin_legacy_common_io_write(struct pci_dev *pdev, u8 offset,
> +					    u8 size, u8 *buf)
> +{
> +	return virtio_pci_admin_legacy_io_write(pdev,
> +					VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE,
> +					offset, size, buf);
> +}
> +EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_common_io_write);

So consider this for example. You start with a PCI device of a VF.
Any number of these will access a PF in parallel. No locking
is taking place so admin vq can get corrupted.
And further, is caller expected not to invoke several of these
in parallel on the same device? If yes this needs to be
documented. I don't see where does vfio enforce this if yes.

 
> +
> +/*
> + * virtio_pci_admin_legacy_io_write_device - Write device legacy registers
> + * of a member device
> + * @dev: VF pci_dev
> + * @offset: starting byte offset within the registers to write to
> + * @size: size of the data to write
> + * @buf: buffer which holds the data
> + *
> + * Returns 0 on success, or negative on failure.
> + */
> +int virtio_pci_admin_legacy_device_io_write(struct pci_dev *pdev, u8 offset,
> +					    u8 size, u8 *buf)
> +{
> +	return virtio_pci_admin_legacy_io_write(pdev,
> +					VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE,
> +					offset, size, buf);
> +}
> +EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_device_io_write);
> +
> +static int virtio_pci_admin_legacy_io_read(struct pci_dev *pdev, u16 opcode,
> +					   u8 offset, u8 size, u8 *buf)
> +{
> +	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
> +	struct virtio_admin_cmd_legacy_rd_data *data;
> +	struct scatterlist data_sg, result_sg;
> +	struct virtio_admin_cmd cmd = {};
> +	int vf_id;
> +	int ret;
> +
> +	if (!virtio_dev)
> +		return -ENODEV;
> +
> +	vf_id = pci_iov_vf_id(pdev);
> +	if (vf_id < 0)
> +		return vf_id;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	data->offset = offset;
> +	sg_init_one(&data_sg, data, sizeof(*data));
> +	sg_init_one(&result_sg, buf, size);
> +	cmd.opcode = cpu_to_le16(opcode);
> +	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
> +	cmd.group_member_id = cpu_to_le64(vf_id + 1);
> +	cmd.data_sg = &data_sg;
> +	cmd.result_sg = &result_sg;
> +	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
> +
> +	kfree(data);
> +	return ret;
> +}
> +
> +/*
> + * virtio_pci_admin_legacy_device_io_read - Read legacy device registers of
> + * a member device
> + * @dev: VF pci_dev
> + * @offset: starting byte offset within the registers to read from
> + * @size: size of the data to be read
> + * @buf: buffer to hold the returned data
> + *
> + * Returns 0 on success, or negative on failure.
> + */
> +int virtio_pci_admin_legacy_device_io_read(struct pci_dev *pdev, u8 offset,
> +					   u8 size, u8 *buf)
> +{
> +	return virtio_pci_admin_legacy_io_read(pdev,
> +					VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ,
> +					offset, size, buf);
> +}
> +EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_device_io_read);
> +
> +/*
> + * virtio_pci_admin_legacy_common_io_read - Read legacy common registers of
> + * a member device
> + * @dev: VF pci_dev
> + * @offset: starting byte offset within the registers to read from
> + * @size: size of the data to be read
> + * @buf: buffer to hold the returned data
> + *
> + * Returns 0 on success, or negative on failure.
> + */
> +int virtio_pci_admin_legacy_common_io_read(struct pci_dev *pdev, u8 offset,
> +					    u8 size, u8 *buf)
> +{
> +	return virtio_pci_admin_legacy_io_read(pdev,
> +					VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ,
> +					offset, size, buf);
> +}
> +EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_common_io_read);
> +
> +/*
> + * virtio_pci_admin_legacy_io_notify_info - Read the queue notification
> + * information for legacy interface
> + * @dev: VF pci_dev
> + * @req_bar_flags: requested bar flags
> + * @bar: on output the BAR number of the member device
> + * @bar_offset: on output the offset within bar
> + *
> + * Returns 0 on success, or negative on failure.
> + */
> +int virtio_pci_admin_legacy_io_notify_info(struct pci_dev *pdev,
> +					   u8 req_bar_flags, u8 *bar,
> +					   u64 *bar_offset)
> +{
> +	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
> +	struct virtio_admin_cmd_notify_info_result *result;
> +	struct virtio_admin_cmd cmd = {};
> +	struct scatterlist result_sg;
> +	int vf_id;
> +	int ret;
> +
> +	if (!virtio_dev)
> +		return -ENODEV;
> +
> +	vf_id = pci_iov_vf_id(pdev);
> +	if (vf_id < 0)
> +		return vf_id;
> +
> +	result = kzalloc(sizeof(*result), GFP_KERNEL);
> +	if (!result)
> +		return -ENOMEM;
> +
> +	sg_init_one(&result_sg, result, sizeof(*result));
> +	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO);
> +	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
> +	cmd.group_member_id = cpu_to_le64(vf_id + 1);
> +	cmd.result_sg = &result_sg;
> +	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
> +	if (!ret) {
> +		struct virtio_admin_cmd_notify_info_data *entry;
> +		int i;
> +
> +		ret = -ENOENT;
> +		for (i = 0; i < VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO; i++) {
> +			entry = &result->entries[i];
> +			if (entry->flags == VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_END)
> +				break;
> +			if (entry->flags != req_bar_flags)
> +				continue;
> +			*bar = entry->bar;
> +			*bar_offset = le64_to_cpu(entry->offset);
> +			ret = 0;
> +			break;
> +		}
> +	}
> +
> +	kfree(result);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_io_notify_info);
> +
>  static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
>  	.get		= NULL,
>  	.set		= NULL,
> diff --git a/include/linux/virtio_pci_admin.h b/include/linux/virtio_pci_admin.h
> new file mode 100644
> index 000000000000..446ced8cb050
> --- /dev/null
> +++ b/include/linux/virtio_pci_admin.h
> @@ -0,0 +1,21 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_VIRTIO_PCI_ADMIN_H
> +#define _LINUX_VIRTIO_PCI_ADMIN_H
> +
> +#include <linux/types.h>
> +#include <linux/pci.h>
> +
> +bool virtio_pci_admin_has_legacy_io(struct pci_dev *pdev);
> +int virtio_pci_admin_legacy_common_io_write(struct pci_dev *pdev, u8 offset,
> +					    u8 size, u8 *buf);
> +int virtio_pci_admin_legacy_common_io_read(struct pci_dev *pdev, u8 offset,
> +					   u8 size, u8 *buf);
> +int virtio_pci_admin_legacy_device_io_write(struct pci_dev *pdev, u8 offset,
> +					    u8 size, u8 *buf);
> +int virtio_pci_admin_legacy_device_io_read(struct pci_dev *pdev, u8 offset,
> +					   u8 size, u8 *buf);
> +int virtio_pci_admin_legacy_io_notify_info(struct pci_dev *pdev,
> +					   u8 req_bar_flags, u8 *bar,
> +					   u64 *bar_offset);
> +
> +#endif /* _LINUX_VIRTIO_PCI_ADMIN_H */
> -- 
> 2.27.0



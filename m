Return-Path: <kvm+bounces-140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0998C7DC323
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 00:30:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B31822816A3
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 23:30:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CBA018E3C;
	Mon, 30 Oct 2023 23:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Auo4VYvT"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890EB18AE9
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 23:30:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29C6E1
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 16:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698708643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uRvzCP5v+vCa5V8gkjAmVzBD6PvXRbnm4WTXIRTATIs=;
	b=Auo4VYvTohHDMjI28n7jlkX8TUEwnq8POIx1qVOtQkpB+pe60BxmOPVVeMJXxEFlxmiT1l
	mFIR0l+DECDqXDTJBKDLg0mHfQ/knRdAcUujatWjeRwbB7r7kfvA0cNK+lu3HfYtDzdut4
	6kotAq+cD1ffH2lYOuIyjCDwGxcTnAo=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-FY-JiELWMPWqRAkFaKIzig-1; Mon, 30 Oct 2023 19:30:27 -0400
X-MC-Unique: FY-JiELWMPWqRAkFaKIzig-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-5b2c12c8248so3409105a12.3
        for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 16:30:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698708626; x=1699313426;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uRvzCP5v+vCa5V8gkjAmVzBD6PvXRbnm4WTXIRTATIs=;
        b=S9oweIGRg2aU6fUGMJCUgwahtQlFvFy0kWozyhbqNXnJZ/cNkShOCd2Qq76wQZ+sAW
         cUAu+A8vey5NSEnvJNm86HrRNPaX4EBMjkm/+wUuLghJXfzEmK0sc0nLrCDY6Vfw7Cq7
         iGFt6u9Ym2D3vc1aXgfIOaoRa8DGRNgwNTikVisfYwuwUdIZYzkPd7Y9Qtoos2srPpmF
         B4ZkRawfxYHwTEfSaG1/pj0kDYD3PJe018RgWOi8zNARhyzM3XQIQPMEpgN9gd3t9sfv
         bvh0jtfvCOYeTngxiGL9NzImGgCJ+MwGo0cdc5stA2A2lSy+P2HTYNC8EazVUI58ctMr
         83NQ==
X-Gm-Message-State: AOJu0YxBWmaGBhZpaqz1BgGZZEzGc0qHLIFuS4P9luGbd1eoGMj6+s5o
	kigXj8+CbGm470NLByfhxWotiKCOQWIDvL7VheexlFiTd5uTlvfdnBHAxJwCzF9XkXTBVyghmeG
	Mh1GzGhzMJDQH
X-Received: by 2002:a05:6a20:7aa7:b0:180:de1d:b93e with SMTP id u39-20020a056a207aa700b00180de1db93emr1004737pzh.28.1698708626183;
        Mon, 30 Oct 2023 16:30:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFsyQY2FR+nrJRYkcGbF92lyOCd/oNKEiPa6M1r7mJZv2Cfk0Q+P8eru6uiHM6p/3PJ7tw9Sw==
X-Received: by 2002:a05:6a20:7aa7:b0:180:de1d:b93e with SMTP id u39-20020a056a207aa700b00180de1db93emr1004723pzh.28.1698708625843;
        Mon, 30 Oct 2023 16:30:25 -0700 (PDT)
Received: from redhat.com ([2.52.26.150])
        by smtp.gmail.com with ESMTPSA id e23-20020aa78c57000000b00690fe1c928csm60842pfd.147.2023.10.30.16.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 16:30:25 -0700 (PDT)
Date: Mon, 30 Oct 2023 19:30:17 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: alex.williamson@redhat.com, jasowang@redhat.com, jgg@nvidia.com,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
	kevin.tian@intel.com, joao.m.martins@oracle.com,
	si-wei.liu@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V2 vfio 5/9] virtio-pci: Initialize the supported admin
 commands
Message-ID: <20231030192904-mutt-send-email-mst@kernel.org>
References: <20231029155952.67686-1-yishaih@nvidia.com>
 <20231029155952.67686-6-yishaih@nvidia.com>
 <20231029160750-mutt-send-email-mst@kernel.org>
 <bb8df2c8-74b5-4666-beda-550248a88890@nvidia.com>
 <20231030115541-mutt-send-email-mst@kernel.org>
 <4e95d66c-c382-4612-8d4b-7ff2b0acd3fb@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e95d66c-c382-4612-8d4b-7ff2b0acd3fb@nvidia.com>

On Mon, Oct 30, 2023 at 06:06:45PM +0200, Yishai Hadas wrote:
> On 30/10/2023 17:57, Michael S. Tsirkin wrote:
> > On Mon, Oct 30, 2023 at 05:27:50PM +0200, Yishai Hadas wrote:
> > > On 29/10/2023 22:17, Michael S. Tsirkin wrote:
> > > > On Sun, Oct 29, 2023 at 05:59:48PM +0200, Yishai Hadas wrote:
> > > > > Initialize the supported admin commands upon activating the admin queue.
> > > > > 
> > > > > The supported commands are saved as part of the admin queue context, it
> > > > > will be used by the next patches from this series.
> > > > > 
> > > > > Note:
> > > > > As we don't want to let upper layers to execute admin commands before
> > > > > that this initialization step was completed, we set ref count to 1 only
> > > > > post of that flow and use a non ref counted version command for this
> > > > > internal flow.
> > > > > 
> > > > > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> > > > > ---
> > > > >    drivers/virtio/virtio_pci_common.h |  1 +
> > > > >    drivers/virtio/virtio_pci_modern.c | 77 +++++++++++++++++++++++++++++-
> > > > >    2 files changed, 77 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
> > > > > index a21b9ba01a60..9e07e556a51a 100644
> > > > > --- a/drivers/virtio/virtio_pci_common.h
> > > > > +++ b/drivers/virtio/virtio_pci_common.h
> > > > > @@ -46,6 +46,7 @@ struct virtio_pci_admin_vq {
> > > > >    	struct virtio_pci_vq_info info;
> > > > >    	struct completion flush_done;
> > > > >    	refcount_t refcount;
> > > > > +	u64 supported_cmds;
> > > > >    	/* Name of the admin queue: avq.$index. */
> > > > >    	char name[10];
> > > > >    	u16 vq_index;
> > > > > diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
> > > > > index ccd7a4d9f57f..25e27aa79cab 100644
> > > > > --- a/drivers/virtio/virtio_pci_modern.c
> > > > > +++ b/drivers/virtio/virtio_pci_modern.c
> > > > > @@ -19,6 +19,9 @@
> > > > >    #define VIRTIO_RING_NO_LEGACY
> > > > >    #include "virtio_pci_common.h"
> > > > > +static int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
> > > > > +				    struct virtio_admin_cmd *cmd);
> > > > > +
> > > > I don't much like forward declarations. Just order functions sensibly
> > > > and they will not be needed.
> > > OK, will be part of V3.
> > > 
> > > > >    static u64 vp_get_features(struct virtio_device *vdev)
> > > > >    {
> > > > >    	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
> > > > > @@ -59,6 +62,42 @@ vp_modern_avq_set_abort(struct virtio_pci_admin_vq *admin_vq, bool abort)
> > > > >    	WRITE_ONCE(admin_vq->abort, abort);
> > > > >    }
> > > > > +static void virtio_pci_admin_init_cmd_list(struct virtio_device *virtio_dev)
> > > > > +{
> > > > > +	struct virtio_pci_device *vp_dev = to_vp_device(virtio_dev);
> > > > > +	struct virtio_admin_cmd cmd = {};
> > > > > +	struct scatterlist result_sg;
> > > > > +	struct scatterlist data_sg;
> > > > > +	__le64 *data;
> > > > > +	int ret;
> > > > > +
> > > > > +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> > > > > +	if (!data)
> > > > > +		return;
> > > > > +
> > > > > +	sg_init_one(&result_sg, data, sizeof(*data));
> > > > > +	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_QUERY);
> > > > > +	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
> > > > > +	cmd.result_sg = &result_sg;
> > > > > +
> > > > > +	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
> > > > > +	if (ret)
> > > > > +		goto end;
> > > > > +
> > > > > +	sg_init_one(&data_sg, data, sizeof(*data));
> > > > > +	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_USE);
> > > > > +	cmd.data_sg = &data_sg;
> > > > > +	cmd.result_sg = NULL;
> > > > > +
> > > > > +	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
> > > > > +	if (ret)
> > > > > +		goto end;
> > > > > +
> > > > > +	vp_dev->admin_vq.supported_cmds = le64_to_cpu(*data);
> > > > > +end:
> > > > > +	kfree(data);
> > > > > +}
> > > > > +
> > > > >    static void vp_modern_avq_activate(struct virtio_device *vdev)
> > > > >    {
> > > > >    	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
> > > > > @@ -67,6 +106,7 @@ static void vp_modern_avq_activate(struct virtio_device *vdev)
> > > > >    	if (!virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ))
> > > > >    		return;
> > > > > +	virtio_pci_admin_init_cmd_list(vdev);
> > > > >    	init_completion(&admin_vq->flush_done);
> > > > >    	refcount_set(&admin_vq->refcount, 1);
> > > > >    	vp_modern_avq_set_abort(admin_vq, false);
> > > > > @@ -562,6 +602,35 @@ static bool vp_get_shm_region(struct virtio_device *vdev,
> > > > >    	return true;
> > > > >    }
> > > > > +static int __virtqueue_exec_admin_cmd(struct virtio_pci_admin_vq *admin_vq,
> > > > > +				    struct scatterlist **sgs,
> > > > > +				    unsigned int out_num,
> > > > > +				    unsigned int in_num,
> > > > > +				    void *data,
> > > > > +				    gfp_t gfp)
> > > > > +{
> > > > > +	struct virtqueue *vq;
> > > > > +	int ret, len;
> > > > > +
> > > > > +	vq = admin_vq->info.vq;
> > > > > +
> > > > > +	ret = virtqueue_add_sgs(vq, sgs, out_num, in_num, data, gfp);
> > > > > +	if (ret < 0)
> > > > > +		return ret;
> > > > > +
> > > > > +	if (unlikely(!virtqueue_kick(vq)))
> > > > > +		return -EIO;
> > > > > +
> > > > > +	while (!virtqueue_get_buf(vq, &len) &&
> > > > > +	       !virtqueue_is_broken(vq))
> > > > > +		cpu_relax();
> > > > > +
> > > > > +	if (virtqueue_is_broken(vq))
> > > > > +		return -EIO;
> > > > > +
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > This is tolerable I guess but it might pin the CPU for a long time.
> > > > The difficulty is handling suprize removal well which we currently
> > > > don't do with interrupts. I would say it's ok as is but add
> > > > a TODO comments along the lines of /* TODO: use interrupts once these virtqueue_is_broken */
> > > I assume that you asked for adding the below comment before the while loop:
> > > /* TODO use interrupts to reduce cpu cycles in the future */
> > > 
> > > Right ?
> > > 
> > > Yishai
> > Well I wrote what I meant. in the future is redundant - everyone knows
> > we can't change the past.
> 
> I agree, no need for 'in the future'.
> 
> However, in your suggestion you mentioned  "once these virtqueue_is_broken".
> 
> What does that mean in current polling mode ?
> 
> Yishai

Maye better: /* TODO: use vq callback once it supports virtqueue_is_broken */

> > 
> > > > >    static int virtqueue_exec_admin_cmd(struct virtio_pci_admin_vq *admin_vq,
> > > > >    				    struct scatterlist **sgs,
> > > > >    				    unsigned int out_num,
> > > > > @@ -653,7 +722,13 @@ static int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
> > > > >    		in_num++;
> > > > >    	}
> > > > > -	ret = virtqueue_exec_admin_cmd(&vp_dev->admin_vq, sgs,
> > > > > +	if (cmd->opcode == VIRTIO_ADMIN_CMD_LIST_QUERY ||
> > > > > +	    cmd->opcode == VIRTIO_ADMIN_CMD_LIST_USE)
> > > > > +		ret = __virtqueue_exec_admin_cmd(&vp_dev->admin_vq, sgs,
> > > > > +				       out_num, in_num,
> > > > > +				       sgs, GFP_KERNEL);
> > > > > +	else
> > > > > +		ret = virtqueue_exec_admin_cmd(&vp_dev->admin_vq, sgs,
> > > > >    				       out_num, in_num,
> > > > >    				       sgs, GFP_KERNEL);
> > > > >    	if (ret) {
> > > > > -- 
> > > > > 2.27.0
> 



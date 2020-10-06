Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE88284B37
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 13:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgJFL6c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 07:58:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50396 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726074AbgJFL6b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Oct 2020 07:58:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601985509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=++G+Zcfk1rwxxjrbSt9E7kviCL52xsOg66+5duMLn5Y=;
        b=iz1Cj9H68Ez/WtuplCJGLd2BTxZ573qBINMesIzK4EQ8Z2tkdvWe/Axu1SzwAfux/wZ/PK
        yiTr5rDHmU/StKHSKEHUIKaosbnxJDcOzQGTHKH8gl/6IphWjvPtJnrj0L85RltpuXLGXa
        bikyVnc9WEhD3IzqN6qrxJ/nU7+Phb8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-rDGFvaYuMEOdnBWRm35Ahw-1; Tue, 06 Oct 2020 07:58:28 -0400
X-MC-Unique: rDGFvaYuMEOdnBWRm35Ahw-1
Received: by mail-wr1-f71.google.com with SMTP id g6so5279740wrv.3
        for <kvm@vger.kernel.org>; Tue, 06 Oct 2020 04:58:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=++G+Zcfk1rwxxjrbSt9E7kviCL52xsOg66+5duMLn5Y=;
        b=SZLfB2/OkOGfbD90cFWhLstDjwpV3YegZbWVn9Za8nHKnGUmwPzrMAlY1BzVokqMvU
         09khEczCe74S88m8JyV9R3AVG4ZvciyXwviy/F2rMENrPJm1EG70T0DweMb7JIOc8/K9
         bN+I/wL4K2jC+ThdZWFGcUHZAf+ZNbJd/7dXPS1/nf9nKG7fjhAGd7DDhZl1yubVUsH9
         9Jltxxyq5cnLg5YRM4RIH6xCdrupF3YaWdvbuTnpMs/dL+BfOjkwY/dJ6NuQwcECJ6TW
         kdbZVe5haU3AjjDiuYB53ozXBoAaWfZVu75A/b+VWqGT6EtSjvy5Cxql58RhgUMdgqAh
         V+Cg==
X-Gm-Message-State: AOAM532sQLV+DxG9lNzY4w4hI7cy1ZwAsW2lLlLHWU1frnprk0bCR9qo
        iznzumbRj0uQnfCGv+nV9ExUbZrJJsJxRBNtmSwfvjnsyZk6xt6sBr8Gp6mJaSI9WQtf4ZH1tw8
        aYaPgog6reGL6
X-Received: by 2002:adf:a3db:: with SMTP id m27mr4770199wrb.277.1601985506578;
        Tue, 06 Oct 2020 04:58:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6Sp5W+WqZXC/hbqf5I4EH+CsnZ3iNz7ejs5V3Pl/kNSWE0RV8qhqqVj/4rKejD7Tan6Fong==
X-Received: by 2002:adf:a3db:: with SMTP id m27mr4770156wrb.277.1601985506079;
        Tue, 06 Oct 2020 04:58:26 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id k15sm4487867wrv.90.2020.10.06.04.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 04:58:25 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     BARBALACE Antonio <antonio.barbalace@ed.ac.uk>
Cc:     "will\@kernel.org" <will@kernel.org>,
        "julien.thierry.kdev\@gmail.com" <julien.thierry.kdev@gmail.com>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: kvmtool: vhost MQ support
In-Reply-To: <AM7PR05MB7076F55498C85087F09421F6CC0C0@AM7PR05MB7076.eurprd05.prod.outlook.com>
References: <AM7PR05MB7076F55498C85087F09421F6CC0C0@AM7PR05MB7076.eurprd05.prod.outlook.com>
Date:   Tue, 06 Oct 2020 13:58:24 +0200
Message-ID: <87a6wz8t27.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

BARBALACE Antonio <antonio.barbalace@ed.ac.uk> writes:

> This patch enables vhost MQ to support in kvmtool without any Linux kernel modification.
> The patch takes the same approach as QEMU -- for each queue pair a new /dev/vhost-net fd is created.
> Fds are kept in ndev->vhost_fds, with ndev->vhost_fd == ndev->vhost_fds[0] (to avoid further modification to the existent source code).
> Thanks, Antonio Barbalace
> The University of Edinburgh is a charitable body, registered in Scotland, with registration number SC005336.
> diff --git a/virtio/net.c b/virtio/net.c
> index 1ee3c19..bae3019 100644
> --- a/virtio/net.c
> +++ b/virtio/net.c
> @@ -58,6 +58,7 @@ struct net_dev {
>  	u32				features, queue_pairs;
>  
>  	int				vhost_fd;
> +	int				vhost_fds[VIRTIO_NET_NUM_QUEUES];
>  	int				tap_fd;
>  	char				tap_name[IFNAMSIZ];
>  	bool				tap_ufo;
> @@ -512,6 +513,7 @@ static int virtio_net__vhost_set_features(struct net_dev *ndev)
>  {
>  	u64 features = 1UL << VIRTIO_RING_F_EVENT_IDX;
>  	u64 vhost_features;
> +	int i, r = 0;
>  
>  	if (ioctl(ndev->vhost_fd, VHOST_GET_FEATURES, &vhost_features) != 0)
>  		die_perror("VHOST_GET_FEATURES failed");
> @@ -521,7 +523,9 @@ static int virtio_net__vhost_set_features(struct net_dev *ndev)
>  			has_virtio_feature(ndev, VIRTIO_NET_F_MRG_RXBUF))
>  		features |= 1UL << VIRTIO_NET_F_MRG_RXBUF;
>  
> -	return ioctl(ndev->vhost_fd, VHOST_SET_FEATURES, &features);
> +	for (i=0; ((u32)i < ndev->queue_pairs) && (r >= 0); i++)

Neither a virtio nor a kvmtool person here, just some comments about the
style below.

Nit: more spaces needed:
	for (i = 0; 

(u32) cast is not really needed because ndev->queue_pairs is caped with
VIRTIO_NET_NUM_QUEUES and 

ndev->queue_pairs = max(1, min(VIRTIO_NET_NUM_QUEUES, params->mq));

alternatively, you can just declare i as 'u32'.

> +		r = ioctl(ndev->vhost_fds[i], VHOST_SET_FEATURES, &features); 

To improve the readability I'd suggest to write this as

	for (i=0; i < ndev->queue_pairs; i++) {
		r = ioctl(ndev->vhost_fds[i], VHOST_SET_FEATURES, &features);
		if (r)
			break;
	}


> +	return r;
>  }
>  
>  static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
> @@ -578,7 +582,7 @@ static bool is_ctrl_vq(struct net_dev *ndev, u32 vq)
>  static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
>  		   u32 pfn)
>  {
> -	struct vhost_vring_state state = { .index = vq };
> +	struct vhost_vring_state state = { .index = (vq %2) };

Nit: superfluous parentheses

>  	struct net_dev_queue *net_queue;
>  	struct vhost_vring_addr addr;
>  	struct net_dev *ndev = dev;
> @@ -619,23 +623,24 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
>  	if (queue->endian != VIRTIO_ENDIAN_HOST)
>  		die_perror("VHOST requires the same endianness in guest and host");
>  
> -	state.num = queue->vring.num;
> -	r = ioctl(ndev->vhost_fd, VHOST_SET_VRING_NUM, &state);
> +	state.num = queue->vring.num; //number of decriptors

I don't see C++ style comments anywhere in this file, use /* */ instead.

> +        r = ioctl(ndev->vhost_fds[(vq /2)], VHOST_SET_VRING_NUM, &state);

Indentation. Also, you seem to be using 'vq / 2' a lot, maybe assign
this to a local variable.

>  	if (r < 0)
>  		die_perror("VHOST_SET_VRING_NUM failed");
> -	state.num = 0;
> -	r = ioctl(ndev->vhost_fd, VHOST_SET_VRING_BASE, &state);
> +
> +	state.num = 0; //descriptors base

Comment style.

> +	r = ioctl(ndev->vhost_fds[(vq /2)], VHOST_SET_VRING_BASE, &state);
>  	if (r < 0)
>  		die_perror("VHOST_SET_VRING_BASE failed");
>  
>  	addr = (struct vhost_vring_addr) {
> -		.index = vq,
> +		.index = (vq %2),
>  		.desc_user_addr = (u64)(unsigned long)queue->vring.desc,
>  		.avail_user_addr = (u64)(unsigned long)queue->vring.avail,
>  		.used_user_addr = (u64)(unsigned long)queue->vring.used,
>  	};
>  
> -	r = ioctl(ndev->vhost_fd, VHOST_SET_VRING_ADDR, &addr);
> +	r = ioctl(ndev->vhost_fds[(vq /2)], VHOST_SET_VRING_ADDR, &addr);
>  	if (r < 0)
>  		die_perror("VHOST_SET_VRING_ADDR failed");
>  
> @@ -659,7 +664,7 @@ static void exit_vq(struct kvm *kvm, void *dev, u32 vq)
>  	 */
>  	if (ndev->vhost_fd && !is_ctrl_vq(ndev, vq)) {
>  		pr_warning("Cannot reset VHOST queue");
> -		ioctl(ndev->vhost_fd, VHOST_RESET_OWNER);
> +		ioctl(ndev->vhost_fds[(vq /2)], VHOST_RESET_OWNER);
>  		return;
>  	}
>  
> @@ -682,7 +687,7 @@ static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
>  		return;
>  
>  	file = (struct vhost_vring_file) {
> -		.index	= vq,
> +		.index	= (vq % 2),
>  		.fd	= eventfd(0, 0),
>  	};
>  
> @@ -693,31 +698,32 @@ static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
>  	queue->irqfd = file.fd;
>  	queue->gsi = gsi;
>  
> -	r = ioctl(ndev->vhost_fd, VHOST_SET_VRING_CALL, &file);
> +	r = ioctl(ndev->vhost_fds[(vq /2)], VHOST_SET_VRING_CALL, &file);
>  	if (r < 0)
>  		die_perror("VHOST_SET_VRING_CALL failed");
> +
>  	file.fd = ndev->tap_fd;
> -	r = ioctl(ndev->vhost_fd, VHOST_NET_SET_BACKEND, &file);
> +	r = ioctl(ndev->vhost_fds[(vq /2)], VHOST_NET_SET_BACKEND, &file);
>  	if (r != 0)
>  		die("VHOST_NET_SET_BACKEND failed %d", errno);
> -
>  }
>  
>  static void notify_vq_eventfd(struct kvm *kvm, void *dev, u32 vq, u32 efd)
>  {
>  	struct net_dev *ndev = dev;
>  	struct vhost_vring_file file = {
> -		.index	= vq,
> +		.index	= (vq % 2),
>  		.fd	= efd,
>  	};
>  	int r;
>  
> -	if (ndev->vhost_fd == 0 || is_ctrl_vq(ndev, vq))
> +	if (ndev->vhost_fd == 0 || is_ctrl_vq(ndev, vq)) {
>  		return;
> +	}
> +	r = ioctl(ndev->vhost_fds[(vq /2)], VHOST_SET_VRING_KICK, &file);
>  
> -	r = ioctl(ndev->vhost_fd, VHOST_SET_VRING_KICK, &file);
>  	if (r < 0)
> -		die_perror("VHOST_SET_VRING_KICK failed");
> +		die_perror("VHOST_SET_VRING_KICK failed test");

What is this 'failed test' about? Stray change?

>  }
>  
>  static int notify_vq(struct kvm *kvm, void *dev, u32 vq)
> @@ -777,10 +783,6 @@ static void virtio_net__vhost_init(struct kvm *kvm, struct net_dev *ndev)
>  	struct vhost_memory *mem;
>  	int r, i;
>  
> -	ndev->vhost_fd = open("/dev/vhost-net", O_RDWR);
> -	if (ndev->vhost_fd < 0)
> -		die_perror("Failed openning vhost-net device");
> -
>  	mem = calloc(1, sizeof(*mem) + kvm->mem_slots * sizeof(struct vhost_memory_region));
>  	if (mem == NULL)
>  		die("Failed allocating memory for vhost memory map");
> @@ -796,13 +798,22 @@ static void virtio_net__vhost_init(struct kvm *kvm, struct net_dev *ndev)
>  	}
>  	mem->nregions = i;
>  
> -	r = ioctl(ndev->vhost_fd, VHOST_SET_OWNER);
> -	if (r != 0)
> -		die_perror("VHOST_SET_OWNER failed");
> +	for (i=0; ((u32)i < ndev->queue_pairs) && 
> +			(i < VIRTIO_NET_NUM_QUEUES); i++) {
>  

Same as above.

> -	r = ioctl(ndev->vhost_fd, VHOST_SET_MEM_TABLE, mem);
> -	if (r != 0)
> -		die_perror("VHOST_SET_MEM_TABLE failed");
> +		ndev->vhost_fds[i] = open("/dev/vhost-net", O_RDWR);
> +	        if (ndev->vhost_fds[i] < 0)
> +			die_perror("Failed openning vhost-net device");
> +
> +		r = ioctl(ndev->vhost_fds[i], VHOST_SET_OWNER);
> +		if (r != 0)
> +			die_perror("VHOST_SET_OWNER failed");
> +	
> +		r = ioctl(ndev->vhost_fds[i], VHOST_SET_MEM_TABLE, mem);
> +		if (r != 0)
> +			die_perror("VHOST_SET_MEM_TABLE failed");
> +	}
> +	ndev->vhost_fd = ndev->vhost_fds[0];

Do we actually need 'vhost_fd' at all, can we just use vhost_fds[0] in a
few places where it is still present?

>  
>  	ndev->vdev.use_vhost = true;
>  
> @@ -966,7 +977,6 @@ static int virtio_net__init_one(struct virtio_net_params *params)
>  				   "falling back to %s.", params->trans,
>  				   virtio_trans_name(trans));
>  	}
> -

Stray change?

>  	r = virtio_init(params->kvm, ndev, &ndev->vdev, ops, trans,
>  			PCI_DEVICE_ID_VIRTIO_NET, VIRTIO_ID_NET, PCI_CLASS_NET);
>  	if (r < 0) {
> diff --git a/virtio/pci.c b/virtio/pci.c
> index c652949..7a1532b 100644
> --- a/virtio/pci.c
> +++ b/virtio/pci.c
> @@ -44,7 +44,8 @@ static int virtio_pci__init_ioeventfd(struct kvm *kvm, struct virtio_device *vde
>  	 * Vhost will poll the eventfd in host kernel side, otherwise we
>  	 * need to poll in userspace.
>  	 */
> -	if (!vdev->use_vhost)
> +	if ( (!vdev->use_vhost) ||

Xen coding style detected :-) Just

	if (!vdev->use_vhost || (vdev->ops->get_vq_count(kvm, vpci->dev) = vq + 1)

would do fine.

> +		((u32)vdev->ops->get_vq_count(kvm, vpci->dev)==(vq+1)) )
>  		flags |= IOEVENTFD_FLAG_USER_POLL;
>  
>  	/* ioport */

-- 
Vitaly


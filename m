Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B00F15D2D7
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 08:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbgBNHd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 02:33:58 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29640 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728374AbgBNHd6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 02:33:58 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01E7P46r065470
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 02:33:56 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y4j8ckrr4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 02:33:55 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 14 Feb 2020 07:33:54 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 14 Feb 2020 07:33:50 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01E7XoQC58851522
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 07:33:50 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0178EA405B;
        Fri, 14 Feb 2020 07:33:50 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A04CDA4062;
        Fri, 14 Feb 2020 07:33:49 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.211])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Feb 2020 07:33:49 +0000 (GMT)
Subject: Re: vhost changes (batched) in linux-next after 12/13 trigger random
 crashes in KVM guests after reboot
To:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <20200107042401-mutt-send-email-mst@kernel.org>
 <b6e32f58e5d85ac5cc3141e9155fb140ae5cd580.camel@redhat.com>
 <1ade56b5-083f-bb6f-d3e0-3ddcf78f4d26@de.ibm.com>
 <20200206171349-mutt-send-email-mst@kernel.org>
 <5c860fa1-cef5-b389-4ebf-99a62afa0fe8@de.ibm.com>
 <20200207025806-mutt-send-email-mst@kernel.org>
 <97c93d38-ef07-e321-d133-18483d54c0c0@de.ibm.com>
 <CAJaqyWfngzP4d01B6+Sqt8FXN6jX7kGegjx8ie4no_1Er3igQA@mail.gmail.com>
 <43a5dbaa-9129-e220-8483-45c60a82c945@de.ibm.com>
 <e299afca8e22044916abbf9fbbd0bff6b0ee9e13.camel@redhat.com>
 <4c3f70b7-723a-8b0f-ac49-babef1bcc180@de.ibm.com>
 <50a79c3491ac483583c97df2fac29e2c3248fdea.camel@redhat.com>
 <8fbbfb49-99d1-7fee-e713-d6d5790fe866@de.ibm.com>
 <2364d0728c3bb4bcc0c13b591f774109a9274a30.camel@redhat.com>
 <bb9fb726-306c-5330-05aa-a86bd1b18097@de.ibm.com>
 <468983fad50a5e74a739f71487f0ea11e8d4dfd1.camel@redhat.com>
 <2dc1df65-1431-3917-40e5-c2b12096e2a7@de.ibm.com>
 <bd9c9b4d99abd20d5420583af5a4954ea1cf4618.camel@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Fri, 14 Feb 2020 08:33:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <bd9c9b4d99abd20d5420583af5a4954ea1cf4618.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20021407-0016-0000-0000-000002E6B052
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021407-0017-0000-0000-00003349B69B
Message-Id: <e11ba53c-a5fa-0518-2e06-9296897ed529@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_01:2020-02-12,2020-02-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=2 phishscore=0
 mlxlogscore=999 clxscore=1015 impostorscore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002140060
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I did 
ping -c 20 -f ... ; reboot 
twice

The ping after the first reboot showed .......E 

this was on the host console

[   55.951885] CPU: 34 PID: 1908 Comm: CPU 0/KVM Not tainted 5.5.0+ #21
[   55.951891] Hardware name: IBM 3906 M04 704 (LPAR)
[   55.951892] Call Trace:
[   55.951902]  [<0000001ede114132>] show_stack+0x8a/0xd0 
[   55.951906]  [<0000001edeb0672a>] dump_stack+0x8a/0xb8 
[   55.951915]  [<000003ff803736a6>] vhost_vring_ioctl+0x6fe/0x858 [vhost] 
[   55.951919]  [<000003ff8042a608>] vhost_net_ioctl+0x510/0x570 [vhost_net] 
[   55.951924]  [<0000001ede3c4dd8>] do_vfs_ioctl+0x430/0x6f8 
[   55.951926]  [<0000001ede3c5124>] ksys_ioctl+0x84/0xb0 
[   55.951927]  [<0000001ede3c51ba>] __s390x_sys_ioctl+0x2a/0x38 
[   55.951931]  [<0000001edeb27f72>] system_call+0x2a6/0x2c8 
[   55.951949] CPU: 34 PID: 1908 Comm: CPU 0/KVM Not tainted 5.5.0+ #21
[   55.951950] Hardware name: IBM 3906 M04 704 (LPAR)
[   55.951951] Call Trace:
[   55.951952]  [<0000001ede114132>] show_stack+0x8a/0xd0 
[   55.951954]  [<0000001edeb0672a>] dump_stack+0x8a/0xb8 
[   55.951956]  [<000003ff803736a6>] vhost_vring_ioctl+0x6fe/0x858 [vhost] 
[   55.951958]  [<000003ff8042a608>] vhost_net_ioctl+0x510/0x570 [vhost_net] 
[   55.951959]  [<0000001ede3c4dd8>] do_vfs_ioctl+0x430/0x6f8 
[   55.951961]  [<0000001ede3c5124>] ksys_ioctl+0x84/0xb0 
[   55.951962]  [<0000001ede3c51ba>] __s390x_sys_ioctl+0x2a/0x38 
[   55.951964]  [<0000001edeb27f72>] system_call+0x2a6/0x2c8 
[   55.951997] Guest moved vq 0000000063d896c6 used index from 44 to 0
[   56.609831] unexpected descriptor format for RX: out 0, in 0
[   86.540460] CPU: 6 PID: 1908 Comm: CPU 0/KVM Not tainted 5.5.0+ #21
[   86.540464] Hardware name: IBM 3906 M04 704 (LPAR)
[   86.540466] Call Trace:
[   86.540473]  [<0000001ede114132>] show_stack+0x8a/0xd0 
[   86.540477]  [<0000001edeb0672a>] dump_stack+0x8a/0xb8 
[   86.540486]  [<000003ff803736a6>] vhost_vring_ioctl+0x6fe/0x858 [vhost] 
[   86.540490]  [<000003ff8042a608>] vhost_net_ioctl+0x510/0x570 [vhost_net] 
[   86.540494]  [<0000001ede3c4dd8>] do_vfs_ioctl+0x430/0x6f8 
[   86.540496]  [<0000001ede3c5124>] ksys_ioctl+0x84/0xb0 
[   86.540498]  [<0000001ede3c51ba>] __s390x_sys_ioctl+0x2a/0x38 
[   86.540501]  [<0000001edeb27f72>] system_call+0x2a6/0x2c8 
[   86.540524] CPU: 6 PID: 1908 Comm: CPU 0/KVM Not tainted 5.5.0+ #21
[   86.540525] Hardware name: IBM 3906 M04 704 (LPAR)
[   86.540526] Call Trace:
[   86.540527]  [<0000001ede114132>] show_stack+0x8a/0xd0 
[   86.540528]  [<0000001edeb0672a>] dump_stack+0x8a/0xb8 
[   86.540531]  [<000003ff803736a6>] vhost_vring_ioctl+0x6fe/0x858 [vhost] 
[   86.540532]  [<000003ff8042a608>] vhost_net_ioctl+0x510/0x570 [vhost_net] 
[   86.540534]  [<0000001ede3c4dd8>] do_vfs_ioctl+0x430/0x6f8 
[   86.540536]  [<0000001ede3c5124>] ksys_ioctl+0x84/0xb0 
[   86.540537]  [<0000001ede3c51ba>] __s390x_sys_ioctl+0x2a/0x38 
[   86.540538]  [<0000001edeb27f72>] system_call+0x2a6/0x2c8 
[   86.540570] unexpected descriptor format for RX: out 0, in 0
[   86.540577] Unexpected header len for TX: 0 expected 0


On 14.02.20 08:06, Eugenio Pérez wrote:
> Hi Christian.
> 
> Sorry, that was meant to be applied over previous debug patch.
> 
> Here I inline the one meant to be applied over eccb852f1fe6bede630e2e4f1a121a81e34354ab.
> 
> Thanks!
> 
> From d978ace99e4844b49b794d768385db3d128a4cc0 Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
> Date: Fri, 14 Feb 2020 08:02:26 +0100
> Subject: [PATCH] vhost: disable all features and trace last_avail_idx and
>  ioctl calls
> 
> ---
>  drivers/vhost/net.c   | 20 +++++++++++++++++---
>  drivers/vhost/vhost.c | 25 +++++++++++++++++++++++--
>  drivers/vhost/vhost.h | 10 +++++-----
>  3 files changed, 45 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index e158159671fa..e4d5f843f9c0 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -1505,10 +1505,13 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
>  
>  	mutex_lock(&n->dev.mutex);
>  	r = vhost_dev_check_owner(&n->dev);
> -	if (r)
> +	if (r) {
> +		pr_debug("vhost_dev_check_owner index=%u fd=%d rc r=%d", index, fd, r);
>  		goto err;
> +	}
>  
>  	if (index >= VHOST_NET_VQ_MAX) {
> +		pr_debug("vhost_dev_check_owner index=%u fd=%d MAX=%d", index, fd, VHOST_NET_VQ_MAX);
>  		r = -ENOBUFS;
>  		goto err;
>  	}
> @@ -1518,22 +1521,26 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
>  
>  	/* Verify that ring has been setup correctly. */
>  	if (!vhost_vq_access_ok(vq)) {
> +		pr_debug("vhost_net_set_backend index=%u fd=%d !vhost_vq_access_ok", index, fd);
>  		r = -EFAULT;
>  		goto err_vq;
>  	}
>  	sock = get_socket(fd);
>  	if (IS_ERR(sock)) {
>  		r = PTR_ERR(sock);
> +		pr_debug("vhost_net_set_backend index=%u fd=%d get_socket err r=%d", index, fd, r);
>  		goto err_vq;
>  	}
>  
>  	/* start polling new socket */
>  	oldsock = vq->private_data;
>  	if (sock != oldsock) {
> +		pr_debug("sock=%p != oldsock=%p index=%u fd=%d vq=%p", sock, oldsock, index, fd, vq);
>  		ubufs = vhost_net_ubuf_alloc(vq,
>  					     sock && vhost_sock_zcopy(sock));
>  		if (IS_ERR(ubufs)) {
>  			r = PTR_ERR(ubufs);
> +			pr_debug("ubufs index=%u fd=%d err r=%d vq=%p", index, fd, r, vq);
>  			goto err_ubufs;
>  		}
>  
> @@ -1541,11 +1548,15 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
>  		vq->private_data = sock;
>  		vhost_net_buf_unproduce(nvq);
>  		r = vhost_vq_init_access(vq);
> -		if (r)
> +		if (r) {
> +			pr_debug("init_access index=%u fd=%d r=%d vq=%p", index, fd, r, vq);
>  			goto err_used;
> +		}
>  		r = vhost_net_enable_vq(n, vq);
> -		if (r)
> +		if (r) {
> +			pr_debug("enable_vq index=%u fd=%d r=%d vq=%p", index, fd, r, vq);
>  			goto err_used;
> +		}
>  		if (index == VHOST_NET_VQ_RX)
>  			nvq->rx_ring = get_tap_ptr_ring(fd);
>  
> @@ -1559,6 +1570,8 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
>  
>  	mutex_unlock(&vq->mutex);
>  
> +	pr_debug("sock=%p", sock);
> +
>  	if (oldubufs) {
>  		vhost_net_ubuf_put_wait_and_free(oldubufs);
>  		mutex_lock(&vq->mutex);
> @@ -1710,6 +1723,7 @@ static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
>  
>  	switch (ioctl) {
>  	case VHOST_NET_SET_BACKEND:
> +		pr_debug("VHOST_NET_SET_BACKEND");
>  		if (copy_from_user(&backend, argp, sizeof backend))
>  			return -EFAULT;
>  		return vhost_net_set_backend(n, backend.index, backend.fd);
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index b5a51b1f2e79..ec25ba32fe81 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1642,15 +1642,30 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
>  			r = -EINVAL;
>  			break;
>  		}
> +
> +		if (vq->last_avail_idx || vq->avail_idx) {
> +			pr_debug(
> +				"strange VHOST_SET_VRING_BASE [vq=%p][s.index=%u][s.num=%u]",
> +				vq, s.index, s.num);
> +			dump_stack();
> +			r = 0;
> +			break;
> +		}
>  		vq->last_avail_idx = s.num;
>  		/* Forget the cached index value. */
>  		vq->avail_idx = vq->last_avail_idx;
> +		pr_debug(
> +			"VHOST_SET_VRING_BASE [vq=%p][vq->last_avail_idx=%u][vq->avail_idx=%u][s.index=%u][s.num=%u]",
> +			vq, vq->last_avail_idx, vq->avail_idx, s.index, s.num);
>  		break;
>  	case VHOST_GET_VRING_BASE:
>  		s.index = idx;
>  		s.num = vq->last_avail_idx;
>  		if (copy_to_user(argp, &s, sizeof s))
>  			r = -EFAULT;
> +		pr_debug(
> +			"VHOST_GET_VRING_BASE [vq=%p][vq->last_avail_idx=%u][vq->avail_idx=%u][s.index=%u][s.num=%u]",
> +			vq, vq->last_avail_idx, vq->avail_idx, s.index, s.num);
>  		break;
>  	case VHOST_SET_VRING_KICK:
>  		if (copy_from_user(&f, argp, sizeof f)) {
> @@ -2239,8 +2254,8 @@ static int fetch_buf(struct vhost_virtqueue *vq)
>  		vq->avail_idx = vhost16_to_cpu(vq, avail_idx);
>  
>  		if (unlikely((u16)(vq->avail_idx - last_avail_idx) > vq->num)) {
> -			vq_err(vq, "Guest moved used index from %u to %u",
> -				last_avail_idx, vq->avail_idx);
> +			vq_err(vq, "Guest moved vq %p used index from %u to %u",
> +				vq, last_avail_idx, vq->avail_idx);
>  			return -EFAULT;
>  		}
>  
> @@ -2316,6 +2331,9 @@ static int fetch_buf(struct vhost_virtqueue *vq)
>  	BUG_ON(!(vq->used_flags & VRING_USED_F_NO_NOTIFY));
>  
>  	/* On success, increment avail index. */
> +	pr_debug(
> +		"[vq=%p][vq->last_avail_idx=%u][vq->avail_idx=%u][vq->ndescs=%d][vq->first_desc=%d]",
> +		vq, vq->last_avail_idx, vq->avail_idx, vq->ndescs, vq->first_desc);
>  	vq->last_avail_idx++;
>  
>  	return 0;
> @@ -2432,6 +2450,9 @@ EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
>  /* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
>  void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
>  {
> +	pr_debug(
> +		"DISCARD [vq=%p][vq->last_avail_idx=%u][vq->avail_idx=%u][n=%d]",
> +		vq, vq->last_avail_idx, vq->avail_idx, n);
>  	vq->last_avail_idx -= n;
>  }
>  EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index 661088ae6dc7..08f6d2ccb697 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -250,11 +250,11 @@ int vhost_init_device_iotlb(struct vhost_dev *d, bool enabled);
>  	} while (0)
>  
>  enum {
> -	VHOST_FEATURES = (1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
> -			 (1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
> -			 (1ULL << VIRTIO_RING_F_EVENT_IDX) |
> -			 (1ULL << VHOST_F_LOG_ALL) |
> -			 (1ULL << VIRTIO_F_ANY_LAYOUT) |
> +	VHOST_FEATURES = /* (1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) | */
> +			 /* (1ULL << VIRTIO_RING_F_INDIRECT_DESC) | */
> +			 /* (1ULL << VIRTIO_RING_F_EVENT_IDX) | */
> +			 /* (1ULL << VHOST_F_LOG_ALL) | */
> +			 /* (1ULL << VIRTIO_F_ANY_LAYOUT) | */
>  			 (1ULL << VIRTIO_F_VERSION_1)
>  };
>  
> 


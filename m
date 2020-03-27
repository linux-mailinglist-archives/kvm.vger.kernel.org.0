Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7A73195A34
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 16:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbgC0Pqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Mar 2020 11:46:49 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11858 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727509AbgC0Pqs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Mar 2020 11:46:48 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02RFY8BX027557
        for <kvm@vger.kernel.org>; Fri, 27 Mar 2020 11:46:46 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ywbv0dx9p-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 27 Mar 2020 11:46:46 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 27 Mar 2020 15:46:37 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 27 Mar 2020 15:46:35 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02RFke2853149808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 15:46:40 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A98BB5204E;
        Fri, 27 Mar 2020 15:46:40 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.169.170])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 075E752051;
        Fri, 27 Mar 2020 15:46:39 +0000 (GMT)
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
 <4c3f70b7-723a-8b0f-ac49-babef1bcc180@de.ibm.com>
 <50a79c3491ac483583c97df2fac29e2c3248fdea.camel@redhat.com>
 <8fbbfb49-99d1-7fee-e713-d6d5790fe866@de.ibm.com>
 <2364d0728c3bb4bcc0c13b591f774109a9274a30.camel@redhat.com>
 <bb9fb726-306c-5330-05aa-a86bd1b18097@de.ibm.com>
 <468983fad50a5e74a739f71487f0ea11e8d4dfd1.camel@redhat.com>
 <2dc1df65-1431-3917-40e5-c2b12096e2a7@de.ibm.com>
 <bd9c9b4d99abd20d5420583af5a4954ea1cf4618.camel@redhat.com>
 <e11ba53c-a5fa-0518-2e06-9296897ed529@de.ibm.com>
 <CAJaqyWfJFArAdpOwehTn5ci-frqai+pazGgcn2VvQSebqGRVtg@mail.gmail.com>
 <80520391-d90d-e10d-a107-7a18f2810900@de.ibm.com>
 <dabe59fe-e068-5935-f49e-bc1da3d8471a@de.ibm.com>
 <35dca16b9a85eb203f35d3e55dcaa9d0dae5a922.camel@redhat.com>
 <3144806d-436e-86a1-2e29-74f7027f7f0b@de.ibm.com>
 <8e226821a8878f53585d967b8af547526d84c73e.camel@redhat.com>
 <1ee3a272-e391-e2e8-9cbb-5d3e2d40bec2@de.ibm.com>
 <d093c51e5af2e86c1c7af0b2ee469157e92d8366.camel@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Fri, 27 Mar 2020 16:46:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <d093c51e5af2e86c1c7af0b2ee469157e92d8366.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20032715-4275-0000-0000-000003B479C3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032715-4276-0000-0000-000038C9C189
Message-Id: <fcefde19-38aa-9f62-0b9a-d657de8a0cce@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-27_05:2020-03-27,2020-03-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 impostorscore=0 mlxlogscore=999
 suspectscore=2 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270137
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 27.03.20 12:08, Eugenio Pérez wrote:
> Hi Christian.
> 
> Sorry for the late response. Could we try this one over eccb852f1fe6bede630e2e4f1a121a81e34354ab, and see if you still
> can reproduce the bug?

To much time has passed and too many things have changed on that system.
I have trouble reproducing this with either
eccb852f1fe6bede630e2e4f1a121a81e34354ab or 52c36ce7f334.
I will try to reproduce this again :-/

> 
> Apart from that, could you print me the backtrace when qemu calls vhost_kernel_set_vring_base and
> vhost_kernel_get_vring_base functions?
> 
> Thank you very much!
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index e158159671fa..a1a4239512bb 100644
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
> @@ -1712,6 +1725,9 @@ static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
>  	case VHOST_NET_SET_BACKEND:
>  		if (copy_from_user(&backend, argp, sizeof backend))
>  			return -EFAULT;
> +		pr_debug("VHOST_NET_SET_BACKEND [b.index=%u][b.fd=%d]",
> +			 backend.index, backend.fd);
> +		dump_stack();
>  		return vhost_net_set_backend(n, backend.index, backend.fd);
>  	case VHOST_GET_FEATURES:
>  		features = VHOST_NET_FEATURES;
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index b5a51b1f2e79..9dd0bcae0b22 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -372,6 +372,11 @@ static int vhost_worker(void *data)
>  	return 0;
>  }
>  
> +static int vhost_vq_num_batch_descs(struct vhost_virtqueue *vq)
> +{
> +	return vq->max_descs - UIO_MAXIOV;
> +}
> +
>  static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
>  {
>  	kfree(vq->descs);
> @@ -394,7 +399,9 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
>  	for (i = 0; i < dev->nvqs; ++i) {
>  		vq = dev->vqs[i];
>  		vq->max_descs = dev->iov_limit;
> -		vq->batch_descs = dev->iov_limit - UIO_MAXIOV;
> +		if (vhost_vq_num_batch_descs(vq) < 0) {
> +			return -EINVAL;
> +		}
>  		vq->descs = kmalloc_array(vq->max_descs,
>  					  sizeof(*vq->descs),
>  					  GFP_KERNEL);
> @@ -1642,15 +1649,27 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
>  			r = -EINVAL;
>  			break;
>  		}
> +
> +		pr_debug(
> +			"VHOST_SET_VRING_BASE [vq=%p][s.index=%u][s.num=%u][vq->avail_idx=%d][vq->last_avail_idx=%d][vq-
>> ndescs=%d][vq->first_desc=%d]",
> +			vq, s.index, s.num, vq->avail_idx, vq->last_avail_idx,
> +			vq->ndescs, vq->first_desc);
> +		dump_stack();
>  		vq->last_avail_idx = s.num;
>  		/* Forget the cached index value. */
>  		vq->avail_idx = vq->last_avail_idx;
> +		vq->ndescs = vq->first_desc = 0;
>  		break;
>  	case VHOST_GET_VRING_BASE:
>  		s.index = idx;
>  		s.num = vq->last_avail_idx;
>  		if (copy_to_user(argp, &s, sizeof s))
>  			r = -EFAULT;
> +		pr_debug(
> +			"VHOST_GET_VRING_BASE [vq=%p][s.index=%u][s.num=%u][vq->avail_idx=%d][vq->last_avail_idx=%d][vq-
>> ndescs=%d][vq->first_desc=%d]",
> +			vq, s.index, s.num, vq->avail_idx, vq->last_avail_idx,
> +			vq->ndescs, vq->first_desc);
> +		dump_stack();
>  		break;
>  	case VHOST_SET_VRING_KICK:
>  		if (copy_from_user(&f, argp, sizeof f)) {
> @@ -2239,8 +2258,8 @@ static int fetch_buf(struct vhost_virtqueue *vq)
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
> @@ -2316,6 +2335,9 @@ static int fetch_buf(struct vhost_virtqueue *vq)
>  	BUG_ON(!(vq->used_flags & VRING_USED_F_NO_NOTIFY));
>  
>  	/* On success, increment avail index. */
> +	pr_debug(
> +		"[vq=%p][vq->last_avail_idx=%u][vq->avail_idx=%u][vq->ndescs=%d][vq->first_desc=%d]",
> +		vq, vq->last_avail_idx, vq->avail_idx, vq->ndescs, vq->first_desc);
>  	vq->last_avail_idx++;
>  
>  	return 0;
> @@ -2333,7 +2355,7 @@ static int fetch_descs(struct vhost_virtqueue *vq)
>  	if (vq->ndescs)
>  		return 0;
>  
> -	while (!ret && vq->ndescs <= vq->batch_descs)
> +	while (!ret && vq->ndescs <= vhost_vq_num_batch_descs(vq))
>  		ret = fetch_buf(vq);
>  
>  	return vq->ndescs ? 0 : ret;
> @@ -2432,6 +2454,9 @@ EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
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
> index 661088ae6dc7..e648b9b997d4 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -102,7 +102,6 @@ struct vhost_virtqueue {
>  	int ndescs;
>  	int first_desc;
>  	int max_descs;
> -	int batch_descs;
>  
>  	const struct vhost_umem_node *meta_iotlb[VHOST_NUM_ADDRS];
>  	struct file *kick;
> 


Return-Path: <kvm+bounces-5726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 259368257B0
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 17:07:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB4C92843E6
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 16:07:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E21202F50A;
	Fri,  5 Jan 2024 16:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m5xi20N7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227622E828;
	Fri,  5 Jan 2024 16:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1d427518d52so5169715ad.0;
        Fri, 05 Jan 2024 08:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704470793; x=1705075593; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=V4sL4eVhA4uzhcU12JGTBN6o5Vi9zu5IXlvUCuaFH2U=;
        b=m5xi20N7pj+YgzEcNptlgxDwpHXPxIOTjEWIJ2zCJXV5yIjmlsYhxShxemknAc5O2F
         RUXTcBqfCb6L110br0bqt1tUZIZoHm1cbrnBnPGzcOhEnDPoEzdLfP52xSfPyXs1Uakm
         x/ONacywLxHqRhu7IhH4nm4gDI0rAtbgPX7ZpdYjB99+Tl/fj2eFkGAJNGWcK5M10bkk
         sa03qHL9Id2C2HcHwB+DurbaLz5zuUhJAtCTPJ/fg6PNuCuebOcSupwj4I/52LI7SMDl
         iI1bjhJrL6R/6TCCFEr4SgnBbLc/hOVJa3GliGwa8JEyUe30icQGEer+zLOUUvIL6xlU
         jgEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704470793; x=1705075593;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V4sL4eVhA4uzhcU12JGTBN6o5Vi9zu5IXlvUCuaFH2U=;
        b=j9QOU+XXDmzlazjt5aLZ6GJIshW4C8s+ZiRQrLYKWAMIvzHdOlq6e1HHRz3z/UQ8Vp
         0RkcsWT4lcxg460Cq0Qu3EVi1UN2R5+UtH9Z29cOKguL0M7Un/VvRvdPrI/kSkAXgQ2+
         ThQr+nqsBOYRPG3rv1oWUuyQNsyY5Cnw3Q+vaj8iWAN8ckOqsECkz0FFpAeNMxgT4FS0
         qYO1BYvWdO+HW17B6k/KrAYTxpwbYj9EjfM+DJoT3YNZx20K3rvJc0gh9KVxBK+vwLfP
         ZyHEkiBFkh0y3jpZTVfXT65/vBJKQMjEGUCzrkIbAXU3jSpclLMr96/oN2otsj6N+1m8
         xJIA==
X-Gm-Message-State: AOJu0YwwQm9CDyJR7ikPlG8s5yQvhUgsAgn7/p/06UfctBhw6KpIte8o
	TN9hop9Q+htELwCBMS/8aZQ=
X-Google-Smtp-Source: AGHT+IFId1NQA5s8Q24G3jnvjMhSA6FtovxGHk+nOJVjnxKKfOUra8OceLYKtNzdfMDhrRvyMbCuxg==
X-Received: by 2002:a17:903:2347:b0:1d4:8ea3:8de3 with SMTP id c7-20020a170903234700b001d48ea38de3mr3378224plh.7.1704470793318;
        Fri, 05 Jan 2024 08:06:33 -0800 (PST)
Received: from ?IPv6:2605:59c8:448:b800:82ee:73ff:fe41:9a02? ([2605:59c8:448:b800:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id h3-20020a170902704300b001d3e9937d92sm1568337plt.51.2024.01.05.08.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jan 2024 08:06:32 -0800 (PST)
Message-ID: <1a66f99173de36e1ae639569582feaf76202361d.camel@gmail.com>
Subject: Re: [PATCH net-next 4/6] vhost/net: remove
 vhost_net_page_frag_refill()
From: Alexander H Duyck <alexander.duyck@gmail.com>
To: Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
 kuba@kernel.org,  pabeni@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Jason Wang
 <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Alexei
 Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend
 <john.fastabend@gmail.com>,  kvm@vger.kernel.org,
 virtualization@lists.linux.dev, bpf@vger.kernel.org
Date: Fri, 05 Jan 2024 08:06:31 -0800
In-Reply-To: <20240103095650.25769-5-linyunsheng@huawei.com>
References: <20240103095650.25769-1-linyunsheng@huawei.com>
	 <20240103095650.25769-5-linyunsheng@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-01-03 at 17:56 +0800, Yunsheng Lin wrote:
> The page frag in vhost_net_page_frag_refill() uses the
> 'struct page_frag' from skb_page_frag_refill(), but it's
> implementation is similar to page_frag_alloc_align() now.
>=20
> This patch removes vhost_net_page_frag_refill() by using
> 'struct page_frag_cache' instead of 'struct page_frag',
> and allocating frag using page_frag_alloc_align().
>=20
> The added benefit is that not only unifying the page frag
> implementation a little, but also having about 0.5% performance
> boost testing by using the vhost_net_test introduced in the
> last patch.
>=20
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vhost/net.c | 93 ++++++++++++++-------------------------------
>  1 file changed, 29 insertions(+), 64 deletions(-)
>=20
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index e574e21cc0ca..805e11d598e4 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -141,10 +141,8 @@ struct vhost_net {
>  	unsigned tx_zcopy_err;
>  	/* Flush in progress. Protected by tx vq lock. */
>  	bool tx_flush;
> -	/* Private page frag */
> -	struct page_frag page_frag;
> -	/* Refcount bias of page frag */
> -	int refcnt_bias;
> +	/* Private page frag cache */
> +	struct page_frag_cache pf_cache;
>  };
> =20
>  static unsigned vhost_net_zcopy_mask __read_mostly;
> @@ -655,41 +653,6 @@ static bool tx_can_batch(struct vhost_virtqueue *vq,=
 size_t total_len)
>  	       !vhost_vq_avail_empty(vq->dev, vq);
>  }
> =20
> -static bool vhost_net_page_frag_refill(struct vhost_net *net, unsigned i=
nt sz,
> -				       struct page_frag *pfrag, gfp_t gfp)
> -{
> -	if (pfrag->page) {
> -		if (pfrag->offset + sz <=3D pfrag->size)
> -			return true;
> -		__page_frag_cache_drain(pfrag->page, net->refcnt_bias);
> -	}
> -
> -	pfrag->offset =3D 0;
> -	net->refcnt_bias =3D 0;
> -	if (SKB_FRAG_PAGE_ORDER) {
> -		/* Avoid direct reclaim but allow kswapd to wake */
> -		pfrag->page =3D alloc_pages((gfp & ~__GFP_DIRECT_RECLAIM) |
> -					  __GFP_COMP | __GFP_NOWARN |
> -					  __GFP_NORETRY | __GFP_NOMEMALLOC,
> -					  SKB_FRAG_PAGE_ORDER);
> -		if (likely(pfrag->page)) {
> -			pfrag->size =3D PAGE_SIZE << SKB_FRAG_PAGE_ORDER;
> -			goto done;
> -		}
> -	}
> -	pfrag->page =3D alloc_page(gfp);
> -	if (likely(pfrag->page)) {
> -		pfrag->size =3D PAGE_SIZE;
> -		goto done;
> -	}
> -	return false;
> -
> -done:
> -	net->refcnt_bias =3D USHRT_MAX;
> -	page_ref_add(pfrag->page, USHRT_MAX - 1);
> -	return true;
> -}
> -
>  #define VHOST_NET_RX_PAD (NET_IP_ALIGN + NET_SKB_PAD)
> =20
>  static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
> @@ -699,7 +662,6 @@ static int vhost_net_build_xdp(struct vhost_net_virtq=
ueue *nvq,
>  	struct vhost_net *net =3D container_of(vq->dev, struct vhost_net,
>  					     dev);
>  	struct socket *sock =3D vhost_vq_get_backend(vq);
> -	struct page_frag *alloc_frag =3D &net->page_frag;
>  	struct virtio_net_hdr *gso;
>  	struct xdp_buff *xdp =3D &nvq->xdp[nvq->batched_xdp];
>  	struct tun_xdp_hdr *hdr;
> @@ -710,6 +672,7 @@ static int vhost_net_build_xdp(struct vhost_net_virtq=
ueue *nvq,
>  	int sock_hlen =3D nvq->sock_hlen;
>  	void *buf;
>  	int copied;
> +	int ret;
> =20
>  	if (unlikely(len < nvq->sock_hlen))
>  		return -EFAULT;
> @@ -719,18 +682,17 @@ static int vhost_net_build_xdp(struct vhost_net_vir=
tqueue *nvq,
>  		return -ENOSPC;
> =20
>  	buflen +=3D SKB_DATA_ALIGN(len + pad);
> -	alloc_frag->offset =3D ALIGN((u64)alloc_frag->offset, SMP_CACHE_BYTES);
> -	if (unlikely(!vhost_net_page_frag_refill(net, buflen,
> -						 alloc_frag, GFP_KERNEL)))
> +	buf =3D page_frag_alloc_align(&net->pf_cache, buflen, GFP_KERNEL,
> +				    SMP_CACHE_BYTES);

If your changes from patch 1 are just to make it fit into this layout
might I suggest just splitting up page_frag_alloc_align into an inline
that accepts the arguments you have here, and adding
__page_frag_alloc_align which is passed the mask the original function
expected. By doing that you should be able to maintain the same level
of performance and still get most of the code cleanup.

> +	if (unlikely(!buf))
>  		return -ENOMEM;
> =20
> -	buf =3D (char *)page_address(alloc_frag->page) + alloc_frag->offset;
> -	copied =3D copy_page_from_iter(alloc_frag->page,
> -				     alloc_frag->offset +
> -				     offsetof(struct tun_xdp_hdr, gso),
> -				     sock_hlen, from);
> -	if (copied !=3D sock_hlen)
> -		return -EFAULT;
> +	copied =3D copy_from_iter(buf + offsetof(struct tun_xdp_hdr, gso),
> +				sock_hlen, from);
> +	if (copied !=3D sock_hlen) {
> +		ret =3D -EFAULT;
> +		goto err;
> +	}
> =20
>  	hdr =3D buf;
>  	gso =3D &hdr->gso;
> @@ -743,27 +705,30 @@ static int vhost_net_build_xdp(struct vhost_net_vir=
tqueue *nvq,
>  			       vhost16_to_cpu(vq, gso->csum_start) +
>  			       vhost16_to_cpu(vq, gso->csum_offset) + 2);
> =20
> -		if (vhost16_to_cpu(vq, gso->hdr_len) > len)
> -			return -EINVAL;
> +		if (vhost16_to_cpu(vq, gso->hdr_len) > len) {
> +			ret =3D -EINVAL;
> +			goto err;
> +		}
>  	}
> =20
>  	len -=3D sock_hlen;
> -	copied =3D copy_page_from_iter(alloc_frag->page,
> -				     alloc_frag->offset + pad,
> -				     len, from);
> -	if (copied !=3D len)
> -		return -EFAULT;
> +	copied =3D copy_from_iter(buf + pad, len, from);
> +	if (copied !=3D len) {
> +		ret =3D -EFAULT;
> +		goto err;
> +	}
> =20
>  	xdp_init_buff(xdp, buflen, NULL);
>  	xdp_prepare_buff(xdp, buf, pad, len, true);
>  	hdr->buflen =3D buflen;
> =20
> -	--net->refcnt_bias;
> -	alloc_frag->offset +=3D buflen;
> -
>  	++nvq->batched_xdp;
> =20
>  	return 0;
> +
> +err:
> +	page_frag_free(buf);
> +	return ret;
>  }
> =20
>  static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
> @@ -1353,8 +1318,7 @@ static int vhost_net_open(struct inode *inode, stru=
ct file *f)
>  			vqs[VHOST_NET_VQ_RX]);
> =20
>  	f->private_data =3D n;
> -	n->page_frag.page =3D NULL;
> -	n->refcnt_bias =3D 0;
> +	n->pf_cache.va =3D NULL;
> =20
>  	return 0;
>  }
> @@ -1422,8 +1386,9 @@ static int vhost_net_release(struct inode *inode, s=
truct file *f)
>  	kfree(n->vqs[VHOST_NET_VQ_RX].rxq.queue);
>  	kfree(n->vqs[VHOST_NET_VQ_TX].xdp);
>  	kfree(n->dev.vqs);
> -	if (n->page_frag.page)
> -		__page_frag_cache_drain(n->page_frag.page, n->refcnt_bias);
> +	if (n->pf_cache.va)
> +		__page_frag_cache_drain(virt_to_head_page(n->pf_cache.va),
> +					n->pf_cache.pagecnt_bias);
>  	kvfree(n);
>  	return 0;
>  }

I would recommend reordering this patch with patch 5. Then you could
remove the block that is setting "n->pf_cache.va =3D NULL" above and just
make use of page_frag_cache_drain in the lower block which would also
return the va to NULL.


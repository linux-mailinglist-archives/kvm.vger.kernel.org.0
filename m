Return-Path: <kvm+bounces-5097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B5B481BCE8
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 18:20:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA27A1F2665C
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 17:20:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8C2D64AA9;
	Thu, 21 Dec 2023 17:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="egVSt6kO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6081359928;
	Thu, 21 Dec 2023 17:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-59432ba7755so216438eaf.3;
        Thu, 21 Dec 2023 09:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703179120; x=1703783920; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eZJK1ZsYu8lcu4aUvbhHjEW8j7Hj9d6E8P9M80KwJ5E=;
        b=egVSt6kOYoHsK8A/qV0GOC0e9jVO9P53qw9IFJTWkwbiZf8dXudGT8cc0uQLteeOFU
         i8Mt5TZTzRKqGo7PhcIW0GlTSOZ58aKZMXakUavmw+dO9is4SuuHYqKDhwanaYhKapIF
         /cogZd1BBtboYftcoEnHj+7G/WKpUr7FwPo8j659GwBSHPZLe4y/eTZflpWuK/GF8lQ3
         zfSndwvjZRIIXIcY7sCNEFCXI9PvJ7fTU2PZpk2lRItnTi2mVn3aUpDkzE/BEGkXZG49
         CQ5kiOd5jN7q7Y6chJJCdLY0vPaEn1MldpnrTJxJk8trM4Uv1pMvFoMAfp/ucC+ct6Jb
         xwvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703179120; x=1703783920;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eZJK1ZsYu8lcu4aUvbhHjEW8j7Hj9d6E8P9M80KwJ5E=;
        b=QwXLG9VcncCguCWDq/Uk+kMRB37gMKMPALz7YQvy8vpcywC3WC/kYIifiRFTiRxzc1
         94RF/vDooIMkD8ZwhuerIOK5rMrZFHDrvOUFYcfgNMugHdjyEo5KcE5NympnQG36cG2N
         JhAEZVjrRzCREPkH3c84PJuCGSUK2swRt3GhFDZZ2kSmFkRm9eaBU2hM+zo9iM4+8GjV
         sKK20RDb8u6sTMFHSLu9vx33x15o2eTRVV82vtUXMfUf+KFiejOp5RUHuK2Ei4B3y6E+
         jNqd+l7CezlThZBvcJBqZFFl+Ic/7S4UAuhGmjF6F1/cZXmZ+AZkFYXCSp0s+vjR/EkF
         6qNw==
X-Gm-Message-State: AOJu0YzJZy+YOhHMcPz/piEWtPI+QMWFK/jjXHEaAhcJ7wD03bxtRWep
	V/x8SlU/KsiwQ63TfXi7E3g=
X-Google-Smtp-Source: AGHT+IE4E3sfP25iuqR7wgvb7clhWYlbJ7fGaPbe+9gAsGXKEubVmCvRkF2eKYi9xjBMQ/Xlf90flg==
X-Received: by 2002:a05:6358:7215:b0:173:a62:a523 with SMTP id h21-20020a056358721500b001730a62a523mr89887rwa.15.1703179120315;
        Thu, 21 Dec 2023 09:18:40 -0800 (PST)
Received: from localhost (114.66.194.35.bc.googleusercontent.com. [35.194.66.114])
        by smtp.gmail.com with ESMTPSA id v13-20020a0cf90d000000b0067f19f17629sm756639qvn.82.2023.12.21.09.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 09:18:40 -0800 (PST)
Date: Thu, 21 Dec 2023 12:18:39 -0500
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Mina Almasry <almasrymina@google.com>, 
 linux-kernel@vger.kernel.org, 
 netdev@vger.kernel.org, 
 kvm@vger.kernel.org, 
 virtualization@lists.linux.dev
Cc: Mina Almasry <almasrymina@google.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, 
 Stefan Hajnoczi <stefanha@redhat.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, 
 David Howells <dhowells@redhat.com>, 
 Jason Gunthorpe <jgg@nvidia.com>, 
 =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, 
 Shakeel Butt <shakeelb@google.com>, 
 Yunsheng Lin <linyunsheng@huawei.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Message-ID: <6584736fd141e_82de3294c4@willemb.c.googlers.com.notmuch>
In-Reply-To: <20231220214505.2303297-4-almasrymina@google.com>
References: <20231220214505.2303297-1-almasrymina@google.com>
 <20231220214505.2303297-4-almasrymina@google.com>
Subject: Re: [PATCH net-next v3 3/3] net: add netmem_ref to skb_frag_t
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Mina Almasry wrote:
> Use netmem_ref instead of page in skb_frag_t. Currently netmem_ref
> is always a struct page underneath, but the abstraction allows efforts
> to add support for skb frags not backed by pages.
> 
> There is unfortunately 1 instance where the skb_frag_t is assumed to be
> a bio_vec in kcm. For this case, add a debug assert that the skb frag is
> indeed backed by a page, and do a cast.
> 
> Add skb[_frag]_fill_netmem_*() and skb_add_rx_frag_netmem() helpers so
> that the API can be used to create netmem skbs.
> 
> Signed-off-by: Mina Almasry <almasrymina@google.com>
> 
> ---
> 
> v3;
> - Renamed the fields in skb_frag_t.
> 
> v2:
> - Add skb frag filling helpers.
> 
> ---
>  include/linux/skbuff.h | 92 +++++++++++++++++++++++++++++-------------
>  net/core/skbuff.c      | 22 +++++++---
>  net/kcm/kcmsock.c      | 10 ++++-
>  3 files changed, 89 insertions(+), 35 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 7ce38874dbd1..729c95e97be1 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -37,6 +37,7 @@
>  #endif
>  #include <net/net_debug.h>
>  #include <net/dropreason-core.h>
> +#include <net/netmem.h>
>  
>  /**
>   * DOC: skb checksums
> @@ -359,7 +360,11 @@ extern int sysctl_max_skb_frags;
>   */
>  #define GSO_BY_FRAGS	0xFFFF
>  
> -typedef struct bio_vec skb_frag_t;
> +typedef struct skb_frag {
> +	netmem_ref netmem;
> +	unsigned int len;
> +	unsigned int offset;
> +} skb_frag_t;
>  
>  /**
>   * skb_frag_size() - Returns the size of a skb fragment
> @@ -367,7 +372,7 @@ typedef struct bio_vec skb_frag_t;
>   */
>  static inline unsigned int skb_frag_size(const skb_frag_t *frag)
>  {
> -	return frag->bv_len;
> +	return frag->len;
>  }
>  
>  /**
> @@ -377,7 +382,7 @@ static inline unsigned int skb_frag_size(const skb_frag_t *frag)
>   */
>  static inline void skb_frag_size_set(skb_frag_t *frag, unsigned int size)
>  {
> -	frag->bv_len = size;
> +	frag->len = size;
>  }
>  
>  /**
> @@ -387,7 +392,7 @@ static inline void skb_frag_size_set(skb_frag_t *frag, unsigned int size)
>   */
>  static inline void skb_frag_size_add(skb_frag_t *frag, int delta)
>  {
> -	frag->bv_len += delta;
> +	frag->len += delta;
>  }
>  
>  /**
> @@ -397,7 +402,7 @@ static inline void skb_frag_size_add(skb_frag_t *frag, int delta)
>   */
>  static inline void skb_frag_size_sub(skb_frag_t *frag, int delta)
>  {
> -	frag->bv_len -= delta;
> +	frag->len -= delta;
>  }
>  
>  /**
> @@ -417,7 +422,7 @@ static inline bool skb_frag_must_loop(struct page *p)
>   *	skb_frag_foreach_page - loop over pages in a fragment
>   *
>   *	@f:		skb frag to operate on
> - *	@f_off:		offset from start of f->bv_page
> + *	@f_off:		offset from start of f->netmem
>   *	@f_len:		length from f_off to loop over
>   *	@p:		(temp var) current page
>   *	@p_off:		(temp var) offset from start of current page,
> @@ -2431,22 +2436,37 @@ static inline unsigned int skb_pagelen(const struct sk_buff *skb)
>  	return skb_headlen(skb) + __skb_pagelen(skb);
>  }
>  
> +static inline void skb_frag_fill_netmem_desc(skb_frag_t *frag,
> +					     netmem_ref netmem, int off,
> +					     int size)
> +{
> +	frag->netmem = netmem;
> +	frag->offset = off;
> +	skb_frag_size_set(frag, size);
> +}
> +
>  static inline void skb_frag_fill_page_desc(skb_frag_t *frag,
>  					   struct page *page,
>  					   int off, int size)
>  {
> -	frag->bv_page = page;
> -	frag->bv_offset = off;
> -	skb_frag_size_set(frag, size);
> +	skb_frag_fill_netmem_desc(frag, page_to_netmem(page), off, size);
> +}
> +
> +static inline void __skb_fill_netmem_desc_noacc(struct skb_shared_info *shinfo,
> +						int i, netmem_ref netmem,
> +						int off, int size)
> +{
> +	skb_frag_t *frag = &shinfo->frags[i];
> +
> +	skb_frag_fill_netmem_desc(frag, netmem, off, size);
>  }
>  
>  static inline void __skb_fill_page_desc_noacc(struct skb_shared_info *shinfo,
>  					      int i, struct page *page,
>  					      int off, int size)
>  {
> -	skb_frag_t *frag = &shinfo->frags[i];
> -
> -	skb_frag_fill_page_desc(frag, page, off, size);
> +	__skb_fill_netmem_desc_noacc(shinfo, i, page_to_netmem(page), off,
> +				     size);
>  }
>  
>  /**
> @@ -2462,10 +2482,10 @@ static inline void skb_len_add(struct sk_buff *skb, int delta)
>  }
>  
>  /**
> - * __skb_fill_page_desc - initialise a paged fragment in an skb
> + * __skb_fill_netmem_desc - initialise a fragment in an skb
>   * @skb: buffer containing fragment to be initialised
> - * @i: paged fragment index to initialise
> - * @page: the page to use for this fragment
> + * @i: fragment index to initialise
> + * @netmem: the netmem to use for this fragment
>   * @off: the offset to the data with @page
>   * @size: the length of the data
>   *
> @@ -2474,10 +2494,13 @@ static inline void skb_len_add(struct sk_buff *skb, int delta)
>   *
>   * Does not take any additional reference on the fragment.
>   */
> -static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
> -					struct page *page, int off, int size)
> +static inline void __skb_fill_netmem_desc(struct sk_buff *skb, int i,
> +					  netmem_ref netmem, int off,
> +					  int size)
>  {
> -	__skb_fill_page_desc_noacc(skb_shinfo(skb), i, page, off, size);
> +	struct page *page = netmem_to_page(netmem);
> +
> +	__skb_fill_netmem_desc_noacc(skb_shinfo(skb), i, netmem, off, size);
>  
>  	/* Propagate page pfmemalloc to the skb if we can. The problem is
>  	 * that not all callers have unique ownership of the page but rely
> @@ -2485,7 +2508,21 @@ static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
>  	 */
>  	page = compound_head(page);
>  	if (page_is_pfmemalloc(page))
> -		skb->pfmemalloc	= true;
> +		skb->pfmemalloc = true;
> +}
> +
> +static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
> +					struct page *page, int off, int size)
> +{
> +	__skb_fill_netmem_desc(skb, i, page_to_netmem(page), off, size);
> +}
> +
> +static inline void skb_fill_netmem_desc(struct sk_buff *skb, int i,
> +					netmem_ref netmem, int off,
> +					int size)
> +{
> +	__skb_fill_netmem_desc(skb, i, netmem, off, size);
> +	skb_shinfo(skb)->nr_frags = i + 1;
>  }
>  
>  /**
> @@ -2505,8 +2542,7 @@ static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
>  static inline void skb_fill_page_desc(struct sk_buff *skb, int i,
>  				      struct page *page, int off, int size)
>  {
> -	__skb_fill_page_desc(skb, i, page, off, size);
> -	skb_shinfo(skb)->nr_frags = i + 1;
> +	skb_fill_netmem_desc(skb, i, page_to_netmem(page), off, size);
>  }
>  
>  /**
> @@ -2532,6 +2568,8 @@ static inline void skb_fill_page_desc_noacc(struct sk_buff *skb, int i,
>  
>  void skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page, int off,
>  		     int size, unsigned int truesize);
> +void skb_add_rx_frag_netmem(struct sk_buff *skb, int i, netmem_ref netmem,
> +			    int off, int size, unsigned int truesize);
>  
>  void skb_coalesce_rx_frag(struct sk_buff *skb, int i, int size,
>  			  unsigned int truesize);
> @@ -3380,7 +3418,7 @@ static inline void skb_propagate_pfmemalloc(const struct page *page,
>   */
>  static inline unsigned int skb_frag_off(const skb_frag_t *frag)
>  {
> -	return frag->bv_offset;
> +	return frag->offset;
>  }
>  
>  /**
> @@ -3390,7 +3428,7 @@ static inline unsigned int skb_frag_off(const skb_frag_t *frag)
>   */
>  static inline void skb_frag_off_add(skb_frag_t *frag, int delta)
>  {
> -	frag->bv_offset += delta;
> +	frag->offset += delta;
>  }
>  
>  /**
> @@ -3400,7 +3438,7 @@ static inline void skb_frag_off_add(skb_frag_t *frag, int delta)
>   */
>  static inline void skb_frag_off_set(skb_frag_t *frag, unsigned int offset)
>  {
> -	frag->bv_offset = offset;
> +	frag->offset = offset;
>  }
>  
>  /**
> @@ -3411,7 +3449,7 @@ static inline void skb_frag_off_set(skb_frag_t *frag, unsigned int offset)
>  static inline void skb_frag_off_copy(skb_frag_t *fragto,
>  				     const skb_frag_t *fragfrom)
>  {
> -	fragto->bv_offset = fragfrom->bv_offset;
> +	fragto->offset = fragfrom->offset;
>  }
>  
>  /**
> @@ -3422,7 +3460,7 @@ static inline void skb_frag_off_copy(skb_frag_t *fragto,
>   */
>  static inline struct page *skb_frag_page(const skb_frag_t *frag)
>  {
> -	return frag->bv_page;
> +	return netmem_to_page(frag->netmem);
>  }
>  
>  /**
> @@ -3526,7 +3564,7 @@ static inline void *skb_frag_address_safe(const skb_frag_t *frag)
>  static inline void skb_frag_page_copy(skb_frag_t *fragto,
>  				      const skb_frag_t *fragfrom)
>  {
> -	fragto->bv_page = fragfrom->bv_page;
> +	fragto->netmem = fragfrom->netmem;
>  }
>  
>  bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t prio);
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 4d4b11b0a83d..8b55e927bbe9 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -845,16 +845,24 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
>  }
>  EXPORT_SYMBOL(__napi_alloc_skb);
>  
> -void skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page, int off,
> -		     int size, unsigned int truesize)
> +void skb_add_rx_frag_netmem(struct sk_buff *skb, int i, netmem_ref netmem,
> +			    int off, int size, unsigned int truesize)
>  {
>  	DEBUG_NET_WARN_ON_ONCE(size > truesize);
>  
> -	skb_fill_page_desc(skb, i, page, off, size);
> +	skb_fill_netmem_desc(skb, i, netmem, off, size);
>  	skb->len += size;
>  	skb->data_len += size;
>  	skb->truesize += truesize;
>  }
> +EXPORT_SYMBOL(skb_add_rx_frag_netmem);
> +
> +void skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page, int off,
> +		     int size, unsigned int truesize)
> +{
> +	skb_add_rx_frag_netmem(skb, i, page_to_netmem(page), off, size,
> +			       truesize);
> +}
>  EXPORT_SYMBOL(skb_add_rx_frag);
>  
>  void skb_coalesce_rx_frag(struct sk_buff *skb, int i, int size,
> @@ -1904,10 +1912,11 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mask)
>  
>  	/* skb frags point to kernel buffers */
>  	for (i = 0; i < new_frags - 1; i++) {
> -		__skb_fill_page_desc(skb, i, head, 0, psize);
> +		__skb_fill_netmem_desc(skb, i, page_to_netmem(head), 0, psize);
>  		head = (struct page *)page_private(head);
>  	}
> -	__skb_fill_page_desc(skb, new_frags - 1, head, 0, d_off);
> +	__skb_fill_netmem_desc(skb, new_frags - 1, page_to_netmem(head), 0,
> +			       d_off);
>  	skb_shinfo(skb)->nr_frags = new_frags;
>  
>  release:
> @@ -3645,7 +3654,8 @@ skb_zerocopy(struct sk_buff *to, struct sk_buff *from, int len, int hlen)
>  		if (plen) {
>  			page = virt_to_head_page(from->head);
>  			offset = from->data - (unsigned char *)page_address(page);
> -			__skb_fill_page_desc(to, 0, page, offset, plen);
> +			__skb_fill_netmem_desc(to, 0, page_to_netmem(page),
> +					       offset, plen);
>  			get_page(page);
>  			j = 1;
>  			len -= plen;
> diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
> index 65d1f6755f98..3180a54b2c68 100644
> --- a/net/kcm/kcmsock.c
> +++ b/net/kcm/kcmsock.c
> @@ -636,9 +636,15 @@ static int kcm_write_msgs(struct kcm_sock *kcm)
>  		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
>  			msize += skb_shinfo(skb)->frags[i].bv_len;
>  
> +		/* The cast to struct bio_vec* here assumes the frags are
> +		 * struct page based. WARN if there is no page in this skb.
> +		 */
> +		DEBUG_NET_WARN_ON_ONCE(
> +			!skb_frag_page(&skb_shinfo(skb)->frags[0]));
> +

It would be unsafe to continue the operation in this case. Even though
we should never get here, test and exit in all codepaths, similar to
other test above?

                if (WARN_ON(!skb_shinfo(skb)->nr_frags)) {
                        ret = -EINVAL;
                        goto out;
                }

>  		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE,
> -			      skb_shinfo(skb)->frags, skb_shinfo(skb)->nr_frags,
> -			      msize);
> +			      (const struct bio_vec *)skb_shinfo(skb)->frags,
> +			      skb_shinfo(skb)->nr_frags, msize);
>  		iov_iter_advance(&msg.msg_iter, txm->frag_offset);
>  
>  		do {
> -- 
> 2.43.0.472.g3155946c3a-goog
> 




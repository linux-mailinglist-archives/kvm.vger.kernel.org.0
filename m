Return-Path: <kvm+bounces-4754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8574E817BCB
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 21:22:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 12B0E1F243DD
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 20:22:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BFBB74087;
	Mon, 18 Dec 2023 20:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oljQn0xn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF877204D
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 20:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a2358a75b69so306794966b.1
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 12:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702930943; x=1703535743; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hBnDjqR8ev8eEOR/Wb/mNlLBPLyySVDmi6fwcpUC1aE=;
        b=oljQn0xnbHUycvaF+zVaIvUUqRi2ivtzBgVGbZpm+FtVvn3zwZrHLFRwK+OIQbHkMG
         UQUFTeylQBFUE19DpGZcTU+1xWmbzEFJLwbyZaJt/TqL7j/iFWHiajeNKzEUBF9Gpn5y
         PPB9yn18Aa4nHyv8G2ifU6MZevfnDTCq5hXvdJJ1LA8lO/ClkJvRFruGPIR5BnpC9Kpr
         8EQH+DwX3Goyqx0M7Ld4P0r+H5SdNUJWICs8V3j6HMXvTdAwHrq6a/2Zafq3zzU4BaRr
         VRaWO+nLw06R3EQKsWMkNLSQxJcSwtb09f2uHGrkILYZokRiQmSOEuyo0f+pe8GQF0zL
         nEWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702930943; x=1703535743;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hBnDjqR8ev8eEOR/Wb/mNlLBPLyySVDmi6fwcpUC1aE=;
        b=sGHm2FrhnrZLPUMNErmLbgbcloZE2FxutlCbOkRqbRvTap6Fg4N8kOPq/ORRiLzl1j
         PGywE03vcXF4v29G4URBJcYG4T5J0NAt5X12Vn73dgodWckTitcTfq4J0SyGVbe+SzmZ
         F/OHCwt64H0wPMHG0UoyYo8YR2W33N/hmKW33dXtmt6BPUtZhDPd/WrYnSMAgM9FnXtj
         Nt6ZM4oPcHyv7DzVRbCihCSqt05gOx+Oet+bHhWkuaNf6oczhpjGLl97bmxvRaHAf/lO
         2aLsdPfNYZ8B4PjrW7qe8fc5EWlj2kGk8fSARWTzQEZitsyvVdQwtfeXMOEW1qjdU9GO
         Vzqg==
X-Gm-Message-State: AOJu0Yw+0sPhlcaSk4C1832or+dE5juXbK2PxWhBfHA3FHjMAwtQzUEl
	+3zz3ldrYF+rrbz3qUwIkv4019o4gcCiC1zXoNvy7A==
X-Google-Smtp-Source: AGHT+IGOSn3yMNFErnneEacsS5/2W9PoiIzpIb6xAZzuXfnZ1mobdrawzlxvMuTKK0N9yjEitoiX5+htjybXySy6Z+s=
X-Received: by 2002:a17:906:1b0e:b0:a23:5893:1ac8 with SMTP id
 o14-20020a1709061b0e00b00a2358931ac8mr2231828ejg.27.1702930942877; Mon, 18
 Dec 2023 12:22:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231217080913.2025973-1-almasrymina@google.com>
 <20231217080913.2025973-4-almasrymina@google.com> <1195676f-59a4-40d8-b459-d2668eb8c5fe@huawei.com>
In-Reply-To: <1195676f-59a4-40d8-b459-d2668eb8c5fe@huawei.com>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 18 Dec 2023 12:22:11 -0800
Message-ID: <CAHS8izPJOrv_4tRRVP=g_m-02d=QKWQCsvO9UTxgGFtoDxFfuw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/3] net: add netmem_t to skb_frag_t
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Shakeel Butt <shakeelb@google.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 18, 2023 at 4:39=E2=80=AFAM Yunsheng Lin <linyunsheng@huawei.co=
m> wrote:
>
> On 2023/12/17 16:09, Mina Almasry wrote:
> > Use netmem_t instead of page directly in skb_frag_t. Currently netmem_t
> > is always a struct page underneath, but the abstraction allows efforts
> > to add support for skb frags not backed by pages.
> >
> > There is unfortunately 1 instance where the skb_frag_t is assumed to be
> > a bio_vec in kcm. For this case, add a debug assert that the skb frag i=
s
> > indeed backed by a page, and do a cast.
> >
> > Add skb[_frag]_fill_netmem_*() and skb_add_rx_frag_netmem() helpers so
> > that the API can be used to create netmem skbs.
> >
> > Signed-off-by: Mina Almasry <almasrymina@google.com>
> >
>
> ...
>
> >
> > -typedef struct bio_vec skb_frag_t;
> > +typedef struct skb_frag {
> > +     struct netmem *bv_page;
>
> bv_page -> bv_netmem?
>

bv_page, bv_len & bv_offset all are misnomers after this change
indeed, because bv_ refers to bio_vec and skb_frag_t is no longer a
bio_vec. However I'm hoping renaming everything can be done in a
separate series. Maybe I'll just apply the bv_page -> bv_netmem
change, that doesn't seem to be much code churn and it makes things
much less confusing.

> > +     unsigned int bv_len;
> > +     unsigned int bv_offset;
> > +} skb_frag_t;
> >
> >  /**
> >   * skb_frag_size() - Returns the size of a skb fragment
> > @@ -2431,22 +2436,37 @@ static inline unsigned int skb_pagelen(const st=
ruct sk_buff *skb)
> >       return skb_headlen(skb) + __skb_pagelen(skb);
> >  }
> >
>
> ...
>
> >  /**
> > @@ -2462,10 +2482,10 @@ static inline void skb_len_add(struct sk_buff *=
skb, int delta)
> >  }
> >
> >  /**
> > - * __skb_fill_page_desc - initialise a paged fragment in an skb
> > + * __skb_fill_netmem_desc - initialise a paged fragment in an skb
> >   * @skb: buffer containing fragment to be initialised
> >   * @i: paged fragment index to initialise
> > - * @page: the page to use for this fragment
> > + * @netmem: the netmem to use for this fragment
> >   * @off: the offset to the data with @page
> >   * @size: the length of the data
> >   *
> > @@ -2474,10 +2494,13 @@ static inline void skb_len_add(struct sk_buff *=
skb, int delta)
> >   *
> >   * Does not take any additional reference on the fragment.
> >   */
> > -static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
> > -                                     struct page *page, int off, int s=
ize)
> > +static inline void __skb_fill_netmem_desc(struct sk_buff *skb, int i,
> > +                                       struct netmem *netmem, int off,
> > +                                       int size)
> >  {
> > -     __skb_fill_page_desc_noacc(skb_shinfo(skb), i, page, off, size);
> > +     struct page *page =3D netmem_to_page(netmem);
> > +
> > +     __skb_fill_netmem_desc_noacc(skb_shinfo(skb), i, netmem, off, siz=
e);
> >
> >       /* Propagate page pfmemalloc to the skb if we can. The problem is
> >        * that not all callers have unique ownership of the page but rel=
y
> > @@ -2485,7 +2508,21 @@ static inline void __skb_fill_page_desc(struct s=
k_buff *skb, int i,
> >        */
> >       page =3D compound_head(page);
> >       if (page_is_pfmemalloc(page))
> > -             skb->pfmemalloc =3D true;
> > +             skb->pfmemalloc =3D true;
>
> Is it possible to introduce netmem_is_pfmemalloc() and netmem_compound_he=
ad()
> for netmem,

That is exactly the plan, and I added these helpers in the follow up
series which introduces devmem support:

https://patchwork.kernel.org/project/netdevbpf/patch/20231218024024.3516870=
-8-almasrymina@google.com/

> and have some built-time testing to ensure the implementation
> is the same between page_is_pfmemalloc()/compound_head() and
> netmem_is_pfmemalloc()/netmem_compound_head()?

That doesn't seem desirable to me. It's too hacky IMO to duplicate the
implementation details of the MM stack in the net stack and that is
not the implementation you see in the patch that adds these helpers
above.

> So that we can avoid the
> netmem_to_page() as much as possible, especially in the driver.
>

Agreed.

>
> > +}
> > +
> > +static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
> > +                                     struct page *page, int off, int s=
ize)
> > +{
> > +     __skb_fill_netmem_desc(skb, i, page_to_netmem(page), off, size);
> > +}
> > +
>
> ...
>
> >   */
> >  static inline struct page *skb_frag_page(const skb_frag_t *frag)
> >  {
> > -     return frag->bv_page;
> > +     return netmem_to_page(frag->bv_page);
>
> It seems we are not able to have a safe type protection for the above
> function, as the driver may be able to pass a devmem frag as a param here=
,
> and pass the returned page into the mm subsystem, and compiler is not abl=
e
> to catch it when compiling.
>

That depends on the implementation of netmem_to_page(). As I
implemented it in the follow up series, netmem_to_page() always checks
that netmem is actually a page before doing the conversion via
checking the LSB checking. It's of course unacceptable to make an
unconditional cast here. That will get around the type safety as you
point out, and defeat the point. But I'm not doing that.

I can add a comment above netmem_to_page():

/* Returns page* if the netmem is backed by a page, NULL otherwise. Current=
ly
 * netmem can only be backed by a page, so we always return the underlying
 * page.
 */
static inline struct page *netmem_to_page(struct netmem *netmem);

> >  }
> >
> >  /**
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 83af8aaeb893..053d220aa2f2 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -845,16 +845,24 @@ struct sk_buff *__napi_alloc_skb(struct napi_stru=
ct *napi, unsigned int len,
> >  }
> >  EXPORT_SYMBOL(__napi_alloc_skb);
> >
>
> ...
>
> > diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
> > index 65d1f6755f98..5c46db045f4c 100644
> > --- a/net/kcm/kcmsock.c
> > +++ b/net/kcm/kcmsock.c
> > @@ -636,9 +636,15 @@ static int kcm_write_msgs(struct kcm_sock *kcm)
> >               for (i =3D 0; i < skb_shinfo(skb)->nr_frags; i++)
> >                       msize +=3D skb_shinfo(skb)->frags[i].bv_len;
> >
> > +             /* The cast to struct bio_vec* here assumes the frags are
> > +              * struct page based.
> > +              */
> > +             DEBUG_NET_WARN_ON_ONCE(
> > +                     !skb_frag_page(&skb_shinfo(skb)->frags[0]));
>
> It seems skb_frag_page() always return non-NULL in this patch, the above
> checking seems unnecessary?

We're doing a cast below, and the cast is only valid if the frag has a
page underneath. This check makes sure the skb has a page. In the
series that adds devmem support, skb_frag_page() returns NULL as the
frag has no page. Since this patch adds the dangerous cast, I think it
may be reasonable for it to also add the check.

I can add a comment above skb_frag_page() to indicate the intention again:

 * Returns the &struct page associated with @frag. Returns NULL if this fra=
g
 * has no associated page.

But as of this series netmem can only be a page, so I think adding
that information may be premature.

--=20
Thanks,
Mina


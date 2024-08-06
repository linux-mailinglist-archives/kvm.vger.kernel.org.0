Return-Path: <kvm+bounces-23346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E2C6948DD1
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 13:38:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31CBF1C233A1
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 11:37:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68D771C3F16;
	Tue,  6 Aug 2024 11:37:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD4E1C2324;
	Tue,  6 Aug 2024 11:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722944259; cv=none; b=G96AJu1leWBWIvqjbHE8T7Mm4M6TFQRZ7+MBnzABIL8NRgKOlyGPXwBrvQiPLPnWTGb6gMKSZdYU9GW7qX1hlvda1jH1nRr7RN+7NyoprE3VrhOjIJFdn7lsPIV+6nRs7ML6FOtW55oKizJI0DqWsJjFO2ElkV3H7ZL57sGiaCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722944259; c=relaxed/simple;
	bh=1gxwcgZ/sQL7GrYA0U4zcsjJGmDnxtE/DBKVYG5CoxY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=lbz910fI83BING3XDWWVmAGEbbnw70Iy2dPYFhbyx21M9g6utATjNynztbAEMu5gy0bR+3NAShYMjNM26c3H2ydEnAG4+TVqbz2ha/wb0MfiI0w4fKcPxQuUHb9yXGmx5zBxKcY2CLgjSzqjdkxy7N/AfI1l8TzXzVaZfO8Oy+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4WdWQD3tK9zQpC4;
	Tue,  6 Aug 2024 19:33:08 +0800 (CST)
Received: from dggpemf200006.china.huawei.com (unknown [7.185.36.61])
	by mail.maildlp.com (Postfix) with ESMTPS id 28868180102;
	Tue,  6 Aug 2024 19:37:34 +0800 (CST)
Received: from [10.67.120.129] (10.67.120.129) by
 dggpemf200006.china.huawei.com (7.185.36.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 6 Aug 2024 19:37:33 +0800
Message-ID: <ca6be29e-ab53-4673-9624-90d41616a154@huawei.com>
Date: Tue, 6 Aug 2024 19:37:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v12 04/14] mm: page_frag: add '_va' suffix to
 page_frag API
To: Alexander Duyck <alexander.duyck@gmail.com>, Yunsheng Lin
	<yunshenglin0825@gmail.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Subbaraya Sundeep
	<sbhatta@marvell.com>, Jeroen de Borst <jeroendb@google.com>, Praveen
 Kaligineedi <pkaligineedi@google.com>, Shailend Chand <shailend@google.com>,
	Eric Dumazet <edumazet@google.com>, Tony Nguyen <anthony.l.nguyen@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>, Sunil Goutham
	<sgoutham@marvell.com>, Geetha sowjanya <gakula@marvell.com>, hariprasad
	<hkelam@marvell.com>, Felix Fietkau <nbd@nbd.name>, Sean Wang
	<sean.wang@mediatek.com>, Mark Lee <Mark-MC.Lee@mediatek.com>, Lorenzo
 Bianconi <lorenzo@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Keith
 Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig
	<hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni
	<kch@nvidia.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
	<jasowang@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov
	<ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Jesper Dangaard
 Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Andrii
 Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Eduard
 Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>, Yonghong Song
	<yonghong.song@linux.dev>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev
	<sdf@fomichev.me>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, Neil
 Brown <neilb@suse.de>, Olga Kornievskaia <kolga@netapp.com>, Dai Ngo
	<Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Trond Myklebust
	<trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
	<intel-wired-lan@lists.osuosl.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>, <linux-nvme@lists.infradead.org>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux.dev>,
	<linux-mm@kvack.org>, <bpf@vger.kernel.org>, <linux-afs@lists.infradead.org>,
	<linux-nfs@vger.kernel.org>
References: <20240731124505.2903877-1-linyunsheng@huawei.com>
 <20240731124505.2903877-5-linyunsheng@huawei.com>
 <CAKgT0UcqdeSJdjZ_FfwyCnT927TwOkE4zchHLOkrBEmhGzex9g@mail.gmail.com>
 <22fda86c-d688-42e7-99e8-e2f8fcf1a5ba@huawei.com>
 <CAKgT0UcuGj8wvC87=A+hkarRupfhjGM0BPzLUT2AJc8Ovg_TFg@mail.gmail.com>
 <877efebe-f316-4192-aada-dd2657b74125@huawei.com>
 <CAKgT0UfUkqR2TJQt6cSEdANNxQEOkjGqpPXhaXmrrxB0KwXmEQ@mail.gmail.com>
 <2a29ce61-7136-4b9b-9940-504228b10cba@gmail.com>
 <CAKgT0Uc6yw4u5Tjw1i0cV=C_ph+A5w0b_mtQMXmnBfKN_vvaDA@mail.gmail.com>
Content-Language: en-US
From: Yunsheng Lin <linyunsheng@huawei.com>
In-Reply-To: <CAKgT0Uc6yw4u5Tjw1i0cV=C_ph+A5w0b_mtQMXmnBfKN_vvaDA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemf200006.china.huawei.com (7.185.36.61)

On 2024/8/6 8:52, Alexander Duyck wrote:
> On Sun, Aug 4, 2024 at 10:00 AM Yunsheng Lin <yunshenglin0825@gmail.com> wrote:
>>
>> On 8/3/2024 1:00 AM, Alexander Duyck wrote:
>>
>>>>
>>>>>
>>>>> As far as your API extension and naming maybe you should look like
>>>>> something like bio_vec and borrow the naming from that since that is
>>>>> essentially what you are passing back and forth is essentially that
>>>>> instead of a page frag which is normally a virtual address.
>>>>
>>>> I thought about adding something like bio_vec before, but I am not sure
>>>> what you have in mind is somthing like I considered before?
>>>> Let's say that we reuse bio_vec like something below for the new APIs:
>>>>
>>>> struct bio_vec {
>>>>          struct page     *bv_page;
>>>>          void            *va;
>>>>          unsigned int    bv_len;
>>>>          unsigned int    bv_offset;
>>>> };
>>>
>>> I wasn't suggesting changing the bio_vec. I was suggesting that be
>>> what you pass as a pointer reference instead of the offset. Basically
>>> your use case is mostly just for populating bio_vec style structures
>>> anyway.
>>
>> I wasn't trying/going to reuse/change bio_vec for page_frag, I was just
>> having a hard time coming with a good new name for it.
>> The best one I came up with is pfrag_vec, but I am not sure about the
>> 'vec' as the "vec" portion of the name would suggest, iovec structures
>> tend to come in arrays, mentioned in the below article:
>> https://lwn.net/Articles/625077/
>>
>> Anther one is page_frag, which is currently in use.
>>
>> Or any better one in your mind?
> 
> I was suggesting using bio_vec, not some new structure. The general
> idea is that almost all the values you are using are exposed by that
> structure already in the case of the page based calls you were adding,
> so it makes sense to use what is there rather than reinventing the
> wheel.

Through a quick look, there seems to be at least three structs which have
similar values: struct bio_vec & struct skb_frag & struct page_frag.

As your above agrument about using bio_vec, it seems it is ok to use any
one of them as each one of them seems to have almost all the values we
are using?

Personally, my preference over them: 'struct page_frag' > 'struct skb_frag'
> 'struct bio_vec', as the naming of 'struct page_frag' seems to best match
the page_frag API, 'struct skb_frag' is the second preference because we
mostly need to fill skb frag anyway, and 'struct bio_vec' is the last
preference because it just happen to have almost all the values needed.

Is there any specific reason other than the above "almost all the values you
are using are exposed by that structure already " that you prefer bio_vec?

> 
>>>
>>>> It seems we have the below options for the new API:
>>>>
>>>> option 1, it seems like a better option from API naming point of view, but
>>>> it needs to return a bio_vec pointer to the caller, it seems we need to have
>>>> extra space for the pointer, I am not sure how we can avoid the memory waste
>>>> for sk_page_frag() case in patch 12:
>>>> struct bio_vec *page_frag_alloc_bio(struct page_frag_cache *nc,
>>>>                                      unsigned int fragsz, gfp_t gfp_mask);
>>>>
>>>> option 2, it need both the caller and callee to have a its own local space
>>>> for 'struct bio_vec ', I am not sure if passing the content instead of
>>>> the pointer of a struct through the function returning is the common pattern
>>>> and if it has any performance impact yet:
>>>> struct bio_vec page_frag_alloc_bio(struct page_frag_cache *nc,
>>>>                                     unsigned int fragsz, gfp_t gfp_mask);
>>>>
>>>> option 3, the caller passes the pointer of 'struct bio_vec ' to the callee,
>>>> and page_frag_alloc_bio() fills in the data, I am not sure what is the point
>>>> of indirect using 'struct bio_vec ' instead of passing 'va' & 'fragsz' &
>>>> 'offset' through pointers directly:
>>>> bool page_frag_alloc_bio(struct page_frag_cache *nc,
>>>>                           unsigned int fragsz, gfp_t gfp_mask, struct bio_vec *bio);
>>>>
>>>> If one of the above option is something in your mind? Yes, please be more specific
>>>> about which one is the prefer option, and why it is the prefer option than the one
>>>> introduced in this patchset?
>>>>
>>>> If no, please be more specific what that is in your mind?
>>>
>>> Option 3 is more or less what I had in mind. Basically you would
>>> return an int to indicate any errors and you would be populating a
>>> bio_vec during your allocation. In addition you would use the bio_vec
>>
>> Actually using this new bio_vec style structures does not seem to solve
>> the APIs naming issue this patch is trying to solve as my understanding,
>> as the new struct is only about passing one pointer or multi-pointers
>> from API naming perspective. It is part of the API naming, but not all
>> of it.
> 
> I have no idea what you are talking about. The issue was you were
> splitting things page_frag_alloc_va and page_frag_alloc_pg. Now it
> would be page_frag_alloc and page_frag_alloc_bio or maybe
> page_frag_fill_bio which would better explain what you are doing with
> this function.

There are three types of API as proposed in this patchset instead of
two types of API:
1. page_frag_alloc_va() returns [va].
2. page_frag_alloc_pg() returns [page, offset].
3. page_frag_alloc() returns [va] & [page, offset].

You seemed to miss that we need a third naming for the type 3 API.
Do you see type 3 API as a valid API? if yes, what naming are you
suggesting for it? if no, why it is not a valid API?

> 
>>> as a tracker of the actual fragsz so when you commit you are
>>> committing with the fragsz as it was determined at the time of putting
>>> the bio_vec together so you can theoretically catch things like if the
>>> underlying offset had somehow changed from the time you setup the
>>
>> I think we might need a stronger argument than the above to use the new
>> *vec thing other than the above debugging feature.
>>
>> I looked throught the bio_vec related info, and come along somewhat not
>> really related, but really helpful "What’s all this get us" section:
>> https://docs.kernel.org/block/biovecs.html
>>
>> So the question seems to be: what is this new struct for page_frag get
>> us?
>>
>> Generally, I am argeed with the new struct thing if it does bring us
>> something other than the above debugging feature. Otherwise we should
>> avoid introducing a new thing which is hard to argue about its existent.
> 
> I don't want a new structure. I just want you to use the bio_vec for
> spots where you are needing to use a page because you are populating a
> bio_vec.
> 
>>> allocation. It would fit well into your probe routines since they are
>>> all essentially passing the page, offset, and fragsz throughout the
>>> code.
>>
>> For the current probe routines, the 'va' need to be passed, do you
>> expect the 'va' to be passed by function return, double pointer, or
>> new the *_vec pointer?
> 
> I would suggest doing so via the *_vec pointer. The problem as I see

As your above suggestion, I can safely assume *_ve is 'struct bio_vec',
right?

I am really confused here, you just clarified that you wasn't suggesting
changing the bio_vec, and now you are suggesting passing 'va' via the
'struct bio_vec' pointer?  How is it possible with current definition of
'struct bio_vec'?

struct bio_vec {
	struct page	*bv_page;
	unsigned int	bv_len;
	unsigned int	bv_offset;
};

Or am I mising something obvious here?

> it is that the existing code is exposing too much of the internals and
> setting up the possibility for a system to get corrupted really

If most of the page_frag API callers doesn't access 'struct bio_vec'
directly and use something like bvec_iter_* API to do the accessing,
then I am agreed with the above argument.

But right now, most of the page_frag API callers are accessing 'va'
directly to do the memcpy'ing, and accessing 'page & off & len' directly
to do skb frag filling, so I am not really sure what's the point of
indirection using the 'struct bio_vec' here.

And adding 'struct bio_vec' for page_frag and accessing the value of it
directly may be against of the design choice of 'struct bio_vec', as
there seems to be no inline helper defined to access the value of
'struct bio_vec' directly in bvec.h


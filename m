Return-Path: <kvm+bounces-23023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 63CB5945BCD
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 12:06:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D80581F23018
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 10:06:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A165A1DC476;
	Fri,  2 Aug 2024 10:06:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC301D0DF3;
	Fri,  2 Aug 2024 10:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722593174; cv=none; b=OAVHH/h9/kcmXOmOrAlyMkI1aB2YG6OdBueAjYRhDcI/j9TTy0WX2X60r9Gk/ugyRAYKz0ztIrpODUdoa9d+jqNMXTQsc0DMQYucOxLq+mee20WUCllgItPJq4mcROOH++GyBMxKdElsYSb1YU4PjZVNpCmGfabNnqkN/NhDahM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722593174; c=relaxed/simple;
	bh=p8KHDp5T541LzcauHdbygkcHm9Fm1n44ZnrMVKkUu6w=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=SOgQ7GfF56r340AGHYlMhxNn2hddkmE4ORKqztgMe/R/ElCHZ4NY3DLfeRSdhR4ioKqpaDgKPHHz3aTW6SfTobElblnjhsJ2TTXflp4JFnXddjXXUpRMxHzS4fv7Rd1Y0NQo1EiuDylSXrOp9ZhVn1N7kcfZ1hoyxazLg69IU8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Wb1ZM6Y7HzQnl8;
	Fri,  2 Aug 2024 18:01:31 +0800 (CST)
Received: from dggpemf200006.china.huawei.com (unknown [7.185.36.61])
	by mail.maildlp.com (Postfix) with ESMTPS id 0F1351800A1;
	Fri,  2 Aug 2024 18:05:53 +0800 (CST)
Received: from [10.67.120.129] (10.67.120.129) by
 dggpemf200006.china.huawei.com (7.185.36.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 2 Aug 2024 18:05:52 +0800
Message-ID: <877efebe-f316-4192-aada-dd2657b74125@huawei.com>
Date: Fri, 2 Aug 2024 18:05:52 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v12 04/14] mm: page_frag: add '_va' suffix to
 page_frag API
To: Alexander Duyck <alexander.duyck@gmail.com>
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
Content-Language: en-US
From: Yunsheng Lin <linyunsheng@huawei.com>
In-Reply-To: <CAKgT0UcuGj8wvC87=A+hkarRupfhjGM0BPzLUT2AJc8Ovg_TFg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf200006.china.huawei.com (7.185.36.61)

On 2024/8/1 23:21, Alexander Duyck wrote:
> On Thu, Aug 1, 2024 at 6:01 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> On 2024/8/1 2:13, Alexander Duyck wrote:
>>> On Wed, Jul 31, 2024 at 5:50 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>>>
>>>> Currently the page_frag API is returning 'virtual address'
>>>> or 'va' when allocing and expecting 'virtual address' or
>>>> 'va' as input when freeing.
>>>>
>>>> As we are about to support new use cases that the caller
>>>> need to deal with 'struct page' or need to deal with both
>>>> 'va' and 'struct page'. In order to differentiate the API
>>>> handling between 'va' and 'struct page', add '_va' suffix
>>>> to the corresponding API mirroring the page_pool_alloc_va()
>>>> API of the page_pool. So that callers expecting to deal with
>>>> va, page or both va and page may call page_frag_alloc_va*,
>>>> page_frag_alloc_pg*, or page_frag_alloc* API accordingly.
>>>>
>>>> CC: Alexander Duyck <alexander.duyck@gmail.com>
>>>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>>>> Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>
>>>
>>> I am naking this patch. It is a pointless rename that is just going to
>>> obfuscate the git history for these callers.
>>
>> I responded to your above similar comment in v2, and then responded more
>> detailedly in v11, both got not direct responding, it would be good to
>> have more concrete feedback here instead of abstract argument.
>>
>> https://lore.kernel.org/all/74e7259a-c462-e3c1-73ac-8e3f49fb80b8@huawei.com/
>> https://lore.kernel.org/all/11187fe4-9419-4341-97b5-6dad7583b5b6@huawei.com/
> 
> I will make this much more understandable. This patch is one of the
> ones that will permanently block this set in my opinion. As such I
> will never ack this patch as I see no benefit to it. Arguing with me
> on this is moot as you aren't going to change my mind, and I don't
> have all day to argue back and forth with you on every single patch.

Let's move on to more specific technical discussion then.

> 
> As far as your API extension and naming maybe you should look like
> something like bio_vec and borrow the naming from that since that is
> essentially what you are passing back and forth is essentially that
> instead of a page frag which is normally a virtual address.

I thought about adding something like bio_vec before, but I am not sure
what you have in mind is somthing like I considered before?
Let's say that we reuse bio_vec like something below for the new APIs:

struct bio_vec {
	struct page	*bv_page;
	void		*va;
	unsigned int	bv_len;
	unsigned int	bv_offset;
};

It seems we have the below options for the new API:

option 1, it seems like a better option from API naming point of view, but
it needs to return a bio_vec pointer to the caller, it seems we need to have
extra space for the pointer, I am not sure how we can avoid the memory waste
for sk_page_frag() case in patch 12:
struct bio_vec *page_frag_alloc_bio(struct page_frag_cache *nc,
				    unsigned int fragsz, gfp_t gfp_mask);

option 2, it need both the caller and callee to have a its own local space
for 'struct bio_vec ', I am not sure if passing the content instead of
the pointer of a struct through the function returning is the common pattern
and if it has any performance impact yet:
struct bio_vec page_frag_alloc_bio(struct page_frag_cache *nc,
				   unsigned int fragsz, gfp_t gfp_mask);

option 3, the caller passes the pointer of 'struct bio_vec ' to the callee,
and page_frag_alloc_bio() fills in the data, I am not sure what is the point
of indirect using 'struct bio_vec ' instead of passing 'va' & 'fragsz' &
'offset' through pointers directly:
bool page_frag_alloc_bio(struct page_frag_cache *nc,
			 unsigned int fragsz, gfp_t gfp_mask, struct bio_vec *bio);

If one of the above option is something in your mind? Yes, please be more specific
about which one is the prefer option, and why it is the prefer option than the one
introduced in this patchset?

If no, please be more specific what that is in your mind?



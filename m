Return-Path: <kvm+bounces-22229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 661E793C1D6
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 14:22:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A9901C21EEC
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 12:22:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F94D19A2A3;
	Thu, 25 Jul 2024 12:21:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9897C199397;
	Thu, 25 Jul 2024 12:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721910109; cv=none; b=HJUpZA5CS4YZFfoHIEaAEvjHpDdThZ0CC/Rzy1cBkedH+AmK6X4DA+wj3JJKCWNn31y/5nQ8H6MnxVarsHO7a59LJmeaMKeXNd+toUjD0kkUSXQk4XSDA62AS1Jmkuc2h971+8kHiStVHwkPhJ0Yc3CMcWADZAJWc3y8GrsITgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721910109; c=relaxed/simple;
	bh=Uxjq9RUhwjCqcw4st/SYfJ6kRT6AQmYokckDdcljTK0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=B1Qz2Gk/txRRE2spetv4g7ebKkA9TCm823eX9zpuHnZ6/5q1u81ZvUcOcP2TTMoee2fNhJi494I887uV9rLzk4cgjXPFD0QZ9QJIkwuJ8IOnkMFNUuQ6PgrI7dSqW4jXaMhT+UhJIXt5McxHOiR/9SBY7JxdOtCFblXdIkEQdF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WV93n3b0KzxVFN;
	Thu, 25 Jul 2024 20:21:41 +0800 (CST)
Received: from dggpemf200006.china.huawei.com (unknown [7.185.36.61])
	by mail.maildlp.com (Postfix) with ESMTPS id 406D6140121;
	Thu, 25 Jul 2024 20:21:45 +0800 (CST)
Received: from [10.67.120.129] (10.67.120.129) by
 dggpemf200006.china.huawei.com (7.185.36.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 25 Jul 2024 20:21:44 +0800
Message-ID: <11187fe4-9419-4341-97b5-6dad7583b5b6@huawei.com>
Date: Thu, 25 Jul 2024 20:21:42 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v11 04/14] mm: page_frag: add '_va' suffix to page_frag API
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
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck
 Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, Neil Brown
	<neilb@suse.de>, Olga Kornievskaia <kolga@netapp.com>, Dai Ngo
	<Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	<intel-wired-lan@lists.osuosl.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>, <linux-nvme@lists.infradead.org>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux.dev>,
	<linux-mm@kvack.org>, <bpf@vger.kernel.org>, <linux-afs@lists.infradead.org>,
	<linux-nfs@vger.kernel.org>
References: <20240719093338.55117-1-linyunsheng@huawei.com>
 <20240719093338.55117-5-linyunsheng@huawei.com>
 <CAKgT0UcqELiXntRA_uD8eJGjt-OCLO64ax=YFXrCHNnaj9kD8g@mail.gmail.com>
Content-Language: en-US
From: Yunsheng Lin <linyunsheng@huawei.com>
In-Reply-To: <CAKgT0UcqELiXntRA_uD8eJGjt-OCLO64ax=YFXrCHNnaj9kD8g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemf200006.china.huawei.com (7.185.36.61)

On 2024/7/22 4:41, Alexander Duyck wrote:
> On Fri, Jul 19, 2024 at 2:37 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> Currently the page_frag API is returning 'virtual address'
>> or 'va' when allocing and expecting 'virtual address' or
>> 'va' as input when freeing.
>>
>> As we are about to support new use cases that the caller
>> need to deal with 'struct page' or need to deal with both
>> 'va' and 'struct page'. In order to differentiate the API
>> handling between 'va' and 'struct page', add '_va' suffix
>> to the corresponding API mirroring the page_pool_alloc_va()
>> API of the page_pool. So that callers expecting to deal with
>> va, page or both va and page may call page_frag_alloc_va*,
>> page_frag_alloc_pg*, or page_frag_alloc* API accordingly.
>>
>> CC: Alexander Duyck <alexander.duyck@gmail.com>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> Rather than renaming the existing API I would rather see this follow
> the same approach as we use with the other memory subsystem functions.

I am not sure if I understand what 'the other memory subsystem functions'
is referring to, it would be better to be more specific about that.

For allocation side:
alloc_pages*()
extern unsigned long get_free_page*(gfp_t gfp_mask, unsigned int order);

For free side, it seems we have:
extern void __free_pages(struct page *page, unsigned int order);
extern void free_pages(unsigned long addr, unsigned int order);
static inline void put_page(struct page *page)

So there seems to be no clear pattern that the mm APIs with double
underscore is dealing with 'struct page' and the one without double
underscore is dealing with virtual address, at least not from the
allocation side.

> A specific example being that with free_page it is essentially passed
> a virtual address, while the double underscore version is passed a
> page. I would be more okay with us renaming the double underscore
> version of any functions we might have to address that rather than
> renaming all the functions with "va".

Before this patchset, page_frag has the below APIs as below:

void *__page_frag_alloc_align(struct page_frag_cache *nc, unsigned int fragsz,
			      gfp_t gfp_mask, unsigned int align_mask);

static inline void *page_frag_alloc_align(struct page_frag_cache *nc,
					  unsigned int fragsz, gfp_t gfp_mask,
					  unsigned int align)

extern void page_frag_free(void *addr);

It would be better to be more specific about what renaming does the above
APIs need in order to support the new usecases.

> 
> In general I would say this patch is adding no value as what it is

As above, it would be better to give a more specific suggestion to
back up the above somewhat abstract agrument, otherwise it is hard
to tell if there is better option here, and why it is better than
the one proposed in this patchset.

> doing is essentially pushing the primary users of this API to change
> to support use cases that won't impact most of them. It is just
> creating a ton of noise in terms of changes with no added value so we
> can reuse the function names.


After this patchset, we have the below page_frag APIs:

For allocation side, we have below APIs:
struct page *page_frag_alloc_pg*(struct page_frag_cache *nc,
                                unsigned int *offset, unsigned int fragsz,
                                gfp_t gfp);
void *page_frag_alloc_va*(struct page_frag_cache *nc,
                                 unsigned int fragsz, gfp_t gfp_mask,
                                 unsigned int align_mask);
struct page *page_frag_alloc*(struct page_frag_cache *nc,
                                     unsigned int *offset,
                                     unsigned int fragsz,
                                     void **va, gfp_t gfp);

For allocation side, we have below APIs:
void page_frag_free_va(void *addr);

The main rules for the about naming are:
1. The API with 'align' suffix ensure the offset or va is aligned
2. The API with double underscore has no checking for the algin parameter.
3. The API with 'va' suffix is dealing with virtual address.
4. The API with 'pg' suffix is dealing with 'struct page'.
5. The API without 'pg' and 'va' suffix is dealing with both 'struct page'
   and virtual address.

Yes, I suppose it is not perfect mainly because we reuse some existing mm
API for page_frag free API.

As mentioned before, I would be happy to change it if what you are proposing
is indeed the better option.


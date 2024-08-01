Return-Path: <kvm+bounces-22943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B65D944C9C
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 15:09:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4EE9B1C2598A
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 13:09:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F8251BCA0C;
	Thu,  1 Aug 2024 13:01:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87C21A6161;
	Thu,  1 Aug 2024 13:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722517287; cv=none; b=F65F8cAw5yCvCc3AfIaIwbNDaIbx1UFltEIqBnrl191E8PPrjpEF8E3ierFIMtaYryyP770tVIQwQ76Wmt5MYlS85Id7+PIXPgcInNjKThyjQ1WwBfca2rK5kD4AdogKPBhah8bt0gh0e7scnJzbo2vFcw/r1qmRFyRVDqUidCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722517287; c=relaxed/simple;
	bh=GkaiSM13/qrTUC0ROStPflXea/cNRgCiSONvV34+KIc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=FgDCDkegpS9MDash4MOsXueNAKq3jqenxYul3jLFcd1FB80kDzYdKzaHfpEzWLN8Iy4Uh2O5fvf4E98KQqiOtWgUUvhSSBhrrSOD52FHSh496mTbhhv5JPTFTkh7vBW1EIrloQ7CWpFsGM2tUf4ZsbrpUfqJrdhp+L6J1DSvoXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WZTc54FXfzxW3F;
	Thu,  1 Aug 2024 21:01:09 +0800 (CST)
Received: from dggpemf200006.china.huawei.com (unknown [7.185.36.61])
	by mail.maildlp.com (Postfix) with ESMTPS id 996A7140109;
	Thu,  1 Aug 2024 21:01:22 +0800 (CST)
Received: from [10.67.120.129] (10.67.120.129) by
 dggpemf200006.china.huawei.com (7.185.36.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 1 Aug 2024 21:01:22 +0800
Message-ID: <22fda86c-d688-42e7-99e8-e2f8fcf1a5ba@huawei.com>
Date: Thu, 1 Aug 2024 21:01:21 +0800
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
Content-Language: en-US
From: Yunsheng Lin <linyunsheng@huawei.com>
In-Reply-To: <CAKgT0UcqdeSJdjZ_FfwyCnT927TwOkE4zchHLOkrBEmhGzex9g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemf200006.china.huawei.com (7.185.36.61)

On 2024/8/1 2:13, Alexander Duyck wrote:
> On Wed, Jul 31, 2024 at 5:50 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
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
> I am naking this patch. It is a pointless rename that is just going to
> obfuscate the git history for these callers.

I responded to your above similar comment in v2, and then responded more
detailedly in v11, both got not direct responding, it would be good to
have more concrete feedback here instead of abstract argument.

https://lore.kernel.org/all/74e7259a-c462-e3c1-73ac-8e3f49fb80b8@huawei.com/
https://lore.kernel.org/all/11187fe4-9419-4341-97b5-6dad7583b5b6@huawei.com/

> 
> As I believe I said before I would prefer to see this work more like
> the handling of __get_free_pages and __free_pages in terms of the use

I am not even sure why are you bringing up  __get_free_pages() and
__free_pages() here, as the declaration of them is something like below:

unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
void __free_pages(struct page *page, unsigned int order);

And I add another related one for completeness here:
extern void free_pages(unsigned long addr, unsigned int order);

I am failing to see there is any pattern or rule for the above API
naming. If there is some pattern for the above existing APIs, please
describe them in detail so that we have common understanding.

After the renaming, the declaration for both new and old APIs is
below, please be more specific about what exactly is the confusion
about them, what is the better naming for the below APIs in your
mind:
struct page *page_frag_alloc_pg(struct page_frag_cache *nc,
                               unsigned int *offset, unsigned int fragsz,
                               gfp_t gfp);
void *page_frag_alloc_va(struct page_frag_cache *nc,
                         unsigned int fragsz, gfp_t gfp_mask);
struct page *page_frag_alloc(struct page_frag_cache *nc,
                             unsigned int *offset,
                             unsigned int fragsz,
                             void **va, gfp_t gfp);

> of pages versus pointers and/or longs. Pushing this API aside because
> you want to reuse the name for something different isn't a valid
> reason to rename an existing API and will just lead to confusion.

Before this patchset, all the page_frag API renamed with a '_va' suffix
in this patch are dealing with virtual address, it would be better to be
more specific about what exactly is the confusion here by adding a explicit
'va' suffix for them in this patch?

I would argue that the renaming may avoid some confusion about whether
page_frag_alloc() returning a 'struct page' or returning a virtual address
instead of leading to confusion.

Anyway, naming is always hard, any better naming is welcome. But don't deny
any existing API renaming when we have not really started doing detailed
comparison between different API naming options yet.


Return-Path: <kvm+bounces-14969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6B4B8A8421
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 15:19:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D86811C21D7A
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 13:19:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C68A913EFFB;
	Wed, 17 Apr 2024 13:18:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B5113C3E0;
	Wed, 17 Apr 2024 13:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713359926; cv=none; b=VH6GWKU+19IEllNnbNB37hYWcATvwO6jbcjdBEp2LzHIU/lD0ARJm3JcHqjFE1WyZn45DTyQkZpYsQ5PkgKJzzHHprQKE05+2J33DB7kTG2SK9v+8xPQ1vapRWC4V7OhoHDqB+KCzhm/hYPQMS1QVQnH6mVpAGyTNMOATNepgRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713359926; c=relaxed/simple;
	bh=zDIOvTM9o+jTTu1NNu/JxBSI7hr2E1MIf2PNjleRc6M=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=E+vqVJ3DJFADe/ZYNvQBNRRJpDHVa85yCQS3098DJ4Zhn2MBEVtbaqS0cwQ8LNv9j998iPUI7ymWAaUbB4ZHXxmNeOZxYlbbw3m475uWaNf8KfnbZ0UJBgRuOc5WO/NVyGU9eekzGRa02luZO14qIVzwcV28H4XfQfXjqExKh1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VKLxQ3gh3zXlNZ;
	Wed, 17 Apr 2024 21:15:22 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (unknown [7.185.36.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 812AD140485;
	Wed, 17 Apr 2024 21:18:41 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Wed, 17 Apr
 2024 21:18:41 +0800
Subject: Re: [PATCH net-next v2 07/15] mm: page_frag: add '_va' suffix to
 page_frag API
To: Alexander H Duyck <alexander.duyck@gmail.com>, <davem@davemloft.net>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Jeroen de Borst
	<jeroendb@google.com>, Praveen Kaligineedi <pkaligineedi@google.com>,
	Shailend Chand <shailend@google.com>, Eric Dumazet <edumazet@google.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>, Tony Nguyen
	<anthony.l.nguyen@intel.com>, Sunil Goutham <sgoutham@marvell.com>, Geetha
 sowjanya <gakula@marvell.com>, Subbaraya Sundeep <sbhatta@marvell.com>,
	hariprasad <hkelam@marvell.com>, Felix Fietkau <nbd@nbd.name>, Sean Wang
	<sean.wang@mediatek.com>, Mark Lee <Mark-MC.Lee@mediatek.com>, Lorenzo
 Bianconi <lorenzo@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Keith
 Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig
	<hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni
	<kch@nvidia.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
	<jasowang@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei
 Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Jesper
 Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>, Yonghong
 Song <yonghong.song@linux.dev>, KP Singh <kpsingh@kernel.org>, Stanislav
 Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, Jiri Olsa
	<jolsa@kernel.org>, David Howells <dhowells@redhat.com>, Marc Dionne
	<marc.dionne@auristor.com>, Chuck Lever <chuck.lever@oracle.com>, Jeff Layton
	<jlayton@kernel.org>, Neil Brown <neilb@suse.de>, Olga Kornievskaia
	<kolga@netapp.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey
	<tom@talpey.com>, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna
 Schumaker <anna@kernel.org>, <intel-wired-lan@lists.osuosl.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mediatek@lists.infradead.org>,
	<linux-nvme@lists.infradead.org>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <linux-mm@kvack.org>,
	<bpf@vger.kernel.org>, <linux-afs@lists.infradead.org>,
	<linux-nfs@vger.kernel.org>
References: <20240415131941.51153-1-linyunsheng@huawei.com>
 <20240415131941.51153-8-linyunsheng@huawei.com>
 <18ca19fa64267b84bee10473a81cbc63f53104a0.camel@gmail.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <74e7259a-c462-e3c1-73ac-8e3f49fb80b8@huawei.com>
Date: Wed, 17 Apr 2024 21:18:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <18ca19fa64267b84bee10473a81cbc63f53104a0.camel@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)

On 2024/4/17 0:12, Alexander H Duyck wrote:
> On Mon, 2024-04-15 at 21:19 +0800, Yunsheng Lin wrote:
>> Currently most of the API for page_frag API is returning
>> 'virtual address' as output or expecting 'virtual address'
>> as input, in order to differentiate the API handling between
>> 'virtual address' and 'struct page', add '_va' suffix to the
>> corresponding API mirroring the page_pool_alloc_va() API of
>> the page_pool.
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> 
> This patch is a total waste of time. By that logic we should be
> renaming __get_free_pages since it essentially does the same thing.
> 
> This just seems like more code changes for the sake of adding code
> changes rather than fixing anything. In my opinion it should be dropped
> from the set.

The rename is to support different use case as mentioned below in patch
14:
"Depending on different use cases, callers expecting to deal with va, page or
both va and page for them may call page_frag_alloc_va*, page_frag_alloc_pg*,
or page_frag_alloc* API accordingly."

Naming is hard anyway, I am open to better API naming for the above use cases.

> 
> .
> 


Return-Path: <kvm+bounces-3849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AAE08086B4
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 12:27:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 264891F227BB
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 11:27:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E288D37D3F;
	Thu,  7 Dec 2023 11:27:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC12A3;
	Thu,  7 Dec 2023 03:27:12 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.54])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4SmBmP6BNDzWjZ5;
	Thu,  7 Dec 2023 19:26:13 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 7 Dec
 2023 19:27:09 +0800
Subject: Re: [PATCH net-next 2/6] page_frag: unify gfp bit for order 3 page
 allocation
To: Jakub Kicinski <kuba@kernel.org>
CC: <davem@davemloft.net>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Alexander Duyck <alexander.duyck@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, Eric Dumazet
	<edumazet@google.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <linux-mm@kvack.org>
References: <20231205113444.63015-1-linyunsheng@huawei.com>
 <20231205113444.63015-3-linyunsheng@huawei.com>
 <20231206191539.06d955f3@kernel.org>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <68750375-bab1-916d-0415-ff873e75a875@huawei.com>
Date: Thu, 7 Dec 2023 19:27:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20231206191539.06d955f3@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected

On 2023/12/7 11:15, Jakub Kicinski wrote:
> On Tue, 5 Dec 2023 19:34:40 +0800 Yunsheng Lin wrote:
>> __GFP_DIRECT_RECLAIM is xor'd to avoid
>> direct reclaim in skb_page_frag_refill(), but it is not
>> xor'd in __page_frag_cache_refill().
> 
> xor is not the same thing as masking a bit off.

You are right.
Will use 'mask off', thanks.

> The patch itself LGTM.
> .
> 


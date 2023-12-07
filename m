Return-Path: <kvm+bounces-3790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CB40807F1E
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 04:15:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 635BB1C21296
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 03:15:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A17D5237;
	Thu,  7 Dec 2023 03:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aSLju+4e"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D5D37B;
	Thu,  7 Dec 2023 03:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10411C433C8;
	Thu,  7 Dec 2023 03:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701918942;
	bh=SRAZz73xZ/wQzq9LmH5D7EgARdnZgItIkeFCCGRI57E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aSLju+4eEJeIUkqF6JDwTQfuLhzmDJ3EawX3T13ddxPpFum1+fPbsj9nN606wV3Mq
	 i9fFZsr1jJtPLFJNEBZz4TSt7+0iMaPrlnhPsLXKTaMRuk17aZaO+Xjbh0r7MKa/F4
	 PiIH69Ri+ANuMK62qJSvqZjqDCCS9PtCMGtT8zcdxxb20oB1v5wc/DBO0yiVpeXBst
	 TLQIuVhMPSr0RjbRX8EWaqJCX4ZR0hYyOXcBq2USAcsHg5Nhm8CKxAe04C5MAIt5zP
	 JKlDkDFzKEPewUkcECvkdDBN0H/53XREjVLSBABKEG/VUThI5J8G349GXQk+Z7+6Ce
	 ixELhIZx2p/cw==
Date: Wed, 6 Dec 2023 19:15:39 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: <davem@davemloft.net>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, Alexander Duyck
 <alexander.duyck@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason
 Wang <jasowang@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Eric
 Dumazet <edumazet@google.com>, <kvm@vger.kernel.org>,
 <virtualization@lists.linux.dev>, <linux-mm@kvack.org>
Subject: Re: [PATCH net-next 2/6] page_frag: unify gfp bit for order 3 page
 allocation
Message-ID: <20231206191539.06d955f3@kernel.org>
In-Reply-To: <20231205113444.63015-3-linyunsheng@huawei.com>
References: <20231205113444.63015-1-linyunsheng@huawei.com>
	<20231205113444.63015-3-linyunsheng@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 5 Dec 2023 19:34:40 +0800 Yunsheng Lin wrote:
> __GFP_DIRECT_RECLAIM is xor'd to avoid
> direct reclaim in skb_page_frag_refill(), but it is not
> xor'd in __page_frag_cache_refill().

xor is not the same thing as masking a bit off.
The patch itself LGTM.


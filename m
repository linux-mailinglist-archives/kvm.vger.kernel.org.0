Return-Path: <kvm+bounces-5103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36E5481C1F0
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 00:25:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E75CD28AD73
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 23:25:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C32687B3BF;
	Thu, 21 Dec 2023 23:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rIee9BHF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9517B3AD
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 23:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--shakeelb.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbd45923230so1749749276.1
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 15:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1703201025; x=1703805825; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cU9mOyLPoF6ZxNM7jnDLVtHU9dKeo3lsrx7E6D/L6sI=;
        b=rIee9BHFH3w3Z9YC28rgKtx4jr66VuXGwN+IQzUx04pSGohOdVOf65JlJd+b4wY7CT
         mb2d02bNRGYDyjAmCf35ji7Qo5w4J6W+uR4MoHcrA3sFVi28tEvIqu3o/tuL/eMBSSlx
         TaWrPrRdCXBVUHD5I6urFnQzzUSZvivuA/lTJVfOncmM1YtQxtJrw1vAKIpLQOPwujKu
         LYs2vQJkbg8cK+SfRZsV9vxpYa8hXE+XQSj1cYSgol5uj8GAPrT59Wdv9tQezatc4EEF
         xdCeqO6owtLWCZn/5FT8/qdhBI8a2hex6djOc5zW5mtvTPyd1qdJ0symVw27M5UT+I7u
         EWng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703201025; x=1703805825;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cU9mOyLPoF6ZxNM7jnDLVtHU9dKeo3lsrx7E6D/L6sI=;
        b=grL1WBBrkpOi3SBdVcZWV88EdJ8UnEgz/8OyvrNQCgU+VUuysG7kKVDnQY/zt/+8Ru
         1AmUKpdCiQajZKxIWFBKnWCauL2gWHPUkdxa3xOlCO+bzjMQSo0YOksZ/YAJMOyuhsb4
         N0dd0YwOxu9VDgLMXp7m9RN0EDykR4dZ7b8FSV02Nw+5iSder0eYPKjtDcAJOGyXyQcX
         hKV2PXabk09o3wi3zooOmKIlrerbv66k7Wdy3GEZjBD0QuTfbDawa6XaKT2gqDH27QtT
         jiRjHbwCEODs8fYZgXCQwJ/ACHsIjleiUdqmYO9vZbQLoUWalei52UNLgk23o3rleuV7
         rOqw==
X-Gm-Message-State: AOJu0YwuZDhv6+hHytg/6NeNboHj9UdYshf57xJMne8BQI0Lmo4DensK
	QMqLgWLFbUyT0uDLRjXON0nmBZxYwcEiTW1PiI64
X-Google-Smtp-Source: AGHT+IHWiT1s/e6el8Gbfa2jmdYfbMdaJTd+pS4T1tXJHPKsVM+5WAmrvhPrUoUOQ5Wk4tJyK70wKIQ5Qx+mgg==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:262e])
 (user=shakeelb job=sendgmr) by 2002:a25:bcc2:0:b0:db5:47c1:e82d with SMTP id
 l2-20020a25bcc2000000b00db547c1e82dmr189052ybm.6.1703201025720; Thu, 21 Dec
 2023 15:23:45 -0800 (PST)
Date: Thu, 21 Dec 2023 23:23:43 +0000
In-Reply-To: <20231220214505.2303297-3-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231220214505.2303297-1-almasrymina@google.com> <20231220214505.2303297-3-almasrymina@google.com>
Message-ID: <20231221232343.qogdsoavt7z45dfc@google.com>
Subject: Re: [PATCH net-next v3 2/3] net: introduce abstraction for network memory
From: Shakeel Butt <shakeelb@google.com>
To: Mina Almasry <almasrymina@google.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, 
	David Howells <dhowells@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	"Christian =?utf-8?B?S8O2bmln?=" <christian.koenig@amd.com>, Yunsheng Lin <linyunsheng@huawei.com>, 
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Dec 20, 2023 at 01:45:01PM -0800, Mina Almasry wrote:
> Add the netmem_ref type, an abstraction for network memory.
> 
> To add support for new memory types to the net stack, we must first
> abstract the current memory type. Currently parts of the net stack
> use struct page directly:
> 
> - page_pool
> - drivers
> - skb_frag_t
> 
> Originally the plan was to reuse struct page* for the new memory types,
> and to set the LSB on the page* to indicate it's not really a page.
> However, for compiler type checking we need to introduce a new type.
> 
> netmem_ref is introduced to abstract the underlying memory type. Currently
> it's a no-op abstraction that is always a struct page underneath. In
> parallel there is an undergoing effort to add support for devmem to the
> net stack:
> 
> https://lore.kernel.org/netdev/20231208005250.2910004-1-almasrymina@google.com/
> 
> Signed-off-by: Mina Almasry <almasrymina@google.com>
> 
> ---
> 
> v3:
> 
> - Modify struct netmem from a union of struct page + new types to an opaque
>   netmem_ref type.  I went with:
> 
>   +typedef void *__bitwise netmem_ref;
> 
>   rather than this that Jakub recommended:
> 
>   +typedef unsigned long __bitwise netmem_ref;
> 
>   Because with the latter the compiler issues warnings to cast NULL to
>   netmem_ref. I hope that's ok.
> 

Can you share what the warning was? You might just need __force
attribute. However you might need this __force a lot. I wonder if you
can just follow struct encoded_page example verbatim here.



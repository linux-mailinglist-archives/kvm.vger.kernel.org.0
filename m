Return-Path: <kvm+bounces-37280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 86F3EA27FD0
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 00:58:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23C2D1886E9E
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 23:59:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A07A21CFEF;
	Tue,  4 Feb 2025 23:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="Xlu+gMlT"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C882D2040B5
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 23:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738713529; cv=none; b=kXQj60oylere3qmFwy1ylHUGxJd2ubxyP4QCwDxFY6u65QlRL67jtiAks7pFwge5ccdXvQkp2MxXjquBaG6p5t0HqKY6bYIQhIDFSMGm6FzgTQwcfMtp8MNBYvH0OYLXuVJaYeSFyXt62KoInGcnhH4rQtejNWK1+bXhBTQI77M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738713529; c=relaxed/simple;
	bh=h1pBuPBtktSjNMu4TvOQ+L+yQZBLCy44jrXjx/GWXb4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L4S74Qyiy773vjTd01VonASAuvxYFtZfqUwNibNEORM5R9I70kXxa/By4LOmhc6nqSXuCuEn32gMBQtFNK++2mfYuWvPsExgPI+rwrp/K1fIX2nqR3gTIWt0a0F32KGmbMlMCUYgwiqeYSJMG9PRcUWBNNF7D7HF5y26zeYRcQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=Xlu+gMlT; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1tfSoL-005yfw-5B; Wed, 05 Feb 2025 00:58:33 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=Rb93MMJ9jrAXvrmiXFCfJpGm+j99GvvxBquzJPRoovE=; b=Xlu+gMlT3AX5XzY+BkrKS8QIfr
	946QTIjd72Jt3evMzv5wMJHT1IBhZLJSWMFthKc1Vvs5jh1/YL3155+u+sMeyECO9VPsZO6NEmMdn
	OtVfJQsu5oZxKA1bcv4WRF6h4M6h8v3dNVVWTgYbUilvMvss2FTiACakY/uO/wpH1Gg46k6zbuTt+
	3Gdt42+2/lOC1AiKjohd1FWKwEtHVxsYNC0hWCYy0A03nuxyFIr4l0TZHaqzWkW26xk0hkNeFh7lt
	QP8JCsLD20C4fzTk5jtjH7dzAu7Y8R94WqNWOJzAGjEsF5x0ePgIIQ79L1pMkHqAbDFzrNXt2p4iZ
	ByRYmBOA==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1tfSoJ-0002IE-WD; Wed, 05 Feb 2025 00:58:32 +0100
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1tfSo2-009Y7j-C5; Wed, 05 Feb 2025 00:58:14 +0100
Message-ID: <4732bd9f-e202-4895-9ba2-576b571c387a@rbox.co>
Date: Wed, 5 Feb 2025 00:58:12 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [net?] general protection fault in add_wait_queue
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: syzbot <syzbot+9d55b199192a4be7d02c@syzkaller.appspotmail.com>,
 davem@davemloft.net, edumazet@google.com, eperezma@redhat.com,
 horms@kernel.org, jasowang@redhat.com, kuba@kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org,
 pabeni@redhat.com, stefanha@redhat.com, syzkaller-bugs@googlegroups.com,
 virtualization@lists.linux.dev, xuanzhuo@linux.alibaba.com
References: <67a09300.050a0220.d7c5a.008b.GAE@google.com>
 <2483d8c1-961e-4a7f-9ce7-ffd21a380c70@rbox.co>
 <6fonjxxkozzmv7huzavck5nsfivx3nsyyicthulg5aiyrmjpql@o7pexllumdxt>
 <CAGxU2F7CgVHUuPPATBzXw20fR1Z+MVpsJvgRO=kMFV1nis49SQ@mail.gmail.com>
Content-Language: pl-PL, en-GB
From: Michal Luczaj <mhal@rbox.co>
In-Reply-To: <CAGxU2F7CgVHUuPPATBzXw20fR1Z+MVpsJvgRO=kMFV1nis49SQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/4/25 11:04, Stefano Garzarella wrote:
> On Tue, 4 Feb 2025 at 10:59, Stefano Garzarella <sgarzare@redhat.com> wrote:
>> On Tue, Feb 04, 2025 at 01:38:50AM +0100, Michal Luczaj wrote:
>>> ...
>>> I'm not sure this is the most elegant code (sock_orphan(sk) sets SOCK_DEAD
>>> on a socket that is already SOCK_DEAD), but here it goes:
>>> https://lore.kernel.org/netdev/20250204-vsock-linger-nullderef-v1-0-6eb1760fa93e@rbox.co/
>>
>> What about the fix proposed here:
>> https://lore.kernel.org/lkml/20250203124959.114591-1-aha310510@gmail.com/
> 
> mmm, nope, that one will completely bypass the lingering, right?

Right. Besides that, it's a transport-specific approach, so all the other
transports would need their .release() tweaked.

>>> One more note: man socket(7) says lingering also happens on shutdown().
>>> Should vsock follow that?
>>
>> Good point, I think so.
>> IMHO we should handle both of them in af_vsock.c if it's possible, but
>> maybe we need a bit of refactoring.
>>
>> Anyway, net-next material, right?

Yeah, I guess.

Michal



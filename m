Return-Path: <kvm+bounces-67670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 06926D0EA5F
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 12:01:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7FAE83035A81
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 11:00:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 154C0336EC7;
	Sun, 11 Jan 2026 11:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="e0RSaExe"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE29635965;
	Sun, 11 Jan 2026 11:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768129223; cv=none; b=NpgnDWLQ8cMjmq2wtlH4kmo9Y+aMqQkS6y9eqgJ0FHp9suhcIDpGPxh979ozEbqMhnKQrR0P9AVrBcrGZeHS3zEEq22TxEvP4K7QVFYPGHiQoMo4fdpC165T/pv9QRqMLD5XUwwnJ3XSE0sSrJAw0mrsnTzMOCW+ySyxxRoLwvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768129223; c=relaxed/simple;
	bh=ELIZpjH4jshC+q126H2p3RkHz0HlUxEYfJcAfY+Z9YE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H7pAt51PonNntr8lCx5e6Ir3Z//v1Mjm6IGRzW/7d948BiOkEP2aG+xbYGU/sJZ9oSyQdS4ouRy4TGMTEtsqcq4Q9xjnP2oQvNP+BLExShyLqmkD5sRvekj0/zYIDjzcoihKWa1wtGTmN/KaoaIvk+5LzZsC1f1/YMjLD4Sp++I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=e0RSaExe; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1vetB6-009kIZ-TZ; Sun, 11 Jan 2026 12:00:12 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=5uZ3LZfOZWVMlL8l8PLhGgJ10/9cK55ZfyWwVPRLGsk=; b=e0RSaExegxUf16QCIIQ+dyZvdP
	spQfbYMwB0zpJ/3wGvx1IXbHwIAnXj8hLsOaQWpGPowImVIjE+u4ydYvzhb2pL0srfVdEl/wWObl6
	agWl8SPivrToaW3n4tdmhccjYG6bGl/LQyCwJ6D6/TBm2wq0f/8yQ8NTjQhMgdidJuXpm+kfuwXhB
	Xkhqt6GfIErXBPAlL5cL0/ZlTUEqeQUZob1Hv8+9sEu8J/sAGCMTfDiGZmN0keywKZV5q/hSz53L6
	15MydZzaL0EUGuLHJi8WqOShrn8hvvaI61IzWLr+l6Alv+g18GzcnfUkw5Z7dCY/Gayil2Qwl0Rxp
	nrBqHsEw==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1vetB6-0006ng-Eu; Sun, 11 Jan 2026 12:00:12 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vetAp-007ayA-Cb; Sun, 11 Jan 2026 11:59:55 +0100
Message-ID: <76ca0c9f-dcda-4a53-ac1f-c5c28d1ecf44@rbox.co>
Date: Sun, 11 Jan 2026 11:59:54 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] vsock/test: Add test for a linear and non-linear skb
 getting coalesced
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>,
 Arseniy Krasnov <avkrasnov@salutedevices.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260108-vsock-recv-coalescence-v1-0-26f97bb9a99b@rbox.co>
 <20260108-vsock-recv-coalescence-v1-2-26f97bb9a99b@rbox.co>
 <aWEqjjE1vb_t35lQ@sgarzare-redhat>
Content-Language: pl-PL, en-GB
From: Michal Luczaj <mhal@rbox.co>
In-Reply-To: <aWEqjjE1vb_t35lQ@sgarzare-redhat>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/9/26 17:32, Stefano Garzarella wrote:
> On Thu, Jan 08, 2026 at 10:54:55AM +0100, Michal Luczaj wrote:
>> Loopback transport can mangle data in rx queue when a linear skb is
>> followed by a small MSG_ZEROCOPY packet.
> 
> Can we describe a bit more what the test is doing?

I've expanded the commit message:

To exercise the logic, send out two packets: a weirdly sized one (to ensure
some spare tail room in the skb) and a zerocopy one that's small enough to
fit in the spare room of its predecessor. Then, wait for both to land in
the rx queue, and check the data received. Faulty packets merger manifests
itself by corrupting payload of the later packet.

>> Signed-off-by: Michal Luczaj <mhal@rbox.co>
>> ---
>> tools/testing/vsock/vsock_test.c          |  5 +++
>> tools/testing/vsock/vsock_test_zerocopy.c | 67 +++++++++++++++++++++++++++++++
>> tools/testing/vsock/vsock_test_zerocopy.h |  3 ++
>> 3 files changed, 75 insertions(+)
>>
>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>> index bbe3723babdc..21c8616100f1 100644
>> --- a/tools/testing/vsock/vsock_test.c
>> +++ b/tools/testing/vsock/vsock_test.c
>> @@ -2403,6 +2403,11 @@ static struct test_case test_cases[] = {
>> 		.run_client = test_stream_accepted_setsockopt_client,
>> 		.run_server = test_stream_accepted_setsockopt_server,
>> 	},
>> +	{
>> +		.name = "SOCK_STREAM MSG_ZEROCOPY coalescence corruption",
> 
> This is essentially a regression test for virtio transport, so I'd add 
> virtio in the test name.

Isn't virtio transport unaffected? It's about loopback transport (that
shares common code with virtio transport).

>> +		.run_client = test_stream_msgzcopy_mangle_client,
>> +		.run_server = test_stream_msgzcopy_mangle_server,
>> +	},
>> 	{},
>> };
>>
>> diff --git a/tools/testing/vsock/vsock_test_zerocopy.c b/tools/testing/vsock/vsock_test_zerocopy.c
>> index 9d9a6cb9614a..6735a9d7525d 100644
>> --- a/tools/testing/vsock/vsock_test_zerocopy.c
>> +++ b/tools/testing/vsock/vsock_test_zerocopy.c
>> @@ -9,11 +9,13 @@
>> #include <stdio.h>
>> #include <stdlib.h>
>> #include <string.h>
>> +#include <sys/ioctl.h>
>> #include <sys/mman.h>
>> #include <unistd.h>
>> #include <poll.h>
>> #include <linux/errqueue.h>
>> #include <linux/kernel.h>
>> +#include <linux/sockios.h>
>> #include <errno.h>
>>
>> #include "control.h"
>> @@ -356,3 +358,68 @@ void test_stream_msgzcopy_empty_errq_server(const struct test_opts *opts)
>> 	control_expectln("DONE");
>> 	close(fd);
>> }
>> +
>> +#define GOOD_COPY_LEN	128	/* net/vmw_vsock/virtio_transport_common.c */
> 
> I think we don't need this, I mean we can eventually just send a single 
> byte, no?

For a single byte sent, you get a single byte of uninitialized kernel
memory. Uninitialized memory can by anything, in particular it can be
(coincidentally) what you happen to expect. Which would result in a false
positive. So instead of estimating what length sufficiently reduces
probability of such false positive, I just took the upper bound.

BTW, I've realized recv_verify() is reinventing the wheel. How about
dropping it in favour of what test_seqpacket_msg_bounds_client() does, i.e.
calc the hash of payload and send it over the control channel for verification?

>> +
>> +void test_stream_msgzcopy_mangle_client(const struct test_opts *opts)
>> +{
>> +	char sbuf1[PAGE_SIZE + 1], sbuf2[GOOD_COPY_LEN];
>> +	struct pollfd fds;
>> +	int fd;
>> +
>> +	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
>> +	if (fd < 0) {
>> +		perror("connect");
>> +		exit(EXIT_FAILURE);
>> +	}
>> +
>> +	enable_so_zerocopy_check(fd);
>> +
>> +	memset(sbuf1, '1', sizeof(sbuf1));
>> +	memset(sbuf2, '2', sizeof(sbuf2));
>> +
>> +	send_buf(fd, sbuf1, sizeof(sbuf1), 0, sizeof(sbuf1));
>> +	send_buf(fd, sbuf2, sizeof(sbuf2), MSG_ZEROCOPY, sizeof(sbuf2));
>> +
>> +	fds.fd = fd;
>> +	fds.events = 0;
>> +
>> +	if (poll(&fds, 1, -1) != 1 || !(fds.revents & POLLERR)) {
>> +		perror("poll");
>> +		exit(EXIT_FAILURE);
>> +	}
> 
> Should we also call vsock_recv_completion() or we don't care about the 
> result?
> 
> If we need it, maybe we can factor our the poll + 
> vsock_recv_completion().

Nope, we don't care about the result.



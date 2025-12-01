Return-Path: <kvm+bounces-65030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 283DCC98D22
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 20:16:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 963624E23AB
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 19:16:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7576244661;
	Mon,  1 Dec 2025 19:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HlJ3KRjP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78BA10F1;
	Mon,  1 Dec 2025 19:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764616559; cv=none; b=jWEQTdkhwNlMazxnf1TtpGTHsOLipymqBKFCnZnLG05Tc16fiin3zzNqt6ihKoW1rIH2rU6yQcvMs4Hr4Y7sl9EpJ2TbNdkbuswsoPz7QaWNbh0lI8U5JmGMb8qKoREuoWep3Iu8xC1iDxTf64jXTYcZo30rZBE760JUkRtcKKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764616559; c=relaxed/simple;
	bh=4XgmDLSCEg6VsFoBcwzl521M4IJOdgdZ7BMmz88L2/M=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jidf7kkmulpSrfhbT6zLqFmXgfHJagYGJg34YvG2MUQEA5Fdgw68yCn+hlvbatALSZgr2x5lb+gBpabT2CtTFungxTawB+NIZ9wucYdNkfjlGJ8UsCufGADFhp+p99feHtLssJI83InaSd36ojlY5uNOqZAH8Yd+PBpilgthsXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HlJ3KRjP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD9BC4CEF1;
	Mon,  1 Dec 2025 19:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764616559;
	bh=4XgmDLSCEg6VsFoBcwzl521M4IJOdgdZ7BMmz88L2/M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HlJ3KRjP7xZ4T9ko7eFxV7P6PoXSWyCu3HrexUTNs8fV3q+nABoR50xZLZKAzpGNa
	 ADyv8W1zgjFaujFUmt88AkFSgo2NDY7bT1mmvqKppbdXFiBm7yNvoVFcbZoOhHFKXj
	 ZZlSoYYVw+0jbvdRNqzJLmN1JxyjhH/KsEKWI2z27KIarFfW9BcXFPoPejMDxnUuyt
	 WHT4zqZu1fr3xCQNnE8UkS9fWmat3w/7+wlNQuRe1MAEFQW7SUwSZWx2kYcTzahhz7
	 fk3vdyF7i7BFoNI67EtyLp2penSN5GgpwofhL5VPA1TiZcHr6gLcyXvEtyz6Rtcaww
	 b7z6WXVZjzQkg==
Date: Mon, 1 Dec 2025 11:15:57 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Edward Adam Davis <eadavis@qq.com>
Cc: davem@davemloft.net, edumazet@google.com, eperezma@redhat.com,
 horms@kernel.org, jasowang@redhat.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org,
 pabeni@redhat.com, sgarzare@redhat.com, stefanha@redhat.com,
 syzbot+ci3edb9412aeb2e703@syzkaller.appspotmail.com,
 syzbot@lists.linux.dev, syzbot@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com, virtualization@lists.linux.dev,
 xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH Next V2] net: restore the iterator to its original state
 when an error occurs
Message-ID: <20251201111557.15cb9415@kernel.org>
In-Reply-To: <tencent_7B73E6D013636363696CC3A34444F77AF705@qq.com>
References: <20251128093946.18c645c6@kernel.org>
	<tencent_7B73E6D013636363696CC3A34444F77AF705@qq.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  1 Dec 2025 11:41:07 +0800 Edward Adam Davis wrote:
> On Fri, 28 Nov 2025 09:39:46 -0800, Jakub Kicinski wrote:
> > > In zerocopy_fill_skb_from_iter(), if two copy operations are performed
> > > and the first one succeeds while the second one fails, it returns a
> > > failure but the count in iterator has already been decremented due to
> > > the first successful copy. This ultimately affects the local variable
> > > rest_len in virtio_transport_send_pkt_info(), causing the remaining
> > > count in rest_len to be greater than the actual iterator count. As a
> > > result, packet sending operations continue even when the iterator count
> > > is zero, which further leads to skb->len being 0 and triggers the warning
> > > reported by syzbot [1].  
> > 
> > Please follow the subsystem guidelines for posting patches:
> > https://www.kernel.org/doc/html/next/process/maintainer-netdev.html
> > Your patch breaks zerocopy tests.  
> I see that they all timed out. I'm not familiar with this test, how can
> I get more details about it?

IIRC its was the packetdrill tests:

tools/testing/selftests/net/packetdrill/tcp_fastopen_server_basic-zero-payload.pkt
tools/testing/selftests/net/packetdrill/tcp_zerocopy_basic.pkt
tools/testing/selftests/net/packetdrill/tcp_zerocopy_batch.pkt
tools/testing/selftests/net/packetdrill/tcp_zerocopy_client.pkt
tools/testing/selftests/net/packetdrill/tcp_zerocopy_closed.pkt
tools/testing/selftests/net/packetdrill/tcp_zerocopy_epoll_edge.pkt
tools/testing/selftests/net/packetdrill/tcp_zerocopy_epoll_exclusive.pkt
tools/testing/selftests/net/packetdrill/tcp_zerocopy_epoll_oneshot.pkt
tools/testing/selftests/net/packetdrill/tcp_zerocopy_fastopen-client.pkt
tools/testing/selftests/net/packetdrill/tcp_zerocopy_fastopen-server.pkt
tools/testing/selftests/net/packetdrill/tcp_zerocopy_maxfrags.pkt
tools/testing/selftests/net/packetdrill/tcp_zerocopy_small.pkt

If you have the packetdrill command installed those _should_ be
relatively easy to run via standard kselftest commands


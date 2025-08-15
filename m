Return-Path: <kvm+bounces-54798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB1A5B28336
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 17:48:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D8EBB04D1F
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 15:48:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26C5D308F2C;
	Fri, 15 Aug 2025 15:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SgIX7RTv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3118F23ABA7;
	Fri, 15 Aug 2025 15:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755272887; cv=none; b=XYffcL1rhAIGE05IcyM81LxVjxt7+cnECN4qs0wXjl0TZmRq4mbuzN/ajUbopUSbbAHoGnTwTz3JPog46gxy4NlGJCHz9uFieSMB8RIfVonfXDMILybfhYyaU5zntCY8HU5IftMbP47s2G8psG5JAaIuLoW5oiAnq4c6TVonKlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755272887; c=relaxed/simple;
	bh=7J7O8B58402DZIOvOG4YVrzlmAE/IexxgXMdQIJautM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UPS8ZiFookzKzMP7UMKf+h+IqwlmTKRyuzBY+rknODtYGdCRRgU6/skgzgVLYQ44JR6kHhCfAiDlVRGEzNqJJu54tpOWfs6JJxrrC5AlKrw+5RWyaW/auZJSAYu7P/V7A/cS3ZXHY37DfTCcuiNkpKPoWJN3taDuXYBv5v2uyW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SgIX7RTv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20D3C4CEEB;
	Fri, 15 Aug 2025 15:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755272886;
	bh=7J7O8B58402DZIOvOG4YVrzlmAE/IexxgXMdQIJautM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SgIX7RTvZhmiYGgeJf8Xyi9SvoEvPcefxLNIy9s4Z9gG3L5ZWH79RGsHSGb+rp2PV
	 tLBsXdREfvDfAYCiu+Tp40vAum4zf3YARXmA/6zN2iuCkaRLoOI08otWwe97Pz9f1O
	 1Wfml97ZFvrRUUKHcRvecmvwjGF0Vu2toJionb24DxUCcxKAatt3wSPkTlmv8p4FmU
	 SzhdChi6CfdVphvLbOETvRsHKhWDfhBLwmvO4PsnwHFWm5srZiYTh/P/6OyuF1Vgfn
	 vxESvslwC+72+Vsa/ReF8Rjun4p9kuGhEDDlLZcFqHTK9Rh8K5kYSWz21e9OnkWBNz
	 u1mbsVQqwUwLA==
Date: Fri, 15 Aug 2025 16:48:00 +0100
From: Will Deacon <will@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: syzbot <syzbot+b4d960daf7a3c7c2b7b1@syzkaller.appspotmail.com>,
	davem@davemloft.net, edumazet@google.com, eperezma@redhat.com,
	horms@kernel.org, jasowang@redhat.com, kuba@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, pabeni@redhat.com, sgarzare@redhat.com,
	stefanha@redhat.com, syzkaller-bugs@googlegroups.com,
	virtualization@lists.linux.dev, xuanzhuo@linux.alibaba.com
Subject: Re: [syzbot] [kvm?] [net?] [virt?] WARNING in
 virtio_transport_send_pkt_info
Message-ID: <aJ9WsFovkgZM3z09@willie-the-truck>
References: <20250812052645-mutt-send-email-mst@kernel.org>
 <689b1156.050a0220.7f033.011c.GAE@google.com>
 <20250812061425-mutt-send-email-mst@kernel.org>
 <aJ8HVCbE-fIoS1U4@willie-the-truck>
 <20250815063140-mutt-send-email-mst@kernel.org>
 <aJ8heyq4-RtJAPyI@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJ8heyq4-RtJAPyI@willie-the-truck>

On Fri, Aug 15, 2025 at 01:00:59PM +0100, Will Deacon wrote:
> On Fri, Aug 15, 2025 at 06:44:47AM -0400, Michael S. Tsirkin wrote:
> > On Fri, Aug 15, 2025 at 11:09:24AM +0100, Will Deacon wrote:
> > > On Tue, Aug 12, 2025 at 06:15:46AM -0400, Michael S. Tsirkin wrote:
> > > > On Tue, Aug 12, 2025 at 03:03:02AM -0700, syzbot wrote:
> > > > > Hello,
> > > > > 
> > > > > syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> > > > > WARNING in virtio_transport_send_pkt_info
> > > > 
> > > > OK so the issue triggers on
> > > > commit 6693731487a8145a9b039bc983d77edc47693855
> > > > Author: Will Deacon <will@kernel.org>
> > > > Date:   Thu Jul 17 10:01:16 2025 +0100
> > > > 
> > > >     vsock/virtio: Allocate nonlinear SKBs for handling large transmit buffers
> > > >     
> > > > 
> > > > but does not trigger on:
> > > > 
> > > > commit 8ca76151d2c8219edea82f1925a2a25907ff6a9d
> > > > Author: Will Deacon <will@kernel.org>
> > > > Date:   Thu Jul 17 10:01:15 2025 +0100
> > > > 
> > > >     vsock/virtio: Rename virtio_vsock_skb_rx_put()
> > > >     
> > > > 
> > > > 
> > > > Will, I suspect your patch merely uncovers a latent bug
> > > > in zero copy handling elsewhere.
> 
> I'm still looking at this, but I'm not sure zero-copy is the right place
> to focus on.
> 
> The bisected patch 6693731487a8 ("vsock/virtio: Allocate nonlinear SKBs
> for handling large transmit buffers") only has two hunks. The first is
> for the non-zcopy case and the latter is a no-op for zcopy, as
> skb_len == VIRTIO_VSOCK_SKB_HEADROOM and so we end up with a linear SKB
> regardless.

It's looking like this is caused by moving from memcpy_from_msg() to
skb_copy_datagram_from_iter(), which is necessary to handle non-linear
SKBs correctly.

In the case of failure (i.e. faulting on the source and returning
-EFAULT), memcpy_from_msg() rewinds the message iterator whereas
skb_copy_datagram_from_iter() does not. If we have previously managed to
transmit some of the packet, then I think
virtio_transport_send_pkt_info() can end up returning a positive "bytes
written" error code and the caller will call it again. If we've advanced
the message iterator, then this can end up with the reported warning if
we run out of input data.

As a hack (see below), I tried rewinding the iterator in the error path
of skb_copy_datagram_from_iter() but I'm not sure whether other callers
would be happy with that. If not, then we could save/restore the
iterator state in virtio_transport_fill_skb() if the copy fails. Or we
could add a variant of skb_copy_datagram_from_iter(), say
skb_copy_datagram_from_iter_full(), which has the rewind behaviour.

What do you think?

Will

--->8

diff --git a/net/core/datagram.c b/net/core/datagram.c
index 94cc4705e91d..62e44ab136b7 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -551,7 +551,7 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 				 int len)
 {
 	int start = skb_headlen(skb);
-	int i, copy = start - offset;
+	int i, copy = start - offset, start_off = offset;
 	struct sk_buff *frag_iter;
 
 	/* Copy header. */
@@ -614,6 +614,7 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 		return 0;
 
 fault:
+	iov_iter_revert(from, offset - start_off);
 	return -EFAULT;
 }
 EXPORT_SYMBOL(skb_copy_datagram_from_iter);


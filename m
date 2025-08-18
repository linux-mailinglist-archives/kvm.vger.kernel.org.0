Return-Path: <kvm+bounces-54892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09AD9B2AC15
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 17:06:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A11B96E03B9
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 14:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71BB52356BE;
	Mon, 18 Aug 2025 14:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M0Xg/oI1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8300735A2AC;
	Mon, 18 Aug 2025 14:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755528774; cv=none; b=Y0cdMexOI0nJVNRT/YnA3+DS/FGwb33J8U7Vu/AcH7Lz4WRApEAkNWCGBIGVBSOdFlkD3KWpkH1So/aW+M+xwGx6XoI4Q8srkLQUOZVXwPQjc8lqbyH60snWtr0PV5EXYkUiGDmDeMsG3Ul/4ohswLwmi9sdy41UUV7ptr63yW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755528774; c=relaxed/simple;
	bh=4Ezi4qd/vRMwuKHWb4eCTtPIoPzHHNvvx+V6bUm3ZAc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bIYcylDNkmkl8EnuKV0dL6GR7V6u2IuB2mq13uXsrh9S1vIqjwKAID3ZihHz0MPjXpb4xX2GC7ELCbYDKo/mcEVZd2M7OcUgaO2Dh4auA7LEm8lY6YMSZYrt+g2Ny1pIUj8uED4sSE3Bd/md+QEv+eyKDy/K0QY8fXTP7pZrJjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M0Xg/oI1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21466C4CEEB;
	Mon, 18 Aug 2025 14:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755528774;
	bh=4Ezi4qd/vRMwuKHWb4eCTtPIoPzHHNvvx+V6bUm3ZAc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M0Xg/oI17+ZOqL9ZkkNYDusfgbL/LP3b450AzcYAEvcjo2W69znvLDlRzH3enng21
	 EptpSPYGxWHbGpNy4TazNe6YrcNMrudiijpLhc4GqGpXVUyA7LPJrqXmAq8gNYtbEA
	 hC92ljJNREp12C2jaek/FqHr00FUZYCU2Os0Oar94Efqq3I6sLDcJLoNtykEkRqEi5
	 FPAIqYOYixVAPIbu43HjcN0mrTYxagAkJzBuY2MWiI2PdUlfySk1ViAbGnRuBcCZ0E
	 Ry1vkruVWibUEWFvUnUgPSYJN2/DljlJObOhf/lIGDHQvD0pfb/+eGYuqK/twc+HD7
	 u4aQeyv/9hDZw==
Date: Mon, 18 Aug 2025 15:52:47 +0100
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
Message-ID: <aKM-P7LJTIPZIi6v@willie-the-truck>
References: <20250812052645-mutt-send-email-mst@kernel.org>
 <689b1156.050a0220.7f033.011c.GAE@google.com>
 <20250812061425-mutt-send-email-mst@kernel.org>
 <aJ8HVCbE-fIoS1U4@willie-the-truck>
 <20250815063140-mutt-send-email-mst@kernel.org>
 <aJ8heyq4-RtJAPyI@willie-the-truck>
 <aJ9WsFovkgZM3z09@willie-the-truck>
 <20250816063301-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816063301-mutt-send-email-mst@kernel.org>

On Sat, Aug 16, 2025 at 06:34:29AM -0400, Michael S. Tsirkin wrote:
> On Fri, Aug 15, 2025 at 04:48:00PM +0100, Will Deacon wrote:
> > On Fri, Aug 15, 2025 at 01:00:59PM +0100, Will Deacon wrote:
> > > On Fri, Aug 15, 2025 at 06:44:47AM -0400, Michael S. Tsirkin wrote:
> > > > On Fri, Aug 15, 2025 at 11:09:24AM +0100, Will Deacon wrote:
> > > > > On Tue, Aug 12, 2025 at 06:15:46AM -0400, Michael S. Tsirkin wrote:
> > > > > > On Tue, Aug 12, 2025 at 03:03:02AM -0700, syzbot wrote:
> > > > > > > Hello,
> > > > > > > 
> > > > > > > syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> > > > > > > WARNING in virtio_transport_send_pkt_info
> > > > > > 
> > > > > > OK so the issue triggers on
> > > > > > commit 6693731487a8145a9b039bc983d77edc47693855
> > > > > > Author: Will Deacon <will@kernel.org>
> > > > > > Date:   Thu Jul 17 10:01:16 2025 +0100
> > > > > > 
> > > > > >     vsock/virtio: Allocate nonlinear SKBs for handling large transmit buffers
> > > > > >     
> > > > > > 
> > > > > > but does not trigger on:
> > > > > > 
> > > > > > commit 8ca76151d2c8219edea82f1925a2a25907ff6a9d
> > > > > > Author: Will Deacon <will@kernel.org>
> > > > > > Date:   Thu Jul 17 10:01:15 2025 +0100
> > > > > > 
> > > > > >     vsock/virtio: Rename virtio_vsock_skb_rx_put()
> > > > > >     
> > > > > > 
> > > > > > 
> > > > > > Will, I suspect your patch merely uncovers a latent bug
> > > > > > in zero copy handling elsewhere.
> > > 
> > > I'm still looking at this, but I'm not sure zero-copy is the right place
> > > to focus on.
> > > 
> > > The bisected patch 6693731487a8 ("vsock/virtio: Allocate nonlinear SKBs
> > > for handling large transmit buffers") only has two hunks. The first is
> > > for the non-zcopy case and the latter is a no-op for zcopy, as
> > > skb_len == VIRTIO_VSOCK_SKB_HEADROOM and so we end up with a linear SKB
> > > regardless.
> > 
> > It's looking like this is caused by moving from memcpy_from_msg() to
> > skb_copy_datagram_from_iter(), which is necessary to handle non-linear
> > SKBs correctly.
> > 
> > In the case of failure (i.e. faulting on the source and returning
> > -EFAULT), memcpy_from_msg() rewinds the message iterator whereas
> > skb_copy_datagram_from_iter() does not. If we have previously managed to
> > transmit some of the packet, then I think
> > virtio_transport_send_pkt_info() can end up returning a positive "bytes
> > written" error code and the caller will call it again. If we've advanced
> > the message iterator, then this can end up with the reported warning if
> > we run out of input data.
> > 
> > As a hack (see below), I tried rewinding the iterator in the error path
> > of skb_copy_datagram_from_iter() but I'm not sure whether other callers
> > would be happy with that. If not, then we could save/restore the
> > iterator state in virtio_transport_fill_skb() if the copy fails. Or we
> > could add a variant of skb_copy_datagram_from_iter(), say
> > skb_copy_datagram_from_iter_full(), which has the rewind behaviour.
> > 
> > What do you think?
> > 
> > Will
> 
> It is, at least, self-contained. I don't much like hacking around
> it in virtio_transport_fill_skb. If your patch isn't acceptable,
> skb_copy_datagram_from_iter_full seem like a better approach, I think.

Thanks. I'll send something out shortly with you on cc.

Will


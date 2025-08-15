Return-Path: <kvm+bounces-54785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 788DCB27FA7
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 14:01:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5386AAC748F
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 12:01:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AA5B3002D5;
	Fri, 15 Aug 2025 12:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TduMfL/n"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F30CA935;
	Fri, 15 Aug 2025 12:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755259266; cv=none; b=X01JkQ/YshlbJnGyjr3DBwrYLxsDx25wc+487zDSYxgJpXdIVrHxcYtBXCpnea7LiZvRiNFbjNVHgToL5NACG0aCfZzcJOfT2wKDAQsWaRLYpSgjkV+pwqwnE6dL8j11XW7EZ7d1mSZZXjMipT/7x9DvFltFlD0OLDrWqtNb0aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755259266; c=relaxed/simple;
	bh=dXRcxOAtorbhC+j9x/ix2NWzVwiygbqH+TVgVVdI9dc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LpKZLBkXe7ZxgnwZBd7DVti/4mDCWo7+5EO4JYohN8yn72FYJLNbV7EYNwhTgfGwIplnicJE+EaLlA78mQb0SSo47KUcL2aU8QusRdLs6CRs5ebvUUsQCyHBQEuavc11qs2Xp5vfdbnUwQW8XMJxi4e/HpDo81AO4Ypmcl4/zu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TduMfL/n; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D5AC4CEEB;
	Fri, 15 Aug 2025 12:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755259265;
	bh=dXRcxOAtorbhC+j9x/ix2NWzVwiygbqH+TVgVVdI9dc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TduMfL/nzSbkpOOvqdX3oBp+NFTAFSi3zaRYqWOyKvmhKtVKGcsY353pdgMgUuLPu
	 q/+qwrm3o6Dd9sMhHaGMETUSv0c/XF4vn0cKgfS+o2+vYr5I+dDLfJk/rABXIWoq4E
	 tqSMsjgi09mhZJUZZ0KIN8vy2dLApBrpHdOMkKN7h+iYpJsFVQE5cwsqlt8VQc2Wh6
	 XOWCGqN8i6psXa385oOZnzA+8nRQuIbVHbcbUsHMUWDOfBwvNu16rd++4zpBA/zoYL
	 dvvXbmAkUMkKdoZ9xr5LISWFkC1HQ546TIu3FAmYIhakhUuIzfiiMcXNM4qR8lEc2N
	 LiPQzm68j6P0w==
Date: Fri, 15 Aug 2025 13:00:59 +0100
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
Message-ID: <aJ8heyq4-RtJAPyI@willie-the-truck>
References: <20250812052645-mutt-send-email-mst@kernel.org>
 <689b1156.050a0220.7f033.011c.GAE@google.com>
 <20250812061425-mutt-send-email-mst@kernel.org>
 <aJ8HVCbE-fIoS1U4@willie-the-truck>
 <20250815063140-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815063140-mutt-send-email-mst@kernel.org>

On Fri, Aug 15, 2025 at 06:44:47AM -0400, Michael S. Tsirkin wrote:
> On Fri, Aug 15, 2025 at 11:09:24AM +0100, Will Deacon wrote:
> > On Tue, Aug 12, 2025 at 06:15:46AM -0400, Michael S. Tsirkin wrote:
> > > On Tue, Aug 12, 2025 at 03:03:02AM -0700, syzbot wrote:
> > > > Hello,
> > > > 
> > > > syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> > > > WARNING in virtio_transport_send_pkt_info
> > > 
> > > OK so the issue triggers on
> > > commit 6693731487a8145a9b039bc983d77edc47693855
> > > Author: Will Deacon <will@kernel.org>
> > > Date:   Thu Jul 17 10:01:16 2025 +0100
> > > 
> > >     vsock/virtio: Allocate nonlinear SKBs for handling large transmit buffers
> > >     
> > > 
> > > but does not trigger on:
> > > 
> > > commit 8ca76151d2c8219edea82f1925a2a25907ff6a9d
> > > Author: Will Deacon <will@kernel.org>
> > > Date:   Thu Jul 17 10:01:15 2025 +0100
> > > 
> > >     vsock/virtio: Rename virtio_vsock_skb_rx_put()
> > >     
> > > 
> > > 
> > > Will, I suspect your patch merely uncovers a latent bug
> > > in zero copy handling elsewhere.

I'm still looking at this, but I'm not sure zero-copy is the right place
to focus on.

The bisected patch 6693731487a8 ("vsock/virtio: Allocate nonlinear SKBs
for handling large transmit buffers") only has two hunks. The first is
for the non-zcopy case and the latter is a no-op for zcopy, as
skb_len == VIRTIO_VSOCK_SKB_HEADROOM and so we end up with a linear SKB
regardless.

I'll keep digging...

Will


Return-Path: <kvm+bounces-54779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E313DB27E0E
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 12:14:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0220685F88
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 10:09:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5D132FDC32;
	Fri, 15 Aug 2025 10:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eT8QeuIm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE580279DAA;
	Fri, 15 Aug 2025 10:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755252571; cv=none; b=MH/ww9XU4je3c52mHnM8nAKD5/lEnLJ1SbFfVPX9YQV3MtwNOSfmq5iDXIJKScm2JL+jcjNnZ4IB31tDuSMrzuW4ni36LtCbmfx6B3/8yfCI6KvkaWwN2Gc91Z7giPUgG6YwDP/0efm1DBmAIOqLqrNxnSDd+dyU10RP/y8k58Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755252571; c=relaxed/simple;
	bh=4F6G06c4lwRmjRxDA3kCpdM0Fpzl2wgfCSFO8ncYib4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N+t4SwBJZkd2wzUCfSzXnIVglBco151MXU1TiUxAXjmwg7Jc2X7rUZJ3SJzu6B5KO7PqJB9ISIMOE7TLiK+N42IK7yLtFBuZZ1k6sXe64JHK3fzdebrxNibrFIfLKMOuQzg71dkJSL92q5Ru0EQzqIjix+dE9TeDkiS83zzToq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eT8QeuIm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E8AC4CEF5;
	Fri, 15 Aug 2025 10:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755252570;
	bh=4F6G06c4lwRmjRxDA3kCpdM0Fpzl2wgfCSFO8ncYib4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eT8QeuImN6Mc0M1N8IPUm86ATESY2jDh0jxkLdPIjuGK8mAZmv5TpZTtKrziii0BK
	 iD4JcFBmZ+82M6OZlZj7XpbT8ro/alnxe9WxMgx1GTGwV3Caeh7PSIIDZoDzahXIju
	 eEGaJN277PxU+EIbTJzqPAA9qTxytkAviEc/bXpbkO0Mlv/m83XUnyuROb21Jrgf3m
	 /wOVlwFzaFELgaexErcumbgtSSmbyVbRoVeV26Z+7j29CHtlOLa2qkJnGJ3wU0a4RJ
	 PbCIsd1AupDwoRKhwl2PvHb2CH0jKsuXlTR8yE5DXNfq3uFPDWqGBfIWM0IWQ0lOhl
	 OWc75fokBhfDg==
Date: Fri, 15 Aug 2025 11:09:24 +0100
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
Message-ID: <aJ8HVCbE-fIoS1U4@willie-the-truck>
References: <20250812052645-mutt-send-email-mst@kernel.org>
 <689b1156.050a0220.7f033.011c.GAE@google.com>
 <20250812061425-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812061425-mutt-send-email-mst@kernel.org>

On Tue, Aug 12, 2025 at 06:15:46AM -0400, Michael S. Tsirkin wrote:
> On Tue, Aug 12, 2025 at 03:03:02AM -0700, syzbot wrote:
> > Hello,
> > 
> > syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> > WARNING in virtio_transport_send_pkt_info
> 
> OK so the issue triggers on
> commit 6693731487a8145a9b039bc983d77edc47693855
> Author: Will Deacon <will@kernel.org>
> Date:   Thu Jul 17 10:01:16 2025 +0100
> 
>     vsock/virtio: Allocate nonlinear SKBs for handling large transmit buffers
>     
> 
> but does not trigger on:
> 
> commit 8ca76151d2c8219edea82f1925a2a25907ff6a9d
> Author: Will Deacon <will@kernel.org>
> Date:   Thu Jul 17 10:01:15 2025 +0100
> 
>     vsock/virtio: Rename virtio_vsock_skb_rx_put()
>     
> 
> 
> Will, I suspect your patch merely uncovers a latent bug
> in zero copy handling elsewhere.
> Want to take a look?

Sorry for the delay, I was debugging something else!

I see Hillf already tried some stuff in the other thread, but I can take
a look as well.

Will


Return-Path: <kvm+bounces-364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E4B747DEC36
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 06:21:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5D48EB211DA
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 05:20:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C9DE4432;
	Thu,  2 Nov 2023 05:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YwvoDwyl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06FB1FA7;
	Thu,  2 Nov 2023 05:20:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B99C433C7;
	Thu,  2 Nov 2023 05:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698902447;
	bh=YhTfqLur7/NQtlk8H9Cl3X4eNRRBK1DfeII4CpjFXWA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YwvoDwylHxhrQyMNZbt0YmegaTf9VzAd4jgxPYpYAtTO7666H2DmLp8VFckNRA7h1
	 MMgYO7qoq1L+fb9FEEvfpWyPcBvJSHz0jDxas40g1w+CMBmtqL4HomNCruvYXQUu6h
	 MdoRq11FdCH0bqi9SUsWu0BNt6L6jwgdPj+mj9HDCTnxoVTTqUmNDuXPE/9bXHl425
	 NVBxLI5LTI2EfOQHyIVSlTpBEKh9gy15O/+HvoojJmvaQ/5eAaA9U41USFeRQpZCj9
	 rYPr6zaDl6y5IMr6Uy2isOl4Ul8QenaA9LN6IG/iWVE5Uz+XegdK3EjzVXBM03nvFt
	 ZMMDQT1Q4fIig==
Date: Wed, 1 Nov 2023 22:20:45 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Shigeru Yoshida <syoshida@redhat.com>
Cc: stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] virtio/vsock: Fix uninit-value in
 virtio_transport_recv_pkt()
Message-ID: <20231101222045.5f7cca01@kernel.org>
In-Reply-To: <20231026150154.3536433-1-syoshida@redhat.com>
References: <20231026150154.3536433-1-syoshida@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 27 Oct 2023 00:01:54 +0900 Shigeru Yoshida wrote:
> This issue occurs because the `buf_alloc` and `fwd_cnt` fields of the
> `struct virtio_vsock_hdr` are not initialized when a new skb is allocated
> in `virtio_transport_alloc_skb()`. This patch resolves the issue by
> initializing these fields during allocation.

We didn't manage to apply this before the merge window, and now the
trees have converged. Patch no longer applies cleanly to net.
Please rebase & repost.
-- 
pw-bot: cr


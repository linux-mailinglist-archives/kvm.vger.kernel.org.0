Return-Path: <kvm+bounces-52677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 55924B08142
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 02:04:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D101170B56
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 00:04:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B201629D0E;
	Thu, 17 Jul 2025 00:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ifS5K02q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB68C2904;
	Thu, 17 Jul 2025 00:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752710647; cv=none; b=pDLjw/vswQyXy6cGX4Mwu5MYjpHAPaPfamjeisOvm5JC/k7LgLQ/fg1lh2dHq7dkaaWNNAtHo3LFUDfaZaSh+tdM/POYSnEtFJhE/LHfEyt0Ca0oqNjGC3sDWkg0FxbfV95P2QEsSvrFfImSBSpxgkLt0HVcWB/G0SUApnNBgP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752710647; c=relaxed/simple;
	bh=DpWiesLa7vbS826EtQoWeBav2x/WTnA3BZlee6Q5GQc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hQydECjk+CSqWXhh91MKq7/rFyiKvzvfc1zTlbqj79LcCA3R1K/kCDj+JaEbFD26t2J5+Yg6JRLYI1hN1HnUx9h2gveHM6o0oyeHiGwj+tQ071H4vdzU7e3S6+KAMUi6NmA8Xg3b8xN5OLpK38Zfqo7vB0U7mcWsyJudUNL7eQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ifS5K02q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D81FC4CEE7;
	Thu, 17 Jul 2025 00:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752710647;
	bh=DpWiesLa7vbS826EtQoWeBav2x/WTnA3BZlee6Q5GQc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ifS5K02q06JStZdhQeWA3FvuMvvuxaR6z3+6afUNNNUbRf6HY+I1ZjF+VEwYTVzIG
	 48DxVMyuQ7u9DswPj5nWMz9EpuYhKPFE4I/Y5+5onoGiJ/MMQ8zkByaNBT14K08g0G
	 u78wx0C1pt3a8rbr9Fe+Yd+fmaPg5dzHx/xP4RIKpNHiluW7yxUo78I4yTyF79AekQ
	 9Px4wXGexik2KuUE9bbxwO0JJWI+pSfCEs+v+csx24kksAqhJLvZfQukDfrqZJlUcq
	 elNR0LHjdIzYvAJx+OSfQ7rPOusFSM/7TCzBFX2uOCbMHaWVdZS7Kt88+H3hKWCmqB
	 kQqb4QZ0w7PNw==
Date: Wed, 16 Jul 2025 17:04:06 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jason Wang <jasowang@redhat.com>
Cc: mst@redhat.com, eperezma@redhat.com, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, jonah.palmer@oracle.com
Subject: Re: [PATCH net-next V2 0/3] in order support for vhost-net
Message-ID: <20250716170406.637e01f5@kernel.org>
In-Reply-To: <20250714084755.11921-1-jasowang@redhat.com>
References: <20250714084755.11921-1-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 14 Jul 2025 16:47:52 +0800 Jason Wang wrote:
> This series implements VIRTIO_F_IN_ORDER support for vhost-net. This
> feature is designed to improve the performance of the virtio ring by
> optimizing descriptor processing.
> 
> Benchmarks show a notable improvement. Please see patch 3 for details.

You tagged these as net-next but just to be clear -- these don't apply
for us in the current form.


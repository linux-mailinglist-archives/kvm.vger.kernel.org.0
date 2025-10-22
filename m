Return-Path: <kvm+bounces-60793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 34E87BF9B60
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 04:21:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 35814188039B
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 02:21:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9C5221FF30;
	Wed, 22 Oct 2025 02:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="MUDpJNL6"
X-Original-To: kvm@vger.kernel.org
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BEA1F7580;
	Wed, 22 Oct 2025 02:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761099666; cv=none; b=DXx46c88GC/KBjYjrJEANtcKLHcJCXKMvWIiQ8zsP+AcAZQjOpz+nGARymXaxLhw1iY//661PZDjhC7jDjxUzEUjXI6HHLK0Y6l/7fORLcQG85To7LTD/ueUQv9TfN/uDWSkEuiesuapUAYwkv/9SlLUrijR2Z2qRnSnmNOMqT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761099666; c=relaxed/simple;
	bh=16KFnA4NoEBxZ+Pe7rN2Vjt7kHABx+RK9w4cgVMEyIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XwuevSFVWoQbpzEo6oF/2nk2dNH1Q8J0oIVHpSTZlxcjGVCKndH6L16TXoR8HVGCYgGJkP4GGeGxdIoYF7ygkjcixoaXDd5brMb91Jr9LxRZ9nrYA7Jtrjsq0JJDQuvoh/mWo3b/xCOtvxruWkVaV4CnKHYTrBNImEHT/Vk9dOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=MUDpJNL6; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=6RFJilJdKj46N0sK2TzoAhWSxeTUKkqdVtOb7d7qsBQ=; b=MUDpJNL6r6j1PkzdDAKco9/T2/
	kX1CD5ZJX38zmHStdn6dJsLqSlFUUh+CsGfAbimAqyDINq3YRbOgjWPogLV+DVa1vSzEaqxe3aBIx
	JryZBr1CXvTLNCG1dxeW+n8s7zEmib9/wBK6VYRWoiLXE1jCPOubfjVMZcYROTXJEwrA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1vBOT6-00Bhav-7w; Wed, 22 Oct 2025 04:20:52 +0200
Date: Wed, 22 Oct 2025 04:20:52 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 1/2] virtio: clean up features qword/dword terms
Message-ID: <8138fb02-f7c5-4c83-a4cb-d86412d8c048@lunn.ch>
References: <cover.1761058274.git.mst@redhat.com>
 <492ef5aaa196d155d0535b5b6f4ad5b3fba70a1b.1761058528.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492ef5aaa196d155d0535b5b6f4ad5b3fba70a1b.1761058528.git.mst@redhat.com>

> @@ -1752,7 +1752,7 @@ static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
>  
>  		/* Copy the net features, up to the user-provided buffer size */
>  		argp += sizeof(u64);
> -		copied = min(count, VIRTIO_FEATURES_DWORDS);
> +		copied = min(count, (u64)VIRTIO_FEATURES_ARRAY_SIZE);

Why is the cast needed? Why was 2 O.K, but (128 >> 6) needs a cast?

> -#define VIRTIO_FEATURES_DWORDS	2
> -#define VIRTIO_FEATURES_MAX	(VIRTIO_FEATURES_DWORDS * 64)
> -#define VIRTIO_FEATURES_WORDS	(VIRTIO_FEATURES_DWORDS * 2)
> +#define VIRTIO_FEATURES_BITS	(128)
>  #define VIRTIO_BIT(b)		BIT_ULL((b) & 0x3f)
> -#define VIRTIO_DWORD(b)		((b) >> 6)
> +#define VIRTIO_U64(b)		((b) >> 6)
> +
> +#define VIRTIO_FEATURES_ARRAY_SIZE VIRTIO_U64(VIRTIO_FEATURES_BITS)

	Andrew


Return-Path: <kvm+bounces-22681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E0F09415A6
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 17:47:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 101A11F25225
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 15:47:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A66061BA865;
	Tue, 30 Jul 2024 15:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DiaPHkjE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36BD1B5808;
	Tue, 30 Jul 2024 15:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354429; cv=none; b=B7GV+n3PfhnMYR1Cc0Dr60JSFhkc6v6rIZeyhjLZaYiYegNSdV2Kbeqb4gGkz/6LVO599hdeRHBL3zTZOjhaoChtQWbM30HBBOboC3vXbkfpg6yYdTejfpVCm9SESPOaNDJPtSxEs5ENK7ZL9bRmrQBRnEInidPSiTBCAjf7F70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354429; c=relaxed/simple;
	bh=tZTmCW5GZ93dLZfDm1v8+9DRshuBQgUPfGjqVhe9ZhM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GExNrvBR8GblsvZByQBjJZRnWpFplZsyKNyqZ0U2g077GezuCT3EwZueu9t9bbRenYr/YLW7wSeI6TQUUVys2TDOANOlHoOzzS7FnFyVhpcHc3X/zlN3eMgPjlL48jKNj10vPBpPLWtvrUjAM2ZBJdqtOSQuDJlz1jpdBQds96M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DiaPHkjE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5C0C32782;
	Tue, 30 Jul 2024 15:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722354429;
	bh=tZTmCW5GZ93dLZfDm1v8+9DRshuBQgUPfGjqVhe9ZhM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DiaPHkjErpIoh7tbTHA2BkSuyZEHOL2luROddx81dyCDgV/01X9oMpto6T6HMOuiW
	 eufkPP1TytFgdz6OiWzOStPlVMJPLLM+woeYyq1qNZc6jz2u6LijjWnkx3EQ5vfn5i
	 RwYmufBnLVyPFnfnCubsnk4XE0JfPj5EaYk3PIcLiPzgHACZcf0bvmEeSCAvBjNBhO
	 2V9TRCEurUbvSJrhoEiZsYOYigVH5e91KIgEFU7UkLxp3TLGMOSou5fQvsC/BV9oAF
	 +uXf06D8Js/wPCs4W8Tz+rKxQG+pbHZuFFdR8RRLUzDYE6OYt14MnFqOFuuS3+Dki8
	 E4h74czh47JzA==
Date: Tue, 30 Jul 2024 08:47:07 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
 <sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, "Michael S.
 Tsirkin" <mst@redhat.com>, <kvm@vger.kernel.org>,
 <virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <kernel@sberdevices.ru>,
 <oxffffaa@gmail.com>
Subject: Re: [PATCH v1] MAINTAINERS: add me as reviewer of AF_VSOCK and
 virtio-vsock
Message-ID: <20240730084707.72ff802c@kernel.org>
In-Reply-To: <20240728183325.1295283-1-avkrasnov@salutedevices.com>
References: <20240728183325.1295283-1-avkrasnov@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 28 Jul 2024 21:33:25 +0300 Arseniy Krasnov wrote:
> I'm working on AF_VSOCK and virtio-vsock.

If you want to review the code perhaps you can use lore+lei
and filter on the paths?

Adding people to MAINTAINERS is somewhat fraught.


Return-Path: <kvm+bounces-65717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 32E4DCB4E13
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 07:32:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 443D93011FAA
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:32:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2407D29617D;
	Thu, 11 Dec 2025 06:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="eaJeKcQB"
X-Original-To: kvm@vger.kernel.org
Received: from out203-205-221-192.mail.qq.com (out203-205-221-192.mail.qq.com [203.205.221.192])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B174F24169D;
	Thu, 11 Dec 2025 06:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.192
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765434753; cv=none; b=NdEFWDRr7TtEt3+4tNgipmzXaW76YqZd/P6JaRyNtEqMt2YY8mgZVjNv3ckNOn6Yq2erzeWOQlF3gksoUyU+HFEhJLUpHKNQDUh/Xt7/pM/V4SxKwjUlUkWbNTq/VTGX/bNhYRgsU0ue/WEGln5ac3HaVTqnmMJiSf3kCaPzb+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765434753; c=relaxed/simple;
	bh=fIvPNLHeDzWJF31MVDenOR42FEqmZ79q0H8utAhI720=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=GtJ5JtPEY1VKyOT9yLqWzVHwgr0rvWdqSljhrl8wi7B+UvGKovITCN2s79MpcMF65AMdQ9qWDxykM7e4pJ+RQdUFCIOvqJqYD1U6DRXmYvJXdN9E23G19+G7u+xwIEUr64NCdcmWjSMFuMCL0NO1iG0/k/L6PMBcZkxJ4YKaM9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=eaJeKcQB; arc=none smtp.client-ip=203.205.221.192
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1765434742; bh=j9YJeKxZIVNEPnjmawJSw8tc2oM/QEMGoWkZljnyWFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eaJeKcQBlF8VpzSaRSU9J9OfWnQgEuBFJrBu4Ll2j9zInAuK/I+KUVNrougxX/qKF
	 UBlXY9InI2/0SYygm8WnMCNZ1CqPv6pMVxWcyFGu92kXud/4Y0ua1U52Q/a/EiFRVX
	 uf0Vj7bDbMzxdYEkA1UtsYwp9hxa+CdSwN4uCD2M=
Received: from lxu-ped-host.. ([111.201.7.117])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 81197280; Thu, 11 Dec 2025 14:32:17 +0800
X-QQ-mid: xmsmtpt1765434737t9ud65iy0
Message-ID: <tencent_62102EE16E389458E93EED06CEBC780A6D0A@qq.com>
X-QQ-XMAILINFO: N1p/MiiOj+Nxnc8ixv9aB6Cuhh1Kg38gNO1ezC8t5gz9BfwdrqVb1jlDr2wZOA
	 ERbWwQzhvvNcEptlPvLm+td0AOlAyg5AN2J3aaF8+idRx3D+9zZdJ19JMlV7n2dKYbqq9EAk/4qt
	 OBUcHMcc0ldyIbIKMEbz6NcMNQgTMhpHzF/NSxxJ7nuWQYHd+uos5B55s7giqxd7OTue4Gw1KqBa
	 J8VGyUfnDGp/Z7iTKEpGuJvKxo6PSGRvs/EWsK0FYUDg7ikGKsaAVcnRb3KFQKd8rn381898ajKy
	 d4/BXPOuxqQWaSCsu6UjF3kiCpDSUKdD38SvmaTjP9jkfwC14cVe8F1pOf26FlgkCfCar2nytGH+
	 Blld7Yx4IIpAu+ceG+ya6CPzlAgqdLgsf0cX0znwYWoQ7gXM+wG83ffi8njN6BRdhFXlDcyk53o2
	 q12DIDhLUwwo8B3pmgLgoz9Ds2M8seYyY7P+hJe+MIWjuFNcpZicMKJ1sVlPdiW4BQX6WOTO8/ap
	 MVsBTpiPS6WcOjqngH8JtQyW4LI70PWVBfCvMD4M0l1tfi3smcXoUBbvzBy+UzFP9lBOrvBucnJf
	 hV7jETV8CRccEMNhJslep92QxBwezHtEcIX0IcrGfdKeS4gjSuiioL6zM7RAegeA2TCaWuN7p4Bh
	 xBJpM7TVFvCc3g1cjKCUZ9qbFqWYDCFIOk90wElp1MyHI8AnwFWuJPdBt2l/ai59w7meXhM/X+kc
	 MVTLl0kOOrd3sKN1AHO1Wty8xTYp0SA+p45I4lKoXIzffhbpYGpmDGaW/GbuEKkDkJvUKv2OvS6Z
	 9fElMXys2KLlGlCeehKEfc9mWC+8YM0NRTSnfhHrtwRLngvT6xWcVV0mJbsM8MlRVw9SAJlaukBg
	 C9fSE7MK2Jss8MctRniiF4aN9pCLmfyorNNOQeQb72xZmSlKYwl4kyvhuiu+QKyVFOctV9yIiL2V
	 3Ks5p1rCHknj7egVgRAg0UaFbfunHL5A8hesQWabzOHpWpLHjgTvFeIaIYeHErVzMhlZYCF7laAM
	 OOpTW77eg+7hhJAW2W1ya4q00FRTEae03LaB6/zA==
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
From: Edward Adam Davis <eadavis@qq.com>
To: kuba@kernel.org
Cc: davem@davemloft.net,
	eadavis@qq.com,
	edumazet@google.com,
	eperezma@redhat.com,
	horms@kernel.org,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	sgarzare@redhat.com,
	stefanha@redhat.com,
	syzbot+ci3edb9412aeb2e703@syzkaller.appspotmail.com,
	syzbot@lists.linux.dev,
	syzbot@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	virtualization@lists.linux.dev,
	xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH net-next V3] net: restore the iterator to its original state when an error occurs
Date: Thu, 11 Dec 2025 14:32:18 +0800
X-OQ-MSGID: <20251211063217.38761-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251211142142.18a4a0b2@kernel.org>
References: <20251211142142.18a4a0b2@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 11 Dec 2025 14:21:42 +0900, Jakub Kicinski wrote:
> > > Have you investigated the other callers? Given problems with previous
> > > version of this patch I'm worried you have not. If you did please extend
> > > the commit message with the appropriate explanation.
> > Are you asking if I investigated other zerocopy tests? NO.
> 
> I said callers. You're changing behavior of a function, is it going
> to break any of the callers.
I investigated the relevant callers and found no similar restore/revert
operations. Furthermore, if such a restore action existed, the ZC
related test programs would have detected it, just as the tests
detected the revert operation in skb_zerocopy_iter_stream().



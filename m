Return-Path: <kvm+bounces-51240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 34C8AAF07C9
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 03:09:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 214067A47B2
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 01:08:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EB7F1531C1;
	Wed,  2 Jul 2025 01:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fbu//ySj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2311172637;
	Wed,  2 Jul 2025 01:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751418569; cv=none; b=pxkNwQUux8r8kPa0MqerM2T/r3YS9ZVjHKMshroAhmj6wC/3bxKNrG+CK9okQuFAe+R+EcbtO0B2jQ+ZD7B1PbVVU8tL62rnL2pRy12nJT6tcLlG/GXegaPt7hR6HEkFNjU7uDQRazM3UVK6hUhQy1MdExxaPskMdephvpwQI3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751418569; c=relaxed/simple;
	bh=0o0wRFAYo3frYpL5CxH0azZzaVynr7Ij6Crcq1EUnCQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CR+/DjqJKhsnkFJhixNDb3stZ+V+LcFstXN5q+CvaB3DHOzGLRvS2lj9DyJ+2Q4EEsoRrht19a7yaOzdAdKl3JWN2sknzB2f2RjuuJpQ0x1BYIsQ68XmJd44BIeTULwFO69F4mV5fAMTwjRxzA+fygf1azNa6GaN3Wu2o3EEdmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fbu//ySj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42ACAC4CEEB;
	Wed,  2 Jul 2025 01:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751418568;
	bh=0o0wRFAYo3frYpL5CxH0azZzaVynr7Ij6Crcq1EUnCQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fbu//ySjN7rgghkCLKMhxM8JGuQ2LFhZ+EZjmyqdIv1UZH58VP4w4nOLJ/rQsvDHY
	 23RHVpIRmF21q2UQ3mJ0K96j4bwOer6Peag4rXo0gMM3o94V/eX4tL5zPotWLJ5H7z
	 3E2qH54C2Sn78sQge3a6wYexGzXBZi07v1okJk72+A0xtR8dTD7/5Ved8K2rCgktwC
	 CMLWiocn3WjhEphwjn76cPP2Zcwh5lAoYWAgx/nJF2hdjPlXm3pTjB3R6XJBFHSbHz
	 btcJPQ9r3XXZugHrbHPzGutb2f2w5tz4pETQykJbio76byyOgV4j8VHKuZX2Wj8Jgk
	 0snCnFpHRWAyA==
Date: Tue, 1 Jul 2025 18:09:27 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Xuewei Niu <niuxuewei97@gmail.com>
Cc: sgarzare@redhat.com, mst@redhat.com, pabeni@redhat.com,
 jasowang@redhat.com, xuanzhuo@linux.alibaba.com, davem@davemloft.net,
 netdev@vger.kernel.org, stefanha@redhat.com, leonardi@redhat.com,
 decui@microsoft.com, virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, fupan.lfp@antgroup.com, Xuewei Niu
 <niuxuewei.nxw@antgroup.com>
Subject: Re: [RESEND PATCH net-next v4 0/4] vsock: Introduce SIOCINQ ioctl
 support
Message-ID: <20250701180927.2cafbb5c@kernel.org>
In-Reply-To: <20250630075727.210462-1-niuxuewei.nxw@antgroup.com>
References: <20250630075727.210462-1-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 30 Jun 2025 15:57:23 +0800 Xuewei Niu wrote:
> Introduce SIOCINQ ioctl support for vsock, indicating the length of unread
> bytes.
> 
> Similar with SIOCOUTQ ioctl, the information is transport-dependent.

This series does not apply cleanly on current net-next.
Please rebase & repost.
Please note that we request that repost do not happen more often than
24 hours apart:
https://www.kernel.org/doc/html/next/process/maintainer-netdev.html
-- 
pw-bot: cr


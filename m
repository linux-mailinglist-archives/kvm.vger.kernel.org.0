Return-Path: <kvm+bounces-33396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 17BF59EABAE
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 10:15:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E84501647BE
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 09:15:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6DC7230D2C;
	Tue, 10 Dec 2024 09:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="LPY/1fEI"
X-Original-To: kvm@vger.kernel.org
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8CE231CA8;
	Tue, 10 Dec 2024 09:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733822103; cv=none; b=AwOygpxuQifho/WGiHMV9tGC0RxlWkIxesDnd2hCmLuxw8bHqMjSwsV5zrlJKCyU/vUU4gNMA6i4xHzwOq65cvKY/hMW9rupRws4BhzFAdI3zwn3XkGkdOjiTKEtlJahFQVddPOME65dz9lgNJTLvbXUu6OayB2iEm8UHjo+a4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733822103; c=relaxed/simple;
	bh=30Ayuuw1cnrbX0DsBQts/0gZotx7RHaYLBtKwdcmEj0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=bCDFRkUCp2fQq7f6+C5E6XIFqoXSF2lNjLZX/Ry4Nz6pOfadDF2jrNJnD455tJrMP+SQN2cRNgKpu8NPlvd1h5VyJAuX3XbCLKjnkVpSpagKfDOQCRO6eZQWjihAwGiD08R52NMznAmcL19cqv/Q/0ckNFaaheEF9ZLMvE+avYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=LPY/1fEI; arc=none smtp.client-ip=80.241.56.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4Y6t984dD7z9vCW;
	Tue, 10 Dec 2024 10:05:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1733821500;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=30Ayuuw1cnrbX0DsBQts/0gZotx7RHaYLBtKwdcmEj0=;
	b=LPY/1fEIN11iYQwn/WSZD1FuUHWycUSarHSAqSnXnUDs//QmnG2NcRUwEe+JE/B8GYyM/e
	/Uz0ebFxw8WEMFGaH/Bwj+JJYmKYLY6WWEoVu42j7rf14daFJOpiztyRnyB4ZZgqTU1zkn
	Hyt6z0pMcKQthW6N3reENMMqwDsCNVgEZCQsgl4goqmsfCDTfeWU7GGRMH+0r1KWA319c5
	AFUE6Hzc0OWZdlAHYxHc2Ytm2GytGwos19jemnC+qYUQrEg/1euNwqLrtxtyGYXgym/nty
	pcoHo5bqs0fvpjPgJatJc+NnQ4Y4nGaVCCp0dHOQiNyLrlywfeVvX+K+79E62g==
Message-ID: <52914da7-a97b-45ad-86a0-affdf8266c61@mailbox.org>
Date: Tue, 10 Dec 2024 10:04:59 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Simon Pilkington <simonp.git@mailbox.org>
Subject: [REGRESSION] from 74a0e79df68a8042fb84fd7207e57b70722cf825: VFIO PCI
 passthrough no longer works
To: seanjc@google.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 regressions@lists.linux.dev
Content-Language: en-GB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-MBO-RS-ID: 6ed77fe675b55b67d4a
X-MBO-RS-META: bz6n961okbjp4388iftg8xy7jt4oubqh

Hi,

With the aforementioned commit I am no longer able to use PCI
passthrough to a
Windows guest on the X570 chipset with a 5950X CPU.

The minimal reproducer for me is to attach a GPU to the VM and attempt
to start
Windows setup from an iso image. The VM will apparently livelock at the
setup splash
screen before the spinner appears as one of my CPU cores goes up to 100%
usage
until I force off the VM. This could be very machine-specific though.

Reverting to the old XOR check fixes both 6.12.y stable and 6.13-rc2 for me.
Otherwise they're both bad. Can you please look into it? I can share the
config
I used for test builds if it would help.

Regards,
Simon


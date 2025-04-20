Return-Path: <kvm+bounces-43703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 86B97A948DE
	for <lists+kvm@lfdr.de>; Sun, 20 Apr 2025 20:49:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2AD9B7A3549
	for <lists+kvm@lfdr.de>; Sun, 20 Apr 2025 18:48:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D20421146A;
	Sun, 20 Apr 2025 18:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wheres5.com header.i=@wheres5.com header.b="F7CWVKxw";
	dkim=pass (2048-bit key) header.d=wheres5.com header.i=@wheres5.com header.b="esiilfBq"
X-Original-To: kvm@vger.kernel.org
Received: from mailer-1.yeehaa.fr (mailer-1.yeehaa.fr [45.13.106.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47646210F58
	for <kvm@vger.kernel.org>; Sun, 20 Apr 2025 18:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.13.106.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745174942; cv=none; b=Y9cUOsZALOY/RmrTLWYwDhDlULoSY9Jwgv33+/kRW/oIITepKjCH+hDPCoVNSf01Vpo+jBkc1IeKnop1JlsRwGKHDUxsLG8GmSOdEcE00zTm7vxgdU7LbzGw/sWTclrLQ3Kxhipo4W6vVasGY1vi3UGUoj3etjumZvE44R1/RbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745174942; c=relaxed/simple;
	bh=EGrCZvuT3teIjiO7yOnGiLxySDkVoaAVxCcIiG2K5mA=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=q8oBzyGMpn3hmI32pVVWomQvNaGZoE3MxHswArh3lIKf95fvEqepDElCXUZSp/7Oi5bMdVLzrcezensqFGcEFd6BFfE78Nrp/b4y8198rQ39M/8hCDTI8BPdphaLjdHMVyEHbHY4IO1fOiL3iwypbTJIjNZl0UTYk5NCEbz2tAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wheres5.com; spf=pass smtp.mailfrom=wheres5.com; dkim=pass (2048-bit key) header.d=wheres5.com header.i=@wheres5.com header.b=F7CWVKxw; dkim=pass (2048-bit key) header.d=wheres5.com header.i=@wheres5.com header.b=esiilfBq; arc=none smtp.client-ip=45.13.106.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wheres5.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wheres5.com
Received: by mailer-1.yeehaa.fr (Postfix, from userid 5001)
	id 9B0C65DE43; Sun, 20 Apr 2025 20:44:17 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailer-1.yeehaa.fr 9B0C65DE43
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wheres5.com;
	s=20130910; t=1745174657;
	bh=ZaJdGIo2ZXZX29PEEtGsyLASNDxBpHTSEw/v2ch2u1E=;
	h=Date:To:From:Subject:From;
	b=F7CWVKxwXSG9qL873ApTSuDgaMHONFZaA1NpDsPZZj5qx4F6xTAbTbeCZoxELma9E
	 4aiJyF7B6m9Nhzl2EndPZHnDvmz7oWLE9urVRE2yXA8bd3Qz+nr71dprRmf3GII8Fp
	 bwxfflRZkBYpnrLdBGtnzLMPuPoaiTffaWiW4oAijGCqkhocpsvq6tFqPUg71tvFXL
	 zf2p11Xmpzss3jFPNXWPhtZn35jp8EHTZz2CAPlcF7nHd6nXUrMHU7SkmnoQBEnjhL
	 KKO1x7uK/eHWk/xjaoVhTSDyj6SkejrnVDEQKRa6sF+pejw1mU2YkybfUz5RZPPlUs
	 5vcQzn7OG7QZg==
X-Spam-Level: 
Received: from [192.168.17.245] (207.211.66.37.rev.sfr.net [37.66.211.207])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mailer-1.yeehaa.fr (Postfix) with ESMTPSA id 176375DE40
	for <kvm@vger.kernel.org>; Sun, 20 Apr 2025 20:44:14 +0200 (CEST)
ARC-Filter: OpenARC Filter v1.0.0 mailer-1.yeehaa.fr 176375DE40
Authentication-Results: mailer-1.yeehaa.fr; arc=none smtp.remote-ip=37.66.211.207
DKIM-Filter: OpenDKIM Filter v2.11.0 mailer-1.yeehaa.fr 176375DE40
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wheres5.com;
	s=20130910; t=1745174655;
	bh=ZaJdGIo2ZXZX29PEEtGsyLASNDxBpHTSEw/v2ch2u1E=;
	h=Date:To:From:Subject:From;
	b=esiilfBqNy3lc5XYdMbJQizPzpuXw1Z3RctqrjsPg+PCpo9QfuRHAomdApIcuTFVq
	 w/dEZQ4uFPPcL2mJ2Y/QpIPUkO/Wt9ym7S/bmTdpmPcIv/kxMFQg9B9juK93gWdtaC
	 OMllHQUdULOik11bZLz/ujEm/b0rmJVdU2HN1H5mxJ4rRmYIMU/ofKXfzJmRym6Xk3
	 RPKADQoe5x2cMmlNPV44zLAKkkHBNUF7rTPcUlbofay0kcDYft9TPSu2RHQz/kYx0O
	 qtDDZw3qbV4xFYeSEvC3XR7gv2mUCF+8hrbo98+FVlODgLvvNleQzrJ9Nt1q5D/bIi
	 HY5+3orbTeP2A==
Message-ID: <06b4dc51-b3f8-4b32-aab2-3e372649d2b1@wheres5.com>
Date: Sun, 20 Apr 2025 20:44:05 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: kvm@vger.kernel.org
Content-Language: fr
From: Hoggins! <fuckspam@wheres5.com>
Subject: Broken live migration
Autocrypt: addr=fuckspam@wheres5.com; keydata=
 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
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello there,

I'm facing a new issue when trying to perform a live migration of a VM 
between two KVM hosts. The VMs I try to migrate are running on an image 
on a GlusterFS shared filesystem.
It used to simply work, and now I get the following messages when trying 
to migrate :

    ~# virsh migrate --undefinesource --live --persistent --verbose
    --desturi qemu+ssh://root@other-kvm-host/system asterisk
    Migration: [100,00 %]erreur : erreur interne : QEMU unexpectedly
    closed the monitor (vm='asterisk'): [2025-04-20 18:29:14.170199
    +0000] I [io-stats.c:3784:ios_sample_buf_size_configure]
    0-vm_images: Configure ios_sample_buf  size is 1024 because
    ios_sample_interval is 0
    2025-04-20T18:29:22.165236Z qemu-system-x86_64: Failed to put
    registers after init: Invalid argument

What info do you need that I can gather to help me debug the issue?
KVM hosts are running Fedora 41, qemu-kvm package version is 
qemu-kvm-9.1.3-2.fc41.x86_64.

Thanks!

     Hoggins!


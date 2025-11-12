Return-Path: <kvm+bounces-62879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id A863DC529B0
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 15:05:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9AF5C34C921
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 14:05:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DA76271464;
	Wed, 12 Nov 2025 14:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hrRDv9jC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE4E1ADC83;
	Wed, 12 Nov 2025 14:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762956336; cv=none; b=dsGyLtAzQ7lCC4C4K+4HmGV7mjO7h1yDmBls39rDk4BwjEZVVxcbdSoWH91wPRLjPmHlgrhVCN15nxYrcq3Tb6fYhdkvfSQ4RTYGL8VgyMLCXyXRIS4Ym5TNT8B241knHwfEz0s6oeF2RShKLUqlXQsU6r6oGka1yhix0hjEeXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762956336; c=relaxed/simple;
	bh=cUexB+134c732hJDU7RXbkQN6iajQ/WyAnGW4R12ZXg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=SHmFmijZfHVwVS81ruDj86kebSt49FhmK0lBiimi7hPbvLXFhupeI2AtA/wiAlbZW/bLJuh27cDo722VIBcPQnaqMpc2czYCM6RPXDcKgSH164HwMouUfJRIcoOrudbm2bzEj6dgV5pUG+qwfemGTBUdwjFCztxiiBrZOGNRJSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hrRDv9jC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6CBC4CEF1;
	Wed, 12 Nov 2025 14:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762956336;
	bh=cUexB+134c732hJDU7RXbkQN6iajQ/WyAnGW4R12ZXg=;
	h=Date:From:Subject:To:From;
	b=hrRDv9jCTOoJlwxoL4NDlu662YQEFOrlV0LgPt+cfBK4nNT015L81G+FYPr9AsBWW
	 75km48IEnebOCCfr7LXswgbI1yl08Xvlo26aUN6NTkz/Z3PTyotffrrxxcbD5tMbaF
	 NVvrnh82Bu+LvEk14O7j80N/LTyKMS8XCyA+ndLzoEqfM6bEAXvqYjHp4dTbEWYW40
	 9JLK/YrmAc777Bt+hb73OKY9JZeFtwkWXN9g6o84qUAayjG/040L0uv0ZFG2CB5T8P
	 gF3stb1lFCjjxuMcP5ovyuGH1kL6eY00pmz95WRvyN8khVUx2kRgjN0BuK24e0r3rO
	 IkrwUsnGDJrNw==
Message-ID: <43cc83ae-2272-4bd6-b702-418a366a7da7@kernel.org>
Date: Wed, 12 Nov 2025 15:05:28 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-11-13
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi everybody,

Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
2025-11-13 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

In this meeting, we'll have Ackerley continue giving us an overview of
work-in-progress HugeTLB support and likely we will talk about 
interaction between directmap removal and ASI patches.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1] 
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

-- 
Cheers

David



Return-Path: <kvm+bounces-65100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 49924C9B1C7
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 11:23:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2DD444E41E7
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 10:22:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9B6330F7F6;
	Tue,  2 Dec 2025 10:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UfUVHxVe"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D508230BF52;
	Tue,  2 Dec 2025 10:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764670937; cv=none; b=SZ9ZXjiXDNPViMua4hpKPDJRZLnrar/ZIkrhorlH2ugxDcMLVcAqei8NpP9OV/pj28c5qoaDsdibHDou6SpFc7x5K4AWX6C38KSQND8uABkJgkFqAZY4obkR+mjxQADfi6BXGMC5NGpNA7ekiI4Dm6jJrkaodMoS8k59DMpzgpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764670937; c=relaxed/simple;
	bh=yj3FN/V5KbQow45uVjosHH53hDgKacz7AQeCSi6AvTM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=k4haIJfvIF4loEIKUJG7XO21VYT64MXRdl+BpHnoBfvVK2INkYtK5H9wuxRUozU6Cn4duQ8oGMzGW1yl8mmr9Nqq3AFR3kyVopPK3lDBT7us78m4qVTxhSwEUpqqr4DkQJ/eLw9kXTROLbY9uP6/jEe0TcWZRxo87haoN1D54RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UfUVHxVe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35900C116D0;
	Tue,  2 Dec 2025 10:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764670937;
	bh=yj3FN/V5KbQow45uVjosHH53hDgKacz7AQeCSi6AvTM=;
	h=Date:From:Subject:To:From;
	b=UfUVHxVeNJIIhMfXVk17M4vjFCcwA+zpS9oiRqG4YqU9vz7OwKhm03Vr5sqZ7m9gk
	 ZyapLJ6Tm1uzwJJui7X3LzZPtudsxzWERJd2M64u9qR2OMNndF7xqygZGy9UaxdaCg
	 rwPGVdSzCOjKd+Hf5cJ4TRlsfpiJLh+oZX2ckfIe+zv0eZzFChqXhjOEI1z8RfTbDw
	 v19x0BIGqaRxO3EY2FVgI5eUoCFZ0ZRf2XNwSsSHBa+zzftEtBGXH+Rb4soHFEzXVA
	 EQieqPKGl7COlC1osbM8uwf6aUcAX2hOXiIbYC7bittxQ3XOchq+CRoJP66Ze/vETh
	 4lf41pKSqwbMA==
Message-ID: <66c32ad4-a59a-425e-8a00-bcfb918e7559@kernel.org>
Date: Tue, 2 Dec 2025 11:22:07 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-12-04
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Our next guest_memfd upstream call is scheduled for Thursday,
2025-12-04 at 8:00 - 9:00am (GMT-08:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

In this meeting, we'll have Ackerley continue giving us an overview of
work-in-progress HugeTLB support and discuss whatever comes up.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.


This might be the last meeting this year: I will be traveling for LPC on 
December 11 and December 18. Then, Christmas is already around the 
corner and we'll skip the one on December 25. So we'll probably have our 
next meeting then on January 8.

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

-- 
Cheers

David




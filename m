Return-Path: <kvm+bounces-22077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D94C3939859
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 04:40:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9364B282A77
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 02:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E63F13957B;
	Tue, 23 Jul 2024 02:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cock.li header.i=@cock.li header.b="AQ/le9qZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail.cock.li (mail.cock.li [37.120.193.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363043D6A
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 02:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.193.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721702395; cv=none; b=Ov6vO7AmM+w+z1YwcGLik3qo4+g5gfPH0qoh18HYI3R6pmKxivLUUc+eZLJdMxZLu8NpUW+os5mZPYFQoqF2IVL+W/lj9fQQNgprzC5S5imqcxDJSMc6lXMciDuXwDCh2Yl8R2mSUr+vhFiVmHwakCXo9APkFFx01JyQajMYWjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721702395; c=relaxed/simple;
	bh=o53m5S5bswoeXMQ2yzokpdKHAkyYDNkRP8UFcaQbS8o=;
	h=MIME-Version:Content-Type:Date:From:To:Cc:Subject:In-Reply-To:
	 References:Message-ID; b=CcDseXKAeUsB+wE7tF3knX7MA7MpIe4Xzt9Z29mBcLbd1wwtUCv83LSthwTGL1t6cXUEXZtRThw2Oq6D2A/Uj42Cvor8qwQEwuWkEebuE1TKsr03dUCn/DaJNtC5eYS635QiCZUrKZFNmtFnoXaeL71x8nEmNMd8K892cVD6ylM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cock.li; spf=pass smtp.mailfrom=cock.li; dkim=pass (2048-bit key) header.d=cock.li header.i=@cock.li header.b=AQ/le9qZ; arc=none smtp.client-ip=37.120.193.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cock.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cock.li
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cock.li; s=mail;
	t=1721702384; bh=o53m5S5bswoeXMQ2yzokpdKHAkyYDNkRP8UFcaQbS8o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AQ/le9qZnMPaF+0rQ1YSJGaINHa4SYMsAiDIpSAG5DP28sYd9RdMHS8JWllJSdIFg
	 kbLSwOndg/CcPE5ZIkkEZWVaPOeDc9lEc4XfajTZjh5aN1/asD/drwlLI/X6KqIfXP
	 g2TOwJ1us5+R5zeJGNtzU6uYxm5UOHXQxldgxR40Ms3BlXwP80PWtsk6PMVsO3SekT
	 NhMljHaqDowqlnu8EFfTeAWe+5Exhs17HnZzuPy0ktNnImEc2AqWfVcBo274PWBKVx
	 xQoOHhF29HAppDPgduLUEFRr4jTc2SPSvtNxgR4X+tqSBz2IucuYgX7JSAXmnkfd5U
	 UopinA1WJzahw==
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 22 Jul 2024 22:39:43 -0400
From: privacymiscoccasion@cock.li
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
Subject: Re: [USB Isolation] USB virt drivers access between guests instead of
 host -> guest?
In-Reply-To: <Zp7rfbJpNDyhaZQO@google.com>
References: <23f30de150579d4893a493a6385f69f6@cock.li>
 <Zp7rfbJpNDyhaZQO@google.com>
User-Agent: Roundcube Webmail/1.4.15
Message-ID: <93ca9700dfce8ea0812e345bcbbf45cd@cock.li>
X-Sender: privacymiscoccasion@cock.li
Return-Receipt-To: privacymiscoccasion@cock.li
Disposition-Notification-To: privacymiscoccasion@cock.li

On 2024-07-22 19:30, Sean Christopherson wrote:
> On Mon, Jul 22, 2024, privacymiscoccasion@cock.li wrote:
>> Hi everyone,
>> 
>> I'm coming over from reading about Qubes OS, which uses the Xen 
>> hypervisor.
>> In Qubes, the way that untrusted devices like USBs are handled is that 
>> they
>> are pass through to a VM, which then (I presume) allows other guests 
>> to
>> access them using virtual drivers.
>> 
>> I'm looking for a theoretical explanation on how this would be 
>> possible with
>> KVM. I am not a developer and thus am having difficulty understanding 
>> how
>> one would let a guest access virtual drivers connecting to hardware 
>> devices
>> like USB and PCIe from another guest.
>> 
>> Any help/practical examples of this would be greatly appreciated. This 
>> seems
>> to be a hard topic to find and so far I haven't come across anything 
>> like
>> this.
> 
> In Linux, this would be done via VFIO[1].  VFIO allows assigning 
> devices to host
> userspace, and thus to KVM guests.  Very rougly speaking, most assets 
> that get
> exposed to KVM guests are proxied through host userspace.  I haven't 
> actually
> read the DPDK docs[2], but if you get stuck with VFIO in particular, my 
> guess is
> that they're a good starting point (beyond any VFIO+KVM tutorials).
> 
> [1] https://docs.kernel.org/driver-api/vfio.html
> [2] https://doc.dpdk.org/guides/linux_gsg/linux_drivers.html

Hello,

Thank you for your response. Indeed, I have been looking at VFIO since 
it's the first step to achieving such a configuration. However, from 
what I understand, VFIO assists in "passing through" the hardware 
controller/device(s) to a VM.

I do not follow how this fulfills the second part of my desired 
configuration, i.e. allowing other guests to access USB 
functionality/attached devices through a secure API with access control 
mechanisms. I want the guest to be able to assign devices to other 
guests, while maintaining the necessary security posture (since this can 
become an attack vector). I might have missed something though, so I'll 
go back and read again.

Thank you for your time.


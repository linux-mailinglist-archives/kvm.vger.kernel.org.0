Return-Path: <kvm+bounces-22085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 91AAB9398FA
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 06:51:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48E2D1F21F06
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 04:51:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F36E313C677;
	Tue, 23 Jul 2024 04:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cock.li header.i=@cock.li header.b="dEqzU1sq"
X-Original-To: kvm@vger.kernel.org
Received: from mail.cock.li (mail.cock.li [37.120.193.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B8D28E8
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 04:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.193.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721710270; cv=none; b=tT2+AICKt+ebogfzMV9AUe5rWb5GO8tvojXiWzdeyPpFKYC6IjlnRe62iWH494WO+K0S8HWseAaZekisX2+kZFrhvkmNAw9r4TNmKwIsQfRj3Pd/QE0bsZGULW2Xx2FLn3zXi4EWm0J1MQ29eydaWZUJLlb9uXHaaZOtiqeXG5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721710270; c=relaxed/simple;
	bh=hv+3L5bobthEw+1uL4XN1T59O7s9qRsBWiFwJpl0x6c=;
	h=MIME-Version:Content-Type:Date:From:To:Cc:Subject:In-Reply-To:
	 References:Message-ID; b=M7Tkz99Z7fRonpvQOHTv69fGgVzq3DU8KINN71bc0NjryKt9F3IFA9NblmnxEbf7w7Td8Kyb/VRFV2NcchtLlDT8p5A05cmrlbyYiIjTR8Dez2e8GWU2Pu9AxNrWHh5WvJb10QGbqQM8JIRpr9UXgYy99yFOzviH4YnzJTLKJB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cock.li; spf=pass smtp.mailfrom=cock.li; dkim=pass (2048-bit key) header.d=cock.li header.i=@cock.li header.b=dEqzU1sq; arc=none smtp.client-ip=37.120.193.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cock.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cock.li
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cock.li; s=mail;
	t=1721710264; bh=hv+3L5bobthEw+1uL4XN1T59O7s9qRsBWiFwJpl0x6c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dEqzU1sqf7QYxhmhxhvg5CGKKOneW74qUT67adFZcrIQ4tFs/Rv0yLwCCNjF38djT
	 v9Qn1dIPgvREObeXHNcWb3HIjDvrLaPGvv+V2PX3srpF408Ao31hB9BROuCTcrFn2n
	 Qb9JtGy1wzLB+6Sv5Xvo92q1XIhajM5OnRP2jRbjaK9+XbBbEHfru+e9ygACfjOxln
	 D9bdKEjcI96bBVzhb11aH536snbOtTaKFutNXhXOwl8tEtKe9fXK97QC7qa6P+B1vv
	 qxFCvEP/y7x46ucJBiK5feYXxiDUHMiu09JxdQc0MELhvUJ4+T9/ToCTCD5kLY0QDj
	 oqO/SeAcIQ5Ag==
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 23 Jul 2024 00:51:03 -0400
From: privacymiscoccasion@cock.li
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
Subject: Re: [USB Isolation] USB virt drivers access between guests instead of
 host -> guest?
In-Reply-To: <93ca9700dfce8ea0812e345bcbbf45cd@cock.li>
References: <23f30de150579d4893a493a6385f69f6@cock.li>
 <Zp7rfbJpNDyhaZQO@google.com> <93ca9700dfce8ea0812e345bcbbf45cd@cock.li>
User-Agent: Roundcube Webmail/1.4.15
Message-ID: <22caf4df8c982e41ac26275a7a7eba79@cock.li>
X-Sender: privacymiscoccasion@cock.li
Return-Receipt-To: privacymiscoccasion@cock.li
Disposition-Notification-To: privacymiscoccasion@cock.li

On 2024-07-22 22:39, privacymiscoccasion@cock.li wrote:
> On 2024-07-22 19:30, Sean Christopherson wrote:
>> On Mon, Jul 22, 2024, privacymiscoccasion@cock.li wrote:
>>> Hi everyone,
>>> 
>>> I'm coming over from reading about Qubes OS, which uses the Xen 
>>> hypervisor.
>>> In Qubes, the way that untrusted devices like USBs are handled is 
>>> that they
>>> are pass through to a VM, which then (I presume) allows other guests 
>>> to
>>> access them using virtual drivers.
>>> 
>>> I'm looking for a theoretical explanation on how this would be 
>>> possible with
>>> KVM. I am not a developer and thus am having difficulty understanding 
>>> how
>>> one would let a guest access virtual drivers connecting to hardware 
>>> devices
>>> like USB and PCIe from another guest.
>>> 
>>> Any help/practical examples of this would be greatly appreciated. 
>>> This seems
>>> to be a hard topic to find and so far I haven't come across anything 
>>> like
>>> this.
>> 
>> In Linux, this would be done via VFIO[1].  VFIO allows assigning 
>> devices to host
>> userspace, and thus to KVM guests.  Very rougly speaking, most assets 
>> that get
>> exposed to KVM guests are proxied through host userspace.  I haven't 
>> actually
>> read the DPDK docs[2], but if you get stuck with VFIO in particular, 
>> my guess is
>> that they're a good starting point (beyond any VFIO+KVM tutorials).
>> 
>> [1] https://docs.kernel.org/driver-api/vfio.html
>> [2] https://doc.dpdk.org/guides/linux_gsg/linux_drivers.html
> 
> Hello,
> 
> Thank you for your response. Indeed, I have been looking at VFIO since
> it's the first step to achieving such a configuration. However, from
> what I understand, VFIO assists in "passing through" the hardware
> controller/device(s) to a VM.
> 
> I do not follow how this fulfills the second part of my desired
> configuration, i.e. allowing other guests to access USB
> functionality/attached devices through a secure API with access
> control mechanisms. I want the guest to be able to assign devices to
> other guests, while maintaining the necessary security posture (since
> this can become an attack vector). I might have missed something
> though, so I'll go back and read again.
> 
> Thank you for your time.

Hi,

As I was reading more about the second part, I came across a few 
interesting projects around this space.

Relevant to USB:
- [Linux Kernel supports 
USB/IP](https://www.kernel.org/doc/html/latest/usb/usbip_protocol.html)
- [Arch wiki tutorial on 
USB/IP](https://wiki.archlinux.org/title/USB/IP)

Relevant to PCIe slicing:
- [vhost-user with DPDK](https://wiki.qemu.org/Features/VirtioVhostUser) 
in QEMU.
- [Redhat guide on Vhost User with 
dpdk](https://www.redhat.com/en/blog/hands-vhost-user-warm-welcome-dpdk)

Relevant to PCIe over IP:
- [A virtio-net EP function to share PCIe devices over 
IP](https://lwn.net/Articles/922124/) - this has the list of relevant 
patches for this feature in the Kernel.

My goal is to have 2 guests, one in charge of distributing access to 
USBs, and the other for access to GPU resources. I will have to read 
more about the support each one has and their usability but this is 
certainly wonderful news.

Thanks!


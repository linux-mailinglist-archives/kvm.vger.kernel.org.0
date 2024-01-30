Return-Path: <kvm+bounces-7492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3852E842CA9
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 20:26:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 566711C24610
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 19:26:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C513B69974;
	Tue, 30 Jan 2024 19:26:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zulu616.server4you.de (mail.csgraf.de [85.25.223.15])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15B8F69E00
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 19:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.25.223.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706642765; cv=none; b=L8ebKAWfGGnAHDDuOAO4JNmx1tcKtqyDJA16OHkcpMpTd9MLdDdObFb0x96vMcP6XsaKYuG5cPAUkGWM6mHTfYZGQEHrH5qr/ogt/nlxTzq1Jlt+yvlic8iLuCN+/k9l9ZBu3hechqBjN+823ScVCvcYgaByaOuM8lPfeM84048=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706642765; c=relaxed/simple;
	bh=LPQMG32TSIByugxLcNhDX++ZyXcMAEn5neQp7PqpIcY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AFfeTh1VkRQwcE36a/XuZFnniQkvE2ggsRqou5pz60xjVuQ+k+qVC70Eed3sTbYgytlGnH8XU7Nu+MGEhtB2EZVJYZAa1DqlYsl5OzjmEwbdRL5lxwm8knHUYIAaTkVVD6lss7+05N2TtC2L9F+o9kVwTtsBIFr6rQm/KAeE2Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csgraf.de; spf=pass smtp.mailfrom=csgraf.de; arc=none smtp.client-ip=85.25.223.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csgraf.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgraf.de
Received: from [0.0.0.0] (ec2-3-122-114-9.eu-central-1.compute.amazonaws.com [3.122.114.9])
	by csgraf.de (Postfix) with ESMTPSA id 73F9F608016B;
	Tue, 30 Jan 2024 20:16:24 +0100 (CET)
Message-ID: <834f4e79-7495-42b3-b6b1-aa614c03d15e@csgraf.de>
Date: Tue, 30 Jan 2024 20:16:23 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Call for GSoC/Outreachy internship project ideas
Content-Language: en-US
To: Stefan Hajnoczi <stefanha@gmail.com>, qemu-devel <qemu-devel@nongnu.org>,
 kvm <kvm@vger.kernel.org>
Cc: Alberto Faria <afaria@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, German Maglione <gmaglione@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 "Richard W.M. Jones" <rjones@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, Warner Losh <imp@bsdimp.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Song Gao <gaosong@loongson.cn>, Akihiko Odaki <akihiko.odaki@daynix.com>,
 Bernhard Beschow <shentey@gmail.com>, Nicholas Piggin <npiggin@gmail.com>,
 Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 "Koira, Eugene" <eugkoira@amazon.nl>, "Yap, William" <williyap@amazon.com>,
 "Bean, J.D." <jdbean@amazon.com>
References: <CAJSP0QX9TQ-=PD7apOamXvGW29VwJPfVNN2X5BsFLFoP2g6USg@mail.gmail.com>
From: Alexander Graf <agraf@csgraf.de>
In-Reply-To: <CAJSP0QX9TQ-=PD7apOamXvGW29VwJPfVNN2X5BsFLFoP2g6USg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hey Stefan,

Thanks a lot for setting up GSoC this year again!

On 15.01.24 17:32, Stefan Hajnoczi wrote:
> Dear QEMU and KVM communities,
> QEMU will apply for the Google Summer of Code and Outreachy internship
> programs again this year. Regular contributors can submit project
> ideas that they'd like to mentor by replying to this email before
> January 30th.
>
> Internship programs
> ---------------------------
> GSoC (https://summerofcode.withgoogle.com/) and Outreachy
> (https://www.outreachy.org/) offer paid open source remote work
> internships to eligible people wishing to participate in open source
> development. QEMU has been part of these internship programs for many
> years. Our mentors have enjoyed helping talented interns make their
> first open source contributions and some former interns continue to
> participate today.
>
> Who can mentor
> ----------------------
> Regular contributors to QEMU and KVM can participate as mentors.
> Mentorship involves about 5 hours of time commitment per week to
> communicate with the intern, review their patches, etc. Time is also
> required during the intern selection phase to communicate with
> applicants. Being a mentor is an opportunity to help someone get
> started in open source development, will give you experience with
> managing a project in a low-stakes environment, and a chance to
> explore interesting technical ideas that you may not have time to
> develop yourself.
>
> How to propose your idea
> ----------------------------------
> Reply to this email with the following project idea template filled in:
>
> === TITLE ===
>
> '''Summary:''' Short description of the project
>
> Detailed description of the project that explains the general idea,
> including a list of high-level tasks that will be completed by the
> project, and provides enough background for someone unfamiliar with
> the codebase to do research. Typically 2 or 3 paragraphs.
>
> '''Links:'''
> * Wiki links to relevant material
> * External links to mailing lists or web sites
>
> '''Details:'''
> * Skill level: beginner or intermediate or advanced
> * Language: C/Python/Rust/etc


=== Implement -M nitro-enclave in QEMU  ===

'''Summary:''' AWS EC2 provides the ability to create an isolated 
sibling VM context from within a VM. This project implements the machine 
model and input data format parsing needed to run these sibling VMs 
stand alone in QEMU.

Nitro Enclaves are the first widely adopted implementation of hypervisor 
assisted compute isolation. Similar to technologies like SGX, it allows 
to spawn a separate context that is inaccessible by the parent Operating 
System. This is implemented by "giving up" resources of the parent VM 
(CPU cores, memory) to the hypervisor which then spawns a second vmm to 
execute a completely separate virtual machine. That new VM only has a 
vsock communication channel to the parent and has a built-in lightweight 
TPM called NSM.

One big challenge with Nitro Enclaves is that due to its roots in 
security, there are very few debugging / introspection capabilities. 
That makes OS bringup, debugging and bootstrapping very difficult. 
Having a local dev&test environment that looks like an Enclave, but is 
100% controlled by the developer and introspectable would make life a 
lot easier for everyone working on them. It also may pave the way to see 
Nitro Enclaves adopted in VM environments outside of EC2.

This project will consist of adding a new machine model to QEMU that 
mimics a Nitro Enclave environment, including NSM, the vsock 
communication channel and building firmware which loads the special 
"EIF" file format which contains kernel, initramfs and metadata from a 
-kernel image.

If the student finishes early, we can then proceed to implement the 
Nitro Enclaves parent driver in QEMU as well to create a full QEMU-only 
Nitro Enclaves environment.

'''Tasks:'''
* Implement a device model for the NSM device (link to spec and driver 
code below)
* Implement a new machine model
* Implement firmware for the new machine model that implements EIF parsing
* Add tests for the NSM device
* Add integration test for the machine model executing an actual EIF payload

'''Links:'''
* https://aws.amazon.com/ec2/nitro/nitro-enclaves/
* 
https://lore.kernel.org/lkml/20200921121732.44291-10-andraprs@amazon.com/T/
* 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/misc/nsm.c

'''Details:'''
* Skill level: intermediate - advanced (some understanding of QEMU 
machine modeling would be good)
* Language: C
* Mentor: agraf
* Suggested by: Alexander Graf (OFTC: agraf, Email: graf@amazon.com)



Alex




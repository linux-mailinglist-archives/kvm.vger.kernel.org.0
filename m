Return-Path: <kvm+bounces-12474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6BF8886799
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 08:46:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 281E0B21D76
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 07:46:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D7C912E59;
	Fri, 22 Mar 2024 07:46:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F2610799
	for <kvm@vger.kernel.org>; Fri, 22 Mar 2024 07:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.216.63.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711093596; cv=none; b=IGIKHBTRQ2PSVulkCHQpplH+OxkMgtO/PA55O8DlQpyQCTtuvBubLSDtHA4LVPaqYPJeNblk11T3volL99G1ZCAxWgXAb2SnyH2mbdPJDRnks4mWTuPvbWdacXPPY9XNRsgk/gm8BodDDAf9EkiWBXzWzGilkOFA95sifJ4Te0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711093596; c=relaxed/simple;
	bh=/tdaDijaleUcm4fiuFl6bb4v7C1pzDX0JftOkkbuL6E=;
	h=Date:Message-ID:Mime-Version:From:To:Cc:Subject:Content-Type; b=ni9RGVawidI8+JsN69BCsAZw8Z9KBuQICLb3zl3DYY3M/i/vFyKsGEwkeq/USqJNjNVe17ehJ7GeXbY8ZhwWXzzE6nrOqQJYCsWBTaFgZNJcLo4e2zk7j3zeVJz/f+vbAUaipbpWUaLMd92BThkZllUW7eIdqzdlv9SnZg1SBfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=63.216.63.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4V1Dsp6Lryz8XrRP
	for <kvm@vger.kernel.org>; Fri, 22 Mar 2024 15:46:22 +0800 (CST)
Received: from njb2app07.zte.com.cn ([10.55.22.95])
	by mse-fl2.zte.com.cn with SMTP id 42M7kGLi056839
	for <kvm@vger.kernel.org>; Fri, 22 Mar 2024 15:46:16 +0800 (+08)
	(envelope-from jiang.kun2@zte.com.cn)
Received: from mapi (njy2app03[null])
	by mapi (Zmail) with MAPI id mid204;
	Fri, 22 Mar 2024 15:46:18 +0800 (CST)
Date: Fri, 22 Mar 2024 15:46:18 +0800 (CST)
X-Zmail-TransId: 2afb65fd374a256-48493
X-Mailer: Zmail v1.0
Message-ID: <202403221546188162024@zte.com.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: <jiang.kun2@zte.com.cn>
To: <kvm@vger.kernel.org>
Cc: <wang.yechao255@zte.com.cn>, <ouyang.maochun@zte.com.cn>
Subject: =?UTF-8?B?SG9zdHMgZ290IHN0dWNrIHdpdGggdm14OiB1bmV4cGVjdGVkIGV4aXQgcmVhc29uIDB4M8Kg?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 42M7kGLi056839
X-Fangmail-Gw-Spam-Type: 0
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 65FD374E.001/4V1Dsp6Lryz8XrRP

Dear KVM experts,

We have two hosts that got stuck, and the last serial port logs had
kvm prints vmx: unexpected exit reason 0x3.

last logs of HostA:
[23031085.916249] kvm [9737]: vcpu6, guest rIP: 0xffffffffb190d1b5 vmx: unexpected exit reason 0x3
[23031085.916251] set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.

last logs of HostB:
[16755112.797211] kvm [2787303]: vcpu11, guest rIP: 0x70a8f4 vmx: unexpected exit reason 0x3
[16755112.797213] kvm [2787303]: vcpu16, guest rIP: 0x70a9ae vmx: unexpected exit reason 0x3
[16755112.797214] kvm [2787303]: vcpu17, guest rIP: 0x70a9ae vmx: unexpected exit reason 0x3
[16755112.797217] kvm [2787303]: vcpu15, guest rIP: 0x70d707 vmx: unexpected exit reason 0x3
[16755112.797219] kvm [2787303]: vcpu12, guest rIP: 0x701431 vmx: unexpected exit reason 0x3
[16755112.797221] kvm [2787303]: vcpu7, guest rIP: 0x70b005 vmx: unexpected exit reason 0x3
[16755112.797222] set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
[16755112.797224] kvm [2787303]: vcpu4, guest rIP: 0x796fa6 vmx: unexpected exit reason 0x3
[16755112.797224] set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
[16755112.797229] kvm [3588862]: vcpu3, guest rIP: 0xffffffff816c7a1b vmx: unexpected exit reason 0x3
[16755112.797230] set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
[16755112.797231] set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
[16755112.797231] set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
[16755112.797232] set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
[16755112.797233] set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
[16755112.797235] kvm [9066]: vcpu5, guest rIP: 0xffffffff8a4a1c0e vmx: unexpected exit reason 0x3
[16755112.797236] set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
[16755112.797236] set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
[16755112.797262] kvm [2813867]: vcpu0, guest rIP: 0xffffffff816c7a1b vmx: unexpected exit reason 0x3
[16755112.797263] set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
[18446744004.989880] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[18446744004.989880] PGD 0 P4D 0
[18446744004.989880] Oops: 0000 [#1] SMP NOPTI
[18446744004.989880] CPU: 10 PID: 0 Comm: swapper/10 Kdump: loaded Tainted: G           OE    --------- -t - 4.18.0-193.14.2.el8_2.x86_64 #1
[18446744004.989880] Hardware name: xxxxx, BIOS xx.xx.xxxx 02/18/2020
[18446744004.989880] RIP: 0010:__list_add_valid+0x0/0x50
[18446744004.989880] Code: ff ff 49 c7 07 00 00 00 00 41 c7 47 08 00 00 00 00 48 89 44 24 28 e9 dc fe ff ff 48 89 6c 24 28 e9 d2 fe ff ff e8 20 08 c8 ff <48> 8b 42 08 49 89 d0 48 39 f0 0f 85 8c 00 00 00 48 8b 10 4c 39 c2

Kernel version is: 4.18.0-193.14.2.el8_2.x86_64
CPU is Intel(R) Xeon(R) Gold 6230N CPU @ 2.30GHz

When the hosts were found to be stuck, both had been stuck for several days.
We tried triggering a panic collection of vmcore using sysrq+c magic key,
but there was no response. Eventually, we had to do a hard reboot by pressing
the power button to recover.

There is no crashdump generated.

Before the two hosts got stuck, they both printed vmx: unexpected exit 
reason 0x3. Looking at the code, we found exit reason 0x3 is 
EXIT_REASON_INIT_SIGNAL, means that the current CPU received INIT IPI in
non-root mode. But found INIT IPI is only sent during CPU setup.
Anyone know why INIT IPI is generated?

HostB printed NULL pointer BUG, but the panic process did not proceed further
and instead got stuck. The time 18446744004.989880 is incorrect, the uptime 
of HostB is 193 days.

We suspect hostB's exception are also related to the previous vmx unexpected 
exit. Anyone encountered similar cases before? Are there any solutions
and suggestions?


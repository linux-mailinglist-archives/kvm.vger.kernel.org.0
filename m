Return-Path: <kvm+bounces-34418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 338929FEACD
	for <lists+kvm@lfdr.de>; Mon, 30 Dec 2024 22:03:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D487F18833F7
	for <lists+kvm@lfdr.de>; Mon, 30 Dec 2024 21:03:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 933FE19C574;
	Mon, 30 Dec 2024 21:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="bG8g+wQd"
X-Original-To: kvm@vger.kernel.org
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D20715E8B
	for <kvm@vger.kernel.org>; Mon, 30 Dec 2024 21:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735592620; cv=none; b=FEsUAs3S+0O14UrUfBExkpLGa67gTW8IZENRLYEWCBb+XE23x7v7H1fx96VTnzkOiMRnr85l1yrTPWd35AwTZheSRRpT9Udk7gkq+XU0RiUgvpHJHreRS/9A+9sQ/aKWaKxq49HWBta6A/P1MgGFfwPDncO8kxGVAsFb04Rwc60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735592620; c=relaxed/simple;
	bh=u1eGerJhkmG4Wf4MK/K63jTGfWfXNu0JGOaNlCXPQxM=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=r3QXfGXEOP6K+7z5ZFOLSuVP5eIFpuBOOg+cnd2fvotdS7W1fNe98DsBLB9+WGsrxx/MEFnLtuVxVQN+gZg2WsXUxrG7QJbSzUzalXU/hOjhmHaHpAwFR3Ro40x+koe14ggry70xtAlgGUy9DuHYoRLyJi5UbMwVJe72mf4GFeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=bG8g+wQd; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 7882D240028
	for <kvm@vger.kernel.org>; Mon, 30 Dec 2024 22:03:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
	t=1735592611; bh=u1eGerJhkmG4Wf4MK/K63jTGfWfXNu0JGOaNlCXPQxM=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:From:
	 From;
	b=bG8g+wQdSD82/PrMXOAx4pR/moeqxy4hr2D199BJlUjhHgQaUMBSKcXlw7Mvr7en3
	 +J1SP3ZNA0JrYCnirLF7GRVOf3qSakRuLQlEolpweLy3z7o5nsnGDEAambkPNtPmJ9
	 dhOgRMV0ws+6F92OsQ4DonH20tisHJGfUQTX3bHVVAR0eNTDm9/GJXzGbJyjHNeq15
	 Qdp/pxYGAp/1QFUGcu1cWSgPEaFe6zl6jpsIDEgw/jjf20uDfMeDnwkfFlI30z8r7N
	 gSG4966wwEUDoVqE8mGQcor4LtwpKnFgPZrrLIb9PqzjhAh62ubHOriq0abJYQwvf9
	 e8inPFYa3IZyA==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4YMT8y4sGzz6twX;
	Mon, 30 Dec 2024 22:03:30 +0100 (CET)
Content-Type: multipart/mixed; boundary="------------RsT4sNfODtKbj8IZrW0O1j69"
Message-ID: <16ea1922-c9ce-4d73-b9b6-8365ca3fcf32@posteo.de>
Date: Mon, 30 Dec 2024 21:03:30 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [bugzilla-daemon@kernel.org: [Bug 219619] New: vfio-pci: screen
 graphics artifacts after 6.12 kernel upgrade]
To: Peter Xu <peterx@redhat.com>,
 Athul Krishna <athul.krishna.kr@protonmail.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Linux PCI <linux-pci@vger.kernel.org>,
 "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <20241222223604.GA3735586@bhelgaas>
 <Hb6kvXlGizYbogNWGJcvhY3LsKeRwROtpRluHKsGqRcmZl68J35nP60YdzW1KSoPl5RO_dCxuL5x9mM13jPBbU414DEZE_0rUwDNvzuzyb8=@protonmail.com>
 <Z2mW2k8GfP7S0c5M@x1n>
Content-Language: en-US
From: Precific <precification@posteo.de>
In-Reply-To: <Z2mW2k8GfP7S0c5M@x1n>

This is a multi-part message in MIME format.
--------------RsT4sNfODtKbj8IZrW0O1j69
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 23.12.24 17:59, Peter Xu wrote:
> On Mon, Dec 23, 2024 at 07:37:46AM +0000, Athul Krishna wrote:
>> Can confirm. Reverting f9e54c3a2f5b from v6.13-rc1 fixed the problem.
>>>   
>>>   Device: Asus Zephyrus GA402RJ
>>>   CPU: Ryzen 7 6800HS
>>>   GPU: RX 6700S
>>>   Kernel: 6.13.0-rc3-g8faabc041a00
>>>   
>>>   Problem:
>>>   Launching games or gpu bench-marking tools in qemu windows 11 vm will cause
>>>   screen artifacts, ultimately qemu will pause with unrecoverable error.
> 
> Is there more information on what setup can reproduce it?
> 
> For example, does it only happen with Windows guests?  Does the GPU
> vendor/model matter?

In my case, both Windows and Linux guests fail to initialize the GPU in 
the first place since 6.12; QEMU does not crash. I also found commit 
f9e54c3a2f5b79ecc57c7bc7d0d3521e461a2101 by bisection.

CPU: AMD 7950X3D
GPU (guest): AMD RX 6700XT (12GB)
Mainboard: ASRock X670E Steel Legend
Kernel: 6.12.0-rc0 .. 6.13.0-rc2

Based on a handful of reports on the Arch forum and on r/vfio, my guess 
is that affected users have Resizable BAR or similar settings enabled in 
the firmware, which usually applies the maximum possible BAR size 
advertised by the GPU on startup. Non-2^n-sized VRAM buffers may be 
another commonality.

Some other reports I found that could fit to this regression:
[1] https://bbs.archlinux.org/viewtopic.php?id=301352
   - Several reports (besides mine), not clear which of those cases are 
triggered by the vfio-pci commit. One case is clearly caused by a 
different commit in KVM. Potential candidates for the vfio-pci commit 
(speculation): (a) 6700XT GPU; (b) 5950X CPU, RTX 3090 GPU
[2] https://old.reddit.com/r/VFIO/comments/1hkvedq/
   - Two users, 7900XT and 7900XTX, reported that reverting 6.12 or 
disabling ReBAR resolves Windows guest GPU initialization.

On my 6700XT (PCI address 03:00.0, 12GB of VRAM), I get the following 
Resizable BAR default configuration with the host firmware/UEFI setting 
enabled:

[root]# lspci -s 03:00.0 -vv
...
Capabilities: [200 v1] Physical Resizable BAR
	BAR 0: current size: 16GB, supported: 256MB 512MB 1GB 2GB 4GB 8GB 16GB
	BAR 2: current size: 256MB, supported: 2MB 4MB 8MB 16MB 32MB 64MB 128MB 
256MB
...

The 16GB configuration above fails with 6.12 (unless I revert commit 
f9e54c3a2f5b79ecc57c7bc7d0d3521e461a2101).
Now, if I change BAR 0 to 8GB (as below), which is below the GPU's VRAM 
size of 12GB, the Linux guest manages to initialize the GPU.

[root]# echo "0000:03:00.0" > /sys/bus/pci/drivers/vfio-pci/unbind
[root]# #13: 8GB, 14: 16GB
[root]# echo 13 > /sys/bus/pci/devices/0000:03:00.0/resource0_resize
[root]# echo "0000:03:00.0" > /sys/bus/pci/drivers/vfio-pci/bind

On my mainboard, 'Resizable BAR off' sets BAR 0 to 256MB, which also 
works with 6.12.

Only the size of BAR 0 (VRAM) appears to be relevant here. BAR 2 sizes 
of 2MB vs. 256MB have no effect on the outcome.

> 
>>>   
>>>   Commit:
>>>   f9e54c3a2f5b79ecc57c7bc7d0d3521e461a2101 is the first bad commit
>>>   commit f9e54c3a2f5b79ecc57c7bc7d0d3521e461a2101
>>>   Author: Alex Williamson <alex.williamson@redhat.com>
>>>   Date:   Mon Aug 26 16:43:53 2024 -0400
>>>   
>>>       vfio/pci: implement huge_fault support
> 
> Personally I have no clue yet on how this could affect it.  I was initially
> worrying on any implicit cache mode changes on the mappings, but I don't
> think any of such was involved in this specific change.
> 
> This commit majorly does two things: (1) allow 2M/1G mappings for BARs
> instead of small 4Ks always, and (2) always lazy faults rather than
> "install everything in the 1st fault".  Maybe one of the two could have
> some impact in some way.

In my case, commenting out (1) the huge_fault callback assignment from 
f9e54c3a2f5b suffices for GPU initialization in the guest, even if (2) 
the 'install everything' loop is still removed.

I have uploaded host kernel logs with vfio-pci-core debugging enabled 
(one log with stock sources, one large log with vfio-pci-core's 
huge_fault handler patched out):
https://bugzilla.kernel.org/show_bug.cgi?id=219619#c1
I'm not sure if the logs of handled faults say much about what 
specifically goes wrong here, though.

The dmesg portion attached to my mail is of a Linux guest failing to 
initialize the GPU (BAR 0 size 16GB with 12GB of VRAM).

Thanks,
Precific

--------------RsT4sNfODtKbj8IZrW0O1j69
Content-Type: text/plain; charset=UTF-8;
 name="2024-12-21-vfiopcicore-regression-guest-amdgpu-dmesg.txt"
Content-Disposition: attachment;
 filename="2024-12-21-vfiopcicore-regression-guest-amdgpu-dmesg.txt"
Content-Transfer-Encoding: base64

LSBEbWVzZyBvZiBhIGxpbnV4IGd1ZXN0IGZhaWxpbmcgYW1kZ3B1IGluaXRpYWxpemF0aW9u
LiBIb3N0IHJ1bm5pbmcga2VybmVsIDYuMTIvNi4xMywgd2l0aCBSZUJBUiBlbmFibGVkICgx
NkdCIEJBUiAwKQpbW25vdGU6IHNvbWUgdmFyaWF0aW9ucyBjYW4gb2NjdXIsIGUuZy4sIHRo
ZSBlcnJvciBzb21ldGltZXMgb2NjdXJzIGF0IGEgbGF0ZXIgc3RhZ2Ugb2YgaW5pdGlhbGl6
YXRpb25dXQoKWyAgIDEwLjI0NTEwMF0gW2RybV0gYW1kZ3B1IGtlcm5lbCBtb2Rlc2V0dGlu
ZyBlbmFibGVkLgpbICAgMTAuMjQ1MTczXSBhbWRncHU6IFZpcnR1YWwgQ1JBVCB0YWJsZSBj
cmVhdGVkIGZvciBDUFUKWyAgIDEwLjI0NTE4Ml0gYW1kZ3B1OiBUb3BvbG9neTogQWRkIENQ
VSBub2RlClsgICAxMC4yNDU0ODBdIFtkcm1dIGluaXRpYWxpemluZyBrZXJuZWwgbW9kZXNl
dHRpbmcgKE5BVllfRkxPVU5ERVIgMHgxMDAyOjB4NzNERiAweDEwMDI6MHgwRTM2IDB4QzEp
LgpbICAgMTAuMjQ1NDkyXSBbZHJtXSByZWdpc3RlciBtbWlvIGJhc2U6IDB4ODFBMDAwMDAK
WyAgIDEwLjI0NTQ5M10gW2RybV0gcmVnaXN0ZXIgbW1pbyBzaXplOiAxMDQ4NTc2ClsgICAx
MC4yNDg4NjFdIFtkcm1dIGFkZCBpcCBibG9jayBudW1iZXIgMCA8bnZfY29tbW9uPgpbICAg
MTAuMjQ4ODYyXSBbZHJtXSBhZGQgaXAgYmxvY2sgbnVtYmVyIDEgPGdtY192MTBfMD4KWyAg
IDEwLjI0ODg2M10gW2RybV0gYWRkIGlwIGJsb2NrIG51bWJlciAyIDxuYXZpMTBfaWg+Clsg
ICAxMC4yNDg4NjRdIFtkcm1dIGFkZCBpcCBibG9jayBudW1iZXIgMyA8cHNwPgpbICAgMTAu
MjQ4ODY0XSBbZHJtXSBhZGQgaXAgYmxvY2sgbnVtYmVyIDQgPHNtdT4KWyAgIDEwLjI0ODg2
NV0gW2RybV0gYWRkIGlwIGJsb2NrIG51bWJlciA1IDxkbT4KWyAgIDEwLjI0ODg2Nl0gW2Ry
bV0gYWRkIGlwIGJsb2NrIG51bWJlciA2IDxnZnhfdjEwXzA+ClsgICAxMC4yNDg4NjddIFtk
cm1dIGFkZCBpcCBibG9jayBudW1iZXIgNyA8c2RtYV92NV8yPgpbICAgMTAuMjQ4ODY3XSBb
ZHJtXSBhZGQgaXAgYmxvY2sgbnVtYmVyIDggPHZjbl92M18wPgpbICAgMTAuMjQ4ODY4XSBb
ZHJtXSBhZGQgaXAgYmxvY2sgbnVtYmVyIDkgPGpwZWdfdjNfMD4KWyAgIDEwLjI0ODg3N10g
YW1kZ3B1IDAwMDA6MDU6MDAuMDogYW1kZ3B1OiBGZXRjaGVkIFZCSU9TIGZyb20gVkZDVApb
ICAgMTAuMjQ4ODc4XSBhbWRncHU6IEFUT00gQklPUzogMTEzLUQ1MTIxMTAwLTEwMQpbICAg
MTAuMjcwMDk3XSBbZHJtXSBWQ04oMCkgZGVjb2RlIGlzIGVuYWJsZWQgaW4gVk0gbW9kZQpb
ICAgMTAuMjcwMDk5XSBbZHJtXSBWQ04oMCkgZW5jb2RlIGlzIGVuYWJsZWQgaW4gVk0gbW9k
ZQpbICAgMTAuMjg0MzE4XSBbZHJtXSBKUEVHIGRlY29kZSBpcyBlbmFibGVkIGluIFZNIG1v
ZGUKWyAgIDEwLjI4NDMyMF0gYW1kZ3B1IDAwMDA6MDU6MDAuMDogYW1kZ3B1OiBUcnVzdGVk
IE1lbW9yeSBab25lIChUTVopIGZlYXR1cmUgZGlzYWJsZWQgYXMgZXhwZXJpbWVudGFsIChk
ZWZhdWx0KQpbICAgMTAuMjg0MzU5XSBbZHJtXSB2bSBzaXplIGlzIDI2MjE0NCBHQiwgNCBs
ZXZlbHMsIGJsb2NrIHNpemUgaXMgOS1iaXQsIGZyYWdtZW50IHNpemUgaXMgOS1iaXQKWyAg
IDEwLjI4NDM2NV0gYW1kZ3B1IDAwMDA6MDU6MDAuMDogYW1kZ3B1OiBWUkFNOiAxMjI3Mk0g
MHgwMDAwMDA4MDAwMDAwMDAwIC0gMHgwMDAwMDA4MkZFRkZGRkZGICgxMjI3Mk0gdXNlZCkK
WyAgIDEwLjI4NDM2N10gYW1kZ3B1IDAwMDA6MDU6MDAuMDogYW1kZ3B1OiBHQVJUOiA1MTJN
IDB4MDAwMDAwMDAwMDAwMDAwMCAtIDB4MDAwMDAwMDAxRkZGRkZGRgpbICAgMTAuMjg0Mzc1
XSBbZHJtXSBEZXRlY3RlZCBWUkFNIFJBTT0xMjI3Mk0sIEJBUj0xNjM4NE0KWyAgIDEwLjI4
NDM3Nl0gW2RybV0gUkFNIHdpZHRoIDE5MmJpdHMgR0REUjYKWyAgIDEwLjI4NDQ5NV0gW2Ry
bV0gYW1kZ3B1OiAxMjI3Mk0gb2YgVlJBTSBtZW1vcnkgcmVhZHkKWyAgIDEwLjI4NDQ5Nl0g
W2RybV0gYW1kZ3B1OiAxNjA0Mk0gb2YgR1RUIG1lbW9yeSByZWFkeS4KWyAgIDEwLjI4NDUw
NV0gW2RybV0gR0FSVDogbnVtIGNwdSBwYWdlcyAxMzEwNzIsIG51bSBncHUgcGFnZXMgMTMx
MDcyClsgICAxMC4yODQ2MjZdIFtkcm1dIFBDSUUgR0FSVCBvZiA1MTJNIGVuYWJsZWQgKHRh
YmxlIGF0IDB4MDAwMDAwODAwMDMwMDAwMCkuClsgICAxMi4yMTgyNzZdIGFtZGdwdSAwMDAw
OjA1OjAwLjA6IGFtZGdwdTogU1RCIGluaXRpYWxpemVkIHRvIDIwNDggZW50cmllcwpbICAg
MTIuMjE4MzMzXSBbZHJtXSBMb2FkaW5nIERNVUIgZmlybXdhcmUgdmlhIFBTUDogdmVyc2lv
bj0weDAyMDIwMDIwClsgICAxMi4yMTg2NDddIFtkcm1dIHVzZV9kb29yYmVsbCBiZWluZyBz
ZXQgdG86IFt0cnVlXQpbICAgMTIuMjE4NjU4XSBbZHJtXSB1c2VfZG9vcmJlbGwgYmVpbmcg
c2V0IHRvOiBbdHJ1ZV0KWyAgIDEyLjIxODY2N10gW2RybV0gRm91bmQgVkNOIGZpcm13YXJl
IFZlcnNpb24gRU5DOiAxLjMwIERFQzogMyBWRVA6IDAgUmV2aXNpb246IDQKWyAgIDEyLjIx
ODY3Ml0gYW1kZ3B1IDAwMDA6MDU6MDAuMDogYW1kZ3B1OiBXaWxsIHVzZSBQU1AgdG8gbG9h
ZCBWQ04gZmlybXdhcmUKWyAgIDE0LjM5MDk5MV0gW2RybV0gcHNwIGdmeCBjb21tYW5kIElE
X0xPQURfVE9DKDB4MjApIGZhaWxlZCBhbmQgcmVzcG9uc2Ugc3RhdHVzIGlzICgweDApClsg
ICAxNC4zOTA5OTRdIFtkcm06cHNwX2h3X3N0YXJ0IFthbWRncHVdXSAqRVJST1IqIEZhaWxl
ZCB0byBsb2FkIHRvYwpbICAgMTQuMzkxMjIzXSBbZHJtOnBzcF9od19zdGFydCBbYW1kZ3B1
XV0gKkVSUk9SKiBQU1AgdG1yIGluaXQgZmFpbGVkIQpbICAgMTQuNDExNDIzXSBbZHJtOnBz
cF9od19pbml0IFthbWRncHVdXSAqRVJST1IqIFBTUCBmaXJtd2FyZSBsb2FkaW5nIGZhaWxl
ZApbICAgMTQuNDExNjA0XSBbZHJtOmFtZGdwdV9kZXZpY2VfZndfbG9hZGluZyBbYW1kZ3B1
XV0gKkVSUk9SKiBod19pbml0IG9mIElQIGJsb2NrIDxwc3A+IGZhaWxlZCAtMjIKWyAgIDE0
LjQxMTc4NF0gYW1kZ3B1IDAwMDA6MDU6MDAuMDogYW1kZ3B1OiBhbWRncHVfZGV2aWNlX2lw
X2luaXQgZmFpbGVkClsgICAxNC40MTE3ODVdIGFtZGdwdSAwMDAwOjA1OjAwLjA6IGFtZGdw
dTogRmF0YWwgZXJyb3IgZHVyaW5nIEdQVSBpbml0ClsgICAxNC40MTE3ODZdIGFtZGdwdSAw
MDAwOjA1OjAwLjA6IGFtZGdwdTogYW1kZ3B1OiBmaW5pc2hpbmcgZGV2aWNlLgpbICAgMTQu
NDExOTI4XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgIDE0LjQx
MTkyOV0gV0FSTklORzogQ1BVOiA2IFBJRDogNTA3IGF0IGRyaXZlcnMvZ3B1L2RybS9hbWQv
YW1kZ3B1L2FtZGdwdV9pcnEuYzo2MjIgYW1kZ3B1X2lycV9wdXQrMHg0Ni8weDcwIFthbWRn
cHVdClsgICAxNC40MTIxMTRdIE1vZHVsZXMgbGlua2VkIGluOiBhbWRncHUoKykgdmlkZW8g
d21pIGFtZHhjcCBpMmNfYWxnb19iaXQgZHJtX3R0bV9oZWxwZXIgY3JjdDEwZGlmX3BjbG11
bCB0dG0gY3JjMzJfcGNsbXVsIGNyYzMyY19pbnRlbCBwb2x5dmFsX2NsbXVsbmkgZHJtX2V4
ZWMgcG9seXZhbF9nZW5lcmljIGdoYXNoX2NsbXVsbmlfaW50ZWwgZ3B1X3NjaGVkIG52bWUg
c2hhNTEyX3Nzc2UzIGRybV9zdWJhbGxvY19oZWxwZXIgZHJtX2J1ZGR5IHNoYTI1Nl9zc3Nl
MyBkcm1fZGlzcGxheV9oZWxwZXIgbnZtZV9jb3JlIHNoYTFfc3NzZTMgdmlydGlvX25ldCBj
ZWMgbnZtZV9hdXRoIHZpcnRpb19jb25zb2xlIG5ldF9mYWlsb3ZlciB2aXJ0aW9fYmxrIGZh
aWxvdmVyIHFlbXVfZndfY2ZnIHNlcmlvX3JhdyBpcDZfdGFibGVzIGlwX3RhYmxlcyBmdXNl
ClsgICAxNC40MTIxMzNdIENQVTogNiBQSUQ6IDUwNyBDb21tOiAodWRldi13b3JrZXIpIE5v
dCB0YWludGVkIDYuOC41LTIwMS5mYzM5Lng4Nl82NCAjMQpbICAgMTQuNDEyMTM0XSBIYXJk
d2FyZSBuYW1lOiBRRU1VIFN0YW5kYXJkIFBDIChRMzUgKyBJQ0g5LCAyMDA5KSwgQklPUyB1
bmtub3duIDAyLzAyLzIwMjIKWyAgIDE0LjQxMjEzNV0gUklQOiAwMDEwOmFtZGdwdV9pcnFf
cHV0KzB4NDYvMHg3MCBbYW1kZ3B1XQpbICAgMTQuNDEyMzA1XSBDb2RlOiBjMCA3NCAzMyA0
OCA4YiA0ZSAxMCA0OCA4MyAzOSAwMCA3NCAyOSA4OSBkMSA0OCA4ZCAwNCA4OCA4YiAwOCA4
NSBjOSA3NCAxMSBmMCBmZiAwOCA3NCAwNyAzMSBjMCBlOSA2YSAzMCBiYyBlMyBlOSA1YSBm
ZCBmZiBmZiA8MGY+IDBiIGI4IGVhIGZmIGZmIGZmIGU5IDU5IDMwIGJjIGUzIGI4IGVhIGZm
IGZmIGZmIGU5IDRmIDMwIGJjIGUzClsgICAxNC40MTIzMDZdIFJTUDogMDAxODpmZmZmYWFl
NTAxMTJiYTYwIEVGTEFHUzogMDAwMTAyNDYKWyAgIDE0LjQxMjMwOF0gUkFYOiBmZmZmOGJi
Y2NhM2VkMTAwIFJCWDogZmZmZjhiYmNkMTk5ODdhOCBSQ1g6IDAwMDAwMDAwMDAwMDAwMDAK
WyAgIDE0LjQxMjMwOV0gUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJTSTogZmZmZjhiYmNkMTlh
NGRiOCBSREk6IGZmZmY4YmJjZDE5ODAwMDAKWyAgIDE0LjQxMjMxMF0gUkJQOiBmZmZmOGJi
Y2QxOTkwMWU4IFIwODogMDAwMDAwMDAwMDAwMDAwMCBSMDk6IGZmZmZhYWU1MDExMmI4NzgK
WyAgIDE0LjQxMjMxMV0gUjEwOiBmZmZmYWFlNTAxMTJiODcwIFIxMTogMDAwMDAwMDAwMDAw
MDAwMyBSMTI6IGZmZmY4YmJjZDE5OTA1YzgKWyAgIDE0LjQxMjMxMV0gUjEzOiBmZmZmOGJi
Y2QxOTgwMDEwIFIxNDogZmZmZjhiYmNkMTk4MDAwMCBSMTU6IGZmZmY4YmJjZDE5YTRkYjgK
WyAgIDE0LjQxMjMxM10gRlM6ICAwMDAwN2Y1ZmRlMDNlOTgwKDAwMDApIEdTOmZmZmY4YmM0
MWZiODAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgMTQuNDEyMzE1XSBD
UzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzClsgICAx
NC40MTIzMTZdIENSMjogMDAwMDU2MjM3NDJmMTAwMCBDUjM6IDAwMDAwMDAxMGMxZmEwMDAg
Q1I0OiAwMDAwMDAwMDAwNzUwZWYwClsgICAxNC40MTIzMThdIFBLUlU6IDU1NTU1NTU0Clsg
ICAxNC40MTIzMTldIENhbGwgVHJhY2U6ClsgICAxNC40MTIzMjBdICA8VEFTSz4KWyAgIDE0
LjQxMjMyMV0gID8gYW1kZ3B1X2lycV9wdXQrMHg0Ni8weDcwIFthbWRncHVdClsgICAxNC40
MTI0OTNdICA/IF9fd2FybisweDgxLzB4MTMwClsgICAxNC40MTI0OTddICA/IGFtZGdwdV9p
cnFfcHV0KzB4NDYvMHg3MCBbYW1kZ3B1XQpbICAgMTQuNDEyNjc3XSAgPyByZXBvcnRfYnVn
KzB4MTcxLzB4MWEwClsgICAxNC40MTI2ODFdICA/IGhhbmRsZV9idWcrMHgzYy8weDgwClsg
ICAxNC40MTI2ODNdICA/IGV4Y19pbnZhbGlkX29wKzB4MTcvMHg3MApbICAgMTQuNDEyNjg1
XSAgPyBhc21fZXhjX2ludmFsaWRfb3ArMHgxYS8weDIwClsgICAxNC40MTI2ODhdICA/IGFt
ZGdwdV9pcnFfcHV0KzB4NDYvMHg3MCBbYW1kZ3B1XQpbICAgMTQuNDEyODU3XSAgYW1kZ3B1
X2ZlbmNlX2RyaXZlcl9od19maW5pKzB4ZmUvMHgxMzAgW2FtZGdwdV0KWyAgIDE0LjQxMzA0
OV0gIGFtZGdwdV9kZXZpY2VfZmluaV9odysweGE2LzB4NDAwIFthbWRncHVdClsgICAxNC40
MTMyMzNdICA/IGJsb2NraW5nX25vdGlmaWVyX2NoYWluX3VucmVnaXN0ZXIrMHgzNi8weDUw
ClsgICAxNC40MTMyMzZdICBhbWRncHVfZHJpdmVyX2xvYWRfa21zKzB4ZWMvMHgxOTAgW2Ft
ZGdwdV0KWyAgIDE0LjQxMzQxMV0gIGFtZGdwdV9wY2lfcHJvYmUrMHgxOGIvMHg1MTAgW2Ft
ZGdwdV0KWyAgIDE0LjQxMzU4Nl0gIGxvY2FsX3BjaV9wcm9iZSsweDQyLzB4YTAKWyAgIDE0
LjQxMzU4OV0gIHBjaV9kZXZpY2VfcHJvYmUrMHhjNy8weDI0MApbICAgMTQuNDEzNTkyXSAg
cmVhbGx5X3Byb2JlKzB4MTliLzB4M2UwClsgICAxNC40MTM1OTVdICA/IF9fcGZ4X19fZHJp
dmVyX2F0dGFjaCsweDEwLzB4MTAKWyAgIDE0LjQxMzU5N10gIF9fZHJpdmVyX3Byb2JlX2Rl
dmljZSsweDc4LzB4MTYwClsgICAxNC40MTM1OTldICBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4
MWYvMHg5MApbICAgMTQuNDEzNjAxXSAgX19kcml2ZXJfYXR0YWNoKzB4ZDIvMHgxYzAKWyAg
IDE0LjQxMzYwM10gIGJ1c19mb3JfZWFjaF9kZXYrMHg4NS8weGQwClsgICAxNC40MTM2MDVd
ICBidXNfYWRkX2RyaXZlcisweDExNi8weDIyMApbICAgMTQuNDEzNjA3XSAgZHJpdmVyX3Jl
Z2lzdGVyKzB4NTkvMHgxMDAKWyAgIDE0LjQxMzYwOV0gID8gX19wZnhfYW1kZ3B1X2luaXQr
MHgxMC8weDEwIFthbWRncHVdClsgICAxNC40MTM3NjhdICBkb19vbmVfaW5pdGNhbGwrMHg1
OC8weDMyMApbICAgMTQuNDEzNzcyXSAgZG9faW5pdF9tb2R1bGUrMHg2MC8weDI0MApbICAg
MTQuNDEzNzc1XSAgX19kb19zeXNfaW5pdF9tb2R1bGUrMHgxN2YvMHgxYjAKWyAgIDE0LjQx
Mzc3Nl0gID8gc3Jzb19hbGlhc19yZXR1cm5fdGh1bmsrMHg1LzB4ZmJlZjUKWyAgIDE0LjQx
Mzc4Ml0gIGRvX3N5c2NhbGxfNjQrMHg4My8weDE3MApbICAgMTQuNDEzNzg0XSAgPyBzcnNv
X2FsaWFzX3JldHVybl90aHVuaysweDUvMHhmYmVmNQpbICAgMTQuNDEzNzg2XSAgPyBfX2Nv
dW50X21lbWNnX2V2ZW50cysweDRkLzB4YzAKWyAgIDE0LjQxMzc4OF0gID8gc3Jzb19hbGlh
c19yZXR1cm5fdGh1bmsrMHg1LzB4ZmJlZjUKWyAgIDE0LjQxMzc5MF0gID8gY291bnRfbWVt
Y2dfZXZlbnRzLmNvbnN0cHJvcC4wKzB4MWEvMHgzMApbICAgMTQuNDEzNzkyXSAgPyBzcnNv
X2FsaWFzX3JldHVybl90aHVuaysweDUvMHhmYmVmNQpbICAgMTQuNDEzNzkzXSAgPyBoYW5k
bGVfbW1fZmF1bHQrMHhhMi8weDM2MApbICAgMTQuNDEzNzk1XSAgPyBzcnNvX2FsaWFzX3Jl
dHVybl90aHVuaysweDUvMHhmYmVmNQpbICAgMTQuNDEzNzk3XSAgPyBkb191c2VyX2FkZHJf
ZmF1bHQrMHgzMDQvMHg2NzAKWyAgIDE0LjQxMzgwMF0gID8gc3Jzb19hbGlhc19yZXR1cm5f
dGh1bmsrMHg1LzB4ZmJlZjUKWyAgIDE0LjQxMzgwMV0gID8gc3Jzb19hbGlhc19yZXR1cm5f
dGh1bmsrMHg1LzB4ZmJlZjUKWyAgIDE0LjQxMzgwM10gIGVudHJ5X1NZU0NBTExfNjRfYWZ0
ZXJfaHdmcmFtZSsweDc4LzB4ODAKWyAgIDE0LjQxMzgwNV0gUklQOiAwMDMzOjB4N2Y1ZmRl
YTJjYjllClsgICAxNC40MTM4MDhdIENvZGU6IDQ4IDhiIDBkIDk1IDEyIDBjIDAwIGY3IGQ4
IDY0IDg5IDAxIDQ4IDgzIGM4IGZmIGMzIDY2IDJlIDBmIDFmIDg0IDAwIDAwIDAwIDAwIDAw
IDkwIGYzIDBmIDFlIGZhIDQ5IDg5IGNhIGI4IGFmIDAwIDAwIDAwIDBmIDA1IDw0OD4gM2Qg
MDEgZjAgZmYgZmYgNzMgMDEgYzMgNDggOGIgMGQgNjIgMTIgMGMgMDAgZjcgZDggNjQgODkg
MDEgNDgKWyAgIDE0LjQxMzgwOV0gUlNQOiAwMDJiOjAwMDA3ZmZjMTNiZTg5OTggRUZMQUdT
OiAwMDAwMDI0NiBPUklHX1JBWDogMDAwMDAwMDAwMDAwMDBhZgpbICAgMTQuNDEzODExXSBS
QVg6IGZmZmZmZmZmZmZmZmZmZGEgUkJYOiAwMDAwNTYyMzc0MWM1NWEwIFJDWDogMDAwMDdm
NWZkZWEyY2I5ZQpbICAgMTQuNDEzODEyXSBSRFg6IDAwMDA1NjIzNzQxYmU1MzAgUlNJOiAw
MDAwMDAwMDAxOWQ1OGNlIFJESTogMDAwMDdmNWZkYjAwMDAxMApbICAgMTQuNDEzODEzXSBS
QlA6IDAwMDA3ZmZjMTNiZThhNTAgUjA4OiAwMDAwNTYyMzc0MTk5MDEwIFIwOTogMDAwMDAw
MDAwMDAwMDAwNwpbICAgMTQuNDEzODE0XSBSMTA6IDAwMDAwMDAwMDAwMDAwMDEgUjExOiAw
MDAwMDAwMDAwMDAwMjQ2IFIxMjogMDAwMDU2MjM3NDFiZTUzMApbICAgMTQuNDEzODE0XSBS
MTM6IDAwMDAwMDAwMDAwMjAwMDAgUjE0OiAwMDAwNTYyMzc0MWMwMDMwIFIxNTogMDAwMDU2
MjM3NDFjOTEyMApbICAgMTQuNDEzODE3XSAgPC9UQVNLPgpbICAgMTQuNDEzODE4XSAtLS1b
IGVuZCB0cmFjZSAwMDAwMDAwMDAwMDAwMDAwIF0tLS0KCg==

--------------RsT4sNfODtKbj8IZrW0O1j69--


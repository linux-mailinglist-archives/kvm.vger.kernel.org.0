Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5AA549D2DE
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 20:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244600AbiAZTzB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 14:55:01 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:39453 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244579AbiAZTzA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jan 2022 14:55:00 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id F40813201FD6;
        Wed, 26 Jan 2022 14:54:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 26 Jan 2022 14:54:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm3; bh=f8I0o6NPM8K1EBbD3rJ8cLZ6Cr7wmb4R2eUWSHNkDdk=; b=WJJTT
        piW6af//xZVAt6XnQRtMcFBKgG2lMm6mymRv6YV7o7vgl5k8KYasjGq8R8ktj/Fu
        A0jWx/u/NysGkeQV2JaqngxoWCEWCM972/Ue7znBr+b8URGKGyKQzfX2BiOAcneK
        G/BX00MS37I6FVt4cZNOH8QlHxOzYU6kVtwk5MZmrSqx6c9kTK60w7h8brRogl2q
        eWArn7YTqamXkyJZXHMdhxyppkBSXVX4x+1SIJRT05FW6i7zprbFL2XXlJu2U3Ys
        78k70hGebcXFYNpHva90OY2hY0GUQDEKsoPIUOZrxYCUSlbDzWHprftjvhfiu+g/
        ku273QvpNZ20Y8cFg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:message-id:mime-version:reply-to:sender
        :subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm1; bh=f8I0o6NPM8K1EBbD3rJ8cLZ6Cr7wm
        b4R2eUWSHNkDdk=; b=F6EfVAT7c0Uc5Xw13oCf4OsuIsdaEN+PSvr0/ge55RUFn
        JE84AGgq4oudavHFVb8iAtkyx3NjLBC/jdD3xfetXKF9PvW0CNQHgklCtZ1pQk7W
        Ho7IA80Z/CtfmOJpy31w4XGiMWP77F5g4ZOfVX/ixzkOv+kgsMazZSFX2pk5WxUz
        Brmz0iXXBy21dbp5AI+rZOcDlVFxAn9Nd6D7F2VaJGsxK1fhKGtqMpVWYWptPPd0
        9u0ClFx/iZXuouvFZESAEYQGa6wf8Z3vZpXKy/BeDt3vpWka16fN/WPnYTKqZa0q
        k6wKRisdIoVrDbskZq59GJFQ7nTy8YwbbaHWKdMHA==
X-ME-Sender: <xms:EafxYTHGao38tZbfhTKroHPCSlTv-7BdaACCczeZOoM7tIJCoDia6g>
    <xme:EafxYQWFqJ_F-5nOYdaJ_s4YFSJCkwgz1WDZT3BoZCFp5PYXa2zH1nf2SQ4JWOPDY
    1EbeZqJEUWmKTscotc>
X-ME-Received: <xmr:EafxYVJ5P1B5bVBnc8dS_pG2UGZm_yfuIqDXjQQXW_HKpMU_DHe7swLh2B5JUNTQE52vI7Bv8Re09hpjJhmfJRP23J4pIw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrfedugdduvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeeuohhrihhsuceu
    uhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepudeitd
    elueeijeefleffveelieefgfejjeeigeekudduteefkefffeethfdvjeevnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessghurh
    drihho
X-ME-Proxy: <xmx:EafxYRHAgWrIlcZna93tDEKVlU4oR-52pAyPtWmVk4vxO_zUR8FAUw>
    <xmx:EafxYZXRvfWZuLXNNr-3IsWIbW0mygcMLyv_PUbzBLBRRbk3hqAfmw>
    <xmx:EafxYcO2YBj-H43ui3BzVCwXP65LGp9VBSI_S7LAs9DmKFX70F-cPQ>
    <xmx:EafxYYdc0L3HheEB_S4gTfwARPjT08WLtiFaJc5XaetoVDJAEb4ZtA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Jan 2022 14:54:57 -0500 (EST)
From:   Boris Burkov <boris@bur.io>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kernel-team@fb.com
Subject: [PATCH] KVM: use set_page_dirty rather than SetPageDirty
Date:   Wed, 26 Jan 2022 11:54:55 -0800
Message-Id: <08b5b2c516b81788ca411dc031d403de4594755e.1643226777.git.boris@bur.io>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At Facebook, we have hit a bug in an interaction between KVM and btrfs
running android emulators in a build/test environment using the android
emulator's ram snapshot features (-snapshot and -snapstorage). The
important aspect of those features is that they result in qemu mmap-ing
a file rather than anonymous memory for the guest's memory.

Ultimately, we observe (with drgn) pages of the mapped file stuck in
btrfs writeback because the mapping's xarray lacks the expected dirty
tags. I have not yet been able to pin down the exact vm behavior that
results in these bad kvm_set_pfn_dirty calls, but I caught them by
instrumenting SetPageDirty with a warning, getting a stack trace like:

RIP: 0010:kvm_set_pfn_dirty+0xaf/0xd0 [kvm]
<snip>
 Call Trace:
  kvm_release_pfn+0x2d/0x40 [kvm]
  __kvm_map_gfn+0x115/0x2b0 [kvm]
  kvm_arch_vcpu_ioctl_run+0x1538/0x1b30 [kvm]
  ? call_function_interrupt+0xa/0x20
  kvm_vcpu_ioctl+0x232/0x5e0 [kvm]
  ksys_ioctl+0x83/0xc0
  __x64_sys_ioctl+0x16/0x20
  do_syscall_64+0x42/0x110
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

kvm_arch_vcpu_ioctl_run+0x1538 is the call to complete_userspace_io on
line 8728, for what it's worth. I also confirmed that the page being
dirtied in this codepath is the one we end up stuck on.

This is on a kernel based off of 5.6, but as far as I can tell, the
behavior in KVM is still incorrect currently, as it doesn't account for
file backed pages.

I tested this fix on the workload and it did prevent the hangs. However,
I am unsure if the fix is appropriate from a locking perspective, so I
hope to draw some extra attention to that aspect. set_page_dirty_lock in
mm/page-writeback.c has a comment about locking that says set_page_dirty
should be called with the page locked or while definitely holding a
reference to the mapping's host inode. I believe that the mmap should
have that reference, so for fear of hurting KVM performance or
introducing a deadlock, I opted for the unlocked variant.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2755ba4177d6..432c109664c3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2811,7 +2811,7 @@ EXPORT_SYMBOL_GPL(kvm_release_pfn_dirty);
 void kvm_set_pfn_dirty(kvm_pfn_t pfn)
 {
 	if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn))
-		SetPageDirty(pfn_to_page(pfn));
+		set_page_dirty(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
 
-- 
2.34.0


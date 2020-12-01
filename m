Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6742C9796
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 07:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgLAGgZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 01:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgLAGgZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Dec 2020 01:36:25 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7AFC0613CF
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 22:35:44 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id v22so1484539edt.9
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 22:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=S43PKtEcjZv88RH3tWBFcTkeH+4F4E0oX/oGz7vFOqI=;
        b=nTcdL2Mr0svJ68JE+t1HqftBehCy5BwLl7k4FJJ9RZxKob4h+aBNNtlJM/MV4su6dG
         0yHFpLjkQKK8sWtt9v6YmaWEB68SfeqrPsJRkn9k5mPy/9pMdm5WYF8NXt9vf1rBxpIN
         bcJSl2/FsxoJvWApWvgg/OgOtaUdQIDd78+FFk4k7q58i0Z086+6IpW4KZJTOXGA+85O
         j5wrqWB+hr4XXs2tdBkO2qo0M4S2IKIVNvOvXoYOAA/5QrGCOcbttGlSe97w7o7l9Z0p
         jdlhWF+ZXMmaNzes2RQFD2K6DPvfaTHa5nJSSFNLJCSX73dr7Zs6ctqXDp2Qn329q5HK
         SEvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S43PKtEcjZv88RH3tWBFcTkeH+4F4E0oX/oGz7vFOqI=;
        b=PbMYMe5zZEn+gyBOthfPx+8HlTQEciOxELZlfPG/ebcqQVrq5/os6x98dDDKd/UfZk
         yqf084dXjMYsL58DjxGXg3EqCjY3az26LR72QPqLAEPzcSigAl7tBtifbOnbBt0Exyke
         cX8skoNknloVAaUopbooC9FzVGDj0jO7UQ8ZFDBc4dmsuhKP/bAJLsG+TZEZvIGk3wWM
         eFgB6VXqBhVeJ31wlG+WwxZeLdrlm2MMmigVNeDpkfOXnFIgTxCUQPxuwoxYe5IXfhjs
         un8hZeBdS7jbTVjzEkh9NQTgQYo2DZ1y7TXrmZQORDz63H9DzjFK4GaGWlMZLXze9Uxh
         julw==
X-Gm-Message-State: AOAM530rwBEr0DQzfwl9D4HOJc1RhNzhb6RfONVB+0IpZUCu6AUxmLG/
        xXX3DWCcU1qDT5LQ4Udg55rg9wFRXYU=
X-Google-Smtp-Source: ABdhPJw5G7y0A1Gq67b5cvnDYKCCgH3sfrn03OQn4e+0mGUV3tO/faCx1shxM8M56HmsG6EEgwW+UA==
X-Received: by 2002:a50:ff05:: with SMTP id a5mr1507919edu.43.1606804542742;
        Mon, 30 Nov 2020 22:35:42 -0800 (PST)
Received: from vm1 (ip-86-49-65-192.net.upcbroadband.cz. [86.49.65.192])
        by smtp.gmail.com with ESMTPSA id m7sm322094ejo.125.2020.11.30.22.35.42
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 22:35:42 -0800 (PST)
Date:   Tue, 1 Dec 2020 07:35:37 +0100
From:   Zdenek Kaspar <zkaspar82@gmail.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Bad performance since 5.9-rc1
Message-ID: <20201201073537.6749e2d7.zkaspar82@gmail.com>
In-Reply-To: <20201119040526.5263f557.zkaspar82@gmail.com>
References: <20201119040526.5263f557.zkaspar82@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 Nov 2020 04:05:26 +0100
Zdenek Kaspar <zkaspar82@gmail.com> wrote:

> Hi,
> 
> in my initial report (https://marc.info/?l=kvm&m=160502183220080&w=2 -
> now fixed by c887c9b9ca62c051d339b1c7b796edf2724029ed) I saw degraded
> performance going back somewhere between v5.8 - v5.9-rc1.
> 
> OpenBSD 6.8 (GENERIC.MP) guest performance (time ./test-build.sh)
> good: 0m13.54s real     0m10.51s user     0m10.96s system
> bad : 6m20.07s real    11m42.93s user     0m13.57s system
> 
> bisected to first bad commit: 6b82ef2c9cf18a48726e4bb359aa9014632f6466
> 
> git bisect log:
> # bad: [e47c4aee5bde03e7018f4fde45ba21028a8f8438] KVM: x86/mmu: Rename
> page_header() to to_shadow_page() # good:
> [01c3b2b5cdae39af8dfcf6e40fdf484ae0e812c5] KVM: SVM: Rename
> svm_nested_virtualize_tpr() to nested_svm_virtualize_tpr() git bisect
> start 'e47c4aee5bde' '01c3b2b5cdae' # bad:
> [ebdb292dac7993425c8e31e2c21c9978e914a676] KVM: x86/mmu: Batch zap MMU
> pages when shrinking the slab git bisect bad
> ebdb292dac7993425c8e31e2c21c9978e914a676 # good:
> [fb58a9c345f645f1774dcf6a36fda169253008ae] KVM: x86/mmu: Optimize MMU
> page cache lookup for fully direct MMUs git bisect good
> fb58a9c345f645f1774dcf6a36fda169253008ae # bad:
> [6b82ef2c9cf18a48726e4bb359aa9014632f6466] KVM: x86/mmu: Batch zap MMU
> pages when recycling oldest pages git bisect bad
> 6b82ef2c9cf18a48726e4bb359aa9014632f6466 # good:
> [f95eec9bed76d42194c23153cb1cc8f186bf91cb] KVM: x86/mmu: Don't put
> invalid SPs back on the list of active pages git bisect good
> f95eec9bed76d42194c23153cb1cc8f186bf91cb # first bad commit:
> [6b82ef2c9cf18a48726e4bb359aa9014632f6466] KVM: x86/mmu: Batch zap MMU
> pages when recycling oldest pages
> 
> Host machine is old Intel Core2 without EPT (TDP).
> 
> TIA, Z.

Hi, with v5.10-rc6:
get_mmio_spte: detect reserved bits on spte, addr 0xfe00d000, dump hierarchy:
------ spte 0x8000030e level 3.
------ spte 0xaf82027 level 2.
------ spte 0x2038001ffe00d407 level 1.
------------[ cut here ]------------
WARNING: CPU: 1 PID: 355 at kvm_mmu_page_fault.cold+0x42/0x4f [kvm]
...
CPU: 1 PID: 355 Comm: qemu-build Not tainted 5.10.0-rc6-amd64 #1
Hardware name:  /DG35EC, BIOS ECG3510M.86A.0118.2010.0113.1426 01/13/2010
RIP: 0010:kvm_mmu_page_fault.cold+0x42/0x4f [kvm]
Code: e2 ec 44 8b 04 24 8b 5c 24 0c 44 89 c5 89 da 83 eb 01 48 c7 c7 20 b2 65 c0 48 63 c3 48 8b 74 c4 30 e8 dd 74 e2 ec 39 dd 7e e3 <0f> 0b 41 b8 ea ff ff ff e9 27 99 ff ff 0f 0b 48 8b 54 24 10 48 83
RSP: 0018:ffffb67400653d30 EFLAGS: 00010202
RAX: 0000000000000027 RBX: 0000000000000000 RCX: ffffa271ff2976f8
RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffffa271ff2976f0
RBP: 0000000000000001 R08: ffffffffadd02ae8 R09: 0000000000000003
R10: 00000000ffffe000 R11: 3fffffffffffffff R12: 00000000fe00d000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000001
FS:  00007fc10ae3d640(0000) GS:ffffa271ff280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000002dc2000 CR4: 00000000000026e0
Call Trace:
 kvm_arch_vcpu_ioctl_run+0xbaf/0x18f0 [kvm]
 ? do_futex+0x7c4/0xb80
 kvm_vcpu_ioctl+0x203/0x520 [kvm]
 ? set_next_entity+0x5b/0x80
 ? __switch_to_asm+0x32/0x60
 ? finish_task_switch+0x70/0x260
 __x64_sys_ioctl+0x338/0x720
 ? __x64_sys_futex+0x120/0x190
 do_syscall_64+0x33/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fc10c389f6b
Code: 89 d8 49 8d 3c 1c 48 f7 d8 49 39 c4 72 b5 e8 1c ff ff ff 85 c0 78 ba 4c 89 e0 5b 5d 41 5c c3 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d d5 ae 0c 00 f7 d8 64 89 01 48
RSP: 002b:00007fc10ae3c628 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007fc10c389f6b
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000012
RBP: 000055ad3767baf0 R08: 000055ad36be4850 R09: 00000000000000ff
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
R13: 000055ad371d9800 R14: 0000000000000001 R15: 0000000000000002
---[ end trace c5f7ae690f5abcc4 ]---

without: kvm: x86/mmu: Fix get_mmio_spte() on CPUs supporting 5-level PT
I can run guest again, but with degraded performance as before.

Z.

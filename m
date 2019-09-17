Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C11DEB4915
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 10:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732986AbfIQISU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 04:18:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36826 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732005AbfIQISU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 04:18:20 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8BD8D83F42
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 08:18:19 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id 124so469436wmz.1
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 01:18:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qRyrFKgOm48KkKg55Dl+vUukfxK99uW3Zie+F4GtPtQ=;
        b=PTb0hxFysnLCjlH1Wx302yyaU1Gxx6TX4gHMqhV5biZ+BGeXasiyEPAx7PZ3WWWI7k
         yC1lWmWk7wFnY+yQVqTfQQB6+JCFUvcDKUSp8pfRNmW3SyanVcKR/n0aRrMjJA9DsVOZ
         m8kUR6ECXzTwlNTOgDpjxOA78qMBGZvgS6oOlCzB9r7eT+enmcvEmc+cTNaaGE2n1kgB
         LxKuA3DjFAhcB7BowgDRJwvTV6RqIxP8pPqkDciTm9Y3bHUhKAp0fWxaDP1C8tVAHaFi
         QNlPLK4SzAnI9V7CJAWdM301QBIJqr++avGdiyAqr6fK5omdKLaA/fb/zhJr1wrSS/Yx
         UZAQ==
X-Gm-Message-State: APjAAAWwyxeGnKOy3hXqaPsAcHTYloU4OH5PF3xYLsnMFOxE0+3ecd+Q
        lijhkdjvnzAl6FrYOCU+imC/WZmx5/xi7eHS+Qrr7OhCouLIMkbuZQ50DcSn0it1tKrg9A4ksAS
        br7ozYenm6Ovf
X-Received: by 2002:adf:e548:: with SMTP id z8mr1879068wrm.324.1568708298091;
        Tue, 17 Sep 2019 01:18:18 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwCfHMrixhy4NM9wsotuqqspSjFXXw/P/RLA2EqCwu+G5IRiXW42RqN3pEaaPcqbfI2jIW1UQ==
X-Received: by 2002:adf:e548:: with SMTP id z8mr1879043wrm.324.1568708297784;
        Tue, 17 Sep 2019 01:18:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c46c:2acb:d8d2:21d8? ([2001:b07:6468:f312:c46c:2acb:d8d2:21d8])
        by smtp.gmail.com with ESMTPSA id y186sm2997074wmb.41.2019.09.17.01.18.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Sep 2019 01:18:17 -0700 (PDT)
Subject: Re: [PATCH 1/3] KVM: Fix coalesced mmio ring buffer out-of-bounds
 access
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     P J P <ppandit@redhat.com>, Jim Mattson <jmattson@google.com>
References: <1568708186-20260-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f4549d5a-d948-f1d1-2a29-8c4621dae1b0@redhat.com>
Date:   Tue, 17 Sep 2019 10:18:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1568708186-20260-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I think we should consider the embargo for CVE-2019-14821 to be broken.
 Since your patch is better, I'll push that one instead as soon as I get
confirmation.

Paolo

On 17/09/19 10:16, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Reported by syzkaller:
> 
> 	#PF: supervisor write access in kernel mode
> 	#PF: error_code(0x0002) - not-present page
> 	PGD 403c01067 P4D 403c01067 PUD 0
> 	Oops: 0002 [#1] SMP PTI
> 	CPU: 1 PID: 12564 Comm: a.out Tainted: G           OE     5.3.0-rc4+ #4
> 	RIP: 0010:coalesced_mmio_write+0xcc/0x130 [kvm]
> 	Call Trace:
> 	 __kvm_io_bus_write+0x91/0xe0 [kvm]
> 	 kvm_io_bus_write+0x79/0xf0 [kvm]
> 	 write_mmio+0xae/0x170 [kvm]
> 	 emulator_read_write_onepage+0x252/0x430 [kvm]
> 	 emulator_read_write+0xcd/0x180 [kvm]
> 	 emulator_write_emulated+0x15/0x20 [kvm]
> 	 segmented_write+0x59/0x80 [kvm]
> 	 writeback+0x113/0x250 [kvm]
> 	 x86_emulate_insn+0x78c/0xd80 [kvm]
> 	 x86_emulate_instruction+0x386/0x7c0 [kvm]
> 	 kvm_mmu_page_fault+0xf9/0x9e0 [kvm]
> 	 handle_ept_violation+0x10a/0x220 [kvm_intel]
> 	 vmx_handle_exit+0xbe/0x6b0 [kvm_intel]
> 	 vcpu_enter_guest+0x4dc/0x18d0 [kvm]
> 	 kvm_arch_vcpu_ioctl_run+0x407/0x660 [kvm]
> 	 kvm_vcpu_ioctl+0x3ad/0x690 [kvm]
> 	 do_vfs_ioctl+0xa2/0x690
> 	 ksys_ioctl+0x6d/0x80
> 	 __x64_sys_ioctl+0x1a/0x20
> 	 do_syscall_64+0x74/0x720
> 	 entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 	RIP: 0010:coalesced_mmio_write+0xcc/0x130 [kvm]
> 
> Both the coalesced_mmio ring buffer indexs ring->first and ring->last are 
> bigger than KVM_COALESCED_MMIO_MAX from the testcase, array out-of-bounds 
> access triggers by ring->coalesced_mmio[ring->last].phys_addr = addr; 
> assignment. This patch fixes it by mod indexs by KVM_COALESCED_MMIO_MAX.
> 
> syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=134b2826a00000
> 
> Reported-by: syzbot+983c866c3dd6efa3662a@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  virt/kvm/coalesced_mmio.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
> index 5294abb..cff1ec9 100644
> --- a/virt/kvm/coalesced_mmio.c
> +++ b/virt/kvm/coalesced_mmio.c
> @@ -73,6 +73,8 @@ static int coalesced_mmio_write(struct kvm_vcpu *vcpu,
>  
>  	spin_lock(&dev->kvm->ring_lock);
>  
> +	ring->first = ring->first % KVM_COALESCED_MMIO_MAX;
> +	ring->last = ring->last % KVM_COALESCED_MMIO_MAX;
>  	if (!coalesced_mmio_has_room(dev)) {
>  		spin_unlock(&dev->kvm->ring_lock);
>  		return -EOPNOTSUPP;
> 


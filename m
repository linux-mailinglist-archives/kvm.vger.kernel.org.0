Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19005470F44
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 01:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345390AbhLKAOq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 19:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345384AbhLKAOp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 19:14:45 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D373FC061714
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 16:11:09 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id y13so34320811edd.13
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 16:11:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tLiIMv0bhgfBDZjfBi0RKoNihcfO6WCiID5jtSMK2U0=;
        b=KEz5oep4tc5C5a+dWs+P60cXfmMRk4rjQA0FqMlsSLcLA1T1IVVkeStyNWzLz8cVH6
         C6d66qIDvPvZc+NODiIkMok0FnU+2AYKcasIoVVatrkcDZUap1AciNls/B9VtO3rOV5x
         A3oXDbIKv4ZC4MrXUEevO9GAGUQ2W6KamUJcIOV0cOYtWDubFbkvmGADp2d9IsyCAVn1
         MOG1RjMaTx0r4rQcm3ryYricEGvlL/X82tY2tlrdWQ9Sx9I8Stwre0vzXccfcqTkOKfL
         0dL/o3vvYAbET/pvWAKotfVb2UcJ+YJPvWmdZgm+QymTTfmrvVKcYJ6y4ZCHJZREaTnL
         65VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tLiIMv0bhgfBDZjfBi0RKoNihcfO6WCiID5jtSMK2U0=;
        b=r6dn40gs2vEwkFizy4HHAn6Me4FWhN/15muCwYDsv8yIHwTf/GkqBJnUP0JJe9cWkT
         1ZyeonLBI/Y0qLd3pGep4fJwDEnr0/+tefm5yzK1NLd1SC1hxd9rvYFEhwk7S+vXxQ9f
         FMCkF1e+0dT3NgOcXnS+m1Q/TGUwoNGUeRbRDHBeDR8NQoCD/1sPmPKnLBpw1YcJM2W+
         wTSMTfUqkIxVvQNA7dSyzuDWdn72A1w9jLvueQB6bnDlHdPUq/Rj4ZJU7VqPxPwYUFrV
         7wO9fg5K2DOk2CYHIg7mar5AKBGtdRklXjXSkUyavjKHiAXJiQrsYxDrmlfgvemM9Z1a
         5xJQ==
X-Gm-Message-State: AOAM533LO0qWe9PtloDYMDhiVfzxjdMUC9lLHA3OtVylyWAPqOMqRv/8
        hSBSUV4ouXK1FNActPX1/E76Z6UyGxo=
X-Google-Smtp-Source: ABdhPJzcjAo9PwOEowG+qHDyZ07VKIIOR0RVrqnvcOAT6BphLOdxkAY9RlXwLxRrVieNLOSc0sjhNQ==
X-Received: by 2002:a17:907:a414:: with SMTP id sg20mr27640905ejc.183.1639181468245;
        Fri, 10 Dec 2021 16:11:08 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:48f9:bea:a04c:3dfe? ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
        by smtp.googlemail.com with ESMTPSA id x14sm2153380ejs.124.2021.12.10.16.11.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 16:11:07 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <d22eb5e1-0e9d-707d-8482-c63857e87b0d@redhat.com>
Date:   Sat, 11 Dec 2021 01:11:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: VM_BUG_ON in vmx_prepare_switch_to_guest->__get_current_cr3_fast
 at kvm/queue
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Cc:     seanjc@google.com, vkuznets@redhat.com, laijs@linux.alibaba.com
References: <YbOVBDCcpuwtXD/7@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YbOVBDCcpuwtXD/7@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/21 18:57, David Matlack wrote:
> While testing some patches I ran into a VM_BUG_ON that I have been able to
> reproduce at kvm/queue commit 45af1bb99b72 ("KVM: VMX: Clean up PI
> pre/post-block WARNs").
> 
> To repro run the kvm-unit-tests on a kernel built from kvm/queue with
> CONFIG_DEBUG_VM=y. I was testing on an Intel Cascade Lake host and have not
> tested in any other environments yet. The repro is not 100% reliable, although
> it's fairly easy to trigger and always during a vmx* kvm-unit-tests
> 
> Given the details of the crash, commit 15ad9762d69f ("KVM: VMX: Save HOST_CR3
> in vmx_prepare_switch_to_guest()") and surrounding commits look most suspect.

Yeah, vmx_prepare_switch_to_guest() doesn't update HOST_CR3 if no 
preemption happens from one call of vcpu_enter_guest() to the next 
(preemption would cause a call to kvm_arch_vcpu_put and from there to 
vmx_prepare_switch_to_host, which clears vmx->guest_state_loaded).

During that time an MM switch is bumping the PCID; I would have expected 
any such flush to require a preemption (in order to reach e.g. 
switch_mm_irqs_off), but that must be wrong.  In the splat below in fact 
you can see that the values are 0x60674f2005 (RAX) and 0x60674f2006 (RCX 
and CR3).

My fault for actually having seen the VM_BUG_ON, but erroneously 
thinking that it started happening during the merge window rather than 
with the new kvm/next patches. :(

Paolo

> 
> The splat:
> 
> [  698.724442] ------------[ cut here ]------------
> [  698.729095] kernel BUG at arch/x86/mm/tlb.c:1082!
> [  698.733838] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
> [  698.740475] CPU: 29 PID: 63256 Comm: qemu-kvm-system Tainted: G S         O      5.16.0-dbg-DEV #1
> [  698.756882] RIP: 0010:__get_current_cr3_fast+0xe6/0x110
> [  698.762134] Code: 3b 4d f8 75 27 48 83 c4 10 5d c3 0f 0b eb df 0f 0b eb 98 0f 0b eb a2 66 85 c9 75 15 48 39 d0 76 17 48 8b 0d dc a7 b9 01 eb 1c <0f> 0b e8 23 8c ba 00 0f 0b 48 39 d0 77 e9 48 c7 c1 00 00 00 80 48
> [  698.780967] RSP: 0018:ffffc90039c6fa50 EFLAGS: 00010297
> [  698.786209] RAX: 00000060674f2005 RBX: ffff88e0911d5380 RCX: 00000060674f2006
> [  698.793366] RDX: 0000000000000004 RSI: 0000000000000000 RDI: ffff88e0985eec18
> [  698.800524] RBP: ffffc90039c6fa60 R08: ffff893e5bf40000 R09: 0000000000000000
> [  698.807682] R10: 00000000000206dd R11: 0000000000000000 R12: ffff88e0985ec8c0
> [  698.814838] R13: 0000000000000000 R14: ffff88e0985eec18 R15: ffff893e5bf40000
> [  698.821997] FS:  00007f5b823ff700(0000) GS:ffff893e5bf40000(0000) knlGS:0000000000000000
> [  698.830114] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  698.835877] CR2: 0000000000000000 CR3: 00000060674f2006 CR4: 00000000003726e0
> [  698.843034] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  698.850192] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  698.857349] Call Trace:
> [  698.859801]  <TASK>
> [  698.861907]  vmx_prepare_switch_to_guest+0x11f/0x290 [kvm_intel]
> [  698.867945]  vcpu_enter_guest+0x128b/0x24b0 [kvm]
> [  698.872719]  ? __this_cpu_preempt_check+0x13/0x20
> [  698.877446]  ? lock_is_held_type+0xff/0x170
> [  698.881646]  ? __this_cpu_preempt_check+0x13/0x20
> [  698.886371]  ? lock_is_held_type+0xff/0x170
> [  698.890568]  ? __lock_acquire+0x91e/0xf00
> [  698.894599]  ? __lock_acquire+0x91e/0xf00
> [  698.898622]  ? __this_cpu_preempt_check+0x13/0x20
> [  698.903348]  ? lock_acquire+0xda/0x210
> [  698.907111]  ? trace_kvm_pio+0x2c/0xd0 [kvm]
> [  698.911422]  vcpu_run+0x90/0x370 [kvm]
> [  698.915211]  kvm_arch_vcpu_ioctl_run+0x173/0x330 [kvm]
> [  698.920394]  kvm_vcpu_ioctl+0x5e3/0x6b0 [kvm]
> [  698.924792]  ? rcu_lock_release+0x10/0x20
> [  698.928824]  ? __fget_files+0x1bb/0x1d0
> [  698.932672]  __se_sys_ioctl+0x77/0xc0
> [  698.936355]  __x64_sys_ioctl+0x1d/0x20
> [  698.940116]  do_syscall_64+0x44/0xa0
> [  698.943702]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  698.948769] RIP: 0033:0x7f5b8b60b947
> [  698.952355] Code: 73 01 c3 48 8b 0d 31 f5 16 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 01 f5 16 00 f7 d8 64 89 01 48
> [  698.971187] RSP: 002b:00007f5b823fe4d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [  698.978780] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f5b8b60b947
> [  698.985937] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 000000000000000e
> [  698.993093] RBP: 00007f5b823fe5c0 R08: 0000000000000400 R09: 00000000000000ff
> [  699.000251] R10: 0000550e7e92ed00 R11: 0000000000000246 R12: 00007f5b8a4a6000
> [  699.007410] R13: 0000550e7f95c000 R14: 0000000000000000 R15: 0000550e7f95c000
> [  699.014571]  </TASK>
> [  699.034357] ---[ end trace ee35b3363814d971 ]---
> 
> ... which is the following VM_BUG_ON:
> 
>    1074 unsigned long __get_current_cr3_fast(void)
>    1075 {
>    1076          unsigned long cr3 = build_cr3(this_cpu_read(cpu_tlbstate.loaded_mm)->pgd,
>    1077                 this_cpu_read(cpu_tlbstate.loaded_mm_asid));
>    1078
>    1079         /* For now, be very restrictive about when this can be called. */
>    1080         VM_WARN_ON(in_nmi() || preemptible());
>    1081
>    1082         VM_BUG_ON(cr3 != __read_cr3());  <------------
>    1083         return cr3;
>    1084 }
> 


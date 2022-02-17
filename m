Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18AA24BAAC6
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 21:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343491AbiBQUVz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 15:21:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245757AbiBQUVx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 15:21:53 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6706411C32
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 12:21:37 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id y5so624050pfe.4
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 12:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=J+kkJEgtKVKfZWSWuqwk05pdmtbCDQvsRGxh7snwGnI=;
        b=h7FWftArjaHElOVGGHKgY40qeoYxYzPPBTvceI6yG+1vgWXPzGQI522y+69W8hdAjv
         lROKGkrewyEYZdQ2veyqb048ObAc1YlQfOJvxFMCcCRAlI3wHg6fEjREIXUaebmV/GKe
         76/S+jQiMWFcNYJVL7vqixjuU7Zh5XYdJupoUOPWyux1LKquiu4qug7wOPhqAX9uY9HW
         vLTHANz2iRkPHYDFwqIXAJYqAOBWNDSOrLeOMfeJBRYTZCSlZaxzQ5fZAidEgKVfn6fN
         gOzrFzf13UXqWelkbD//g0yQQUn3XmoyVf6SCu8gVI0mECgRk7x9lTMMWyTgg1krJEot
         zDVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=J+kkJEgtKVKfZWSWuqwk05pdmtbCDQvsRGxh7snwGnI=;
        b=N6FVwof0XFjvP9tF6p2zWVdCFIuDkZsyKDs6OCViKAi1rC+EMu6qJMC3aTssOfHnT3
         qTZ6K042qw5g02x3ql4DSDOMY6vU7uO/yW77sFf5Ge1dUs9WsOHGJDpZHaycysH8RKSZ
         EuYnCylaRw8UhVetGAo8BiVcaUori97Ow75UxnuGQDZBBAjKkpi3WZcmG7naIUpsKnr/
         a2A/9Up8rbOwWlbWag2525dOTLAomKWuuHMIKSI9bMoe9qDl1qDUOxrz0p291IldPhNP
         d/wf7LLpFXuwPJfK/cAr7wevRu+gUojXCG4NfyGpEcsXocU0a4c+7SH2VMp9G7CX8j/H
         X0Hg==
X-Gm-Message-State: AOAM531q0qVaeDSxstRxPToccCz3yRHT+ERzx8FPVqgwW1PiyL94rCyY
        Hh2kAz/9HC26ctgwEL7C0aJdog==
X-Google-Smtp-Source: ABdhPJzQicmY1LsxlAXt7Nu8jPmDKZmHtBAbJ7a0NHzf+nhxMBMTRhziuc3NyshtcAhItPBQ8prW6Q==
X-Received: by 2002:a05:6a00:16d3:b0:4cb:51e2:1923 with SMTP id l19-20020a056a0016d300b004cb51e21923mr4402640pfc.7.1645129296888;
        Thu, 17 Feb 2022 12:21:36 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id r13sm3859043pgb.22.2022.02.17.12.21.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Feb 2022 12:21:36 -0800 (PST)
Message-ID: <db8a9edd-533e-3502-aed1-e084d6b55e48@linaro.org>
Date:   Thu, 17 Feb 2022 12:21:35 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+8112db3ab20e70d50c31@syzkaller.appspotmail.com
References: <20220125220358.2091737-1-seanjc@google.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH] KVM: x86: Forcibly leave nested virt when SMM state is
 toggled
In-Reply-To: <20220125220358.2091737-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/25/22 14:03, Sean Christopherson wrote:
> Forcibly leave nested virtualization operation if userspace toggles SMM
> state via KVM_SET_VCPU_EVENTS or KVM_SYNC_X86_EVENTS.  If userspace
> forces the vCPU out of SMM while it's post-VMXON and then injects an SMI,
> vmx_enter_smm() will overwrite vmx->nested.smm.vmxon and end up with both
> vmxon=false and smm.vmxon=false, but all other nVMX state allocated.
> 
> Don't attempt to gracefully handle the transition as (a) most transitions
> are nonsencial, e.g. forcing SMM while L2 is running, (b) there isn't
> sufficient information to handle all transitions, e.g. SVM wants access
> to the SMRAM save state, and (c) KVM_SET_VCPU_EVENTS must precede
> KVM_SET_NESTED_STATE during state restore as the latter disallows putting
> the vCPU into L2 if SMM is active, and disallows tagging the vCPU as
> being post-VMXON in SMM if SMM is not active.
> 
> Abuse of KVM_SET_VCPU_EVENTS manifests as a WARN and memory leak in nVMX
> due to failure to free vmcs01's shadow VMCS, but the bug goes far beyond
> just a memory leak, e.g. toggling SMM on while L2 is active puts the vCPU
> in an architecturally impossible state.
> 
>    WARNING: CPU: 0 PID: 3606 at free_loaded_vmcs arch/x86/kvm/vmx/vmx.c:2665 [inline]
>    WARNING: CPU: 0 PID: 3606 at free_loaded_vmcs+0x158/0x1a0 arch/x86/kvm/vmx/vmx.c:2656
>    Modules linked in:
>    CPU: 1 PID: 3606 Comm: syz-executor725 Not tainted 5.17.0-rc1-syzkaller #0
>    Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>    RIP: 0010:free_loaded_vmcs arch/x86/kvm/vmx/vmx.c:2665 [inline]
>    RIP: 0010:free_loaded_vmcs+0x158/0x1a0 arch/x86/kvm/vmx/vmx.c:2656
>    Code: <0f> 0b eb b3 e8 8f 4d 9f 00 e9 f7 fe ff ff 48 89 df e8 92 4d 9f 00
>    Call Trace:
>     <TASK>
>     kvm_arch_vcpu_destroy+0x72/0x2f0 arch/x86/kvm/x86.c:11123
>     kvm_vcpu_destroy arch/x86/kvm/../../../virt/kvm/kvm_main.c:441 [inline]
>     kvm_destroy_vcpus+0x11f/0x290 arch/x86/kvm/../../../virt/kvm/kvm_main.c:460
>     kvm_free_vcpus arch/x86/kvm/x86.c:11564 [inline]
>     kvm_arch_destroy_vm+0x2e8/0x470 arch/x86/kvm/x86.c:11676
>     kvm_destroy_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1217 [inline]
>     kvm_put_kvm+0x4fa/0xb00 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1250
>     kvm_vm_release+0x3f/0x50 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1273
>     __fput+0x286/0x9f0 fs/file_table.c:311
>     task_work_run+0xdd/0x1a0 kernel/task_work.c:164
>     exit_task_work include/linux/task_work.h:32 [inline]
>     do_exit+0xb29/0x2a30 kernel/exit.c:806
>     do_group_exit+0xd2/0x2f0 kernel/exit.c:935
>     get_signal+0x4b0/0x28c0 kernel/signal.c:2862
>     arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
>     handle_signal_work kernel/entry/common.c:148 [inline]
>     exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
>     exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
>     __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
>     syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
>     do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>     entry_SYSCALL_64_after_hwframe+0x44/0xae
>     </TASK>
> 
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+8112db3ab20e70d50c31@syzkaller.appspotmail.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Sean,
I can reliably reproduce my original issue [1] that this supposed to fix
on 5.17-rc4, with the same reproducer [2]. Here is a screen dump [3].
Maybe we do still need my patch. It fixed the issue.

[1] https://lore.kernel.org/all/3789ab35-6ede-34e8-b2d0-f50f4e0f1f15@linaro.org/
[2] https://syzkaller.appspot.com/text?tag=ReproC&x=173085bdb00000
[3] https://termbin.com/fkm8f

-- 
Thanks,
Tadeusz

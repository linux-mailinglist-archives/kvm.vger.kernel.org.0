Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 777F861F24F
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 13:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbiKGMA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 07:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbiKGMAs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 07:00:48 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478D91A83B
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 04:00:47 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id bs21so15862480wrb.4
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 04:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zWvz8bh4+vQKDNdPBDvtEEjozaiA8NxpItsV7tm0Qy0=;
        b=RM2XZktvK25OAmJHVCsqxExlx2YDb8taU5jJP6p51IieAMAC7rVqfwilaQF7Xqqe3G
         UwMWWVo3jrRu5oK/J3jJN4bG6MrzlcwfXbL/gDA98pemG49BzKD6bgFyow0xVV6hIC4N
         cf6zx1TH/gu3ilDDICAD4lfW6uErG3Aj8PE+aPiMsDZzvwiNA5Y84Nf0p0SZtWeekrp2
         3qdK1/twOpDLX49v/t/ybYncTBiauIlLPODLWk6KsnXmtK/KZ/QbdXqSQ3r7uxN3WAvW
         bCAtytlDiReH1KhZkxHPGBBrCC7+BrOifMA+vx31z4AXM6SLhrkDGFn6tpeXsfo6CyjO
         Ug9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zWvz8bh4+vQKDNdPBDvtEEjozaiA8NxpItsV7tm0Qy0=;
        b=GtM1CGHRbx2pd6kAY1A0NXfXBeITbwkISHZSw8ZML1IFwP/VpLN1mDdhidCwUhUqNt
         pxkc3dibfqb9iXMkUW9wlz16yKG0KGFr/bKa2y8Y661dK9vzCl8LnCnsI4v+VcgQJ1K9
         IUL8JU7gQwufa+xuzf0txXWg3aypK6QBz0MPpBvBCMeaKrgTZwpgelychjhp8PYq0DZZ
         2RtxdprfJW1sBBbcP5Ld+WP7I7XtWv7Npgy4Iaamj0bJjkpg1BIRIT+U4y2wBod6aJzp
         9m7sDhVs6vxAVQBVLyg4tog7muPUA8E+EPSTsdp/8cpUtwV3JgHU0EcVmQf4mmqWmHTe
         1eJA==
X-Gm-Message-State: ACrzQf0HFGe8Y+vQ5BUGwOElkyW6+TnzIcEzY6WkwHl6+dKDcKCnAx/D
        H3FbdsPQtixZis0WCBl6fBSorA==
X-Google-Smtp-Source: AMsMyM59k115pH9o+6WIgEa9CaPh3ktLnt7NSnldWl3F1VAmeY4BCiQWWWW9a39fkvnQOQN6hJYR7A==
X-Received: by 2002:adf:e241:0:b0:238:3c64:decc with SMTP id bl1-20020adfe241000000b002383c64deccmr15833238wrb.698.1667822445787;
        Mon, 07 Nov 2022 04:00:45 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b4d7:0:ebf7:de38:f6bc:8fe8? ([2a02:6b6a:b4d7:0:ebf7:de38:f6bc:8fe8])
        by smtp.gmail.com with ESMTPSA id g2-20020a5d4882000000b00236cb3fec8fsm8600966wrq.9.2022.11.07.04.00.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 04:00:45 -0800 (PST)
Message-ID: <180b91af-a2aa-2cfd-eb7f-b2825c4e3dbe@bytedance.com>
Date:   Mon, 7 Nov 2022 12:00:44 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [External] Re: [v2 0/6] KVM: arm64: implement vcpu_is_preempted
 check
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        steven.price@arm.com, mark.rutland@arm.com, bagasdotme@gmail.com,
        fam.zheng@bytedance.com, liangma@liangbit.com,
        punit.agrawal@bytedance.com
References: <20221104062105.4119003-1-usama.arif@bytedance.com>
 <87k048f3cm.wl-maz@kernel.org>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <87k048f3cm.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/11/2022 16:35, Marc Zyngier wrote:
> On Fri, 04 Nov 2022 06:20:59 +0000,
> Usama Arif <usama.arif@bytedance.com> wrote:
>>
>> This patchset adds support for vcpu_is_preempted in arm64, which
>> allows the guest to check if a vcpu was scheduled out, which is
>> useful to know incase it was holding a lock. vcpu_is_preempted can
>> be used to improve performance in locking (see owner_on_cpu usage in
>> mutex_spin_on_owner, mutex_can_spin_on_owner, rtmutex_spin_on_owner
>> and osq_lock) and scheduling (see available_idle_cpu which is used
>> in several places in kernel/sched/fair.c for e.g. in wake_affine to
>> determine which CPU can run soonest):
> 
> [...]
> 
>> pvcy shows a smaller overall improvement (50%) compared to
>> vcpu_is_preempted (277%).  Host side flamegraph analysis shows that
>> ~60% of the host time when using pvcy is spent in kvm_handle_wfx,
>> compared with ~1.5% when using vcpu_is_preempted, hence
>> vcpu_is_preempted shows a larger improvement.
> 
> And have you worked out *why* we spend so much time handling WFE?
> 
> 	M.

Its from the following change in pvcy patchset:

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index e778eefcf214..915644816a85 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -118,7 +118,12 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
         }

         if (esr & ESR_ELx_WFx_ISS_WFE) {
-               kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
+               int state;
+               while ((state = kvm_pvcy_check_state(vcpu)) == 0)
+                       schedule();
+
+               if (state == -1)
+                       kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
         } else {
                 if (esr & ESR_ELx_WFx_ISS_WFxT)
                         vcpu_set_flag(vcpu, IN_WFIT);


If my understanding is correct of the pvcy changes, whenever pvcy 
returns an unchanged vcpu state, we would schedule to another vcpu. And 
its the constant scheduling where the time is spent. I guess the affects 
are much higher when the lock contention is very high. This can be seem 
from the pvcy host side flamegraph as well with (~67% of the time spent 
in the schedule() call in kvm_handle_wfx), For reference, I have put the 
graph at:
https://uarif1.github.io/pvlock/perf_host_pvcy_nmi.svg

Thanks,
Usama

> 

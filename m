Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1624D85F0
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 14:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241730AbiCNNda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 09:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbiCNNd2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 09:33:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2B25713DCE
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 06:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647264737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N2dBQ7kyew540zi+JMXl0o4PlnhZGpL163gOjfNKUtE=;
        b=Dem1Ri40A9B5AUGUbW20ZGXveWY8rwXQ9XMi5izPprDDjgwtuMC1DZZ6Htgayj0dFwDIoQ
        tSLXf4QWkVoD3iUTGF1YingnPc5fruTQZFx/Eip4dkN6Opcp36A5A1WwcHKH2FaCibMmeV
        gBsI0DTeE9aQytS8oMpshmjzu7g4Nl4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-uC9n-J7PPXqQtvWMQyRSZA-1; Mon, 14 Mar 2022 09:32:16 -0400
X-MC-Unique: uC9n-J7PPXqQtvWMQyRSZA-1
Received: by mail-ej1-f71.google.com with SMTP id hq34-20020a1709073f2200b006d677c94909so7991719ejc.8
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 06:32:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=N2dBQ7kyew540zi+JMXl0o4PlnhZGpL163gOjfNKUtE=;
        b=A7Thj/QzRNXx4CCwYPPFTg+gDUyAdudp3Ig4t5DddZ68i39yqqBIr6s0VsvwvgRISL
         ybYaWyuEuzymE7LVasLvcDXqSJ67TmGVneEb5dKH5bw1ztXL5e3z/Ju+338VwgDQjYT1
         SXP93mCIWVOfr8Sif1JkS894/ekXx/FVq8yh5sQkrQBmOL+sx6LzxNBZHMqRaiIH/KMT
         ZFq/hRI3GSNan26BTrdj/teDWnduy0ePLlZRoW0gS6sHaa35qkrbfPVSgWG2iYnMvPwG
         3t9naCcJ8T4Tip2QgT4dIseHgZRbhCpgAcAcDq7BCI4ZcmjlUmopD6TjtztNkv8xq2et
         QT1A==
X-Gm-Message-State: AOAM530BioAeeKDIQ3h7bz2kPwg0Lbp7azQEOsXj+Ef1ct0Yxe+qZjq3
        LaPs/tCvxTbvEOJ323UTDGgqoLXDFLtNHVSMPHi5vLULseTJQzQ+Rg+FVatEW8IV8tvGo0CZkuG
        dx5ltAc8ctv8m
X-Received: by 2002:a17:907:608f:b0:6db:af2c:ab7e with SMTP id ht15-20020a170907608f00b006dbaf2cab7emr11800380ejc.694.1647264731571;
        Mon, 14 Mar 2022 06:32:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2A4Jg7pFV8JQfJlYOlmkdwJUWsVc9ARLKYhWxh7NvlxsXly+PiHlJ2Xpyw1flCD87GI4MFA==
X-Received: by 2002:a17:907:608f:b0:6db:af2c:ab7e with SMTP id ht15-20020a170907608f00b006dbaf2cab7emr11800348ejc.694.1647264731307;
        Mon, 14 Mar 2022 06:32:11 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id g2-20020aa7c842000000b0041314b98872sm7887639edt.22.2022.03.14.06.32.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 06:32:10 -0700 (PDT)
Message-ID: <9f804acc-00b5-f619-f107-e3dc3c5ec8a6@redhat.com>
Date:   Mon, 14 Mar 2022 14:32:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: WARNING: CPU: 0 PID: 884 at
 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3162 mark_page_dirty_in_slot
Content-Language: en-US
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     open list <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkft-triage@lists.linaro.org
References: <CA+G9fYsziOWHkV+YbKymtpVBkL=DAHnmMfkeuWvx0pJPg=fMEA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CA+G9fYsziOWHkV+YbKymtpVBkL=DAHnmMfkeuWvx0pJPg=fMEA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/14/22 13:51, Naresh Kamboju wrote:
> While running kselftest kvm tests on Linux mainline 5.17.0-rc8 on x86_64 device
> the following kernel warning was noticed

Thanks, this is known.  I'll get back to it this week since Linus gave 
me an extra week. :)

Paolo

> # selftests: kvm: hyperv_clock
> [   59.752584] ------------[ cut here ]------------
> [   59.757297] WARNING: CPU: 0 PID: 884 at
> arch/x86/kvm/../../../virt/kvm/kvm_main.c:3162
> mark_page_dirty_in_slot+0xba/0xd0
> [   59.768196] Modules linked in: x86_pkg_temp_thermal fuse
> [   59.773531] CPU: 0 PID: 884 Comm: hyperv_clock Not tainted 5.17.0-rc8 #1
> [   59.780242] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.5 11/26/2020
> [   59.787652] RIP: 0010:mark_page_dirty_in_slot+0xba/0xd0
> [   59.792894] Code: 89 ea 09 c6 e8 07 cd 00 00 5b 41 5c 41 5d 41 5e
> 5d c3 48 8b 83 c0 00 00 00 49 63 d5 f0 48 0f ab 10 5b 41 5c 41 5d 41
> 5e 5d c3 <0f> 0b 5b 41 5c 41 5d 41 5e 5d c3 0f 1f 44 00 00 eb 80 0f 1f
> 40 00
> [   59.811659] RSP: 0018:ffffa1548109bbe0 EFLAGS: 00010246
> [   59.816919] RAX: 0000000080000000 RBX: ffff9174c5303a00 RCX: 0000000000000000
> [   59.824068] RDX: 0000000000000000 RSI: ffffffffb6e29061 RDI: ffffffffb6e29061
> [   59.831219] RBP: ffffa1548109bc00 R08: 0000000000000000 R09: 0000000000000001
> [   59.838369] R10: 0000000000000001 R11: 0000000000000000 R12: ffffa1548109d000
> [   59.845545] R13: 0000000000000022 R14: 0000000000000000 R15: 0000000000000004
> [   59.852721] FS:  00007f07cc7b9740(0000) GS:ffff917827a00000(0000)
> knlGS:0000000000000000
> [   59.860822] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   59.866585] CR2: 0000000000000000 CR3: 0000000106700006 CR4: 00000000003726f0
> [   59.873737] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   59.880886] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   59.888034] Call Trace:
> [   59.890512]  <TASK>
> [   59.892641]  __kvm_write_guest_page+0xc8/0x100
> [   59.897112]  kvm_write_guest+0x61/0xb0
> [   59.900882]  kvm_hv_invalidate_tsc_page+0xd3/0x140
> [   59.905688]  ? kvm_hv_invalidate_tsc_page+0x72/0x140
> [   59.910676]  kvm_arch_vm_ioctl+0x20f/0xb70
> [   59.914789]  ? __lock_acquire+0x3af/0x2370
> [   59.918913]  ? __this_cpu_preempt_check+0x13/0x20
> [   59.923638]  ? lock_is_held_type+0xdd/0x130
> [   59.927845]  kvm_vm_ioctl+0x774/0xe10
> [   59.931530]  ? ktime_get_coarse_real_ts64+0xbe/0xd0
> [   59.936429]  ? __this_cpu_preempt_check+0x13/0x20
> [   59.941178]  ? lockdep_hardirqs_on+0x7e/0x100
> [   59.945552]  ? ktime_get_coarse_real_ts64+0xbe/0xd0
> [   59.950493]  ? ktime_get_coarse_real_ts64+0xbe/0xd0
> [   59.955459]  ? security_file_ioctl+0x37/0x50
> [   59.959753]  __x64_sys_ioctl+0x91/0xc0
> [   59.963524]  do_syscall_64+0x5c/0x80
> [   59.967125]  ? do_syscall_64+0x69/0x80
> [   59.970896]  ? syscall_exit_to_user_mode+0x3e/0x50
> [   59.975706]  ? do_syscall_64+0x69/0x80
> [   59.979495]  ? exc_page_fault+0x7c/0x250
> [   59.983453]  ? asm_exc_page_fault+0x8/0x30
> [   59.987570]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   59.992637] RIP: 0033:0x7f07cc0b78f7
> [   59.996234] Code: b3 66 90 48 8b 05 a1 35 2c 00 64 c7 00 26 00 00
> 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00
> 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 71 35 2c 00 f7 d8 64 89
> 01 48
> [   60.014996] RSP: 002b:00007ffdf0b37478 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000010
> [   60.022581] RAX: ffffffffffffffda RBX: 000000004030ae7b RCX: 00007f07cc0b78f7
> [   60.029729] RDX: 00007ffdf0b374b0 RSI: 000000004030ae7b RDI: 0000000000000006
> [   60.036880] RBP: 0000000000000007 R08: 000000000040de60 R09: 0000000000000007
> [   60.044030] R10: 0000000000067816 R11: 0000000000000246 R12: 00007f07cc7bf000
> [   60.051180] R13: 0000000000000007 R14: 0000000000006592 R15: 0000000000136843
> [   60.058357]  </TASK>
> [   60.060566] irq event stamp: 6625
> [   60.063925] hardirqs last  enabled at (6635): [<ffffffffb7064848>]
> __up_console_sem+0x58/0x60
> [   60.072511] hardirqs last disabled at (6644): [<ffffffffb706482d>]
> __up_console_sem+0x3d/0x60
> [   60.081044] softirqs last  enabled at (6092): [<ffffffffb8400327>]
> __do_softirq+0x327/0x493
> [   60.089407] softirqs last disabled at (6085): [<ffffffffb6fe3a65>]
> irq_exit_rcu+0xe5/0x130
> [   60.097735] ---[ end trace 0000000000000000 ]---
> ok 6 selftests: kvm: hyperv_clock
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> metadata:
>    git_describe: v5.17-rc8
>    git_ref: master
>    git_repo: https://gitlab.com/Linaro/lkft/mirrors/torvalds/linux-mainline
>    git_sha: 09688c0166e76ce2fb85e86b9d99be8b0084cdf9
>    kernel-config: https://builds.tuxbuild.com/26LbaUN6vcuAN7Rd69gZkFWp5J8/config
>    build: https://builds.tuxbuild.com/26LbaUN6vcuAN7Rd69gZkFWp5J8/
> 
> --
> Linaro LKFT
> https://lkft.linaro.org
> 
> [1] https://lkft.validation.linaro.org/scheduler/job/4714912#L1520
> [2] https://qa-reports.linaro.org/lkft/linux-mainline-master/build/v5.17-rc8/testrun/8445627/suite/linux-log-parser/test/check-kernel-warning-4714912/details/
> 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A86459C56C
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 19:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236895AbiHVRvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 13:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237030AbiHVRuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 13:50:40 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A38EB43334
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 10:50:38 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id u22so10584324plq.12
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 10:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=/9pdvewaFJfJXyNVSXKyqnVcGbfMxvL6xyI+fnyra6Y=;
        b=n983nb07Xr5sc7oSWDR+0vxG9HLqEC4+IexkaNkMZA/ZEDkXTjf+CIeKEYs04z0WN6
         cinYKMyH9u2m0PLL4GsXhtlVYxF/o2Yk2ySReCcwwd35Vsw8bbfkrmttwKCIVssutJe0
         A2cLUOS92FVJsWj4we04Pmr5+vte2Qe7S/K3p/7jadwKJMCfDC7mDKUxWnltjTt7iO12
         H+IqYNgHOR7czy0dk6Bvvq91sARWLhi1oh2qaARo2fGHq96kA+8zbrI98m1t536+P/9l
         7ofD7n+YOHyHLC0yLgKgnuxYeTjSJs5wuoxF9VNoJuWY3iJZMtjH+bFkKxTPer/yAWPH
         wySQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=/9pdvewaFJfJXyNVSXKyqnVcGbfMxvL6xyI+fnyra6Y=;
        b=aa6hS2+bexo5ucnKVjd2r1YWUKNIhr1wsYOUThW+Cjo4GwQ67eDQ6wSKR9Jvlxkl8c
         QZz/kFEgYbGsaGGlzb24rqfq6IhlbWWWBqqUVoXnTylexZkI8oVEiSBSQH3s0ihGClwl
         S+IyhvBAtqzEGle19VQ/qHgwgjRFfLgDctURHERyNIocqnQXNRDPqjw8eifiLLfbSkoH
         MyDPj6x/k/roi9FAdZTfynxHPYTE78qhgZ15ro2JAXW+XgkLTyE7IsPLOzZKoNhktur1
         rrwxRta+Bjxt/pd9Q5nWG8+fnscbG93V6MhNDg9I8DKzc6sQvsiBd+9MLMvEZZtJiQmO
         K7ag==
X-Gm-Message-State: ACgBeo1jYL2kwPnI+cJUCYPv9XXm+S4cYQ3VZwwVCJEnNE8jLefQ+kHZ
        hnFq4bu2WsPQ4AdoU4sTkLycEw==
X-Google-Smtp-Source: AA6agR4+RU3ypFQPgD2AhP7c+8BkoxdnX5SFE7IrbciQ4Z73ObiwdMig1EA716NSFqjFLWd5C7LD9w==
X-Received: by 2002:a17:90b:1a8f:b0:1f4:fb36:a9b3 with SMTP id ng15-20020a17090b1a8f00b001f4fb36a9b3mr24508878pjb.186.1661190638015;
        Mon, 22 Aug 2022 10:50:38 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x2-20020a17090a164200b001f50e4c43c4sm10376557pje.22.2022.08.22.10.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 10:50:37 -0700 (PDT)
Date:   Mon, 22 Aug 2022 17:50:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     bugzilla-daemon@kernel.org
Cc:     kvm@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org
Subject: Re: [Bug 216388] New: On Host, kernel errors in KVM, on guests, it
 shows CPU stalls
Message-ID: <YwPB6W2tVIGWD7kD@google.com>
References: <bug-216388-28872@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-216388-28872@https.bugzilla.kernel.org/>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+GVT folks

On Sun, Aug 21, 2022, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=216388
> 
>             Bug ID: 216388
>            Summary: On Host, kernel errors in KVM, on guests, it shows CPU
>                     stalls
>            Product: Virtualization
>            Version: unspecified
>     Kernel Version: 5.19.0 / 5.19.1 / 5.19.2
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: nanook@eskimo.com
>         Regression: No
> 
> Created attachment 301614
>   --> https://bugzilla.kernel.org/attachment.cgi?id=301614&action=edit
> The configuration file used to Comile this kernel.
> 
> This behavior has persisted across 5.19.0, 5.19.1, and 5.19.2.  While the
> kernel I am taking this example from is tainted (owing to using Intel
> development drivers for GPU virtualization), it is also occurring on
> non-tainted kernels on servers with no development or third party modules
> installed.
> 
> INFO: task CPU 2/KVM:2343 blocked for more than 1228 seconds.
> [207177.050049]       Tainted: G     U    I       5.19.2 #1
> [207177.050050] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [207177.050051] task:CPU 2/KVM       state:D stack:    0 pid: 2343 ppid:     1
> flags:0x00000002
> [207177.050054] Call Trace:
> [207177.050055]  <TASK>
> [207177.050056]  __schedule+0x359/0x1400
> [207177.050060]  ? kvm_mmu_page_fault+0x1ee/0x980
> [207177.050062]  ? kvm_set_msr_common+0x31f/0x1060
> [207177.050065]  schedule+0x5f/0x100
> [207177.050066]  schedule_preempt_disabled+0x15/0x30
> [207177.050068]  __mutex_lock.constprop.0+0x4e2/0x750
> [207177.050070]  ? aa_file_perm+0x124/0x4f0
> [207177.050071]  __mutex_lock_slowpath+0x13/0x20
> [207177.050072]  mutex_lock+0x25/0x30
> [207177.050075]  intel_vgpu_emulate_mmio_read+0x5d/0x3b0 [kvmgt]

This isn't a KVM problem, it's a KVMGT problem (despite the name, KVMGT is very
much not KVM).

> [207177.050084]  intel_vgpu_rw+0xb8/0x1c0 [kvmgt]
> [207177.050091]  intel_vgpu_read+0x20d/0x250 [kvmgt]
> [207177.050097]  vfio_device_fops_read+0x1f/0x40
> [207177.050100]  vfs_read+0x9b/0x160
> [207177.050102]  __x64_sys_pread64+0x93/0xd0
> [207177.050104]  do_syscall_64+0x58/0x80
> [207177.050106]  ? kvm_on_user_return+0x84/0xe0
> [207177.050107]  ? fire_user_return_notifiers+0x37/0x70
> [207177.050109]  ? exit_to_user_mode_prepare+0x41/0x200
> [207177.050111]  ? syscall_exit_to_user_mode+0x1b/0x40
> [207177.050112]  ? do_syscall_64+0x67/0x80
> [207177.050114]  ? irqentry_exit+0x54/0x70
> [207177.050115]  ? sysvec_call_function_single+0x4b/0xa0
> [207177.050116]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [207177.050118] RIP: 0033:0x7ff51131293f
> [207177.050119] RSP: 002b:00007ff4ddffa260 EFLAGS: 00000293 ORIG_RAX:
> 0000000000000011
> [207177.050121] RAX: ffffffffffffffda RBX: 00005599a6835420 RCX:
> 00007ff51131293f
> [207177.050122] RDX: 0000000000000004 RSI: 00007ff4ddffa2a8 RDI:
> 0000000000000027
> [207177.050123] RBP: 0000000000000004 R08: 0000000000000000 R09:
> 00000000ffffffff
> [207177.050124] R10: 0000000000065f10 R11: 0000000000000293 R12:
> 0000000000065f10
> [207177.050124] R13: 00005599a6835330 R14: 0000000000000004 R15:
> 0000000000065f10
> [207177.050126]  </TASK>
> 
>      I am seeing this on Intel i7-6700k, i7-6850k, and i7-9700k platforms.
> 
>      This did not happen on 5.17 kernels, and 5.18 kernels never ran stable
> enough on my platforms to actually run them for more than a few minutes.
> 
>      Likewise 6.0-rc1 has not been stable enough to run in production.  After
> less than three hours running on my workstation it locked hard with even the
> magic sys-request key being unresponsive and only power cycling the machine got
> it back.
> 
>      The operating system in use for the host on all machines is Ubuntu 22.04.
> 
>      Guests vary with Ubuntu 22.04 being the most common but also Mint, Debian,
> Manjaro, Centos, Fedora, ScientificLinux, Zorin, and Windows being in use.
> 
>      I see the same issue manifest on platforms running only Ubuntu guests as
> with guests of varying operating systems.  
> 
>      The configuration file I used to compile this kernel is attached.  I
> compiled it with gcc 12.1.0.
> 
>      This behavior does not manifest itself instantly, typically the machine
> needs to be running 3-7 days before it does.  Once it does guests keep stalling
> and restarting libvirtd does not help.  Only thing that seems to is a hard
> reboot of the physical host.  For this reason I believe the issue lies strictly
> with the host and not the guests.
> 
>      I have listed it as a severity of high since it is completely service
> interrupting.
> 
> -- 
> You may reply to this email to add a comment.
> 
> You are receiving this mail because:
> You are watching the assignee of the bug.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3DC5AAA32
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 10:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235494AbiIBIhb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 04:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbiIBIhQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 04:37:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BDDDEF2
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 01:36:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9678B82A15
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 08:36:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8E933C433D7
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 08:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662107788;
        bh=VaCKPPKJxy2pciFNT96gxT2F7TKJcAH+V9q+W/Ub4OI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Z8fRsX1MflWdWMMXTbIPWXx/hfEIF/JgT5NobxUBeQlerCE5f/JGzLu/OpDSRNccj
         qPv4ci5QIdscIPM30kX7OvX9U5sE911MhP7+8irQxF0Ye+Nsi2W7Va2jnZeBQmmqHB
         DYIoTBQtXhuTLwsCzYZX8/mWsF3ZMqvN8+5wjgO9vxoPhoApbTQRPRyCb/fzBG5ytU
         Lvgf0HqQEj6bXZBjSsqheDCC/RIliyKlemsw1hnC83REGtFXcdebmtb9NqzuQvmAal
         fRrElC3/7AsXKA9rv5ZYHwA45frgG7cLNds7HINadqVYMLQz1p/SLO0xoJ4/0VwlvK
         YP/mpQfYuTSDQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 78D92C433E9; Fri,  2 Sep 2022 08:36:28 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216388] On Host, kernel errors in KVM, on guests, it shows CPU
 stalls
Date:   Fri, 02 Sep 2022 08:36:28 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: nanook@eskimo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216388-28872-sA4Q9o1QVN@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216388-28872@https.bugzilla.kernel.org/>
References: <bug-216388-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216388

--- Comment #11 from Robert Dinse (nanook@eskimo.com) ---
Well still happening with gcc-12.2.0 but seems to be somewhat less frequent.

[    7.092312] rcu: INFO: rcu_sched detected expedited stalls on CPUs/tasks=
: {
4-... } 3 jiffies s: 389 root: 0x10/.
[    7.092329] rcu: blocking rcu_node structures (internal RCU debug):
[    7.092332] Task dump for CPU 4:
[    7.092334] task:modprobe        state:R  running task     stack:    0 p=
id:
1502 ppid:     8 flags:0x0000400a
[    7.092338] Call Trace:
[    7.092344]  <TASK>
[    7.092347]  ? __wake_up_common_lock+0x87/0xc0
[    7.092355]  ? sysvec_apic_timer_interrupt+0x90/0xa0
[    7.092361]  ? insn_get_prefixes+0x1f1/0x440
[    7.092365]  ? load_new_mm_cr3+0x7f/0xe0
[    7.092368]  ? cpumask_any_but+0x35/0x50
[    7.092372]  ? x2apic_send_IPI_allbutself+0x2f/0x40
[    7.092375]  ? do_sync_core+0x2a/0x30
[    7.092379]  ? cpumask_next+0x23/0x30
[    7.092381]  ? smp_call_function_many_cond+0xea/0x370
[    7.092386]  ? text_poke_memset+0x20/0x20
[    7.092389]  ? arch_unregister_cpu+0x50/0x50
[    7.092394]  ? __fscache_acquire_cookie+0x4f4/0x500 [fscache]
[    7.092407]  ? on_each_cpu_cond_mask+0x1d/0x30
[    7.092409]  ? text_poke_bp_batch+0xaf/0x210
[    7.092412]  ? __traceiter_fscache_volume+0x60/0x60 [fscache]
[    7.092421]  ? __fscache_acquire_cookie+0x4f4/0x500 [fscache]
[    7.092429]  ? __fscache_acquire_cookie+0x4f4/0x500 [fscache]
[    7.092438]  ? text_poke_bp+0x49/0x70
[    7.092440]  ? __static_call_transform+0x7f/0x120
[    7.092442]  ? arch_static_call_transform+0x87/0xa0
[    7.092446]  ? __static_call_init+0x167/0x210
[    7.092450]  ? static_call_module_notify+0x13e/0x1a0
[    7.092452]  ? blocking_notifier_call_chain_robust+0x72/0xd0
[    7.092456]  ? load_module+0x2068/0x25e0
[    7.092459]  ? ima_post_read_file+0xd5/0x100
[    7.092464]  ? __do_sys_finit_module+0xbd/0x130
[    7.092466]  ? __do_sys_finit_module+0xbd/0x130
[    7.092469]  ? __x64_sys_finit_module+0x18/0x20
[    7.092470]  ? do_syscall_64+0x5b/0x80
[    7.092474]  ? ksys_mmap_pgoff+0x108/0x250
[    7.092478]  ? do_syscall_64+0x67/0x80
[    7.092480]  ? exit_to_user_mode_prepare+0x41/0x1e0
[    7.092485]  ? syscall_exit_to_user_mode+0x1b/0x40
[    7.092487]  ? do_syscall_64+0x67/0x80
[    7.092489]  ? do_syscall_64+0x67/0x80
[    7.092492]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[    7.092496]  </TASK>

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

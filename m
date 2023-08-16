Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64EE77DFCC
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 12:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244125AbjHPK7T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 06:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244370AbjHPK7F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 06:59:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA2B2D5E
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 03:58:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8460565B72
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 10:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E2844C433C9
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 10:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692183489;
        bh=t3aYqIkTF0SgGDFRi+CTeJ3SKMw6REGGw5B66KHiHD4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=qk7DjKZfmj8WG41dlOmGfM6T3bqaMeE+B7WqQ87BL62oXYQFRGYz7iCWskLHPP5D4
         5qluU4xlaOS/XgJu+WT/HYg7lM2KfxyN0zVwk/jwZSOPTsMcDBoDay6xEfUT6VLVu9
         XsEcNtiXxTqCmhUCxx82R4Vl4jZKXdXldYXzaVIgxPYLZ90CiJAnH4maFs6GcAYrXd
         5Cl4bTGqpotGdjWaM0JBOLKi8JMcMzHo4DzEfBi0I9A/l/kn2O+TpjPfzgSWnA49Ov
         89rh6BjH8q1KCwmZyjMP+U+3ziH4MpmB5UVfx5X/TAhOkEERYwYf9jmHDBoYHnfnl0
         78pGmr1x+dq/w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C5D96C53BD3; Wed, 16 Aug 2023 10:58:09 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217799] kvm: Windows Server 2003 VM fails to work on 6.1.44
 (works fine on 6.1.43)
Date:   Wed, 16 Aug 2023 10:58:09 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: rm+bko@romanrm.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217799-28872-hEDxw2pEv7@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217799-28872@https.bugzilla.kernel.org/>
References: <bug-217799-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217799

--- Comment #3 from Roman Mamedov (rm+bko@romanrm.net) ---
Hello,

Unfortunately I am not in a position to easily do bisects.
But as noted above, setting "spec_rstack_overflow=3Doff" is enough to solve=
 it.

Further info, trying with an XP x64 install ISO provided by Microsoft:
https://archive.org/details/windows-xp-professional-x64-edition

With "spec_rstack_overflow=3Doff", it works fine. But in the default state =
of
this new mitigation (which is "safe RET, no microcode" on my machine), the
install ISO hangs at the "Setup is starting Windows" message. So if anyone
wants to reproduce on their local machine, there is now a quick and legal w=
ay
to do so.

My QEMU command-line:

kvm -cpu host -m 2048 -machine pc,mem-merge=3Don,accel=3Dkvm -vnc [::]:24 -=
device
ide-hd,drive=3Ddrive0,bus=3Dide.0 -drive
if=3Dnone,id=3Ddrive0,cache=3Dwriteback,aio=3Dthreads,format=3Draw,discard=
=3Dunmap,detect-zeroes=3Doff,file=3Dxp.img
-rtc base=3Dlocaltime -cdrom xp64ce.iso -boot d

I should add that when a VM is in this stuck state, the CPU load by QEMU
process is 0% (not 100%).

And I am not sure why the default mitigation state says "no microcode", as I
use a 2023-08-08 updated microcode package from Debian.

# dmesg | grep microcode
[    0.401618] Speculative Return Stack Overflow: IBPB-extending microcode =
not
applied!
[    0.401618] Speculative Return Stack Overflow: Mitigation: safe RET, no
microcode
[    1.051941] microcode: CPU0: patch_level=3D0x0a201016
[    1.051947] microcode: CPU1: patch_level=3D0x0a201016
[    1.051953] microcode: CPU2: patch_level=3D0x0a201016
[    1.051960] microcode: CPU3: patch_level=3D0x0a201016
[    1.051967] microcode: CPU4: patch_level=3D0x0a201016
[    1.051973] microcode: CPU5: patch_level=3D0x0a201016
[    1.051981] microcode: CPU6: patch_level=3D0x0a201016
[    1.051989] microcode: CPU7: patch_level=3D0x0a201016
[    1.051996] microcode: CPU8: patch_level=3D0x0a201016
[    1.052003] microcode: CPU9: patch_level=3D0x0a201016
[    1.052010] microcode: CPU10: patch_level=3D0x0a201016
[    1.052018] microcode: CPU11: patch_level=3D0x0a201016
[    1.052024] microcode: CPU12: patch_level=3D0x0a201016
[    1.052030] microcode: CPU13: patch_level=3D0x0a201016
[    1.052036] microcode: CPU14: patch_level=3D0x0a201016
[    1.052041] microcode: CPU15: patch_level=3D0x0a201016
[    1.052046] microcode: CPU16: patch_level=3D0x0a201016
[    1.052052] microcode: CPU17: patch_level=3D0x0a201016
[    1.052058] microcode: CPU18: patch_level=3D0x0a201016
[    1.052064] microcode: CPU19: patch_level=3D0x0a201016
[    1.052070] microcode: CPU20: patch_level=3D0x0a201016
[    1.052076] microcode: CPU21: patch_level=3D0x0a201016
[    1.052082] microcode: CPU22: patch_level=3D0x0a201016
[    1.052088] microcode: CPU23: patch_level=3D0x0a201016
[    1.052092] microcode: Microcode Update Driver: v2.2.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9DB58ED8C
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 15:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbiHJNo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 09:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiHJNoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 09:44:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0ED67152
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 06:44:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E024561460
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 13:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 492EDC433D6
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 13:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660139092;
        bh=pQ2M7MZtMQWGMnTysaihHOXHmhgrAXGoZrtSkdFg3lY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=OEqtl60dvGblSFWcTUl0l1/PVF4MROXiWSSxQPfTCzFoXbK4LadNxwfybyDPxE6+u
         RmcziKCyQyTR7Co0FOkcZ/xIllVl6ou5kuq2IItkmBUgSmZ8aFyr+4/efBMuSzb2Nl
         g15VyhMvZ10bzia5ghyh365ZjZnE1QMoGyxaopp3QYbzAKA+vShks89/63j95UwDef
         +QW1pPOdfZK4CjUy7OiMVYG5YnVEQ8tp5P/u8pB2m2U8om1RBqen91ZfVeOLwhZ8JJ
         Iqe3KnukmyXhrDUd/QloqEO2AZsV1V1Sm+zHnCTYpZTmxnlgjAsgXMm6DlZQYWU7jn
         1+LkYN3QIJv/A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 3144FC433E9; Wed, 10 Aug 2022 13:44:52 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216349] Kernel panic in a Ubuntu VM running on Proxmox
Date:   Wed, 10 Aug 2022 13:44:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jdpark.au@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216349-28872-1UXL3MVk0e@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216349-28872@https.bugzilla.kernel.org/>
References: <bug-216349-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216349

--- Comment #1 from John Park (jdpark.au@gmail.com) ---
I just experienced another kernel panic on the same VM above. Log below:

---

[ 7720.804438] BUG: #DF stack guard page was hit at 00000000d9071369 (stack=
 is
000000002e08a9df..0000000059db9875)
[ 7720.804460] stack guard page: 0000 [#1] SMP PTI
[ 7720.804464] CPU: 0 PID: 809 Comm: dockerd Not tainted 5.15.0-46-generic
#49-Ubuntu
[ 7720.804473] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
[ 7720.804475] RIP: 0010:error_entry+0xc/0x130
[ 7720.804498] Code: ff 85 db 0f 85 19 fd ff ff 0f 01 f8 e9 11 fd ff ff 66 =
66
2e 0f 1f 84 00 00 00 00 00 66 90 fc 56 48 8b 74 24 08 48 89 7c 24 08 <52> 5=
1 50
41 50 41 51 41 52 41 53 53 55 41 54 41 55 41 56 41 57 56
[ 7720.804500] RSP: 0000:fffffe0000009000 EFLAGS: 00010087
[ 7720.804503] RAX: 000000000001fbc0 RBX: 0000000000000000 RCX:
ffffffff87001187
[ 7720.804504] RDX: 0000000000000000 RSI: ffffffff87000b48 RDI:
fffffe0000009078
[ 7720.804505] RBP: fffffe0000009068 R08: 0000000000000000 R09:
0000000000000000
[ 7720.804506] R10: 0000000000000000 R11: 0000000000000000 R12:
fffffe0000009078
[ 7720.804507] R13: 000000000001fbc0 R14: 0000000000000000 R15:
0000000000000000
[ 7720.804508] FS:  00007fd11cff9640(0000) GS:ffff8988bbc00000(0000)
knlGS:0000000000000000
[ 7720.804509] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 7720.804511] CR2: fffffe0000008ff8 CR3: 00000001292be000 CR4:
00000000000006f0
[ 7720.804514] Call Trace:
[ 7720.804519]  <#DF>
[ 7720.804534]  ? exc_page_fault+0x1c/0x170
[ 7720.804538]  asm_exc_page_fault+0x26/0x30
[ 7720.804541] RIP: 0010:exc_page_fault+0x1c/0x170
[ 7720.804543] Code: 07 01 eb c4 e8 b5 01 00 00 cc cc cc cc cc 55 48 89 e5 =
41
57 41 56 49 89 f6 41 55 41 54 49 89 fc 0f 20 d0 0f 1f 40 00 49 89 c5 <65> 4=
8 8b
04 25 c0 fb 01 00 48 8b 80 98 08 00 00 0f 18 48 78 66 90
[ 7720.804545] RSP: 0000:fffffe0000009128 EFLAGS: 00010087
[ 7720.804546] RAX: 000000000001fbc0 RBX: 0000000000000000 RCX:
ffffffff87001187
[ 7720.804547] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
fffffe0000009158
[ 7720.804548] RBP: fffffe0000009148 R08: 0000000000000000 R09:
0000000000000000
[ 7720.804548] R10: 0000000000000000 R11: 0000000000000000 R12:
fffffe0000009158
[ 7720.804549] R13: 000000000001fbc0 R14: 0000000000000000 R15:
0000000000000000
[ 7720.804550]  ? native_iret+0x7/0x7
[ 7720.804562]  asm_exc_page_fault+0x26/0x30
[ 7720.804564] RIP: 0010:exc_page_fault+0x1c/0x170
[ 7720.804566] Code: 07 01 eb c4 e8 b5 01 00 00 cc cc cc cc cc 55 48 89 e5 =
41
57 41 56 49 89 f6 41 55 41 54 49 89 fc 0f 20 d0 0f 1f 40 00 49 89 c5 <65> 4=
8 8b
04 25 c0 fb 01 00 48 8b 80 98 08 00 00 0f 18 48 78 66 90
[ 7720.804567] RSP: 0000:fffffe0000009208 EFLAGS: 00010087
[ 7720.804568] RAX: 000000000001fbc0 RBX: 0000000000000000 RCX:
ffffffff87001187
[ 7720.804569] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
fffffe0000009238
[ 7720.804570] RBP: fffffe0000009228 R08: 0000000000000000 R09:
0000000000000000
[ 7720.804570] R10: 0000000000000000 R11: 0000000000000000 R12:
fffffe0000009238
[ 7720.804571] R13: 000000000001fbc0 R14: 0000000000000000 R15:
0000000000000000
[ 7720.804592]  ? native_iret+0x7/0x7
[ 7720.804594]  asm_exc_page_fault+0x26/0x30
[ 7720.804597] RIP: 0010:exc_page_fault+0x1c/0x170
[ 7720.804598] Code: 07 01 eb c4 e8 b5 01 00 00 cc cc cc cc cc 55 48 89 e5 =
41
57 41 56 49 89 f6 41 55 41 54 49 89 fc 0f 20 d0 0f 1f 40 00 49 89 c5 <65> 4=
8 8b
04 25 c0 fb 01 00 48 8b 80 98 08 00 00 0f 18 48 78 66 90
[ 7720.804608] RSP: 0000:fffffe00000092e8 EFLAGS: 00010087
[ 7720.804610] RAX: 000000000001fbc0 RBX: 0000000000000000 RCX:
ffffffff87001187
[ 7720.804610] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
fffffe0000009318
[ 7720.804611] RBP: fffffe0000009308 R08: 0000000000000000 R09:
0000000000000000
[ 7720.804612] R10: 0000000000000000 R11: 0000000000000000 R12:
fffffe0000009318
[ 7720.804612] R13: 000000000001fbc0 R14: 0000000000000000 R15:
0000000000000000
[ 7720.804614]  ? native_iret+0x7/0x7
[ 7720.804616]  asm_exc_page_fault+0x26/0x30
[ 7720.804618] RIP: 0010:exc_page_fault+0x1c/0x170
[ 7720.804620] Code: 07 01 eb c4 e8 b5 01 00 00 cc cc cc cc cc 55 48 89 e5 =
41
57 41 56 49 89 f6 41 55 41 54 49 89 fc 0f 20 d0 0f 1f 40 00 49 89 c5 <65> 4=
8 8b
04 25 c0 fb 01 00 48 8b 80 98 08 00 00 0f 18 48 78 66 90
[ 7720.804629] RSP: 0000:fffffe00000093c8 EFLAGS: 00010087
[ 7720.804630] RAX: 000000000001fbc0 RBX: 0000000000000000 RCX:
ffffffff87001187
[ 7720.804631] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
fffffe00000093f8
[ 7720.804632] RBP: fffffe00000093e8 R08: 0000000000000000 R09:
0000000000000000
[ 7720.804632] R10: 0000000000000000 R11: 0000000000000000 R12:
fffffe00000093f8
[ 7720.804633] R13: 000000000001fbc0 R14: 0000000000000000 R15:
0000000000000000
[ 7720.804634]  ? native_iret+0x7/0x7
[ 7720.804637]  asm_exc_page_fault+0x26/0x30
[ 7720.804639] RIP: 0010:exc_page_fault+0x1c/0x170
[ 7720.804640] Code: 07 01 eb c4 e8 b5 01 00 00 cc cc cc cc cc 55 48 89 e5 =
41
57 41 56 49 89 f6 41 55 41 54 49 89 fc 0f 20 d0 0f 1f 40 00 49 89 c5 <65> 4=
8 8b
04 25 c0 fb 01 00 48 8b 80 98 08 00 00 0f 18 48 78 66 90
[ 7720.804641] RSP: 0000:fffffe00000094a8 EFLAGS: 00010087
[ 7720.804642] RAX: 000000000001fbc0 RBX: 0000000000000000 RCX:
ffffffff87001187
[ 7720.804643] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
fffffe00000094d8
[ 7720.804643] RBP: fffffe00000094c8 R08: 0000000000000000 R09:
0000000000000000
[ 7720.804644] R10: 0000000000000000 R11: 0000000000000000 R12:
fffffe00000094d8
[ 7720.804645] R13: 000000000001fbc0 R14: 0000000000000000 R15:
0000000000000000
[ 7720.804645]  ? native_iret+0x7/0x7
[ 7720.804647]  asm_exc_page_fault+0x26/0x30
[ 7720.804649] RIP: 0010:exc_page_fault+0x1c/0x170
[ 7720.804650] Code: 07 01 eb c4 e8 b5 01 00 00 cc cc cc cc cc 55 48 89 e5 =
41
57 41 56 49 89 f6 41 55 41 54 49 89 fc 0f 20 d0 0f 1f 40 00 49 89 c5 <65> 4=
8 8b
04 25 c0 fb 01 00 48 8b 80 98 08 00 00 0f 18 48 78 66 90
[ 7720.804651] RSP: 0000:fffffe0000009588 EFLAGS: 00010087
[ 7720.804652] RAX: 000000000001fbc0 RBX: 0000000000000000 RCX:
ffffffff87001187
[ 7720.804653] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
fffffe00000095b8
[ 7720.804653] RBP: fffffe00000095a8 R08: 0000000000000000 R09:
0000000000000000
[ 7720.804654] R10: 0000000000000000 R11: 0000000000000000 R12:
fffffe00000095b8
[ 7720.804655] R13: 000000000001fbc0 R14: 0000000000000000 R15:
0000000000000000
[ 7720.804656]  ? native_iret+0x7/0x7
[ 7720.804657]  asm_exc_page_fault+0x26/0x30
[ 7720.804659] RIP: 0010:irqentry_enter+0xf/0x50
[ 7720.804661] Code: 66 66 2e 0f 1f 84 00 00 00 00 00 c3 cc cc cc cc 66 66 =
2e
0f 1f 84 00 00 00 00 00 55 48 89 e5 f6 87 88 00 00 00 03 75 17 31 c0 <65> 4=
8 8b
14 25 c0 fb 01 00 f6 42 2c 02 75 13 5d c3 cc cc cc cc e8
[ 7720.804661] RSP: 0000:fffffe0000009668 EFLAGS: 00010046
[ 7720.804662] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffffffff87001187
[ 7720.804663] RDX: 0000000000000000 RSI: ffffffff87000aea RDI:
fffffe0000009698
[ 7720.804677] RBP: fffffe0000009668 R08: 0000000000000000 R09:
0000000000000000
[ 7720.804678] R10: 0000000000000000 R11: 0000000000000000 R12:
fffffe0000009698
[ 7720.804679] R13: 0000000000000000 R14: 0000000000000000 R15:
0000000000000000
[ 7720.804680]  ? native_iret+0x7/0x7
[ 7720.804681]  ? asm_exc_invalid_op+0xa/0x20
[ 7720.804684]  exc_invalid_op+0x25/0x70
[ 7720.804686]  asm_exc_invalid_op+0x1a/0x20
[ 7720.804688] RIP: 0010:asm_exc_invalid_op+0x0/0x20
[ 7720.804690] Code: 00 00 48 89 c4 48 8d 6c 24 01 48 89 e7 48 8b 74 24 78 =
48
c7 44 24 78 ff ff ff ff e8 ea 7f f9 ff e9 a5 0a 00 00 0f 1f 44 00 00 <0f> 1=
f 00
6a ff e8 66 09 00 00 48 89 c4 48 8d 6c 24 01 48 89 e7 e8
[ 7720.804691] RSP: 0000:fffffe0000009748 EFLAGS: 00010002
[ 7720.804692] RAX: 000000c0009b6600 RBX: 000000c0008ba750 RCX:
0000000000000028
[ 7720.804693] RDX: 0000000000000090 RSI: 0000000000203000 RDI:
00007fd1244e3138
[ 7720.804694] RBP: 00007fd11cff8af8 R08: 0000000000000003 R09:
00007fd1260cdd3b
[ 7720.804695] R10: 00000000000fbeb0 R11: 00007fd126287fff R12:
000000c0008ba750
[ 7720.804695] R13: 000000c0009b6600 R14: 000000c0009cf860 R15:
0000000000000000
[ 7720.804700] WARNING: stack recursion on stack type 5
[ 7720.804703]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804705]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804707]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804709]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804711]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804722]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804724]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804726]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804728]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804730]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804732]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804734]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804736]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804737]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804739]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804742]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804744]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804746]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804747]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804749]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804751]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804753]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804755]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804757]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804759]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804761]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804763]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804765]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804767]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804769]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804779]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804782]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804783]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804785]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804787]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804789]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804791]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804793]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804796]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804797]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804799]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804801]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804803]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804805]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804807]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804809]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804811]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804813]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804815]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804817]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804818]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804820]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804822]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804824]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804826]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804828]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804830]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804832]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804834]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804836]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804838]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804840]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804841]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804843]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804845]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804847]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804849]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804851]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804853]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804855]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804857]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804859]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804861]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804877]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804878]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804880]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804882]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804895]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804898]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804900]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804902]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804904]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804906]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804908]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804910]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804912]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.804915]  ? asm_exc_stack_segment+0x10/0x30
[ 7720.804917]  ? vsnprintf+0x359/0x550
[ 7720.804935]  ? vsnprintf+0x359/0x550
[ 7720.804936]  ? sprintf+0x56/0x80
[ 7720.804938]  ? __sprint_symbol.constprop.0+0xee/0x110
[ 7720.804964]  ? symbol_string+0xa2/0x140
[ 7720.804966]  ? symbol_string+0xa2/0x140
[ 7720.804968]  ? vsnprintf+0x397/0x550
[ 7720.804969]  ? vscnprintf+0xd/0x40
[ 7720.804970]  ? printk_sprint+0x79/0xa0
[ 7720.804978]  ? pointer+0x230/0x4f0
[ 7720.804980]  ? vsnprintf+0x397/0x550
[ 7720.804982]  ? vscnprintf+0xd/0x40
[ 7720.804983]  ? printk_sprint+0x5e/0xa0
[ 7720.804985]  ? vprintk_store+0x2fe/0x5b0
[ 7720.804987]  ? defer_console_output+0x3b/0x50
[ 7720.804989]  ? vprintk+0x4a/0x90
[ 7720.804991]  ? is_bpf_text_address+0x17/0x30
[ 7720.805002]  ? kernel_text_address+0xf7/0x100
[ 7720.805011]  ? unwind_next_frame.part.0+0x86/0x200
[ 7720.805020]  ? __kernel_text_address+0x12/0x50
[ 7720.805022]  ? show_trace_log_lvl+0x1cb/0x2df
[ 7720.805033]  ? show_trace_log_lvl+0x1cb/0x2df
[ 7720.805035]  ? asm_exc_alignment_check+0x30/0x30
[ 7720.805038]  ? show_regs.part.0+0x23/0x29
[ 7720.805039]  ? __die_body.cold+0x8/0xd
[ 7720.805056]  ? __die+0x2b/0x37
[ 7720.805057]  ? die+0x30/0x60
[ 7720.805067]  ? handle_stack_overflow+0x4e/0x60
[ 7720.805069]  ? exc_double_fault+0x155/0x190
[ 7720.805071]  ? asm_exc_double_fault+0x1e/0x30
[ 7720.805073]  ? native_iret+0x7/0x7
[ 7720.805074]  ? asm_exc_page_fault+0x8/0x30
[ 7720.805077]  ? error_entry+0xc/0x130
[ 7720.805078]  </#DF>
[ 7720.805083] Modules linked in: tcp_diag udp_diag inet_diag veth xt_nat
xt_tcpudp xt_conntrack nft_chain_nat xt_MASQUERADE nf_nat nf_conntrack_netl=
ink
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xfrm_user xfrm_algo nft_counter
xt_addrtype nft_compat nf_tables nfnetlink br_netfilter bridge stp llc over=
lay
sch_fq_codel cp210x input_leds usbserial cdc_acm joydev serio_raw mac_hid
qemu_fw_cfg dm_multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua mtd pstore_b=
lk
ramoops netconsole pstore_zone reed_solomon ipmi_devintf ipmi_msghandler msr
efi_pstore ip_tables x_tables autofs4 btrfs blake2b_generic zstd_compress
raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx x=
or
raid6_pq libcrc32c raid1 raid0 multipath linear bochs drm_vram_helper
drm_ttm_helper ttm drm_kms_helper hid_generic syscopyarea sysfillrect sysim=
gblt
fb_sys_fops cec usbhid rc_core virtio_net net_failover hid drm psmouse
virtio_scsi failover i2c_piix4 pata_acpi floppy
[ 7720.901966] ---[ end trace b7f1a532a0e81c78 ]---
[ 7720.901991] RIP: 0010:error_entry+0xc/0x130
[ 7720.901998] Code: ff 85 db 0f 85 19 fd ff ff 0f 01 f8 e9 11 fd ff ff 66 =
66
2e 0f 1f 84 00 00 00 00 00 66 90 fc 56 48 8b 74 24 08 48 89 7c 24 08 <52> 5=
1 50
41 50 41 51 41 52 41 53 53 55 41 54 41 55 41 56 41 57 56
[ 7720.901999] RSP: 0000:fffffe0000009000 EFLAGS: 00010087
[ 7720.902001] RAX: 000000000001fbc0 RBX: 0000000000000000 RCX:
ffffffff87001187
[ 7720.902002] RDX: 0000000000000000 RSI: ffffffff87000b48 RDI:
fffffe0000009078
[ 7720.902003] RBP: fffffe0000009068 R08: 0000000000000000 R09:
0000000000000000
[ 7720.902004] R10: 0000000000000000 R11: 0000000000000000 R12:
fffffe0000009078
[ 7720.902004] R13: 000000000001fbc0 R14: 0000000000000000 R15:
0000000000000000
[ 7720.902005] FS:  00007fd11cff9640(0000) GS:ffff8988bbc00000(0000)
knlGS:0000000000000000
[ 7720.902007] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 7720.902008] CR2: fffffe0000008ff8 CR3: 00000001292be000 CR4:
00000000000006f0
[ 7720.902013] Kernel panic - not syncing: Fatal exception in interrupt
[ 7720.902108] Kernel Offset: 0x5200000 from 0xffffffff81000000 (relocation
range: 0xffffffff80000000-0xffffffffbfffffff)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

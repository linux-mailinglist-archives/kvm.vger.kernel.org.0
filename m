Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83CC2530BF1
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 11:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbiEWIsv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 04:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbiEWIsu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 04:48:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBD1101C3
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 01:48:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9E7360DDE
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 08:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2AFBEC385AA
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 08:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653295727;
        bh=Bx7Na5RqmYVQEB43OwJYQnbt7ja4ZwzGrpBmXqt/7r4=;
        h=From:To:Subject:Date:From;
        b=VtxNvtgSHae+XWT2N8CMlNhqFmAuXi47VVgm3MHmIUul61i+qqJ4UVw6cbT/T9G+a
         q1/xf4u3rVdpDouJC+SSH++9f5wVENw1h6EBBafl0NDe5ghTdavvRhRS8LarVIuB21
         +HK6vn4iuos6kkefA3//BXakGq+XljsMbjp5/Ci4paOzSl9FlQYueeTbIX/reMn0Yt
         Y/mHt/iNDyOARcCxfaKe4IEu3iVwWjqZEiLFUNrzmgFjkhma3Is/EpheHi0+Eptk2q
         5rGYm+XeiSeUeeB45aBFqfX9OJiLDLCYHyvT6qGpPs70R/i4XzaQfygBAKCqlmlCfm
         WjMW7NgNF+AmQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 08A9DC05FD5; Mon, 23 May 2022 08:48:47 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216017] New: KVM: problem virtualization from kernel 5.17.9
Date:   Mon, 23 May 2022 08:48:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: opw
X-Bugzilla-Severity: high
X-Bugzilla-Who: ne-vlezay80@yandex.ru
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status keywords
 bug_severity priority component assigned_to reporter cf_regression
Message-ID: <bug-216017-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216017

            Bug ID: 216017
           Summary: KVM: problem virtualization from kernel 5.17.9
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.17.9-arch1-1
          Hardware: AMD
                OS: Linux
              Tree: Mainline
            Status: NEW
          Keywords: opw
          Severity: high
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: ne-vlezay80@yandex.ru
        Regression: No

Qemu periodically chaches width:

[root@router ne-vlezay80]# qemu-system-x86_64 -enable-kvm
qemu-system-x86_64: error: failed to set MSR 0xc0000104 to 0x100000000
qemu-system-x86_64: ../qemu-7.0.0/target/i386/kvm/kvm.c:2996: kvm_buf_set_m=
srs:
Assertion `ret =3D=3D cpu->kvm_msr_buf->nmsrs' failed.
Aborted (core dumped)

Also if running virtual pachine width type -cpu host, system is freezez from
kernel panic.=20

Kernel version: 5.17.9
Distribution: Arch Linux
QEMU: 7.0
CPU: AMD Phenom X4
Arch: x86_64

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

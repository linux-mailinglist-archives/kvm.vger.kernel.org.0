Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72AB65443C3
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 08:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238887AbiFIGZL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 02:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiFIGZJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 02:25:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B7960C1
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 23:25:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 200E861D60
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 06:25:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 845C8C3411F
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 06:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654755907;
        bh=Gc/+YIkTRLFvR7zGV4I2noFMvbOVKV9u99WvsQEvoOg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=OSNkGH0DblRukuCtffDhDNbO0pG3A+on+vIeyFSYj7IPlbVR/vPATWm4BBv1LbDER
         fOqFmF2R1+bXvpKefnRok3R7TP06beHeGu7KQtXKjRTHfop884wkHE13aCvGUlDlAF
         u1yFvVvw0AHAON/lUDagQlGkGm/T6BP+KbHT7cMYQOL9fgRXt890fP5sZZbV+Gh1Ji
         /08reHcHfviIFD/xxaWjFlaVkSkipt20JQ2l//8zjfvspj/LrzMqM4MaG8Kz7bLVor
         6zvZZZiXhEkggFGsMN7/2QlxWfHLFm14YPfX+RWy2QXgP8ZYdx7lTU6XOToZBxsCkp
         e1Yoh2uZlMYWg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 67B4FCC13B1; Thu,  9 Jun 2022 06:25:07 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216098] Assertion Failure in kvm selftest mmu_role_test
Date:   Thu, 09 Jun 2022 06:25:07 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: lixiao.yang@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216098-28872-xnGj5djByh@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216098-28872@https.bugzilla.kernel.org/>
References: <bug-216098-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216098

--- Comment #1 from Yang Lixiao (lixiao.yang@intel.com) ---
(In reply to Yang Lixiao from comment #0)
Correction:
Actual Result:
[root@icx-2s2 ~]# kvm/tools/testing/selftests/kvm/mmu_role_test -g
Test MMIO after toggling CPUID.GBPAGES
=3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
  lib/x86_64/processor.c:898: rc =3D=3D 0
  pid=3D189748 tid=3D189748 errno=3D22 - Invalid argument
     1  0x000000000040b66a: vcpu_set_cpuid at processor.c:897
     2  0x00000000004026df: mmu_role_test at mmu_role_test.c:60
     3  0x00000000004024a2: main at mmu_role_test.c:137
     4  0x00007f73b16237b2: ?? ??:0
     5  0x00000000004024ed: _start at ??:?
  KVM_SET_CPUID2 failed, rc: -1 errno: 22

[root@icx-2s2 ~]#kvm/tools/testing/selftests/kvm/mmu_role_test -m
Test MMIO after changing CPUID.MAXPHYADDR
=3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
  lib/x86_64/processor.c:898: rc =3D=3D 0
  pid=3D189759 tid=3D189759 errno=3D22 - Invalid argument
     1  0x000000000040b66a: vcpu_set_cpuid at processor.c:897
     2  0x00000000004026df: mmu_role_test at mmu_role_test.c:60
     3  0x0000000000402479: main at mmu_role_test.c:143
     4  0x00007f318f8237b2: ?? ??:0
     5  0x00000000004024ed: _start at ??:?
  KVM_SET_CPUID2 failed, rc: -1 errno: 22

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

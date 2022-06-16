Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1282F54EC82
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 23:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378928AbiFPVZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 17:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378323AbiFPVZs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 17:25:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4266F60DB9
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 14:25:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA14061DF6
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 21:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3CDFFC341C0
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 21:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655414746;
        bh=Dh3atd3DHejyD0KSsiHQbyPsXJzqCeyPoAUINaotHvs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=NUDTwSTjS6ScAKt/XzyfGhjXivlxf3YCF+FjjTgEOMxQpt8iDEgMyfYgHmuMwGA4m
         yzEYodMmVZGhZ1BimUWSxI6TPy2poTJRhsO17Qbd0+wz45r85TMxxDc6XTqj0G1EP7
         RcCUUMabF4RBhWTtJzSsmmnajfHVjFtn+hY0pCk52RMFTbVpGViyUq5bzMF6bzZk2h
         Q6O2rFtQCIiUQRNOqGe8kZ3g5a05OJfYX6f83dfCWbjhRlOOxpEfGDzBIiPx8uTtBF
         HbkHGkc+6amEB4NRBEFgoXJBtsrFZfho0KAZ/cv2qj8eoswGAUTU4YlCoqTUNh4LFO
         Hy8Cnhsq6Wn9Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 288FBCC13B4; Thu, 16 Jun 2022 21:25:46 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Thu, 16 Jun 2022 21:25:45 +0000
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
Message-ID: <bug-216026-28872-Be6cR7Z15s@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216026-28872@https.bugzilla.kernel.org/>
References: <bug-216026-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216026

--- Comment #23 from Robert Dinse (nanook@eskimo.com) ---
This is from 5.18.5:

In function =E2=80=98reg_read=E2=80=99,
    inlined from =E2=80=98reg_rmw=E2=80=99 at arch/x86/kvm/emulate.c:266:2:
arch/x86/kvm/emulate.c:254:27: error: array subscript 32 is above array bou=
nds
of =E2=80=98long unsigned int[17]=E2=80=99 [-Werror=3Darray-bounds]
  254 |         return ctxt->_regs[nr];
      |                ~~~~~~~~~~~^~~~
In file included from arch/x86/kvm/emulate.c:23:
arch/x86/kvm/kvm_emulate.h: In function =E2=80=98reg_rmw=E2=80=99:
arch/x86/kvm/kvm_emulate.h:366:23: note: while referencing =E2=80=98_regs=
=E2=80=99
  366 |         unsigned long _regs[NR_VCPU_REGS];
      |                       ^~~~~
cc1: all warnings being treated as errors
make[5]: *** [scripts/Makefile.build:288: arch/x86/kvm/emulate.o] Error 1
make[5]: *** Waiting for unfinished jobs....
make[4]: *** [scripts/Makefile.build:550: arch/x86/kvm] Error 2
make[3]: *** [Makefile:1834: arch/x86] Error 2
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [debian/rules:7: build-arch] Error 2
dpkg-buildpackage: error: debian/rules binary subprocess returned exit stat=
us 2
make[1]: *** [scripts/Makefile.package:83: bindeb-pkg] Error 2
make: *** [Makefile:1542: bindeb-pkg] Error 2

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

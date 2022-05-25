Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB2F5337D8
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 09:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233100AbiEYH5G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 03:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232779AbiEYH5D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 03:57:03 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4525E7CB7F
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 00:57:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9ABE4CE1E2F
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 07:57:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 016C2C34116
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 07:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653465419;
        bh=qe9SZ0gF/2MquTq3ID3BY3u/QQlzkmylboyaRrAjj0Y=;
        h=From:To:Subject:Date:From;
        b=iJQycqfcSLVesFEZvDhZ1ritnGZEGFqVaKvunWXc3mbtqjHwdZle2qTxuBv1dAs/d
         T3aXXbA6g1NPg+s7+ExlOFPLI6VoF/agyLS5Y0pPztCFS+KkQiNwNHiVix9eHcoXwu
         4eLvzbvqa1pFTdDN7irJbDmkHS8GsJxMoDFHk21tQ0WQgt9WZ7VHJpjA+AhevKhOeh
         ot062Led8lTFmMKS0xfbmUqklJToTgCU052O141s+n7ImqXcwm2C6aK1I3ksLeFo7Z
         326Ll9Tulx5RLnq+yzswIIQamR8oOgSN70LGkofxL/QGs0nFmy5QWmDuI9uACXzGt8
         QaIOMV3TlGqyw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id DFCA8CC13AD; Wed, 25 May 2022 07:56:58 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] New: Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Wed, 25 May 2022 07:56:58 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: nanook@eskimo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-216026-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216026

            Bug ID: 216026
           Summary: Fails to compile using gcc 12.1 under Ubuntu 22.04
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.18
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: nanook@eskimo.com
        Regression: No

Created attachment 301039
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301039&action=3Dedit
The .config tried to build against, did a make mrproper first.

CC      arch/x86/kvm/../../../virt/kvm/kvm_main.o
  CC      arch/x86/kvm/../../../virt/kvm/eventfd.o
  CC      arch/x86/kvm/../../../virt/kvm/binary_stats.o
  CC      arch/x86/kvm/../../../virt/kvm/vfio.o
  CC      arch/x86/kvm/../../../virt/kvm/coalesced_mmio.o
  CC      arch/x86/kvm/../../../virt/kvm/async_pf.o
  CC      arch/x86/kvm/../../../virt/kvm/irqchip.o
  CC      arch/x86/kvm/../../../virt/kvm/dirty_ring.o
  CC      arch/x86/kvm/../../../virt/kvm/pfncache.o
  CC      arch/x86/kvm/x86.o
  CC      arch/x86/kvm/emulate.o
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
make[4]: *** [scripts/Makefile.build:550: arch/x86/kvm] Error 2
make[3]: *** [Makefile:1834: arch/x86] Error 2
make[2]: *** [debian/rules:7: build-arch] Error 2
dpkg-buildpackage: error: debian/rules binary subprocess returned exit stat=
us 2
make[1]: *** [scripts/Makefile.package:83: bindeb-pkg] Error 2
make: *** [Makefile:1542: bindeb-pkg] Error 2

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

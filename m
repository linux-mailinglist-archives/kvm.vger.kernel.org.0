Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBA75BB9F8
	for <lists+kvm@lfdr.de>; Sat, 17 Sep 2022 20:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiIQSq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Sep 2022 14:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiIQSqy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Sep 2022 14:46:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00862B1A7
        for <kvm@vger.kernel.org>; Sat, 17 Sep 2022 11:46:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54E536115B
        for <kvm@vger.kernel.org>; Sat, 17 Sep 2022 18:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3740C433B5
        for <kvm@vger.kernel.org>; Sat, 17 Sep 2022 18:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663440412;
        bh=LZ2ZAqO7XXZylmGWbh1XG9xtkgdM+bgVp/4hpTEOzIg=;
        h=From:To:Subject:Date:From;
        b=edJIS5uNBY1EllnMcKeKS0sc5ffpEI8QHS+70DY1SkztYB+aUmFo1tCBQ6Udx9BvC
         CEfj99E2rK1kN60jxz1v+fm3W7YF2ZjPrtXZ9HPid5bbIMVEXQwBm4zSWbUDFpzyrt
         7Kqp7zXAIEOGYJFj/eiF0M/f5792EI7A432oHmDESL2gFmO4Du74VHskAbDHe9mfQ3
         NTXMxoDEOH5wMLeaeDi8oRNWjIfnEDhPdBy3rMdaBx9bRghmpJCwQ9Id90RPAsO1QV
         6K4eCBoKfMvU5HVETZrkTOa4OPm6CxIx4f/7IghA3UPa7uAuwBLnzqm+fY2bNII4bz
         jXbGo4ZmPSYTA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 9F26FC433EA; Sat, 17 Sep 2022 18:46:52 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216498] New: Can't load kvmgt anymore (works with 5.18)
Date:   Sat, 17 Sep 2022 18:46:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dion@inhex.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-216498-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216498

            Bug ID: 216498
           Summary: Can't load kvmgt anymore (works with 5.18)
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.19
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: dion@inhex.net
        Regression: No

Created attachment 301820
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301820&action=3Dedit
5.19 dmesg with warning, GVT-g doesn't work

I'm using Intel GVT-g actively and it was very stable on older kernels
including 5.18.x.

But after updating to 5.19 it doesn't work anymore. I'm sure that it isn't
related to hardware change / bios update. It still works if I reboot to old=
er
5.18 kernel.=20


I'm getting followed in dmesg:

[   92.987534] ------------[ cut here ]------------
[   92.987538] assign a handler to a non-tracked mmio 4ab8
[   92.987555] WARNING: CPU: 0 PID: 3660 at
drivers/gpu/drm/i915/gvt/handlers.c:124 setup_mmio_info.constprop.0+0xd5/0x=
100
[kvmgt]

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

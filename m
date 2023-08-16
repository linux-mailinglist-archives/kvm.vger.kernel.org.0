Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A339C77DCCD
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 10:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243040AbjHPIxJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 04:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243175AbjHPIxC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 04:53:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57941B9
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 01:53:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEB3063982
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 08:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46F37C433C7
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 08:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692175980;
        bh=RqQan85HBG5Xgcj+qAkyK5LYHwbrcmekxu8GroukQMo=;
        h=From:To:Subject:Date:From;
        b=sOfyv8CntbAXSiKEpTFlnvEQS5QxnXAy0fguXTyG1r92Q6an7Av3WsTw7QgdAvReV
         ueo4pnVmyjSij+V36EXBp3d/+DR99oSR8an9jbZhnZ4gfBVlrUuBf/vE0+LeMcU+Az
         4u/n9oRTlfYqoNTl28LnNaFy6YQhgshRxNkiPnYWx82vXbhJ52Bsp4Ipi+ctVVDjwT
         QifPffKKKvTKoynu8w2/7hMX4mLNsy9McTIhWFvSP602JRWM0J2+fg3WD5dLsoBZg6
         f43pUSOmnBTPduUKBo3yKMfFXllrTBcXI5WKEcBKO1eYfa+AJCMjbQ77cLZC+QY+hN
         32Tr2mUBV2qAw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2F198C53BD3; Wed, 16 Aug 2023 08:53:00 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217799] New: kvm: Windows Server 2003 VM fails to work on
 6.1.44 (works fine on 6.1.43)
Date:   Wed, 16 Aug 2023 08:52:59 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
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
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-217799-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217799

            Bug ID: 217799
           Summary: kvm: Windows Server 2003 VM fails to work on 6.1.44
                    (works fine on 6.1.43)
           Product: Virtualization
           Version: unspecified
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: rm+bko@romanrm.net
        Regression: No

Hello,

I have a virtual machine running the old Windows Server 2003. On kernels 6.=
1.44
and 6.1.45, the QEMU VNC window stays dark, not switching to any of the gue=
st's
video modes and the VM process uses only ~64 MB of RAM of the assigned 2 GB,
indefinitely. It's like the VM is paused/halted/stuck before even starting.=
 The
process can be killed successfully and then restarted again (with the same
result), so it is not deadlocked in kernel or the like.

Kernel 6.1.43 works fine.

I have also tried downgrading CPU microcode from 20230808 to 20230719, but =
that
did not help.

The CPU is AMD Ryzen 5900. I suspect some of the newly added mitigations ma=
y be
the culprit?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

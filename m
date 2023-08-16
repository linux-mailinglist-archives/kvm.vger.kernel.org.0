Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7644677DD35
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 11:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243304AbjHPJWb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 05:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243413AbjHPJWT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 05:22:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E0B2D79
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 02:22:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 859FA65CB6
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 09:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB352C433C9
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 09:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692177729;
        bh=WyVGfLqUJsRXJ1+F04Xko6Xp6WjZK0FEMDLaEUmnU0o=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=isZYGmDCh6v1Wixkz54flw0Jckir0p/R+7L67pfpUZFDrgvuDe3J7CzcAc2YVTj4q
         1EgUFECJ8myC0IXmiGqCv4cOUDZlvUJw/cql/tUh3ld1mjQNCoc9gEkOFAfoJc9Lx0
         qJDT631MYy6wCOVqQhpplCwah1db22CCSZiydaAB5oHAi9G5NgoEYIjo7tlQzVZdJB
         KSKLOACl1ixr2MgDlREn9y69pMAWbBFEk5ROQYLvc7gp7kRGG+1+/9p5fyqs48eSQr
         /L0G1/P/mVaK/QQ3cw4TqC+5kknsFLyj4rDD9CEQDJJESIqPck5da3v/0g5cJb8Vy1
         qWB89FlLIuzzQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id D5822C53BD3; Wed, 16 Aug 2023 09:22:08 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217799] kvm: Windows Server 2003 VM fails to work on 6.1.44
 (works fine on 6.1.43)
Date:   Wed, 16 Aug 2023 09:22:08 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bagasdotme@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217799-28872-Y3AErR39fH@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217799-28872@https.bugzilla.kernel.org/>
References: <bug-217799-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217799

Bagas Sanjaya (bagasdotme@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bagasdotme@gmail.com

--- Comment #2 from Bagas Sanjaya (bagasdotme@gmail.com) ---
(In reply to Roman Mamedov from comment #0)
> Hello,
>=20
> I have a virtual machine running the old Windows Server 2003. On kernels
> 6.1.44 and 6.1.45, the QEMU VNC window stays dark, not switching to any of
> the guest's video modes and the VM process uses only ~64 MB of RAM of the
> assigned 2 GB, indefinitely. It's like the VM is paused/halted/stuck befo=
re
> even starting. The process can be killed successfully and then restarted
> again (with the same result), so it is not deadlocked in kernel or the li=
ke.
>=20
> Kernel 6.1.43 works fine.
>=20
> I have also tried downgrading CPU microcode from 20230808 to 20230719, but
> that did not help.
>=20
> The CPU is AMD Ryzen 5900. I suspect some of the newly added mitigations =
may
> be the culprit?

Can you do bisection between v6.1.44 and v6.1.45 to find out the specific
mitigation that have this regression?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

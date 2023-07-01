Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86EF0744847
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 11:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjGAJoo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 05:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjGAJon (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 05:44:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5A11986
        for <kvm@vger.kernel.org>; Sat,  1 Jul 2023 02:44:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D41260AFE
        for <kvm@vger.kernel.org>; Sat,  1 Jul 2023 09:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D801C433D9
        for <kvm@vger.kernel.org>; Sat,  1 Jul 2023 09:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688204681;
        bh=SLExUp18/LJs6g98J2bMPnsRMFS83+vGncFBfBFsW2E=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=eXl2Qxz87e5ocHr13cbYIpYd3aAA3u0LeyGiLnECKssTqJDPFwVB/cNVnNKCAMaKH
         s5EXLH6zqxTI/aZ11I9tx1L9uE129vNj59HpU4N3rPiRKtOyGnMzuhti4n94eIkDee
         r4Ma+ZXU40WuOzzYlauTxhXwolvRcHEshx2BYAWaM50yAFwSu/1dh+Tg9umkZ/0USt
         IfgasF54h4N5Va5tva/IFQlCMQPD1u9i6aeHPKijMLTs29+C49AQQ6gG2yTXBThAc8
         /xhxahHS6eUHn8MsfZAvtTOGcg+DTPBJBlxs/iODF5PnOlfRNrTWbbo7xlMqEkZDX5
         tAUyeDTXME+kg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 6E8F1C53BD5; Sat,  1 Jul 2023 09:44:41 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217307] windows guest entering boot loop when nested
 virtualization enabled and hyperv installed
Date:   Sat, 01 Jul 2023 09:44:41 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: webczat@outlook.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217307-28872-aCHlQoovsG@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217307-28872@https.bugzilla.kernel.org/>
References: <bug-217307-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217307

--- Comment #11 from Micha=C5=82 Zegan (webczat@outlook.com) ---
just fyi, there are other people with this issue.
https://forums.unraid.net/topic/131838-windows-11-virtual-machine-platform-=
wsl2-boot-loop/
https://www.reddit.com/r/VFIO/comments/xxe8ud/hyperv_making_vm_bootloop_on_=
i712700k/
the common thing is that all of them have intel core 12'th gen or later. so
almost likely anyone with 12'th gen or 13'th gen intel host should be able =
to
repro this.
I have also tried things like described in one of these posts, changing cpu
features, changing machine model from q35, disabling secureboot/tpm/other
devices, would try to install in legacy bios mode but win11 probably won't =
make
it easy so not likely to be able to do this.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

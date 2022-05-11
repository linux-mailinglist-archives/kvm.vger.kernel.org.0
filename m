Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C70665229D8
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 04:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241237AbiEKC3o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 22:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiEKC3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 22:29:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05996219C01
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 19:29:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFDC8B81CCA
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 02:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 817FDC385D9
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 02:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652236175;
        bh=Kga1tHouRk/vZkv1zJI0pI41kdo2neJ+KiVrpvUmG/A=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=RUKX+8dbojc63ROxthdzfEMlUuJdOER348wnoT74eowhyxcv4jyn71jphEaXRhCsS
         76xiaHCMfBl4McoGFUZfxcUGOt4I2GhmJKhlG12e/iu0m2TktuYiA51JtoOAEAsrkS
         DT0HV+vJK55A5V7jbceDkED7vi7DBKoyJQwpHBvFPJDGTTLZQv/nQI3T/lj1QFahu9
         UkDg4PW26lBIlWvn9d3tkXgkr1L+2VyCcI/GRa9ldYHF14cPG94rMe1U45SH4Jr7PW
         HRx3gFhA4kttHDrgMP2wRy0pPITUQXNIZcQT4nti8cDPP6uzGeIxLa/C4Rvi9FrI/3
         upVG4rWXpVCQw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 6C166C05FD2; Wed, 11 May 2022 02:29:35 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215964] nVMX: KVM(L0) does not perform a platform reboot when
 guest(L2) trigger a reboot event through IO-Port-0xCF9
Date:   Wed, 11 May 2022 02:29:35 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: yadong.qi@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215964-28872-KIbAT1T0KQ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215964-28872@https.bugzilla.kernel.org/>
References: <bug-215964-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D215964

--- Comment #2 from Yadong Qi (yadong.qi@intel.com) ---
Currently in L1, USE_IO_BITMAPS is set and only monitored the S3 releated I=
/O
port(0x604).=20

And we are using QEMU as userspace manager, I will submit a QEMU issue and =
link
to this bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

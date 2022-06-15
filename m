Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62F2254C1D8
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 08:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353098AbiFOG3x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 02:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236311AbiFOG3v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 02:29:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F663A1AA
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 23:29:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FF7C617F3
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 06:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E3A77C341C0
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 06:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655274589;
        bh=pGSP0eTMuf8uD4h5CTWDkhtcHtSSTBfol8SCVBx6a1M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=E4ed7eXCV6Lzs1nxWZad7hdd4NxKS/mLiyO0pWncUwhqdinCgKODMNoYU8p03X37h
         Eq4SqB3UOO2bhUxhWv0kENpydhpd2mR5mjOKzsWvavhyAr3YDuMqd40I2MVtePUs1a
         fBj6DXCIveH0mSZblcSR2XH8GIA2Q2HUwCYyHMPBbqoxCw8CPmtKFPbxkOvzzsjmyW
         taeqX4pfVIk+njAM5XycIlqpaH2vlToCgJnt7cWRPcrNTf2jy69mVdYqKwk5A+0aHc
         hldcj3H6c++1523vAIZTwb1pX87A8d0rg65jY9tpK6eriUGDt79p2xSrv8DUZ4TIho
         o4OmQeR5lo6yw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id CA6E3C05FD2; Wed, 15 Jun 2022 06:29:49 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216137] Kernel Will Not Compile using GCC 12.1
Date:   Wed, 15 Jun 2022 06:29:49 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: nanook@eskimo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216137-28872-lXrF8XCYAc@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216137-28872@https.bugzilla.kernel.org/>
References: <bug-216137-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216137

--- Comment #1 from Robert Dinse (nanook@eskimo.com) ---
This has really become more urgent now that 5.17 has become EOL.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

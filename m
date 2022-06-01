Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A921539D94
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 08:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350032AbiFAG4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 02:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349988AbiFAG43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 02:56:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD195583A1
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 23:56:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6688CB8182B
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 06:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 07C8BC341CE
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 06:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654066586;
        bh=TJlr27y3x+jz5h8JiL5gtlXWJmWeJ9CrPGMqiGhNdos=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=TzPTGy7a4M53caWJJW8quB3eAxLMdYAykDfjINh01b8M0DECfQBMdPYkr9/H/t2Gv
         uSM3rmm3T7w3c6FjvUDBmj3EwpG6e95ULCTqHSzA0rRkVrFhy4QArS3W8klK9foF1q
         nzUn3/TwJ5qfanX+s+FF82Z4FKowukwVRl65wUcN/zbC5E/pOcqqVCi1aGlM4gLeAQ
         2xg2ceuIECqlXemxU6JNidK7p4v6F9CaSqit5a6HkB+hDhY1dk6rGqH8ZnkSncGO5L
         IcAh11edKIdTh49l+JqX1kXCsCLFQ6oRtuYdII/AREQUH9Lv5UxbTYWdbl+xFlrO5h
         OJyUmn+HYasow==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id EBF39CC13AD; Wed,  1 Jun 2022 06:56:25 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Wed, 01 Jun 2022 06:56:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216026-28872-O1kpsku1pD@https.bugzilla.kernel.org/>
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

--- Comment #12 from Artem S. Tashkinov (aros@gmx.com) ---
*** Bug 216056 has been marked as a duplicate of this bug. ***

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

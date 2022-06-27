Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7A1155DEC3
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbiF0Hl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 03:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbiF0Hl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 03:41:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FA960D8
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 00:41:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 508926009B
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 07:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B75AAC341CD
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 07:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656315684;
        bh=sg8oGFPl6ECYbmmieV+usD/8sSVOb4jx3BtXqzjaeO4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=G01suVoUe6rwKiEAgWiGGB+y0yfv7Ct3k/p60G5yrXL7tTr8BmAIFRptWzqAze5di
         fn1LN7gu3c9DPdbZTATtlRKWqE4aTDjJEh6syfbGfvnbYfrqcbHBRYzekjc977qVRj
         ApjRjVR61Az2B9WrI/JDgviaSOyJc8VUk/rmHdL51pmskvobitGdgFsEVLtQFkgWMD
         CQFHDOCcUeNM7GMFYflLw9MUFFAVqtufpWtJ/n4trI3JlDdCas15y68Doqaz0H1MPJ
         Wran10ucFmn0fzX5CJSBb4HsE90x6yfpY+4q4/NdQPjum+KKCqyPXEj5D4gl4eUIyV
         Q6w53IPXByjDA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id A21F6C05FD5; Mon, 27 Jun 2022 07:41:24 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Mon, 27 Jun 2022 07:41:24 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: nanook@eskimo.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216026-28872-nQbsA0DuvB@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216026-28872@https.bugzilla.kernel.org/>
References: <bug-216026-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216026

--- Comment #41 from Robert Dinse (nanook@eskimo.com) ---
Well now I'm wondering if this was really a proper fix of the code or just a
fix to make the error invisible.

With 5.17.14, a Windows kvm-qemu guest works mostly properly (there is an i=
ssue
with copy host cpu in virtual-manager, where it takes a one socket 8 core, =
one
thread / core CPU and maps it to 8 sockets 1 core, but I can get around tha=
t by
manually defining layout.

The virtual machine is using i-915/UHD630 GPU virtualization and pass throu=
gh.

Under the 5.17.14 kernel this works properly.

Under the 5.18.6 kernel it works right after a fresh boot but within a few
hours it loses it's brains, I no longer have a cursor, I can't get the host=
 to
communicate properly with the guest anymore.

Should I re-open this bug or file a new one with that description?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

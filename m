Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4BBB6C8EB5
	for <lists+kvm@lfdr.de>; Sat, 25 Mar 2023 14:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjCYN7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Mar 2023 09:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjCYN7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Mar 2023 09:59:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7632D78
        for <kvm@vger.kernel.org>; Sat, 25 Mar 2023 06:59:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACFBE60C5F
        for <kvm@vger.kernel.org>; Sat, 25 Mar 2023 13:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1B00FC4339B
        for <kvm@vger.kernel.org>; Sat, 25 Mar 2023 13:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679752742;
        bh=EdHyYaTfkxyPxS8b1Mnu+as46KiRXpFvU8jLPhXuHlE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=aBXvCnJonhjHLMmZp9Elug2i5yRqyZiYdNEGpXCyh6+IVG7MfOuB6YvjnsQxQxuC3
         ygLvpyesG2odtYzQQSIFiEyvtRU1n3O++pnPg4KWfR1u2qCF+2a6pq6YMKhI2wFCOF
         pu/Xq2mGKK+Lsef+RL6UcvnBnxD4XqXCZIn4wZ5GQaR4+JCw35zAfzagn1tAo5wmOT
         qh35Lp9tbUPUZGHrBQA5Rnvh3QeYXJW/XGMwbCGr1D6kOP9KjmT5MfpzDgNkFn9CxE
         u96RCahYB/QyQRIR0xUNcGCf/XCnxhiQYLyNeSDvDJipzVZ/kC4cIvVzSdXtTtCMGm
         /cTKOqFMdRtFQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 09347C43144; Sat, 25 Mar 2023 13:59:02 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217247] BUG: kernel NULL pointer dereference, address:
 000000000000000c / speculation_ctrl_update
Date:   Sat, 25 Mar 2023 13:59:01 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: hvtaifwkbgefbaei@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-217247-28872-pjHaiz2KZ0@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217247-28872@https.bugzilla.kernel.org/>
References: <bug-217247-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217247

--- Comment #1 from Sami Farin (hvtaifwkbgefbaei@gmail.com) ---
Created attachment 304024
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D304024&action=3Dedit
lspci

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5664159186B
	for <lists+kvm@lfdr.de>; Sat, 13 Aug 2022 04:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbiHMC71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 22:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiHMC7Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 22:59:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F7B9DB74
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 19:59:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57C2B60DDD
        for <kvm@vger.kernel.org>; Sat, 13 Aug 2022 02:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BDF07C433D7
        for <kvm@vger.kernel.org>; Sat, 13 Aug 2022 02:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660359563;
        bh=ms+WfAzPRy8jgWDh9okfXnHbrSBMohrvp8hnIT7Hiks=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=hehTKV/EqUGKe+5xjwKik4sfRV45RXCFh3H1di4zPPmg8SA1EpDxzTRCV708ClEFX
         FUXStB6jQdAWGiCJnz7JEYC6FhTz1IiQP/TK+dxtEeRH7fpwGR5Vkitlxf1cCA9Gcx
         clqnGKBk5aorlwozFBr8a5o4rFHWB6kIc3Ok2z6+wSlvXcTl4hOA/o9BAnuMXG9b7o
         N0ksxHQ8ttFWaVz1x91/nLBEuXEsPOpYDmswd/O0Ak1xC0PfSlz3ex6dXevh3VStMf
         KcRNYlSfPhMVZNkUQbP+KypwYLm1jUCR975upWI4ZK/X8Y85S7dlNTxowq27sGAnEN
         UqkP6gKLHVvag==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id A0C1CC433E4; Sat, 13 Aug 2022 02:59:23 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216349] Kernel panic in a Ubuntu VM running on Proxmox
Date:   Sat, 13 Aug 2022 02:59:23 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jdpark.au@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-216349-28872-Kcn7XeHXop@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216349-28872@https.bugzilla.kernel.org/>
References: <bug-216349-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216349

--- Comment #9 from John Park (jdpark.au@gmail.com) ---
Created attachment 301557
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301557&action=3Dedit
kernel panic - netconsole output

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

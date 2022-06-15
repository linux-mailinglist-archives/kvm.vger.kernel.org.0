Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDB754D478
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 00:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348905AbiFOWRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 18:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346231AbiFOWRo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 18:17:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1343113E89
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 15:17:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79702618CA
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 22:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5F25C341C5
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 22:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655331462;
        bh=nRTCekOoVKkuw4tdJMvlvlWfbJQb9ZUNVRqFotnDuws=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=pdLDxvMzmfpRwxg0gCB8cKqHa833SLOc/Bb7dw8tehTafGsybGPCDzZL/DQzrBwla
         70NqR8fx/PHqmoGKA1nv+3nFomxIFuq/I9uxB0ETIRz4EsU0+xKe3ilg/1jS59IiWC
         NGsAfFy8knlm6Y51G8bcYAE8Qc2FB9cxyJAwNdrabDwTBCFK5KZIWJjviB8VeZvc+3
         etxvCYkKQhCqtMM7mBHWsLnvtAE+myt4EvcrQH1NkKIIIzV94B31DSzzprz4EVAyS7
         wi8OnUhIeUz3D4rSb2fcTrFhhKEFetu/LerobDJJxA5kpIW4ldsZ7IsQAvVfeL/WwT
         BdvYaX2X9vWhQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C2E55CC13B4; Wed, 15 Jun 2022 22:17:42 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Wed, 15 Jun 2022 22:17:42 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: nanook@eskimo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216026-28872-4JWzRevZa8@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216026-28872@https.bugzilla.kernel.org/>
References: <bug-216026-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216026

--- Comment #21 from Robert Dinse (nanook@eskimo.com) ---
(In reply to Artem S. Tashkinov from comment #19)
> *** Bug 216137 has been marked as a duplicate of this bug. ***

     I would not have created this duplicate if the search function in bugz=
illa
worked properly.  But I tried advanced search and searched for bugs I creat=
ed
and it returned zero bugs.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

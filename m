Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C16755B3AE
	for <lists+kvm@lfdr.de>; Sun, 26 Jun 2022 21:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbiFZTEg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jun 2022 15:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiFZTEf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jun 2022 15:04:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6698DAE41
        for <kvm@vger.kernel.org>; Sun, 26 Jun 2022 12:04:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0404360F60
        for <kvm@vger.kernel.org>; Sun, 26 Jun 2022 19:04:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 58CC6C385A9
        for <kvm@vger.kernel.org>; Sun, 26 Jun 2022 19:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656270272;
        bh=Bq7CtgVOL67NJvsDYqg6J1ixt+NZsHCu/tiZlEw73GE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=PT3S0TKQZHPmvNMB1V6SV1PVXF1W/4mixobbdpvzpHZshIx4SNQY6iuK3dFush1DM
         v1s+GfJmROQBNoA6WboIR40O9XL6YyB7K20kRMZZ4uIu71L+TCpCD/lkRibum6T0Vg
         EOJ3bxiUEL/Hm37R7PDYFzrjdCxVmA8BeD0JccQxd9ptRW5y2CeSLMK6+MUlIZZ0cK
         zYttVysXYf/Uk9yxYqoJ8hwYDlt5DZCJq3AxcPS6KjN+wwN+d31+H3drVP2qbQ/AjA
         esEGs2M3i3fGqdcdCdwXgO7CGuRokWromDIQsr9n9kk8hH4/dQbxv5JvhMfUkbvTec
         g/aPBIjqk4IIA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 428F6CC13B4; Sun, 26 Jun 2022 19:04:32 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Sun, 26 Jun 2022 19:04:31 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: alexander.warth@mailbox.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216026-28872-A3M0IsQ6gz@https.bugzilla.kernel.org/>
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

--- Comment #40 from Alexander Warth (alexander.warth@mailbox.org) ---
me too. Thx for the fix and efforts.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947AD55373D
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 18:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352294AbiFUQFS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 12:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238552AbiFUQFR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 12:05:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F4694
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 09:05:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D8E6612EE
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 16:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CEAE5C341C6
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 16:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655827515;
        bh=vxn8xm9FbEXvB0I/KCpEGfljqQPVKWSOWkvKiOEubPs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=pApr8I2Xw1FG5Yo09PS0z7w37+vZZ9FRIlpIXMtS7BSpRhqIbJmvh5u0UFlNIVbyn
         VzPw+1SdeOSoc0QP5TzmYFXXBKwZgmFYRuyJVrG2HG0wFGJOi9iznfA4ryuFpHQO3f
         fpsg0G2fJkNk77FDlT4l2YI/pMDeQLfatgjbZzsnokgykuB4S6+6F2TUpRW/PK3Lqw
         ZzJVAXjWWayFSQ44O3r0Ngqs+ijvs4xaVmldE9Y6Be8swI78t+jSpuyFmwJAGn3qpu
         EIQ8f1aizZJxYH1MRwpBa/MSXKFyIW4IZ1+AUOiGz57IICnXf5WzqfEmJOdplEMdfS
         3AB9sMp7Amc3g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B619CCC13B4; Tue, 21 Jun 2022 16:05:15 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Tue, 21 Jun 2022 16:05:15 +0000
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
Message-ID: <bug-216026-28872-kRf05DSMXQ@https.bugzilla.kernel.org/>
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

--- Comment #36 from Alexander Warth (alexander.warth@mailbox.org) ---
Thx Artem.

As said before it is basically already fixed by this patch more or less.=20

https://patchwork.kernel.org/project/kvm/patch/20220526210817.3428868-3-sea=
njc@google.com/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

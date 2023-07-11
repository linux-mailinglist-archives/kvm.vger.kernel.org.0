Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E226E74E737
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 08:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbjGKGYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 02:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjGKGYh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 02:24:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16D4E57
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 23:24:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 432C461331
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 06:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB56DC43391
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 06:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689056674;
        bh=QETeoBOMHyo+zFhO3IBU81P5RIbfL9BjzrfdtMwlR4Q=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ZKMTwcjjQHo0AH3+0sYtENyfVu7nScsXwuM52rPfFvslZLHzpnuJuTRs4DBoRYGOo
         wKm3qhZ0mTYyVi0efKjp+FW2l4OmcAIM+tRYZoFJhLi5gBgut/tzPyfvb4bcrsqwKL
         oml57j7+h5SWcE++MwAN6/nImc+FOpbtpI632DVMMjh/Aqqyz1GcxVUEWMB8doWTT5
         c0QQQFicAyvX0goIQLj1H70mkm2lUlzRYYVSC7rR1utqC5+7nBcObRU46QTdbCNZIA
         NO69566s9aLioP3sCAryiNvWQehLIL5bXVqkZqe9WqLKU9S966KwC3DZO3zhi/nXoV
         E7zB5zp3tJ+7A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 96E17C53BD5; Tue, 11 Jul 2023 06:24:34 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217558] In KVM guest with VF of X710 NIC passthrough, the mac
 address of VF is inconsistent with it in host
Date:   Tue, 11 Jul 2023 06:24:34 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Drivers
X-Bugzilla-Component: Network
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: farrah.chen@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217558-28872-XwvSbFpLU1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217558-28872@https.bugzilla.kernel.org/>
References: <bug-217558-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217558

--- Comment #11 from Chen, Fan (farrah.chen@intel.com) ---
Thanks Radoslaw, looks like your patch can fix this issue, I used above ker=
nel
with this patch, tried 5 times to reproduce, can't reproduce, mac of VF is =
the
same in host and guest, got expected result.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

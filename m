Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E70A87487D1
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 17:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbjGEPXu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 11:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbjGEPXs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 11:23:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9542E170B
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 08:23:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C05B615F0
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 15:23:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8FCF5C433D9
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 15:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688570626;
        bh=EU0KAhxjqn+Ob0RyjLQpfA+2QBsokNpsCGuAxaQ+hak=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=SH9orV7bW28tWZcYHl8EjTnG3ryuEdiSTPFVNd3ROEw/wfuZhXL8xnitXn0AMlhS7
         Z/Qab+KyGv4f/hbVU3VDgojpxhH7hAzp3dPNGRxanEY3NmaXLnGAMkKSMUb1FA4kId
         2FPUHwhqa835Uk9EX4UOhCjkIjwFX394hfNqwCtufR7YKOl4m8a41ua9VHrufXS1BM
         P4EAI9b6qvfynsS0n0A1C7DKZBVCNSjCMzcHN5EhZo+AMcvIhgJAHJqKMiASmB8AhC
         GIeWIjXS0EbqS6m9ecZ4+lCYTGSLNdxkxmPLgrcbFzfJC3LbLrfrb7AmUYo4CA8+U0
         Y27n2nSazJN6A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 7F858C53BD4; Wed,  5 Jul 2023 15:23:46 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217307] windows guest entering boot loop when nested
 virtualization enabled and hyperv installed
Date:   Wed, 05 Jul 2023 15:23:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: 780553323@qq.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217307-28872-mEBH2fssCu@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217307-28872@https.bugzilla.kernel.org/>
References: <bug-217307-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217307

--- Comment #16 from Prob1d (780553323@qq.com) ---
i7 9700 actually. Before switch to host mode, the config below also works f=
or
me.
<cpu mode=3D'custom' match=3D'exact' check=3D'partial'>
 <model fallback=3D'allow'>Skylake-Client-noTSX-IBRS</model>
 <feature policy=3D'require' name=3D'hypervisor'/>
 <feature policy=3D'require' name=3D'vmx'/>
</cpu>

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

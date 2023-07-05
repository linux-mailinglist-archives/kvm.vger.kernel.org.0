Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB6B748809
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 17:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbjGEP1u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 11:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232425AbjGEP1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 11:27:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE2719AB
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 08:27:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4556A615F2
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 15:27:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ABD91C433CC
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 15:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688570857;
        bh=4MuFxGvSTsOdfrWrgL+EE6BlSs/I8K+sTUbxq3UDGs4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=RFlDN+WOyXp1I4xca6wo2qR/0KYcecZPb5QhqnIE0Epu4Q3HnPvflQwRh1Wew7Osh
         TtswPxeKyqnnuaOKJBQ/gBae6BzGyeXxNw/zhb2rZclqN6pNc4tV3Zyvv0if2VhO2b
         e9cdSanHfjdkow5L5MgxTk8h0ibB/wnU/meaGwTYn8bKENTmRgiqBjwNYIEsSkVrOE
         D5/wojXla/zEa8D+chMtOhphrx0A0Eg3hhrakIjtwIW4fII5emwdhh6VAZW4y5UUX+
         bm0Xi81l9Uxy8e8dOPPrpycOdNznTsBqd8x7qZn4uI8p2MUxtUi50iB//V0Zjrw3RW
         JydySSZJHYlZg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 9B5C7C53BD0; Wed,  5 Jul 2023 15:27:37 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217307] windows guest entering boot loop when nested
 virtualization enabled and hyperv installed
Date:   Wed, 05 Jul 2023 15:27:37 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: webczat@outlook.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217307-28872-KZcSwzuIhy@https.bugzilla.kernel.org/>
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

--- Comment #17 from Micha=C5=82 Zegan (webczat@outlook.com) ---
well, no matter what problems you had before with nested virtualization,
according to some forum posts I was reading lately it seems that my problem=
 is
something that exclusively affects 12th gen and above. and no toggling of
features help, except features which would just disable nested virtualizati=
on.
sep, vme, vmx features when disabled make vm boot without hypervisor. Any o=
ther
combination results in boot loop, and i was even crazy enough to both disab=
le
and enable them one by one. nothing comes close to working.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

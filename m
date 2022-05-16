Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF2D5288F1
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 17:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242468AbiEPPeA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 11:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiEPPd6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 11:33:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A8B3C701
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 08:33:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 41C09CE16A2
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 15:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7E45AC34113
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 15:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652715234;
        bh=gF7f/ZkXA3wqcZi+uFyyxchoTB6IVbwmQbf1k5/CmcQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=dU7sXUWnmnJlWup8DCsigiNcqYKePEeHeTqgjOuenfrHgTr2N4DpKfgLCjgKVQW6A
         PnIPGQRkwnZziGklEuduMBDoOFx4e/5foolcuKQzuSnwj1jIx2oamKwGASndasM/gC
         uw3bH1JTaa4f5wsJcth/y25Ck09jDdKf5pcFWUh/3TG4jdH04ZHOyWrdTVP0E70w6Z
         jsUxtm0XRiBFzXwV6ywrzSAGTApDYvOMg9m0jlWEBJ4j6eKPWzEY56I8iS4Rb0w+GU
         tEH/xEWxC045SlsceBWtFnt2bDYmnYHgzI4D4sGNYm4yTto5Jl0E4ujxPe2hjiru1F
         Hqh1RkauOlwLw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 6232DC05FD2; Mon, 16 May 2022 15:33:54 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215977] kvm BUG: kernel NULL pointer dereference, address:
 000000000000000b
Date:   Mon, 16 May 2022 15:33:54 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-215977-28872-gS5C8zWJii@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215977-28872@https.bugzilla.kernel.org/>
References: <bug-215977-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215977

Sean Christopherson (seanjc@google.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seanjc@google.com

--- Comment #1 from Sean Christopherson (seanjc@google.com) ---
Looks like the FPU XSAVE bug[1] that affects older CPUs, fix is pending[2].

[1] https://lore.kernel.org/all/20220502022959.18aafe13.zkaspar82@gmail.com
[2] https://lore.kernel.org/all/20220504001219.983513-1-seanjc@google.com

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

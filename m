Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18D7550F70
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 06:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237006AbiFTEfM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 00:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235669AbiFTEfL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 00:35:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318B6D11B
        for <kvm@vger.kernel.org>; Sun, 19 Jun 2022 21:35:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC74DB80E51
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 04:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3CEDC341C7
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 04:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655699707;
        bh=NMwEVlv081347MhGP8/yuP8cvzRUMhaEqGRpX7lOhzQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=i7gcfWEDProKw2EQYnmB0lJwUxJMIbbOLMpfyb9/U+M0r/E1Ojp5K7Pw4wN9TDBDP
         BZXZJsRUoyxzTdPpx6uZaPt3diagkwldV9LqNWljkttbSyOZMGki7w/JFyX7ahITBK
         xRDTF1CDPBSmZlJJ9RaayxWgjHOCgUO+9l0uiakgnZbUlMCtgG7cqdCzAoO/sY+ndA
         W1aOF+RZp5A8xPsrSK3xlZZQnS/Y8SSimQvmDTl1KjwfimpJpSOP/R4nzidG3CvwfX
         yc5WIFyNSIwQglwGEsJ74vq2g9//2AJg+yD+jwqevgyuizbnsF9nLRJK6+kT+BSuLc
         Bg9EcGOIXxVPg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 999BDCC13B5; Mon, 20 Jun 2022 04:35:07 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Mon, 20 Jun 2022 04:35:07 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: nanook@eskimo.com
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216026-28872-yS9pcel1gu@https.bugzilla.kernel.org/>
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

--- Comment #28 from Robert Dinse (nanook@eskimo.com) ---
I tried compiling this with Clang 15, it does not work either, get an error
that says error: write on a pipe with no reader, but the clang website says
this is a clang problem, apparently a race condition, so it will not compile
with the current version of either compiler.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

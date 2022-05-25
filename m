Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 441FA534551
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 22:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241573AbiEYUvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 16:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbiEYUvI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 16:51:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D1490CC8
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 13:51:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52037B81EAF
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 20:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 00148C34114
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 20:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653511865;
        bh=N4Bzvmh4nZsJaeG+VOvzQ2SgLs7se7e8GEFaHwikArg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=NBAl4XTfhvOqbBoiYRQKP4BwF/4TZfjVmOZNYDyqskRB+oosR5+AWZlEBD2fyDSu8
         6Hn+IewAf72juy2GLB0+Mui/zxjHKbJQoYengYEPDjWsQTN3RNtR5fQR5Kb7jC6zuX
         W43WgZ9GgsCW1tDuc7RgY9XAtiueH4f1Luw2hZzvkDjGkqbRi3Lsq3mvgo4MCoHJPH
         ZQb7y5IRglxp5rZrbtjxAMyxHufGz2JAffSWzQVHasUx6pegY4JnETDj1qAqiSdATK
         CRzEjnsrq9IFmFhgKGkgx7jpsC7NTWUUnXcH2nlyHro6cAtzuTkJ0ieKXiICB+JaqK
         OnUHRA816YOwQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id D4625CC13AD; Wed, 25 May 2022 20:51:04 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Wed, 25 May 2022 20:51:04 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216026-28872-fHgRY7R93V@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216026-28872@https.bugzilla.kernel.org/>
References: <bug-216026-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216026

--- Comment #5 from Sean Christopherson (seanjc@google.com) ---
Ah, commit e6148767825c ("Makefile: Enable -Warray-bounds") removed
"-Wno-array-bounds", which is why I couldn't find a reference to array-boun=
ds
in v5.18 and later.  So yeah, v5.18 broke a bunch of code :-/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

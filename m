Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95FBD534466
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 21:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345041AbiEYTlM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 15:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345000AbiEYTlF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 15:41:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F405566CAC
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 12:40:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F420D61A0A
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 19:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5F1AC36AE9
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 19:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653507655;
        bh=TD1n1yD0RiTvfJzutJesVQ8txq1hXnpzTNYR/KnStYU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=FwyiJeHPy3+vTLeUXS+OP0bIZts6XP2vKf8fH+h/l3QXOmK7lyXHVnGy4nqaWqJVT
         nuBgc6aPWWoqsbhRIYFpi15aBcyZO7CYYueMiEoDpLE0sRczDidMgmpC9b6OKpWret
         Eh+xoSg4UO2dW7PAj1bOjTdvkRszjS0s3hfpde2cGVIhAf2ZvVVLZoBBvh2M7qrBpU
         7trTPXmOEum9BEUiy+dB7qoi0guclmeXxc3XBcWe4h78461sdbukzZYobFivF1DdgZ
         mYSHQDjWh/Cs2v/6hrKGmKQNNbhjaIfFIVceP5WHMYzb0xrRqolNrQ5x79OViI2G03
         VL1g0NPb7Kv1A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B1E99CC13AD; Wed, 25 May 2022 19:40:55 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Wed, 25 May 2022 19:40:55 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: nanook@eskimo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216026-28872-Vb2hKqBmqN@https.bugzilla.kernel.org/>
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

--- Comment #4 from Robert Dinse (nanook@eskimo.com) ---
I compiled this:

Linux nanook 5.17.9 #1 SMP PREEMPT Wed May 18 14:16:39 PDT 2022 x86_64 x86_=
64
x86_64 GNU/Linux

On the exact same machine with the exact same compiler, and save for the new
additions which I left at the exact same values, the new additions I left at
the default values, in the exact same compiler environment and it compiled
without errors, so something DID change in the code.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

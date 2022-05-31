Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B3A5389D6
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 04:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243503AbiEaCKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 22:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237934AbiEaCKf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 22:10:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66005C772
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 19:10:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDF7C61090
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 02:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 43D83C3411F
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 02:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653963033;
        bh=c4iiOEelTUAr7oygK+JsnKHB3bPWKt3SCkNsa9VrsQI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=qlikk5RpTNl1MSJUFF8GrppMwU7xrdzROypZhTtZljeyvXsh6ofP/5lDwKPDaEb2n
         b6a/ORJkIljuYQhs7yTe06v1zxnsHURhlR58D5ySSp4w9pK9VylqeN54zx6rpcZEze
         +tnnTzZ2yGottvhymhSTF9B/rPsanqc7ICng7YXjDUEa+goufJWTpCel4k8PrORign
         /wDYiGfX1aNcMJOM167p87bu/kLA4+IkFeYTVu4IV8spuctLZALWllPU/gzdO0g5Hi
         iH+OuILNZdQreztTS4g+ukdRQQycx8eTEnR2KB9B+wixy6vhKSUICSFJYvJasWuOzv
         Iw66H0XsgXQUg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2A31CC05FD4; Tue, 31 May 2022 02:10:33 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Tue, 31 May 2022 02:10:32 +0000
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
Message-ID: <bug-216026-28872-UtuCDPNNYW@https.bugzilla.kernel.org/>
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

--- Comment #10 from Robert Dinse (nanook@eskimo.com) ---
I unfortunately had to re-install Linux on my box between the time the patc=
hes
were installed and my last backup (which I do weekly) so lost them.  I was
planning on just waiting for 18.1 and hope they had incorporated them by th=
en.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

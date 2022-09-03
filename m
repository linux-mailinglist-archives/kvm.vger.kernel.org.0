Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05DF65ABD3D
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 07:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbiICFb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Sep 2022 01:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbiICFb5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Sep 2022 01:31:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9B342AC3
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 22:31:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 634A7B82E86
        for <kvm@vger.kernel.org>; Sat,  3 Sep 2022 05:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E246CC433C1
        for <kvm@vger.kernel.org>; Sat,  3 Sep 2022 05:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662183109;
        bh=qwQuSRSrk8hXY/zVfFODhVss+MAOFE2GU10Cae6il+4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=X+PPvdYUp0rkEB7/GQfGCwN0JF6XWViX6VfXzt9D7iBRvrPqZLtT6zGTxTr4Yc5Nv
         VdeRyqZVvY2QUac+ILekS9+Vx2NJl94+LMgxRmGo3kdRDhaZKYNwlAUH68V9FgwIg7
         5ITOH7vutx4mZzskmPhqkHvMj30+3zUdMAxALY7iyfkAK9wskVRX+Nons6PHFZN6ES
         dRrExl01n+0E/trYuM0tFc64Es/7xexAHxY92XvKB5lfSVrG1AvjR9ast85uX2/tG9
         htGjvtez431OibM6otdDQstdPPPx4U5WHAbEIMbwZlPWNP1nQO4VkNbAbgSu8CUKGI
         dda+doX2zhaHg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id CB698C433E9; Sat,  3 Sep 2022 05:31:49 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216388] On Host, kernel errors in KVM, on guests, it shows CPU
 stalls
Date:   Sat, 03 Sep 2022 05:31:49 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: nanook@eskimo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216388-28872-upGr2JMvDG@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216388-28872@https.bugzilla.kernel.org/>
References: <bug-216388-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216388

--- Comment #14 from Robert Dinse (nanook@eskimo.com) ---
Ok, with 5.18.19 no rcu sched detected expedited stalls so this is definite=
ly
something that broke between 5.18.19 and 5.19.0.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

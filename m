Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E35515ABC1B
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 03:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiICBiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 21:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiICBh7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 21:37:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADFD1144E3
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 18:37:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92E22B82D27
        for <kvm@vger.kernel.org>; Sat,  3 Sep 2022 01:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 505AFC433B5
        for <kvm@vger.kernel.org>; Sat,  3 Sep 2022 01:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662169076;
        bh=DZT6akR6Q3IKUe1/J25jXGWMJclz0+xgplX7a89S+mY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=dQjsg1Aa+zueERXsqI1wsjrcN5GK5UuD10hIz0dWd+DBCxQbrp5TmNmW8zTbltJh0
         FxN9PvmHoCPCYhZPKE9jTpSiTtw9Cxga72MIDjcDI2UrBxQeDE5IaC9tIGS+iUawiz
         1+2cQQPkAr4+xI/XTlJNIJg0Rq2mlbcSLdGz6Zkn73tTAqFq4XAkwZW9f7yi4bHN6x
         hZx6UC6w1I3vtrw7mggw1x0mbAouWenBXjBAAOvjQeBAmFFJmLDM/ThK62hsc/IuoB
         pFfllJhbQCU0BYIblQDIF78ykYwDbPbA36GclAV0UaXy0N2WEtZcsbGr6Qoig+8gMx
         pTsSfrPmB+dTw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 31B79C433E4; Sat,  3 Sep 2022 01:37:56 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216388] On Host, kernel errors in KVM, on guests, it shows CPU
 stalls
Date:   Sat, 03 Sep 2022 01:37:55 +0000
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
Message-ID: <bug-216388-28872-LuVPOdKl5L@https.bugzilla.kernel.org/>
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

--- Comment #12 from Robert Dinse (nanook@eskimo.com) ---
There are four machines where these seem to happen within moments of a boot=
, so
I am going to five the EOL 5.18.19 a try as they are all guest machines and
thus I can easily reboot remotely into a working kernel if 5.18 locks or
otherwise does not work.

Another thing I tried was raising the rcu expedited stalls timeout from 20m=
s to
40ms, but made no difference.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

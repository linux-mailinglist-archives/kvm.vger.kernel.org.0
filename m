Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB7F05AF734
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 23:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiIFVof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 17:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiIFVod (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 17:44:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F11BE5
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 14:44:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73393B81A50
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 21:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3395DC433C1
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 21:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662500668;
        bh=qYYg7zzQmJfLak+hnFDkLvIwSfx4EXzlEL3j9qj1aBA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=pYjBklbPMeC9ffpwhtLUovtvV+DAWKAkT7Mbd3YG4nbZNDXunstmslgIhoQvCVWhk
         JZJKB1r9NXvZAcNI5FcwpxdgXRT4YED7CxcIVjHD4pkVZvQhbmH3ak83mjc7y8LTWU
         S2f69Wxm9TMVLO9IBs6putabSTdayYlTOfr3ZFAcgldgymPncJP3DPoUOktrLsgQBm
         W3Ir2w+86SSeXm/pv/LedCTFH+sbO9CnQ4Z5L+6ttcYu4CsbdQ1sB3nGUZPWTycxDq
         ima97WpBzBzFwZrGM9I9AJQUwxUS3U4NUW7/JcR1IayozQs53Dkpghtp9IkRAA0ztl
         Yt1mVcOXqX/dA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 18AC4C433E4; Tue,  6 Sep 2022 21:44:28 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216388] On Host, kernel errors in KVM, on guests, it shows CPU
 stalls
Date:   Tue, 06 Sep 2022 21:44:27 +0000
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
Message-ID: <bug-216388-28872-XJJo7G024O@https.bugzilla.kernel.org/>
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

--- Comment #20 from Robert Dinse (nanook@eskimo.com) ---
At this point 6.0rc4 is running flawlessly so whatever was broken in 5.19 is
fixed in 6.0.  If 5.19 is going to be a long term support release then it's
worth continuing to pursue but if not there is little point.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

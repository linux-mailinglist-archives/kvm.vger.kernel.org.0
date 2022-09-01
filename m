Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5BE5AA057
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 21:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233911AbiIATqn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 15:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiIATql (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 15:46:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1290A8276B
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 12:46:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C86C0B825DC
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 19:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8FA70C433D6
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 19:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662061598;
        bh=4S1icuF84RX3tQCLD8eGmk7tmFo1T0jF5jPn0wJJQlo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=gjaYJ286ETwi1WJBRVT9hexikxx0aPLll6Xz+wz8ExvPccgo5KVQt11ePBf485eaY
         D3FxlhBdcdQ3ItkSEH7EfGALLVBLPVEFDvcsykQpMIk1SWsOEpJ3MVUkpVm1H8BYYn
         3T9Ejjn4FSOBMCxSU60Tn+iNgRr46fUL5gOf1LiTq8aV+5+HPxzpoyCg4TLms3P8UC
         QksKjQleFrXiEnhyK2g1n6KzsvAVnQv2yn3Q636IaEx0GrNwii4z0XGlIovzgmxYS6
         wFEF8Nh1+VAFA/LnOR+O3v7hCpBeygdq2U+FLWECX28m/51XMvk6VPq7r41uGikpFj
         sC+eQhxLm3PBg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 7B816C433E9; Thu,  1 Sep 2022 19:46:38 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216388] On Host, kernel errors in KVM, on guests, it shows CPU
 stalls
Date:   Thu, 01 Sep 2022 19:46:38 +0000
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
Message-ID: <bug-216388-28872-NZk3ZXNbhA@https.bugzilla.kernel.org/>
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

--- Comment #8 from Robert Dinse (nanook@eskimo.com) ---
     I will scour the logs and see what I can find.  My understanding is th=
at
Ubuntu 22.10 is going to be 5.19 based, but Ubuntu does not run a tickless
kernel so they would not see this if related to that.  I may try compiling =
the
host machines non-tickless just to see if that makes a difference.

     I could run 5.18 on my workstation but it is not busy enough to freque=
ntly
see these (maybe once a week).  Oh these three above were all on a KVM guest
rather than a host machine.  They were from my web server which is quite a =
busy
machine.  I tried 6.0.0-rc3 on my workstation and it is still wonky.  No lo=
nger
locking up without error or even magic sys request working but now video wi=
ll
not play from bitchute, and video will play from odysee but without audio w=
hile
youtube gets both audio and video, all from the same browser (Firefox) so I
don't know where to even start with that.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

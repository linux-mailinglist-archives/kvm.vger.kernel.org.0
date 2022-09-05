Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A71D5AC94F
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 06:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236131AbiIEEGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 00:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbiIEEGb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 00:06:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC7A275DD
        for <kvm@vger.kernel.org>; Sun,  4 Sep 2022 21:06:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A062EB80DE2
        for <kvm@vger.kernel.org>; Mon,  5 Sep 2022 04:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 47C3BC433D6
        for <kvm@vger.kernel.org>; Mon,  5 Sep 2022 04:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662350788;
        bh=PZz0XCBM6X4ouJZowyFrOf+ZYFViK6w8pZhFolgl+kA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=RHJMdzWEKUTj3aUEGI3i8lyuWAEidg7aBrDB6Kmi1BqpyLa1TFA9f3zksMQSuXgS1
         haiNEk9DJIetV2L7mcfX/cJLc/1RaphtagZLILv3S1jw4YjjTq0p3cxGNcJV3yE8L9
         b7APUex05k6/96SCLKMbg35K/l2HqNKpRU0GEFJFUyJhwd1RUhQkdySyl66Xz+MyJy
         h/iJYBthSPlyOqodXR82C/gK55Oc+f9bOkp6MToxhPgRxfUxmeWtl5yI0mRWf5gXoG
         9K9mLN6asfnduwndgpIXud36WbKNtxi5lmpPsQEMM67gX1OhQHpLKgSyMN/OWvaLrK
         O9RG9zfAW3O6Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2F122C433E4; Mon,  5 Sep 2022 04:06:28 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216388] On Host, kernel errors in KVM, on guests, it shows CPU
 stalls
Date:   Mon, 05 Sep 2022 04:06:27 +0000
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
Message-ID: <bug-216388-28872-p3SNEfkGKu@https.bugzilla.kernel.org/>
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

--- Comment #18 from Robert Dinse (nanook@eskimo.com) ---
Since 6.0.0-rc4 came out today I decided to give it a try.  rc3 did not work
with my Intel graphics, booted and ran okay except no display, rc2 had issu=
es
where on some websites such as odysee.com, video would not play at all even
though it was fine on youtube, on others like bitchute, video would play bu=
t no
audio, rc1 ran for three hours then hard-locked, not even magic-sys-req key
worked.

But 4th time's a charm it would seem.  rc4 worked the display properly agai=
n..
And video worked on all the websites.  And I didn't get any of the RCU
expedited CPU stalls AND it FLIES!  My PHP based wordpress website loads in=
 an
awesome 38ms!  And at least half of that is network latency between where I=
 am
and my servers are located.

So I'm not going to continue to pursue 5.19, I don't feel real comfortable
using release candidates for live workloads but this is working better than
anything ever has.'

If 5.19 isn't going to become a long term release candidate perhaps should =
just
close this ticket as will not fix.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

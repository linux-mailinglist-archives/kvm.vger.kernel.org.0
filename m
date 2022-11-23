Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75F9E634C04
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 02:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235393AbiKWBHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 20:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234076AbiKWBHV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 20:07:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B864DDA4D1
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 17:07:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64691B81E4F
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 01:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16C33C43147
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 01:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669165638;
        bh=DCHo34lFwUJXd1HxDSXq2mLcBoc8T6ukKV//uHO9Qbo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=tHgtcCFbmN4x7PPAEWz+/shEOlJ/D3DprDtNpCMJM+8kT0vL/p9a7cNRvF3ptYHa3
         f1wKgH1sY06e5vMP5Uhdg8XJXc5fG/l8ba7Hmp6jZ7EBcyo2wKOzYN05cFRHP0SND9
         zE5cp8M5FTAndoYlNQhqMnNnkMLlQijyQwMDFKRga33ATZytcw4c1nc7sts8qSy7SJ
         c1N4C4k8DSWH2dMlRnMNlyBBsZk8FlRFtgSU9s4Um7yQJi/5DlyXaF10OFGNg4jJfY
         CI7GhBJlYaE5sdc9xkfXBf/vJMgHiP+tdMjsBKo2B7PJ3EIu/whokhuB77+SN9DHO9
         Gx7PzGJEDRvEA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 009BDC072A6; Wed, 23 Nov 2022 01:07:17 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216725] VMXON with CR0 bit 5 cleared should #GP, got '6'
Date:   Wed, 23 Nov 2022 01:07:17 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: lixiao.yang@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216725-28872-AVR9SEqHUw@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216725-28872@https.bugzilla.kernel.org/>
References: <bug-216725-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216725

--- Comment #2 from Yang Lixiao (lixiao.yang@intel.com) ---
(In reply to Yu Zhang from comment #1)
> Well, IIUC, the case was added by Sean
> (https://lore.kernel.org/all/20220608235238.3881916-1-seanjc@google.com/),
> to test his fix for nVMX
> (https://lore.kernel.org/lkml/Yz7zB7Lxt2DHa4nT@google.com/T/).=20
>=20
> But the KVM patch has not been queued in next branch yet. Maybe we can ju=
st
> wait...

Sure. Thanks for your notice!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

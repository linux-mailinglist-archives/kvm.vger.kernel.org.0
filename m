Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6C1682171
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 02:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjAaBiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 20:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjAaBiY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 20:38:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD3914E8C
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 17:38:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AEC861237
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 01:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA8F9C43446
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 01:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675129100;
        bh=qmWNYu3L8uDTH/NGrwCnQIi7apb8gsBMl/pqytpPSjg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=nYyXavptoYCeotEynoez2aNmqvlvZbbelXkK96CKVsFRg1VpKYtAz85KZT1X3RumE
         m+sY4yb2B1tAF9VhKRSfee2jnFm6kUl5+mmt/7/bs+wKK0gOZm7fc0FRrXxVFr2o/T
         PYoikFHG/+DxhWa+7Hm9ZnA8VgLgzHfFIaV6u9ZPxORuk3agV3Kong2kP2saqScx3m
         n9UN9P2J5SKFqtLyMiwVPMCCXCS5mEJZY35Ga+L7z+dYPkM4yt6W0Ymc9SMOxq1Y35
         DH+j+M9FwsbIBO3QQHs6BJfPfO9wpZuWwVz4vFoAQv2h0zPMHoOBJ6+kP5cQP8+NoV
         0xMsKMjTZHrmA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 88919C072A6; Tue, 31 Jan 2023 01:38:20 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216923] kvm-unit-test pmu_pebs is skipped on SPR
Date:   Tue, 31 Jan 2023 01:38:20 +0000
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
Message-ID: <bug-216923-28872-KMT3PKmDbX@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216923-28872@https.bugzilla.kernel.org/>
References: <bug-216923-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216923

--- Comment #2 from Yang Lixiao (lixiao.yang@intel.com) ---
(In reply to Like Xu from comment #1)
> The guest PEBS support for Intel SPR are not merged.
> 20221109082802.27543-1-likexu@tencent.com

Thanks for the information! I'll test it after it's merged.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

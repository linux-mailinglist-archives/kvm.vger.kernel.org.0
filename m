Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1BD674B2D4
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 16:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbjGGOLy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 10:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbjGGOLv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 10:11:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD2B2127
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 07:11:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39329616EB
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 14:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9C505C433CD
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 14:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688739096;
        bh=0A29NA7WQb+Li9Zxpbr1UY2rmzvoq99YaeWw85aYIrk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=VT/pOnEGN5sT04Cn90F/Gr2/qqAM+t3gNLtd+ytLziYAWVhI1RBbmVOU2hM6Ziob5
         enYJMckGkAbEfSlI90capbnwybqO114T1qLpsOobvuyp0lkFm6IP9VFHNEcOYRhIfC
         XajP70ZHAr7lLt4GjMAuRW/0DzBdVEfvhNFkQIYYKcGt6VitJWadrQ8nkghGTEQdOs
         ZBpmmtgFQrgkU9s6WuoijUYI4cYeFONxKyDeSWa+TGpVSZrTmfyeW94R2ca9yT1VCo
         gK4gbyAC/l8p8LZ9KDkFNhQt6y+ryD4xqk9o/0aFEY61OWFaB1OjPoo0yiwa6fArfM
         w6OM1jLOSqXAw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 8B385C53BD5; Fri,  7 Jul 2023 14:11:36 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217558] In KVM guest with VF of X710 NIC passthrough, the mac
 address of VF is inconsistent with it in host
Date:   Fri, 07 Jul 2023 14:11:36 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Drivers
X-Bugzilla-Component: Network
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: radoslawx.tyl@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217558-28872-3YwvJdOrQR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217558-28872@https.bugzilla.kernel.org/>
References: <bug-217558-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217558

--- Comment #10 from Radoslaw Tyl (radoslawx.tyl@intel.com) ---
Hello Fan,

I reproduced issue on the latest commit in dev-queue branch
https://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue.git/log/dri=
vers/net/ethernet/intel/iavf?h=3Ddev-queue

Could you please try to reproduce the issue with this patch in Attachments
added to above version kernel ?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

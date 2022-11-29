Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C20C63BD78
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 11:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbiK2KED (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 05:04:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbiK2KEC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 05:04:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0601B5B84E
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 02:04:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B04AAB811FE
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 10:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4AEBAC43144
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 10:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669716239;
        bh=AtipbcZecsGxnCfONfdw+d5Dv/1wlaSlP2v466Gko4g=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Y6hGMtqey7Ig1g3QZb0sETe3oHTZOzW9HG7OScWMSJHjHEhGTvLbK6uI+XUOMN4Eo
         bJy3SbovNoG/TS/5t7tWB/hBUXMQkRCmWRPgYVwXRxa5H7NOglq3Zg2mmEByUtUnVp
         5Hq8rgRNCYV0XJgH1Uxhd4hhhk3sM5LRJw4Kwa1f4pB069Cys98sbKVn4agYUUdxaR
         Gb/KLe3cyx/rFymNYb8p9Wwks+MviuxRjzeT+uTes4OfXpOe+NvkAHDYdZcggWpzkB
         ynGNbH90yjneQfbYSGVPKQDyxJfimjxOvi9Mw45rcJPaQPZnXRTjVE6ABB0hgQZba3
         co7JqW/bon76Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 35C39C05FD2; Tue, 29 Nov 2022 10:03:59 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date:   Tue, 29 Nov 2022 10:03:58 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: devzero@web.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-199727-28872-1AGDJ06Kk1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-199727-28872@https.bugzilla.kernel.org/>
References: <bug-199727-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D199727

--- Comment #19 from Roland Kletzing (devzero@web.de) ---
@chris

>To achieve the highest stability, are you setting all VMs to async IO
>Threads/IO Thread/Virtio SCSI Single, or just the machines with the=20
>highest load?

i have set ALL our virtual maschines to this

@gergely, any news on this? should we close this ticket ?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

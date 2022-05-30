Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4293553848F
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 17:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234795AbiE3PQu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 11:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237307AbiE3PQ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 11:16:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978AAEA899
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 07:15:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 420D7B80DC0
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 14:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED2D0C341C4
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 14:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653920154;
        bh=ItYdAs/+FyVkuI97z7m6VZXadduXb8EGthi3l9ZBM9U=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=SzBzIzsCFP98q/EyAIaeOm+zcCsVRVMcnwvMjiRSfL/YXcb4RwXYYiPnnNmTP8ZkC
         NPOLZbLf7xiu3MOpx1QjMXZkTR5SRKbcysdPtg4GrTcqnkhAeaKQCceLpAxEcHtlPe
         AQzwgXMr2KgQpibRElFb60PvTJ11fzwB+Tdr2rH03/zJAT5pGwJKPC2GsUy+PIf5Z+
         fjYccMqJr3/Mvry7dyWZzkaxreuYyV/1ryLdtbIl3sbOTol2nB/GkCIod65FwwWxa3
         pe/wYWlB/CyPtNrIkufmwwcRAOvpNvquOZ1Zyc8Xw7NcwvlT+mJhtLurCZ+53wfGKB
         PfolF3ACahs5Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id D6E6CCC13B5; Mon, 30 May 2022 14:15:53 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216017] KVM: problem virtualization from kernel 5.17.9/5.18
Date:   Mon, 30 May 2022 14:15:53 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: opw
X-Bugzilla-Severity: high
X-Bugzilla-Who: ne-vlezay80@yandex.ru
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216017-28872-dZzjil7clm@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216017-28872@https.bugzilla.kernel.org/>
References: <bug-216017-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216017

--- Comment #8 from Alexey Boldyrev (ne-vlezay80@yandex.ru) ---
Who has a source based kernel, you can apply this patch:
https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?h=3Dqueue&id=3D51c4=
476c00c110486a06aae7eb93dec622ed28ed

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

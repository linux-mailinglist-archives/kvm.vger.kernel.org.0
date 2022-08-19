Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDE0599524
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 08:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346732AbiHSGK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 02:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242643AbiHSGKg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 02:10:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2710BC6FF4
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 23:09:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DBD0615F4
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 06:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2905C4314B
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 06:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660889357;
        bh=xMKpEAnxIhJuvg7DQn+5Xj8OtDrqeBuEJmgLOpiuBZE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=iwLe5DjjGVv/vyc3euGdodG4LrzhRG+EX+pG1mj2z9ZDFWT7lKE/8a26nkrvFg0p2
         X3DQQ6YWYL+9MdgUwxqwNsv3lAjfEMGjxQMyMhPpuSDJxT8B4Ewy70TODdU0FH0f+B
         arlbWbQQXnI1RGYxcWBO0YnXAXafDAwfPD0IQnBbA8FgNk1/pzoZeqht4BW1CkVZ3G
         4CB9qPjqaupXo8f/yj2s7tCLZxLcP8RfT2TiLLbzw13yH2W0HQoG4ClpAgS8B/7sAi
         yWNEx5nrRjrbtq4ystRPrShV++IEkHSKXBM2Z8/ZXPZpkBeQ+o9r5T6gMqrxEkNhm2
         Wh6pT5YKya2sQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 962CAC433E9; Fri, 19 Aug 2022 06:09:17 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216364] [Kernel IBT][kvm] There was "Missing ENDBR" in kvm when
 syzkaller tests
Date:   Fri, 19 Aug 2022 06:09:17 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: pengfei.xu@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216364-28872-BzdobWRqSH@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216364-28872@https.bugzilla.kernel.org/>
References: <bug-216364-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216364

--- Comment #4 from xupengfe (pengfei.xu@intel.com) ---
This issue was fixed by the patches in below link:

https://lore.kernel.org/lkml/64365019-57dc-b449-8178-30428e09adf8@redhat.co=
m/



Verified it could not be reproduced with syzkaller test for more than 4 hou=
rs
on TGL-H and ADL-P.

Could close this issue.
Thanks!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A675371BC
	for <lists+kvm@lfdr.de>; Sun, 29 May 2022 18:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbiE2QKw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 May 2022 12:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiE2QKv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 May 2022 12:10:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29ACF5D5EB
        for <kvm@vger.kernel.org>; Sun, 29 May 2022 09:10:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6C1FB80AE8
        for <kvm@vger.kernel.org>; Sun, 29 May 2022 16:10:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7AF4DC3411E
        for <kvm@vger.kernel.org>; Sun, 29 May 2022 16:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653840646;
        bh=J7v6GDLkoDI1jBIFkoDOYsETuthMGVzTExZsc4N91W8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=JLfOEF/G2KOOtq7uZ7FTVEwxVJyu/Yg58sPvaAvj7U/AJ8g8Ed0vDJiSgNO/XxZgx
         xqbXDzidlpJCY7qTDXlL8u/Nl8yqFn/4hvyd+UVgunHGOMaFkQJW8tjMNv/OGz7jg8
         J66a+FVBT6tKk/oJrGHC+TG2tcNqRnVb6KReV+Kj0VgHqKS5N3E4UKJVuk2piJgm0M
         PSYPAXiiedU6HQRoEm0VgCTW8C9WMqB7WFooYEKiXazVpYBhbrKuFjxqHdhrxD20P6
         sB2uIumJmsNS7GGk1MBrclC5Y8oJSa65/+E4BQyrBaGlQKGBItYSLmnCI0xWvYXbfZ
         9Z26pHwGZRwIA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 60970CC13B2; Sun, 29 May 2022 16:10:46 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216017] KVM: problem virtualization from kernel 5.17.9
Date:   Sun, 29 May 2022 16:10:46 +0000
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
Message-ID: <bug-216017-28872-u05YM0VyUl@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216017-28872@https.bugzilla.kernel.org/>
References: <bug-216017-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216017

--- Comment #5 from Alexey Boldyrev (ne-vlezay80@yandex.ru) ---
Although I just had on the AMD FX-6300 virtual machines seemed to work under
the 5.18 kernel on the host. It looks like this is some kind of bug that on=
ly
appears on AMD Phenom X4.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03FF6D0D01
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 19:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbjC3RlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 13:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbjC3RlM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 13:41:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3F9E04A
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 10:41:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3114EB8299A
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 17:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4422C4339B
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 17:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680198068;
        bh=sw8QXVjZGAEga01lx15ffeNlyyaHIoNvTwmjGxM9SvM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=kfayiiev9JnzlwOgYY3Keb3JkawsAYEVCtk5uSg8T+uJOLeNDtFabcdrKVQNcn5FM
         g75i/GDM1gIZgJHjQT2NCeKWShAFr9sLUr0437dLvFO7DEqzkZ/Stgwu7LH35Mzfmi
         WSBbBScYBziLOW4CGODGry54GVHQrr6T0uN7tnixreESyjZS8eX5maHoTLeFKcUpHr
         2nU5St7EqDhYAqRo1BX4kghik5EW2HGmx+v7lImBqcQPLQ+oim3FANtFcsXPWdcBqo
         pR1a4T3aFrbMXlv/xkMa/gdGWoins0+65sYYb6mjvQXMRasiwfi0VD5SVKUaoZDRed
         jwk+bJQpNZeFQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id CD10AC43144; Thu, 30 Mar 2023 17:41:08 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217247] BUG: kernel NULL pointer dereference, address:
 000000000000000c / speculation_ctrl_update
Date:   Thu, 30 Mar 2023 17:41:08 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: hvtaifwkbgefbaei@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217247-28872-1VhyQZrs41@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217247-28872@https.bugzilla.kernel.org/>
References: <bug-217247-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217247

--- Comment #3 from Sami Farin (hvtaifwkbgefbaei@gmail.com) ---
Thanks. I am now running 6.1.22 with that patch applied.

The only difference in kernel messages 6.1.21 =E2=86=92 6.1.22:
 smpboot: SMP disabled
+smpboot: CPU0: AMD Ryzen 5 1600X Six-Core Processor (family: 0x17, model: =
0x1,
stepping: 0x1)

qemu works OK so far (only 30 minutes of usage so far)...

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

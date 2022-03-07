Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF92C4D0720
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 20:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241756AbiCGTCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 14:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233700AbiCGTCM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 14:02:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0446C6D3A0
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 11:01:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90F2361361
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 19:01:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE805C340FA
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 19:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646679677;
        bh=GmE9mZ/tfuxrPQ3D0g9n1GzZdr60PUHnpVCwen8m/vU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=enG81ZhGd6koBLqCCtsDj0t4aVXkIUp2C6fwbTxMqfTnnwdzyoSqy2ccAt29IHREE
         kknKER40ggUUCEO6dPqF/P6fRGR62QsHkv2yI7qLluqQG64Ntw6/ocJbBbp+4oRA3A
         C7pyAqhLIWS7+shxEXCA3m3IILuYXB2ewDuN5V/FivgLPxyXRCn+Lx/zorWMnIBo17
         gmekENiqw6FpelfE/GRHLIA4Mw3B4qKAKHCnbs8fX92oO+8On9/RuKDLrM31Dv98Hr
         +JxDcX3ziFHEqvXYKchXz/385BStsMRpHfk6m0TUOrSbfH+2vPSo5SrEnZ62W5LQ5A
         uUm2KQOU3Hfqg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id DC47BC05FF5; Mon,  7 Mar 2022 19:01:16 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date:   Mon, 07 Mar 2022 19:01:16 +0000
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
Message-ID: <bug-199727-28872-1ZPQXVEqS6@https.bugzilla.kernel.org/>
In-Reply-To: <bug-199727-28872@https.bugzilla.kernel.org/>
References: <bug-199727-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D199727

--- Comment #13 from Roland Kletzing (devzero@web.de) ---
hello, thanks - aio=3Dio_uring is no better, the only real way to get to a =
stable
system is virtio-scsi-single/iothreads=3D1/aio=3Dthreads

the question is why aio=3Dnative and io_uring has issues and threads has no=
t...

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

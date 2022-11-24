Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304926372E1
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 08:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiKXHUG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 02:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiKXHUE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 02:20:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07F2776DA
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 23:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C3DF62006
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 07:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D6287C433D6
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 07:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669275015;
        bh=JwJDabG1JjaUIAdcqZrB4AQC5z7R7Cvp36wMA40cUog=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=KvpXYW8DcBgIJQTKsdVXMfIuWG0H2D5RKTjgUq4zX9i9wndZSdm0AdEcnAWpuL0tP
         88cVNbK06OFN6cAH0tB3zxsw5Z+N4O2sGlRRliyu7USZSkrO4Cj8rHSJvpwPrZwsOa
         nEgF1W4RNaQaj1zNis1yGU3j9bxtvOmX4ZvH5F5+OBpJojJUZABkwMHSRjEkDrY5pA
         gY2iIJbplxuizHVq1aOOQOgp+01CySBo9eHirMWzZc2JfSs10hNOSqV/VKKmxmsqgU
         N7PbasDc+p7g6TV1kLk8AXhjklHnYPHzkAEra4zYZUyAwHpPkERMA7h353PLsW8W+f
         /WcI4YvPZLQUQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C0643C05FCF; Thu, 24 Nov 2022 07:30:15 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216737] Call trace happens on guest after running pt vmx tool
Date:   Thu, 24 Nov 2022 07:30:15 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-216737-28872-2b69VF6AwT@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216737-28872@https.bugzilla.kernel.org/>
References: <bug-216737-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216737

--- Comment #1 from Yang Lixiao (lixiao.yang@intel.com) ---
Created attachment 303285
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D303285&action=3Dedit
strace log when executing the pt vmx binary tool

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

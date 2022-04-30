Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F120515C88
	for <lists+kvm@lfdr.de>; Sat, 30 Apr 2022 13:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241310AbiD3Lut (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Apr 2022 07:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237002AbiD3Lus (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Apr 2022 07:50:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFCA68308
        for <kvm@vger.kernel.org>; Sat, 30 Apr 2022 04:47:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A29EEB81F26
        for <kvm@vger.kernel.org>; Sat, 30 Apr 2022 11:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 37B60C385AE
        for <kvm@vger.kernel.org>; Sat, 30 Apr 2022 11:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651319244;
        bh=7FNTa3MOP18zaJlIpFm1CSUn9PNt1V2gQu8VIz26sHc=;
        h=From:To:Subject:Date:From;
        b=fycBptcYX9uLb2hAyHcB7b0icrm047SZpgrLAfue3m97VpMvo+L1QLl92xHS+/fWE
         J21ZSSAFLWB68WbsDUKqwaZCjrN7mW2vTLeObv1hTGjtzXqM3kWYkGIRrpNqL1sNvf
         o+Q1TdI35Rw7UTqEyreFrOs2zeA28twMP9Xfh3DHNWZ0IC5QKlEEagTEGRqmOH6IPH
         4D8HpY8wGd8T4XPGv4zsQCZal2wCmLJHvyNXMBz5LNq6XX89trC6VQWts3HfyFtjn4
         EBlHFDFZv02Yd+foUjY1VdXkQ4qSu60ubhYZL9NM7iOuc1z9GM5HhyY4WN++ZFZQxj
         YhBHgXW2AwR8g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2138BC05FD0; Sat, 30 Apr 2022 11:47:24 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215923] New: Nested KVM Networking issue
Date:   Sat, 30 Apr 2022 11:47:23 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: mobilebackup95@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-215923-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215923

            Bug ID: 215923
           Summary: Nested KVM Networking issue
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.13.0.40
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: mobilebackup95@gmail.com
        Regression: No

Hi,=20

Inside openstack i have an instance of Ubuntu 20.04 and i have installed KV=
M (
using virt-manager ) to setup a Virtual Machine ... i have done that and i
created a VM of ubuntu 20.04 inside the Openstack Instance but there are
networking issue while i set the default parameter as setting up the VM ( i
mean the networking is as default to NAT ) , So when the VM is up and runni=
ng
the PING to 8.8.8.8 is available and also ping to google.com is also valid
which shows that the DNS is correctly working ... but there is not connecti=
vity
with packages while i do sudo apt update, it will not get any package update
and also the wget to google.com is shows that its connected to it but it wo=
nt
able to download!!! the same happen with curl to any other websites...


I'm confirming that the openstack instance has full access to the internet
including ping and wget , .... but the VM is not working correctly!

P.S. I have set the ip forwarding, Iptables , ... also disabled firewals but
notting changed!!


Would you please fix this ?

Thanks
Best regards

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

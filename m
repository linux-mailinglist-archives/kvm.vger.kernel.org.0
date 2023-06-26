Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7C9473D60F
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 04:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbjFZC40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jun 2023 22:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjFZC4Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jun 2023 22:56:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39785E3
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 19:56:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF12760C72
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 02:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1574EC433CB
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 02:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687748183;
        bh=uoS7UK7dE8tZMBHc1wGi6MJaGjX71LCOG1TlK+ZJmzY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=qD7VEts9DU2buWD0sHX8g/JiExwt59iovvQgoRagFpqTCEpjw0VwIhxufNwXgX20X
         pZ3xrOBQatQwndTGHD6Y6+RWI5UqdnIWXTEsLakfP4q3MHzjzq3e5ZUHa6YW26+Ie8
         g+tH4zmDpocbgoSsZlhuxiEDyQR+2rjqoeA/6UqQubhrZ3ssea50tDusyL0HQ7fSDa
         /Se2X9CsCbMlY7X/OzHyh3SfhsjY54oPklIUCxMoRuNwlycDPKVa4AzB5sPBEYwUnU
         pGR83plUXRlXYALqZayKykud5G1ljNCd2N2lu1rQCaWo6J23gYT2rNKGMi8RoNUvsy
         wGLCCofvCVGNw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id EDAD2C53BCD; Mon, 26 Jun 2023 02:56:22 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217574] kvm_intel loads only after suspend
Date:   Mon, 26 Jun 2023 02:56:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: chao.gao@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217574-28872-psYslDuH36@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217574-28872@https.bugzilla.kernel.org/>
References: <bug-217574-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217574

--- Comment #6 from Chao Gao (chao.gao@intel.com) ---
I found this: https://ubuntuforums.org/archive/index.php/t-2344602.html. it=
 was
reported on the same CPU E5-2696 v3.

Could you run below commands after bootup and suspension, and share the out=
put?

# rdmsr -a 0x48b |uniq
# cat /proc/cpuinfo |grep microcode |uniq

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

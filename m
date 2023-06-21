Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F8F738568
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 15:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbjFUNiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 09:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbjFUNiI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 09:38:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055AF170F
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 06:38:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D39461517
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 13:38:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D1C9CC433CC
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 13:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687354685;
        bh=B804r/CgUptuC7JWNsLM3PmMVdLJv8LfURaI4TI7UNc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=EnBXKxWeOUgg5siMZRj0Zjy6zFRYqQPowWlXWTQ1uvYzQJzQZ4tpQynlLiSouuRqw
         /mg42Mct4iT2wwh+YUQUJMZPGbsVKeL5orTPqKdwapBUA58ln9vCjVMfQKgI+TpTNB
         PsB34L2sPj26Vd7IBJZjuLpvs3/zmknvJ8tcAS0U8eoJTtyXhaypEsRN6hn3A2YD4h
         lx2uG0lJFTjdvmM0i3Ur7Cf2B63FVGfUvDjba5moztk2XFGD6h/jRxj4C/Xia58hMH
         XDFvdMWvudE83L4ncfpNukD+s59h2B48cTpVxJYHhQ94IjMbYuREZ+W2yzLFMxs8/+
         NRCOpSQprDAbw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id BEDD8C53BD3; Wed, 21 Jun 2023 13:38:05 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217558] In KVM guest with VF of X710 NIC passthrough, the mac
 address of VF is inconsistent with it in host
Date:   Wed, 21 Jun 2023 13:38:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: farrah.chen@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217558-28872-soRpr1WN3U@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217558-28872@https.bugzilla.kernel.org/>
References: <bug-217558-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217558

--- Comment #4 from Chen, Fan (farrah.chen@intel.com) ---
Add mateusz.palczewski@intel.com and mateusz.palczewski@intel.com

-----Original Message-----
From: bugzilla-daemon@kernel.org <bugzilla-daemon@kernel.org>=20
Sent: Wednesday, June 21, 2023 9:26 PM
To: kvm@vger.kernel.org
Subject: [Bug 217558] In KVM guest with VF of X710 NIC passthrough, the mac
address of VF is inconsistent with it in host

https://bugzilla.kernel.org/show_bug.cgi?id=3D217558

--- Comment #3 from Chen, Fan (farrah.chen@intel.com) --- We bisect and fou=
nd
the first bad commit, I don't understand if this commit is intend to do so?
Make the mac of VF in VM different from it in host? We think they use the s=
ame
mac is better for users, with the same mac, the mac of VF is known for us
before creating VM, then we can get IP address of the VF interface in VM fr=
om
mac without using vnc or other UI or serial port. How can we make the mac o=
f VF
keep the same in host and VM now?

commit ceb29474bbbc377e11be3a70589a0005305e4fc3
Author: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Date:   Thu Mar 30 10:00:22 2023 -0700

    i40e: Add support for VF to specify its primary MAC address

    Currently in the i40e driver there is no implementation of different
    MAC address handling depending on whether it is a legacy or primary.
    Introduce new checks for VF to be able to specify its primary MAC
    address based on the VIRTCHNL_ETHER_ADDR_PRIMARY type.

    Primary MAC address are treated differently compared to legacy
    ones in a scenario where:
    1. If a unicast MAC is being added and it's specified as
    VIRTCHNL_ETHER_ADDR_PRIMARY, then replace the current
    default_lan_addr.addr.
    2. If a unicast MAC is being deleted and it's type
    is specified as VIRTCHNL_ETHER_ADDR_PRIMARY, then zero the
    hw_lan_addr.addr.

Actually, we also tried to use "ip link set ens28f0 vf 0 mac <mac>" to fix a
mac for VF, it works in host, but we create VM with this VF passthrough, it=
 has
a high probability failed to assign the mac to VF in vm, and the interface
failed yo get IP either, error dmesg in VM:=20
[    3.037955] iavf 0000:00:04.0: Invalid MAC address 00:00:00:00:00:00, us=
ing
random
[    3.039523] iavf 0000:00:04.0: Multiqueue Enabled: Queue pair count =3D 4
[    3.040466] iavf 0000:00:04.0: MAC address: 3a:38:ca:66:f9:65
[    3.040980] iavf 0000:00:04.0: GRO is enabled
[    3.042240] iavf 0000:00:05.0: Multiqueue Enabled: Queue pair count =3D 4
[    3.043232] iavf 0000:00:05.0: MAC address: 36:91:96:9d:5d:05
[    3.043770] iavf 0000:00:05.0: GRO is enabled
[    3.044401] iavf 0000:00:04.0 ens4: renamed from eth0
[    3.049199] iavf 0000:00:05.0 ens5: renamed from eth1
[    3.072576] ppdev: user-space parallel port driver
[    3.094077] XFS (vda2): Mounting V5 Filesystem
8736b23e-ddde-4cca-9166-2623d2e57e5a
[    3.102245] XFS (vda2): Ending clean mount
[    3.550242] iavf 0000:00:04.0: Failed to add MAC filter, error IAVF_ERR_=
NVM
[    3.617176] iavf 0000:00:04.0 ens4: NIC Link is Up Speed is 10 Gbps Full
Duplex
[    3.618173] IPv6: ADDRCONF(NETDEV_CHANGE): ens4: link becomes ready
[    3.628189] iavf 0000:00:05.0 ens5: NIC Link is Up Speed is 10 Gbps Full
Duplex
[    3.629039] IPv6: ADDRCONF(NETDEV_CHANGE): ens5: link becomes ready

Fix this issue will be very helpful for us.

I failed to CC the primary author sylwesterx.dziedziuch@intel.com and
mateusz.palczewski@intel.com in bugliza.

Thanks,
Fan

--
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

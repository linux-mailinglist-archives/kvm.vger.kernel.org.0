Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E15D73BC7A
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 18:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbjFWQW4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 12:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbjFWQWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 12:22:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7409271B
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 09:22:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60CC561AB3
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 16:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BAD08C433CB
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 16:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687537367;
        bh=Y0UkbiUpfWq4ilLJjMeVhlAXOANOhuVOiVGoCebF70o=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=tNgYAH3PoGptl7RT64gZho1sR0IZdYYIgeYonzM4PfsGAr+9XsU3G1nE3DAQj6ZfM
         ugMbu7CzGrVjjRiQxE7cwnt/56hZwhKA99Ep7fODddtITCFIEoNXHShl46q8hYcCru
         9oMLtIq8tIzrCVHUA/X8l8mYw/AL/WpKN2z8zT0VMeu4HRc5o4b378efprGzHBkt6O
         UFLL+12zmG75jr496GbxTXF32ZZoG6E9koDHmP/qnCmyE/ActC7rKkDZH0MBVbozsG
         wOpv5lCuN4rHbYOxUyXA50LT5VPWCDQ/6REtq+BtTlv2FUdG0Jho9678hA2fYHNliW
         EMZ5dXB3IMG3Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 9B110C53BD3; Fri, 23 Jun 2023 16:22:47 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217574] kvm_intel loads only after suspend
Date:   Fri, 23 Jun 2023 16:22:47 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: drigoslkx@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217574-28872-erfsaQcRqO@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217574-28872@https.bugzilla.kernel.org/>
References: <bug-217574-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217574

--- Comment #3 from drigohighlander (drigoslkx@gmail.com) ---
Hi, here is the output after bootup:

bash-5.2# rdmsr -a 0x480
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012

after suspension:
bash-5.2# rdmsr -a 0x480
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
da040000000012
bash-5.2#=20

lscpu:
bash-5.2# lscpu
Architecture:            x86_64
  CPU op-mode(s):        32-bit, 64-bit
  Address sizes:         46 bits physical, 48 bits virtual
  Byte Order:            Little Endian
CPU(s):                  36
  On-line CPU(s) list:   0-35
Vendor ID:               GenuineIntel
  BIOS Vendor ID:        Intel
  Model name:            Intel(R) Xeon(R) CPU E5-2696 v3 @ 2.30GHz
    BIOS Model name:     Intel(R) Xeon(R) CPU E5-2696 v3 @ 2.30GHz  CPU @
2.3GHz
    BIOS CPU family:     179
    CPU family:          6
    Model:               63
    Thread(s) per core:  2
    Core(s) per socket:  18
    Socket(s):           1
    Stepping:            2
    CPU(s) scaling MHz:  64%
    CPU max MHz:         3800.0000
    CPU min MHz:         1200.0000
    BogoMIPS:            4589.05
    Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr p=
ge
mc
                         a cmov pat pse36 clflush dts acpi mmx fxsr sse sse=
2 ss=20
                         ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc
arc
                         h_perfmon pebs bts rep_good nopl xtopology nonstop=
_tsc=20
                         cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_c=
pl
vm
                         x smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid d=
ca
ss
                         e4_1 sse4_2 x2apic movbe popcnt aes xsave avx f16c
rdra
                         nd lahf_lm abm cpuid_fault epb invpcid_single pti
intel
                         _ppin tpr_shadow vnmi flexpriority ept vpid ept_ad
fsgs
                         base tsc_adjust bmi1 hle avx2 smep bmi2 erms invpc=
id
rt
                         m cqm xsaveopt cqm_llc cqm_occup_llc dtherm ida ar=
at
pl
                         n pts
Virtualization features:=20
  Virtualization:        VT-x
Caches (sum of all):=20=20=20=20=20
  L1d:                   576 KiB (18 instances)
  L1i:                   576 KiB (18 instances)
  L2:                    4.5 MiB (18 instances)
  L3:                    45 MiB (1 instance)
NUMA:=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
  NUMA node(s):          1
  NUMA node0 CPU(s):     0-35
Vulnerabilities:=20=20=20=20=20=20=20=20=20
  Itlb multihit:         KVM: Mitigation: VMX disabled
  L1tf:                  Mitigation; PTE Inversion; VMX conditional cache
flushe
                         s, SMT vulnerable
  Mds:                   Vulnerable: Clear CPU buffers attempted, no microc=
ode;=20
                         SMT vulnerable
  Meltdown:              Mitigation; PTI
  Mmio stale data:       Vulnerable: Clear CPU buffers attempted, no microc=
ode;=20
                         SMT vulnerable
  Retbleed:              Not affected
  Spec store bypass:     Vulnerable
  Spectre v1:            Mitigation; usercopy/swapgs barriers and __user
pointer
                          sanitization
  Spectre v2:            Mitigation; Retpolines, STIBP disabled, RSB fillin=
g,
PB
                         RSB-eIBRS Not affected
  Srbds:                 Not affected
  Tsx async abort:       Not affected
bash-5.2#

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

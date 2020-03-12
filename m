Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 531311830C8
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 14:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgCLNCy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 12 Mar 2020 09:02:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgCLNCx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 09:02:53 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206831] New: Intel AC 9260 wifi doesn't load in vm(sys-net
 under qubes os)
Date:   Thu, 12 Mar 2020 13:02:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: lipan.ovidiu@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-206831-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206831

            Bug ID: 206831
           Summary: Intel AC 9260 wifi doesn't load in vm(sys-net under
                    qubes os)
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.6-rc4
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: lipan.ovidiu@gmail.com
        Regression: No

I recently updated my qubes r4.1 fc31 to kernel 5.6-rc4(due lack of Nvidia rtx
2080 support under the old kernel). Now the NV card works properly but I've
lost the wifi connection under sys-net vm. I must mention it used to works
perfectly on the older kernel version(actually any version up to 5.6, including
5.5.9 freshly compiled). I also updated the sys-net vm kernel verision to
5.6-rc4 but I still have the issue. Here is the output of dmseg of sys-net:

[    7.332438] iwlwifi 0000:00:06.0: Failed to load firmware chunk!
[    7.332458] iwlwifi 0000:00:06.0: iwlwifi transaction failed, dumping
registers
[    7.332476] iwlwifi 0000:00:06.0: iwlwifi device config registers:
[    7.338624] iwlwifi 0000:00:06.0: 00000000: 25268086 00180406 02800029
00000000 f2010004 00000000 00000000 00000000
[    7.338651] iwlwifi 0000:00:06.0: 00000020: 00000000 00000000 00000000
15501a56 00000000 000000c8 00000000 0000010b
[    7.338677] iwlwifi 0000:00:06.0: 00000040: 00020010 00008ec0 00102810
0045e812 10120000 00000000 00000000 00000000
[    7.338701] iwlwifi 0000:00:06.0: 00000060: 00000000 00080812 00000000
00000000 00000002 00000000 00000000 00000000
[    7.338725] iwlwifi 0000:00:06.0: 00000080: 000f0011 00002000 00003000
00000000 00000000 00000000 00000000 00000000
[    7.338749] iwlwifi 0000:00:06.0: 000000a0: 00000000 00000000 00000000
00000000 00000000 00000000 00000000 00000000
[    7.338773] iwlwifi 0000:00:06.0: 000000c0: 00000000 00000000 0023d001
0d000008 00804005 fee97000 00000000 00004300
[    7.338797] iwlwifi 0000:00:06.0: 000000e0: 00000000 00000000 00000000
00000000 00000000 00000000 00000000 00000000
[    7.338822] iwlwifi 0000:00:06.0: Read failed at 0x100
[    7.338836] iwlwifi 0000:00:06.0: Could not load the [0] uCode section
[    7.338860] iwlwifi 0000:00:06.0: Failed to start INIT ucode: -110
[    7.338877] iwlwifi 0000:00:06.0: Collecting data: trigger 16 fired.
[    7.588505] iwlwifi 0000:00:06.0: Not valid error log pointer 0x00000000 for
Init uCode
[    7.588537] iwlwifi 0000:00:06.0: Fseq Registers:
[    7.588557] iwlwifi 0000:00:06.0: 0x66C2C9EE | FSEQ_ERROR_CODE
[    7.588579] iwlwifi 0000:00:06.0: 0x00000000 | FSEQ_TOP_INIT_VERSION
[    7.588602] iwlwifi 0000:00:06.0: 0x815790C8 | FSEQ_CNVIO_INIT_VERSION
[    7.588624] iwlwifi 0000:00:06.0: 0x0000A371 | FSEQ_OTP_VERSION
[    7.588645] iwlwifi 0000:00:06.0: 0xF133AC29 | FSEQ_TOP_CONTENT_VERSION
[    7.588668] iwlwifi 0000:00:06.0: 0xAFFDD78E | FSEQ_ALIVE_TOKEN
[    7.588689] iwlwifi 0000:00:06.0: 0xB1F3B688 | FSEQ_CNVI_ID
[    7.588709] iwlwifi 0000:00:06.0: 0x6F9FEAC3 | FSEQ_CNVR_ID
[    7.588729] iwlwifi 0000:00:06.0: 0x01000200 | CNVI_AUX_MISC_CHIP
[    7.588753] iwlwifi 0000:00:06.0: 0x01300202 | CNVR_AUX_MISC_CHIP
[    7.588778] iwlwifi 0000:00:06.0: 0x0000485B |
CNVR_SCU_SD_REGS_SD_REG_DIG_DCDC_VTRIM
[    7.588856] iwlwifi 0000:00:06.0: 0x0BADCAFE |
CNVR_SCU_SD_REGS_SD_REG_ACTIVE_VDIG_MIRROR
[    7.588929] iwlwifi 0000:00:06.0: Firmware not running - cannot dump error
[    7.601717] iwlwifi 0000:00:06.0: Failed to run INIT ucode: -110


Any help will be highly appreciated.

Thank you

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

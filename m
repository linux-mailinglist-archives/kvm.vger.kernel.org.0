Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 525C57CF09C
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 09:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbjJSHCa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 03:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbjJSHC1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 03:02:27 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D79183
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 00:02:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D473C433C7
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 07:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697698944;
        bh=+HjpsRyqe/ieStRS3LlNy4DWdaHvgJqWEBaxS9kS+5Y=;
        h=From:To:Subject:Date:From;
        b=ukCdPK5GZbc7OLKnD4Anx6wg5UD3NNDNDWt1682kwlzOaLr4uHreUsxEAs8I9PixU
         e2hKHmsB9LcuxH8mRjuS0GG8rJz735edaCS9JzRta+Oo2eZAq65ip5X1bQiNZSZsO5
         un1Z9xWqJuDubODdcxkZeYosO+0k38YMAA/C7OL3GsPl5hHG63T7fikP0zLuGQ2tpu
         H4k9L8+07agVDCI7nMBseIQmbXpd9sF0AsVCV5kvMbqEPEJzvQBo0xurEHPFaM+wr2
         wuwBbzJ5SmC3Aw4gWd6ktlnVbf/oIjlmrLINb3L+0evu5kDNp7jkZ3WalMTEgPG8g6
         GQzTVlQUDUgWg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 73744C53BD0; Thu, 19 Oct 2023 07:02:24 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 218026] New: Compile failure in kvm-unit-tests about "ld:
 Error: unable to disambiguate: -no-pie"
Date:   Thu, 19 Oct 2023 07:02:24 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ruifeng.gao@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-218026-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D218026

            Bug ID: 218026
           Summary: Compile failure in kvm-unit-tests about "ld: Error:
                    unable to disambiguate: -no-pie"
           Product: Virtualization
           Version: unspecified
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: high
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: ruifeng.gao@intel.com
        Regression: No

Environment:
CPU Architecture: x86_64
Host OS: CentOS Stream 9
binutils: binutils-2.36.1-4.el9.x86_64
kvm-unit-tests source: https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
Branch: master
Commit: 09e8c119b4cd7b615ea0ece16c92c79054dfb38d

Bug Detailed Description:
kvm-unit-tests can not be compiled due to "ld: Error: unable to disambiguat=
e:
-no-pie".=20
Checked ld version:
[root@emr-2s7 kvm-unit-tests]# ld --version
GNU ld version 2.36.1-4.el9
With older version (i.e., GNU ld version 2.35.2-39.el9), it can be compiled
well. Initially suspected, it should be a compiling issue.

Reproducing Steps:
git clone https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
cd kvm-unit-tests
./configure
make standalone

Actual Result:
...
rotector    -Wno-frame-address   -fno-pic  -Wclobbered=20
-Wunused-but-set-parameter  -Wmissing-parameter-type  -Wold-style-declarati=
on
-Woverride-init -Wmissing-prototypes -Wstrict-prototypes -std=3Dgnu99
-ffreestanding -I /root/grf/kvm-unit-tests/lib -I
/root/grf/kvm-unit-tests/lib/x86 -I lib   -c -o x86/vmexit.o x86/vmexit.c
gcc -mno-red-zone -mno-sse -mno-sse2  -fcf-protection=3Dfull -m64 -O1 -g -M=
MD -MP
-MF x86/.cstart64.d -fno-strict-aliasing -fno-common -Wall -Wwrite-strings
-Wempty-body -Wuninitialized -Wignored-qualifiers -Wno-missing-braces -Werr=
or=20
-fno-omit-frame-pointer  -fno-stack-protector    -Wno-frame-address   -fno-=
pic=20
-Wclobbered  -Wunused-but-set-parameter  -Wmissing-parameter-type=20
-Wold-style-declaration -Woverride-init -Wmissing-prototypes
-Wstrict-prototypes -std=3Dgnu99 -ffreestanding -I /root/grf/kvm-unit-tests=
/lib
-I /root/grf/kvm-unit-tests/lib/x86 -I lib -c -nostdlib -o x86/cstart64.o
x86/cstart64.S
ld -nostdlib  -no-pie -z noexecstack -m elf_x86_64 -T
/root/grf/kvm-unit-tests/x86/flat.lds -o x86/vmexit.elf \
        x86/vmexit.o x86/cstart64.o lib/libcflat.a
ld: Error: unable to disambiguate: -no-pie (did you mean --no-pie ?)
make: *** [/root/grf/kvm-unit-tests/x86/Makefile.common:70: x86/vmexit.elf]
Error 1


Expected Result:
The kvm-unit-tests suite should be compiled successfully.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

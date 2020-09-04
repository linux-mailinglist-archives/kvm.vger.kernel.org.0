Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B52F925E3E0
	for <lists+kvm@lfdr.de>; Sat,  5 Sep 2020 00:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbgIDWrQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 4 Sep 2020 18:47:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728116AbgIDWrM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 18:47:12 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209155] KVM Linux guest with more than 1 CPU panics after
 commit 5a9f54435a48... on old CPU (Phenom x4)
Date:   Fri, 04 Sep 2020 22:47:11 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kronenpj@kronenpj.dyndns.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209155-28872-as4Q0g3YtC@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209155-28872@https.bugzilla.kernel.org/>
References: <bug-209155-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209155

--- Comment #3 from Paul K. (kronenpj@kronenpj.dyndns.org) ---
$ git bisect log
# bad: [bcf876870b95592b52519ed4aafcf9d95999bc9c] Linux 5.8
git bisect start 'v5.8'
# good: [3d77e6a8804abcc0504c904bd6e5cdf3a5cf8162] Linux 5.7
git bisect good 3d77e6a8804abcc0504c904bd6e5cdf3a5cf8162
# bad: [694b5a5d313f3997764b67d52bab66ec7e59e714] Merge tag 'arm-soc-5.8' of
git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc
git bisect bad 694b5a5d313f3997764b67d52bab66ec7e59e714
# bad: [694b5a5d313f3997764b67d52bab66ec7e59e714] Merge tag 'arm-soc-5.8' of
git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc
git bisect bad 694b5a5d313f3997764b67d52bab66ec7e59e714
# bad: [694b5a5d313f3997764b67d52bab66ec7e59e714] Merge tag 'arm-soc-5.8' of
git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc
git bisect bad 694b5a5d313f3997764b67d52bab66ec7e59e714
# bad: [694b5a5d313f3997764b67d52bab66ec7e59e714] Merge tag 'arm-soc-5.8' of
git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc
git bisect bad 694b5a5d313f3997764b67d52bab66ec7e59e714
# bad: [694b5a5d313f3997764b67d52bab66ec7e59e714] Merge tag 'arm-soc-5.8' of
git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc
git bisect bad 694b5a5d313f3997764b67d52bab66ec7e59e714
# bad: [2e63f6ce7ed2c4ff83ba30ad9ccad422289a6c63] Merge branch 'uaccess.comedi'
of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
git bisect bad 2e63f6ce7ed2c4ff83ba30ad9ccad422289a6c63
# good: [cfa3b8068b09f25037146bfd5eed041b78878bee] Merge tag 'for-linus-hmm' of
git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma
git bisect good cfa3b8068b09f25037146bfd5eed041b78878bee
# good: [c41219fda6e04255c44d37fd2c0d898c1c46abf1] Merge tag
'drm-intel-next-fixes-2020-05-20' of
git://anongit.freedesktop.org/drm/drm-intel into drm-next
git bisect good c41219fda6e04255c44d37fd2c0d898c1c46abf1
# good: [f3cdc8ae116e27d84e1f33c7a2995960cebb73ac] Merge tag 'for-5.8-tag' of
git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux
git bisect good f3cdc8ae116e27d84e1f33c7a2995960cebb73ac
# good: [f1e455352b6f503532eb3637d0a6d991895e7856] Merge tag 'kgdb-5.8-rc1' of
git://git.kernel.org/pub/scm/linux/kernel/git/danielt/linux
git bisect good f1e455352b6f503532eb3637d0a6d991895e7856
# bad: [cb953129bfe5c0f2da835a0469930873fb7e71df] kvm: add halt-polling cpu
usage stats
git bisect bad cb953129bfe5c0f2da835a0469930873fb7e71df
# good: [3754afe7cf7cc3693a9c9ff795e9bd97175ca639] tools/kvm_stat: Add command
line switch '-L' to log to file
git bisect good 3754afe7cf7cc3693a9c9ff795e9bd97175ca639
# good: [c4e115f08c08cb9f3b70247b42323e40b9afd1fd] kvm/eventfd: remove unneeded
conversion to bool
git bisect good c4e115f08c08cb9f3b70247b42323e40b9afd1fd
# good: [5b494aea13fe9ec67365510c0d75835428cbb303] KVM: No need to retry for
hva_to_pfn_remapped()
git bisect good 5b494aea13fe9ec67365510c0d75835428cbb303
# bad: [379a3c8ee44440d5afa505230ed8cb5b0d0e314b] KVM: VMX: Optimize
posted-interrupt delivery for timer fastpath
git bisect bad 379a3c8ee44440d5afa505230ed8cb5b0d0e314b
# good: [9e826feb8f114964cbdce026340b6cb9bde68a18] KVM: nVMX: Drop superfluous
VMREAD of vmcs02.GUEST_SYSENTER_*
git bisect good 9e826feb8f114964cbdce026340b6cb9bde68a18
# good: [2c4c41325540cf3abb12aef142c0e550f6afeffc] KVM: x86: Print symbolic
names of VMX VM-Exit flags in traces
git bisect good 2c4c41325540cf3abb12aef142c0e550f6afeffc
# bad: [404d5d7bff0d419fe11c7eaebca9ec8f25258f95] KVM: X86: Introduce more
exit_fastpath_completion enum values
git bisect bad 404d5d7bff0d419fe11c7eaebca9ec8f25258f95
# good: [5a9f54435a488f8a1153efd36cccee3e7e0fc28b] KVM: X86: Introduce
kvm_vcpu_exit_request() helper
git bisect good 5a9f54435a488f8a1153efd36cccee3e7e0fc28b
# first bad commit: [404d5d7bff0d419fe11c7eaebca9ec8f25258f95] KVM: X86:
Introduce more exit_fastpath_completion enum values

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 106A3EFD1B
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 13:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388271AbfKEMXi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 5 Nov 2019 07:23:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:51912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388221AbfKEMXi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 07:23:38 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 205441] New: Enabling KVM causes any Linux VM reboot on kernel
 boot
Date:   Tue, 05 Nov 2019 12:21:49 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: hawk@tld-linux.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-205441-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205441

            Bug ID: 205441
           Summary: Enabling KVM causes any Linux VM reboot on kernel boot
           Product: Virtualization
           Version: unspecified
    Kernel Version: 4.19.81
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: hawk@tld-linux.org
        Regression: No

Created attachment 285801
  --> https://bugzilla.kernel.org/attachment.cgi?id=285801&action=edit
Kernel .config file

I'm unable to run any Linux VM on host running kernel 4.19.81. VM starts fine,
boot loader works fine, both kernel and initramfs images are loaded and when
kernel boot should occur, VM simply reboots itself. This happens only when
-enable-kvm is added on command line. Disabling KVM makes it working again (but
slow).

Problem appears only on one of my two physical hosts, the one with Intel Core 2
Quad 9500 CPU. KVM works fine on Intel Xeon E3-1246 CPU (same packages, same
versions, same configs). I tried different guest kernel versions and systems
and VM will always reboot when trying to boot kernel.

If I downgrade to 4.19.73 KVM is working fine again. I may test kernels from
4.19.74 to 4.19.79 to see which one introduces the problem, but it will take
some time as I must build these packages manually.

I'm starting my test VM with below command, but started via libvirt have same
problem. 

qemu-system-x86_64 -m 2048M -smp 1 -k en-us -drive
file=/tmp/cri-tld-x64-20190916.iso,media=cdrom,format=raw,if=ide -cpu kvm64
-vnc 127.0.0.1:0 -enable-kvm

I tried changing -cpu parameter including host passthrough option, but problems
persists.

Kernel version (distribution package):

Linux version 4.19.81-4.19-vanilla-1 (builder@x64) (gcc version 9.2.0 20190830
(release) (TLD-Linux)) #1 SMP Wed Oct 30 20:56:24 CET 2019

Kernel config is attached.

CPU on host where problem exists (limited output to single core)

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Core(TM)2 Quad CPU    Q9500  @ 2.83GHz
stepping        : 10
microcode       : 0xa0b
cpu MHz         : 2015.344
cache size      : 3072 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 4
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
constant_tsc arch_perfmon pebs bts rep_good nopl cpuid aperfmperf pni dtes64
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm pti
tpr_shadow vnmi flexpriority dtherm
bugs            : cpu_meltdown spectre_v1 spectre_v2 spec_store_bypass l1tf mds
swapgs
bogomips        : 5652.52
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

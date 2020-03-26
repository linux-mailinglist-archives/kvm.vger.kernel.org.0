Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 627BA193CF2
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 11:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgCZKcZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 26 Mar 2020 06:32:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:59286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726590AbgCZKcY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 06:32:24 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206977] New: AMD gpu Crash after power or reboot the VM
Date:   Thu, 26 Mar 2020 10:32:23 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: Hans.Wurst424@gmx.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-206977-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206977

            Bug ID: 206977
           Summary: AMD gpu Crash after power or reboot the VM
           Product: Virtualization
           Version: unspecified
    Kernel Version: linux-lts 5.4.26 and 5.5.11 and 5.6.rc7 mainline krnel
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: Hans.Wurst424@gmx.de
        Regression: No

Created attachment 288075
  --> https://bugzilla.kernel.org/attachment.cgi?id=288075&action=edit
AMD gpu Crash after power or reboot the VM logs

Hartdware
CPU:
AMD RYZEN 1700X
MAIBOARD:
Asrock X370 Taichi
bios:
2.40 last bios version of cpu
GPU1:
amd radeon r7 260x it works good the rest.
GPU2:
SAPPHIRE Nitro Plus RX VEGA 64 it works not good the rest with the vfio-pci
module.



I have a Problem with a corrupt Header on my AMD RX VEGA 64 Card after shutdown
the VM.
The GPU is with vfio in Qemu VM.
arch linux kernel 5.5.10 and linux-lts 5.4. and linxu kernel 5.6rx7 make this
BUG on my KVM server.
I downgrade the kernel to 5.3.5 an the corrupt Header is fixed and the rest
with the vfio-pci module work.
I have mesa beta 20.0.1 and archlinux 19.3.4-2 tested. and the BUG is not
fixed.
see the log lspci -v > lspciv1.log for the 5.3.5 kernel loading in VM after
shutdown.
see the log lspci -v > lspci_header_corupt.log for the 5.4.26 or 5.5.10 kernel
loading in VM after shutdown.
see the dmesg >vfio_5.3.5.log for the 5.3.5 kernel loading in VM after
shutdown.
see the log dmesg > vfio_5.4.26.log for the 5.4.26 or 5.5.10 kernel loading in
VM after shutdown.

the gpu corrupt header has a gpu then not colling any more and fan rpm of 0.
the gpu 30min - 40min after crash is the fan of 100% and pc must remove for
engine and waiting 15min gpu coling down.



Additional info:
* linux linux-lts mesa 19.3.4-2
* config and/or log files etc.
* link to upstream bug report, if any

Steps to reproduce:
I starting a qemu q35 or qemu std VM with the gpu per vfio deice add and
shoutdown the vm and the Header is corrupt.



I post it in archlinux bug reporter 
https://bugs.archlinux.org/task/65956


server log after shoutdown VM.
lspci -v >lspci_header_corupt.log
--
11:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Vega
10 XL/XT [Radeon RX Vega 56/64] (rev ff) (prog-if ff)
        !!! Unknown header type 7f
        Kernel driver in use: vfio-pci
        Kernel modules: amdgpu

11:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Vega 10 HDMI Audio
[Radeon Vega 56/64] (rev ff) (prog-if ff)
        !!! Unknown header type 7f
        Kernel driver in use: vfio-pci
        Kernel modules: snd_hda_intel
--
server 
grub boot parmter
iommu=pt amd_iommu=on vfio-pci.ids=1002:687f,1002:aaf8,1022:145c
rd.driver.pre=vfio-pci nopti

VM WIDNWOS 7 work with the AMD RX veag 64 card good.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

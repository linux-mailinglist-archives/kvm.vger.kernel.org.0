Return-Path: <kvm+bounces-4553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C6D9814382
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 09:23:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E36821F24FCE
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 08:23:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4B7A134A2;
	Fri, 15 Dec 2023 08:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cZu8S8ow"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAD812E49
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 08:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 97B5BC433C9
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 08:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702628626;
	bh=GQkn1lqrVgef3txUYcoRewUO00x6r5u1ulH+JweLScw=;
	h=From:To:Subject:Date:From;
	b=cZu8S8owXQF/mi2SWxQHryoeDwtzXWwri+TVwfMZh2Iaw8Br9v8AjhAIbftTQsc2F
	 2bseMByPaRbdoN2ft5ybki3Sw5XCSHvlcIsjQQKw+zIigXHH+e5bDvpqyubXqfL2Ok
	 /jRSX0U2Ae7SykcCB4v7LgyCKFr9Kyr/25zu+M30rdw3cN602Gw4xTAvrpQKPJpOji
	 wHJy6/B0jZEmvjIwZcA+TLXAVxPI5GMkxOxlo4tj5iup+1I86L70YSdLXC+8noXu28
	 3rswo1iSZQcQlOL0ek7vOToFVuf4aWswe3EdHSF4Q4HUwSLuCWB1KwvMF2vqDAVLe4
	 IkRSRVY0wWnHw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 8453CC53BD1; Fri, 15 Dec 2023 08:23:46 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218267] New: [Sapphire Rapids][Upstream]Boot up multiple
 Windows VMs hang
Date: Fri, 15 Dec 2023 08:23:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: qiangx.guo@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression attachments.created
Message-ID: <bug-218267-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D218267

            Bug ID: 218267
           Summary: [Sapphire Rapids][Upstream]Boot up multiple Windows
                    VMs hang
           Product: Virtualization
           Version: unspecified
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: high
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: qiangx.guo@intel.com
        Regression: No

Created attachment 305601
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D305601&action=3Dedit
Boot up 8 Windows VM script

System Environment
=3D=3D=3D=3D=3D=3D=3D

Platform: Sapphire Rapids Platform

Host OS: CentOS Stream 9

Kernel:6.7.0-rc1 (commit:8ed26ab8d59111c2f7b86d200d1eb97d2a458fd1)
Qemu: QEMU emulator version 8.1.94 (v8.2.0-rc4)
(commit:039afc5ef7367fbc8fb475580c291c2655e856cb)

Host Kernel cmdline:BOOT_IMAGE=3D/kvm-vmlinuz root=3D/dev/mapper/cs_spr--2s=
2-root
ro crashkernel=3Dauto console=3Dtty0 console=3DttyS0,115200,8n1 3 intel_iom=
mu=3Don
disable_mtrr_cleanup

Bug detailed description
=3D=3D=3D=3D=3D=3D=3D
We boot up 8 Windows VMs (total vCPUs > pCPUs) in host, random run applicat=
ion
on each VM such as WPS editing etc, and wait for a moment, then Some of the
Windows Guest hang and console reports "KVM internal error. Suberror: 3".

Tips:We add "-cpu
host,host-cache-info=3Don,migratable=3Don,hv-time=3Don,hv-relaxed=3Don,hv-v=
apic=3Don,hv-spinlocks=3D0x1fff"
in qemu parameters and boot up VMs.Some of VMs easy to hang.


Reproduce Steps
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
1.Boot up 8 Windows VMs in Host:

for ((i=3D1;i<=3D8;i++));do
qemu-img create -b /home/guoqiang/win2k16_vdi_local.qcow2 -F qcow2 -f qcow2
/home/guoqiang/win2016$i.qcow2

sleep 1

qemu-system-x86_64 -accel kvm -cpu
host,host-cache-info=3Don,migratable=3Don,hv-time=3Don,hv-relaxed=3Don,hv-v=
apic=3Don,hv-spinlocks=3D0x1fff
-smp 30 -drive file=3D/home/guoqiang/win2016$i.qcow2,if=3Dnone,id=3Dvirtio-=
disk0
-device virtio-blk-pci,drive=3Dvirtio-disk0,bootindex=3D0 -m 4096 -daemoniz=
e -vnc
:$i -device virtio-net-pci,netdev=3Dnic0 -netdev
tap,id=3Dnic0,br=3Dvirbr0,helper=3D/usr/local/libexec/qemu-bridge-helper,vh=
ost=3Don

sleep 5

done

2.Wait a monent and VMs hang.

Host error log:
KVM internal error. Suberror: 3

extra data[0]: 0x000000008000002f

extra data[1]: 0x0000000000000020

extra data[2]: 0x0000000000000d83

extra data[3]: 0x0000000000000038

RAX=3D0000000000000000 RBX=3D0000000000000000 RCX=3D0000000040000070
RDX=3D0000000000000000

RSI=3D0000000000000000 RDI=3Dffffc58dcf552010 RBP=3Dfffff801ed48e100
RSP=3Dfffff801ed48e060

R8 =3D00000000ffffffff R9 =3D0000000000000000 R10=3D00000000ffffffff
R11=3D0000000000000000

R12=3D000000133fd128fc R13=3D0000000000000046 R14=3D0000000000000000
R15=3D0000000000000000

RIP=3Dfffff801eb94fd7c RFL=3D00000046 [---Z-P-] CPL=3D0 II=3D0 A20=3D1 SMM=
=3D0 HLT=3D0

ES =3D002b 0000000000000000 ffffffff 00c0f300 DPL=3D3 DS [-WA]

CS =3D0010 0000000000000000 00000000 00209b00 DPL=3D0 CS64 [-RA]

SS =3D0018 0000000000000000 ffffffff 00c09300 DPL=3D0 DS [-WA]

DS =3D002b 0000000000000000 ffffffff 00c0f300 DPL=3D3 DS [-WA]

FS =3D0053 000000000059b000 00003c00 0040f300 DPL=3D3 DS [-WA]

GS =3D002b fffff801ebb3f000 ffffffff 00c0f300 DPL=3D3 DS [-WA]

LDT=3D0000 0000000000000000 ffffffff 00c00000

TR =3D0040 fffff801ed486070 00000067 00008b00 DPL=3D0 TSS64-busy

GDT=3D fffff801ed485000 0000006f

IDT=3D fffff801ed485070 00000fff

CR0=3D80050031 CR2=3D0000000000000030 CR3=3D00000000001aa000 CR4=3D001506f8

DR0=3D0000000000000000 DR1=3D0000000000000000 DR2=3D0000000000000000
DR3=3D0000000000000000

DR6=3D00000000ffff0ff0 DR7=3D0000000000000400

EFER=3D0000000000000d01

Code=3D25 88 61 00 00 b9 70 00 00 40 0f ba 32 00 72 06 33 c0 8b d0 <0f> 30 =
5a 58
59 c3 cc cc cc cc cc cc 0f 1f 84 00 00 00 00 00 48 81 ec 38 01 00 00 48 8d =
84

KVM internal error. Suberror: 3

extra data[0]: 0x000000008000002f

extra data[1]: 0x0000000000000020

extra data[2]: 0x0000000000000d81

extra data[3]: 0x00000000000000a2

RAX=3D0000000000000000 RBX=3D0000000000000000 RCX=3D0000000040000070
RDX=3D0000000000000000

RSI=3D0000000000000000 RDI=3Dffffdf86659d07b0 RBP=3Dffff96806225b100
RSP=3Dffff96806225b060

R8 =3D00000000ffffffff R9 =3D0000000000000000 R10=3D00000000ffffffff
R11=3D0000000000000000

R12=3D00000013e153ce49 R13=3D0000000000000046 R14=3D0000000000000000
R15=3D0000000000000000

RIP=3Dfffff8001f1ddd7c RFL=3D00000046 [---Z-P-] CPL=3D0 II=3D0 A20=3D1 SMM=
=3D0 HLT=3D0

ES =3D002b 0000000000000000 ffffffff 00c0f300 DPL=3D3 DS [-WA]

CS =3D0010 0000000000000000 00000000 00209b00 DPL=3D0 CS64 [-RA]

SS =3D0018 0000000000000000 ffffffff 00c09300 DPL=3D0 DS [-WA]

DS =3D002b 0000000000000000 ffffffff 00c0f300 DPL=3D3 DS [-WA]

FS =3D0053 0000000000604000 00007c00 0040f300 DPL=3D3 DS [-WA]

GS =3D002b ffff968062230000 ffffffff 00c0f300 DPL=3D3 DS [-WA]

LDT=3D0000 0000000000000000 ffffffff 00c00000

TR =3D0040 ffff968062236ac0 00000067 00008b00 DPL=3D0 TSS64-busy

GDT=3D ffff96806223db80 0000006f

IDT=3D ffff96806223dbf0 00000fff

CR0=3D80050031 CR2=3D0000000000000030 CR3=3D00000000001aa000 CR4=3D001506f8

DR0=3D0000000000000000 DR1=3D0000000000000000 DR2=3D0000000000000000
DR3=3D0000000000000000

DR6=3D00000000fffe07f0 DR7=3D0000000000000400

EFER=3D0000000000000d01

Code=3D25 88 61 00 00 b9 70 00 00 40 0f ba 32 00 72 06 33 c0 8b d0 <0f> 30 =
5a 58
59 c3 cc cc cc cc cc cc 0f 1f 84 00 00 00 00 00 48 81 ec 38 01 00 00 48 8d =
84

KVM internal error. Suberror: 3

extra data[0]: 0x000000008000002f

extra data[1]: 0x0000000000000020

extra data[2]: 0x0000000000000f82

extra data[3]: 0x000000000000004b

KVM internal error. Suberror: 3

extra data[0]: 0x000000008000002f

extra data[1]: 0x0000000000000020

extra data[2]: 0x0000000000000f82

extra data[3]: 0x000000000000004b

RAX=3D0000000000000000 RBX=3D0000000000000000 RCX=3D0000000040000070
RDX=3D0000000000000000

RSI=3D0000000000000000 RDI=3Dffffe7885a932010 RBP=3Dfffff802a5a8e100
RSP=3Dfffff802a5a8e060

R8 =3D00000000ffffffff R9 =3D0000000000000000 R10=3D00000000ffffffff
R11=3D0000000000000000

R12=3D000000144b0a7258 R13=3D0000000000000046 R14=3D0000000000000000
R15=3D0000000000000000

RIP=3Dfffff802a3f60d7c RFL=3D00000046 [---Z-P-] CPL=3D0 II=3D0 A20=3D1 SMM=
=3D0 HLT=3D0

ES =3D002b 0000000000000000 ffffffff 00c0f300 DPL=3D3 DS [-WA]

CS =3D0010 0000000000000000 00000000 00209b00 DPL=3D0 CS64 [-RA]

SS =3D0018 0000000000000000 00000000 00409300 DPL=3D0 DS [-WA]

DS =3D002b 0000000000000000 ffffffff 00c0f300 DPL=3D3 DS [-WA]

FS =3D0053 0000000013b70000 00003c00 0040f300 DPL=3D3 DS [-WA]

GS =3D002b fffff802a4150000 ffffffff 00c0f300 DPL=3D3 DS [-WA]

LDT=3D0000 0000000000000000 ffffffff 00c00000

TR =3D0040 fffff802a5a86070 00000067 00008b00 DPL=3D0 TSS64-busy

GDT=3D fffff802a5a85000 0000006f

IDT=3D fffff802a5a85070 00000fff

CR0=3D80050031 CR2=3D0000000000000030 CR3=3D00000000001aa000 CR4=3D001506f8

DR0=3D0000000000000000 DR1=3D0000000000000000 DR2=3D0000000000000000
DR3=3D0000000000000000

DR6=3D00000000ffff0ff0 DR7=3D0000000000000400

EFER=3D0000000000000d01

Code=3D25 88 61 00 00 b9 70 00 00 40 0f ba 32 00 72 06 33 c0 8b d0 <0f> 30 =
5a 58
59 c3 cc cc cc cc cc cc 0f 1f 84 00 00 00 00 00 48 81 ec 38 01 00 00 48 8d =
84

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=


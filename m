Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF88A14FD6C
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2020 15:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgBBN4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Feb 2020 08:56:15 -0500
Received: from mail-eopbgr1310089.outbound.protection.outlook.com ([40.107.131.89]:2112
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726679AbgBBN4P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Feb 2020 08:56:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=US6TA8VElTwUMPkXJC04ywCANjSkbwZzdZZQEh2ZIhEieOQKMHjp3U9hqcdYOV398S1xKsGIbFjBdCTmdyAvQFTcLw5zLQXcY+/ZCEa9KAHxrJs+IbvH/E9nV7pbZnje1oBy154M8fn60ldae7KoDplAEtwN7XdnN90JGtabnuQL3bdcG1rkqC6IqwyyvxTGskx8f0vVAt9h1kb1Xr8swgjpMSUPZhbE9t5RBHHzBEVXrZhMzohr0WomJzxNSRpeReyO1Qcvs4jYATDzuN+wHrRjMsSlz1xqK0hNOs2BbHIVHXBAo5wzAOsdVJ99HbYUOgwm5BU+LMD9ZxHoUOJRSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ktWfz3RcUITO+t+j/UfBfyqaPTg2laqOimc9ICNWwxQ=;
 b=DBBSMc4Ek+OPaIcTpBz42rHkW9HpVl9AY3hQDqoxbJkoyfC2oavSNzKu2tvGarAdkznvml4QVXWgU7oaYmFTC7g+pRjUlGWK0FApW7feFy9LYa9S4U6NInONYY1hm5rey2DqidHydx1yU9cSNVUs5EQaOuBQt/3ZJ/XysILSrvfg8oPWpGuEDGpd0KlnpW9OxQRhL6GHiFoj/qTiuX79q8b/pMFjd1WAYV/F0pQ3P8Hj3sw9+UzyYugNWiAnQ9RyZNq4+ArUWmD7LcWmbx+Dd/4NzvO9Hf1kkYugPISp1NKiiHm/p7I/oyg8tdr1Jyy8vihjVkIPFFpAihi0Cu7U4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=teo-en-ming-corp.com; dmarc=pass action=none
 header.from=teo-en-ming-corp.com; dkim=pass header.d=teo-en-ming-corp.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=teoenmingcorp.onmicrosoft.com; s=selector2-teoenmingcorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ktWfz3RcUITO+t+j/UfBfyqaPTg2laqOimc9ICNWwxQ=;
 b=ks1eWE9sO9gi/67P/PWMWcGsNSyCTJjPRozZDoUkWFc0lcg6UkbU2s4xnIdJzr9KMhIbDUOyJIkcFfOIAt5vlXebCjNx5fWwDf/DOJOSzpcYVQubYS2xLhJ9GpqJg6/ovgYvuEbqQWj2AT31hOKGzWUVerpzI+5tVaPfa2Cj6+o=
Received: from SG2PR01MB2141.apcprd01.prod.exchangelabs.com (10.170.143.19) by
 SG2PR01MB2758.apcprd01.prod.exchangelabs.com (20.177.169.76) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.29; Sun, 2 Feb 2020 13:56:05 +0000
Received: from SG2PR01MB2141.apcprd01.prod.exchangelabs.com
 ([fe80::81e9:67b1:74eb:2853]) by SG2PR01MB2141.apcprd01.prod.exchangelabs.com
 ([fe80::81e9:67b1:74eb:2853%3]) with mapi id 15.20.2686.031; Sun, 2 Feb 2020
 13:56:05 +0000
From:   Turritopsis Dohrnii Teo En Ming <ceo@teo-en-ming-corp.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Turritopsis Dohrnii Teo En Ming <ceo@teo-en-ming-corp.com>
Subject: Teo En Ming's Guide to GPU/VGA Passthrough of NVidia GeForce GTX1650
 to Windows 10 Virtual Machine using Linux KVM on Ubuntu 18.04.3 LTS Desktop
 Edition
Thread-Topic: Teo En Ming's Guide to GPU/VGA Passthrough of NVidia GeForce
 GTX1650 to Windows 10 Virtual Machine using Linux KVM on Ubuntu 18.04.3 LTS
 Desktop Edition
Thread-Index: AdXZjVXvndjWXYR8TDG0wz/7Q7ie7A==
Date:   Sun, 2 Feb 2020 13:56:04 +0000
Message-ID: <SG2PR01MB2141D9722010EB871E47E58287010@SG2PR01MB2141.apcprd01.prod.exchangelabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ceo@teo-en-ming-corp.com; 
x-originating-ip: [118.189.211.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 21fb7f81-7ed3-4d29-8d5e-08d7a7e7a585
x-ms-traffictypediagnostic: SG2PR01MB2758:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SG2PR01MB2758B4F7CC6DB7C1F00C230287010@SG2PR01MB2758.apcprd01.prod.exchangelabs.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0301360BF5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(6029001)(396003)(366004)(346002)(136003)(376002)(39830400003)(189003)(199004)(5660300002)(52536014)(71200400001)(66574012)(30864003)(66446008)(64756008)(66476007)(76116006)(7696005)(16799955002)(66556008)(6506007)(66946007)(26005)(186003)(107886003)(55016002)(9686003)(4326008)(2906002)(316002)(6916009)(33656002)(966005)(508600001)(45080400002)(81166006)(86362001)(8676002)(8936002)(81156014)(21314003)(559001)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:SG2PR01MB2758;H:SG2PR01MB2141.apcprd01.prod.exchangelabs.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: teo-en-ming-corp.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mx+SaiSyVoImkYlbNOddAqwlf2k7UbzMb+fHHa7gF9PUmxdlVdn0+CXfl1MuHRoAjRGDd1M6hHrDNHXkHlt5+35lXEB0zCLKmHVaKAIxU10Eyo/3/rX4ADNho5ZC33UdjMX96akfUResGmnBp1+L2ZlbFos7O629iZ4LktcX9tC7B/zcBb/Rl2UslinkRLa/3y9gqkEDOY8wWITeMrxbRPPnOJBepFWhIhTH1mKBw14GeJpkT7GOoiNbV7iv/ExBZFjlI4SD1b19tHLf9F5dZDeA8v/tuO/Lo/+lv6CeRyqSbcwiEs2PCo76/oCBeY0fTjXxY2VTbTOelJbL/V81UN71N8rinnbPCJGzIoXj4UA7lcNf82/uH6a2NbKQy8Pd1dsweQiBFN/hTn2gm8E/nTVkGKDxnap3JND5Nq/KxqCjaXWy17q+tbzBPrv8Btk5BmriL2Ip4vYVoS+WELWcFvjaZgM+trIZeEPaQDRrE54kpdezXNtdmg2t9EkXz3L3vFJaY6z9p2CqHAsG7i81wsfP6ZuZVAr2tiTDqwR1bWPd9/O25azuK3LNhRTM0YrnvBEcegHlaSD6vEa7CJrxKA==
x-ms-exchange-antispam-messagedata: BOW1MJOw3N/cxqVwGInrjCf8KAqUiRUlLJSXL/au/PWqjwZJovvF/VtdegDBOb8ixn+9zD4Fzmr/N3YdTrDY37obvMOi7++YmBxi4wsA4BEDcxe2JEzp4ZXtuQUcRu9ZLHFq8itFMtfmpHEfQsvo7w==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: teo-en-ming-corp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21fb7f81-7ed3-4d29-8d5e-08d7a7e7a585
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2020 13:56:04.9913
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b3f6ae-c453-4b93-aec9-f17508e5885c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xItNQ6HEPvnMqJC+HQku5yxl144ycXtpLIdvf/6vfDsokd1rvwjxk6VeIR7h2ABv27lodcT6dGmAghdf7j3o+E4UOSEJWkPteZm1JxaIXPw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR01MB2758
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Primary Subject: Teo En Ming's Guide to GPU/VGA Passthrough of NVidia GeFor=
ce GTX1650 to Windows 10 Virtual Machine using Linux KVM on Ubuntu 18.04.3 =
LTS Desktop Edition

Secondary Subject: Mr. Turritopsis Dohrnii Teo En Ming's Linux KVM GPU Pass=
through Project, Started 1st Feb 2020 Saturday late night before midnight a=
nd completed
on 2nd Feb 2020 Sunday at 9:21 PM Singapore Time

PUBLISHED 2ND FEB 2020 SUNDAY AT 9:30 PM SINGAPORE TIME (VERSION 1.0)

REFERENCE
=3D=3D=3D=3D=3D=3D=3D=3D=3D

Heiko Sieger's blog: Running Windows 10 on Linux using KVM with VGA Passthr=
ough

Link: https://heiko-sieger.info/running-windows-10-on-linux-using-kvm-with-=
vga-passthrough/

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

I am following Heiko Sieger's guide because I think it is very well written=
 and very well explained. Good job!

I need to come up with this guide for myself because the home desktop compu=
ter which I have is specific and unique to me.

Turritopsis Dohrnii Teo En Ming's home desktop computer technical specifica=
tions:

[1] Processor: AMD Ryzen 3 3200G with Radeon Vega 8 Graphics, 4 Cores, 4 Th=
reads, 4.0 GHz Max Boost, 3.6 GHz Base
[2] Motherboard: Gigabyte B450M DS3H rev 1.0 Socket AM4 (BIOS Version: F41,=
 BIOS Date: 07/22/2019, BIOS ID: 8A16BG05)
[3] Memory: 8 GB Transcend DDR4-2666
[4] Integrated Graphics Device (IGD): AMD Radeon Vega 8 Graphics (for Linux=
 host)
[5] Discrete GPU on PCIe Slot 1: MSI GeForce GTX1650 Ventus XS OC Edition 4=
 GB GDDR5 (for Windows 10 version 1709 virtual machine)
[6] Solid State Disk (SSD): 256 GB Transcend SSD (bare-metal Windows 10 ver=
sion 1909 installation)
[7] Harddisk (HDD): Seagate Barracude 1 TB 3.5" Internal SATA (for installi=
ng Ubuntu 18.04.3 LTS Desktop Edition host)

DETAILED INSTRUCTIONS
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Download ubuntu-18.04.3-desktop-amd64.iso from ubuntu.com (official website=
) and burn it to a USB thumb drive using Universal USB Installer 1.9.9.0=20
from Pendrivelinux.com

Reboot computer.

Press DELETE to go into BIOS Setup.

Use the CLASSIC BIOS Interface.

Peripherals > Initial Display Output: IGD Video (Onboard Graphics)

M.I.T. > Advanced Frequency Settings > Advanced CPU Settings > SVM Mode: En=
abled

BIOS > Storage Boot Option Control: UEFI Only

BIOS > Other PCI Device ROM Priority: UEFI Only

Save BIOS settings and Exit.

Press F12 to go into Boot Menu.

Select the USB thumb drive containing Ubuntu 18.04.3 LTS (UEFI).

Select "Try Ubuntu without installing".

Double click "Install Ubuntu 18.04.3 LTS".

Welcome: English

Keyboard layout: English (US)

Select "Normal installation".

Uncheck "Download updates while installing Ubuntu".

Uncheck "Install third-party software for graphics and Wi-Fi hardware and a=
dditional media formats".

Select "Erase disk and install Ubuntu".

Uncheck "Encrypt the new Ubuntu installation for security".

Uncheck "Use LVM with the new Ubuntu installation".

Select drive: SCSI1 (0,0,0) (sda) - 1.0 TB ATA ST1000DM010-2EP1 (Seagate Ba=
rracuda).

Click Install Now.

Write the changes to disks? Continue.

Where are you? Singapore.

Your name: Turritopsis Dohrnii Teo En Ming

Your computer's name: ubuntu18043

Pick a username: teo-en-ming

Installation Complete: Click Restart Now.

Press F12 to go into Boot Menu.

Select ubuntu (Seagate 1 TB HDD).

Linux command: sudo nano /etc/default/grub

Contents of file:

# If you change this file, run 'update-grub' afterwards to update
# /boot/grub/grub.cfg.
# For full documentation of the options in this file, see:
#   info -f grub -n 'Simple configuration'

GRUB_DEFAULT=3D0
GRUB_TIMEOUT_STYLE=3Dhidden
GRUB_TIMEOUT=3D10
GRUB_DISTRIBUTOR=3D`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT=3D"quiet splash amd_iommu=3Don"
GRUB_CMDLINE_LINUX=3D""

# Uncomment to enable BadRAM filtering, modify to suit your needs
# This works with Linux (no patch required) and with any kernel that obtain=
s
# the memory map information from GRUB (GNU Mach, kernel of FreeBSD ...)
#GRUB_BADRAM=3D"0x01234567,0xfefefefe,0x89abcdef,0xefefefef"

# Uncomment to disable graphical terminal (grub-pc only)
#GRUB_TERMINAL=3Dconsole

# The resolution used on graphical terminal
# note that you can use only modes which your graphic card supports via VBE
# you can see them in real GRUB with the command `vbeinfo'
#GRUB_GFXMODE=3D640x480

# Uncomment if you don't want GRUB to pass "root=3DUUID=3Dxxx" parameter to=
 Linux
#GRUB_DISABLE_LINUX_UUID=3Dtrue

# Uncomment to disable generation of recovery mode menu entries
#GRUB_DISABLE_RECOVERY=3D"true"

# Uncomment to get a beep at grub start
#GRUB_INIT_TUNE=3D"480 440 1"

Linux command: sudo update-grub

Output:

Sourcing file `/etc/default/grub'
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-5.3.0-28-generic
Found initrd image: /boot/initrd.img-5.3.0-28-generic
Found linux image: /boot/vmlinuz-5.0.0-23-generic
Found initrd image: /boot/initrd.img-5.0.0-23-generic
Found Windows Boot Manager on /dev/sdc2@/efi/Microsoft/Boot/bootmgfw.efi
Adding boot menu entry for EFI firmware configuration
done


Reboot the computer.

Linux command: sudo reboot

Linux command: dmesg | grep AMD-Vi

Output:

[    0.572129] pci 0000:00:00.2: AMD-Vi: Unable to write to IOMMU perf coun=
ter.
[    0.576192] pci 0000:00:00.2: AMD-Vi: Found IOMMU cap 0x40
[    0.576193] pci 0000:00:00.2: AMD-Vi: Extended features (0x4f77ef22294ad=
a):
[    0.576195] AMD-Vi: Interrupt remapping enabled
[    0.576195] AMD-Vi: Virtual APIC enabled
[    0.576368] AMD-Vi: Lazy IO/TLB flushing enabled
[   10.432967] AMD-Vi: AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>


Linux command: cat /proc/cpuinfo | grep svm

Output:

flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat =
pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtsc=
p lm constant_tsc rep_good nopl nonstop_tsc cpuid extd_apicid aperfmperf pn=
i pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 movbe popcnt aes xsave avx=
 f16c rdrand lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignss=
e 3dnowprefetch osvw skinit wdt tce topoext perfctr_core perfctr_nb bpext p=
erfctr_llc mwaitx cpb hw_pstate sme ssbd sev ibpb vmmcall fsgsbase bmi1 avx=
2 smep bmi2 rdseed adx smap clflushopt sha_ni xsaveopt xsavec xgetbv1 xsave=
s clzero irperf xsaveerptr arat npt lbrv svm_lock nrip_save tsc_scale vmcb_=
clean flushbyasid decodeassists pausefilter pfthreshold avic v_vmsave_vmloa=
d vgif overflow_recov succor smca
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat =
pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtsc=
p lm constant_tsc rep_good nopl nonstop_tsc cpuid extd_apicid aperfmperf pn=
i pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 movbe popcnt aes xsave avx=
 f16c rdrand lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignss=
e 3dnowprefetch osvw skinit wdt tce topoext perfctr_core perfctr_nb bpext p=
erfctr_llc mwaitx cpb hw_pstate sme ssbd sev ibpb vmmcall fsgsbase bmi1 avx=
2 smep bmi2 rdseed adx smap clflushopt sha_ni xsaveopt xsavec xgetbv1 xsave=
s clzero irperf xsaveerptr arat npt lbrv svm_lock nrip_save tsc_scale vmcb_=
clean flushbyasid decodeassists pausefilter pfthreshold avic v_vmsave_vmloa=
d vgif overflow_recov succor smca
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat =
pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtsc=
p lm constant_tsc rep_good nopl nonstop_tsc cpuid extd_apicid aperfmperf pn=
i pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 movbe popcnt aes xsave avx=
 f16c rdrand lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignss=
e 3dnowprefetch osvw skinit wdt tce topoext perfctr_core perfctr_nb bpext p=
erfctr_llc mwaitx cpb hw_pstate sme ssbd sev ibpb vmmcall fsgsbase bmi1 avx=
2 smep bmi2 rdseed adx smap clflushopt sha_ni xsaveopt xsavec xgetbv1 xsave=
s clzero irperf xsaveerptr arat npt lbrv svm_lock nrip_save tsc_scale vmcb_=
clean flushbyasid decodeassists pausefilter pfthreshold avic v_vmsave_vmloa=
d vgif overflow_recov succor smca
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat =
pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtsc=
p lm constant_tsc rep_good nopl nonstop_tsc cpuid extd_apicid aperfmperf pn=
i pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 movbe popcnt aes xsave avx=
 f16c rdrand lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignss=
e 3dnowprefetch osvw skinit wdt tce topoext perfctr_core perfctr_nb bpext p=
erfctr_llc mwaitx cpb hw_pstate sme ssbd sev ibpb vmmcall fsgsbase bmi1 avx=
2 smep bmi2 rdseed adx smap clflushopt sha_ni xsaveopt xsavec xgetbv1 xsave=
s clzero irperf xsaveerptr arat npt lbrv svm_lock nrip_save tsc_scale vmcb_=
clean flushbyasid decodeassists pausefilter pfthreshold avic v_vmsave_vmloa=
d vgif overflow_recov succor smca


Linux command: sudo apt install qemu-kvm qemu-utils seabios ovmf hugepages =
cpu-checker


Linux command: lspci | grep VGA

Output:

01:00.0 VGA compatible controller: NVIDIA Corporation Device 1f82 (rev a1)
07:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] P=
icasso (rev c9)


Linux command: lspci -nn | grep 01:00.

Output:

01:00.0 VGA compatible controller [0300]: NVIDIA Corporation Device [10de:1=
f82] (rev a1)
01:00.1 Audio device [0403]: NVIDIA Corporation Device [10de:10fa] (rev a1)


Bus numbers of NVidia GeForce GTX1650 GPU:

01:00.0
01:00.1


PCI IDs of NVidia GeForce GTX1650 GPU:

10de:1f82
10de:10fa

Linux command: for a in /sys/kernel/iommu_groups/*; do find $a -type l; don=
e | sort --version-sort

Output:

/sys/kernel/iommu_groups/7/devices/0000:01:00.0
/sys/kernel/iommu_groups/7/devices/0000:01:00.1

IOMMU Group: 7

Linux command: lsusb

Output:

Bus 001 Device 005: ID 0603:00f2 Novatek Microelectronics Corp. Keyboard (L=
abtec Ultra Flat Keyboard)
Bus 001 Device 004: ID 056e:0107 Elecom Co., Ltd (wireless optical mouse)

Linux command: cat /sys/bus/pci/devices/0000:01:00.0/modalias

Output:

pci:v000010DEd00001F82sv00001462sd00008D92bc03sc00i00

Linux command: cat /sys/bus/pci/devices/0000:01:00.1/modalias

Output:

pci:v000010DEd000010FAsv00001462sd00008D92bc04sc03i00

Linux command: sudo nano /etc/modprobe.d/local.conf

Contents of file:

alias pci:v000010DEd00001F82sv00001462sd00008D92bc03sc00i00 vfio-pci
alias pci:v000010DEd000010FAsv00001462sd00008D92bc04sc03i00 vfio-pci
options vfio-pci ids=3D10de:1f82,10de:10fa
options vfio-pci disable_vga=3D1

Linux command: sudo nano /etc/modprobe.d/kvm.conf

Contents of file:

options kvm ignore_msrs=3D1

Linux command: sudo nano /etc/initramfs-tools/modules

Contents of file:

vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
vhost-net

Linux command: sudo update-initramfs -u

Output:

update-initramfs: Generating /boot/initrd.img-5.3.0-28-generic

I will configure bridge networking much later, after GPU Passthrough is suc=
cessful. GPU Passthrough is top priority. I must get it to work first.

REFERENCE
=3D=3D=3D=3D=3D=3D=3D=3D=3D

Link: https://heiko-sieger.info/define-a-network-bridge-using-ubuntus-linux=
-mints-network-manager-application/

Download the latest VFIO drivers from https://fedorapeople.org/groups/virt/=
virtio-win/direct-downloads/latest-virtio/virtio-win.iso

Linux command: fallocate -l 250G /home/teo-en-ming/win10.img

Linux command: kvm-ok

Output:

INFO: /dev/kvm exists
KVM acceleration can be used

Linux command: lsmod | grep kvm

Output:

kvm_amd                94208  0
ccp                    86016  1 kvm_amd
kvm                   651264  1 kvm_amd
irqbypass              16384  1 kvm

Reboot the computer.

Linux command: sudo reboot

Linux command: lsmod | grep kvm

Output:

kvm_amd                94208  0
ccp                    86016  1 kvm_amd
kvm                   651264  1 kvm_amd
irqbypass              16384  2 vfio_pci,kvm

Linux command: lsmod | grep vfio

Output:

vfio_pci               49152  0
irqbypass              16384  2 vfio_pci,kvm
vfio_virqfd            16384  1 vfio_pci
vfio_iommu_type1       28672  0
vfio                   32768  2 vfio_iommu_type1,vfio_pci


Linux command: qemu-system-x86_64 --version

Output:

QEMU emulator version 2.11.1(Debian 1:2.11+dfsg-1ubuntu7.21)
Copyright (c) 2003-2017 Fabrice Bellard and the QEMU Project developers

Linux command: lspci -kn | grep -A 2 01:00

Output:

01:00.0 0300: 10de:1f82 (rev a1)
	Subsystem: 1462:8d92
	Kernel driver in use: vfio-pci
--
01:00.1 0403: 10de:10fa (rev a1)
	Subsystem: 1462:8d92
	Kernel driver in use: vfio-pci

Kernel driver in use is vfio-pci. It worked!

Linux command: dmesg | grep VFIO

Output:

[    2.808675] VFIO - User Level meta-driver version: 0.3

Create Script to Start Windows 10 Virtual Machine with GPU Passthrough
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Linux command: sudo nano windows10vm.sh

Contents of file:

#!/bin/bash

vmname=3D"windows10vm"

if ps -ef | grep qemu-system-x86_64 | grep -q multifunction=3Don; then
echo "A passthrough VM is already running." &
exit 1

else

# use pulseaudio
export QEMU_AUDIO_DRV=3Dpa
export QEMU_PA_SAMPLES=3D8192
export QEMU_AUDIO_TIMER_PERIOD=3D99
export QEMU_PA_SERVER=3D/run/user/1000/pulse/native

cp /usr/share/OVMF/OVMF_VARS.fd /tmp/my_vars.fd

qemu-system-x86_64 \
-name $vmname,process=3D$vmname \
-machine type=3Dpc,accel=3Dkvm \
-cpu host,kvm=3Doff \
-smp 3,sockets=3D1,cores=3D3,threads=3D1 \
-m 4G \
-balloon none \
-rtc clock=3Dhost,base=3Dlocaltime \
-serial none \
-parallel none \
-soundhw hda \
-usb \
-device usb-host,vendorid=3D0x0603,productid=3D0x00f2 \
-device usb-host,vendorid=3D0x056e,productid=3D0x0107 \
-device vfio-pci,host=3D01:00.0,multifunction=3Don \
-device vfio-pci,host=3D01:00.1 \
-drive if=3Dpflash,format=3Draw,readonly,file=3D/usr/share/OVMF/OVMF_CODE.f=
d \
-drive if=3Dpflash,format=3Draw,file=3D/tmp/my_vars.fd \
-boot order=3Ddc \
-drive id=3Ddisk0,if=3Dvirtio,cache=3Dnone,format=3Draw,file=3D/home/teo-en=
-ming/win10.img \
-drive file=3D/home/teo-en-ming/win10-1709.iso,index=3D1,media=3Dcdrom \
-drive file=3D/home/teo-en-ming/Downloads/virtio-win-0.1.173.iso,index=3D2,=
media=3Dcdrom=20
#-netdev type=3Dtap,id=3Dnet0,ifname=3Dvmtap0,vhost=3Don \
#-device virtio-net-pci,netdev=3Dnet0,mac=3D00:16:3e:00:01:01
#-vga none \
#-nographic \

exit 0
fi



Linux command: sudo chmod +x windows10vm.sh

Linux command: sudo ./windows10vm.sh



Temporarily paused doing work at 2:41 AM in the morning on 2nd Feb 2020 Sun=
day.

Instructions for AMD Ryzen platforms
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Link: https://forums.linuxmint.com/viewtopic.php?f=3D231&t=3D212692&p=3D134=
0482#p1340482

Linux command: sudo add-apt-repository ppa:jacob/virtualisation

Uninstall qemu 2.11.1.

Linux command: sudo apt-get remove qemu-kvm qemu-utils

Install qemu 2.12

Linux command: sudo apt install qemu-kvm qemu-utils

ERROR: Windows 10 virtual machine keeps showing BSOD with IRQL NOT LESS OR =
EQUAL Stop Code.
By the way, I am able to see the Tiano Core screen.=20
No matter what variables I play with in the shell script to start Windows 1=
0 VM,=20
I always get BSOD IRQL NOT LESS OR EQUAL Stop Code. I am running out of opt=
ions already.
Please give me suggestions.

Questions
=3D=3D=3D=3D=3D=3D=3D=3D=3D

[1] Is MSI GeForce GTX1650 4 GB GDDR5 GPU not supported by Linux KVM for GP=
U Passthrough?

[2] Do I need to upgrade the BIOS of my Gigabyte B450M DS3H Socket AM4 moth=
erboard? I fear bricking my motherboard. It is a risky operation.

[3] Are there any other workarounds that I have to do for AMD Ryzen 3000 se=
ries platform, in order to get GPU Passthrough to work?

I am looking forward to your replies.

Thank you very much!

Stopped troubleshooting at 5.19 AM Singapore Time on 2 Feb 2020 Sunday and =
went to sleep.

Resumed troubleshooting at around 12 noon Singapore Time on 2 Feb 2020 Sund=
ay.

Upgraded motherboard BIOS to version F50 using Q-Flash.

Linux command: sudo ./windows10vm.sh

Output:

qemu-system-x86_64: -balloon none: warning: This option is deprecated. Use =
'--device virtio-balloon' to enable the balloon device.
qemu-system-x86_64: -device vfio-pci,host=3D01:00.0,multifunction=3Don: vfi=
o error: 0000:01:00.0: group 0 is not viable
Please ensure all devices within the iommu_group are bound to their vfio bu=
s driver.

Linux command: for a in /sys/kernel/iommu_groups/*; do find $a -type l; don=
e | sort --version-sort

Output:

/sys/kernel/iommu_groups/0/devices/0000:00:01.0
/sys/kernel/iommu_groups/0/devices/0000:00:01.1
/sys/kernel/iommu_groups/0/devices/0000:00:01.2
/sys/kernel/iommu_groups/0/devices/0000:01:00.0
/sys/kernel/iommu_groups/0/devices/0000:01:00.1
/sys/kernel/iommu_groups/0/devices/0000:02:00.0
/sys/kernel/iommu_groups/0/devices/0000:02:00.1
/sys/kernel/iommu_groups/0/devices/0000:02:00.2
/sys/kernel/iommu_groups/0/devices/0000:03:00.0
/sys/kernel/iommu_groups/0/devices/0000:03:01.0
/sys/kernel/iommu_groups/0/devices/0000:03:04.0
/sys/kernel/iommu_groups/0/devices/0000:05:00.0
/sys/kernel/iommu_groups/0/devices/0000:06:00.0
/sys/kernel/iommu_groups/1/devices/0000:00:08.0
/sys/kernel/iommu_groups/1/devices/0000:00:08.1
/sys/kernel/iommu_groups/1/devices/0000:00:08.2
/sys/kernel/iommu_groups/1/devices/0000:07:00.0
/sys/kernel/iommu_groups/1/devices/0000:07:00.1
/sys/kernel/iommu_groups/1/devices/0000:07:00.2
/sys/kernel/iommu_groups/1/devices/0000:07:00.3
/sys/kernel/iommu_groups/1/devices/0000:07:00.4
/sys/kernel/iommu_groups/1/devices/0000:07:00.6
/sys/kernel/iommu_groups/1/devices/0000:08:00.0
/sys/kernel/iommu_groups/2/devices/0000:00:14.0
/sys/kernel/iommu_groups/2/devices/0000:00:14.3
/sys/kernel/iommu_groups/3/devices/0000:00:18.0
/sys/kernel/iommu_groups/3/devices/0000:00:18.1
/sys/kernel/iommu_groups/3/devices/0000:00:18.2
/sys/kernel/iommu_groups/3/devices/0000:00:18.3
/sys/kernel/iommu_groups/3/devices/0000:00:18.4
/sys/kernel/iommu_groups/3/devices/0000:00:18.5
/sys/kernel/iommu_groups/3/devices/0000:00:18.6
/sys/kernel/iommu_groups/3/devices/0000:00:18.7

Linux command: sudo apt install inxi

Linux command: inxi -S

Output:

System:    Host: ubuntu18043 Kernel: 5.3.0-28-generic x86_64 bits: 64 Deskt=
op: Gnome 3.28.4
           Distro: Ubuntu 18.04.3 LTS

REFERENCE
=3D=3D=3D=3D=3D=3D=3D=3D=3D

Link: https://phoenixnap.com/kb/how-to-update-kernel-ubuntu

Linux command: sudo apt-add-repository ppa:teejee2008/ppa

Linux command: sudo apt-get update

Linux command: sudo apt-get install ukuu

Linux command: sudo ukuu-gtk

Ukuu: Ubuntu Kernel Update Utility

Installed Linux kernel 5.5.1 using Ukuu.

Linux command: uname -a

Output:

Linux ubuntu18043 5.5.1-050501-generic #202002011032 SMP Sat Feb 1 10:34:22=
 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux

Linux command: for a in /sys/kernel/iommu_groups/*; do find $a -type l; don=
e | sort --version-sort

/sys/kernel/iommu_groups/0/devices/0000:00:01.0
/sys/kernel/iommu_groups/0/devices/0000:00:01.1
/sys/kernel/iommu_groups/0/devices/0000:00:01.2
/sys/kernel/iommu_groups/0/devices/0000:01:00.0
/sys/kernel/iommu_groups/0/devices/0000:01:00.1
/sys/kernel/iommu_groups/0/devices/0000:02:00.0
/sys/kernel/iommu_groups/0/devices/0000:02:00.1
/sys/kernel/iommu_groups/0/devices/0000:02:00.2
/sys/kernel/iommu_groups/0/devices/0000:03:00.0
/sys/kernel/iommu_groups/0/devices/0000:03:01.0
/sys/kernel/iommu_groups/0/devices/0000:03:04.0
/sys/kernel/iommu_groups/0/devices/0000:05:00.0
/sys/kernel/iommu_groups/0/devices/0000:06:00.0
/sys/kernel/iommu_groups/1/devices/0000:00:08.0
/sys/kernel/iommu_groups/1/devices/0000:00:08.1
/sys/kernel/iommu_groups/1/devices/0000:00:08.2
/sys/kernel/iommu_groups/1/devices/0000:07:00.0
/sys/kernel/iommu_groups/1/devices/0000:07:00.1
/sys/kernel/iommu_groups/1/devices/0000:07:00.2
/sys/kernel/iommu_groups/1/devices/0000:07:00.3
/sys/kernel/iommu_groups/1/devices/0000:07:00.4
/sys/kernel/iommu_groups/1/devices/0000:07:00.6
/sys/kernel/iommu_groups/1/devices/0000:08:00.0
/sys/kernel/iommu_groups/2/devices/0000:00:14.0
/sys/kernel/iommu_groups/2/devices/0000:00:14.3
/sys/kernel/iommu_groups/3/devices/0000:00:18.0
/sys/kernel/iommu_groups/3/devices/0000:00:18.1
/sys/kernel/iommu_groups/3/devices/0000:00:18.2
/sys/kernel/iommu_groups/3/devices/0000:00:18.3
/sys/kernel/iommu_groups/3/devices/0000:00:18.4
/sys/kernel/iommu_groups/3/devices/0000:00:18.5
/sys/kernel/iommu_groups/3/devices/0000:00:18.6
/sys/kernel/iommu_groups/3/devices/0000:00:18.7

REFERENCE
=3D=3D=3D=3D=3D=3D=3D=3D=3D

https://queuecumber.gitlab.io/linux-acs-override/

Linux command: cd Downloads

Linux command: unzip artifacts.zip

Linux command: sudo dpkg -i linux-headers-5.4.10-acso_5.4.10-acso-1_amd64.d=
eb

Linux command: sudo dpkg -i linux-image-5.4.10-acso_5.4.10-acso-1_amd64.deb

Linux command: sudo dpkg -i linux-libc-dev_5.4.10-acso-1_amd64.deb

Linux command: sudo reboot

Linux command: uname -a

Output:

Linux ubuntu18043 5.4.10-acso #1 SMP Thu Jan 9 10:30:12 UTC 2020 x86_64 x86=
_64 x86_64 GNU/Linux

Linux command: for a in /sys/kernel/iommu_groups/*; do find $a -type l; don=
e | sort --version-sort

Output:

/sys/kernel/iommu_groups/0/devices/0000:00:01.0
/sys/kernel/iommu_groups/0/devices/0000:00:01.1
/sys/kernel/iommu_groups/0/devices/0000:00:01.2
/sys/kernel/iommu_groups/0/devices/0000:01:00.0
/sys/kernel/iommu_groups/0/devices/0000:01:00.1
/sys/kernel/iommu_groups/0/devices/0000:02:00.0
/sys/kernel/iommu_groups/0/devices/0000:02:00.1
/sys/kernel/iommu_groups/0/devices/0000:02:00.2
/sys/kernel/iommu_groups/0/devices/0000:03:00.0
/sys/kernel/iommu_groups/0/devices/0000:03:01.0
/sys/kernel/iommu_groups/0/devices/0000:03:04.0
/sys/kernel/iommu_groups/0/devices/0000:05:00.0
/sys/kernel/iommu_groups/0/devices/0000:06:00.0
/sys/kernel/iommu_groups/1/devices/0000:00:08.0
/sys/kernel/iommu_groups/1/devices/0000:00:08.1
/sys/kernel/iommu_groups/1/devices/0000:00:08.2
/sys/kernel/iommu_groups/1/devices/0000:07:00.0
/sys/kernel/iommu_groups/1/devices/0000:07:00.1
/sys/kernel/iommu_groups/1/devices/0000:07:00.2
/sys/kernel/iommu_groups/1/devices/0000:07:00.3
/sys/kernel/iommu_groups/1/devices/0000:07:00.4
/sys/kernel/iommu_groups/1/devices/0000:07:00.6
/sys/kernel/iommu_groups/1/devices/0000:08:00.0
/sys/kernel/iommu_groups/2/devices/0000:00:14.0
/sys/kernel/iommu_groups/2/devices/0000:00:14.3
/sys/kernel/iommu_groups/3/devices/0000:00:18.0
/sys/kernel/iommu_groups/3/devices/0000:00:18.1
/sys/kernel/iommu_groups/3/devices/0000:00:18.2
/sys/kernel/iommu_groups/3/devices/0000:00:18.3
/sys/kernel/iommu_groups/3/devices/0000:00:18.4
/sys/kernel/iommu_groups/3/devices/0000:00:18.5
/sys/kernel/iommu_groups/3/devices/0000:00:18.6
/sys/kernel/iommu_groups/3/devices/0000:00:18.7

Shifted GTX1650 GPU from PCIe Slot 1 to PCIe Slot 2

Linux Command: lspci | grep VGA

Output:

05:00.0 VGA compatible controller: NVIDIA Corporation Device 1f82 (rev a1)
06:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] P=
icasso (rev c9)

Linux command: for a in /sys/kernel/iommu_groups/*; do find $a -type l; don=
e | sort --version-sort

Output:

/sys/kernel/iommu_groups/0/devices/0000:00:01.0
/sys/kernel/iommu_groups/0/devices/0000:00:01.2
/sys/kernel/iommu_groups/0/devices/0000:01:00.0
/sys/kernel/iommu_groups/0/devices/0000:01:00.1
/sys/kernel/iommu_groups/0/devices/0000:01:00.2
/sys/kernel/iommu_groups/0/devices/0000:02:00.0
/sys/kernel/iommu_groups/0/devices/0000:02:01.0
/sys/kernel/iommu_groups/0/devices/0000:02:04.0
/sys/kernel/iommu_groups/0/devices/0000:04:00.0
/sys/kernel/iommu_groups/0/devices/0000:05:00.0
/sys/kernel/iommu_groups/0/devices/0000:05:00.1
/sys/kernel/iommu_groups/1/devices/0000:00:08.0
/sys/kernel/iommu_groups/1/devices/0000:00:08.1
/sys/kernel/iommu_groups/1/devices/0000:00:08.2
/sys/kernel/iommu_groups/1/devices/0000:06:00.0
/sys/kernel/iommu_groups/1/devices/0000:06:00.1
/sys/kernel/iommu_groups/1/devices/0000:06:00.2
/sys/kernel/iommu_groups/1/devices/0000:06:00.3
/sys/kernel/iommu_groups/1/devices/0000:06:00.4
/sys/kernel/iommu_groups/1/devices/0000:06:00.6
/sys/kernel/iommu_groups/1/devices/0000:07:00.0
/sys/kernel/iommu_groups/2/devices/0000:00:14.0
/sys/kernel/iommu_groups/2/devices/0000:00:14.3
/sys/kernel/iommu_groups/3/devices/0000:00:18.0
/sys/kernel/iommu_groups/3/devices/0000:00:18.1
/sys/kernel/iommu_groups/3/devices/0000:00:18.2
/sys/kernel/iommu_groups/3/devices/0000:00:18.3
/sys/kernel/iommu_groups/3/devices/0000:00:18.4
/sys/kernel/iommu_groups/3/devices/0000:00:18.5
/sys/kernel/iommu_groups/3/devices/0000:00:18.6
/sys/kernel/iommu_groups/3/devices/0000:00:18.7

No improvement. Shift GTX1650 GPU back to PCIe slot 1.

Downgraded motherboard bios to version F42h using Q-flash.

Linux command: for a in /sys/kernel/iommu_groups/*; do find $a -type l; don=
e | sort --version-sort

Output:

/sys/kernel/iommu_groups/0/devices/0000:00:01.0
/sys/kernel/iommu_groups/0/devices/0000:00:01.1
/sys/kernel/iommu_groups/0/devices/0000:00:01.2
/sys/kernel/iommu_groups/0/devices/0000:01:00.0
/sys/kernel/iommu_groups/0/devices/0000:01:00.1
/sys/kernel/iommu_groups/0/devices/0000:02:00.0
/sys/kernel/iommu_groups/0/devices/0000:02:00.1
/sys/kernel/iommu_groups/0/devices/0000:02:00.2
/sys/kernel/iommu_groups/0/devices/0000:03:00.0
/sys/kernel/iommu_groups/0/devices/0000:03:01.0
/sys/kernel/iommu_groups/0/devices/0000:03:04.0
/sys/kernel/iommu_groups/0/devices/0000:05:00.0
/sys/kernel/iommu_groups/0/devices/0000:06:00.0
/sys/kernel/iommu_groups/1/devices/0000:00:08.0
/sys/kernel/iommu_groups/1/devices/0000:00:08.1
/sys/kernel/iommu_groups/1/devices/0000:00:08.2
/sys/kernel/iommu_groups/1/devices/0000:07:00.0
/sys/kernel/iommu_groups/1/devices/0000:07:00.1
/sys/kernel/iommu_groups/1/devices/0000:07:00.2
/sys/kernel/iommu_groups/1/devices/0000:07:00.3
/sys/kernel/iommu_groups/1/devices/0000:07:00.4
/sys/kernel/iommu_groups/1/devices/0000:07:00.6
/sys/kernel/iommu_groups/1/devices/0000:08:00.0
/sys/kernel/iommu_groups/2/devices/0000:00:14.0
/sys/kernel/iommu_groups/2/devices/0000:00:14.3
/sys/kernel/iommu_groups/3/devices/0000:00:18.0
/sys/kernel/iommu_groups/3/devices/0000:00:18.1
/sys/kernel/iommu_groups/3/devices/0000:00:18.2
/sys/kernel/iommu_groups/3/devices/0000:00:18.3
/sys/kernel/iommu_groups/3/devices/0000:00:18.4
/sys/kernel/iommu_groups/3/devices/0000:00:18.5
/sys/kernel/iommu_groups/3/devices/0000:00:18.6
/sys/kernel/iommu_groups/3/devices/0000:00:18.7

Downgraded motherboard BIOS to version F41 using Q-Flash.

Linux command: lspci | grep VGA

Output:

01:00.0 VGA compatible controller: NVIDIA Corporation Device 1f82 (rev a1)
07:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] P=
icasso (rev c9)

Linux command: for a in /sys/kernel/iommu_groups/*; do find $a -type l; don=
e | sort --version-sort

Output:

/sys/kernel/iommu_groups/0/devices/0000:00:01.0
/sys/kernel/iommu_groups/1/devices/0000:00:01.1
/sys/kernel/iommu_groups/2/devices/0000:00:01.2
/sys/kernel/iommu_groups/3/devices/0000:00:08.0
/sys/kernel/iommu_groups/4/devices/0000:00:08.1
/sys/kernel/iommu_groups/5/devices/0000:00:14.0
/sys/kernel/iommu_groups/5/devices/0000:00:14.3
/sys/kernel/iommu_groups/6/devices/0000:00:18.0
/sys/kernel/iommu_groups/6/devices/0000:00:18.1
/sys/kernel/iommu_groups/6/devices/0000:00:18.2
/sys/kernel/iommu_groups/6/devices/0000:00:18.3
/sys/kernel/iommu_groups/6/devices/0000:00:18.4
/sys/kernel/iommu_groups/6/devices/0000:00:18.5
/sys/kernel/iommu_groups/6/devices/0000:00:18.6
/sys/kernel/iommu_groups/6/devices/0000:00:18.7
/sys/kernel/iommu_groups/7/devices/0000:01:00.0
/sys/kernel/iommu_groups/7/devices/0000:01:00.1
/sys/kernel/iommu_groups/8/devices/0000:02:00.0
/sys/kernel/iommu_groups/8/devices/0000:02:00.1
/sys/kernel/iommu_groups/8/devices/0000:02:00.2
/sys/kernel/iommu_groups/8/devices/0000:03:00.0
/sys/kernel/iommu_groups/8/devices/0000:03:01.0
/sys/kernel/iommu_groups/8/devices/0000:03:04.0
/sys/kernel/iommu_groups/8/devices/0000:05:00.0
/sys/kernel/iommu_groups/8/devices/0000:06:00.0
/sys/kernel/iommu_groups/9/devices/0000:07:00.0
/sys/kernel/iommu_groups/10/devices/0000:07:00.1
/sys/kernel/iommu_groups/10/devices/0000:07:00.2
/sys/kernel/iommu_groups/10/devices/0000:07:00.3
/sys/kernel/iommu_groups/10/devices/0000:07:00.4
/sys/kernel/iommu_groups/10/devices/0000:07:00.6

Conclusion:=20
Motherboard BIOS version F41 is still the best. BIOS versions F42h and F50 =
don't work at all.
With BIOS version F41, the IOMMU group is 7. Within IOMMU group 7, only NVI=
DIA GTX1650 GPU exists.
With BIOS versions F42h and F50, the IOMMU group is 0 and there are too man=
y devices within this group (cannot work).

Using Linux kernel 5.5.1 encountered some problem.

Linux command: sudo ./windows10vm.sh

Output:

qemu-system-x86_64: -balloon none: warning: This option is deprecated. Use =
'--device virtio-balloon' to enable the balloon device.
qemu-system-x86_64: -device vfio-pci,host=3D01:00.0,multifunction=3Don: vfi=
o error: 0000:01:00.0: failed to open /dev/vfio/7: No such file or director=
y

Any changes in /etc/modprobe.d require you to update the initramfs. Enter a=
t the command line:

Linux command: sudo update-initramfs -u

Linux command: sudo reboot

Linux command: sudo update-grub

Linux command: sudo reboot

Linux kernel 5.5.1 is still having some issues with loading vfio-pci kernel=
 module.

Falling back to Linux kernel 5.3.0.

Checked. Linux kernel 5.3.0 has no issues. Use Linux kernel 5.3.0 all the w=
ay.

However, Windows 10 virtual machine still giving me BSOD with IRQL NOT LESS=
 OR EQUAL Stop Code.

2 Feb 2020 Sunday 5 PM Singapore Time: I am very lost. I don't know what to=
 do next. Some experts please help.

Thank you very much.

Resumed troubleshooting at 8.17 PM Singapore Time on 2 Feb 2020 Sunday.

REFERENCE
=3D=3D=3D=3D=3D=3D=3D=3D=3D

Discussion Thread: Gpu passthrough vfio blue screen

Link: https://forum.level1techs.com/t/gpu-passthrough-vfio-blue-screen/1328=
08

According to this discussion thread, any Windows 10 version 1803 and above =
will result in a BSOD with IRQL NOT LESS OR EQUAL Stop Code
during installation of the Windows 10 virtual machine.

I am going to download Windows 10 version 1709 from the following download =
link.

Link: https://tb.rg-adguard.net/public.php

Please remember to boot up Ubuntu 18.04.3 LTS Desktop Edition host using Li=
nux Kernel 5.3.0 and not Linux Kernel 5.5.1, which doesn't work at all.

Start Windows 10 version 1709 virtual machine with GPU Passthrough

Linux command: sudo ./windows10vm.sh

Windows 10 version 1709 virtual machine completed installation successfully=
.

During the installation of Windows 10 version 1709 virtual machine, it woul=
d not be able to find any virtual harddisk.
Simply install the virtio driver and Windows 10 version 1709 virtual machin=
e will be able to detect the virtual harddisk of 250 GB.

Windows 10 version 1709 virtual machine completed installation successfully=
.

My Windows 10 version 1709 virtual machine already has an internet connecti=
on. So I will not be configuring bridged networking at the moment.

Device Manager > Display adapters > NVIDIA GeForce GTX 1650

NVIDIA GeForce GTX 1650: This device is working properly.

Congratulations to myself! Teo En Ming has successfully passed through MSI =
GeForce GTX 1650 4 GB GDDR5 GPU to Windows 10 version 1709 virtual machine
using Linux KVM on Ubuntu 18.04.3 LTS Desktop Edition host with a 5.3.0 Lin=
ux Kernel.

I am going to do photo editing and 4K UHD video rendering in this Windows 1=
0 1709 virtual machine with GPU Passthrough.

Confirmed Working Script to Start Windows 10 Virtual Machine with GPU Passt=
hrough
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D

#!/bin/bash

vmname=3D"windows10vm"

if ps -ef | grep qemu-system-x86_64 | grep -q multifunction=3Don; then
echo "A passthrough VM is already running." &
exit 1

else

# use pulseaudio
export QEMU_AUDIO_DRV=3Dpa
export QEMU_PA_SAMPLES=3D8192
export QEMU_AUDIO_TIMER_PERIOD=3D99
export QEMU_PA_SERVER=3D/run/user/1000/pulse/native

cp /usr/share/OVMF/OVMF_VARS.fd /tmp/my_vars.fd

qemu-system-x86_64 \
-name $vmname,process=3D$vmname \
-machine type=3Dpc,accel=3Dkvm \
-cpu host,kvm=3Doff \
-smp 3,sockets=3D1,cores=3D3,threads=3D1 \
-m 4G \
-balloon none \
-rtc clock=3Dhost,base=3Dlocaltime \
-serial none \
-parallel none \
-soundhw hda \
-usb \
-device usb-host,vendorid=3D0x0603,productid=3D0x00f2 \
-device usb-host,vendorid=3D0x056e,productid=3D0x0107 \
-device vfio-pci,host=3D01:00.0,multifunction=3Don \
-device vfio-pci,host=3D01:00.1 \
-drive if=3Dpflash,format=3Draw,readonly,file=3D/usr/share/OVMF/OVMF_CODE.f=
d \
-drive if=3Dpflash,format=3Draw,file=3D/tmp/my_vars.fd \
-boot order=3Ddc \
-drive id=3Ddisk0,if=3Dvirtio,cache=3Dnone,format=3Draw,file=3D/home/teo-en=
-ming/win10.img \
-drive file=3D/home/teo-en-ming/win10-1709.iso,index=3D1,media=3Dcdrom \
-drive file=3D/home/teo-en-ming/Downloads/virtio-win-0.1.173.iso,index=3D2,=
media=3Dcdrom=20
#-netdev type=3Dtap,id=3Dnet0,ifname=3Dvmtap0,vhost=3Don \
#-device virtio-net-pci,netdev=3Dnet0,mac=3D00:16:3e:00:01:01
#-vga none \
#-nographic \

exit 0
fi

-----END OF TURRITOPSIS DOHRNII TEO EN MING'S GUIDE-----







-----BEGIN EMAIL SIGNATURE-----

The Gospel for all Targeted Individuals (TIs):

[The New York Times] Microwave Weapons Are Prime Suspect in Ills of
U.S. Embassy Workers

Link:=A0https://www.nytimes.com/2018/09/01/science/sonic-attack-cuba-microw=
ave.html

***************************************************************************=
*****************

Singaporean Mr. Turritopsis Dohrnii Teo En Ming's Academic
Qualifications as at 14 Feb 2019 and refugee seeking attempts at the United=
 Nations Refugee Agency Bangkok (21 Mar 2017), in Taiwan (5 Aug 2019) and A=
ustralia (25 Dec 2019 to 9 Jan 2020):

[1]=A0https://tdtemcerts.wordpress.com/

[2]=A0https://tdtemcerts.blogspot.sg/

[3]=A0https://www.scribd.com/user/270125049/Teo-En-Ming

-----END EMAIL SIGNATURE-----


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7D812A458
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2019 23:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbfLXW5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 17:57:54 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48482 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbfLXW5y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 17:57:54 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBOMsI0x124461;
        Tue, 24 Dec 2019 22:56:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=/dgJ8XuSEwopCmXfGg18AuXhFUHdN3GB/Y4XIlcxZyI=;
 b=BHlHU5eIkhzcnVBY5L45sIQ47YbRIKktvREB94jys27/0DzDY0S3pWHoxR8CP0rpGbcU
 hN0djlTosL1vf1uxdXYhyuSodVNqkDCzDzsMUtUpQQWnHrB2L70j9QjIE0W7izBGyjxR
 SgYSLGE4gXkiW1uWGKaaWaDsWx9wpmA1KuDT+G1/SpmEiKmbio1rEkF/HrhBbHw/5Mic
 yeGFyigN3KzF0Sdoaa28XEFWBIs+KFvNiuCLecObkWDXxe/gXimopiQnROeinCkR9FDp
 JUQKT+4vQ3AJDQSp43anr16r2M3ulDybsBxXc6b2KStAF2dKkE9hwu7irwDqqJzt7ALa ZQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2x1c1qw267-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Dec 2019 22:56:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBOMsCKl068489;
        Tue, 24 Dec 2019 22:56:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2x3nn5tptx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Dec 2019 22:56:21 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBOMuIVZ000679;
        Tue, 24 Dec 2019 22:56:18 GMT
Received: from [192.168.14.112] (/109.64.214.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Dec 2019 14:56:18 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [RESEND RFC 0/2] Paravirtualized Control Register pinning
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <F82D153A-F083-432B-864C-1CF6A02C19DD@oracle.com>
Date:   Wed, 25 Dec 2019 00:56:03 +0200
Cc:     John Andersen <john.s.andersen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, pbonzini@redhat.com, hpa@zytor.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <12D7EEB4-C77E-4BD1-AF61-8B0FBBA2ED05@oracle.com>
References: <20191220192701.23415-1-john.s.andersen@intel.com>
 <F82D153A-F083-432B-864C-1CF6A02C19DD@oracle.com>
To:     Liran Alon <liran.alon@oracle.com>,
        kernel-hardening@lists.openwall.com
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9481 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912240198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9481 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912240198
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+kernel-hardening mailing list.

> On 23 Dec 2019, at 16:30, Liran Alon <liran.alon@oracle.com> wrote:
>=20
>=20
>=20
>> On 20 Dec 2019, at 21:26, John Andersen <john.s.andersen@intel.com> =
wrote:
>>=20
>> Paravirtualized Control Register pinning is a strengthened version of
>> existing protections on the Write Protect, Supervisor Mode Execution =
/
>> Access Protection, and User-Mode Instruction Prevention bits. The
>> existing protections prevent native_write_cr*() functions from =
writing
>> values which disable those bits. This patchset prevents any guest
>> writes to control registers from disabling pinned bits, not just =
writes
>> from native_write_cr*(). This stops attackers within the guest from
>> using ROP to disable protection bits.
>>=20
>> =
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__web.archive.org_web=
_20171029060939_http-3A__www.blackbunny.io_linux-2Dkernel-2Dx86-2D64-2Dbyp=
ass-2Dsmep-2Dkaslr-2Dkptr-5Frestric_&d=3DDwIDAg&c=3DRoP1YumCXCgaWHvlZYR8PZ=
h8Bv7qIrMUB65eapI_JnE&r=3DJk6Q8nNzkQ6LJ6g42qARkg6ryIDGQr-yKXPNGZbpTx0&m=3D=
-H3SsRpu0sEBqqn9-OOVimBDXk6TimcJerlu4-ko5Io&s=3DTrjU4_UEZIoYjxtoXcjsA8Riu0=
QZ8eI7a4fH96hSBQc&e=3D=20
>>=20
>> The protection is implemented by adding MSRs to KVM which contain the
>> bits that are allowed to be pinned, and the bits which are pinned. =
The
>> guest or userspace can enable bit pinning by reading MSRs to check
>> which bits are allowed to be pinned, and then writing MSRs to set =
which
>> bits they want pinned.
>>=20
>> Other hypervisors such as HyperV have implemented similar protections
>> for Control Registers and MSRs; which security researchers have found
>> effective.
>>=20
>> =
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.abatchy.com_201=
8_01_kernel-2Dexploitation-2D4&d=3DDwIDAg&c=3DRoP1YumCXCgaWHvlZYR8PZh8Bv7q=
IrMUB65eapI_JnE&r=3DJk6Q8nNzkQ6LJ6g42qARkg6ryIDGQr-yKXPNGZbpTx0&m=3D-H3SsR=
pu0sEBqqn9-OOVimBDXk6TimcJerlu4-ko5Io&s=3DFg3e-BSUebNg44Ocp_y19xIoK0HJEHPW=
2AgM958F3Uc&e=3D=20
>>=20
>=20
> I think it=E2=80=99s important to mention how Hyper-V implements this =
protection as it is done in a very different architecture.
>=20
> Hyper-V implements a set of PV APIs named VSM (Virtual Secure Mode) =
aimed to allow a guest (partition) to separate itself to multiple =
security domains called VTLs (Virtual Trust Level).
> The VSM API expose an interface to higher VTLs to control the =
execution of lower VTLs. In theory, VSM supports up to 16 VTLs, but =
Windows VBS (Virtualization Based Security) that is
> the only current technology which utilise VSM, use only 2 VTLs. VTL0 =
for most of OS execution (Normal-Mode) and VTL1 for a secure OS =
execution (Secure-Mode).
>=20
> Higher VTL controls execution of lower VTL by the following VSM =
mechanisms:
> 1) Memory Access Protections: Allows higher VTL to restrict memory =
access to physical pages. Either making them inaccessible or limited to =
certain permissions.
> 2) Secure Intercepts: Allows a higher VTL to request hypervisor to =
intercept certain events in lower VTLs for handling by higher VTL. This =
includes access to system registers (e.g. CRs & MSRs).
>=20
> VBS use above mentioned mechanisms as follows:
> a) Credentials Guard: Prevents pass-the-hash attacks. Done by =
encrypting credentials using a VTL1 trustlet to encrypt them by an =
encryption-key stored in VTL1-only accessible memory.
> b) HVCI (Hypervisor-based Code-Integrity): Prevents execution of =
unsigned code. Done by marking all EPT entries with NX until signature =
verified by VTL1 service. Once verified, mark EPT entries as RO+X.
> (HVCI also supports enforcing code-signing only on Ring0 code =
efficiently by utilising Intel MBEC or AMD GMET CPU features. Which =
allows setting NX-bit on EPT entries based on guest CPL).
> c) KDP (Kernel Data Protection): Marks certain pages after =
initialisation as read-only on VTL0 EPT.
> d) kCFG (Kernel Control-Flow Guard): VTL1 protects bitmap,specifying =
valid indirect branch targets, by protecting it with read-only on VTL0 =
EPT.
> e) HyperGuard: VTL1 use =E2=80=9CSecure Intercepts=E2=80=9D mechanism =
to prevent VTL0 from modifying important system registers. Including CR0 =
& CR4 as done by this patch.
>    HyperGuard also implements a mechanism named NPIEP (Non-Privileged =
Instruction Execution Prevention) that prevents VTL0 Ring3 executing =
SIDT/SGDT/SLDT/STR to leak Ring0 addresses.
>=20
> To sum-up, In Hyper-V, the hypervisor expose a relatively thin API to =
allow guest to partition itself to multiple security domains (enforced =
by virtualization).
> Using this framework, it=E2=80=99s possible to implement multiple =
OS-level protection mechanisms. Only one of them are pinning certain =
registers to specific values as done by this patch.
>=20
> Therefore, as I also tried to say in recent KVM Forum, I think KVM =
should consider exposing a VSM-like API to guest to allow various guest =
OS,
> Including Linux, to implement VBS-like features. To decide on how this =
API should look like, we need to have a more broad discussion with Linux
> Security maintainers and KVM maintainers on which security features we =
would like to implement using such API and what should be their =
architecture.
> Then, we can implement this API in KVM and start to gradually =
introduce more security features in Linux which utilise this API.
>=20
> Once Linux will have security features implemented with this new KVM =
API, we could also consider implementing them on top of other similar =
hypervisor APIs
> such as Hyper-V VSM. To achieve, for example, Linux being more secure =
when running on Microsoft Azure compute instances.
>=20
> Therefore, I see this patch as a short-term solution to quickly gain =
real security value on a very specific issue.
> But if we are serious about improving Linux security using =
Virtualization, we should have this more broad discussion.
>=20
> -Liran
>=20


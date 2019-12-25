Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC2A112A81D
	for <lists+kvm@lfdr.de>; Wed, 25 Dec 2019 14:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfLYNGo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Dec 2019 08:06:44 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:32868 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbfLYNGn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Dec 2019 08:06:43 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBPD01FJ097769;
        Wed, 25 Dec 2019 13:05:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=YZuWUi/KOIjuQaGW9DH+AaTzsplDdQe1sbQ+GLC+Pk8=;
 b=qAz1KrykNZq3VMdc3BmLTALpia/Ppw1yVEhBar+HIBe/MjbsuK49yt66UNLicgwUqNw+
 0vewTAUCIiVpfuMo4VrLxhIIktdG3PvARcZ9Y7V25W12wJdPwF4xMqj56mVPvNDfeZWv
 4yFEHpln9y1d1ZwSok9rC1BTBZsFrlthFA30fbRBCoR0OxVMymdaq4y5AQD08KsXAeGg
 OgIGqVyHW3+6Fe9e4Ds61meEysLIZD0WVE+7bjKaL4n5hTFwGMph2o6SUSY+J06zKs+q
 JmEE8EyC862Dldg9ys2rp7g/mKLjqKObAP3WMReOdr8Z32f8wZR1DVkcxdb9YMzufAYA Iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2x1c1qy97s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Dec 2019 13:05:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBPD3rCY002193;
        Wed, 25 Dec 2019 13:05:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2x3nn6fned-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Dec 2019 13:05:33 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBPD5TaY029567;
        Wed, 25 Dec 2019 13:05:29 GMT
Received: from [192.168.14.112] (/79.180.210.71)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Dec 2019 05:05:28 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [RESEND RFC 0/2] Paravirtualized Control Register pinning
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <CALCETrXpLxdnzQjjJcaEi6B8NwLR7uv2REwcdM5ZXFUQsXgM6Q@mail.gmail.com>
Date:   Wed, 25 Dec 2019 15:05:23 +0200
Cc:     John Andersen <john.s.andersen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3A97EC6A-B8B4-44E7-89FA-71D3407CB3D7@oracle.com>
References: <20191220192701.23415-1-john.s.andersen@intel.com>
 <F82D153A-F083-432B-864C-1CF6A02C19DD@oracle.com>
 <CALCETrXpLxdnzQjjJcaEi6B8NwLR7uv2REwcdM5ZXFUQsXgM6Q@mail.gmail.com>
To:     Andy Lutomirski <luto@kernel.org>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9481 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912250110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9481 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912250110
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 25 Dec 2019, at 4:04, Andy Lutomirski <luto@kernel.org> wrote:
>=20
> On Mon, Dec 23, 2019 at 6:31 AM Liran Alon <liran.alon@oracle.com> =
wrote:
>>=20
>>=20
>>=20
>>> On 20 Dec 2019, at 21:26, John Andersen <john.s.andersen@intel.com> =
wrote:
>>>=20
>>> Paravirtualized Control Register pinning is a strengthened version =
of
>>> existing protections on the Write Protect, Supervisor Mode Execution =
/
>>> Access Protection, and User-Mode Instruction Prevention bits. The
>>> existing protections prevent native_write_cr*() functions from =
writing
>>> values which disable those bits. This patchset prevents any guest
>>> writes to control registers from disabling pinned bits, not just =
writes
>>> from native_write_cr*(). This stops attackers within the guest from
>>> using ROP to disable protection bits.
>>>=20
>>> =
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__web.archive.org_web=
_20171029060939_http-3A__www.blackbunny.io_linux-2Dkernel-2Dx86-2D64-2Dbyp=
ass-2Dsmep-2Dkaslr-2Dkptr-5Frestric_&d=3DDwIDAg&c=3DRoP1YumCXCgaWHvlZYR8PZ=
h8Bv7qIrMUB65eapI_JnE&r=3DJk6Q8nNzkQ6LJ6g42qARkg6ryIDGQr-yKXPNGZbpTx0&m=3D=
-H3SsRpu0sEBqqn9-OOVimBDXk6TimcJerlu4-ko5Io&s=3DTrjU4_UEZIoYjxtoXcjsA8Riu0=
QZ8eI7a4fH96hSBQc&e=3D
>>>=20
>>> The protection is implemented by adding MSRs to KVM which contain =
the
>>> bits that are allowed to be pinned, and the bits which are pinned. =
The
>>> guest or userspace can enable bit pinning by reading MSRs to check
>>> which bits are allowed to be pinned, and then writing MSRs to set =
which
>>> bits they want pinned.
>>>=20
>>> Other hypervisors such as HyperV have implemented similar =
protections
>>> for Control Registers and MSRs; which security researchers have =
found
>>> effective.
>>>=20
>>> =
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.abatchy.com_201=
8_01_kernel-2Dexploitation-2D4&d=3DDwIDAg&c=3DRoP1YumCXCgaWHvlZYR8PZh8Bv7q=
IrMUB65eapI_JnE&r=3DJk6Q8nNzkQ6LJ6g42qARkg6ryIDGQr-yKXPNGZbpTx0&m=3D-H3SsR=
pu0sEBqqn9-OOVimBDXk6TimcJerlu4-ko5Io&s=3DFg3e-BSUebNg44Ocp_y19xIoK0HJEHPW=
2AgM958F3Uc&e=3D
>>>=20
>>=20
>> I think it=E2=80=99s important to mention how Hyper-V implements this =
protection as it is done in a very different architecture.
>>=20
>> Hyper-V implements a set of PV APIs named VSM (Virtual Secure Mode) =
aimed to allow a guest (partition) to separate itself to multiple =
security domains called VTLs (Virtual Trust Level).
>> The VSM API expose an interface to higher VTLs to control the =
execution of lower VTLs. In theory, VSM supports up to 16 VTLs, but =
Windows VBS (Virtualization Based Security) that is
>> the only current technology which utilise VSM, use only 2 VTLs. VTL0 =
for most of OS execution (Normal-Mode) and VTL1 for a secure OS =
execution (Secure-Mode).
>>=20
>> Higher VTL controls execution of lower VTL by the following VSM =
mechanisms:
>> 1) Memory Access Protections: Allows higher VTL to restrict memory =
access to physical pages. Either making them inaccessible or limited to =
certain permissions.
>> 2) Secure Intercepts: Allows a higher VTL to request hypervisor to =
intercept certain events in lower VTLs for handling by higher VTL. This =
includes access to system registers (e.g. CRs & MSRs).
>>=20
>> VBS use above mentioned mechanisms as follows:
>> a) Credentials Guard: Prevents pass-the-hash attacks. Done by =
encrypting credentials using a VTL1 trustlet to encrypt them by an =
encryption-key stored in VTL1-only accessible memory.
>> b) HVCI (Hypervisor-based Code-Integrity): Prevents execution of =
unsigned code. Done by marking all EPT entries with NX until signature =
verified by VTL1 service. Once verified, mark EPT entries as RO+X.
>> (HVCI also supports enforcing code-signing only on Ring0 code =
efficiently by utilising Intel MBEC or AMD GMET CPU features. Which =
allows setting NX-bit on EPT entries based on guest CPL).
>> c) KDP (Kernel Data Protection): Marks certain pages after =
initialisation as read-only on VTL0 EPT.
>> d) kCFG (Kernel Control-Flow Guard): VTL1 protects bitmap,specifying =
valid indirect branch targets, by protecting it with read-only on VTL0 =
EPT.
>> e) HyperGuard: VTL1 use =E2=80=9CSecure Intercepts=E2=80=9D mechanism =
to prevent VTL0 from modifying important system registers. Including CR0 =
& CR4 as done by this patch.
>>    HyperGuard also implements a mechanism named NPIEP (Non-Privileged =
Instruction Execution Prevention) that prevents VTL0 Ring3 executing =
SIDT/SGDT/SLDT/STR to leak Ring0 addresses.
>>=20
>> To sum-up, In Hyper-V, the hypervisor expose a relatively thin API to =
allow guest to partition itself to multiple security domains (enforced =
by virtualization).
>> Using this framework, it=E2=80=99s possible to implement multiple =
OS-level protection mechanisms. Only one of them are pinning certain =
registers to specific values as done by this patch.
>>=20
>> Therefore, as I also tried to say in recent KVM Forum, I think KVM =
should consider exposing a VSM-like API to guest to allow various guest =
OS,
>> Including Linux, to implement VBS-like features. To decide on how =
this API should look like, we need to have a more broad discussion with =
Linux
>> Security maintainers and KVM maintainers on which security features =
we would like to implement using such API and what should be their =
architecture.
>> Then, we can implement this API in KVM and start to gradually =
introduce more security features in Linux which utilise this API.
>=20
> How about having KVM implement the VSM API directly?

Hyper-V VSM API is tightly coupled to the rest of Hyper-V PV interface. =
Therefore, KVM could only implement VSM API as-is
as part of it=E2=80=99s Hyper-V PV interface emulation implementation. =
Because we don=E2=80=99t wish to expose Hyper-V PV interface by default
to all KVM guests, KVM should have it=E2=80=99s own variant providing =
similar capabilities.

In addition, in my opinion there are some bad design choices in VSM API =
I haven=E2=80=99t mentioned in my previous message. Which KVM
VSM-like API would maybe want to do differently to avoid those mistakes. =
For example, VSM API by design assumes that a given VTL
is superior and control every aspect of all VTLs lower than it. In =
Windows VBS, this have caused securekernel (Sk) running in VTL1 to
be part of TCB and therefore significantly enlarge it. In contrast, for =
example, to QubesOS where OS is split to security-domains that
each have well-defined capabilities but none have full capabilities as =
VTL1 have in VBS. Therefore, it preserves only the hypervisor
in TCB as it should.

Having said that, I am already working on a patch-series to enhance KVM =
Hyper-V PV interface implementation to also include VSM.
As I have mentioned in recent KVM Forum, I wish to do so to make modern =
Windows OS with VBS support running on top of KVM,
to not need to run Hyper-V inside the KVM guest (i.e. Leading to =
nested-virtualization workload). When Windows detect it=E2=80=99s =
already
running as a guest on top of Hyper-V with VSM support, it uses =
underlying hypervisor VSM API to implement VBS. Without loading
Hyper-V inside the guest. Therefore, improving performance & semantics =
of Windows VBS guests on top of KVM.

Note though, that my work of implementing VSM in KVM Hyper-V PV =
interface implementation isn=E2=80=99t related to the discussion here.
Which is: How should Linux be modified to take advantage of a VSM-like =
API to implement security mitigations features as those
I described above that Windows VBS implement on top of such API. =
Deciding on the design of those features, will also guideline
what should be the KVM PV VSM-like API we should implement.

-Liran


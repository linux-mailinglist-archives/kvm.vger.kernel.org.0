Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B53C912A41C
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2019 21:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfLXUhY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 15:37:24 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:56358 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfLXUhY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 15:37:24 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBOKY2Jb043693;
        Tue, 24 Dec 2019 20:35:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=lNCF4RZKGjVUIUjuki0UL6qlAXZJd6vY+N1gl3J6aqM=;
 b=fE4cc+UILaBonFrEj8cDhuqR6xb7sykQY/opaEI1qmnFcuuMHC//LGkl+crrGKRtVaUG
 p+9BnsmO6MCCTxVCpUlXjrbk34iGUWbEFKoUxW2kxNMZE6uIZRmWpAiaJIsOOpYnoD/o
 ifRXup++98Bsm6K9o0ZDdsZkuRnR1QyyPTisz0Rjpy+vYtZ/7V8apolLCHse1lv3VTOo
 0UwJuYBlzCH+CkfjbrsX62PhDBfWQnqZc+82AP4FAb+hnNnqzo98/UkDc0pIiwK5EYoK
 qMZ3SvaX8gzyDry+OQFCKFfsmdIyGT19FxBNpsylx84OlGSTSHKucf5z2s514XNRs5Mj PQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2x1c1qvur0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Dec 2019 20:35:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBOKTMWL151477;
        Tue, 24 Dec 2019 20:35:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2x3amshsk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Dec 2019 20:35:50 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBOKZnKJ019145;
        Tue, 24 Dec 2019 20:35:49 GMT
Received: from [192.168.14.112] (/109.64.214.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Dec 2019 12:35:49 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [RESEND RFC 0/2] Paravirtualized Control Register pinning
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <73950aff51bdf908f75ffa5e5cb629fc1d4ebbb6.camel@intel.com>
Date:   Tue, 24 Dec 2019 22:35:43 +0200
Cc:     "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>, "bp@alien8.de" <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <91A51486-9CE8-4041-AAB2-0507D42C5A72@oracle.com>
References: <20191220192701.23415-1-john.s.andersen@intel.com>
 <1EBCD42E-9109-47A1-B959-6363A509D48D@oracle.com>
 <73950aff51bdf908f75ffa5e5cb629fc1d4ebbb6.camel@intel.com>
To:     "Andersen, John S" <john.s.andersen@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9481 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912240180
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9481 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912240181
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 24 Dec 2019, at 21:44, Andersen, John S <john.s.andersen@intel.com> =
wrote:
>=20
> On Mon, 2019-12-23 at 16:48 +0200, Liran Alon wrote:
>>> On 20 Dec 2019, at 21:26, John Andersen <john.s.andersen@intel.com>
>>> wrote:
>>>=20
>>> Pinning is not active when running in SMM. Entering SMM disables
>>> pinned
>>> bits, writes to control registers within SMM would therefore
>>> trigger
>>> general protection faults if pinning was enforced.
>>=20
>> For compatibility reasons, it=E2=80=99s reasonable that pinning =
won=E2=80=99t be
>> active when running in SMM.
>> However, I do think we should not allow vSMM code to change pinned
>> values when returning back from SMM.
>> This would prevent a vulnerable vSMI handler from modifying vSMM
>> state-area to modify CR4 when running outside of vSMM.
>> I believe in this case it=E2=80=99s legit to just forcibly restore =
original
>> CR0/CR4 pinned values. Ignoring vSMM changes.
>>=20
>=20
> In em_rsm could we just OR with the value of the PINNED MSRs right
> before the final return?

Not exactly.

If I understand correctly, the proposed mechanism should also allow =
pinning specific
system registers (e.g. CR0/CR4) bits to either being cleared or being =
set. Not necessarily being set.
As kvm_set_cr0() & kvm_set_cr4() were modified to only check if pinned =
bit changed value.

Therefore, you should modify enter_smm() to save current pinned bits =
values
and then silently restore their values on em_rsm().

>=20
>>> The guest may never read pinned bits. If an attacker were to read
>>> the
>>> CR pinned MSRs, they might decide to preform another attack which
>>> would
>>> not cause a general protection fault.
>>=20
>> I disagree with this statement.
>> An attacker knows what is the system it is attacking and can deduce
>> by that which bits it pinned=E2=80=A6
>> Therefore, protecting from guest reading these is not important at
>> all.
>>=20
>=20
> Sure, I'll make it readable.
>=20
>>> Should userspace expose the CR pining CPUID feature bit, it must
>>> zero CR
>>> pinned MSRs on reboot. If it does not, it runs the risk of having
>>> the
>>> guest enable pinning and subsequently cause general protection
>>> faults on
>>> next boot due to early boot code setting control registers to
>>> values
>>> which do not contain the pinned bits.
>>=20
>> Why reset CR pinned MSRs by userspace instead of KVM INIT handling?
>>=20
>>> When running with KVM guest support and paravirtualized CR pinning
>>> enabled, paravirtualized and existing pinning are setup at the same
>>> point on the boot CPU. Non-boot CPUs setup pinning upon
>>> identification.
>>>=20
>>> Guests using the kexec system call currently do not support
>>> paravirtualized control register pinning. This is due to early boot
>>> code writing known good values to control registers, these values
>>> do
>>> not contain the protected bits. This is due to CPU feature
>>> identification being done at a later time, when the kernel properly
>>> checks if it can enable protections.
>>>=20
>>> Most distributions enable kexec. However, kexec could be made boot
>>> time
>>> disableable. In this case if a user has disabled kexec at boot time
>>> the guest will request that paravirtualized control register
>>> pinning
>>> be enabled. This would expand the userbase to users of major
>>> distributions.
>>>=20
>>> Paravirtualized CR pinning will likely be incompatible with kexec
>>> for
>>> the foreseeable future. Early boot code could possibly be changed
>>> to
>>> not clear protected bits. However, a kernel that requests CR bits
>>> be
>>> pinned can't know if the kernel it's kexecing has been updated to
>>> not
>>> clear protected bits. This would result in the kernel being kexec'd
>>> almost immediately receiving a general protection fault.
>>=20
>> Instead of disabling kexec entirely, I think it makes more sense to
>> invent
>> some generic mechanism in which new kernel can describe to old kernel
>> a set of flags that specifies which features hand-over it supports.
>> One of them
>> being pinned CRs.
>>=20
>> For example, isn=E2=80=99t this also relevant for IOMMU DMA =
protection?
>> i.e. Doesn=E2=80=99t old kernel need to know if it should disable or =
enable
>> IOMMU DMAR
>> before kexec to new kernel? Similar to EDK2 IOMMU DMA protection
>> hand-over?
>=20
> Great idea.
>=20
> Making kexec work will require changes to these files and maybe more:
>=20
> arch/x86/boot/compressed/head_64.S
> arch/x86/kernel/head_64.S
> arch/x86/kernel/relocate_kernel_64.S
>=20
> Which my previous attempts showed different results when running
> virtualized vs. unvirtualized. Specificity different behavior with =
SMAP
> and UMIP bits.

I didn=E2=80=99t understand why there should be different results when =
running virtualized or not.

What I suggested is to just add metadata in a vmlinux ELF section that =
will be designated to
describe vmlinux handover capabilities.

Then, kexec functionality can be modified to read this section before =
loading & jumping
to new kernel vmlinux.

In the context of this patch-set, this section will specify a flag of if =
new vmlinux supports
CR0/CR4 pinning hand-over. If not and current kernel already pinned =
these values,
kexec should just return failure.

Just for example, in the context of IOMMU DMA protection hand-over, =
kexec will
use another flag to new of new vmlinux supports IOMMU DMA protection =
hand-over,
and if not, make sure to disable IOMMU before jumping to new vmlinux.

>=20
> This would be a longer process though. As validating that everything
> still works in both the VM and on physical hosts will be required. As
> it stands this patchset could pick up a fairly large userbase via the
> virtualized container projects. Should we pursue kexec in this =
patchset
> or a later one?

In my opinion, this should be handled as part of this patch-series.
Otherwise, you basically introduce a kernel change that breaks existing =
functionality
in unpredictable manner to user.

i.e. It=E2=80=99s ok of kernel would haven=E2=80=99t allowed to use =
system registers pinning functionality
unless user also configured at boot-time that it disables kexec. But =
it=E2=80=99s not ok for
kernel behaviour to change such that kexec suddenly crashes if kernel =
was upgraded
to now use system registers pinning.

My personal opinion though is that kexec should first be enhanced to =
read hand-over metadata
as I described. And only then apply this patch-series which also =
modifies kexec to define and use
one of the hand-over bits as I mentioned above. But I would like to hear =
additional opinions on this.

In addition, I would like to understand Linux security maintainers point =
of view on the comment
I mentioned in another reply regarding how this mechanism is implemented =
in Hyper-V.

-Liran

>=20
> Thanks,
> John


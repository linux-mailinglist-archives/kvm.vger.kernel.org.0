Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F16D1BF00
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 23:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfEMVJd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 17:09:33 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:50704 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbfEMVJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 17:09:32 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DL3koI146771;
        Mon, 13 May 2019 21:08:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=etxC2fIO+k7WqJJbgmpaQKX6DDfUoMBtn3qTvkFV+tE=;
 b=FSfBXyohrOkcDcJUQjU9IbWERTb6TScchNOdnSNATyPYzF7SZ0/RAhT0ZrdjyrPMnhQj
 h4RPVcu565duvAFebok/LJcd3c+xOgFjoqRauIXFjbEJdhkRIGze08wA7ECcSvhk9i93
 E6X7epEf32cPFEeU2/FPfvjsJ9PLMW1Sy5Pn/KT6EkP/xN5fE+ebLUMdOpjI3KJ6CHpK
 TmS0Hmd3gx43vcCfYcH8WTla1Bup+aUHzerBHUIbKaD8IgaIATMHWplVrL8bftDDajWD
 cNf3OemKPk7HniAOw7L0LkBrGsprAuU21bairPt9pBdhGlGDr+TYe4lgM+ZDHyPjmbeR nA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 2sdkwdj031-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 21:08:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DL7aVk089303;
        Mon, 13 May 2019 21:08:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2se0tvskr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 21:08:42 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4DL8TlR001785;
        Mon, 13 May 2019 21:08:36 GMT
Received: from [192.168.14.112] (/79.180.238.224)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 May 2019 14:08:29 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [RFC KVM 00/27] KVM Address Space Isolation
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <CALCETrVhRt0vPgcun19VBqAU_sWUkRg1RDVYk4osY6vK0SKzgg@mail.gmail.com>
Date:   Tue, 14 May 2019 00:08:23 +0300
Cc:     Alexandre Chartre <alexandre.chartre@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, Jonathan Adams <jwadams@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C2A30CC6-1459-4182-B71A-D8FF121A19F2@oracle.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <CALCETrVhRt0vPgcun19VBqAU_sWUkRg1RDVYk4osY6vK0SKzgg@mail.gmail.com>
To:     Andy Lutomirski <luto@kernel.org>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905130141
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130140
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 13 May 2019, at 21:17, Andy Lutomirski <luto@kernel.org> wrote:
>=20
>> I expect that the KVM address space can eventually be expanded to =
include
>> the ioctl syscall entries. By doing so, and also adding the KVM page =
table
>> to the process userland page table (which should be safe to do =
because the
>> KVM address space doesn't have any secret), we could potentially =
handle the
>> KVM ioctl without having to switch to the kernel pagetable (thus =
effectively
>> eliminating KPTI for KVM). Then the only overhead would be if a =
VM-Exit has
>> to be handled using the full kernel address space.
>>=20
>=20
> In the hopefully common case where a VM exits and then gets re-entered
> without needing to load full page tables, what code actually runs?
> I'm trying to understand when the optimization of not switching is
> actually useful.
>=20
> Allowing ioctl() without switching to kernel tables sounds...
> extremely complicated.  It also makes the dubious assumption that user
> memory contains no secrets.

Let me attempt to clarify what we were thinking when creating this patch =
series:

1) It is never safe to execute one hyperthread inside guest while it=E2=80=
=99s sibling hyperthread runs in a virtual address space which contains =
secrets of host or other guests.
This is because we assume that using some speculative gadget (such as =
half-Spectrev2 gadget), it will be possible to populate *some* CPU core =
resource which could then be *somehow* leaked by the hyperthread running =
inside guest. In case of L1TF, this would be data populated to the L1D =
cache.

2) Because of (1), every time a hyperthread runs inside host kernel, we =
must make sure it=E2=80=99s sibling is not running inside guest. i.e. We =
must kick the sibling hyperthread outside of guest using IPI.

3) =46rom (2), we should have theoretically deduced that for every =
#VMExit, there is a need to kick the sibling hyperthread also outside of =
guest until the #VMExit is completed. Such a patch series was =
implemented at some point but it had (obviously) significant performance =
hit.

4) The main goal of this patch series is to preserve (2), but to avoid =
the overhead specified in (3).

The way this patch series achieves (4) is by observing that during the =
run of a VM, most #VMExits can be handled rather quickly and locally =
inside KVM and doesn=E2=80=99t need to reference any data that is not =
relevant to this VM or KVM code. Therefore, if we will run these =
#VMExits in an isolated virtual address space (i.e. KVM isolated address =
space), there is no need to kick the sibling hyperthread from guest =
while these #VMExits handlers run.
The hope is that the very vast majority of #VMExit handlers will be able =
to completely run without requiring to switch to full address space. =
Therefore, avoiding the performance hit of (2).
However, for the very few #VMExits that does require to run in full =
kernel address space, we must first kick the sibling hyperthread outside =
of guest and only then switch to full kernel address space and only once =
all hyperthreads return to KVM address space, then allow then to enter =
into guest.

=46rom this reason, I think the above paragraph (that was added to my =
original cover letter) is incorrect.
I believe that we should by design treat all exits to userspace VMM =
(e.g. QEMU) as slow-path that should not be optimised and therefore ok =
to switch address space (and therefore also kick sibling hyperthread). =
Similarly, all IOCTLs handlers are also slow-path and therefore it =
should be ok for them to also not run in KVM isolated address space.

-Liran










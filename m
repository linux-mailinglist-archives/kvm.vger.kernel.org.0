Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C75E41297B5
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 15:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfLWOuH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Dec 2019 09:50:07 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52606 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfLWOuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Dec 2019 09:50:07 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBNEiIml169711;
        Mon, 23 Dec 2019 14:48:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=g1lVZdT0RoWUN9y8SokwmqP2SGuxF5i/i86SBNZiQds=;
 b=LDuKe9//v4ay+bf3g1FibZG9un9+hdeH/0RDEu6jW++K2YiQRUsG/7YldJb5Ih0+5+gt
 TfuIxUEYRP3EgKUNvzAPqITeKBm7Aqbqug7dY/Ib3FcJvGOC4HvdXdvo3IOriyqZCPGZ
 T3xS6nW4vfXZn6otPrw7MSndxzq2HpxEI9BNXkTl3pY11NKvm2CaSDcw468g0IBHSJgM
 6V0NWLfV9xu0emV1SakUnqFZaWcrYZEP9vtgXmKgB/ZZsSlOLGjkKs0Xk79rrZQFMQpT
 aOdUXt0r0pYLGB+nMBVaXwU+5fFQ1hKooBreXN+8WdHyzUsjn5cdjl4qv93ESJ0oOJrQ GQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2x1bbpq876-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Dec 2019 14:48:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBNEiZnk116250;
        Mon, 23 Dec 2019 14:48:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2x1wh3cvg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Dec 2019 14:48:39 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBNEmc1C003148;
        Mon, 23 Dec 2019 14:48:38 GMT
Received: from [192.168.14.112] (/109.64.214.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Dec 2019 06:48:38 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [RESEND RFC 0/2] Paravirtualized Control Register pinning
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20191220192701.23415-1-john.s.andersen@intel.com>
Date:   Mon, 23 Dec 2019 16:48:33 +0200
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        pbonzini@redhat.com, hpa@zytor.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1EBCD42E-9109-47A1-B959-6363A509D48D@oracle.com>
References: <20191220192701.23415-1-john.s.andersen@intel.com>
To:     John Andersen <john.s.andersen@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9479 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=817
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912230127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9479 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=883 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912230127
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 20 Dec 2019, at 21:26, John Andersen <john.s.andersen@intel.com> =
wrote:
>=20
> Pinning is not active when running in SMM. Entering SMM disables =
pinned
> bits, writes to control registers within SMM would therefore trigger
> general protection faults if pinning was enforced.

For compatibility reasons, it=E2=80=99s reasonable that pinning won=E2=80=99=
t be active when running in SMM.
However, I do think we should not allow vSMM code to change pinned =
values when returning back from SMM.
This would prevent a vulnerable vSMI handler from modifying vSMM =
state-area to modify CR4 when running outside of vSMM.
I believe in this case it=E2=80=99s legit to just forcibly restore =
original CR0/CR4 pinned values. Ignoring vSMM changes.

>=20
> The guest may never read pinned bits. If an attacker were to read the
> CR pinned MSRs, they might decide to preform another attack which =
would
> not cause a general protection fault.

I disagree with this statement.
An attacker knows what is the system it is attacking and can deduce by =
that which bits it pinned=E2=80=A6
Therefore, protecting from guest reading these is not important at all.

>=20
> Should userspace expose the CR pining CPUID feature bit, it must zero =
CR
> pinned MSRs on reboot. If it does not, it runs the risk of having the
> guest enable pinning and subsequently cause general protection faults =
on
> next boot due to early boot code setting control registers to values
> which do not contain the pinned bits.

Why reset CR pinned MSRs by userspace instead of KVM INIT handling?

>=20
> When running with KVM guest support and paravirtualized CR pinning
> enabled, paravirtualized and existing pinning are setup at the same
> point on the boot CPU. Non-boot CPUs setup pinning upon =
identification.
>=20
> Guests using the kexec system call currently do not support
> paravirtualized control register pinning. This is due to early boot
> code writing known good values to control registers, these values do
> not contain the protected bits. This is due to CPU feature
> identification being done at a later time, when the kernel properly
> checks if it can enable protections.
>=20
> Most distributions enable kexec. However, kexec could be made boot =
time
> disableable. In this case if a user has disabled kexec at boot time
> the guest will request that paravirtualized control register pinning
> be enabled. This would expand the userbase to users of major
> distributions.
>=20
> Paravirtualized CR pinning will likely be incompatible with kexec for
> the foreseeable future. Early boot code could possibly be changed to
> not clear protected bits. However, a kernel that requests CR bits be
> pinned can't know if the kernel it's kexecing has been updated to not
> clear protected bits. This would result in the kernel being kexec'd
> almost immediately receiving a general protection fault.

Instead of disabling kexec entirely, I think it makes more sense to =
invent
some generic mechanism in which new kernel can describe to old kernel
a set of flags that specifies which features hand-over it supports. One =
of them
being pinned CRs.

For example, isn=E2=80=99t this also relevant for IOMMU DMA protection?
i.e. Doesn=E2=80=99t old kernel need to know if it should disable or =
enable IOMMU DMAR
before kexec to new kernel? Similar to EDK2 IOMMU DMA protection =
hand-over?

-Liran


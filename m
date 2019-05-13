Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 327D01BF4A
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 23:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfEMVx6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 17:53:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39012 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbfEMVx6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 17:53:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DLmh82182354;
        Mon, 13 May 2019 21:53:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=2MAMrxNYQf48ug7b7j35h+Pbw3ANRo1Zmpgy9x2jtz4=;
 b=SJSk2/29TyU2Esyuic0VP9KkvsrRaFNxOjBKN1JdBEZ+hRRvLMJH+jVl+zhkySDtgADm
 0c2y4vyYPd8FArWCH8sJSA5mL2zH+guICgatFDQNYeSLKjoAO0G6pxTPWOH6HlAlyTLf
 A6iJg4dYtjAl5Q9Vbi1dW7Ll1XmAkci5vtxx1NPLsg6sDN7SpTaDKG9xo5hDmwoewui9
 jkKZizNsZYycjCYjGIxE0btqKS2ZXAGuyL3TqeCmXdcCN88C/Kb7elSbVxvJrszwUxaG
 o5fL3FSYCvh4Fy5uTuamyfMNq2ngHrfMmAh/Ei4IRwIB3xlyjzpkWMbt7Hm9R3mN35eb 6Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2sdq1q9vbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 21:53:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DLpFh6146440;
        Mon, 13 May 2019 21:53:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2sdmeaqu8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 21:53:09 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4DLr7hD026201;
        Mon, 13 May 2019 21:53:07 GMT
Received: from [192.168.14.112] (/79.180.238.224)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 May 2019 14:53:07 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [RFC KVM 00/27] KVM Address Space Isolation
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <D07C8F51-F2DF-4C8B-AB3B-0DFABD5F4C33@intel.com>
Date:   Tue, 14 May 2019 00:53:00 +0300
Cc:     Alexandre Chartre <alexandre.chartre@oracle.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jan.setjeeilers@oracle.com" <jan.setjeeilers@oracle.com>,
        "jwadams@google.com" <jwadams@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <AB2D3B96-8B31-4183-820D-D4452826FC62@oracle.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <11F6D766-EC47-4283-8797-68A1405511B0@intel.com>
 <46FF68B2-3284-4705-A904-328992449D43@oracle.com>
 <D07C8F51-F2DF-4C8B-AB3B-0DFABD5F4C33@intel.com>
To:     "Nakajima, Jun" <jun.nakajima@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905130145
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130145
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 14 May 2019, at 0:42, Nakajima, Jun <jun.nakajima@intel.com> wrote:
>=20
>=20
>=20
>> On May 13, 2019, at 2:16 PM, Liran Alon <liran.alon@oracle.com> =
wrote:
>>=20
>>> On 13 May 2019, at 22:31, Nakajima, Jun <jun.nakajima@intel.com> =
wrote:
>>>=20
>>> On 5/13/19, 7:43 AM, "kvm-owner@vger.kernel.org on behalf of =
Alexandre Chartre" wrote:
>>>=20
>>>   Proposal
>>>   =3D=3D=3D=3D=3D=3D=3D=3D
>>>=20
>>>   To handle both these points, this series introduce the mechanism =
of KVM
>>>   address space isolation. Note that this mechanism completes =
(a)+(b) and
>>>   don't contradict. In case this mechanism is also applied, (a)+(b) =
should
>>>   still be applied to the full virtual address space as a =
defence-in-depth).
>>>=20
>>>   The idea is that most of KVM #VMExit handlers code will run in a =
special
>>>   KVM isolated address space which maps only KVM required code and =
per-VM
>>>   information. Only once KVM needs to architectually access other =
(sensitive)
>>>   data, it will switch from KVM isolated address space to full =
standard
>>>   host address space. At this point, KVM will also need to kick all =
sibling
>>>   hyperthreads to get out of guest (note that kicking all sibling =
hyperthreads
>>>   is not implemented in this serie).
>>>=20
>>>   Basically, we will have the following flow:
>>>=20
>>>     - qemu issues KVM_RUN ioctl
>>>     - KVM handles the ioctl and calls vcpu_run():
>>>       . KVM switches from the kernel address to the KVM address =
space
>>>       . KVM transfers control to VM (VMLAUNCH/VMRESUME)
>>>       . VM returns to KVM
>>>       . KVM handles VM-Exit:
>>>         . if handling need full kernel then switch to kernel address =
space
>>>         . else continues with KVM address space
>>>       . KVM loops in vcpu_run() or return
>>>     - KVM_RUN ioctl returns
>>>=20
>>>   So, the KVM_RUN core function will mainly be executed using the =
KVM address
>>>   space. The handling of a VM-Exit can require access to the kernel =
space
>>>   and, in that case, we will switch back to the kernel address =
space.
>>>=20
>>> Once all sibling hyperthreads are in the host (either using the full =
kernel address space or user address space), what happens to the other =
sibling hyperthreads if one of them tries to do VM entry? That VCPU will =
switch to the KVM address space prior to VM entry, but others continue =
to run? Do you think (a) + (b) would be sufficient for that case?
>>=20
>> The description here is missing and important part: When a =
hyperthread needs to switch from KVM isolated address space to kernel =
full address space, it should first kick all sibling hyperthreads =
outside of guest and only then safety switch to full kernel address =
space. Only once all sibling hyperthreads are running with KVM isolated =
address space, it is safe to enter guest.
>>=20
>=20
> Okay, it makes sense. So, it will require some synchronization among =
the siblings there.

Definitely.
Currently the kicking of sibling hyperthreads is not integrated yet with =
this patch series. But it should be at some point.

-Liran

>=20
>> The main point of this address space is to avoid kicking all sibling =
hyperthreads on *every* VMExit from guest but instead only kick them =
when switching address space. The assumption is that the vast majority =
of exits can be handled in KVM isolated address space and therefore do =
not require to kick the sibling hyperthreads outside of guest.
>=20
>=20
> ---
> Jun
> Intel Open Source Technology Center


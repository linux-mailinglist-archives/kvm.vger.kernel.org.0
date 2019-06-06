Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED99236F94
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 11:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbfFFJMD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 05:12:03 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45402 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727538AbfFFJMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 05:12:03 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5694PLC048867;
        Thu, 6 Jun 2019 09:11:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=gTZ6qhcG3ZvGmVbNEhsKmEfBmntjrrIggaUVf9+X5w4=;
 b=KfBCngR6qY5Z3KB4uTuxIwFho/46XjP3asVNJXDIg1myZHxDz3PThStzatHNJKr7EAet
 R21h5uRfe+5pQ6g8hTNj04AgqBshKSYoe60k1ypOeThytXw9mLa+9q0YmHc+F8QoRjhD
 sM1vJV0oSLn2lK8Sv6ZSDa21ZUY+JUu3MPmmjn7zxBsiD1ZpmNO0tZjSfmtMnNKVeXOt
 KBzOkdLKctpjqND3iuGvoW6MJr3os2LcdeZ5/k4fEdv6eLAZjTeaZ1TkxY/qKhqHVJ1p
 hCb1KITxIShhuMlEBPuUvS/IRSciOnibzBSS4hoqHyAv0PnbymbmyCLZg1kCL6zrTRYT BA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2suevdqgtf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jun 2019 09:11:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x569B5JA133493;
        Thu, 6 Jun 2019 09:11:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2swnhangxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jun 2019 09:11:19 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x569BHDM001722;
        Thu, 6 Jun 2019 09:11:18 GMT
Received: from [192.168.14.112] (/109.66.241.232)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Jun 2019 02:11:17 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: QEMU/KVM migration backwards compatibility broken?
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190606084222.GA2788@work-vm>
Date:   Thu, 6 Jun 2019 12:11:14 +0300
Cc:     kvm list <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <862DD946-EB3C-405A-BE88-4B22E0B9709C@oracle.com>
References: <38B8F53B-F993-45C3-9A82-796A0D4A55EC@oracle.com>
 <20190606084222.GA2788@work-vm>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9279 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906060067
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9279 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906060067
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 6 Jun 2019, at 11:42, Dr. David Alan Gilbert <dgilbert@redhat.com> =
wrote:
>=20
> * Liran Alon (liran.alon@oracle.com) wrote:
>> Hi,
>>=20
>> Looking at QEMU source code, I am puzzled regarding how migration =
backwards compatibility is preserved regarding X86CPU.
>>=20
>> As I understand it, fields that are based on KVM capabilities and =
guest runtime usage are defined in VMState subsections in order to not =
send them if not necessary.
>> This is done such that in case they are not needed and we migrate to =
an old QEMU which don=E2=80=99t support loading this state, migration =
will still succeed
>> (As .needed() method will return false and therefore this state =
won=E2=80=99t be sent as part of migration stream).
>> Furthermore, in case .needed() returns true and old QEMU don=E2=80=99t =
support loading this state, migration fails. As it should because we are =
aware that guest state
>> is not going to be restored properly on destination.
>>=20
>> I=E2=80=99m puzzled about what will happen in the following scenario:
>> 1) Source is running new QEMU with new KVM that supports save of some =
VMState subsection.
>> 2) Destination is running new QEMU that supports load this state but =
with old kernel that doesn=E2=80=99t know how to load this state.
>>=20
>> I would have expected in this case that if source .needed() returns =
true, then migration will fail because of lack of support in destination =
kernel.
>> However, it seems from current QEMU code that this will actually =
succeed in many cases.
>>=20
>> For example, if msr_smi_count is sent as part of migration stream =
(See vmstate_msr_smi_count) and destination have =
has_msr_smi_count=3D=3Dfalse,
>> then destination will succeed loading migration stream but =
kvm_put_msrs() will actually ignore env->msr_smi_count and will =
successfully load guest state.
>> Therefore, migration will succeed even though it should have =
failed=E2=80=A6
>>=20
>> It seems to me that QEMU should have for every such VMState =
subsection, a .post_load() method that verifies that relevant capability =
is supported by kernel
>> and otherwise fail migration.
>>=20
>> What do you think? Should I really create a patch to modify all these =
CPUX86 VMState subsections to behave like this?
>=20
> I don't know the x86 specific side that much; but from my migration =
side
> the answer should mostly be through machine types - indeed for =
smi-count
> there's a property 'x-migrate-smi-count' which is off for machine =
types
> pre 2.11 (see hw/i386/pc.c pc_compat_2_11) - so if you've got an old
> kernel you should stick to the old machine types.
>=20
> There's nothing guarding running the new machine type on old-kernels;
> and arguably we should have a check at startup that complains if
> your kernel is missing something the machine type uses.
> However, that would mean that people running with -M pc   would fail
> on old kernels.
>=20
> A post-load is also a valid check; but one question is whether,
> for a particular register, the pain is worth it - it depends on the
> symptom that the missing state causes.  If it's minor then you might
> conclude it's not worth a failed migration;  if it's a hung or
> corrupt guest then yes it is.   Certainly a warning printed is worth
> it.
>=20
> Dave

I think we should have flags that allow user to specify which VMState =
subsections user explicitly allow to avoid restore even though they are =
required to fully restore guest state.
But it seems to me that the behaviour should be to always fail migration =
in case we load a VMState subsections that we are unable to restore =
unless user explicitly specified this is ok
for this specific subsection.

Therefore, it seems that for every VMState subsection that it=E2=80=99s =
restore is based on kernel capability we should:
1) Have a user-controllable flag (which is also tied to machine-type?) =
to explicitly allow avoid restoring this state if cannot. Default should =
be =E2=80=9Cfalse=E2=80=9D.
2) Have a .post_load() method that verifies we have required kernel =
capability to restore this state, unless flag (1) was specified as =
=E2=80=9Ctrue=E2=80=9D.

Note that above mentioned flags is different than flags such as =
=E2=80=9Cx-migrate-smi-count=E2=80=9D.
The purpose of =E2=80=9Cx-migrate-smi-count=E2=80=9D flag is to avoid =
sending the VMState subsection to begin with in case we know we migrate =
to older QEMU which don=E2=80=99t even have the relevant VMState =
subsection. But it is not relevant for the case both source and =
destination runs QEMU which understands the VMState subsection but run =
on kernels with different capabilities.

Also note regarding your first paragraph, that specifying flags based on =
kernel you are running on doesn=E2=80=99t help for the case discussed =
here.
As source QEMU is running on new kernel. Unless you meant that source =
QEMU should use relevant machine-type based on the destination kernel.
i.e. You should launch QEMU with old machine-type as long as you have =
hosts in your migration pool that runs with old kernel.
I don=E2=80=99 think it=E2=80=99s the right approach though. As there is =
no way to change flags such as =E2=80=9Cx-migrate-smi-count=E2=80=9D =
dynamically after all hosts in migration pool have been upgraded.

What do you think?

-Liran

>=20
>> Thanks,
>> -Liran
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK


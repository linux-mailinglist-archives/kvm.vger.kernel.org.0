Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6411A3714D
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 12:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbfFFKKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 06:10:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44336 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727469AbfFFKKn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 06:10:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x56A9RD7078670;
        Thu, 6 Jun 2019 10:10:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=A2lohbaoWLKoAvAf4tx9KyrLIjuQu3VNYPX70hF57eo=;
 b=FpMhnJ+4aHCoNMPYFiVfeboHriMdawL6ei1XqWecrPQdSU0m3iXPJRpyAA3lOgwCluuV
 fbu1oDT06yY94JUUNCtC6v0uGGtlH8HQl4nXGoYK8D8h1xSGPXhKlNTU+1R/ZQUs/Jhv
 CcZxejgsnm61ba+V2IadHx3oixD89/lI3Ai2dQqmvyNF0zq4mGu6dh+9jhjGfsDoxdqI
 HQg7iyhlJkbwZmw5CNLvJgm3/NGKL4q6A8br9hEx3/CVxyIqfQiNcopVSyBxmmXBrkoE
 xu5FRrImX/zSYH292UvRPTvu5bDYq9rPx1bi32EWhxQrGJDHJC47vNyGUua83/iIw5Rj Ew== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2sugstqh4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jun 2019 10:10:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x56A8YIu051418;
        Thu, 6 Jun 2019 10:10:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2swnhap5bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jun 2019 10:10:01 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x56AA0n6020679;
        Thu, 6 Jun 2019 10:10:00 GMT
Received: from [192.168.14.112] (/109.66.241.232)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Jun 2019 03:10:00 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: QEMU/KVM migration backwards compatibility broken?
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190606092358.GE2788@work-vm>
Date:   Thu, 6 Jun 2019 13:09:56 +0300
Cc:     kvm list <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <8F3FD038-12DB-44BC-A262-3F1B55079753@oracle.com>
References: <38B8F53B-F993-45C3-9A82-796A0D4A55EC@oracle.com>
 <20190606084222.GA2788@work-vm>
 <862DD946-EB3C-405A-BE88-4B22E0B9709C@oracle.com>
 <20190606092358.GE2788@work-vm>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9279 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906060074
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9279 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906060074
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 6 Jun 2019, at 12:23, Dr. David Alan Gilbert <dgilbert@redhat.com> =
wrote:
>=20
> * Liran Alon (liran.alon@oracle.com) wrote:
>>=20
>>=20
>>> On 6 Jun 2019, at 11:42, Dr. David Alan Gilbert =
<dgilbert@redhat.com> wrote:
>>>=20
>>> * Liran Alon (liran.alon@oracle.com) wrote:
>>>> Hi,
>>>>=20
>>>> Looking at QEMU source code, I am puzzled regarding how migration =
backwards compatibility is preserved regarding X86CPU.
>>>>=20
>>>> As I understand it, fields that are based on KVM capabilities and =
guest runtime usage are defined in VMState subsections in order to not =
send them if not necessary.
>>>> This is done such that in case they are not needed and we migrate =
to an old QEMU which don=E2=80=99t support loading this state, migration =
will still succeed
>>>> (As .needed() method will return false and therefore this state =
won=E2=80=99t be sent as part of migration stream).
>>>> Furthermore, in case .needed() returns true and old QEMU don=E2=80=99=
t support loading this state, migration fails. As it should because we =
are aware that guest state
>>>> is not going to be restored properly on destination.
>>>>=20
>>>> I=E2=80=99m puzzled about what will happen in the following =
scenario:
>>>> 1) Source is running new QEMU with new KVM that supports save of =
some VMState subsection.
>>>> 2) Destination is running new QEMU that supports load this state =
but with old kernel that doesn=E2=80=99t know how to load this state.
>>>>=20
>>>> I would have expected in this case that if source .needed() returns =
true, then migration will fail because of lack of support in destination =
kernel.
>>>> However, it seems from current QEMU code that this will actually =
succeed in many cases.
>>>>=20
>>>> For example, if msr_smi_count is sent as part of migration stream =
(See vmstate_msr_smi_count) and destination have =
has_msr_smi_count=3D=3Dfalse,
>>>> then destination will succeed loading migration stream but =
kvm_put_msrs() will actually ignore env->msr_smi_count and will =
successfully load guest state.
>>>> Therefore, migration will succeed even though it should have =
failed=E2=80=A6
>>>>=20
>>>> It seems to me that QEMU should have for every such VMState =
subsection, a .post_load() method that verifies that relevant capability =
is supported by kernel
>>>> and otherwise fail migration.
>>>>=20
>>>> What do you think? Should I really create a patch to modify all =
these CPUX86 VMState subsections to behave like this?
>>>=20
>>> I don't know the x86 specific side that much; but from my migration =
side
>>> the answer should mostly be through machine types - indeed for =
smi-count
>>> there's a property 'x-migrate-smi-count' which is off for machine =
types
>>> pre 2.11 (see hw/i386/pc.c pc_compat_2_11) - so if you've got an old
>>> kernel you should stick to the old machine types.
>>>=20
>>> There's nothing guarding running the new machine type on =
old-kernels;
>>> and arguably we should have a check at startup that complains if
>>> your kernel is missing something the machine type uses.
>>> However, that would mean that people running with -M pc   would fail
>>> on old kernels.
>>>=20
>>> A post-load is also a valid check; but one question is whether,
>>> for a particular register, the pain is worth it - it depends on the
>>> symptom that the missing state causes.  If it's minor then you might
>>> conclude it's not worth a failed migration;  if it's a hung or
>>> corrupt guest then yes it is.   Certainly a warning printed is worth
>>> it.
>>>=20
>>> Dave
>>=20
>> I think we should have flags that allow user to specify which VMState =
subsections user explicitly allow to avoid restore even though they are =
required to fully restore guest state.
>> But it seems to me that the behaviour should be to always fail =
migration in case we load a VMState subsections that we are unable to =
restore unless user explicitly specified this is ok
>> for this specific subsection.
>> Therefore, it seems that for every VMState subsection that it=E2=80=99s=
 restore is based on kernel capability we should:
>> 1) Have a user-controllable flag (which is also tied to =
machine-type?) to explicitly allow avoid restoring this state if cannot. =
Default should be =E2=80=9Cfalse=E2=80=9D.
>> 2) Have a .post_load() method that verifies we have required kernel =
capability to restore this state, unless flag (1) was specified as =
=E2=80=9Ctrue=E2=80=9D.
>=20
> This seems a lot of flags; users aren't going to know what to do with
> all of them; I don't see what will set/control them.

True but I think users will want to specify only for a handful of =
VMState subsections that it is OK to not restore them even thought hey =
are deemed needed by source QEMU.
We can create flags only for those VMState subsections.
User should set these flags explicitly on QEMU command-line. As a =
=E2=80=9C-cpu=E2=80=9D property? I don=E2=80=99t think these flags =
should be tied to machine-type.

>=20
>> Note that above mentioned flags is different than flags such as =
=E2=80=9Cx-migrate-smi-count=E2=80=9D.
>> The purpose of =E2=80=9Cx-migrate-smi-count=E2=80=9D flag is to avoid =
sending the VMState subsection to begin with in case we know we migrate =
to older QEMU which don=E2=80=99t even have the relevant VMState =
subsection. But it is not relevant for the case both source and =
destination runs QEMU which understands the VMState subsection but run =
on kernels with different capabilities.
>>=20
>> Also note regarding your first paragraph, that specifying flags based =
on kernel you are running on doesn=E2=80=99t help for the case discussed =
here.
>> As source QEMU is running on new kernel. Unless you meant that source =
QEMU should use relevant machine-type based on the destination kernel.
>> i.e. You should launch QEMU with old machine-type as long as you have =
hosts in your migration pool that runs with old kernel.
>=20
> That's what I meant; stick to the old machine-type unless you know =
it's
> safe to use a newer one.
>=20
>> I don=E2=80=99 think it=E2=80=99s the right approach though. As there =
is no way to change flags such as =E2=80=9Cx-migrate-smi-count=E2=80=9D =
dynamically after all hosts in migration pool have been upgraded.
>>=20
>> What do you think?
>=20
> I don't have an easy answer.  The users already have to make sure they
> use a machine type that's old enough for all the QEMUs installed in
> their cluster; making sure it's also old enough for their oldest
> kernel isn't too big a difference - *except* that it's much harder to
> tell which kernel corresponds to which feature/machine type etc - so
> how does a user know what the newest supported machine type is?
> Failing at startup when selecting a machine type that the current
> kernel can't support would help that.
>=20
> Dave

First, machine-type express the set of vHW behaviour and properties that =
is exposed to guest.
Therefore, machine-type shouldn=E2=80=99t change for a given guest =
lifetime (including Live-Migrations).
Otherwise, guest will experience different vHW behaviour and properties =
before/after Live-Migration.
So I think machine-type is not relevant for this discussion. We should =
focus on flags which specify
migration behaviour (such as =E2=80=9Cx-migrate-smi-count=E2=80=9D which =
can also be controlled by machine-type but not only).

Second, this strategy results in inefficient migration management. =
Consider the following scenario:
1) Guest running on new_qemu+old_kernel migrate to host with =
new_qemu+new_kernel.
Because source is old_kernel than destination QEMU is launched with =
(x-migrate-smi-count =3D=3D false).
2) Assume at this point fleet of hosts have half of hosts with =
old_kernel and half with new_kernel.
3) Further assume that guest workload indeed use msr_smi_count and =
therefore relevant VMState subsection should be sent to properly =
preserve guest state.
4) =46rom some reason, we decide to migrate again the guest in (1).
Even if guest is migrated to a host with new_kernel, then QEMU still =
avoids sending msr_smi_count VMState subsection because it is launched =
with (x-migrate-smi-count =3D=3D false).

Therefore, I think it makes more sense that source QEMU will always send =
all VMState subsection that are deemed needed (i.e. .nedeed() returns =
true)
and let receive-side decide if migration should fail if this subsection =
was sent but failed to be restored.
The only case which I think sender should limit the VMState subsection =
it sends to destination is because source is running older QEMU
which is not even aware of this VMState subsection (Which is to my =
understanding the rational behind using =E2=80=9Cx-migrate-smi-count=E2=80=
=9D and tie it up to machine-type).

Third, let=E2=80=99s assume all hosts in fleet was upgraded to =
new_kernel. How do I modify all launched QEMUs on these new hosts to now =
have =E2=80=9Cx-migrate-smi-count=E2=80=9D set to true?
As I would like future migrations to do send this VMState subsection. =
Currently there is no QMP command to update these flags.

Fourth, I think it=E2=80=99s not trivial for management-plane to be =
aware with which flags it should set on destination QEMU based on =
currently running kernels on fleet.
It=E2=80=99s not the same as machine-type, as already discussed above =
doesn=E2=80=99t change during the entire lifetime of guest.

I=E2=80=99m also not sure it is a good idea that we currently control =
flags such as =E2=80=9Cx-migrate-smi-count=E2=80=9D from machine-type.
As it means that if a guest was initially launched using some old QEMU, =
it will *forever* not migrate some VMState subsection during all it=E2=80=99=
s Live-Migrations.
Even if all hosts and all QEMUs on fleet are capable of migrating this =
state properly.
Maybe it is preferred that this flag was specified as part of =
=E2=80=9Cmigrate=E2=80=9D command itself in case management-plane knows =
it wishes to migrate even though dest QEMU
is older and doesn=E2=80=99t understand this specific VMState =
subsection.

I=E2=80=99m left pretty confused about QEMU=E2=80=99s migration =
compatibility strategy...

-Liran

>=20
>> -Liran
>>=20
>>>=20
>>>> Thanks,
>>>> -Liran
>>> --
>>> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
>>=20
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK


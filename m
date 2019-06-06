Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64F4E372E4
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 13:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbfFFLaU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 07:30:20 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56770 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727230AbfFFLaU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 07:30:20 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x56BSwqH160637;
        Thu, 6 Jun 2019 11:29:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=zqFxMNJ9A/8o5MQvi6OrO++Ji/3bq0cKTPjckZtiVj4=;
 b=bu1r07nHUSq922xznScpTBYM//7rkW/lv7w0DNpYDImMTaAFidsNczeUJgGUmt520FNZ
 dEtTZynDrN9FG85jVDQIaz5Z/S15Hh6QptUWp1UO1juLFInH1EQ8sklqfHZKn+63a0JP
 pExPeDDca5G0WEM30JGEtkxLrq1ic7neQbBmZ+jsIa4LRlh3nHXK0vmHILAky0qlRrN7
 7VgFSEfhnLLW0A0xEHiH8Duk/V2Vl9K+dJJeYUHlWnmGLlOI1qRL6YuKU43S6kmjo0fx
 38Uu0AEAfAPCHH01qHE92+Ql9oZFtij4qBnWONkgoRut/X3IzBOpIGeo+jZdBnYYgcRY CQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2suevdr310-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jun 2019 11:29:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x56BT4vr143182;
        Thu, 6 Jun 2019 11:29:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2swngmf28k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jun 2019 11:29:38 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x56BTbLZ011839;
        Thu, 6 Jun 2019 11:29:37 GMT
Received: from [10.30.3.6] (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Jun 2019 04:29:37 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: QEMU/KVM migration backwards compatibility broken?
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190606110737.GK2788@work-vm>
Date:   Thu, 6 Jun 2019 14:29:33 +0300
Cc:     kvm list <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3F6B41CD-C7E2-4A61-875C-F61AE45F2A58@oracle.com>
References: <38B8F53B-F993-45C3-9A82-796A0D4A55EC@oracle.com>
 <20190606084222.GA2788@work-vm>
 <862DD946-EB3C-405A-BE88-4B22E0B9709C@oracle.com>
 <20190606092358.GE2788@work-vm>
 <8F3FD038-12DB-44BC-A262-3F1B55079753@oracle.com>
 <20190606103958.GJ2788@work-vm>
 <B7A9A778-9BD5-449E-A8F3-5D8E3471F4A6@oracle.com>
 <20190606110737.GK2788@work-vm>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9279 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906060084
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9279 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906060085
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 6 Jun 2019, at 14:07, Dr. David Alan Gilbert <dgilbert@redhat.com> =
wrote:
>=20
> * Liran Alon (liran.alon@oracle.com) wrote:
>>=20
>>=20
>>> On 6 Jun 2019, at 13:39, Dr. David Alan Gilbert =
<dgilbert@redhat.com> wrote:
>>>=20
>>> * Liran Alon (liran.alon@oracle.com) wrote:
>>>>=20
>>>>=20
>>>>> On 6 Jun 2019, at 12:23, Dr. David Alan Gilbert =
<dgilbert@redhat.com> wrote:
>>>>>=20
>>>>> * Liran Alon (liran.alon@oracle.com) wrote:
>>>>>>=20
>>>>>>=20
>>>>>>> On 6 Jun 2019, at 11:42, Dr. David Alan Gilbert =
<dgilbert@redhat.com> wrote:
>>>>>>>=20
>>>>>>> * Liran Alon (liran.alon@oracle.com) wrote:
>>>>>>>> Hi,
>>>>>>>>=20
>>>>>>>> Looking at QEMU source code, I am puzzled regarding how =
migration backwards compatibility is preserved regarding X86CPU.
>>>>>>>>=20
>>>>>>>> As I understand it, fields that are based on KVM capabilities =
and guest runtime usage are defined in VMState subsections in order to =
not send them if not necessary.
>>>>>>>> This is done such that in case they are not needed and we =
migrate to an old QEMU which don=E2=80=99t support loading this state, =
migration will still succeed
>>>>>>>> (As .needed() method will return false and therefore this state =
won=E2=80=99t be sent as part of migration stream).
>>>>>>>> Furthermore, in case .needed() returns true and old QEMU =
don=E2=80=99t support loading this state, migration fails. As it should =
because we are aware that guest state
>>>>>>>> is not going to be restored properly on destination.
>>>>>>>>=20
>>>>>>>> I=E2=80=99m puzzled about what will happen in the following =
scenario:
>>>>>>>> 1) Source is running new QEMU with new KVM that supports save =
of some VMState subsection.
>>>>>>>> 2) Destination is running new QEMU that supports load this =
state but with old kernel that doesn=E2=80=99t know how to load this =
state.
>>>>>>>>=20
>>>>>>>> I would have expected in this case that if source .needed() =
returns true, then migration will fail because of lack of support in =
destination kernel.
>>>>>>>> However, it seems from current QEMU code that this will =
actually succeed in many cases.
>>>>>>>>=20
>>>>>>>> For example, if msr_smi_count is sent as part of migration =
stream (See vmstate_msr_smi_count) and destination have =
has_msr_smi_count=3D=3Dfalse,
>>>>>>>> then destination will succeed loading migration stream but =
kvm_put_msrs() will actually ignore env->msr_smi_count and will =
successfully load guest state.
>>>>>>>> Therefore, migration will succeed even though it should have =
failed=E2=80=A6
>>>>>>>>=20
>>>>>>>> It seems to me that QEMU should have for every such VMState =
subsection, a .post_load() method that verifies that relevant capability =
is supported by kernel
>>>>>>>> and otherwise fail migration.
>>>>>>>>=20
>>>>>>>> What do you think? Should I really create a patch to modify all =
these CPUX86 VMState subsections to behave like this?
>>>>>>>=20
>>>>>>> I don't know the x86 specific side that much; but from my =
migration side
>>>>>>> the answer should mostly be through machine types - indeed for =
smi-count
>>>>>>> there's a property 'x-migrate-smi-count' which is off for =
machine types
>>>>>>> pre 2.11 (see hw/i386/pc.c pc_compat_2_11) - so if you've got an =
old
>>>>>>> kernel you should stick to the old machine types.
>>>>>>>=20
>>>>>>> There's nothing guarding running the new machine type on =
old-kernels;
>>>>>>> and arguably we should have a check at startup that complains if
>>>>>>> your kernel is missing something the machine type uses.
>>>>>>> However, that would mean that people running with -M pc   would =
fail
>>>>>>> on old kernels.
>>>>>>>=20
>>>>>>> A post-load is also a valid check; but one question is whether,
>>>>>>> for a particular register, the pain is worth it - it depends on =
the
>>>>>>> symptom that the missing state causes.  If it's minor then you =
might
>>>>>>> conclude it's not worth a failed migration;  if it's a hung or
>>>>>>> corrupt guest then yes it is.   Certainly a warning printed is =
worth
>>>>>>> it.
>>>>>>>=20
>>>>>>> Dave
>>>>>>=20
>>>>>> I think we should have flags that allow user to specify which =
VMState subsections user explicitly allow to avoid restore even though =
they are required to fully restore guest state.
>>>>>> But it seems to me that the behaviour should be to always fail =
migration in case we load a VMState subsections that we are unable to =
restore unless user explicitly specified this is ok
>>>>>> for this specific subsection.
>>>>>> Therefore, it seems that for every VMState subsection that it=E2=80=
=99s restore is based on kernel capability we should:
>>>>>> 1) Have a user-controllable flag (which is also tied to =
machine-type?) to explicitly allow avoid restoring this state if cannot. =
Default should be =E2=80=9Cfalse=E2=80=9D.
>>>>>> 2) Have a .post_load() method that verifies we have required =
kernel capability to restore this state, unless flag (1) was specified =
as =E2=80=9Ctrue=E2=80=9D.
>>>>>=20
>>>>> This seems a lot of flags; users aren't going to know what to do =
with
>>>>> all of them; I don't see what will set/control them.
>>>>=20
>>>> True but I think users will want to specify only for a handful of =
VMState subsections that it is OK to not restore them even thought hey =
are deemed needed by source QEMU.
>>>> We can create flags only for those VMState subsections.
>>>> User should set these flags explicitly on QEMU command-line. As a =
=E2=80=9C-cpu=E2=80=9D property? I don=E2=80=99t think these flags =
should be tied to machine-type.
>>>=20
>>> I don't see who is going to work out these flags and send them.
>>>=20
>>>>>=20
>>>>>> Note that above mentioned flags is different than flags such as =
=E2=80=9Cx-migrate-smi-count=E2=80=9D.
>>>>>> The purpose of =E2=80=9Cx-migrate-smi-count=E2=80=9D flag is to =
avoid sending the VMState subsection to begin with in case we know we =
migrate to older QEMU which don=E2=80=99t even have the relevant VMState =
subsection. But it is not relevant for the case both source and =
destination runs QEMU which understands the VMState subsection but run =
on kernels with different capabilities.
>>>>>>=20
>>>>>> Also note regarding your first paragraph, that specifying flags =
based on kernel you are running on doesn=E2=80=99t help for the case =
discussed here.
>>>>>> As source QEMU is running on new kernel. Unless you meant that =
source QEMU should use relevant machine-type based on the destination =
kernel.
>>>>>> i.e. You should launch QEMU with old machine-type as long as you =
have hosts in your migration pool that runs with old kernel.
>>>>>=20
>>>>> That's what I meant; stick to the old machine-type unless you know =
it's
>>>>> safe to use a newer one.
>>>>>=20
>>>>>> I don=E2=80=99 think it=E2=80=99s the right approach though. As =
there is no way to change flags such as =E2=80=9Cx-migrate-smi-count=E2=80=
=9D dynamically after all hosts in migration pool have been upgraded.
>>>>>>=20
>>>>>> What do you think?
>>>>>=20
>>>>> I don't have an easy answer.  The users already have to make sure =
they
>>>>> use a machine type that's old enough for all the QEMUs installed =
in
>>>>> their cluster; making sure it's also old enough for their oldest
>>>>> kernel isn't too big a difference - *except* that it's much harder =
to
>>>>> tell which kernel corresponds to which feature/machine type etc - =
so
>>>>> how does a user know what the newest supported machine type is?
>>>>> Failing at startup when selecting a machine type that the current
>>>>> kernel can't support would help that.
>>>>>=20
>>>>> Dave
>>>>=20
>>>> First, machine-type express the set of vHW behaviour and properties =
that is exposed to guest.
>>>> Therefore, machine-type shouldn=E2=80=99t change for a given guest =
lifetime (including Live-Migrations).
>>>> Otherwise, guest will experience different vHW behaviour and =
properties before/after Live-Migration.
>>>> So I think machine-type is not relevant for this discussion. We =
should focus on flags which specify
>>>> migration behaviour (such as =E2=80=9Cx-migrate-smi-count=E2=80=9D =
which can also be controlled by machine-type but not only).
>>>=20
>>> Machine type specifies two things:
>>> a) The view from the guest
>>> b) Migration compatibility
>>>=20
>>> (b) is explicitly documented in qemu's docs/devel/migration.rst, see =
the
>>> subsection on subsections.
>>>=20
>>>> Second, this strategy results in inefficient migration management. =
Consider the following scenario:
>>>> 1) Guest running on new_qemu+old_kernel migrate to host with =
new_qemu+new_kernel.
>>>> Because source is old_kernel than destination QEMU is launched with =
(x-migrate-smi-count =3D=3D false).
>>>> 2) Assume at this point fleet of hosts have half of hosts with =
old_kernel and half with new_kernel.
>>>> 3) Further assume that guest workload indeed use msr_smi_count and =
therefore relevant VMState subsection should be sent to properly =
preserve guest state.
>>>> 4) =46rom some reason, we decide to migrate again the guest in (1).
>>>> Even if guest is migrated to a host with new_kernel, then QEMU =
still avoids sending msr_smi_count VMState subsection because it is =
launched with (x-migrate-smi-count =3D=3D false).
>>>>=20
>>>> Therefore, I think it makes more sense that source QEMU will always =
send all VMState subsection that are deemed needed (i.e. .nedeed() =
returns true)
>>>> and let receive-side decide if migration should fail if this =
subsection was sent but failed to be restored.
>>>> The only case which I think sender should limit the VMState =
subsection it sends to destination is because source is running older =
QEMU
>>>> which is not even aware of this VMState subsection (Which is to my =
understanding the rational behind using =E2=80=9Cx-migrate-smi-count=E2=80=
=9D and tie it up to machine-type).
>>>=20
>>> But we want to avoid failed migrations if we can; so in general we =
don't
>>> want to be sending subsections to destinations that can't handle =
them.
>>> The only case where it's reasonable is when there's a migration bug =
such
>>> that the behaviour in the guest is really nasty; if there's a choice
>>> between a failed migration or a hung/corrupt guest I'll take a =
failed
>>> migration.
>>>=20
>>>> Third, let=E2=80=99s assume all hosts in fleet was upgraded to =
new_kernel. How do I modify all launched QEMUs on these new hosts to now =
have =E2=80=9Cx-migrate-smi-count=E2=80=9D set to true?
>>>> As I would like future migrations to do send this VMState =
subsection. Currently there is no QMP command to update these flags.
>>>=20
>>> I guess that's possible - it's pretty painful though; you're going =
to
>>> have to teach your management layer about features/fixes of the =
kernels
>>> and which flags to tweak in qemu.  Having said that, if you could do =
it,
>>> then you'd avoid having to restart VMs to pick up a few fixes.
>>>=20
>>>> Fourth, I think it=E2=80=99s not trivial for management-plane to be =
aware with which flags it should set on destination QEMU based on =
currently running kernels on fleet.
>>>> It=E2=80=99s not the same as machine-type, as already discussed =
above doesn=E2=80=99t change during the entire lifetime of guest.
>>>=20
>>> Right, which is why I don't see your idea of adding flags will work.
>>> I don't see how anything will figure out what the right flags to use
>>> are.
>>> (Getting the management layers to do sane things with the cpuid =
flags
>>> is already a nightmare, and they're fairly well understood).
>>>=20
>>>> I=E2=80=99m also not sure it is a good idea that we currently =
control flags such as =E2=80=9Cx-migrate-smi-count=E2=80=9D from =
machine-type.
>>>> As it means that if a guest was initially launched using some old =
QEMU, it will *forever* not migrate some VMState subsection during all =
it=E2=80=99s Live-Migrations.
>>>> Even if all hosts and all QEMUs on fleet are capable of migrating =
this state properly.
>>>> Maybe it is preferred that this flag was specified as part of =
=E2=80=9Cmigrate=E2=80=9D command itself in case management-plane knows =
it wishes to migrate even though dest QEMU
>>>> is older and doesn=E2=80=99t understand this specific VMState =
subsection.
>>>>=20
>>>> I=E2=80=99m left pretty confused about QEMU=E2=80=99s migration =
compatibility strategy...
>>>=20
>>> The compatibility strategy is the machine type;  but yes it does
>>> have a problem when it's not really just a qemu version - but also
>>> kernel (and external libraries, etc).
>>> My general advice is that users should be updating their kernels and
>>> qemus together; but I realise there's lots of cases where that
>>> doesn't work.
>>>=20
>>> Dave
>>=20
>> I think it=E2=80=99s not practical advise to expect users to always =
upgrade kernel and QEMU together.
>> In fact, users prefer to upgrade them separately to avoid doing major =
upgrades at once and to better pin-point root-cause of issues.
>=20
> It's tricky; for distro-based users, hitting 'update' and getting both
> makes a lot of sense; but as you say you ened to let them do stuff
> individually if they want to, so they can track down problems.
> There's also a newer problem which is people want to run the QEMU in
> containers on hosts that have separate update schedules - the kernel
> version relationship is then much more fluid.
>=20
>> Compiling all above very useful discussion (thanks for this!), I may =
have a better suggestion that doesn=E2=80=99t require any additional =
flags:
>> 1) Source QEMU will always send all all VMState subsections that is =
deemed by source QEMU as required to not break guest semantic behaviour.
>> This is done by .needed() methods that examine guest runtime state to =
understand if this state is required to be sent or not.
>=20
> So that's as we already do.

Besides the fact that today we also expect to add a flag tied to =
machine-type for every new VMState subsection we add that didn=E2=80=99t =
exist on previous QEMU versions...

>=20
>> 2) Destination QEMU will provide a generic QMP command which allows =
to set names of VMState subsections that if accepted on migration stream
>> and failed to be loaded (because either subsection name is not =
implemented or because .post_load() method failed) then the failure =
should be ignored
>> and migration should continue as usual. By default, the list of this =
names will be empty.
>=20
> The format of the migration stream means that you can't skip an =
unknown
> subsection; it's not possible to resume parsing the stream without
> knowing what was supposed to be there. [This is pretty awful
> but my last attempts to rework it hit a dead end]

Wow=E2=80=A6 That is indeed pretty awful.
I thought every VMState subsection have a header with a length field=E2=80=
=A6 :(

Why did your last attempts to add such a length field to migration =
stream protocol failed?

>=20
> So we still need to tie subsections to machine types; that way
> you don't send them to old qemu's and there for you don't have the
> problem of the qemu receiving something it doesn't know.

I agree that if there is no way to skip a VMState subsection in the =
stream, then we must
have a way to specify to source QEMU to prevent sending this subsection =
to destination=E2=80=A6

I would suggest though that instead of having a flag tied to =
machine-type, we will have a QMP command
that can specify names of subsections we explicitly wish to be skipped =
sending to destination even if their .needed() method returns true.

This seems like a more explicit approach and doesn=E2=80=99t come with =
the down-side of forever not migrating this VMState subsection
for the entire lifetime of guest.

>=20
> Still, you could skip things where the destination kernel doesn't know
> about it.
>=20
>> 3) Destination QEMU will implement .post_load() method for all these =
VMState subsections that depend on kernel capability to be restored =
properly
>> such that it will fail subsection load in case kernel capability is =
not present. (Note that this load failure will be ignored if subsection =
name is specified in (2)).
>>=20
>> Above suggestion have the following properties:
>> 1) Doesn=E2=80=99t require any flag to be added to QEMU.
>=20
> There's no logical difference between 'flags' and 'names of =
subsections'
> - they're got the same problem in someone somewhere knowing which are
>  safe.

I agree. But creating additional flags does come with a development and =
testing overhead and makes code less intuitive.
I would have prefer to use subsection names.

>=20
>> 2) Moves all control on whether to fail migration because of failure =
to load VMState subsection to receiver side. Sender always attempts to =
send max state he believes is required.
>> 3) We remove coupling of migration compatibility from machine-type.
>>=20
>> What do you think?
>=20
> Sorry, can't do (3) - we need to keep the binding for subsections to
> machine types for qemu compatibility;  I'm open for something for
> kernel compat, but not when it's breaking the qemu subsection
> checks.
>=20
> Dave

Agree. I have proposed now above how to not break qemu subsection checks =
while still not tie this to machine-type.
Please tell me what you think on that approach. :)

We can combine that approach together with implementing the mentioned =
.post_load() methods and maybe it solves the discussion at hand here.

-Liran

>=20
>>=20
>> -Liran
>>=20
>>>=20
>>>> -Liran
>>>>=20
>>>>>=20
>>>>>> -Liran
>>>>>>=20
>>>>>>>=20
>>>>>>>> Thanks,
>>>>>>>> -Liran
>>>>>>> --
>>>>>>> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
>>>>>>=20
>>>>> --
>>>>> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
>>>>=20
>>> --
>>> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
>>=20
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK


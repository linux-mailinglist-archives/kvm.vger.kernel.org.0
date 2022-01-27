Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D795C49E91A
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 18:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244665AbiA0Red (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 12:34:33 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61172 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234612AbiA0Rec (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jan 2022 12:34:32 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20RH6MBw022435;
        Thu, 27 Jan 2022 17:34:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=+1Y7Dk2Z3towDl4Jpbnuh4qqmZHKJI/5PABityw3HJk=;
 b=b/7zcjxvzMBCMFRFPo5C6Mps/9uBNh5XDQomawX8j9l2meUiY425zJwTc62XMp20WoX2
 4c6HjdOK360/wbOjyGiIkUuQyu9FJuTKedLf12j8EMvU7vhpnZK/S0dMVqhTlLPaDqoL
 1Fe9BgbZvxf+NNwqNM2JSogFhfI4JRoLyJEC4/H5X1iIo88ztVIVQmGaov93IfI55cxs
 Y+1wR/LorMzb16MJZ0zr9tEUcw1fTDCDhak1uJrNDAcLLD1beNfaL5qBNJCZNa8yYplg
 G5D0UN/KHFyUcF8A83YTSd1iXijS/v+DHZE/bgB3A6OanmVgFhLbSqowuyE/dZkTnwso Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3duwujju78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 17:34:31 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20RHBCO4010562;
        Thu, 27 Jan 2022 17:34:30 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3duwujju6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 17:34:30 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20RHIct8019457;
        Thu, 27 Jan 2022 17:34:29 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3dr9j9tja8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 17:34:28 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20RHOjKd47841706
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 17:24:45 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAE0AA405C;
        Thu, 27 Jan 2022 17:34:23 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D999A4062;
        Thu, 27 Jan 2022 17:34:23 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.145])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jan 2022 17:34:23 +0000 (GMT)
Date:   Thu, 27 Jan 2022 18:34:20 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 06/10] KVM: s390: Add vm IOCTL for key checked
 guest absolute memory access
Message-ID: <20220127183420.76dd7f15@p-imbrenda>
In-Reply-To: <71eb83a1-131d-f667-b1ef-ae214c724ba4@linux.ibm.com>
References: <20220118095210.1651483-1-scgl@linux.ibm.com>
        <20220118095210.1651483-7-scgl@linux.ibm.com>
        <069c72b6-457f-65c7-652e-e6eca7235fca@redhat.com>
        <8647fcaf-6d8a-4678-0695-4b1cc797b3b1@linux.ibm.com>
        <3035e023-d71a-407b-2ba6-45ad0ae85a9e@redhat.com>
        <71eb83a1-131d-f667-b1ef-ae214c724ba4@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JdK3eWlFoFHP7lnJnYMqzQBCQA8ClrYn
X-Proofpoint-GUID: KGxAk64TmxKHerkRT8iUXuSGNF0el9D_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_03,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 suspectscore=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 bulkscore=0 impostorscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201270102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 27 Jan 2022 17:29:44 +0100
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> On 1/25/22 13:00, Thomas Huth wrote:
> > On 20/01/2022 13.23, Janis Schoetterl-Glausch wrote: =20
> >> On 1/20/22 11:38, Thomas Huth wrote: =20
> >>> On 18/01/2022 10.52, Janis Schoetterl-Glausch wrote: =20
> >>>> Channel I/O honors storage keys and is performed on absolute memory.
> >>>> For I/O emulation user space therefore needs to be able to do key
> >>>> checked accesses.
> >>>> The vm IOCTL supports read/write accesses, as well as checking
> >>>> if an access would succeed. =20
> >>> ... =20
> >>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> >>>> index e3f450b2f346..dd04170287fd 100644
> >>>> --- a/include/uapi/linux/kvm.h
> >>>> +++ b/include/uapi/linux/kvm.h
> >>>> @@ -572,6 +572,8 @@ struct kvm_s390_mem_op {
> >>>> =C2=A0=C2=A0 #define KVM_S390_MEMOP_LOGICAL_WRITE=C2=A0=C2=A0=C2=A0 1
> >>>> =C2=A0=C2=A0 #define KVM_S390_MEMOP_SIDA_READ=C2=A0=C2=A0=C2=A0 2
> >>>> =C2=A0=C2=A0 #define KVM_S390_MEMOP_SIDA_WRITE=C2=A0=C2=A0=C2=A0 3
> >>>> +#define KVM_S390_MEMOP_ABSOLUTE_READ=C2=A0=C2=A0=C2=A0 4
> >>>> +#define KVM_S390_MEMOP_ABSOLUTE_WRITE=C2=A0=C2=A0=C2=A0 5 =20
> >>>
> >>> Not quite sure about this - maybe it is, but at least I'd like to see=
 this discussed: Do we really want to re-use the same ioctl layout for both=
, the VM and the VCPU file handles? Where the userspace developer has to kn=
ow that the *_ABSOLUTE_* ops only work with VM handles, and the others only=
 work with the VCPU handles? A CPU can also address absolute memory, so why=
 not adding the *_ABSOLUTE_* ops there, too? And if we'd do that, wouldn't =
it be sufficient to have the VCPU ioctls only - or do you want to call thes=
e ioctls from spots in QEMU where you do not have a VCPU handle available? =
(I/O instructions are triggered from a CPU, so I'd assume that you should h=
ave a VCPU handle around?) =20
> >>
> >> There are some differences between the vm and the vcpu memops.
> >> No storage or fetch protection overrides apply to IO/vm memops, after =
all there is no control register to enable them.
> >> Additionally, quiescing is not required for IO, tho in practice we use=
 the same code path for the vcpu and the vm here.
> >> Allowing absolute accesses with a vcpu is doable, but I'm not sure wha=
t the use case for it would be, I'm not aware of
> >> a precedence in the architecture. Of course the vcpu memop already sup=
ports logical=3Dreal accesses. =20
> >=20
> > Ok. Maybe it then would be better to call new ioctl and the new op defi=
nes differently, to avoid confusion? E.g. call it "vmmemop" and use:
> >=20
> > #define KVM_S390_VMMEMOP_ABSOLUTE_READ=C2=A0=C2=A0=C2=A0 1
> > #define KVM_S390_VMMEMOP_ABSOLUTE_WRITE=C2=A0=C2=A0 2
> >=20
> > ?
> >=20
> > =C2=A0Thomas
> >  =20
>=20
> Thanks for the suggestion, I had to think about it for a while :). Here a=
re my thoughts:
> The ioctl type (vm/vcpu) and the operations cannot be completely orthogon=
al (vm + logical cannot work),
> but with regards to the absolute operations they could be. We don't have =
a use case for that
> right now and the semantics are a bit unclear, so I think we should choos=
e a design now that
> leaves us space for future extension. If we need to, we can add a NON_QUI=
ESCING flag backwards compatibly
> (tho it seems a rather unlikely requirement to me), that would behave the=
 same for vm/vcpu memops.
> We could also have a NO_PROT_OVERRIDE flag, which the vm memop would igno=
re.
> Whether override is possible is dependent on the vcpu state, so user spac=
e leaves the exact behavior to KVM anyway.
> If you wanted to enforce that protection override occurs, you would have =
to adjust
> the vcpu state and therefore there should be no confusion about whether t=
o use a vcpu or vm ioctl.
>=20
> So I'm inclined to have one ioctl code and keep the operations as they ar=
e.
> I moved the key to the union. One question that remains is whether to enf=
orce that reserved bytes must be 0.
> In general I think that it is a good idea, since it leaves a bigger desig=
n space for future extensions.
> However the vcpu memop has not done that. I think it should be enforced f=
or new functionality (operations, flags),

I agree with enforcing that unused bits should be 0

> any objections?
>=20
> I'll try to be thorough in documenting the currently supported behavior.

this is also a good idea :)


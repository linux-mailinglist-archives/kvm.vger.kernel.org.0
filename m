Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED2145FAE98
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 10:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiJKImH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 04:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiJKImF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 04:42:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A95F1D0D1
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 01:42:04 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29B8YWOO002930
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 08:42:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : cc : subject : message-id : date; s=pp1;
 bh=hsAbRPkMpFINL3NGFt14K6GMxHotTo+J5VFUe0goYyg=;
 b=GoeS9PO2q0VMYoQ/gtxqkGnx/q0NvMgTePrvno08EtzqCdTSMHIUPEqcXhFEDyI+RKPd
 /l2zwkxuz5O6JGYeY9/jI9pwnlGDUkApqqcgW6Kk7UCWx8BA29fNH3jJgpzCWOhl+iSi
 n86iEooLPwxRJJ/u8/nuJzLKo2cuaMxjmuF1qHG/qooea4iLqA0awbRi48rJpVuU9tNk
 2a3w3rCQ5aGBy7WKFyBB6THFz/HIk9Sr1rc68pAMZ+RelxwnGj9IOHlIkKigaDGcHxXZ
 6nFFFI1WjXynp3HGwdyOXxcuzwpzxdruVh0K4OJgNPiavK3ZMtJ0qKr1RLl7qL2AZJZk Ng== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k50xuq2nd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 08:42:03 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29B8Zc6Q026646
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 08:42:01 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3k30u9ay2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 08:42:00 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29B8fvPb62587288
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Oct 2022 08:41:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABD954C044;
        Tue, 11 Oct 2022 08:41:57 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 883424C040;
        Tue, 11 Oct 2022 08:41:57 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.53.19])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Oct 2022 08:41:57 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <f982f740-1227-8033-a9bd-4830db8e5b6b@linux.ibm.com>
References: <20221005163258.117232-1-nrb@linux.ibm.com> <20221005163258.117232-2-nrb@linux.ibm.com> <f982f740-1227-8033-a9bd-4830db8e5b6b@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     imbrenda@linux.ibm.com, borntraeger@linux.ibm.com
Subject: Re: [PATCH v3 1/2] KVM: s390: pv: don't allow userspace to set the clock under PV
Message-ID: <166547771730.25289.7471151387651448087@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 11 Oct 2022 10:41:57 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aoM4rbD8eZF0RqM7WwdlmwCZ_tN6miUA
X-Proofpoint-ORIG-GUID: aoM4rbD8eZF0RqM7WwdlmwCZ_tN6miUA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-11_03,2022-10-10_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 priorityscore=1501 mlxlogscore=852 impostorscore=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 mlxscore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210110047
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2022-10-10 17:20:10)
[...]
> This will ONLY result in a warning and there's no way that this can=20
> result in QEMU crashing, right?

Yes, QEMU code in hw/s390x/tod-kvm.c just sets an Error pointer which is th=
en
passed to warn_report(). So no crash is possible.

> >=20
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index b7ef0b71014d..0a8019b14c8f 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -1207,6 +1207,8 @@ static int kvm_s390_vm_get_migration(struct kvm *=
kvm,
> >       return 0;
> >   }
> >  =20
> > +static void __kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm=
_s390_vm_tod_clock *gtod);
> > +
> >   static int kvm_s390_set_tod_ext(struct kvm *kvm, struct kvm_device_at=
tr *attr)
> >   {
> >       struct kvm_s390_vm_tod_clock gtod;
> > @@ -1216,7 +1218,7 @@ static int kvm_s390_set_tod_ext(struct kvm *kvm, =
struct kvm_device_attr *attr)
> >  =20
> >       if (!test_kvm_facility(kvm, 139) && gtod.epoch_idx)
> >               return -EINVAL;
> > -     kvm_s390_set_tod_clock(kvm, &gtod);
> > +     __kvm_s390_set_tod_clock(kvm, &gtod);
> >  =20
> >       VM_EVENT(kvm, 3, "SET: TOD extension: 0x%x, TOD base: 0x%llx",
> >               gtod.epoch_idx, gtod.tod);
> > @@ -1247,7 +1249,7 @@ static int kvm_s390_set_tod_low(struct kvm *kvm, =
struct kvm_device_attr *attr)
> >                          sizeof(gtod.tod)))
> >               return -EFAULT;
> >  =20
> > -     kvm_s390_set_tod_clock(kvm, &gtod);
> > +     __kvm_s390_set_tod_clock(kvm, &gtod);
> >       VM_EVENT(kvm, 3, "SET: TOD base: 0x%llx", gtod.tod);
> >       return 0;
> >   }
> > @@ -1259,6 +1261,12 @@ static int kvm_s390_set_tod(struct kvm *kvm, str=
uct kvm_device_attr *attr)
> >       if (attr->flags)
> >               return -EINVAL;
> >  =20
>=20
> Add comment:
> For a protected guest the TOD is managed by the Ultravisor so trying to=20
> change it will never bring the expected results.

Yes, good point. Done.

> -EOPNOTSUPP is a new return code for the tod attribute, therefore=20
> programs using it might need a fix to be able to handle it.

Hmm, yes indeed.

Another alternative to consider might be -EINVAL. That is already specified=
 as a
return for KVM_S390_VM_TOD_HIGH and KVM_S390_VM_TOD_EXT (in different
circumstances though). However, it's missing from KVM_S390_VM_TOD_LOW...

> And as -EOPNOTSUPP has never been used before you'll also need to=20
> update: Documentation/virt/kvm/devices/vm.rst

Yeah, I will update the docs and use -EOPNOTSUPP for now. If someone argues=
 for
-EINVAL, I can still change it.

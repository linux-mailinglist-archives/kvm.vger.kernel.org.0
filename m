Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3944D86DE
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 15:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbiCNOVq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 10:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236288AbiCNOVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 10:21:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332FF1C127;
        Mon, 14 Mar 2022 07:20:34 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EDSTOh027948;
        Mon, 14 Mar 2022 14:20:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=rSmt3LGJWcR72QWX3eGLx5fEPKvXfiNzoyow4OiTM+8=;
 b=ZklPz8Dx9+f+5TzTugEXoV87/fZYTqS00llq1ZHq6Fg8JP+4CD04FXZoM4EKvA/FAK39
 +8kqf0N0SpKk9ZZ+1aTSHryCFaKc4794mRMOEaFmNMGbXmr0G/SfUgtoFmzkh0LRDLSf
 sXFF4eiM6vLZiBDXB7bPnT19aCnAbOqPz5VNv8JgltxAz6Mj64wIsWijN3vkynFx0igq
 M/yVQjBWJe3i/b/oWX9+fvG1B9ADo0lz55rWRs4Mx7Q6TViAOjnOsEQVGxFwK/iYwWG+
 gzT3lJpP/6r7e7Zrin61bX4JGVoU+LNdMj241qguCQs/Ro9OIrK0AMBMUvTwxveAq1Kt VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6mehfbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 14:20:33 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EDTOng003107;
        Mon, 14 Mar 2022 14:20:33 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6mehfa6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 14:20:33 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EE7CF5023843;
        Mon, 14 Mar 2022 14:20:31 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3erjshmcq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 14:20:30 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EEKRn455443892
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 14:20:27 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0797952081;
        Mon, 14 Mar 2022 14:20:24 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.12.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9CE725207A;
        Mon, 14 Mar 2022 14:20:23 +0000 (GMT)
Date:   Mon, 14 Mar 2022 15:20:21 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com, mimu@linux.ibm.com,
        Heiko Carstens <hca@linux.ibm.com>
Subject: Re: [PATCH v1 1/1] KVM: s390x: fix SCK locking
Message-ID: <20220314152021.3d536f58@p-imbrenda>
In-Reply-To: <a708afc8-c8e6-8af3-3514-53be3368131a@linux.ibm.com>
References: <20220301143340.111129-1-imbrenda@linux.ibm.com>
        <391eeaf9-3fa6-13eb-c9c9-bc4768b0605b@de.ibm.com>
        <a708afc8-c8e6-8af3-3514-53be3368131a@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: grbE7g-N_8g3g3jhaNcKqsaMt9ZqVzKj
X-Proofpoint-ORIG-GUID: pmRSK78j2FwA-IiUjG3W8a1X2Fw6hYng
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_08,2022-03-14_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 mlxlogscore=999 suspectscore=0 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203140089
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 14 Mar 2022 15:02:13 +0100
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> On 3/14/22 14:33, Christian Borntraeger wrote:
> > Am 01.03.22 um 15:33 schrieb Claudio Imbrenda: =20
> >> When handling the SCK instruction, the kvm lock is taken, even though
> >> the vcpu lock is already being held. The normal locking order is kvm
> >> lock first and then vcpu lock. This is can (and in some circumstances
> >> does) lead to deadlocks.
> >>
> >> The function kvm_s390_set_tod_clock is called both by the SCK handler
> >> and by some IOCTLs to set the clock. The IOCTLs will not hold the vcpu
> >> lock, so they can safely take the kvm lock. The SCK handler holds the
> >> vcpu lock, but will also somehow need to acquire the kvm lock without
> >> relinquishing the vcpu lock.
> >>
> >> The solution is to factor out the code to set the clock, and provide
> >> two wrappers. One is called like the original function and does the
> >> locking, the other is called kvm_s390_try_set_tod_clock and uses
> >> trylock to try to acquire the kvm lock. This new wrapper is then used
> >> in the SCK handler. If locking fails, -EAGAIN is returned, which is
> >> eventually propagated to userspace, thus also freeing the vcpu lock and
> >> allowing for forward progress.
> >>
> >> This is not the most efficient or elegant way to solve this issue, but
> >> the SCK instruction is deprecated and its performance is not critical.
> >>
> >> The goal of this patch is just to provide a simple but correct way to
> >> fix the bug.
> >>
> >> Fixes: 6a3f95a6b04c ("KVM: s390: Intercept SCK instruction")
> >> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> >> ---
> >> =C2=A0 arch/s390/kvm/kvm-s390.c | 19 ++++++++++++++++---
> >> =C2=A0 arch/s390/kvm/kvm-s390.h |=C2=A0 4 ++--
> >> =C2=A0 arch/s390/kvm/priv.c=C2=A0=C2=A0=C2=A0=C2=A0 | 14 +++++++++++++-
> >> =C2=A0 3 files changed, 31 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> >> index 2296b1ff1e02..4e3db4004bfd 100644
> >> --- a/arch/s390/kvm/kvm-s390.c
> >> +++ b/arch/s390/kvm/kvm-s390.c
> >> @@ -3869,14 +3869,12 @@ static int kvm_s390_handle_requests(struct kvm=
_vcpu *vcpu)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
> >> =C2=A0 }
> >> =C2=A0 -void kvm_s390_set_tod_clock(struct kvm *kvm,
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 const struct kvm_s390_vm_tod_clock *gtod)
> >> +static void __kvm_s390_set_tod_clock(struct kvm *kvm, const struct kv=
m_s390_vm_tod_clock *gtod)
> >> =C2=A0 {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct kvm_vcpu *vcpu;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 union tod_clock clk;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long i;
> >> =C2=A0 -=C2=A0=C2=A0=C2=A0 mutex_lock(&kvm->lock);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 preempt_disable();
> >> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 store_tod_clock_ext(&clk);
> >> @@ -3897,7 +3895,22 @@ void kvm_s390_set_tod_clock(struct kvm *kvm,
> >> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_s390_vcpu_unblock_all(kvm);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 preempt_enable();
> >> +}
> >> +
> >> +void kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm=
_tod_clock *gtod)
> >> +{
> >> +=C2=A0=C2=A0=C2=A0 mutex_lock(&kvm->lock);
> >> +=C2=A0=C2=A0=C2=A0 __kvm_s390_set_tod_clock(kvm, gtod);
> >> +=C2=A0=C2=A0=C2=A0 mutex_unlock(&kvm->lock);
> >> +}
> >> +
> >> +int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390=
_vm_tod_clock *gtod)
> >> +{
> >> +=C2=A0=C2=A0=C2=A0 if (!mutex_trylock(&kvm->lock))
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
> >> +=C2=A0=C2=A0=C2=A0 __kvm_s390_set_tod_clock(kvm, gtod);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_unlock(&kvm->lock);
> >> +=C2=A0=C2=A0=C2=A0 return 1;
> >> =C2=A0 }
> >> =C2=A0 =C2=A0 /**
> >> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> >> index 098831e815e6..f2c910763d7f 100644
> >> --- a/arch/s390/kvm/kvm-s390.h
> >> +++ b/arch/s390/kvm/kvm-s390.h
> >> @@ -349,8 +349,8 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu);
> >> =C2=A0 int kvm_s390_handle_sigp_pei(struct kvm_vcpu *vcpu);
> >> =C2=A0 =C2=A0 /* implemented in kvm-s390.c */
> >> -void kvm_s390_set_tod_clock(struct kvm *kvm,
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 const struct kvm_s390_vm_tod_clock *gtod);
> >> +void kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm=
_tod_clock *gtod);
> >> +int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390=
_vm_tod_clock *gtod);
> >> =C2=A0 long kvm_arch_fault_in_page(struct kvm_vcpu *vcpu, gpa_t gpa, i=
nt writable);
> >> =C2=A0 int kvm_s390_store_status_unloaded(struct kvm_vcpu *vcpu, unsig=
ned long addr);
> >> =C2=A0 int kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu, unsigned =
long addr);
> >> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> >> index 417154b314a6..7f3e7990ef82 100644
> >> --- a/arch/s390/kvm/priv.c
> >> +++ b/arch/s390/kvm/priv.c
> >> @@ -102,7 +102,19 @@ static int handle_set_clock(struct kvm_vcpu *vcpu)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return kvm_s390=
_inject_prog_cond(vcpu, rc);
> >> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 VCPU_EVENT(vcpu, 3, "SCK: settin=
g guest TOD to 0x%llx", gtod.tod);
> >> -=C2=A0=C2=A0=C2=A0 kvm_s390_set_tod_clock(vcpu->kvm, &gtod);
> >> +=C2=A0=C2=A0=C2=A0 /*
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 * To set the TOD clock we need to take the k=
vm lock, but we are
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 * already holding the vcpu lock, and the usu=
al lock order is the
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 * opposite. Therefore we use trylock instead=
 of lock, and if the
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 * kvm lock cannot be taken, we retry the ins=
truction and return
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 * -EAGAIN to userspace, thus freeing the vcp=
u lock.
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 * The SCK instruction is considered legacy a=
nd at this point it's
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 * not worth the effort to find a nicer solut=
ion.
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 */ =20
> >=20
> > To comply more with usual comment style (no we, us) and to give more co=
ntext
> > on the legacy I will slightly modify the comment before sending out.
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0/*
> > =C2=A0=C2=A0=C2=A0=C2=A0 * To set the TOD clock the kvm lock must be ta=
ken, but the vcpu
> > =C2=A0=C2=A0=C2=A0=C2=A0 * lock is already held in handle_set_clock. Th=
e usual lock order
> > =C2=A0=C2=A0=C2=A0=C2=A0 * is the opposite.
> > =C2=A0=C2=A0=C2=A0=C2=A0 * As SCK is deprecated and should not be used =
in several cases =20
>=20
> I think you'd want commas around that clause, i.e.
> 	* As SCK is deprecated and should not be used in several cases,
> 	* for example when the multiple-opoch or the TOD-clock-steering
> 	* facility is installed (see Principles of Operation),
> 	* a slow path can be used.
>=20

+1

looks good with the commas

> > =C2=A0=C2=A0=C2=A0=C2=A0 * like the existence of the multiple epoch fac=
ility or TOD clock> =C2=A0=C2=A0=C2=A0=C2=A0 * steering (see Principles of =
Operation) a slow path can be used.
> > =C2=A0=C2=A0=C2=A0=C2=A0 * If the lock can not be taken via try_lock, t=
he instruction will
> > =C2=A0=C2=A0=C2=A0=C2=A0 * be retried via -EAGAIN at a later point in t=
ime.
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> >=20
> > Ok with everybody?
> >=20
> >=20
> >  =20
> >> +=C2=A0=C2=A0=C2=A0 if (!kvm_s390_try_set_tod_clock(vcpu->kvm, &gtod))=
 {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_s390_retry_instr(vcpu);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EAGAIN;
> >> +=C2=A0=C2=A0=C2=A0 }
> >> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_s390_set_psw_cc(vcpu, 0);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0; =20
>=20


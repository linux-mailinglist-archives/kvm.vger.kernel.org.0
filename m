Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F05FA4AF0DB
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 13:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbiBIMHJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 07:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbiBIMGI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 07:06:08 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D0FC002B5B;
        Wed,  9 Feb 2022 03:05:08 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219AwwD6000818;
        Wed, 9 Feb 2022 11:05:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=LHfiMXVZg7ZVpowzCte9q2RfZJaMyGlfoite7Y+tdGo=;
 b=lbvVSjWLy/9lFUxIN0EO//SqgtIFZDTr+KfVGQUOzStVGOCHRzptEeTFETPyr/qoQckC
 n1wCuFXu4yNIt3EY/5d38c+Di4BowV7tSMvYbhtJalEkESm12ve9uHesGDVVflmEUF8K
 +bEwRSK9b3aCbYz2txZpaELTUzRQAluC35uc0n2+mft4m2xtgm+Cszpck6fFT4iNUgxA
 dVtP0aMHpHsoKbKd69uzfzKttGewY2ybwl4OmHHRjeApRWfMPTSusrrbl9OtdBmQKfwO
 33bNRyX1xfPdpovDZDGljSMa1Z1lDUhW/2ipSpi2WxguE5CvyKPsPLBMF4ybNYNbec5x Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e4cb6g38s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 11:05:06 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 219Aws7N000771;
        Wed, 9 Feb 2022 11:05:05 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e4cb6g388-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 11:05:05 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 219B4xqj008545;
        Wed, 9 Feb 2022 11:05:04 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3e1ggk66q6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 11:05:03 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 219B4xXs48562576
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Feb 2022 11:04:59 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3859AE072;
        Wed,  9 Feb 2022 11:04:59 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 116ECAE079;
        Wed,  9 Feb 2022 11:04:59 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.75.42])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Feb 2022 11:04:58 +0000 (GMT)
Message-ID: <1eb6ae828fd02340ff30bfab6a949fff90e85d3b.camel@linux.ibm.com>
Subject: Re: [PATCH v2 05/11] KVM: s390: Add optional storage key checking
 to MEMOP IOCTL
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Date:   Wed, 09 Feb 2022 12:04:58 +0100
In-Reply-To: <ef35d70a-c0dc-e5ae-8182-79847085d593@linux.ibm.com>
References: <20220207165930.1608621-1-scgl@linux.ibm.com>
         <20220207165930.1608621-6-scgl@linux.ibm.com>
         <48d1678f-746c-dab6-5ec3-56397277f752@linux.ibm.com>
         <71f07914-d0b2-e98b-22b2-bc05f04df2da@linux.ibm.com>
         <6ea27647-fbbe-3962-03a0-8ca5340fc7fd@linux.ibm.com>
         <8d502356c3a624847c0dd2fe5d5f60e72923a141.camel@linux.ibm.com>
         <3ec91f7a-10ca-b984-d852-1327f965b1e8@linux.ibm.com>
         <83408abf-86fe-20b0-564c-8cf840757e76@linux.ibm.com>
         <ef35d70a-c0dc-e5ae-8182-79847085d593@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OQCO6zO4JOftPp5kM8pvUdQrvmjN1mxA
X-Proofpoint-GUID: wIUjsMzPqKKI5F8ZIW3PqCZnqVMMLk_p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_06,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 impostorscore=0
 mlxscore=0 spamscore=0 malwarescore=0 priorityscore=1501 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202090069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-02-09 at 11:48 +0100, Christian Borntraeger wrote:
> 
> Am 09.02.22 um 11:39 schrieb Janis Schoetterl-Glausch:
> > On 2/9/22 11:08, Christian Borntraeger wrote:
> > > 
> > > Am 09.02.22 um 11:01 schrieb Janis Schoetterl-Glausch:
> > > > On Wed, 2022-02-09 at 10:08 +0100, Christian Borntraeger wrote:
> > > > > Am 09.02.22 um 09:49 schrieb Janis Schoetterl-Glausch:
> > > > > > On 2/9/22 08:34, Christian Borntraeger wrote:
> > > > > > > Am 07.02.22 um 17:59 schrieb Janis Schoetterl-Glausch:
> > > > > > > > User space needs a mechanism to perform key checked accesses when
> > > > > > > > emulating instructions.
> > > > > > > > 
> > > > > > > > The key can be passed as an additional argument.
> > > > > > > > Having an additional argument is flexible, as user space can
> > > > > > > > pass the guest PSW's key, in order to make an access the same way the
> > > > > > > > CPU would, or pass another key if necessary.
> > > > > > > > 
> > > > > > > > Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> > > > > > > > Acked-by: Janosch Frank <frankja@linux.ibm.com>
> > > > > > > > Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > > > > > > > ---
> > > > > > > >      arch/s390/kvm/kvm-s390.c | 49 +++++++++++++++++++++++++++++++---------
> > > > > > > >      include/uapi/linux/kvm.h |  8 +++++--
> > > > > > > >      2 files changed, 44 insertions(+), 13 deletions(-)
> > > > > > > > 
> > > > > > > > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > > > > > > > index cf347e1a4f17..71e61fb3f0d9 100644
> > > > > > > > --- a/arch/s390/kvm/kvm-s390.c
> > > > > > > > +++ b/arch/s390/kvm/kvm-s390.c
> > > > > > > > @@ -32,6 +32,7 @@
> > > > > > > >      #include <linux/sched/signal.h>
> > > > > > > >      #include <linux/string.h>
> > > > > > > >      #include <linux/pgtable.h>
> > > > > > > > +#include <linux/bitfield.h>
> > > > > > > >        #include <asm/asm-offsets.h>
> > > > > > > >      #include <asm/lowcore.h>
> > > > > > > > @@ -2359,6 +2360,11 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
> > > > > > > >          return r;
> > > > > > > >      }
> > > > > > > >      +static bool access_key_invalid(u8 access_key)
> > > > > > > > +{
> > > > > > > > +    return access_key > 0xf;
> > > > > > > > +}
> > > > > > > > +
> > > > > > > >      long kvm_arch_vm_ioctl(struct file *filp,
> > > > > > > >                     unsigned int ioctl, unsigned long arg)
> > > > > > > >      {
> > > > > > > > @@ -4687,34 +4693,54 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
> > > > > > > >                        struct kvm_s390_mem_op *mop)
> > > > > > > >      {
> > > > > > > >          void __user *uaddr = (void __user *)mop->buf;
> > > > > > > > +    u8 access_key = 0, ar = 0;
> > > > > > > >          void *tmpbuf = NULL;
> > > > > > > > +    bool check_reserved;
> > > > > > > >          int r = 0;
> > > > > > > >          const u64 supported_flags = KVM_S390_MEMOP_F_INJECT_EXCEPTION
> > > > > > > > -                    | KVM_S390_MEMOP_F_CHECK_ONLY;
> > > > > > > > +                    | KVM_S390_MEMOP_F_CHECK_ONLY
> > > > > > > > +                    | KVM_S390_MEMOP_F_SKEY_PROTECTION;
> > > > > > > >      -    if (mop->flags & ~supported_flags || mop->ar >= NUM_ACRS || !mop->size)
> > > > > > > > +    if (mop->flags & ~supported_flags || !mop->size)
> > > > > > > >              return -EINVAL;
> > > > > > > > -
> > > > > > > >          if (mop->size > MEM_OP_MAX_SIZE)
> > > > > > > >              return -E2BIG;
> > > > > > > > -
> > > > > > > >          if (kvm_s390_pv_cpu_is_protected(vcpu))
> > > > > > > >              return -EINVAL;
> > > > > > > > -
> > > > > > > >          if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
> > > > > > > >              tmpbuf = vmalloc(mop->size);
> > > > > > > >              if (!tmpbuf)
> > > > > > > >                  return -ENOMEM;
> > > > > > > >          }
> > > > > > > > +    ar = mop->ar;
> > > > > > > > +    mop->ar = 0;
> > > > > > > 
> > > > > > > Why this assignment to 0?
> > > > > > 
> > > > > > It's so the check of reserved below works like that, they're all part of the anonymous union.
> > > > > 
> > > > > Ah, I see. This is ugly :-)
> > > > 
> > > > Yes :)
> > > > > > > > +    if (ar >= NUM_ACRS)
> > > > > > > > +        return -EINVAL;
> > > > > > > > +    if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
> > > > > > > > +        access_key = mop->key;
> > > > > > > > +        mop->key = 0;
> > > > > > > 
> > > > > > > and this? I think we can leave mop unchanged.
> > > > > > > 
> > > > > > > In fact, why do we add the ar and access_key variable?
> > > > > > > This breaks the check from above (if (mop->flags & ~supported_flags || mop->ar >= NUM_ACRS || !mop->size))  into two checks
> > > > > > > and it will create a memleak for tmpbuf.
> > > > > > 
> > > > > > I can move the allocation down, goto out or get rid of the reserved check and keep everything as before.
> > > > > > First is simpler, but second makes handling that case more explicit and might help in the future.
> > > > > 
> > > > > Maybe add a reserved_02 field in the anon struct and check this for being zero and get rid of the local variables?
> > > > 
> > > > I think that would require us adding new fields in the struct by putting them in a union with reserved_02 and so on,
> > > > which could get rather messy.
> > > 
> > > I think it is fine to rename reserved_02. Maybe rename that to dont_use_02 ?
> > 
> > I don't know what kind of stability guarantees we give here, since it can only happen when recompiling with
> > a new header. dont_use is a lot better than reserved here, after all we tell user space to set
> > reserved bytes to 0, using reserved_02 to do that would be quite handy and therefore likely.
> > 
> > The question is also what semantic we want for the check.
> > The way it works right now, user space also needs to set unused fields to 0, e.g. key if the flag is not set.
> > At least this is the case for the vm memop, the vcpu memop cannot do that because of backward compatibility.
> 
> As an alternative just remove the check for reserved == 0 and do that later on as an add-on patch?

That would kinda defeat the purpose of the check, since misbehaving user space programs would
get an error then but not now.


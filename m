Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6700F4B12D2
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 17:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244217AbiBJQeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 11:34:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240006AbiBJQd7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 11:33:59 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45121128;
        Thu, 10 Feb 2022 08:34:00 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21AEbdii022529;
        Thu, 10 Feb 2022 16:34:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=g57ywYNBpp/+DdoeErzjbSZAtuE4dkfFN3FYvJUBMLo=;
 b=e3BEUzV/Q+OIQ9IK78Vhw7WFsPrTNzmsHbyX7sjyaNqBoz3XW+1TXYUytfiB5BQQCYdJ
 7CDIKQuzV9USdqMyN0uQZmmB5VdK9hlKJ2r0NNEmsRgqGvQfk8VGo76SqP3k5xzvtdmX
 pEj29m9trfONCYq+oihGGbRgJ4KV2p4Cp3l6NLeDxrfX8XEAgvlW0arjAXmVW45befnK
 uuUddOYns3FUXQgHhmoejUlxE1DOJHDJWjRHAcgREexO/l/1xFecKwjM2N1u2GPKl6Gy
 DjVjtDwqHkeToGQojCjDVA/dTq++7DHf+ESXU6F6Xw9Nj/dvOqqqznqLxhAKr5ElQVII rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e529ty34k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 16:33:59 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21AGT4CW026795;
        Thu, 10 Feb 2022 16:33:59 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e529ty33n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 16:33:59 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21AGW5U3030786;
        Thu, 10 Feb 2022 16:33:56 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3e1gv9t3gu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 16:33:56 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21AGXqd943319738
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Feb 2022 16:33:52 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 181EEAE056;
        Thu, 10 Feb 2022 16:33:52 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76E26AE051;
        Thu, 10 Feb 2022 16:33:51 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.14.149])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Feb 2022 16:33:51 +0000 (GMT)
Date:   Thu, 10 Feb 2022 17:33:49 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v3 05/10] KVM: s390: Add optional storage key checking
 to MEMOP IOCTL
Message-ID: <20220210173349.6f498780@p-imbrenda>
In-Reply-To: <0310d3c8-7dd3-a840-9c54-f4de35a6b465@linux.ibm.com>
References: <20220209170422.1910690-1-scgl@linux.ibm.com>
        <20220209170422.1910690-6-scgl@linux.ibm.com>
        <0310d3c8-7dd3-a840-9c54-f4de35a6b465@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GP2VuSzmwQqpB84fZ39mu2cFTb0ax_jE
X-Proofpoint-ORIG-GUID: PWueAQtlKzcTV8T18jX_f4cwyS6WwUJe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-10_07,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 adultscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202100087
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Feb 2022 12:59:03 +0100
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> On 2/9/22 18:04, Janis Schoetterl-Glausch wrote:
> > User space needs a mechanism to perform key checked accesses when
> > emulating instructions.
> > 
> > The key can be passed as an additional argument.
> > Having an additional argument is flexible, as user space can
> > pass the guest PSW's key, in order to make an access the same way the
> > CPU would, or pass another key if necessary.
> > 
> > Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> > Acked-by: Janosch Frank <frankja@linux.ibm.com>
> > Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  arch/s390/kvm/kvm-s390.c | 30 ++++++++++++++++++++----------
> >  include/uapi/linux/kvm.h |  6 +++++-
> >  2 files changed, 25 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index cf347e1a4f17..85763ec7bc60 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -32,6 +32,7 @@
> >  #include <linux/sched/signal.h>
> >  #include <linux/string.h>
> >  #include <linux/pgtable.h>
> > +#include <linux/bitfield.h>
> >  
> >  #include <asm/asm-offsets.h>
> >  #include <asm/lowcore.h>
> > @@ -2359,6 +2360,11 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
> >  	return r;
> >  }
> >  
> > +static bool access_key_invalid(u8 access_key)
> > +{
> > +	return access_key > 0xf;
> > +}
> > +
> >  long kvm_arch_vm_ioctl(struct file *filp,
> >  		       unsigned int ioctl, unsigned long arg)
> >  {
> > @@ -4690,17 +4696,19 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
> >  	void *tmpbuf = NULL;
> >  	int r = 0;
> >  	const u64 supported_flags = KVM_S390_MEMOP_F_INJECT_EXCEPTION
> > -				    | KVM_S390_MEMOP_F_CHECK_ONLY;
> > +				    | KVM_S390_MEMOP_F_CHECK_ONLY
> > +				    | KVM_S390_MEMOP_F_SKEY_PROTECTION;
> >  
> >  	if (mop->flags & ~supported_flags || mop->ar >= NUM_ACRS || !mop->size)
> >  		return -EINVAL;
> > -
> >  	if (mop->size > MEM_OP_MAX_SIZE)
> >  		return -E2BIG;
> > -
> >  	if (kvm_s390_pv_cpu_is_protected(vcpu))
> >  		return -EINVAL;
> > -
> > +	if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
> > +		if (access_key_invalid(mop->key))
> > +			return -EINVAL;  
> 
> I got this wrong unfortunately, we need to explicitly default to key 0, i.e.
> +       } else {
> +               mop->key = 0;
> Same for the vm memop.
> Didn't have a test case for this, yet.

you can keep my r-b once you fix this (and the spurious include)

> > +	}>  	if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
> >  		tmpbuf = vmalloc(mop->size);
> >  		if (!tmpbuf)
> > @@ -4710,11 +4718,12 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
> >  	switch (mop->op) {
> >  	case KVM_S390_MEMOP_LOGICAL_READ:
> >  		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
> > -			r = check_gva_range(vcpu, mop->gaddr, mop->ar,
> > -					    mop->size, GACC_FETCH, 0);
> > +			r = check_gva_range(vcpu, mop->gaddr, mop->ar, mop->size,
> > +					    GACC_FETCH, mop->key);
> >  			break;
> >  		}
> > -		r = read_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
> > +		r = read_guest_with_key(vcpu, mop->gaddr, mop->ar, tmpbuf,
> > +					mop->size, mop->key);
> >  		if (r == 0) {
> >  			if (copy_to_user(uaddr, tmpbuf, mop->size))
> >  				r = -EFAULT;
> > @@ -4722,15 +4731,16 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
> >  		break;
> >  	case KVM_S390_MEMOP_LOGICAL_WRITE:
> >  		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
> > -			r = check_gva_range(vcpu, mop->gaddr, mop->ar,
> > -					    mop->size, GACC_STORE, 0);
> > +			r = check_gva_range(vcpu, mop->gaddr, mop->ar, mop->size,
> > +					    GACC_STORE, mop->key);
> >  			break;
> >  		}
> >  		if (copy_from_user(tmpbuf, uaddr, mop->size)) {
> >  			r = -EFAULT;
> >  			break;
> >  		}
> > -		r = write_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
> > +		r = write_guest_with_key(vcpu, mop->gaddr, mop->ar, tmpbuf,
> > +					 mop->size, mop->key);
> >  		break;
> >  	}
> >    
> 
> [...]


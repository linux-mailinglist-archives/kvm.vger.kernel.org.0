Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B532403F4A
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 20:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350258AbhIHSvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 14:51:47 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10244 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1350225AbhIHSvq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Sep 2021 14:51:46 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 188IXX51157759;
        Wed, 8 Sep 2021 14:50:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=VejXnR12bwgW4mRU9KCmWfR44BHrQLRMaeGV6lm6q7A=;
 b=fh21NFPlPMNUvNTl12ZYMWDEqHdOiiQgM1XBFk1BeadMqdGv46vLXn6s5B3VlB9EA/D1
 ON12ahX1RsRlJf4kUuELwCLIkkKUrsV9Rv0Uf0vsUq+I8Gu26Fn32O1w2g1E0t0N3IzE
 4IGH1uKDJFNNkxXqtm2XwMvqEVnknl/HfJ55QQ3fC9EBwkgQjMnPAbe6awUOWGUgp/f2
 RgkK7fF4AxlmSB0r68TVmzfZl+j8GofhVadbCNsOlq2CxTGPiC2LfO7lfhzMlPyAhaIC
 pMKIauGPrRoDUhzY2uBlCy8SSBoh04821BIZ53u/8aCkQdHHiZLMhtJzTTbfJ0gcfZIN ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3axmvn4px4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Sep 2021 14:50:37 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 188IXu6O158782;
        Wed, 8 Sep 2021 14:50:37 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3axmvn4pwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Sep 2021 14:50:37 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 188Ig5S8032425;
        Wed, 8 Sep 2021 18:50:35 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3axcnk4nsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Sep 2021 18:50:35 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 188IoU4M44302710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Sep 2021 18:50:31 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E42264C04E;
        Wed,  8 Sep 2021 18:50:30 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DD944C044;
        Wed,  8 Sep 2021 18:50:30 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.12.56])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Sep 2021 18:50:30 +0000 (GMT)
Date:   Wed, 8 Sep 2021 20:50:27 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: Re: [PATCH v4 02/14] KVM: s390: pv: avoid double free of sida page
Message-ID: <20210908205027.4f595c6e@p-imbrenda>
In-Reply-To: <ad1a386e-3ae9-13d7-430b-c24ed0cc4c85@de.ibm.com>
References: <20210818132620.46770-1-imbrenda@linux.ibm.com>
        <20210818132620.46770-3-imbrenda@linux.ibm.com>
        <ad1a386e-3ae9-13d7-430b-c24ed0cc4c85@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4IXWemJVoDLCywAFRMKkLPfjgnaL-fS5
X-Proofpoint-ORIG-GUID: wOH3UOAOAE2G1x9GlRAeV9EEWjkiSP0B
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-08_06:2021-09-07,2021-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 mlxlogscore=782 suspectscore=0 impostorscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109080116
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 31 Aug 2021 15:55:07 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 18.08.21 15:26, Claudio Imbrenda wrote:
> > If kvm_s390_pv_destroy_cpu is called more than once, we risk calling
> > free_page on a random page, since the sidad field is aliased with the
> > gbea, which is not guaranteed to be zero.
> > 
> > The solution is to simply return successfully immediately if the vCPU
> > was already non secure.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Fixes: 19e1227768863a1469797c13ef8fea1af7beac2c ("KVM: S390: protvirt: Introduce instruction data area bounce buffer")  
> 
> Patch looks good. Do we have any potential case where we call this twice? In other words,
> do we need the Fixes tag with the code as of today or not?

I think so.

if QEMU calls KVM_PV_DISABLE, and it fails, some VCPUs might have been
made non secure, but the VM itself still counts as secure. QEMU can
then call KVM_PV_DISABLE again, which will try to convert all VCPUs to
non secure again, triggering this bug.

this scenario will not happen in practice (unless the hardware is
broken)

> > ---
> >   arch/s390/kvm/pv.c | 19 +++++++++----------
> >   1 file changed, 9 insertions(+), 10 deletions(-)
> > 
> > diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> > index c8841f476e91..0a854115100b 100644
> > --- a/arch/s390/kvm/pv.c
> > +++ b/arch/s390/kvm/pv.c
> > @@ -16,18 +16,17 @@
> >   
> >   int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
> >   {
> > -	int cc = 0;
> > +	int cc;
> >   
> > -	if (kvm_s390_pv_cpu_get_handle(vcpu)) {
> > -		cc = uv_cmd_nodata(kvm_s390_pv_cpu_get_handle(vcpu),
> > -				   UVC_CMD_DESTROY_SEC_CPU, rc, rrc);
> > +	if (!kvm_s390_pv_cpu_get_handle(vcpu))
> > +		return 0;
> > +
> > +	cc = uv_cmd_nodata(kvm_s390_pv_cpu_get_handle(vcpu), UVC_CMD_DESTROY_SEC_CPU, rc, rrc);
> > +
> > +	KVM_UV_EVENT(vcpu->kvm, 3, "PROTVIRT DESTROY VCPU %d: rc %x rrc %x",
> > +		     vcpu->vcpu_id, *rc, *rrc);
> > +	WARN_ONCE(cc, "protvirt destroy cpu failed rc %x rrc %x", *rc, *rrc);
> >   
> > -		KVM_UV_EVENT(vcpu->kvm, 3,
> > -			     "PROTVIRT DESTROY VCPU %d: rc %x rrc %x",
> > -			     vcpu->vcpu_id, *rc, *rrc);
> > -		WARN_ONCE(cc, "protvirt destroy cpu failed rc %x rrc %x",
> > -			  *rc, *rrc);
> > -	}
> >   	/* Intended memory leak for something that should never happen. */
> >   	if (!cc)
> >   		free_pages(vcpu->arch.pv.stor_base,
> >   


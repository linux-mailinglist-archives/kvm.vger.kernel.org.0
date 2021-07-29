Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05173DA444
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 15:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237761AbhG2N3c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 09:29:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15098 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237752AbhG2N3L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 09:29:11 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TDSLcK064929;
        Thu, 29 Jul 2021 09:29:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=UlOZAV3njL9WgqZBD8YgjqqBRmlVJi6DL813I4lx2rE=;
 b=Z5b5nnjjaXk8iHz+dsjeJlcmsHWgHWcnUCZucaOA0C/jfGMOXZcthS0F5fpzKnaQWnne
 w79U0ITFzJpubb8axxMHj8KkpCUt8LDTwOoJoOJm6TcZ+9WcNJn3XAOOOSPIpZMtvUwo
 HpDDMskuUgK5LvBi+Lc3ndlbHWBOQRrohk+c0G5OPyb9xgyujSpSaMbMSJe4SyaQcFYl
 9Uyfa8JLsX9siovWKwqN3Llr81Ya5SKA7gRzQKN4Cj1wjzgfNCiMVuOPuB8Zwr2h7eUP
 IMgFzzUOgpKqppqvyIAAZ15QaqkRmzO0wjEKAv7Ib+vE1a6vuVE5p21kgHTI377IzVtz uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3w8cr0nu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 09:29:07 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16TDSwQE072095;
        Thu, 29 Jul 2021 09:29:07 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3w8cr0n3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 09:29:06 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16TDIh3H017669;
        Thu, 29 Jul 2021 13:29:04 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3a235ks4ht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 13:29:04 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16TDT0pO27001110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 13:29:01 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C923DA4060;
        Thu, 29 Jul 2021 13:29:00 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5AE63A405C;
        Thu, 29 Jul 2021 13:29:00 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.151])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 29 Jul 2021 13:29:00 +0000 (GMT)
Date:   Thu, 29 Jul 2021 15:22:05 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/13] KVM: s390: pv: avoid stall notifications for
 some UVCs
Message-ID: <20210729152205.73d39a65@p-imbrenda>
In-Reply-To: <87h7gd2y5c.fsf@redhat.com>
References: <20210728142631.41860-1-imbrenda@linux.ibm.com>
        <20210728142631.41860-2-imbrenda@linux.ibm.com>
        <87h7gd2y5c.fsf@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SxWz63jsLsS7B6Gg-v2kr-IWBqk9ZxJu
X-Proofpoint-ORIG-GUID: OPLqKlrIQPiVMfVwBdLbob15-vblMzzr
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_10:2021-07-29,2021-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 29 Jul 2021 12:49:03 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Wed, Jul 28 2021, Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:
> 
> > Improve make_secure_pte to avoid stalls when the system is heavily
> > overcommitted. This was especially problematic in
> > kvm_s390_pv_unpack, because of the loop over all pages that needed
> > unpacking.
> >
> > Also fix kvm_s390_pv_init_vm to avoid stalls when the system is
> > heavily overcommitted.
> >
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  arch/s390/kernel/uv.c | 11 ++++++++---
> >  arch/s390/kvm/pv.c    |  2 +-
> >  2 files changed, 9 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> > index aeb0a15bcbb7..fd0faa51c1bb 100644
> > --- a/arch/s390/kernel/uv.c
> > +++ b/arch/s390/kernel/uv.c
> > @@ -196,11 +196,16 @@ static int make_secure_pte(pte_t *ptep,
> > unsigned long addr, if (!page_ref_freeze(page, expected))
> >  		return -EBUSY;
> >  	set_bit(PG_arch_1, &page->flags);
> > -	rc = uv_call(0, (u64)uvcb);
> > +	rc = __uv_call(0, (u64)uvcb);
> >  	page_ref_unfreeze(page, expected);
> > -	/* Return -ENXIO if the page was not mapped, -EINVAL
> > otherwise */
> > -	if (rc)
> > +	/*
> > +	 * Return -ENXIO if the page was not mapped, -EINVAL for
> > other errors.
> > +	 * If busy or partially completed, return -EAGAIN.
> > +	 */
> > +	if (rc == 1)
> >  		rc = uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
> > +	else if (rc > 1)
> > +		rc = -EAGAIN;
> >  	return rc;
> >  }  
> 
> Possibly dumb question: when does the call return > 1?

this is exactly what Janosch meant :)

the next version will have #defines for the 4 possible CC values.

in short:
0 OK
1 error
2 busy (nothing done, try again)
3 partial (something done but not all, try again)

> gmap_make_secure() will do a wait_on_page_writeback() for -EAGAIN, is
> that always the right thing to do?

it's the easiest way to get to a place where we will be able to
reschedule if needed.

wait_on_page_writeback will probably do nothing in that case because
the page is not in writeback.

(a few minutes later)

actually I have checked, it seems that the -EAGAIN gets eventually
propagated to places where it's not checked properly!

this will need some more fixing


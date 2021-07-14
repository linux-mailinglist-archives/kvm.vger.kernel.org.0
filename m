Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438EE3C820E
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 11:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238905AbhGNJxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 05:53:32 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5012 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238271AbhGNJxc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Jul 2021 05:53:32 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16E9Y3ED187502;
        Wed, 14 Jul 2021 05:50:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=t4gpCQMDXnpdkc6VBOQdvRGHznSkjRftDBs/orXu85I=;
 b=EVjXkgxEURLlnB+T4SnOUqKiPPoPkzQSV6hQdzQGNkrme0ft+yRn/PhqmWxBDNsqCuaA
 FiUeoPNUv44jObx+YpoI3fMSRBk+gkJjTE+FBm+U4Ujq/l4Op6WYZCDPp5kW2Hupbmlt
 4i8KOyUkkzPaVZS5zOAlIJORNwV3rN9CPXEnUgQtTdnrHOumbd2MWSoVi11z1XPx1sBe
 lXojLXPZ7BaHdTzug7NJT5VqnoTJOmIyG+6KsJUphaA0lx5PGaYqp8qFwFbtpOvqUrVj
 S/MED5svDCeWED4sNd0x7TI8hM1f6MDRIn6dIIOMpbE3ccHBpzZv/u/pb/i6xdg82Ojs 6g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39sde1j5ma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Jul 2021 05:50:40 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16E9ZNXi191345;
        Wed, 14 Jul 2021 05:50:40 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39sde1j5ke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Jul 2021 05:50:40 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16E9n27Z015225;
        Wed, 14 Jul 2021 09:50:38 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 39q2th9q87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Jul 2021 09:50:38 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16E9oYxJ27328954
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 09:50:35 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D67BCA4040;
        Wed, 14 Jul 2021 09:50:34 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C832A404D;
        Wed, 14 Jul 2021 09:50:34 +0000 (GMT)
Received: from osiris (unknown [9.145.156.107])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 14 Jul 2021 09:50:34 +0000 (GMT)
Date:   Wed, 14 Jul 2021 11:50:33 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: generate kvm hypercall functions
Message-ID: <YO6zadbavNXs4Z3+@osiris>
References: <20210713145713.2815167-1-hca@linux.ibm.com>
 <20210714113843.6daa7e09@p-imbrenda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714113843.6daa7e09@p-imbrenda>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8cJMNYiPDGsq2ev834_wHvwhd8GgwkPq
X-Proofpoint-ORIG-GUID: lAMlpMdjYaVs9jcJudzkxGbbtXu4ruXv
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-14_04:2021-07-14,2021-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 spamscore=0 clxscore=1015 mlxlogscore=999 impostorscore=0 adultscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107140062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 14, 2021 at 11:38:43AM +0200, Claudio Imbrenda wrote:
> On Tue, 13 Jul 2021 16:57:13 +0200
> Heiko Carstens <hca@linux.ibm.com> wrote:
> 
> [snip]
> 
> > +#define HYPERCALL_ARGS_0
> > +#define HYPERCALL_ARGS_1 , arg1
> > +#define HYPERCALL_ARGS_2 HYPERCALL_ARGS_1, arg2
> > +#define HYPERCALL_ARGS_3 HYPERCALL_ARGS_2, arg3
> > +#define HYPERCALL_ARGS_4 HYPERCALL_ARGS_3, arg4
> > +#define HYPERCALL_ARGS_5 HYPERCALL_ARGS_4, arg5
> > +#define HYPERCALL_ARGS_6 HYPERCALL_ARGS_5, arg6
> > +
> > +#define GENERATE_KVM_HYPERCALL_FUNC(args)
> > 	\ +static inline
> > 			\ +long __kvm_hypercall##args(unsigned long
> > nr HYPERCALL_PARM_##args)	\ +{
> > 					\
> > +	register unsigned long __nr asm("1") = nr;
> > 	\
> > +	register long __rc asm("2");
> > 	\
> 
> didn't we want to get rid of asm register allocations?
> 
> this would have been a nice time to do such a cleanup

I see only two ways to get rid them, both are suboptimal, therefore I
decided to keep them at very few places; one of them this one.

Alternatively to this approach it would be possible to:

a) write the function entirely in assembler (instead of inlining it).

b) pass a structure with all parameters to the inline assembly and
   clobber a large amount of registers, which _might_ even lead to
   compile errors since the compiler might run out of registers when
   allocating registers for the inline asm.

Given that hypercall is slow anyway a) might be an option. But that's
up to you guys. Otherwise I would consider this the "final" solution
until we get compiler support which allows for something better.

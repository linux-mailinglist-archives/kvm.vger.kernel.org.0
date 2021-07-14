Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4E0A3C83C5
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 13:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbhGNLYu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 07:24:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49762 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230164AbhGNLYu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Jul 2021 07:24:50 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16EB3xL5142064;
        Wed, 14 Jul 2021 07:21:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=GdnJyVHJARk6MNPiC15FadKa0Y4qjKwV9jON7WmVRu8=;
 b=e42KMdQiLiot7CUYQwrF8nkrOJ2VW2ShKPlfhuI0m4Wd6UvCpZv2TXe0ELSnGIG5eIxm
 LJaWfP0AdOh/nTeao/GN6UNn+3sFJMrijHXuuzoDNrq28Br/B/LGOBeQxG6b2SIJlGJs
 IEmHp+jhrJjZqaEMNUIoM9RcZ6VMEYSYvtKGwKNcwyEeh6B19jLWWPrtS5UoMmPg+G77
 R22pedeqShl7/jccrS6d1/hZRXv8jkOVkz/RWMrABUrdfvnKZ2cw/K5jDVE/dKHP/0tM
 kkpauzBRBG/8pkqYsi/3LKhbPSmiCEwfoXJyA8ulrWT/t5WdSU+uSlfvst1l6NTy2urC nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39s8vgfx5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Jul 2021 07:21:58 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16EB4IsJ143998;
        Wed, 14 Jul 2021 07:21:58 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39s8vgfx4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Jul 2021 07:21:58 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16EBIv1R009276;
        Wed, 14 Jul 2021 11:21:56 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 39q368gx2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Jul 2021 11:21:55 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16EBJgs332309586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 11:19:42 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E7994C046;
        Wed, 14 Jul 2021 11:21:52 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2376F4C044;
        Wed, 14 Jul 2021 11:21:52 +0000 (GMT)
Received: from osiris (unknown [9.145.156.107])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 14 Jul 2021 11:21:52 +0000 (GMT)
Date:   Wed, 14 Jul 2021 13:21:50 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: generate kvm hypercall functions
Message-ID: <YO7Izgq+WodlmMcm@osiris>
References: <20210713145713.2815167-1-hca@linux.ibm.com>
 <20210714113843.6daa7e09@p-imbrenda>
 <YO6zadbavNXs4Z3+@osiris>
 <ad7dfe27-cc38-5832-6d43-01b6014d841a@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad7dfe27-cc38-5832-6d43-01b6014d841a@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Vbpw4Hwu8KGf7lNdO2OKd0Dbbs5FFyPg
X-Proofpoint-GUID: JEDNPHNoAunoxd4riBEdUMQNsddhATfy
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-14_04:2021-07-14,2021-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 mlxlogscore=829 clxscore=1015 spamscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107140070
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 14, 2021 at 12:03:20PM +0200, Christian Borntraeger wrote:
> > > didn't we want to get rid of asm register allocations?
> > > this would have been a nice time to do such a cleanup
> > 
> > I see only two ways to get rid them, both are suboptimal, therefore I
> > decided to keep them at very few places; one of them this one.
> > 
> > Alternatively to this approach it would be possible to:
> > 
> > a) write the function entirely in assembler (instead of inlining it).
> 
> I would like to keep this as is, unless we know that this could break.
> Maybe we should add something like nokasan or whatever?

That would only make sense if the function would not be inlined. For
that we have e.g. __no_kasan_or_inline. But then I'd rather prefer
__always_inline. But that wouldn't solve any problems, if you see any.

From my point of view this should be safe wrt instrumentation. There
are only scalar assignments without memory accesses or anything else
the could be instrumented. If even that wouldn't work then "register
asm" would be completely useless. Even though, given all the potential
pitfalls, it is very close to being useless.

So if you want to go that route (noinstr, or whatever), then we need
those functions in a way that they can't be inlined. But keep in mind
that we also have e.g. call_on_stack() with a similar construct which
I'd like to keep inlined for performance reasons.

Let me know if you want any changes to the hypercall code.

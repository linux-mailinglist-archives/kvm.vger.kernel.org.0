Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788963C742D
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhGMQSR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:18:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41178 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234586AbhGMQSN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 12:18:13 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16DG45Oe142719;
        Tue, 13 Jul 2021 12:15:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=VJXHV11dkS5ZO7BU+D6sJmRseM/GF4sEjmGuGQ8JtBU=;
 b=K0m8YFzEsquU1om1WgjZjbsMkt1WOiVp5ls+UJd1PYD0OQy/Sn8cb7ZGigN8xWUGDiVL
 qcEKfZFW0cU2LiXvcexL9A0i+oQ8KVnBJ1W6DzgYkn7nKGYzvYgeWmpftNfJbbSwHLdp
 6dnfq2weL5qf/jcn0kuu3hOPLOvqAqGqeWSCj18b2c7NvZViCgIi/2HBQN5FWNxCudSV
 /Icy0rMmP8r51jqBVVdBHBTD31ftsSPvClyhiNuqcMFMFNnEeLKeAdi5S9Vr5jtCllPL
 1Ja3+ilSYTla5w1RKxktKto1oKds7Pa5zFL56wBd+0KY5ExkRWNZvSZUyQ3zv6kdb4j3 Ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39qs3cb717-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Jul 2021 12:15:23 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16DG4A9n143241;
        Tue, 13 Jul 2021 12:15:22 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39qs3cb70b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Jul 2021 12:15:22 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16DGFKxc023030;
        Tue, 13 Jul 2021 16:15:20 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 39q2th8qsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Jul 2021 16:15:20 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16DGFHAl36372890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 16:15:17 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DA0E4C04E;
        Tue, 13 Jul 2021 16:15:17 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CC214C046;
        Tue, 13 Jul 2021 16:15:17 +0000 (GMT)
Received: from osiris (unknown [9.145.20.227])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 13 Jul 2021 16:15:17 +0000 (GMT)
Date:   Tue, 13 Jul 2021 18:15:15 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: generate kvm hypercall functions
Message-ID: <YO28E42wIH6/aGUm@osiris>
References: <20210713145713.2815167-1-hca@linux.ibm.com>
 <82d32e12-c061-1fe0-0a3e-02c930cbab2e@de.ibm.com>
 <YO22qSixp0VWDle2@osiris>
 <fe51925a-7f1c-fb98-94c9-729c5e23ff08@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe51925a-7f1c-fb98-94c9-729c5e23ff08@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HdIzRpQVaJ6Iy5tcWLUfiCL8nFwePj-K
X-Proofpoint-ORIG-GUID: rijbUf_9EleBgcwYADS17Xpj49NT3ZGS
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-13_07:2021-07-13,2021-07-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=876 phishscore=0 impostorscore=0 suspectscore=0 mlxscore=0
 adultscore=0 malwarescore=0 clxscore=1015 bulkscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107130103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 13, 2021 at 05:59:17PM +0200, Christian Borntraeger wrote:
> On 13.07.21 17:52, Heiko Carstens wrote:
> > On Tue, Jul 13, 2021 at 05:41:33PM +0200, Christian Borntraeger wrote:
> > > On 13.07.21 16:57, Heiko Carstens wrote:
> > > [..]
> > > > +#define HYPERCALL_FMT_0
> > > > +#define HYPERCALL_FMT_1 , "0" (r2)
> > > > +#define HYPERCALL_FMT_2 , "d" (r3) HYPERCALL_FMT_1
> > > > +#define HYPERCALL_FMT_3 , "d" (r4) HYPERCALL_FMT_2
> > > > +#define HYPERCALL_FMT_4 , "d" (r5) HYPERCALL_FMT_3
> > > > +#define HYPERCALL_FMT_5 , "d" (r6) HYPERCALL_FMT_4
> > > > +#define HYPERCALL_FMT_6 , "d" (r7) HYPERCALL_FMT_5
> > > 
> > > This will result in reverse order.
> > > old:
> > > "d" (__nr), "0" (__p1), "d" (__p2), "d" (__p3), "d" (__p4), "d" (__p5), "d" (__p6)
> > > new:
> > > "d"(__nr), "d"(r7), "d"(r6), "d"(r5), "d"(r4), "d"(r3), "0"(r2)
> > > 
> > > As we do not reference the variable in the asm this should not matter,
> > > I just noticed it when comparing the result of the preprocessed files.
> > > 
> > > Assuming that we do not care this looks good.
> > 
> > Yes, it does not matter. Please let me know if should change it anyway.
> 
> No, I think this is ok.
> Shall I take it via the kvm tree or do you want to take it via the s390 tree?

I think this should go via kvm tree. It probably has to wait until next merge
window anyway(?).

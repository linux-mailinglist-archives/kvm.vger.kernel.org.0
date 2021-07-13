Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278413C738B
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 17:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237112AbhGMPzJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 11:55:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29530 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237005AbhGMPzI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 11:55:08 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16DFXiEX119949;
        Tue, 13 Jul 2021 11:52:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=bOe15IcMNyKRwW2/KFNq73xCbcfGLy20CA6LJJnRSSo=;
 b=VvZLDMVjopDmN2BNRefNw/Mj1cIPpATdjdIUcUNd/zXEZAQZWEBD75ENSz93s0IEaAOp
 heH0BwmeLk//Lq+mZBvtLKjeZJ6Ni1qKcZuNm/0kHye6yspN0dU3IcKa1+Zt1Y2VeXjM
 3z/Xg2JiW/VOf72RZGuURfIS8Q0pohXePdKC9OgDX/EqinAZb15VCdKA00/NhsoCg7YT
 F/+p12MGWeUIvcO1nGLPcmQAkLnit6MsB9WBy8gTLg+ZQhwj2TxV5gnrGuzz1QzLVY6O
 OW0np1RaLw7ogSupqkjsx+9vPnSVsDaBgtwc3xZMrgoYQ0TM512B34L3Siq0bFRu66I9 Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39sc2x3wvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Jul 2021 11:52:17 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16DFZrwF131615;
        Tue, 13 Jul 2021 11:52:17 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39sc2x3wv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Jul 2021 11:52:17 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16DFmXtb012526;
        Tue, 13 Jul 2021 15:52:15 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 39q2th9cjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Jul 2021 15:52:14 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16DFqC6927525442
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 15:52:12 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95D2BA405B;
        Tue, 13 Jul 2021 15:52:11 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42F03A406E;
        Tue, 13 Jul 2021 15:52:11 +0000 (GMT)
Received: from osiris (unknown [9.145.20.227])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 13 Jul 2021 15:52:11 +0000 (GMT)
Date:   Tue, 13 Jul 2021 17:52:09 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: generate kvm hypercall functions
Message-ID: <YO22qSixp0VWDle2@osiris>
References: <20210713145713.2815167-1-hca@linux.ibm.com>
 <82d32e12-c061-1fe0-0a3e-02c930cbab2e@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82d32e12-c061-1fe0-0a3e-02c930cbab2e@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qR3rHFeY5z7ZtbseBnxqguc545z673jl
X-Proofpoint-ORIG-GUID: YHY8eLK95ZOwOQ5uk8hFpff9J6wfINro
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-13_07:2021-07-13,2021-07-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 spamscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 mlxlogscore=932 mlxscore=0 adultscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107130099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 13, 2021 at 05:41:33PM +0200, Christian Borntraeger wrote:
> On 13.07.21 16:57, Heiko Carstens wrote:
> [..]
> > +#define HYPERCALL_FMT_0
> > +#define HYPERCALL_FMT_1 , "0" (r2)
> > +#define HYPERCALL_FMT_2 , "d" (r3) HYPERCALL_FMT_1
> > +#define HYPERCALL_FMT_3 , "d" (r4) HYPERCALL_FMT_2
> > +#define HYPERCALL_FMT_4 , "d" (r5) HYPERCALL_FMT_3
> > +#define HYPERCALL_FMT_5 , "d" (r6) HYPERCALL_FMT_4
> > +#define HYPERCALL_FMT_6 , "d" (r7) HYPERCALL_FMT_5
> 
> This will result in reverse order.
> old:
> "d" (__nr), "0" (__p1), "d" (__p2), "d" (__p3), "d" (__p4), "d" (__p5), "d" (__p6)
> new:
> "d"(__nr), "d"(r7), "d"(r6), "d"(r5), "d"(r4), "d"(r3), "0"(r2)
> 
> As we do not reference the variable in the asm this should not matter,
> I just noticed it when comparing the result of the preprocessed files.
> 
> Assuming that we do not care this looks good.

Yes, it does not matter. Please let me know if should change it anyway.

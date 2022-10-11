Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E44B5FB801
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 18:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiJKQKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 12:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiJKQKr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 12:10:47 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF8E54CBF
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 09:10:45 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29BG7cnn004206
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 16:10:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=JHp0WQ/raB1MbT0pqcTMha1u+BIF3D9+40JeWnTl2Ok=;
 b=Y4OmRSP1hkRj+Ynrldbuny84osh2g+j3G0Z8Y7iPhQ5g6ShHDdz/2swjteELPiSF+l/e
 Tee9fdvZJfAFkmLdvQB8ao1yg9v5sw3JohkreHiuH1ak7nOja5G285CJeZXai+/CRji4
 bOWK+0VqK5PR49ZbJrtLiS9N383hXH3FfG1+/MUgEwTgfcuLjMMSWbGKpGcW19jmfH6E
 p57AZuR5d/nMn2KGXP1COFtdtW9M0LBeWemC6GjUTaNUv7dioEth5+aDQ2DrrXjrZgiZ
 Yfrf+9VKunbdr3gW2GY12lkZ2+JdDGruTa5jG0yYJxYGbfochMHDmFoWnPp8Kbtewq7c Tw== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5a6fbjmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 16:10:44 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29BG6APm026398
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 16:10:43 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3k30u8uhj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 16:10:43 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29BGAdmt62980522
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Oct 2022 16:10:39 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7E9BAE04D;
        Tue, 11 Oct 2022 16:10:39 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8812AE045;
        Tue, 11 Oct 2022 16:10:39 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.242])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Oct 2022 16:10:39 +0000 (GMT)
Date:   Tue, 11 Oct 2022 18:10:37 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 0/2] s390x: Add migration test for
 guest TOD clock
Message-ID: <20221011181037.73ae8aa9@p-imbrenda>
In-Reply-To: <70217003-867c-ce7a-7503-2e058e51995c@linux.ibm.com>
References: <20221011151433.886294-1-nrb@linux.ibm.com>
        <70217003-867c-ce7a-7503-2e058e51995c@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BcAaCJmNp_JZky-UoSms55hcv3YAeV2l
X-Proofpoint-ORIG-GUID: BcAaCJmNp_JZky-UoSms55hcv3YAeV2l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-11_08,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 suspectscore=0 impostorscore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 mlxscore=0 adultscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210110092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Oct 2022 17:58:29 +0200
Christian Borntraeger <borntraeger@linux.ibm.com> wrote:

> Am 11.10.22 um 17:14 schrieb Nico Boehr:
> > v1->v2:
> > ---
> > - remove unneeded include
> > - advance clock by 10 minutes instead of 1 minute (thanks Claudio)
> > - express get_clock_us() using stck() (thanks Claudio)
> > 
> > The guest TOD clock should be preserved on migration. Add a test to
> > verify that.  
> 
> I do not fully agree with this assumption. Its the way it curently is, but we might want to have a configurable or different behaviour in the future.
> 
> For example if the difference is smaller than time x it could be allowed to move the time forward to get the guest synced to the new host (never go backward though).

the test is actually testing that the clock does not go backwards,
rather than staying the same

> Or to preserve the time but then slowly step towards the target system clock etc (or for this testcase step the epoch difference towards the original difference).
> 
> So we maybe want to have a comment in here somehow that this is the as-is behaviour.

comments never hurt :)

> 
> > To reduce code duplication, move some of the time-related defined
> > from the sck test to the library.
> > 
> > Nico Boehr (2):
> >    lib/s390x: move TOD clock related functions to library
> >    s390x: add migration TOD clock test
> > 
> >   lib/s390x/asm/time.h  | 50 ++++++++++++++++++++++++++++++++++++++++++-
> >   s390x/Makefile        |  1 +
> >   s390x/migration-sck.c | 44 +++++++++++++++++++++++++++++++++++++
> >   s390x/sck.c           | 32 ---------------------------
> >   s390x/unittests.cfg   |  4 ++++
> >   5 files changed, 98 insertions(+), 33 deletions(-)
> >   create mode 100644 s390x/migration-sck.c
> >   


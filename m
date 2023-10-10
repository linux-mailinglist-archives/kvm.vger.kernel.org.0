Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E647BFACC
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 14:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbjJJMIc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 08:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbjJJMIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 08:08:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6530794
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 05:08:28 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39ABJkrH017230
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 12:08:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=jy0+2CaQ51TBnN21+adfVttL2DGOgu/wxuRV9z0g55s=;
 b=ghHtUDkkgQd0UQS3fSjGGgthiFeX96CN8dOssd3TbBhy7wRhjNNcQ0WnTL/qYzfqHiUy
 vWI6kIZqpcvw0kEh0NZQzEGpt8GIKmiNnjr/ihHXvtilneIHSbbTWCMQ5IJRR7ngbZN5
 3C12IeJzhlWC3CDA+1ik0v74+lJhMStxfkB/RKh9Yo4tgQTAogc3vU2mQ3zJc8/U04GF
 Qy9G/w4iW4jnLHSXJq0L5r2wVFSn0a64Dsbh68DBbUHzZgtd4b1djgbcuazuubyeo2eY
 MHeXzdgh5VoinSA4dAOo9MSgKermnrY/tFS6u+E7BGVO+NNqquNc5oqNSQFmUqOTSzPb hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn53gjgb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 12:08:27 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39ABtDdo017688
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 12:08:26 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn53gjg3f-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 12:08:26 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39A9kbNX023021;
        Tue, 10 Oct 2023 11:44:09 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tkmc1fh2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 11:44:09 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39ABi6Fc22938290
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 11:44:06 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31CE420043;
        Tue, 10 Oct 2023 11:44:06 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05B312004D;
        Tue, 10 Oct 2023 11:44:06 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Oct 2023 11:44:05 +0000 (GMT)
Date:   Tue, 10 Oct 2023 13:44:04 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 3/3] lib: s390x: sclp: Add line mode
 input handling
Message-ID: <20231010134404.65a69d01@p-imbrenda>
In-Reply-To: <8568bef1-e829-40f3-8815-c5ab1e9dc8ef@linux.ibm.com>
References: <20231010073855.26319-1-frankja@linux.ibm.com>
        <20231010073855.26319-4-frankja@linux.ibm.com>
        <20231010123309.4dd54963@p-imbrenda>
        <8568bef1-e829-40f3-8815-c5ab1e9dc8ef@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sE58HRr1ldJeXvR63z8ZeKAvXzLBF5ku
X-Proofpoint-GUID: fw_KBUoEHoHIJ--Sx3i6ab1wjSqejFOy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-10_07,2023-10-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 adultscore=0 impostorscore=0 bulkscore=0 clxscore=1015 malwarescore=0
 phishscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310100088
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 10 Oct 2023 13:05:59 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 10/10/23 12:33, Claudio Imbrenda wrote:
> > On Tue, 10 Oct 2023 07:38:55 +0000
> > Janosch Frank <frankja@linux.ibm.com> wrote:
> >   
> >> Time to add line-mode input so we can use input handling under LPAR if
> >> there's no access to a ASCII console.
> >>
> >> Line-mode IO is pretty wild and the documentation could be improved a
> >> lot. Hence I've copied the input parsing functions from Linux.
> >>
> >> For some reason output is a type 2 event but input is a type 1
> >> event. This also means that the input and output structures are
> >> different from each other.
> >>
> >> The input can consist of multiple structures which don't contain text
> >> data before the input text data is reached. Hence we need a bunch of
> >> search functions to retrieve a pointer to the text data.
> >>
> >> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >> ---
> >>   lib/s390x/sclp-console.c | 180 ++++++++++++++++++++++++++++++++++-----
> >>   lib/s390x/sclp.h         |  26 +++++-
> >>   2 files changed, 185 insertions(+), 21 deletions(-)
> >>
> >> diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
> >> index 313be1e4..23c09b70 100644
> >> --- a/lib/s390x/sclp-console.c
> >> +++ b/lib/s390x/sclp-console.c
> >> @@ -1,8 +1,12 @@
> >>   /* SPDX-License-Identifier: GPL-2.0-or-later */
> >>   /*
> >> - * SCLP ASCII access driver
> >> + * SCLP line mode and ASCII console driver
> >>    *
> >>    * Copyright (c) 2013 Alexander Graf <agraf@suse.de>
> >> + *
> >> + * Copyright IBM Corp. 1999
> >> + * Author(s): Martin Peschke <mpeschke@de.ibm.com>
> >> + *	      Martin Schwidefsky <schwidefsky@de.ibm.com>  
> > 
> > from the weird copyright notices that you are adding I deduce that you
> > copied those functions from the kernel. maybe add a line in the patch
> > description to say so? or at least explain better in the comment itself.  
> 
> You mean this line which is in the patch description?
> "Hence I've copied the input parsing functions from Linux."

oufff, I'm blind sorry

> 
> But sure, I could add that after "SCLP line mode and ASCII console driver"

yeah that would bring it in line with the rest of the other files which
have been (partially) copied from the kernel

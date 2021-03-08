Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178E4331233
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 16:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhCHPaw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 10:30:52 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30470 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229813AbhCHPaZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 10:30:25 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128FKZuG171233;
        Mon, 8 Mar 2021 10:30:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=/fxiTMrgxy91YdicZ8dplzUiOxJyqCpYT+olUl1jTlU=;
 b=CWhqf2QsufyGz28ZIspUjQDRUAULnI//f9SvPVmUESCY6qQvpqj8trhsMWOjk+/20s7s
 2C+rmoBUpicYM/Sr6nnYaOWyEgwTpG5TGGqqNvv7U9Gb6SOEMiRJBdlVvedzzMrtFdhq
 GKzXfZPJh7obrzIjZyLmDTPXi5e62W1d01UhPd8jYBqsF+hNbT8hGNSUiA4DU4XgIaxy
 4nSJ+9xxI6N0idaDNmwRvoTysxs7jaq/bB63QhOQTVgIkcP5ZHR5mmgkJd9MifduQ2Q1
 wv5v5yu4ig4AHOl+kzqfnWvu0CgtFOvc/aMI4DTU593RQPH+CdHvn0bFStyFtTf6DYdi YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375pfx080c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 10:30:25 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128FN22X188459;
        Mon, 8 Mar 2021 10:30:25 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375pfx07y9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 10:30:24 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128FSIiS010248;
        Mon, 8 Mar 2021 15:30:22 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3741c89xt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 15:30:22 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128FUJ4638011144
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 15:30:19 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C090BAE051;
        Mon,  8 Mar 2021 15:30:19 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58D8FAE056;
        Mon,  8 Mar 2021 15:30:19 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.11.70])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 15:30:19 +0000 (GMT)
Date:   Mon, 8 Mar 2021 16:30:17 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-kernel@vger.kernel.org, david@redhat.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v5 0/3] s390/kvm: fix MVPG when in VSIE
Message-ID: <20210308163017.672bb400@ibm-vm>
In-Reply-To: <262c0955-0283-6812-c841-cd1f18acf835@linux.ibm.com>
References: <20210302174443.514363-1-imbrenda@linux.ibm.com>
        <e548903d-ed72-d84f-8010-1bb765696ffe@de.ibm.com>
        <262c0955-0283-6812-c841-cd1f18acf835@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_11:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 impostorscore=0 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0
 priorityscore=1501 mlxlogscore=795 lowpriorityscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103080083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 8 Mar 2021 16:26:58 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 3/8/21 4:19 PM, Christian Borntraeger wrote:
> > On 02.03.21 18:44, Claudio Imbrenda wrote:  
> >> The current handling of the MVPG instruction when executed in a
> >> nested guest is wrong, and can lead to the nested guest hanging.
> >>
> >> This patchset fixes the behaviour to be more architecturally
> >> correct, and fixes the hangs observed.
> >>
> >> v4->v5
> >> * split kvm_s390_logical_to_effective so it can be reused for vSIE
> >> * fix existing comments and add some more comments
> >> * use the new split _kvm_s390_logical_to_effective in
> >> vsie_handle_mvpg
> >>
> >> v3->v4
> >> * added PEI_ prefix to DAT_PROT and NOT_PTE macros
> >> * added small comment to explain what they are about
> >>
> >> v2->v3
> >> * improved some comments
> >> * improved some variable and parameter names for increased
> >> readability
> >> * fixed missing handling of page faults in the MVPG handler
> >> * small readability improvements
> >>
> >> v1->v2
> >> * complete rewrite  
> > 
> > 
> > queued (with small fixups) for kvms390. Still not sure if this will
> > land in master or next. Opinions?  
> 
> I'd go for the next merge window

I agree

> >>
> >> Claudio Imbrenda (3):
> >>    s390/kvm: split kvm_s390_logical_to_effective
> >>    s390/kvm: extend kvm_s390_shadow_fault to return entry pointer
> >>    s390/kvm: VSIE: correctly handle MVPG when in VSIE
> >>
> >>   arch/s390/kvm/gaccess.c |  30 ++++++++++--
> >>   arch/s390/kvm/gaccess.h |  35 ++++++++++---
> >>   arch/s390/kvm/vsie.c    | 106
> >> ++++++++++++++++++++++++++++++++++++---- 3 files changed, 151
> >> insertions(+), 20 deletions(-) 
> 


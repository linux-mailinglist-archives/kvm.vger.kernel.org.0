Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 806264A8556
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 14:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350749AbiBCNhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 08:37:21 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10426 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235297AbiBCNhV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Feb 2022 08:37:21 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 213Cc9Ur003113
        for <kvm@vger.kernel.org>; Thu, 3 Feb 2022 13:37:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=vgnF91mEgtZQoSSRnq0MGClcDUIknSS0FSWoJnNf8Ws=;
 b=M7daTMKMiE/0qROFzXoyPIR0qp+3azYXr/1GiziSWBSgsZlSg1L6JutT+fAOW16iYODc
 D+SEx4dI3Gr+1HvjddKr46tzWFPrq38ijdFxPfiS2Y/2CnYE6hxUm9b6WZO04OiTDwbr
 hRE5ZTpbmlAEmkv3p4l2P/y3eBI/jo4ZAsq2qdS4OIwIYSVRuU6aHDmn11i8wW9od+25
 o8s/lIoPWW3e0U3YHVB2ceiOVqNs6Gi1eDLjbxKFMjqwnyW1n+C2QndKtC7eTTaPKy5O
 L/8knJCoiF3/XnjSbecwsaqBaFb+HU23o6iN+X0srSvwL9zFoZjeCBqMmrz4Lfo1ARLa Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dywrrmwg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 03 Feb 2022 13:37:20 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 213DS6d1001829
        for <kvm@vger.kernel.org>; Thu, 3 Feb 2022 13:37:20 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dywrrmwer-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 13:37:20 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 213DWtpN008783;
        Thu, 3 Feb 2022 13:37:18 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3dvvujxf25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 13:37:18 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 213DbFUQ38207864
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Feb 2022 13:37:15 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57555AE05A;
        Thu,  3 Feb 2022 13:37:15 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D460DAE04D;
        Thu,  3 Feb 2022 13:37:14 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.135])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Feb 2022 13:37:14 +0000 (GMT)
Date:   Thu, 3 Feb 2022 14:37:12 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 0/5] s390x: smp: avoid hardcoded CPU
 addresses
Message-ID: <20220203143712.28b1881e@p-imbrenda>
In-Reply-To: <f8f09670-688b-2b12-f09a-860a9edffd54@linux.ibm.com>
References: <20220128185449.64936-1-imbrenda@linux.ibm.com>
        <f8f09670-688b-2b12-f09a-860a9edffd54@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dTS-4FZtoDGQOES4ZC4Quxen_eZxctCg
X-Proofpoint-GUID: VAuLM8iJhf3wittT72zkk5NoPar3YpQ2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-03_04,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 clxscore=1015 impostorscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 suspectscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 3 Feb 2022 09:45:56 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 1/28/22 19:54, Claudio Imbrenda wrote:
> > On s390x there are no guarantees about the CPU addresses, except that
> > they shall be unique. This means that in some environments, it's
> > possible that there is no match between the CPU address and its
> > position (index) in the list of available CPUs returned by the system.  
> 
> While I support this patch set I've yet to find an environment where 
> this gave me headaches.
> 
> > 
> > This series fixes a small bug in the SMP initialization code, adds a
> > guarantee that the boot CPU will always have index 0, and introduces
> > some functions to allow tests to use CPU indexes instead of using
> > hardcoded CPU addresses. This will allow the tests to run successfully
> > in more environments (e.g. z/VM, LPAR).  
> 
> I'm wondering if we should do it the other way round and make the smp_* 
> functions take a idx instead of a cpu addr. The only instance where this 
> gets a bit ugly is the sigp calls which we would also need to convert.

yes, in fact this is something I was already planning to do :)

for sigp, we can either convert, or add a wrapper with idx.

> 
> > Some existing tests are adapted to take advantage of the new
> > functionalities.
> > 
> > Claudio Imbrenda (5):
> >    lib: s390x: smp: add functions to work with CPU indexes
> >    lib: s390x: smp: guarantee that boot CPU has index 0
> >    s390x: smp: avoid hardcoded CPU addresses
> >    s390x: firq: avoid hardcoded CPU addresses
> >    s390x: skrf: avoid hardcoded CPU addresses
> > 
> >   lib/s390x/smp.h |  2 ++
> >   lib/s390x/smp.c | 28 ++++++++++++-----
> >   s390x/firq.c    | 17 +++++-----
> >   s390x/skrf.c    |  8 +++--
> >   s390x/smp.c     | 83 ++++++++++++++++++++++++++-----------------------
> >   5 files changed, 79 insertions(+), 59 deletions(-)
> >   
> 


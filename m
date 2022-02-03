Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE2C4A87F5
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 16:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351930AbiBCPsM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 10:48:12 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5148 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238679AbiBCPsK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Feb 2022 10:48:10 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 213EcTns013236
        for <kvm@vger.kernel.org>; Thu, 3 Feb 2022 15:48:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=N5t4GBonbKkaxxlBEpXLQRDSTHQa9a913ZbpMyFCLAU=;
 b=DDMS0Fp9REvEYje/GKRfepM5QZxXnMlJxOWcHg3SQi7B+ecvaaFj5rbT9/H27fCY062M
 i8GtDRSme5y3X0GS2dEluYu7J+W7yVp67XSmViD4wYbedGnDhVE/CDi7JggXreNAW77f
 QoH2WG1T8/McIG+w9vOWfoevJ1TMFveTCA4rM562tLGm9SKjT3ONhKqH0QtQu1MAVbQa
 HSldxsf4zIjNgO1HB8jCONuLUkBamCGI/mZmJl56ZRY+scV9qBCSWP/rADwLFsN2hFGu
 2C7h2NbUgNQwhyXjgsho8LgsjJiJW25ztED3SJaehVMu5ob90WjO7hModu59/o5rypGk rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dyvexu4h6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 03 Feb 2022 15:48:10 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 213FQuND015035
        for <kvm@vger.kernel.org>; Thu, 3 Feb 2022 15:48:09 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dyvexu4gb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 15:48:09 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 213FRSQd009819;
        Thu, 3 Feb 2022 15:48:07 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3dvw79wp66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 15:48:07 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 213Fm3XO43516298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Feb 2022 15:48:03 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB85DA404D;
        Thu,  3 Feb 2022 15:48:03 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48A08A4040;
        Thu,  3 Feb 2022 15:48:03 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.135])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Feb 2022 15:48:03 +0000 (GMT)
Date:   Thu, 3 Feb 2022 16:48:00 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 0/5] s390x: smp: avoid hardcoded CPU
 addresses
Message-ID: <20220203164800.732ad674@p-imbrenda>
In-Reply-To: <9a38563e-3307-13df-e734-483a31822e08@linux.ibm.com>
References: <20220128185449.64936-1-imbrenda@linux.ibm.com>
        <f8f09670-688b-2b12-f09a-860a9edffd54@linux.ibm.com>
        <20220203143712.28b1881e@p-imbrenda>
        <9a38563e-3307-13df-e734-483a31822e08@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 893szW7pRUCkSQ_TbMor4zMQylclNeuM
X-Proofpoint-GUID: JtejvuMNtDb0BQXGHDxc4wZ6LIxz4gmc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-03_05,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 3 Feb 2022 16:23:23 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 2/3/22 14:37, Claudio Imbrenda wrote:
> > On Thu, 3 Feb 2022 09:45:56 +0100
> > Janosch Frank <frankja@linux.ibm.com> wrote:
> >   
> >> On 1/28/22 19:54, Claudio Imbrenda wrote:  
> >>> On s390x there are no guarantees about the CPU addresses, except that
> >>> they shall be unique. This means that in some environments, it's
> >>> possible that there is no match between the CPU address and its
> >>> position (index) in the list of available CPUs returned by the system.  
> >>
> >> While I support this patch set I've yet to find an environment where
> >> this gave me headaches.
> >>  
> >>>
> >>> This series fixes a small bug in the SMP initialization code, adds a
> >>> guarantee that the boot CPU will always have index 0, and introduces
> >>> some functions to allow tests to use CPU indexes instead of using
> >>> hardcoded CPU addresses. This will allow the tests to run successfully
> >>> in more environments (e.g. z/VM, LPAR).  
> >>
> >> I'm wondering if we should do it the other way round and make the smp_*
> >> functions take a idx instead of a cpu addr. The only instance where this
> >> gets a bit ugly is the sigp calls which we would also need to convert.  
> > 
> > yes, in fact this is something I was already planning to do :)  
> 
> Do you want to add that in a v2 to reduce the additional churn?

ok

> 
> > 
> > for sigp, we can either convert, or add a wrapper with idx.  
> 
> How about adding a wrapper to smp.c?
> 
> smp_cpu_sigp()
> smp_cpu_sigp_retry()

I was actually thinking about sigp_idx, but I like your names better

> 
> 
> That would fall in line with the naming of the smp functions and it's 
> clear that we refer to a specific cpu from the smp lib.
> 
> We can then leave the sigp.h functions as is so Nico can use them for 
> the invalid addr tests.

yes, a "raw" sigp function should definitely stay there

> 
> >   
> >>  
> >>> Some existing tests are adapted to take advantage of the new
> >>> functionalities.
> >>>
> >>> Claudio Imbrenda (5):
> >>>     lib: s390x: smp: add functions to work with CPU indexes
> >>>     lib: s390x: smp: guarantee that boot CPU has index 0
> >>>     s390x: smp: avoid hardcoded CPU addresses
> >>>     s390x: firq: avoid hardcoded CPU addresses
> >>>     s390x: skrf: avoid hardcoded CPU addresses
> >>>
> >>>    lib/s390x/smp.h |  2 ++
> >>>    lib/s390x/smp.c | 28 ++++++++++++-----
> >>>    s390x/firq.c    | 17 +++++-----
> >>>    s390x/skrf.c    |  8 +++--
> >>>    s390x/smp.c     | 83 ++++++++++++++++++++++++++-----------------------
> >>>    5 files changed, 79 insertions(+), 59 deletions(-)
> >>>      
> >>  
> >   
> 


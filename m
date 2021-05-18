Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C41387D8B
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 18:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245718AbhERQc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 12:32:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6466 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238766AbhERQc5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 12:32:57 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14IG33jJ076269;
        Tue, 18 May 2021 12:31:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Juro+T4w8v0nPLSpZC0QAY/z09B/PbYv3PNlr8eaeMM=;
 b=bnxl/VFhrF4J2VTJ+fMxCi39QbEploE5p8xgxO7ineKtYmiL5FVTnYjAshJ7jc9DFyN7
 02J0EYTHUYinHkxuc6y4XnrvHx/AnK6K50AZAga6ghJlwyoLbBEFvQpsfBFS24cfalNC
 h26ntRHbCFO9fBXPlNpQzk4Q3rvJuV2bs+vQw/l7SLlUY5qtkErbuj4iQR5UIDCXoIV3
 KFdVtqh2RxIeUo58tePqC2I6zfcBd0H34r8Q4nqK9RKMZAZriSxWvKEesLB4SlGq7XiY
 KDEEYZOk1+wxBebKibkJmgnKUka8KdiBtz08LwyUumkGeKDRX5jzigSeeO2VgDAYWK8+ UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mghfs8ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 12:31:38 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14IG37iO076652;
        Tue, 18 May 2021 12:31:37 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mghfs89p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 12:31:37 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14IGN7ct006567;
        Tue, 18 May 2021 16:31:36 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 38j5x80vr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 16:31:35 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14IGVWws32309710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 May 2021 16:31:33 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D856442047;
        Tue, 18 May 2021 16:31:32 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B30642045;
        Tue, 18 May 2021 16:31:32 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.14.34])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 May 2021 16:31:32 +0000 (GMT)
Date:   Tue, 18 May 2021 18:31:31 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 00/11] KVM: s390: pv: implement lazy destroy
Message-ID: <20210518183131.1e0cf801@ibm-vm>
In-Reply-To: <a38192d5-0868-8e07-0a34-c1615e1997fc@redhat.com>
References: <20210517200758.22593-1-imbrenda@linux.ibm.com>
        <20210518170537.58b32ffe.cohuck@redhat.com>
        <20210518173624.13d043e3@ibm-vm>
        <20210518180411.4abf837d.cohuck@redhat.com>
        <20210518181922.52d04c61@ibm-vm>
        <a38192d5-0868-8e07-0a34-c1615e1997fc@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SMc-f6DskCKvBmasSBtCnoBbbOpc80sL
X-Proofpoint-GUID: i2pj2RcVrJkGcLLwNBWpBfSO-wZeB_S_
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-18_08:2021-05-18,2021-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 spamscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105180111
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 May 2021 18:22:42 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 18.05.21 18:19, Claudio Imbrenda wrote:
> > On Tue, 18 May 2021 18:04:11 +0200
> > Cornelia Huck <cohuck@redhat.com> wrote:
> >   
> >> On Tue, 18 May 2021 17:36:24 +0200
> >> Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:
> >>  
> >>> On Tue, 18 May 2021 17:05:37 +0200
> >>> Cornelia Huck <cohuck@redhat.com> wrote:
> >>>      
> >>>> On Mon, 17 May 2021 22:07:47 +0200
> >>>> Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:  
> >>  
> >>>>> This means that the same address space can have memory
> >>>>> belonging to more than one protected guest, although only one
> >>>>> will be running, the others will in fact not even have any
> >>>>> CPUs.  
> >>>>
> >>>> Are those set-aside-but-not-yet-cleaned-up pages still possibly
> >>>> accessible in any way? I would assume that they only belong to
> >>>> the  
> >>>
> >>> in case of reboot: yes, they are still in the address space of the
> >>> guest, and can be swapped if needed
> >>>      
> >>>> 'zombie' guests, and any new or rebooted guest is a new entity
> >>>> that needs to get new pages?  
> >>>
> >>> the rebooted guest (normal or secure) will re-use the same pages
> >>> of the old guest (before or after cleanup, which is the reason of
> >>> patches 3 and 4)  
> >>
> >> Took a look at those patches, makes sense.
> >>  
> >>>
> >>> the KVM guest is not affected in case of reboot, so the userspace
> >>> address space is not touched.  
> >>
> >> 'guest' is a bit ambiguous here -- do you mean the vm here, and the
> >> actual guest above?
> >>  
> > 
> > yes this is tricky, because there is the guest OS, which terminates
> > or reboots, then there is the "secure configuration" entity,
> > handled by the Ultravisor, and then the KVM VM
> > 
> > when a secure guest reboots, the "secure configuration" is
> > dismantled (in this case, in a deferred way), and the KVM VM (and
> > its memory) is not directly affected
> > 
> > what happened before was that the secure configuration was
> > dismantled synchronously, and then re-created.
> > 
> > now instead, a new secure configuration is created using the same
> > KVM VM (and thus the same mm), before the old secure configuration
> > has been completely dismantled. hence the same KVM VM can have
> > multiple secure configurations associated, sharing the same address
> > space.
> > 
> > of course, only the newest one is actually running, the other ones
> > are "zombies", without CPUs.
> >   
> 
> Can a guest trigger a DoS?

I don't see how

a guest can fill its memory and then reboot, and then fill its memory
again and then reboot... but that will take time, filling the memory
will itself clean up leftover pages from previous boots.

"normal" reboot loops will be fast, because there won't be much memory
to process

I have actually tested mixed reboot/shutdown loops, and the system
behaved as you would expect when under load.


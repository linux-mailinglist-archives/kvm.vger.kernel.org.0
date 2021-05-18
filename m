Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB243387D3B
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 18:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350552AbhERQUs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 12:20:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34356 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242950AbhERQUr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 12:20:47 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14IG4TIR147769;
        Tue, 18 May 2021 12:19:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ndd82IbH5HumlBekUUP8sx3csBphY0T+gPuyzoyc1GA=;
 b=B9amqs8peRvBpYC0QLsib0X/sri7iJCzMuuJ5ISBei0XE/PGzZN9IHtK0R7yHdX+qP/L
 TcI5GWlFCQQGwXoXDU6jrq2/mYx3toOqiwWDUOcdD5IlQle0Ou308D0cHF5UNIMSwCFf
 FTTF7cAV7MiCwr0nUnGHX9iECHO7JCC1ARSyN0pzKpCh9I/LhYkjvbGUwxGd4YEfCqZr
 /9AyxIeANODx7XEwX9VCzop+k/+Q6fj5XteoWtZEZRv7JJFhA6+C2Mr7TcTpwJNF2M6f
 slqhEfiyFPt+q9WIYZwLM3pAzQWXjrw5WCIU0JR+Gnq7QkDFn8eB1dyyd5Sihn7zwM4e lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mg27hyem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 12:19:29 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14IGJTPa023437;
        Tue, 18 May 2021 12:19:29 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mg27hye3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 12:19:29 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14IFj1O2022765;
        Tue, 18 May 2021 16:19:27 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 38j5x7skkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 16:19:27 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14IGJOAF33096112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 May 2021 16:19:24 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29C4911C058;
        Tue, 18 May 2021 16:19:24 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B56B611C05C;
        Tue, 18 May 2021 16:19:23 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.14.34])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 May 2021 16:19:23 +0000 (GMT)
Date:   Tue, 18 May 2021 18:19:22 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 00/11] KVM: s390: pv: implement lazy destroy
Message-ID: <20210518181922.52d04c61@ibm-vm>
In-Reply-To: <20210518180411.4abf837d.cohuck@redhat.com>
References: <20210517200758.22593-1-imbrenda@linux.ibm.com>
        <20210518170537.58b32ffe.cohuck@redhat.com>
        <20210518173624.13d043e3@ibm-vm>
        <20210518180411.4abf837d.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Yqx5T4YRfPVRsfivh9VqriYO3qmg--6_
X-Proofpoint-GUID: mLKiil3Z3TUwv6fgB-1YcGBXzQDQh29F
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-18_08:2021-05-18,2021-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 adultscore=0 clxscore=1015 malwarescore=0 impostorscore=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105180111
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 May 2021 18:04:11 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Tue, 18 May 2021 17:36:24 +0200
> Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:
> 
> > On Tue, 18 May 2021 17:05:37 +0200
> > Cornelia Huck <cohuck@redhat.com> wrote:
> >   
> > > On Mon, 17 May 2021 22:07:47 +0200
> > > Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:  
> 
> > > > This means that the same address space can have memory
> > > > belonging to more than one protected guest, although only one
> > > > will be running, the others will in fact not even have any
> > > > CPUs.      
> > > 
> > > Are those set-aside-but-not-yet-cleaned-up pages still possibly
> > > accessible in any way? I would assume that they only belong to
> > > the    
> > 
> > in case of reboot: yes, they are still in the address space of the
> > guest, and can be swapped if needed
> >   
> > > 'zombie' guests, and any new or rebooted guest is a new entity
> > > that needs to get new pages?    
> > 
> > the rebooted guest (normal or secure) will re-use the same pages of
> > the old guest (before or after cleanup, which is the reason of
> > patches 3 and 4)  
> 
> Took a look at those patches, makes sense.
> 
> > 
> > the KVM guest is not affected in case of reboot, so the userspace
> > address space is not touched.  
> 
> 'guest' is a bit ambiguous here -- do you mean the vm here, and the
> actual guest above?
> 

yes this is tricky, because there is the guest OS, which terminates or
reboots, then there is the "secure configuration" entity, handled by the
Ultravisor, and then the KVM VM

when a secure guest reboots, the "secure configuration" is dismantled
(in this case, in a deferred way), and the KVM VM (and its memory) is
not directly affected

what happened before was that the secure configuration was dismantled
synchronously, and then re-created.

now instead, a new secure configuration is created using the same KVM
VM (and thus the same mm), before the old secure configuration has been
completely dismantled. hence the same KVM VM can have multiple secure
configurations associated, sharing the same address space.

of course, only the newest one is actually running, the other ones are
"zombies", without CPUs.


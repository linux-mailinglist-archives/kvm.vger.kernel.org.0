Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448D5387D23
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 18:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350526AbhERQOf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 12:14:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64340 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350239AbhERQOc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 12:14:32 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14IG3c4A049206;
        Tue, 18 May 2021 12:13:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Kuh0RMEqHHwd8FOG++wxjthmVwDNJDZy6Vnj8O82ZBU=;
 b=KsT//ZnXcEx/voXauzNdDiXC9TJ1cJKf8SPmAB49e/zYu6UIkHMO9mZrC3x4Ai2HrAxS
 HAFgXj+xyKbf7xYwrZo8FRGYrw3AHaMt3dhd8sydJjfy8S/arHWC9ybk45mWbaFjCQj5
 DNblT5jVcZ8LQIb9AE/iRaCOpjMumk6Ps5cQMypY1oXwOMrqgrXH7xdO1WmznrUtbhHC
 VJWIZpSvJnU/mcL1DdO7kMHKLJ41jqSqndqzqohp65sQJoYuzXYREge872Um+qwyl33f
 a6sx8G8gj3HuiTmGoBJM4LIgq7lVYigkr5RatSvWffTdtk5kWfD65t+8KdPnBeyS58IY wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mfatbrmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 12:13:14 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14IG42MG051782;
        Tue, 18 May 2021 12:13:14 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mfatbrm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 12:13:13 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14IFi9HV006617;
        Tue, 18 May 2021 16:13:11 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 38m1gv08jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 16:13:11 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14IGD89W42336608
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 May 2021 16:13:08 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28E484204C;
        Tue, 18 May 2021 16:13:08 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B77DD42042;
        Tue, 18 May 2021 16:13:07 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.14.34])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 May 2021 16:13:07 +0000 (GMT)
Date:   Tue, 18 May 2021 18:13:05 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 00/11] KVM: s390: pv: implement lazy destroy
Message-ID: <20210518181305.2a9d19f3@ibm-vm>
In-Reply-To: <225fe3ec-f2e9-6c76-97e1-b252fe3326b3@de.ibm.com>
References: <20210517200758.22593-1-imbrenda@linux.ibm.com>
        <20210518170537.58b32ffe.cohuck@redhat.com>
        <20210518173624.13d043e3@ibm-vm>
        <225fe3ec-f2e9-6c76-97e1-b252fe3326b3@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qpyhIDVOXTUKyNJhZ9t04ARzuYTlSHvL
X-Proofpoint-ORIG-GUID: UUJUIPWLDF4sqYrjDXChyi2V0iISzRu2
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-18_08:2021-05-18,2021-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105180111
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 May 2021 17:45:18 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 18.05.21 17:36, Claudio Imbrenda wrote:
> > On Tue, 18 May 2021 17:05:37 +0200
> > Cornelia Huck <cohuck@redhat.com> wrote:
> >   
> >> On Mon, 17 May 2021 22:07:47 +0200
> >> Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:
> >>  
> >>> Previously, when a protected VM was rebooted or when it was shut
> >>> down, its memory was made unprotected, and then the protected VM
> >>> itself was destroyed. Looping over the whole address space can
> >>> take some time, considering the overhead of the various
> >>> Ultravisor Calls (UVCs).  This means that a reboot or a shutdown
> >>> would take a potentially long amount of time, depending on the
> >>> amount of used memory.
> >>>
> >>> This patchseries implements a deferred destroy mechanism for
> >>> protected guests. When a protected guest is destroyed, its memory
> >>> is cleared in background, allowing the guest to restart or
> >>> terminate significantly faster than before.
> >>>
> >>> There are 2 possibilities when a protected VM is torn down:
> >>> * it still has an address space associated (reboot case)
> >>> * it does not have an address space anymore (shutdown case)
> >>>
> >>> For the reboot case, the reference count of the mm is increased,
> >>> and then a background thread is started to clean up. Once the
> >>> thread went through the whole address space, the protected VM is
> >>> actually destroyed.
> >>>
> >>> For the shutdown case, a list of pages to be destroyed is formed
> >>> when the mm is torn down. Instead of just unmapping the pages when
> >>> the address space is being torn down, they are also set aside.
> >>> Later when KVM cleans up the VM, a thread is started to clean up
> >>> the pages from the list.  
> >>
> >> Just to make sure, 'clean up' includes doing uv calls?  
> > 
> > yes
> >   
> >>>
> >>> This means that the same address space can have memory belonging
> >>> to more than one protected guest, although only one will be
> >>> running, the others will in fact not even have any CPUs.  
> >>
> >> Are those set-aside-but-not-yet-cleaned-up pages still possibly
> >> accessible in any way? I would assume that they only belong to the
> >>  
> > 
> > in case of reboot: yes, they are still in the address space of the
> > guest, and can be swapped if needed
> >   
> >> 'zombie' guests, and any new or rebooted guest is a new entity that
> >> needs to get new pages?  
> > 
> > the rebooted guest (normal or secure) will re-use the same pages of
> > the old guest (before or after cleanup, which is the reason of
> > patches 3 and 4)
> > 
> > the KVM guest is not affected in case of reboot, so the userspace
> > address space is not touched.
> >   
> >> Can too many not-yet-cleaned-up pages lead to a (temporary) memory
> >> exhaustion?  
> > 
> > in case of reboot, not much; the pages were in use are still in use
> > after the reboot, and they can be swapped.
> > 
> > in case of a shutdown, yes, because the pages are really taken aside
> > and cleared/destroyed in background. they cannot be swapped. they
> > are freed immediately as they are processed, to try to mitigate
> > memory exhaustion scenarios.
> > 
> > in the end, this patchseries is a tradeoff between speed and memory
> > consumption. the memory needs to be cleared up at some point, and
> > that requires time.
> > 
> > in cases where this might be an issue, I introduced a new KVM flag
> > to disable lazy destroy (patch 10)  
> 
> Maybe we could piggy-back on the OOM-kill notifier and then fall back
> to synchronous freeing for some pages?

I'm not sure I follow

once the pages have been set aside, it's too late

while the pages are being set aside, every now and then some memory
needs to be allocated. the allocation is atomic, not allowed to use
emergency reserves, and can fail without warning. if the allocation
fails, we clean up one page and continue, without setting aside
anything (patch 9)

so if the system is low on memory, the lazy destroy should not make the
situation too much worse.

the only issue here is starting a normal process in the host (maybe
a non secure guest) that uses a lot of memory very quickly, right after
a large secure guest has terminated.


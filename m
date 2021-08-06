Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF023E2BC8
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 15:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344401AbhHFNo3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 09:44:29 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18604 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S244377AbhHFNo3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Aug 2021 09:44:29 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 176DWoHi044424;
        Fri, 6 Aug 2021 09:44:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=9mDEg6x4A2drGfW+eqRTDhwomIBzZ4FHeuSSzXJt0n8=;
 b=aJUI3y2sSabihuTqfR3A/aNzxTVi4EgHEwxVCt2eYEKKncI9izzkuo/QJcLaN2jknGG/
 XhR+U0QGuGRNGKQPWI1PeGKXTQTbGyAhzFp85Peco/UplwHnZWAtuGnBafGBS4pm5Akw
 es9IDKXiRGkWnGg2fhUipzsY2yFXQaGLIJ0MQIZpTHi/B+h+a9rRnwWH6PAWDmsgyhBJ
 LTq8laRfKk3dbrJplWFHjNpWc9hRw4yrbD9wjigAix3WFb76km85C6m/eiexF0glsVWy
 hgQvocI+EzN3t273OWsDZdZZC+CdckCAGzOX8bqgxNOFQO1P4Cdwhvqq/5T/3811z7qa iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a859e5bcy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 09:44:10 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 176DXPSS048857;
        Fri, 6 Aug 2021 09:44:10 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a859e5bbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 09:44:09 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 176Dc9NE004883;
        Fri, 6 Aug 2021 13:44:08 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3a4wshw9jm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 13:44:07 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 176Di3NB54919462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Aug 2021 13:44:03 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6CD4F4203F;
        Fri,  6 Aug 2021 13:44:03 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9F304204C;
        Fri,  6 Aug 2021 13:44:02 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.6.208])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Aug 2021 13:44:02 +0000 (GMT)
Date:   Fri, 6 Aug 2021 15:44:00 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v3 00/14] KVM: s390: pv: implement lazy destroy
Message-ID: <20210806154400.2ca55563@p-imbrenda>
In-Reply-To: <ada27c6d-4dc9-04c3-d5b9-566e65359701@redhat.com>
References: <20210804154046.88552-1-imbrenda@linux.ibm.com>
        <86b114ef-41ea-04b6-327c-4a036f784fad@redhat.com>
        <20210806113005.0259d53c@p-imbrenda>
        <ada27c6d-4dc9-04c3-d5b9-566e65359701@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SZSp3tXSV6TE0C5KSQqORaCJWYFb8msQ
X-Proofpoint-ORIG-GUID: -fjOXrtC71AoXOI_pElZquJXf7snA4fb
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-06_04:2021-08-05,2021-08-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=926
 clxscore=1015 suspectscore=0 malwarescore=0 bulkscore=0 impostorscore=0
 mlxscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108060094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 6 Aug 2021 13:30:21 +0200
David Hildenbrand <david@redhat.com> wrote:

[...]

> >>> When the system runs out of memory, if a guest has terminated and
> >>> its memory is being cleaned asynchronously, the OOM killer will
> >>> wait a little and then see if memory has been freed. This has the
> >>> practical effect of slowing down memory allocations when the
> >>> system is out of memory to give the cleanup thread time to
> >>> cleanup and free memory, and avoid an actual OOM situation.  
> >>
> >> ... and this sound like the kind of arch MM hacks that will bite us
> >> in the long run. Of course, I might be wrong, but already doing
> >> excessive GFP_ATOMIC allocations or messing with the OOM killer
> >> that  
> > 
> > they are GFP_ATOMIC but they should not put too much weight on the
> > memory and can also fail without consequences, I used:
> > 
> > GFP_ATOMIC | __GFP_NOMEMALLOC | __GFP_NOWARN
> > 
> > also notice that after every page allocation a page gets freed, so
> > this is only temporary.  
> 
> Correct me if I'm wrong: you're allocating unmovable pages for
> tracking (e.g., ZONE_DMA, ZONE_NORMAL) from atomic reserves and will
> free a movable process page, correct? Or which page will you be
> freeing?

we are transforming ALL moveable pages belonging to userspace into
unmoveable pages. every ~500 pages one page gets actually
allocated (unmoveable), and another (moveable) one gets freed.

> > 
> > I would not call it "messing with the OOM killer", I'm using the
> > same interface used by virtio-baloon  
> 
> Right, and for virtio-balloon it's actually a workaround to restore
> the original behavior of a rarely used feature: deflate-on-oom.
> Commit da10329cb057 ("virtio-balloon: switch back to OOM handler for 
> VIRTIO_BALLOON_F_DEFLATE_ON_OOM") tried to document why we switched
> back from a shrinker to VIRTIO_BALLOON_F_DEFLATE_ON_OOM:
> 
> "The name "deflate on OOM" makes it pretty clear when deflation should
>   happen - after other approaches to reclaim memory failed, not while
>   reclaiming. This allows to minimize the footprint of a guest -
> memory will only be taken out of the balloon when really needed."
> 
> Note some subtle differences:
> 
> a) IIRC, before running into the OOM killer, will try reclaiming
>     anything  else. This is what we want for deflate-on-oom, it might
> not be what you want for your feature (e.g., flushing other
> processes/VMs to disk/swap instead of waiting for a single process to
> stop).

we are already reclaiming the memory of the dead secure guest.

> b) Migration of movable balloon inflated pages continues working
> because we are dealing with non-lru page migration.
> 
> Will page reclaim, page migration, compaction, ... of these movable
> LRU pages still continue working while they are sitting around
> waiting to be cleaned up? I can see that we're grabbing an extra
> reference when we put them onto the list, that might be a problem:
> for example, we can most certainly not swap out these pages or write
> them back to disk on memory pressure.

this is true. on the other hand, swapping a moveable page would be even
slower, because those pages would need to be exported and not destroyed.

> >   
> >> way for a pure (shutdown) optimization is an alarm signal. Of
> >> course, I might be wrong.
> >>
> >> You should at least CC linux-mm. I'll do that right now and also CC
> >> Michal. He might have time to have a quick glimpse at patch #11 and
> >> #13.
> >>
> >> https://lkml.kernel.org/r/20210804154046.88552-12-imbrenda@linux.ibm.com
> >> https://lkml.kernel.org/r/20210804154046.88552-14-imbrenda@linux.ibm.com
> >>
> >> IMHO, we should proceed with patch 1-10, as they solve a really
> >> important problem ("slow reboots") in a nice way, whereby patch 11
> >> handles a case that can be worked around comparatively easily by
> >> management tools -- my 2 cents.  
> > 
> > how would management tools work around the issue that a shutdown can
> > take very long?  
> 
> The traditional approach is to wait starting a new VM on another 
> hypervisor instead until memory has been freed up, or start it on 
> another hypervisor. That raises the question about the target use
> case.
> 
> What I don't get is that we have to pay the price for freeing up that 
> memory. Why isn't it sufficient to keep the process running and let 
> ordinary MM do it's thing?

what price?

you mean let mm do the slowest possible thing when tearing down a dead
guest?

without this, the dying guest would still take up all the memory. and
swapping it would not be any faster (it would be slower, in fact). the
system would OOM anyway.

> Maybe you should clearly spell out what the target use case for the
> fast shutdown (fast quitting of the process?) is?. I assume it is,
> starting a new VM / process / whatsoever on the same host
> immediately, and then
> 
> a) Eventually slowing down other processes due heavy reclaim.

for each dying guest, only one CPU is used by the reclaim; depending on
the total load of the system, this might not even be noticeable

> b) Slowing down the new process because you have to pay the price of 
> cleaning up memory.

do you prefer to OOM because the dying guest will need ages to clean up
its memory?

> I think I am missing why we need the lazy destroy at all when killing
> a process. Couldn't you instead teach the OOM killer "hey, we're
> currently quitting a heavy process that is just *very* slow to free
> up memory, please wait for that before starting shooting around" ?

isn't this ^ exactly what the OOM notifier does?


another note here:

when the process quits, the mm starts the tear down. at this point, the
mm has no idea that this is a dying KVM guest, so the best it can do is
exporting (which is significantly slower than destroy page)

kvm comes into play long after the mm is gone, and at this point it
can't do anything anymore. the memory is already gone (very slowly).

if I kill -9 qemu (or if qemu segfaults), KVM will never notice until
the mm is gone.


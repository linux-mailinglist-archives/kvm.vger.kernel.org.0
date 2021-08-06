Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622103E2759
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 11:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhHFJfN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 05:35:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44624 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244411AbhHFJfL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Aug 2021 05:35:11 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1769XFES180400;
        Fri, 6 Aug 2021 05:34:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=DFzWBu8nrmvkkvErcxeG1Ba6c1l04INbUxHBOut8jRA=;
 b=Lg63E8CM+kRxMjUDBy8QjSWsWK8f1+1/eYMzwhtZp2GRSH8YLj3haYOcgQwsaz3QPufC
 gtKLoUvO8NnT4lBAW4GF7NVBJClr9ev/6BnhCRNQ6MITh4MNGHiGRaVOqi+XaEk5qibK
 GdaxYhPcOUk2M52IhZt3LufGBDuYfwOJtqIrSzCTeZPYs5gbnxgrvuVi/0INsl1U9mXw
 9i4LElwje3KU+04LHcE7Nt2nmVkXNKGfCo5Ir1OLxPuBl3uzvyH0zp7yzLs2dFwQP/rg
 khHRSndJrLowTVpUDHUBkY97+u8EgnvYWmR/EhFIp+3TcHhmBiMEGrE16180sh0URIDj pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a8ye9nnq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 05:34:53 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1769XoHX182952;
        Fri, 6 Aug 2021 05:34:53 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a8ye9nnnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 05:34:53 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1769WTH5023947;
        Fri, 6 Aug 2021 09:34:51 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3a4x58ujpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 09:34:50 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1769YkT826018054
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Aug 2021 09:34:46 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B4504205C;
        Fri,  6 Aug 2021 09:34:46 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0985142042;
        Fri,  6 Aug 2021 09:34:46 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.6.208])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Aug 2021 09:34:45 +0000 (GMT)
Date:   Fri, 6 Aug 2021 11:30:05 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v3 00/14] KVM: s390: pv: implement lazy destroy
Message-ID: <20210806113005.0259d53c@p-imbrenda>
In-Reply-To: <86b114ef-41ea-04b6-327c-4a036f784fad@redhat.com>
References: <20210804154046.88552-1-imbrenda@linux.ibm.com>
        <86b114ef-41ea-04b6-327c-4a036f784fad@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NXMxdx-DilzzegqkArzYiI6ijm9cugdq
X-Proofpoint-GUID: S0FS-CtOORbJt6m_Nd7GtUjNccCG0Bcp
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-06_02:2021-08-05,2021-08-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 impostorscore=0 phishscore=0 clxscore=1011
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108060067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 6 Aug 2021 09:10:28 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 04.08.21 17:40, Claudio Imbrenda wrote:
> > Previously, when a protected VM was rebooted or when it was shut
> > down, its memory was made unprotected, and then the protected VM
> > itself was destroyed. Looping over the whole address space can take
> > some time, considering the overhead of the various Ultravisor Calls
> > (UVCs). This means that a reboot or a shutdown would take a
> > potentially long amount of time, depending on the amount of used
> > memory.
> > 
> > This patchseries implements a deferred destroy mechanism for
> > protected guests. When a protected guest is destroyed, its memory
> > is cleared in background, allowing the guest to restart or
> > terminate significantly faster than before.
> > 
> > There are 2 possibilities when a protected VM is torn down:
> > * it still has an address space associated (reboot case)
> > * it does not have an address space anymore (shutdown case)
> > 
> > For the reboot case, the reference count of the mm is increased, and
> > then a background thread is started to clean up. Once the thread
> > went through the whole address space, the protected VM is actually
> > destroyed.  
> 
> That doesn't sound too hacky to me, and actually sounds like a good 
> idea, doing what the guest would do either way but speeding it up 
> asynchronously, but ...
> 
> > 
> > For the shutdown case, a list of pages to be destroyed is formed
> > when the mm is torn down. Instead of just unmapping the pages when
> > the address space is being torn down, they are also set aside.
> > Later when KVM cleans up the VM, a thread is started to clean up
> > the pages from the list.  
> 
> ... this ...
> 
> > 
> > This means that the same address space can have memory belonging to
> > more than one protected guest, although only one will be running,
> > the others will in fact not even have any CPUs.  
> 
> ... this ...

this ^ is exactly the reboot case.

> > When a guest is destroyed, its memory still counts towards its
> > memory control group until it's actually freed (I tested this
> > experimentally)
> > 
> > When the system runs out of memory, if a guest has terminated and
> > its memory is being cleaned asynchronously, the OOM killer will
> > wait a little and then see if memory has been freed. This has the
> > practical effect of slowing down memory allocations when the system
> > is out of memory to give the cleanup thread time to cleanup and
> > free memory, and avoid an actual OOM situation.  
> 
> ... and this sound like the kind of arch MM hacks that will bite us
> in the long run. Of course, I might be wrong, but already doing
> excessive GFP_ATOMIC allocations or messing with the OOM killer that

they are GFP_ATOMIC but they should not put too much weight on the
memory and can also fail without consequences, I used:

GFP_ATOMIC | __GFP_NOMEMALLOC | __GFP_NOWARN

also notice that after every page allocation a page gets freed, so this
is only temporary.

I would not call it "messing with the OOM killer", I'm using the same
interface used by virtio-baloon

> way for a pure (shutdown) optimization is an alarm signal. Of course,
> I might be wrong.
> 
> You should at least CC linux-mm. I'll do that right now and also CC 
> Michal. He might have time to have a quick glimpse at patch #11 and
> #13.
> 
> https://lkml.kernel.org/r/20210804154046.88552-12-imbrenda@linux.ibm.com
> https://lkml.kernel.org/r/20210804154046.88552-14-imbrenda@linux.ibm.com
> 
> IMHO, we should proceed with patch 1-10, as they solve a really 
> important problem ("slow reboots") in a nice way, whereby patch 11 
> handles a case that can be worked around comparatively easily by 
> management tools -- my 2 cents.

how would management tools work around the issue that a shutdown can
take very long?

also, without my patches, the shutdown case would use export instead of
destroy, making it even slower.


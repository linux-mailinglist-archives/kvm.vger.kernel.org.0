Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB3B13A79
	for <lists+kvm@lfdr.de>; Sat,  4 May 2019 15:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfEDN6Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 May 2019 09:58:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51868 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726217AbfEDN6Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 4 May 2019 09:58:25 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x44Dv7BN057555
        for <kvm@vger.kernel.org>; Sat, 4 May 2019 09:58:24 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2s96thshvh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Sat, 04 May 2019 09:58:23 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Sat, 4 May 2019 14:58:21 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 4 May 2019 14:58:17 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x44DwGLf58982418
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 4 May 2019 13:58:16 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D45D0A405C;
        Sat,  4 May 2019 13:58:15 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 269BFA405B;
        Sat,  4 May 2019 13:58:15 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.34.191])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  4 May 2019 13:58:15 +0000 (GMT)
Date:   Sat, 4 May 2019 15:58:12 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH 00/10] s390: virtio: support protected virtualization
In-Reply-To: <20190503115511.17a1f6d1.cohuck@redhat.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
        <20190503115511.17a1f6d1.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19050413-0008-0000-0000-000002E33D81
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050413-0009-0000-0000-0000224FB1D2
Message-Id: <20190504155812.1f7e55c0.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-04_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905040093
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 3 May 2019 11:55:11 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Fri, 26 Apr 2019 20:32:35 +0200
> Halil Pasic <pasic@linux.ibm.com> wrote:
> 
> > Enhanced virtualization protection technology may require the use of
> > bounce buffers for I/O. While support for this was built into the virtio
> > core, virtio-ccw wasn't changed accordingly.
> > 
> > Some background on technology (not part of this series) and the
> > terminology used.
> > 
> > * Protected Virtualization (PV):
> > 
> > Protected Virtualization guarantees, that non-shared memory of a  guest
> > that operates in PV mode private to that guest. I.e. any attempts by the
> > hypervisor or other guests to access it will result in an exception. If
> > supported by the environment (machine, KVM, guest VM) a guest can decide
> > to change into PV mode by doing the appropriate ultravisor calls. Unlike
> > some other enhanced virtualization protection technology, 
> 
> I think that sentence misses its second part?
>

I wanted to kill the whole sentence, but killed only a part of
it. :( Sorry. If any, the sentence had only significance for judging how
well inherited some names fit.
  
> > 
> > * Ultravisor:
> > 
> > A hardware/firmware entity that manages PV guests, and polices access to
> > their memory. A PV guest prospect needs to interact with the ultravisor,
> > to enter PV mode, and potentially to share pages (for I/O which should
> > be encrypted by the guest). A guest interacts with the ultravisor via so
> > called ultravisor calls. A hypervisor needs to interact with the
> > ultravisor to facilitate interpretation, emulation and swapping. A
> > hypervisor  interacts with the ultravisor via ultravisor calls and via
> > the SIE state description. Generally the ultravisor sanitizes hypervisor
> > inputs so that the guest can not be corrupted (except for denial of
> > service.
> > 
> > 
> > What needs to be done
> > =====================
> > 
> > Thus what needs to be done to bring virtio-ccw up to speed with respect
> > to protected virtualization is:
> > * use some 'new' common virtio stuff
> 
> Doing this makes sense regardless of the protected virtualization use
> case, and I think we should go ahead and merge those patches for 5.2.
> 

I agree.

> > * make sure that virtio-ccw specific stuff uses shared memory when
> >   talking to the hypervisor (except control/communication blocks like ORB,
> >   these are handled by the ultravisor)
> 
> TBH, I'm still a bit hazy on what needs to use shared memory and what
> doesn't.
> 

It is all in the code :). To have complete and definitive answers here
we would need some sort of public UV architecture.

> > * make sure the DMA API does what is necessary to talk through shared
> >   memory if we are a protected virtualization guest.
> > * make sure the common IO layer plays along as well (airqs, sense).
> > 
> > 
> > Important notes
> > ================
> > 
> > * This patch set is based on Martins features branch
> >  (git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git branch
> >  'features').
> > 
> > * Documentation is still very sketchy. I'm committed to improving this,
> >   but I'm currently hampered by some dependencies currently.  
> 
> I understand, but I think this really needs more doc; also for people
> who want to understand the code in the future.
> 
> Unfortunately lack of doc also hampers others in reviewing this :/
>

I'm not sure how much can we do on the doc front. Without a complete
architecture, one basically needs to trust the guys with access to the
architecture.

Many thanks for your feedback. Regards,
Halil

[..]


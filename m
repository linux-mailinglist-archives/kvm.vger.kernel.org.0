Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED850488C92
	for <lists+kvm@lfdr.de>; Sun,  9 Jan 2022 22:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237130AbiAIVgo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Jan 2022 16:36:44 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62888 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233873AbiAIVgn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 9 Jan 2022 16:36:43 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 209G6t30019537;
        Sun, 9 Jan 2022 21:36:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=bjVFy4e/dTyFvJDD8SHxBSGEDpnz2rkKYHQyHr2XUKs=;
 b=bn/MX7bP9erQgY6bF1a2xNNxpyV3f/62tPXtqB+Bd+SCbgRrRs4m0B6/ykgGQLfAU+99
 BlEUgERYme2glWwClOjZIDQf7ej09cTu9IZWzyfz25+/4QjrqG/9iG7/l6JBihmxQObv
 NNY1VOyDLu3ebfhFkfmlzVxLqciC+02RxcuHCRaeV5GocnAwAVPKbPAvvf19cAzMEwnW
 frV338+/87uGtyoxjQhSrSadEWwPCvDjOckN1HGtCVY07P3Rf/kwzcQHZF2D90RTpg6r
 aPOXiABwg1eKx7Ch6wC6YiSmWpJWmqAHAiiqhzjlgVD7cuiDiD7FYOoh3ZMuuoWbfNan eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dfm044nxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 09 Jan 2022 21:36:41 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 209LQBhH005785;
        Sun, 9 Jan 2022 21:36:41 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dfm044nxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 09 Jan 2022 21:36:40 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 209LXn2C028281;
        Sun, 9 Jan 2022 21:36:39 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3df1vhxmug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 09 Jan 2022 21:36:39 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 209LaZV447186382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 9 Jan 2022 21:36:35 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C02DFA405F;
        Sun,  9 Jan 2022 21:36:35 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22FD6A4054;
        Sun,  9 Jan 2022 21:36:35 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.37.42])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Sun,  9 Jan 2022 21:36:35 +0000 (GMT)
Date:   Sun, 9 Jan 2022 22:36:32 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v17 09/15] s390/vfio-ap: allow hot plug/unplug of AP
 resources using mdev device
Message-ID: <20220109223632.03830576.pasic@linux.ibm.com>
In-Reply-To: <20211021152332.70455-10-akrowiak@linux.ibm.com>
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
        <20211021152332.70455-10-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: L_UdoSJFgxHFImM8OJwzbiPUdR1OaNEa
X-Proofpoint-ORIG-GUID: dJrNuTbFu9vwAuGtbs6S_dPbAi-AvYa-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-09_10,2022-01-07_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 impostorscore=0 mlxscore=0 adultscore=0
 malwarescore=0 clxscore=1015 bulkscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201090156
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Oct 2021 11:23:26 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Keep in mind that the kvm->lock must be taken outside of the
> matrix_mdev->lock to avoid circular lock dependencies (i.e., a lockdep
> splat). This will necessitate taking the matrix_dev->guests_lock in order
> to find the guest(s) in the matrix_dev->guests list to which the affected
> APQN(s) may be assigned. The kvm->lock can then be taken prior to the
> matrix_dev->lock and the APCB plugged into the guest without any problem.

IMHO correct and sane locking is one of the key points we have to
resolve. Frankly, I'm having trouble understanding the why behind some
of your changes, compared to v16, and I suspect that looking for a good
locking scheme might have played a role.

In the beginning, I was not very keen on taking the kvm->lock first
and the matrix_dev->lock, but the more I think about it the more I
become convinced that this is probably the simplest way to resolve the
problem in a satisfactory manner. I don't like the idea of
hogging the kvm->lock and potentially stalling out some core kvm code
because there is contention on matrix_dev->lock. And it is kind of up to
the user-space and the guests, how much pressure is put on the
matrix_dev->lock. And I'm still worried about that, but when I went
through the alternatives, my mood turned form bad to worse. Because of
that, I'm fine with this solution, provided some of the KVM/s390
maintainers ack it as well. I don't feel comfortable making a call on
this alone.

That said, let me also sum up my thoughts on alternatives and
non-alternatives, hopefully for the benefit of other reviewers.

1) I deeply regret that I used to argue against handling PQAP in
userspace with an ioctl as Pierre originally proposed. I was unaware of
the kvm->lock vcpu->lock locking order. Back then we didn't use to
have that sequence, but the rule was already there. I guess we could
still go back to that scheme of handling PQAP if QEMU were to support
it, and thus break the circle, but that would result in a very ugly
dependency (we would need QEMU support for dynamic, and we would have
to handle the case of an old QEMU). Technically it is still possible, but
very ugly.
2) I've contemplated if it is possible to simulate the userspace exit
and re-entry via ioctl in KVM. But looking at the code, it does not
look like a sane option to me.
3) I also considered using a read-write lock for matrix_dev->lock. In
theory a read-write lock that favors reads in a sense that a steady
stream of readers can starve the writers would work. But rwsem can't be
used in this situation because rwsem is fair, in a sense that a waiting
writers may effectively block readers that try to acquire the lock while
the lock is held as a read lock. So while rwsem in practice does allow
for more parallelism regarding lock dependency circles it does not
provide any benefits over a mutex.
4) I considered srcu as well. But rcu is a very different beast and does
not seem to be a great fit for what we are trying to do here. We are
not not fine with working with a stale copy of the matrix in most of the
situations.
5) I also contemplated, if relaxing the mutual exclusion is possible.
PQAP only needs the CRYCB matrix to check whether the queue is in the
config or not. So maybe we could get away without taking the
matrix_dev->lock and doing separate locking for the queue in question,
and instead of delaying any updates to the CRYCB while processing AQIC,
we could just work with whatever we see in the CRYCB. Since the setting
up of the interrupts is asynchronous with respect to the instruction
requesting it (PQAP/AQIC) and the CRYCB masks are relevant in the
instruction context... So I was thinking: if we were to introduce a
separate lock for the AQIC state, and find the queue without taking
the matrix_dev->lock, we could actually process the PQAP/AQIC without
the matrix_dev->lock. But then because we would have vcpu->lock -->
vfio_ap_queue->lock, we would have to avoid ending up with a circle
on the cleanup path, and also avoid races on the cleanup path. I'm not
sure how tricky that would end up being, if at all possible.
6) We could practically implement that unfair read-write lock with
a mutex and condition variables (and a waitqueue), but that wouldn't
simplify things either. Still if we want to avoid taking kvm->lock
before taking the vfio_ap lock, it may be the most straight forward
alternative.

At the end let me also state, that my understanding of some of the
details is still incomplete.

Regards,
Halil




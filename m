Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0568748BAE0
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 23:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346565AbiAKWmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 17:42:36 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6652 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244914AbiAKWmf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jan 2022 17:42:35 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20BLvl9D018809;
        Tue, 11 Jan 2022 22:42:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=VIUtkx0Vejn4Nrh6YYDxiL+ffzO9aLrC1gxxCoClFHY=;
 b=ZLUnoZtZphudqWWQ5YsyJE0ha7oaCcWQ9LzMQLbmQ6nzekPwbcIOR9fg0rGofteVpQoc
 yeSXmyurDLseQvVVBX/XcHdojaYKm/1WNyxxtqVosrVE09Sz+g0uwfli4WbDAOgQo0pO
 M6zgqKKzTVnHK51rPbI69Y09LBeV0eMWBTVO2I1TsPGZDRqE4UpDOMpJ9lXEVjK4WwA/
 rmxjejg+S43bUvTixVhc80RmURtHHowMKWQM6HVH4ME3ysQxc69li9dyQR7PXWA15JLt
 B1/LOaUx3ZdYJZIWdK7voLEK+aOI999y90qlOQ3qWRLfNIxdOAlsa+FNtLQ50ghGGfXX tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dhj940qby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 22:42:33 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20BMf7xo030061;
        Tue, 11 Jan 2022 22:42:33 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dhj940qbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 22:42:33 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20BMgLR8019573;
        Tue, 11 Jan 2022 22:42:31 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma05wdc.us.ibm.com with ESMTP id 3df28axxk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 22:42:31 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20BMgSif23855526
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 22:42:28 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2D3428064;
        Tue, 11 Jan 2022 22:42:28 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D35142805A;
        Tue, 11 Jan 2022 22:42:27 +0000 (GMT)
Received: from [9.65.85.237] (unknown [9.65.85.237])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jan 2022 22:42:27 +0000 (GMT)
Message-ID: <165275d9-02cd-fb5d-7dc9-e6c44edecb2d@linux.ibm.com>
Date:   Tue, 11 Jan 2022 17:42:27 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v17 09/15] s390/vfio-ap: allow hot plug/unplug of AP
 resources using mdev device
Content-Language: en-US
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
 <20211021152332.70455-10-akrowiak@linux.ibm.com>
 <20220109223632.03830576.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20220109223632.03830576.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DVA7Pce2uRobcXfMV-j0JPQMGNu7Xgaa
X-Proofpoint-ORIG-GUID: EqlAvbFJ_oRGWqT8eAou57yPElgszePU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 suspectscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 adultscore=0 spamscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110118
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/9/22 16:36, Halil Pasic wrote:
> On Thu, 21 Oct 2021 11:23:26 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> Keep in mind that the kvm->lock must be taken outside of the
>> matrix_mdev->lock to avoid circular lock dependencies (i.e., a lockdep
>> splat). This will necessitate taking the matrix_dev->guests_lock in order
>> to find the guest(s) in the matrix_dev->guests list to which the affected
>> APQN(s) may be assigned. The kvm->lock can then be taken prior to the
>> matrix_dev->lock and the APCB plugged into the guest without any problem.
> IMHO correct and sane locking is one of the key points we have to
> resolve. Frankly, I'm having trouble understanding the why behind some
> of your changes, compared to v16, and I suspect that looking for a good
> locking scheme might have played a role.

The locking scheme introduced with this patch series was
precipitated by the fact that the queue probe/remove
callbacks require access to both the matrix_dev->lock
and matrix_mdev->kvm->lock. When those callbacks are
invoked, the only information we have is the queue device
being removed. In order to retrieve the mdev to which
the APQN of the queue is assigned, we have to take the
matrix_dev->lock. We also need the matrix_mdev->kvm->lock
because we are hot plugging/unplugging the queue (i.e.,
kvm_arch_crypto_set_masks).

Given we need to take the kvm->lock prior to the
matrix_dev->lock in order to avoid potential lockdep
splats, this design was created.

>
> In the beginning, I was not very keen on taking the kvm->lock first
> and the matrix_dev->lock, but the more I think about it the more I
> become convinced that this is probably the simplest way to resolve the
> problem in a satisfactory manner. I don't like the idea of
> hogging the kvm->lock and potentially stalling out some core kvm code
> because there is contention on matrix_dev->lock. And it is kind of up to
> the user-space and the guests, how much pressure is put on the
> matrix_dev->lock. And I'm still worried about that, but when I went
> through the alternatives, my mood turned form bad to worse. Because of
> that, I'm fine with this solution, provided some of the KVM/s390
> maintainers ack it as well. I don't feel comfortable making a call on
> this alone.

You are feeling the very same frustrations I felt when trying to
come up with a viable solution. I share your concerns, but I
was simply not able to come up with anything better that
wouldn't require redesigning the secure execution ioctls as well
as the instruction interception ioctls.

>
> That said, let me also sum up my thoughts on alternatives and
> non-alternatives, hopefully for the benefit of other reviewers.
>
> 1) I deeply regret that I used to argue against handling PQAP in
> userspace with an ioctl as Pierre originally proposed. I was unaware of
> the kvm->lock vcpu->lock locking order. Back then we didn't use to
> have that sequence, but the rule was already there. I guess we could
> still go back to that scheme of handling PQAP if QEMU were to support
> it, and thus break the circle, but that would result in a very ugly
> dependency (we would need QEMU support for dynamic, and we would have
> to handle the case of an old QEMU). Technically it is still possible, but
> very ugly.

Note that this didn't rear its ugly head until secure execution guests
were introduced.

> 2) I've contemplated if it is possible to simulate the userspace exit
> and re-entry via ioctl in KVM. But looking at the code, it does not
> look like a sane option to me.
> 3) I also considered using a read-write lock for matrix_dev->lock. In
> theory a read-write lock that favors reads in a sense that a steady
> stream of readers can starve the writers would work. But rwsem can't be
> used in this situation because rwsem is fair, in a sense that a waiting
> writers may effectively block readers that try to acquire the lock while
> the lock is held as a read lock. So while rwsem in practice does allow
> for more parallelism regarding lock dependency circles it does not
> provide any benefits over a mutex.

Note: I went down this road already and was not able to resolve
           lockdep splats with rwsem. That is not to say I exhausted
           all permutations, but I ended up pulling what little hair I
           have left out.

> 4) I considered srcu as well. But rcu is a very different beast and does
> not seem to be a great fit for what we are trying to do here. We are
> not not fine with working with a stale copy of the matrix in most of the
> situations.
> 5) I also contemplated, if relaxing the mutual exclusion is possible.
> PQAP only needs the CRYCB matrix to check whether the queue is in the
> config or not. So maybe we could get away without taking the
> matrix_dev->lock and doing separate locking for the queue in question,
> and instead of delaying any updates to the CRYCB while processing AQIC,
> we could just work with whatever we see in the CRYCB. Since the setting
> up of the interrupts is asynchronous with respect to the instruction
> requesting it (PQAP/AQIC) and the CRYCB masks are relevant in the
> instruction context... So I was thinking: if we were to introduce a
> separate lock for the AQIC state, and find the queue without taking
> the matrix_dev->lock, we could actually process the PQAP/AQIC without
> the matrix_dev->lock. But then because we would have vcpu->lock -->
> vfio_ap_queue->lock, we would have to avoid ending up with a circle
> on the cleanup path, and also avoid races on the cleanup path. I'm not
> sure how tricky that would end up being, if at all possible.

Note: I too considered this, but again failed to make it work.
           I don't recall why, but I ended up with lockdep splats.
           Maybe I just didn't design it properly.

> 6) We could practically implement that unfair read-write lock with
> a mutex and condition variables (and a waitqueue), but that wouldn't
> simplify things either. Still if we want to avoid taking kvm->lock
> before taking the vfio_ap lock, it may be the most straight forward
> alternative.

Note: The original lockdep splat was resolved with a wait queue,
           but as you may recall, that was objected to on the grounds
           that it circumvented lockdep. That is what precipitated this
           mess in the first place.

>
> At the end let me also state, that my understanding of some of the
> details is still incomplete.

Given the difficulty of keeping the mental thread needed to
implement this, I can certainly understand:)

>
> Regards,
> Halil
>
>
>


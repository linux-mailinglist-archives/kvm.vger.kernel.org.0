Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8A2283E52
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 20:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgJESaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 14:30:14 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30566 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725960AbgJESaO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Oct 2020 14:30:14 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 095ICTh8043634;
        Mon, 5 Oct 2020 14:30:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=nT2mIlBCxGDH8Fhfo/7DoCwceIjZICLyx3ExjEyaVnU=;
 b=RXR4lPzfCnfBg6euUL8El8rzAehJCupDjPTFPA2dXHY1vVCfmpQvQmgxo4shKbpTV00G
 R25AmYEvlRHghWBNeQpDXGmXkNobq5dCXGIIkkhHG56GfPn3V3Kz2SW8U7qON49e5kGS
 mGURDv753T39LB1ZTTlqlDaI8EdvcBDxhxS+jDulv1Jfxxa3duXIBTv+VSfvYbQmka/m
 HESKay/khUgYNomrDR7DOfzflpSdiBNf2MoKjGbQd35CNFKg/CZhD09kAyIQ8U+jxOA5
 CxG5ArbhgByk3bD/DDdb1LbDTZyGedaxN7h9VKVn1zjzsLOegCYmMnGXn7HpJ9wmdXNm Xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3408jb0dn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 14:30:13 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 095IUDwM166144;
        Mon, 5 Oct 2020 14:30:13 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3408jb0dkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 14:30:13 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 095IRPGn004267;
        Mon, 5 Oct 2020 18:30:10 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 33xgx7s8r2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 18:30:10 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 095IU7tv13369846
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Oct 2020 18:30:07 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B78F94C063;
        Mon,  5 Oct 2020 18:30:07 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E63C84C06A;
        Mon,  5 Oct 2020 18:30:06 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.170.31])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  5 Oct 2020 18:30:06 +0000 (GMT)
Date:   Mon, 5 Oct 2020 20:30:03 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v10 11/16] s390/vfio-ap: allow hot plug/unplug of AP
 resources using mdev device
Message-ID: <20201005203003.5db3b1eb.pasic@linux.ibm.com>
In-Reply-To: <d6ba4248-77da-4963-5653-1548ced10712@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
        <20200821195616.13554-12-akrowiak@linux.ibm.com>
        <20200928030147.7ee6f494.pasic@linux.ibm.com>
        <d6ba4248-77da-4963-5653-1548ced10712@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-05_12:2020-10-05,2020-10-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 spamscore=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010050129
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 5 Oct 2020 12:24:39 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> 
> 
> On 9/27/20 9:01 PM, Halil Pasic wrote:
> > On Fri, 21 Aug 2020 15:56:11 -0400
> > Tony Krowiak<akrowiak@linux.ibm.com>  wrote:
> >
> >> Let's hot plug/unplug adapters, domains and control domains assigned to or
> >> unassigned from an AP matrix mdev device while it is in use by a guest per
> >> the following:
> >>
> >> * When the APID of an adapter is assigned to a matrix mdev in use by a KVM
> >>    guest, the adapter will be hot plugged into the KVM guest as long as each
> >>    APQN derived from the Cartesian product of the APID being assigned and
> >>    the APQIs already assigned to the guest's CRYCB references a queue device
> >>    bound to the vfio_ap device driver.
> >>
> >> * When the APID of an adapter is unassigned from a matrix mdev in use by a
> >>    KVM guest, the adapter will be hot unplugged from the KVM guest.
> >>
> >> * When the APQI of a domain is assigned to a matrix mdev in use by a KVM
> >>    guest, the domain will be hot plugged into the KVM guest as long as each
> >>    APQN derived from the Cartesian product of the APQI being assigned and
> >>    the APIDs already assigned to the guest's CRYCB references a queue device
> >>    bound to the vfio_ap device driver.
> >>
> >> * When the APQI of a domain is unassigned from a matrix mdev in use by a
> >>    KVM guest, the domain will be hot unplugged from the KVM guest
> > Hm, I suppose this means that what your guest effectively gets may depend
> > on whether assign_domain or assign_adapter is done first.
> >
> > Suppose we have the queues
> > 0.0 0.1
> > 1.0
> > bound to vfio_ap, i.e. 1.1 is missing for a reason different than
> > belonging to the default drivers (for what exact reason no idea).
> 
> I'm not quite sure what you mean be "we have queue". I will
> assume you mean those queues are bound to the vfio_ap
> device driver. 

Yes, this is exactly what I've meant.


> The only way this could happen is if somebody
> manually unbinds queue 1.1.
> 

Assuming that:
1) every time we observe ap_perm the ap subsystem in in a settled state
(i.e. not in a middle of pushing things left and right
because of an ap_perm change, 
2) the only non-default driver is vfio_ap, and that
3) queues handle non-operational states by other means than dissapearing
(should be the case with the latest reworks)
I agree what is left is manual unbind, which I lean towards considering
an edge case.

If this is indeed just about that edge case, maybe we can live with a
simpler algorithm than this one.


> > Let's suppose we started with the matix containing only adapter
> > 0 (0.) and domain 0 (.0).
> >
> > After echo 1 > assign_adapter && echo 1 > assign_domain we end up with
> > matrix:
> > 0.0 0.1
> > 1.0 1.1
> > guest_matrix:
> > 0.0 0.1
> > while after echo 1 > assign_domain && echo 1 > assign_adapter we end up
> > with:
> > matrix:
> > 0.0 0.1
> > 1.0 1.1
> > guest_matrix:
> > 0.0
> > 0.1
> >
> > That means, the set of bound queues and the set of assigned resources do
> > not fully determine the set of resources passed through to the guest.
> >
> > Is that a deliberate design choice?
> 
> Yes, it is a deliberate choice to only allow guest access to queues
> represented by queue devices bound to the vfio_ap device driver.
> The idea here is to adhere to the linux device model.
> 

This is not what I've asked. My question was about he fact that
reordering assignments gives different results. Well this was kind
of the case before as well, with the notable difference, that in a
past we always had an error. So if a full sequence of assignments could
be performed without an error, than any permutation would be performed
with the exact same result.

I'm all for only allowing guest access to queues represented by queue
devices bound to the vfio_ap device driver. I'm concerned with the
permutation (and calculus).

> >
> >> * When the domain number of a control domain is assigned to a matrix mdev
> >>    in use by a KVM guest, the control domain will be hot plugged into the
> >>    KVM guest.
> >>
> >> * When the domain number of a control domain is unassigned from a matrix
> >>    mdev in use by a KVM guest, the control domain will be hot unplugged
> >>    from the KVM guest.
> >>
> >> Signed-off-by: Tony Krowiak<akrowiak@linux.ibm.com>
> >> ---

[..]

> >> +static bool vfio_ap_mdev_assign_guest_apid(struct ap_matrix_mdev *matrix_mdev,
> >> +					   unsigned long apid)
> >> +{
> >> +	unsigned long apqi, apqn;
> >> +
> >> +	if (!vfio_ap_mdev_has_crycb(matrix_mdev) ||
> >> +	    !test_bit_inv(apid, (unsigned long *)matrix_dev->info.apm))
> >> +		return false;
> >> +
> >> +	if (bitmap_empty(matrix_mdev->shadow_apcb.aqm, AP_DOMAINS))
> >> +		return vfio_ap_mdev_assign_apqis_4_apid(matrix_mdev, apid);
> > Hm. Let's say we have the same situation regarding the bound queues as
> > above but we start with the empty matrix, and do all the assignments
> > while the guest is running.
> >
> > Consider the following sequence of actions.
> >
> > 1) echo 0 > assign_domain
> 
> matrix:            .0
> guest_matrix: no APQNs
> 
> > 2) echo 1 > assign_domain
> 
> matrix:            .0, .1
> guest_matrix: no APQNs
> 
> > 3) echo 1 > assign_adapter
> 
> matrix:           1.0, 1.1
> guest_matrix: 1.0
> 
> > 4) echo 0 > assign_adapter
> 
> matrix:           0.0, 0.1, 1.0, 1.1
> guest_matrix: 0.0, 1.0
> > 5) echo 1 > unassign_adapter
> 
> matrix:           0.0, 0.1
> guest_matrix: 0.0
> 
> > I understand that at 3), because
> > bitmap_empty(matrix_mdev->shadow_apcb.aqm)we would end up with a shadow
> > aqm containing just domain 0, as queue 1.1 ain't bound to us.
> 
> True
> 
> > Thus at the end we would have
> > matrix:
> > 0.0 0.1
> > guest_matrix:
> > 0.0
> 
> At the end I had:
> matrix:            0.0, 0.1
> guest_matrix: 0.0
> 
> > And if we add in an adapter 2. into the mix with the queues 2.0 and 2.1
> > then after
> > 6) echo 2 > assign_adapter
> > we get
> > Thus at the end we would have
> > matrix:
> > 0.0 0.1
> > 2.0 2.1
> > guest_matrix:
> > 0.0
> > 2.0
> >
> > This looks very quirky to me. Did I read the code wrong? Opinions?
> 
> You read the code correctly and I agree, this is a bit quirky. I would say
> that after adding adapter 2, we should end up with guest matrix:
> 0.0, 0.1
> 2.0, 2.1
> 
> If you agree, I'll make the adjustment.
> 

I do agree, but maybe we should discuss what adjustments do you have in
mind.

[..]

> >> +static bool vfio_ap_mdev_unassign_guest_apid(struct ap_matrix_mdev *matrix_mdev,
> >> +					     unsigned long apid)
> >> +{
> >> +	if (vfio_ap_mdev_has_crycb(matrix_mdev)) {
> >> +		if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm)) {
> >> +			clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
> >> +
> >> +			/*
> >> +			 * If there are no APIDs assigned to the guest, then
> >> +			 * the guest will not have access to any queues, so
> >> +			 * let's also go ahead and unassign the APQIs. Keeping
> >> +			 * them around may yield unpredictable results during
> >> +			 * a probe that is not related to a host AP
> >> +			 * configuration change (i.e., an AP adapter is
> >> +			 * configured online).
> >> +			 */
> > I don't quite understand this comment. Clearing out the other mask when
> > the other one becomes empty, does allow us to recover the full possible guest
> > matrix in the scenario described above. I don't see any shadow
> > manipulation in the probe handler at this stage. Are we maybe
> > talking about the same effect as I described for assign?
> 
> Patch 15/16 is for the probe.
> 

I still don't understand the logic, but I guess we want to make
adjustments anyways, so maybe I don't have to.

Regards,
Halil

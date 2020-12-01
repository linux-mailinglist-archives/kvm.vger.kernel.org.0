Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE022CB0B3
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 00:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgLAXPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 18:15:52 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54044 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726332AbgLAXPw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Dec 2020 18:15:52 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1N2suv064820;
        Tue, 1 Dec 2020 18:15:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=rnmVbviuLrDh7M5fcFhR9gXOraMeI5tZXxvxlJf4CWU=;
 b=NHmPs3m0YMv0BOnxtRSbT5Gvs9g/MMQdvCJqlQc1STloHB4UkNi5HeoWK2W3ptkTC1jG
 DPqF6hc1fa9PKmhXBcd9zms/Asjgo+CUqXXfpbzXwALxIG+hqYJBJ2R3g1p8eYq+ZRh7
 HqkkMwQObuqqO5OX3PPqCYgXfk9XOP/yKq0U1Gdhx6GAkkqJZJiyy6qetOYzEi+KS2qc
 AaecD2iWrZUlCxqWBWFTZDizb+egfSzivwjFcIClZYy6YBHyY0awSGCjYFOjPHGIZrEd
 4QQ+hmsIrbrUiMEwEKU1U9gkwk9Ffd7985oUGBIz1iOMbGtdp8eYbiouUNEW+vq5PBQJ uQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 355jjh6u76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 18:15:07 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B1N3Dju065610;
        Tue, 1 Dec 2020 18:15:07 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 355jjh6u64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 18:15:06 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B1N2Y5C012753;
        Tue, 1 Dec 2020 23:15:04 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 354fpdabxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 23:15:04 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B1NF2BP58917316
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Dec 2020 23:15:02 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0273AA4062;
        Tue,  1 Dec 2020 23:15:02 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05395A405B;
        Tue,  1 Dec 2020 23:14:59 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.25.88])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue,  1 Dec 2020 23:14:58 +0000 (GMT)
Date:   Wed, 2 Dec 2020 00:14:54 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v12 12/17] s390/vfio-ap: allow hot plug/unplug of AP
 resources using mdev device
Message-ID: <20201202001454.5ea80130.pasic@linux.ibm.com>
In-Reply-To: <84d1126b-08f8-9f8e-ad72-490625aabbd6@linux.ibm.com>
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
        <20201124214016.3013-13-akrowiak@linux.ibm.com>
        <20201129025250.16eb8355.pasic@linux.ibm.com>
        <103cbe02-2093-c950-8d65-d3dc385942ce@linux.ibm.com>
        <20201201003227.0c3696fc.pasic@linux.ibm.com>
        <20201201185659.72ca96c8.pasic@linux.ibm.com>
        <84d1126b-08f8-9f8e-ad72-490625aabbd6@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_12:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 impostorscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010137
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 1 Dec 2020 17:12:56 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 12/1/20 12:56 PM, Halil Pasic wrote:
> > On Tue, 1 Dec 2020 00:32:27 +0100
> > Halil Pasic <pasic@linux.ibm.com> wrote:
> >  
> >>>
> >>> On 11/28/20 8:52 PM, Halil Pasic wrote:  
> >> [..]  
> >>>>> * Unassign adapter from mdev's matrix:
> >>>>>
> >>>>>     The domain will be hot unplugged from the KVM guest if it is
> >>>>>     assigned to the guest's matrix.
> >>>>>
> >>>>> * Assign a control domain:
> >>>>>
> >>>>>     The control domain will be hot plugged into the KVM guest if it is not
> >>>>>     assigned to the guest's APCB. The AP architecture ensures a guest will
> >>>>>     only get access to the control domain if it is in the host's AP
> >>>>>     configuration, so there is no risk in hot plugging it; however, it will
> >>>>>     become automatically available to the guest when it is added to the host
> >>>>>     configuration.
> >>>>>
> >>>>> * Unassign a control domain:
> >>>>>
> >>>>>     The control domain will be hot unplugged from the KVM guest if it is
> >>>>>     assigned to the guest's APCB.  
> >>>> This is where things start getting tricky. E.g. do we need to revise
> >>>> filtering after an unassign? (For example an assign_adapter X didn't
> >>>> change the shadow, because queue XY was missing, but now we unplug domain
> >>>> Y. Should the adapter X pop up? I guess it should.)  
> >>> I suppose that makes sense at the expense of making the code
> >>> more complex. It is essentially what we had in the prior version
> >>> which used the same filtering code for assignment as well as
> >>> host AP configuration changes.
> >>>      
> >> Will have to think about it some more. Making the user unplug and
> >> replug an adapter because at some point it got filtered, but there
> >> is no need to filter it does not feel right. On the other hand, I'm
> >> afraid I'm complaining in circles.  
> > I did some thinking. The following statements are about the state of
> > affairs, when all 17 patches are applied. I'm commenting here, because
> > I believe this is the patch that introduces the most controversial code.
> >
> > First about low level problems with the current code/design. The other is
> > empty handling in vfio_ap_assign_apid_to_apcb() (and
> > vfio_ap_assign_apqi_to_apcb()) is troublesome. The final product
> > allows for over-commitment, i.e. assignment of e.g. domains that
> > are not in the crypto host config. Let's assume the host LPAR
> > has usage domains 1 and 2, and adapters 1, 2, and 3. The apmask
> > and aqmask are both 0 (all in on vfio), all bound. We start with an empty
> > mdev that is tied to a running guest:
> > assign_adapter 1
> > assign_adapter 2
> > assign_adapter 3
> > assign_adapter 4
> > all of these will work. The resulting shadow_apcb is completely empty. No
> > commit_apcb.
> > assign_domain 1
> > assign_domain 2
> > assign_domain 3
> > all of these will work. But again the shadow_apcb is completely empty at
> > the end: we did get to the loop that is checking the boundness of the
> > queues, but please note that we are checking against matrix.apm, and
> > adapter 4 is not in the config of the host.
> >
> > I've hacked up a fixup patch for these problems that simplifies the
> > code considerably, but there are design level issues, that run deeper,
> > so I'm not sure the fixups are the way to go.
> >
> > Now lets talk about design level stuff. Currently the assignment
> > operations are designed in to accommodate the FCFS principle. This
> > is a blessing and a curse at the same time.
> >
> > Consider the following scenarios. We have an empty (nothing assigned
> > mdev) and the following queues are bound to the vfio_ap driver:
> > 0.0
> > 0.1
> > 1.0
> > If the we do
> > asssign_adapter 0
> > assign_domain 0
> > assign_domain 1
> > assign_adapter 1
> > We end up with the guest_matrix
> > 0.0
> > 0.1
> > and the matrix
> > 0.0
> > 0.1
> > 1.0
> > 1.0
> >
> > That is a different result compared to
> > asssign_adapter 0
> > assign_domain 0
> > assign_adapter 1
> > assign_domain 1
> > or the situation where we have 0.0, 0.1, 1.0 and 1.1 bound to vfio_ap
> > and then 1.1 gets unbound.  
> 
> In v11 of the patch series, the filtering code always filters
> the matrix assigned to the mdev and is invoked whenever
> an adapter or domain is assigned, a queue is probed and
> when the AP bus scan complete notification is received and
> adapters and/or domains have been added to the host AP
> configuration. So I made a slight modification to that
> filtering function to filter only by APID and ran the above
> scenarios. In each case, the resulting guest matrix was
> identicle. I also tested the bind/unbind and achieved the
> same results.
> 
> >
> > For the same system state (bound, config, ap_perm, matrix) you get a
> > different outcomes (guest_matrix), because the outcomes depend on
> > history.
> >
> > Another thing is recovery. I believe the main idea behind shadow_apcb
> > is that we should auto recover once the resources are available again.
> > The current design choices make recovery more difficult to think about
> > because we may end up having either the apid or the apqi filtered on
> > a 'hole' (an queue missing for reasons different than, belonging to
> > default, or not being in the host config).  
> 
> The filtering code from the v11 series with the tweak I
> mentioned above accomplishes this. I tested this by
> doing manual binds/unbinds of a queue using the
> scenarios you layed out.
> 
> >
> > I still think for these cases filtering out the apid is the lesser
> > evil. Yes a hotplug of a domain making hot unplugging an adapter is
> > ugly, but at least I can describe that. So I propose the following.
> > Let me hack up a fixup that morphs things in this direction. Maybe
> > I will run into unexpected problems, but if I don't then we will
> > have an alternative design you can run your testcases against. How about
> > that?  
> 
> I appreciate the offer, but I believe with the change to the v11
> filtering code I described above we have a solution. One of
> your objections to the filtering code was looping over all
> assigned adapters/domains each time an adapter or
> domain is assigned. It should also be easy to examine only
> the APQNs involving the new APID or APQI being assigned.
> Again, I appreciate your offer, but I don't think it is necessary
> to take you away from your priorities to involve yourself in
> mine.

Seems you have it sorted out. Unfortunately I can't really follow without
code, but I have to trust you. Can you please spin a v13 with these
improvements implemented?

Maybe I didn't comment on every patch, but I did go through all of them.
I believe we have enough material for another iteration, and further
review makes no sense at this point. I intend to come back to this
once v13 is out.

Thanks,
Halil

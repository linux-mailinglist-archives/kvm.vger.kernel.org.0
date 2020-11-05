Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B2D2A7E8D
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 13:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730515AbgKEM1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 07:27:36 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20812 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728371AbgKEM1f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Nov 2020 07:27:35 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A5C2QQu158212;
        Thu, 5 Nov 2020 07:27:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=sZMxXrWKtIj4BaIqF9S7hjC/CaI7bTxPcbqkIKzHuMg=;
 b=IfaoLbxYVCE5N0uhTdYboKW1XAaUfK7Hfp0HVtU0ghqZ8u0bq6oOdpK69l2xs4UiImMb
 roYimkmC/6ubPkVdtRb9KHzuB90IGN3gIcLysllFhzYlih454j0Ovh9cSq8+P9ZS7Lln
 sNv9GvaRBCBZiyhDo9FcPd6+ChY6psGVX8I02NUjpnHEQIQYj5qoL7d7CLeupLT78zKb
 R+8Lth3axfhig7aIBYaHScSTYis0S4dS5tordqZhKVABUUXgiWeIqY6s4UoAqdXJXnGV
 xY+98SD0vsX/xAs792riPYPOtaaHatLU3kGsde7tZ7oOsZGlL6uTPa4J5gi4CBzF/azA Pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34m34y0s85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 07:27:34 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A5C2VlO158592;
        Thu, 5 Nov 2020 07:27:34 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34m34y0s72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 07:27:34 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A5CC8d9013567;
        Thu, 5 Nov 2020 12:27:32 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 34hm6hcmjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 12:27:32 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A5CRShr1573604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Nov 2020 12:27:28 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC591AE045;
        Thu,  5 Nov 2020 12:27:28 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9A43AE04D;
        Thu,  5 Nov 2020 12:27:27 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.175.178])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 Nov 2020 12:27:27 +0000 (GMT)
Date:   Thu, 5 Nov 2020 13:27:25 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v11 08/14] s390/vfio-ap: hot plug/unplug queues on
 bind/unbind of queue device
Message-ID: <20201105132725.30485f05.pasic@linux.ibm.com>
In-Reply-To: <eb27fc27-e236-7b16-9d8c-814bba816934@linux.ibm.com>
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
        <20201022171209.19494-9-akrowiak@linux.ibm.com>
        <20201028145725.1a81c5cf.pasic@linux.ibm.com>
        <055284df-87d8-507a-d7d7-05a73459322d@linux.ibm.com>
        <20201104135218.666bf0f5.pasic@linux.ibm.com>
        <eb27fc27-e236-7b16-9d8c-814bba816934@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-05_05:2020-11-05,2020-11-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 adultscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011050079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 4 Nov 2020 16:20:26 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> > But I'm sure the code is suggesting it can, because
> > vfio_ap_mdev_filter_guest_matrix() has a third parameter called filter_apid,
> > which governs whether the apm or the aqm bit should be removed. And
> > vfio_ap_mdev_filter_guest_matrix() does get called with filter_apid=false in
> > assign_domain_store() and I don't see subsequent unlink operations that would
> > severe q->mdev_matrix.  
> 
> I think you may be conflating two different things. The q in q->matrix_mdev
> represents a queue device bound to the driver. The link to matrix_mdev
> indicates the APQN of the queue device is assigned to the matrix_mdev.
> When a new domain is assigned to matrix_mdev, we know that
> all APQNS currently assigned to the shadow_apcb  are bound to the vfio 
> driver
> because of previous filtering, so we are only concerned with those APQNs
> with the APQI of the new domain being assigned.
> 
> 1. Queues bound to vfio_ap:
>      04.0004
>      04.0047
> 2. APQNs assigned to matrix_mdev:
>      04.0004
>      04.0047
> 3. shadow_apcb:
>      04.0004
>      04.0047
> 4. Assign domain 0054 to matrix_mdev
> 5. APQI 0054 gets filtered because 04.0054 not bound to vfio_ap
> 6. no change to shadow_apcb:
>      04.0004
>      04.0047

Let me please expand on your example. For reference see the filtering
code after the example.

1. Queues bound to vfio_ap:
     04.0004
     04.0047
     05.0004
     05.0047
     05.0054
2. APQNs assigned to matrix_mdev:
     04.0004
     04.0047
3. shadow_apcb:
     04.0004
     04.0047
4. Assign domain 0054 to matrix_mdev
5. APQNs assigned to matrix_mdev:
     04.0004
     04.0047
     04.0054
5. APQI 0054 gets filtered because 04.0054 not bound to vfio_ap
6. no change to shadow_apcb:
     04.0004
     04.0047
7. assign adapter 05
8. APQNs assigned to matrix_mdev:
     04.0004
     04.0047
     04.0054 
     05.0004
     05.0047
     05.0054
9. shadow_apcb changes to:
     05.0004
     05.0047
     05.0054
because now vfio_ap_mdev_filter_guest_matrix() is called with filter_apid=true
10. assign domain 0052
11. APQNs assigned to matrix_mdev:
     04.0004
     04.0047
     04.0053     
     04.0054 
     05.0004
     05.0047
     05.0053
     05.0054
11. shadow_apcb changes to 
     04.0004
     04.0047
     05.0004
     05.0047
     because now filter_guest_matrix() is called with filter_apid=false
     and apqis 0053 and 0054 get filtered
12. 05.0054 gets removed (unbound)
13. with your current code we unplug adapter 05 from shadow_apcb
    despite the fact that 05.0054 was not in the shadow_apcb in
    the first place
14. unassign adapter 05
15. unassign domain 0053
16. APQNs assigned to matrix_mdev:     
     04.0004
     04.0047
     04.0054
17. shadow apcb is
    04.0004
    04.0047
16. assign adapter 05
15. APQNs assigned to matrix_mdev:     
     04.0004
     04.0047
     04.0054
     05.0004
     05.0047     
     05.0054
16. shadow_apcb changes to 
     <empty>
     because now filter_guest_matrix() is called with filter_apid=true
     and apqn 04 gets filtered because queues 04.0053 are not bound
     and apqn 05 gets filtered because queues 05.0053 are not bound

static int vfio_ap_mdev_filter_guest_matrix(struct ap_matrix_mdev *matrix_mdev, 
                                            bool filter_apid)                   
{                                                                               
        struct ap_matrix shadow_apcb;                                           
        unsigned long apid, apqi, apqn;                                         
                                                                                
        memcpy(&shadow_apcb, &matrix_mdev->matrix, sizeof(struct ap_matrix));   
                                                                                
        for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES) {       
                /*                                                              
                 * If the APID is not assigned to the host AP configuration,    
                 * we can not assign it to the guest's AP configuration         
                 */                                                             
                if (!test_bit_inv(apid, (unsigned long *)                       
                                  matrix_dev->config_info.apm)) {               
                        clear_bit_inv(apid, shadow_apcb.apm);                   
                        continue;                                               
                }                                                               
                                                                                
                for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,             
                                     AP_DOMAINS) {                              
                        /*                                                      
                         * If the APQI is not assigned to the host AP           
                         * configuration, then it can not be assigned to the    
                         * guest's AP configuration                             
                         */                                                     
                        if (!test_bit_inv(apqi, (unsigned long *)               
                                          matrix_dev->config_info.aqm)) {       
                                clear_bit_inv(apqi, shadow_apcb.aqm);           
                                continue;                                       
                        }                                                       
                                                                                
                        /*                                                      
                         * If the APQN is not bound to the vfio_ap device       
                         * driver, then we can't assign it to the guest's       
                         * AP configuration. The AP architecture won't          
                         * allow filtering of a single APQN, so let's filter    
                         * the APID.                                            
                         */                                                     
                        apqn = AP_MKQID(apid, apqi);                            
                                                                                
                        if (!vfio_ap_mdev_get_queue(matrix_mdev, apqn)) {       
                                if (filter_apid) {                              
                                        clear_bit_inv(apid, shadow_apcb.apm);   
                                        break;                                  
                                }                                               
                                                                                
                                clear_bit_inv(apqi, shadow_apcb.aqm);           
                                continue;                                       
                        }                                                       
                }

I realize this scenario (to play through to the end) requires  
manually unbound queue (more precisely queue missing not because
of host ap config or because of a[pq]mask), but just one 'hole' suffices.

I'm afraid, that I might be bitching around, because last time it was me
who downplayed the effects of such 'holes'.

Nevertheless, I would like to ask you to verify the scenario I've
sketched, or complain if I've gotten something wrong.

Regarding solutions to the problem. It makes no sense to talk about a
solution, before agreeing on the existence of the problem. Nevertheless
I will write down two sentences, mostly as a reminder to myself, for the
case we do agree on the existence of the problem. The simplest approach
is to always filter by apid. That way we get a quirky adapter unplug
right at steps 4, but it won't create the complicated mess we have in
the rest of the points. Another idea is to restrict the overprovisioning
of domains. Basically we would make the step 4 fail because we detected
a 'hole'. But this idea has its own problems, and in some scenarios
it does boil down to the unplug the adapter rule. 

[..]

> 
> I'm not sure why you are bringing up unlinking in the context of assigning
> a new domain. Unlinking only occurs when an APID or APQI is unassigned.

Are you certain? What about vfio_ap_mdev_on_cfg_remove()? I believe it
unplugs from the shadow_apcb, but it does not change the
assignments to the matrix_mdev. We do that so we know in remove that the
queue was already cleaned up, and does not need more cleanup.

Regards,
Halil


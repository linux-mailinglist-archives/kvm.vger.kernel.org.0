Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519CB1BA7C8
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 17:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgD0PTR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 11:19:17 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40256 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726539AbgD0PTQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Apr 2020 11:19:16 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03REYsO2070456;
        Mon, 27 Apr 2020 11:19:15 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mfhd35ee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 11:19:15 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03REZsou075191;
        Mon, 27 Apr 2020 11:19:15 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mfhd35db-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 11:19:14 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03RFAKWU001097;
        Mon, 27 Apr 2020 15:19:12 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 30mcu6v3ty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 15:19:12 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03RFI1KG65798558
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 15:18:01 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C520CA405B;
        Mon, 27 Apr 2020 15:19:09 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CF5BA405C;
        Mon, 27 Apr 2020 15:19:09 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.84.115])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Apr 2020 15:19:09 +0000 (GMT)
Date:   Mon, 27 Apr 2020 17:17:39 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Harald Freudenberger <freude@linux.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pmorel@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, jjherne@linux.ibm.com, fiuczy@linux.ibm.com
Subject: Re: [PATCH v7 01/15] s390/vfio-ap: store queue struct in hash table
 for quick access
Message-ID: <20200427171739.76291a74.pasic@linux.ibm.com>
In-Reply-To: <d15b4a8e-66eb-e4ce-c8ac-6885519940aa@linux.ibm.com>
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
        <20200407192015.19887-2-akrowiak@linux.ibm.com>
        <20200424055732.7663896d.pasic@linux.ibm.com>
        <d15b4a8e-66eb-e4ce-c8ac-6885519940aa@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_10:2020-04-27,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 malwarescore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270123
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 Apr 2020 15:05:23 +0200
Harald Freudenberger <freude@linux.ibm.com> wrote:

> On 24.04.20 05:57, Halil Pasic wrote:
> > On Tue,  7 Apr 2020 15:20:01 -0400
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >  
> >> Rather than looping over potentially 65535 objects, let's store the
> >> structures for caching information about queue devices bound to the
> >> vfio_ap device driver in a hash table keyed by APQN.  
> > @Harald:
> > Would it make sense to make the efficient lookup of an apqueue base
> > on its APQN core AP functionality instead of each driver figuring it out
> > on it's own?
> >
> > If I'm not wrong the zcrypt device/driver(s) must the problem of
> > looking up a queue based on its APQN as well.
> >
> > For instance struct ep11_cprb has a target_id filed
> > (arch/s390/include/uapi/asm/zcrypt.h).
> >
> > Regards,
> > Halil  
> 
> Hi Halil
> 
> no, the zcrypt drivers don't have this problem. They build up their own device object which
> includes a pointer to the base ap device.

I'm a bit confused. Doesn't your code loop first trough the ap_card
objects to find the APID portion of the APQN, and then loop the queue
list of the matching card to find the right ap_queue object? Or did I
miss something? Isn't that what _zcrypt_send_ep11_cprb() does? Can you
point me to the code that avoids the lookup (by apqn) for zcrypt?


If you look at the new function of vfio_ap_get_queue(unsigned long apqn)
it basically about finding the queue based on the apqn, with the
difference that it is vfio specific.

Regards,
Halil

> 
> However, this is not a big issue, as the ap_bus holds a list of ap_card objects and within each
> ap_card object there exists a list of ap_queues.





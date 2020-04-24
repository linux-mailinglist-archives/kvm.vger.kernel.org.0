Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDAE1B7DD1
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 20:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgDXSYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 14:24:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56500 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726793AbgDXSYA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 14:24:00 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03OI7KmW074755;
        Fri, 24 Apr 2020 14:23:57 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30kk5ts63y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 14:23:57 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03OI7RHT075473;
        Fri, 24 Apr 2020 14:23:56 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30kk5ts639-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 14:23:56 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03OIA4Gl020117;
        Fri, 24 Apr 2020 18:23:54 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 30fs659dkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 18:23:54 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03OINpHu56098924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 18:23:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CBA2842041;
        Fri, 24 Apr 2020 18:23:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EAB64203F;
        Fri, 24 Apr 2020 18:23:51 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.37.140])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 24 Apr 2020 18:23:51 +0000 (GMT)
Date:   Fri, 24 Apr 2020 20:23:48 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
Subject: Re: [PATCH v7 03/15] s390/zcrypt: driver callback to indicate
 resource in use
Message-ID: <20200424202348.39bb2eaf.pasic@linux.ibm.com>
In-Reply-To: <195d237d-c668-48ca-1125-08eafc0011db@linux.ibm.com>
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
        <20200407192015.19887-4-akrowiak@linux.ibm.com>
        <20200414145851.562867ae.cohuck@redhat.com>
        <35d8c3cb-78bb-8f84-41d8-c6e59d201ba0@linux.ibm.com>
        <20200416113721.124f9843.cohuck@redhat.com>
        <20200424053338.658b2a05.pasic@linux.ibm.com>
        <195d237d-c668-48ca-1125-08eafc0011db@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_09:2020-04-24,2020-04-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 impostorscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004240138
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 Apr 2020 13:07:38 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> 
> 
> On 4/23/20 11:33 PM, Halil Pasic wrote:
> > On Thu, 16 Apr 2020 11:37:21 +0200
> > Cornelia Huck <cohuck@redhat.com> wrote:
> >
> >> On Wed, 15 Apr 2020 13:10:10 -0400
> >> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >>
> >>> On 4/14/20 8:58 AM, Cornelia Huck wrote:
> >>>> On Tue,  7 Apr 2020 15:20:03 -0400
> >>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >>>>> +
> >>>>> +	if (ap_drv->in_use)
> >>>>> +		if (ap_drv->in_use(newapm, ap_perms.aqm))
> >>>> Can we log the offending apm somewhere, preferably with additional info
> >>>> that allows the admin to figure out why an error was returned?
> >>> One of the things on my TODO list is to add logging to the vfio_ap
> >>> module which will track all significant activity within the device
> >>> driver. I plan to do that with a patch or set of patches specifically
> >>> put together for that purpose. Having said that, the best place to
> >>> log this would be in the in_use callback in the vfio_ap device driver
> >>> (see next patch) where the APQNs that are in use can be identified.
> >>> For now, I will log a message to the dmesg log indicating which
> >>> APQNs are in use by the matrix mdev.
> >> Sounds reasonable. My main issue was what an admin was supposed to do
> >> until logging was in place :)
> > Logging may not be the right answer here. Imagine somebody wants to build
> > a nice web-tool for managing this stuff at scale -- e.g. something HMC. I
> > don't think the solution is to let this tool parse the kernel messages
> > and try to relate that to its own transactions.
> 
> I don't believe there is no right or wrong answer here; I simply don't
> see the relevance of discussing a tool in this context. We are talking
> about a sysfs attribute interface here, so - correct me if I'm
> mistaken - our options for notifying the user that a queue is in use are
> limited to the return code from the sysfs interface and logging. I would
> expect that a tool would have to do something similar to the callback
> implemented in the vfio_ap device driver and check the APQNs
> removed against the APQNs assigned to the mdevs to determine which
> is in use.
> 

We are talking interface design. The relevance of discussing a tool is
that any userspace tool must come by with whatever interface we come up
now. IMHO thinking about the usage (and the client code) is very helpful
in avoiding broken interface designs. AFAIK this is one of the basic
ideas behind test driven development.

Regards,
Halil

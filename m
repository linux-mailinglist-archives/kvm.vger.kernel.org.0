Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA821B6C02
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 05:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgDXDhr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 23:37:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59266 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725884AbgDXDhr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Apr 2020 23:37:47 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O3bUj1125875
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 23:37:47 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30jrxnc2k3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 23:37:44 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Fri, 24 Apr 2020 04:33:08 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 24 Apr 2020 04:33:05 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03O3Xfdf12583372
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 03:33:41 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28B36AE04D;
        Fri, 24 Apr 2020 03:33:41 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74A51AE045;
        Fri, 24 Apr 2020 03:33:40 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.87.192])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 24 Apr 2020 03:33:40 +0000 (GMT)
Date:   Fri, 24 Apr 2020 05:33:38 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
Subject: Re: [PATCH v7 03/15] s390/zcrypt: driver callback to indicate
 resource in use
In-Reply-To: <20200416113721.124f9843.cohuck@redhat.com>
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
        <20200407192015.19887-4-akrowiak@linux.ibm.com>
        <20200414145851.562867ae.cohuck@redhat.com>
        <35d8c3cb-78bb-8f84-41d8-c6e59d201ba0@linux.ibm.com>
        <20200416113721.124f9843.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20042403-0008-0000-0000-000003765C89
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042403-0009-0000-0000-00004A982BA6
Message-Id: <20200424053338.658b2a05.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-23_19:2020-04-23,2020-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 spamscore=0 clxscore=1015 suspectscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 mlxlogscore=981 mlxscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240022
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 Apr 2020 11:37:21 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Wed, 15 Apr 2020 13:10:10 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> 
> > On 4/14/20 8:58 AM, Cornelia Huck wrote:
> > > On Tue,  7 Apr 2020 15:20:03 -0400
> > > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> 
> > >> +
> > >> +	if (ap_drv->in_use)
> > >> +		if (ap_drv->in_use(newapm, ap_perms.aqm))  
> > > Can we log the offending apm somewhere, preferably with additional info
> > > that allows the admin to figure out why an error was returned?  
> > 
> > One of the things on my TODO list is to add logging to the vfio_ap
> > module which will track all significant activity within the device
> > driver. I plan to do that with a patch or set of patches specifically
> > put together for that purpose. Having said that, the best place to
> > log this would be in the in_use callback in the vfio_ap device driver
> > (see next patch) where the APQNs that are in use can be identified.
> > For now, I will log a message to the dmesg log indicating which
> > APQNs are in use by the matrix mdev.
> 
> Sounds reasonable. My main issue was what an admin was supposed to do
> until logging was in place :)

Logging may not be the right answer here. Imagine somebody wants to build
a nice web-tool for managing this stuff at scale -- e.g. something HMC. I
don't think the solution is to let this tool parse the kernel messages
and try to relate that to its own transactions.

But I do agree, having a way to report why "won't do" to the end user is
important for usability.

Regards,
Halil

> 
> > 
> > >  
> > >> +			rc = -EADDRINUSE;
> > >> +
> > >> +	module_put(drv->owner);
> > >> +
> > >> +	return rc;
> > >> +}  
> 


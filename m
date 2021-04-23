Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473B13697FA
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 19:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhDWRJj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 13:09:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57836 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229691AbhDWRJi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 13:09:38 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NH4EtP057432;
        Fri, 23 Apr 2021 13:09:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=XT3MF+QXeyK101zF2vqFzprhuAOyIadpctZ0fT0Cajc=;
 b=JCjaWC71m9rpvapqta86gzk40RU70Y+TJgiIJsmXec7VaCJJc2pDo90hggXlUlx/e+pk
 fy98MH6+FIyupI6kk4/mZx4FSUksd0lqyaKZ5LK64sMNLJ2pcsHt9EpVaNzXCgpGWbeM
 18TAWGpNI1u4tWylasARmqynGV9RjF/Y5st9KqKOIcUEv6t+zGaMsnALXri50E6lRD/Z
 PcqhoA1wl0CY2K6zxL+L23aiT2O+pWMpt1nuIBmrIkNKCYTQGO69XhaZsL7+8GrlzWMy
 VXshc0iypIzt0aJhFuxLWQz8xd0OPQqRvy9gy9S34iKnWVSPfDQZCcX24QhmR0+cHGUT KA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3841but20y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Apr 2021 13:09:01 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13NH54Ed060673;
        Fri, 23 Apr 2021 13:09:01 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3841but1yb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Apr 2021 13:09:01 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13NH85vZ014519;
        Fri, 23 Apr 2021 17:08:58 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 37yt2rue3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Apr 2021 17:08:58 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13NH8tcX36307354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Apr 2021 17:08:55 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4853511C04A;
        Fri, 23 Apr 2021 17:08:55 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE8DE11C04C;
        Fri, 23 Apr 2021 17:08:54 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.88.237])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri, 23 Apr 2021 17:08:54 +0000 (GMT)
Date:   Fri, 23 Apr 2021 19:08:53 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v4 0/4] vfio-ccw: Fix interrupt handling for
 HALT/CLEAR
Message-ID: <20210423190853.6b159871.pasic@linux.ibm.com>
In-Reply-To: <c23691d7e4d0456dffbbeb1cea80fe3395f92c86.camel@linux.ibm.com>
References: <20210413182410.1396170-1-farman@linux.ibm.com>
 <20210422025258.6ed7619d.pasic@linux.ibm.com>
 <1eb9cbdfe43a42a62f6afb0315bb1e3a103dac9a.camel@linux.ibm.com>
 <20210423135015.5283edde.pasic@linux.ibm.com>
 <c23691d7e4d0456dffbbeb1cea80fe3395f92c86.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fI_-r-MRO54pOgx6fNGf6pWV39jlraS0
X-Proofpoint-ORIG-GUID: 9A8xrKHIfqQiD1lpAs9xulM2dG-jSEAS
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 adultscore=0 bulkscore=0 suspectscore=0 mlxlogscore=862 impostorscore=0
 mlxscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104230109
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 23 Apr 2021 11:53:06 -0400
Eric Farman <farman@linux.ibm.com> wrote:

> > 
> > Is in your opinion the vfio-ccw kernel module data race free with
> > this
> > series applied?  
> 
> I have no further concerns.

I take this for a "yes, in my opinion it is data race free".

Please explain me, how do we synchronize access to
a) private->state
b) cp->initialized?

Asuming we both use the definition from the C standard, the multiple
threads potentially concurrently accessing private->state or
cp->initialized are not hard to find.

For the former you can take vfio_ccw_sch_io_todo() (has both a read
and a write, and runs from the workqueue) and fsm_io_request() (has
both read and write). I guess the accesses from fsm_io_request() are
all with the io_mutex held, but the accesses form vfio_ccw_sch_io_todo()
are not with the io_mutex held AFAICT.

And the same is true for the latter with the difference that 
vfio_ccw_sch_io_todo() manipulates cp->initialized via cp_update_scsw()
and cp_free().

These are either data races, or I'm missing something. Let me also
note that C programs data races are bad news, because of undefined
behavior.

Regards,
Halil



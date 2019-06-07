Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC03539198
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 18:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbfFGQGn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 12:06:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35300 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729408AbfFGQGn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jun 2019 12:06:43 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x57FvGOA132100
        for <kvm@vger.kernel.org>; Fri, 7 Jun 2019 12:06:41 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2syth4hyd7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2019 12:06:40 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Fri, 7 Jun 2019 17:06:36 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 7 Jun 2019 17:06:32 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x57G6Vsl58982588
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Jun 2019 16:06:32 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D22ADAE056;
        Fri,  7 Jun 2019 16:06:31 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82A47AE045;
        Fri,  7 Jun 2019 16:06:31 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.224.168])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  7 Jun 2019 16:06:31 +0000 (GMT)
Date:   Fri, 7 Jun 2019 18:06:30 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Libvirt Devel <libvir-list@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Erik Skultety <eskultet@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        Sylvain Bauza <sbauza@redhat.com>
Subject: Re: mdevctl: A shoestring mediated device management and
 persistence utility
In-Reply-To: <20190524121106.16e08562.cohuck@redhat.com>
References: <20190523172001.41f386d8@x1.home>
 <20190524121106.16e08562.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19060716-0008-0000-0000-000002F14B12
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060716-0009-0000-0000-0000225E3C29
Message-Id: <20190607180630.7e8e24d4.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-07_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906070109
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 May 2019 12:11:06 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Thu, 23 May 2019 17:20:01 -0600
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> > Hi,
> > 

[..]

> > 
> > It would be really useful if s390 folks could help me understand
> > whether it's possible to glean all the information necessary to
> > recreate a ccw or ap mdev device from sysfs.  I expect the file where
> > we currently only store the mdev_type to evolve into something that
> > includes more information to facilitate more complicated devices.  For
> > now I make no claims to maintaining compatibility of recorded mdev
> > devices, it will absolutely change, but I didn't want to get bogged
> > down in making sure I don't accidentally source a root kit hidden in an
> > mdev config file.
> 
> I played a bit with it on my LPAR, and it is at least not obviously
> broken with vfio-ccw :) I don't have any ap devices to play with,
> though.
> 

Sorry for being late...

I guess for vfio-ccw one needs to make sure that the ccw device is bound
to the vfio-ccw driver first, and only after that can one use  
create-mdev to create the mdev on top of the subchannel.

So to make this work persistently (survive a reboot) one would need to
take care of the subchannel getting bound to the right vfio_ccw driver
before mdevctl is called. Right?

BTW how does this concurrence situation between the drivers io_subchannel
and vfio_ccw work? Especially if both are build in?

> > 
> > I'm also curious how or if libvirt or openstack might use this.  If
> > nothing else, it makes libvirt hook scripts easier to write, especially
> > if we add an option not to autostart mdevs, or if users don't mind
> > persistent mdevs, maybe there's nothing more to do.
> > 

+1

@Alex: I'm curious what is the big management picture for non-auto looks
like.

Regards,
Halil

[..]


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA75B42A57
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 17:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439994AbfFLPHu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 11:07:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40182 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436492AbfFLPHu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Jun 2019 11:07:50 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5CF4Zlt105842
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2019 11:07:49 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t33jk0sam-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2019 11:07:49 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Wed, 12 Jun 2019 16:07:47 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 12 Jun 2019 16:07:43 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5CF7gnt58982610
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 15:07:42 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B91DE11C052;
        Wed, 12 Jun 2019 15:07:42 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69EDE11C054;
        Wed, 12 Jun 2019 15:07:42 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.224.26])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Jun 2019 15:07:42 +0000 (GMT)
Date:   Wed, 12 Jun 2019 17:07:41 +0200
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
In-Reply-To: <20190611214508.0a86aeb2.cohuck@redhat.com>
References: <20190523172001.41f386d8@x1.home>
        <20190524121106.16e08562.cohuck@redhat.com>
        <20190607180630.7e8e24d4.pasic@linux.ibm.com>
        <20190611214508.0a86aeb2.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19061215-0008-0000-0000-000002F327CE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061215-0009-0000-0000-000022602A38
Message-Id: <20190612170741.37d5276b.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906120101
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Jun 2019 21:45:08 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Fri, 7 Jun 2019 18:06:30 +0200
> Halil Pasic <pasic@linux.ibm.com> wrote:
> 
> > On Fri, 24 May 2019 12:11:06 +0200
> > Cornelia Huck <cohuck@redhat.com> wrote:
> > 
> > > On Thu, 23 May 2019 17:20:01 -0600
> > > Alex Williamson <alex.williamson@redhat.com> wrote:
> > >   
> > > > Hi,
> > > >   
> > 
> > [..]
> > 
> > > > 
> > > > It would be really useful if s390 folks could help me understand
> > > > whether it's possible to glean all the information necessary to
> > > > recreate a ccw or ap mdev device from sysfs.  I expect the file where
> > > > we currently only store the mdev_type to evolve into something that
> > > > includes more information to facilitate more complicated devices.  For
> > > > now I make no claims to maintaining compatibility of recorded mdev
> > > > devices, it will absolutely change, but I didn't want to get bogged
> > > > down in making sure I don't accidentally source a root kit hidden in an
> > > > mdev config file.  
> > > 
> > > I played a bit with it on my LPAR, and it is at least not obviously
> > > broken with vfio-ccw :) I don't have any ap devices to play with,
> > > though.
> > >   
> > 
> > Sorry for being late...
> > 
> > I guess for vfio-ccw one needs to make sure that the ccw device is bound
> > to the vfio-ccw driver first, and only after that can one use  
> > create-mdev to create the mdev on top of the subchannel.
> > 
> > So to make this work persistently (survive a reboot) one would need to
> > take care of the subchannel getting bound to the right vfio_ccw driver
> > before mdevctl is called. Right?
> > 
> > BTW how does this concurrence situation between the drivers io_subchannel
> > and vfio_ccw work? Especially if both are build in?
> 
> If you have two drivers that match to the same device type, you'll
> always have the issue that the driver that is first matched with the
> device will bind to it and you have to do the unbind/rebind dance to
> get it bound to the correct device driver. (I guess that this was the
> basic motivation behind the ap bus default driver infrastructure,
> right?) 

Yes and no. The main idea behind the ap bus default driver infrastructure
is to make devices 'return' to the right driver (family) even if the
devices linux representation (kobj) gets destroyed and reconstructed
(e.g. due to loss of connectivity).

> I think that in our case the io_subchannel driver will be
> called first (alphabetical order and the fact that vfio-ccw will often
> be a module).

Did some more digging vfio_ccw seems to be device_initcall, while
io_subchannel subsys_initcall. I.e. we are safe there.

> I'm not sure if it is within the scope of mdevctl to
> ensure that the device is bound to the correct driver, or if it rather
> should work with devices already bound to the correct driver only.
> Maybe a separate udev-rules generator?
>

My point is, for persistent mdevctl should do it's magic after this
mechanism kicked in. Otherwise mdevctl will fail to accomplish its
purpose.

I wonder if that is the case with driverctl. From what I say both have
"""
DefaultDependencies=no
Before=basic.target
"""
in the @.service file...

I'm just trying to figure out how the end-to end solution looks like.

> There's also the question where that automatic configuration should
> stop. Should cio_ignore handling be part of it as well? [That's a
> non-generic interface, of course. Tooling within s390-tools, maybe?]
>

Isn't cio_ignore a /proc interface? I don't think mdevctl should be
concerned with cio_ignore.

Regards,
Halil


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7078142B51
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 17:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729769AbfFLPyp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 11:54:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41834 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726725AbfFLPyp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Jun 2019 11:54:45 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5CFpdIo120548
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2019 11:54:43 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t33bcufvv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2019 11:54:43 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Wed, 12 Jun 2019 16:54:41 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 12 Jun 2019 16:54:37 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5CFsa3417301728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 15:54:36 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 850C24203F;
        Wed, 12 Jun 2019 15:54:36 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27AC442045;
        Wed, 12 Jun 2019 15:54:36 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.224.26])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Jun 2019 15:54:36 +0000 (GMT)
Date:   Wed, 12 Jun 2019 17:54:34 +0200
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
In-Reply-To: <20190612091439.3a33f17b.cohuck@redhat.com>
References: <20190523172001.41f386d8@x1.home>
        <20190524121106.16e08562.cohuck@redhat.com>
        <20190607180630.7e8e24d4.pasic@linux.ibm.com>
        <20190611214508.0a86aeb2.cohuck@redhat.com>
        <20190611142822.238ef424@x1.home>
        <20190612091439.3a33f17b.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19061215-0016-0000-0000-000002887DBC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061215-0017-0000-0000-000032E5B47B
Message-Id: <20190612175434.54e196e2.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906120106
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 12 Jun 2019 09:14:39 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Tue, 11 Jun 2019 14:28:22 -0600
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> > On Tue, 11 Jun 2019 21:45:08 +0200
> > Cornelia Huck <cohuck@redhat.com> wrote:
> > 
> > > On Fri, 7 Jun 2019 18:06:30 +0200
> > > Halil Pasic <pasic@linux.ibm.com> wrote:
> 
> > > > I guess for vfio-ccw one needs to make sure that the ccw device is bound
> > > > to the vfio-ccw driver first, and only after that can one use  
> > > > create-mdev to create the mdev on top of the subchannel.
> > > > 
> > > > So to make this work persistently (survive a reboot) one would need to
> > > > take care of the subchannel getting bound to the right vfio_ccw driver
> > > > before mdevctl is called. Right?
> > > > 
> > > > BTW how does this concurrence situation between the drivers io_subchannel
> > > > and vfio_ccw work? Especially if both are build in?    
> > > 
> > > If you have two drivers that match to the same device type, you'll
> > > always have the issue that the driver that is first matched with the
> > > device will bind to it and you have to do the unbind/rebind dance to
> > > get it bound to the correct device driver. (I guess that this was the
> > > basic motivation behind the ap bus default driver infrastructure,
> > > right?) I think that in our case the io_subchannel driver will be
> > > called first (alphabetical order and the fact that vfio-ccw will often
> > > be a module). I'm not sure if it is within the scope of mdevctl to
> > > ensure that the device is bound to the correct driver, or if it rather
> > > should work with devices already bound to the correct driver only.
> > > Maybe a separate udev-rules generator?  
> > 
> > Getting a device bound to a specific driver is exactly the domain of
> > driverctl.  Implement the sysfs interfaces driverctl uses and see if it
> > works.  Driverctl defaults to PCI and knows some extra things about
> > PCI, but appears to be written to be generally bus agnostic.  Thanks,
> > 
> > Alex
> 

@Alex: Thanks! I was not aware of driverctl.

> Ok, looked at driverctl. Extending this one for non-PCI seems like a
> reasonable path. However, we would also need to extend any non-PCI
> device type we want to support with a driver_override attribute like
> you did for PCI in 782a985d7af26db39e86070d28f987cad2 -- so this is
> only for newer kernels. Adding that attribute for subchannels looks
> feasible at a glance, but I have not tried to actually do it :)
> 
> Halil, do you think that would make sense?

Looks doable. Did not quite figure out the details yet, but it seems
that for PCI driver_override has more benefits than for cio (compared
to simple unbind/bind), as matching and probing seems to be more
elaborate for PCI. The benefit I see are
1) the ability to exclude the device form driver binding, and
2) having the same mechanism and thus consistent experience for pci and
cio.

What we IMHO should not do is make driver_override the override the
sch->st == id->type check.

Regards,
Halil

> 
> [This might also help with the lcs vs. ctc confusion on a certain 3088
> cu model if this is added for ccw devices as well; but I'm not sure if
> these are still out in the wild at all. Probably not worth the effort
> for that.]


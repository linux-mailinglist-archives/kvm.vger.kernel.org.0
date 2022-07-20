Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0F757AE19
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 04:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238725AbiGTCmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 22:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbiGTCmF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 22:42:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1316EEB0;
        Tue, 19 Jul 2022 19:42:05 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26K1vM1w002745;
        Wed, 20 Jul 2022 02:41:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=7UEjnQ9Fw6qm3Hnb75fqa7qC0uHbRbZqMqQPaL3jSks=;
 b=GEO319hiz4JcjWvgkEyTnTsiBpSxsxuJw86w4TeFqXDwzapXsm0QM7+wjx1FrTNiWYHx
 O8kGpqF/LgaIFiOuDpQx5xOXrdwCjop/vmdA9YGjFb8wAdtKYfzmQkv6nfEwadMo+hgv
 DyE0Qa7cA85pgqXiQTxAFlJbb/0S2qSVCkw4gTe352FKZnURn1FVJQ7wMVmpzCdMwjJL
 GShrjKTRTEZ1+5dUD6rDgiRYf3t0DYyiAhydJp7lnhcoIsr3u9ES8803iho+Xq5NHc6W
 q1kDAxh4dHwzkbgK5B3gspaQClR9msqBPDw4gBuJYja0QEVmH/Og3gl8/b+s8MA9wBwM eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3he8g71e0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jul 2022 02:41:55 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26K2WdG4010868;
        Wed, 20 Jul 2022 02:41:55 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3he8g71e00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jul 2022 02:41:55 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26K2KsF4021125;
        Wed, 20 Jul 2022 02:41:53 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma05wdc.us.ibm.com with ESMTP id 3hbmy9pyyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jul 2022 02:41:53 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26K2fr2i1442516
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jul 2022 02:41:53 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3685BAC05F;
        Wed, 20 Jul 2022 02:41:53 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C285AC05B;
        Wed, 20 Jul 2022 02:41:50 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.146.30])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 20 Jul 2022 02:41:50 +0000 (GMT)
Message-ID: <29248eb6e20ef5990d3189ba5468fe4d8bada61a.camel@linux.ibm.com>
Subject: Re: simplify the mdev interface v6
From:   Eric Farman <farman@linux.ibm.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Vineeth Vijayan <vneethv@linux.ibm.com>
Date:   Tue, 19 Jul 2022 22:41:49 -0400
In-Reply-To: <20cba66846a011e2fe8885f15def6ec837d12d0b.camel@linux.ibm.com>
References: <20220709045450.609884-1-hch@lst.de>
         <20220718054348.GA22345@lst.de>
         <20220718153331.18a52e31.alex.williamson@redhat.com>
         <1f945ef0eb6c02079700a6785ca3dd9864096b82.camel@linux.ibm.com>
         <20220719144928.GB21431@lst.de>
         <20220719092644.3db1ceee.alex.williamson@redhat.com>
         <20cba66846a011e2fe8885f15def6ec837d12d0b.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8RZjUmOqkPePhUJr-PvgkgwHde1AOURb
X-Proofpoint-ORIG-GUID: pWHeslY43WUiJry92UTwTRrbhDGkMex_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-19_10,2022-07-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 bulkscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 malwarescore=0 impostorscore=0 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207200008
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-07-19 at 13:49 -0400, Eric Farman wrote:
> On Tue, 2022-07-19 at 09:26 -0600, Alex Williamson wrote:
> > On Tue, 19 Jul 2022 16:49:28 +0200
> > Christoph Hellwig <hch@lst.de> wrote:
> > 
> > > On Mon, Jul 18, 2022 at 10:01:40PM -0400, Eric Farman wrote:
> > > > I'll get the problem with struct subchannel [1] sorted out in
> > > > the
> > > > next
> > > > couple of days. This series breaks vfio-ccw in its current form
> > > > (see
> > > > reply to patch 14), but even with that addressed the placement
> > > > of
> > > > all
> > > > these other mdev structs needs to be handled differently.  
> > > 
> > > Alex, any preference if I should just fix the number instances
> > > checking
> > > with either an incremental patch or a resend, or wait for this
> > > ccw
> > > rework?
> > 
> > Since it's the last patch, let's at least just respin that patch
> > rather
> > than break and fix.  I'd like to make sure Eric is ok to shift
> > around
> > structures as a follow-up or make a proposal how this series should
> > change though. 
> 
> I'd hoped to have that proposal today, but I don't have much
> confidence
> in it yet as this series (with the fix on the last patch) is still
> crashing my system. Will get something out as soon as I'm able.

The solution I envision thus far does two things:

 - Move the struct mdev_parent and its friends out of struct
subchannel, and into struct vfio_ccw_private. This struct is allocated
just prior to the call to mdev_register_device/_parent, and released
with the mdev_unregister. It's also a device-specific struct linked
from the device-agnostic subchannel.
 - Add a kref to struct vfio_ccw_private. The mdev_parent currently has
one, which is now unnecessary since it's embedded in another struct,
but it leaves vfio_ccw_private rather racy.

I suspect the second item (or something similar) is needed anyway,
because Alex' tree + this series crashes frequently in (usually)
mdev_remove. I haven't found an explanation for how we get in this
state, but admittedly didn't spent a lot of time on them since the
proposed changes to struct subchannel are a non-starter. The other
crashes were always in something that's almost certainly a victim of
something else, like kmalloc-related stuff in net/skbuff.

With the above, the crashes out of the vfio-ccw stack disappear, and
things work a bit better. But those random kmalloc-related crashes
persist. I guess I'll pick those up tomorrow.

Eric


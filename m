Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA4F6972B5
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 01:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbjBOAg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 19:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBOAg2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 19:36:28 -0500
X-Greylist: delayed 558 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Feb 2023 16:36:27 PST
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4C1977C
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 16:36:27 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id E454A37E180AFF;
        Tue, 14 Feb 2023 18:27:07 -0600 (CST)
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id mxSS9AhdlaO9; Tue, 14 Feb 2023 18:27:05 -0600 (CST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 2586637E180AF1;
        Tue, 14 Feb 2023 18:27:05 -0600 (CST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com 2586637E180AF1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
        t=1676420825; bh=k+Zla+TXGT+u0A7tdHZXItJb2pEmHhwdwagw90wi1D4=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=OyiReIBHBRqEu3Q9dt+hYtOGKVCGMQ9ln719/xjqjRm/2qaICeqBMgDGz6Sjabln8
         QCpeNljG3kau1Cuxk0Mll6bRX8fd/IJdUwLNfIqibC1OP5YlA0K7flHOJ+jZ4gRvbF
         QPZaQBGqYZz1M96qGrLoffu0T0EhuJ8Q8Q2SYw2s=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id oiirFsNpqpBI; Tue, 14 Feb 2023 18:27:04 -0600 (CST)
Received: from vali.starlink.edu (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id CFA8837E180AEE;
        Tue, 14 Feb 2023 18:27:04 -0600 (CST)
Date:   Tue, 14 Feb 2023 18:27:03 -0600 (CST)
From:   Timothy Pearson <tpearson@raptorengineering.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org,
        kevin tian <kevin.tian@intel.com>,
        robin murphy <robin.murphy@arm.com>, cohuck@redhat.com,
        eric auger <eric.auger@redhat.com>, nicolinc@nvidia.com,
        kvm <kvm@vger.kernel.org>, mjrosato@linux.ibm.com,
        chao p peng <chao.p.peng@linux.intel.com>,
        yi y sun <yi.y.sun@linux.intel.com>, peterx@redhat.com,
        jasowang@redhat.com,
        shameerali kolothum thodi 
        <shameerali.kolothum.thodi@huawei.com>, lulu@redhat.com,
        suravee suthikulpanit <suravee.suthikulpanit@amd.com>,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Message-ID: <595229255.11912427.1676420823058.JavaMail.zimbra@raptorengineeringinc.com>
In-Reply-To: <Y+wkqnCAe42Ogcof@nvidia.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com> <20230213151348.56451-6-yi.l.liu@intel.com> <20230214152627.3a399523.alex.williamson@redhat.com> <Y+wYX34sPvPQmGSr@nvidia.com> <20230214164235.64e2dccb.alex.williamson@redhat.com> <Y+wkqnCAe42Ogcof@nvidia.com>
Subject: Re: [PATCH v3 05/15] kvm/vfio: Accept vfio device file from
 userspace
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.5.0_GA_3042 (ZimbraWebClient - GC110 (Linux)/8.5.0_GA_3042)
Thread-Topic: kvm/vfio: Accept vfio device file from userspace
Thread-Index: AsnTMrxzRGkgYuS3YUElHBx57ph+Og==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



----- Original Message -----
> From: "Jason Gunthorpe" <jgg@nvidia.com>
> To: "Alex Williamson" <alex.williamson@redhat.com>
> Cc: "Yi Liu" <yi.l.liu@intel.com>, joro@8bytes.org, "kevin tian" <kevin.tian@intel.com>, "robin murphy"
> <robin.murphy@arm.com>, cohuck@redhat.com, "eric auger" <eric.auger@redhat.com>, nicolinc@nvidia.com, "kvm"
> <kvm@vger.kernel.org>, mjrosato@linux.ibm.com, "chao p peng" <chao.p.peng@linux.intel.com>, "yi y sun"
> <yi.y.sun@linux.intel.com>, peterx@redhat.com, jasowang@redhat.com, "shameerali kolothum thodi"
> <shameerali.kolothum.thodi@huawei.com>, lulu@redhat.com, "suravee suthikulpanit" <suravee.suthikulpanit@amd.com>,
> intel-gvt-dev@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, "linux-s390" <linux-s390@vger.kernel.org>,
> "Timothy Pearson" <tpearson@raptorengineering.com>, "Michael Ellerman" <mpe@ellerman.id.au>
> Sent: Tuesday, February 14, 2023 6:17:46 PM
> Subject: Re: [PATCH v3 05/15] kvm/vfio: Accept vfio device file from userspace

> On Tue, Feb 14, 2023 at 04:42:35PM -0700, Alex Williamson wrote:
> 
>> A device file opened through a group could be passed through this
>> interface though, right?
> 
> Yes, I think so
> 
>> Do we just chalk that up to user error?  Maybe the SPAPR extension
>> at least needs to be documented as relying on registering groups
>> rather than devices.
> 
> The way these APIs work is you have to pass the same FD to all of
> them. The SPAPR stuff is no different, if you used a cdev with
> KVM_DEV_VFIO_GROUP_ADD then you have to use the same cdev fd with the
> SPAPR group_fd. Yi just didn't rename it.
> 
> It is weird, but logically self consistent, I think.
> 
>> > I'm still thinking about proposing to just delete all this SPAPR
>> > stuff. Power still hasn't had the patches applied to make it work
>> > again so it seems to all be dead.
>> 
>> There's been some off-list discussion about at least fixing SPAPR
>> support, but yes, it either needs to get some love or we ought to think
>> about its future.  Thanks,
> 
> The patches exist, they just need to be applied AFAIK. If the people
> responsible can't care enough about this to even do that then I find
> it hard to care at all about the state of SPAPR.
> 
> Jason

I've been discussing the state of the patches offline, apologies for the delay in checking in here.

I'll be taking over SPAPR support going forward, as we need it for our product line.  My current thoughts are to rebase / fix and test the patches that were already generated, to at least get support reenabled, then we can coordinate on further changes needed to maintain the support going forward.

I should have a rebased patchset ready later this week.

Thank you!

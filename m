Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADDD84DA150
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 18:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350626AbiCORde (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 13:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350621AbiCORdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 13:33:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5247A5882A
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 10:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647365540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vIoYTkbN3Ug6dTUhmuqPkv63yNtg6n8OcRSZGx3ZPto=;
        b=g4a+O2sFhVe1fNLB9X3ukxpCjicfSkITwfA1UudW7h75TYUKWJj+tSoJRx38KqA+Mf1ScX
        uvbPJ//YtRolA8QjAMsmr0BAuSMy57b8wSMsMj8ZRx61KRi0U1sRfYzR7YX4416izcd8F8
        25L5GZz/Vxj4NJgPCaGPwLcmkSvCRjk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-DnOvd3EJMken7kVGUZ0rGw-1; Tue, 15 Mar 2022 13:32:17 -0400
X-MC-Unique: DnOvd3EJMken7kVGUZ0rGw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AAA8A802809;
        Tue, 15 Mar 2022 17:32:16 +0000 (UTC)
Received: from localhost (unknown [10.39.194.62])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6410C404C33F;
        Tue, 15 Mar 2022 17:32:16 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        yishaih@nvidia.com, linux-doc@vger.kernel.org, corbet@lwn.net
Subject: Re: [PATCH v3] vfio-pci: Provide reviewers and acceptance criteria
 for vendor drivers
In-Reply-To: <20220315102200.15a86b16.alex.williamson@redhat.com>
Organization: Red Hat GmbH
References: <164728932975.54581.1235687116658126625.stgit@omen>
 <87a6drh8hy.fsf@redhat.com> <20220315155304.GC11336@nvidia.com>
 <20220315102200.15a86b16.alex.williamson@redhat.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Tue, 15 Mar 2022 18:32:14 +0100
Message-ID: <87zglrf7fl.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 15 2022, Alex Williamson <alex.williamson@redhat.com> wrote:

> On Tue, 15 Mar 2022 12:53:04 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>
>> On Tue, Mar 15, 2022 at 10:26:17AM +0100, Cornelia Huck wrote:
>> > On Mon, Mar 14 2022, Alex Williamson <alex.williamson@redhat.com> wrote:

>> In general I wonder if this is a bit too specific to PCI, really this
>> is just review criteria for any driver making a struct vfio_device_ops
>> implementation, and we have some specific guidance for migration here
>> as well.
>> 
>> Like if IBM makes s390 migration drivers all of this applies just as
>> well even though they are not PCI.
>
> Are you volunteering to be a reviewer under drivers/vfio/?  Careful,
> I'll add you ;)
>
> What you're saying is true of course and it could be argued that this
> sort of criteria is true for any new driver, I think the unique thing
> here that raises it to a point where we want to formalize the breadth
> of reviews is how significantly lower the bar is to create a device
> specific driver now that we have a vfio-pci-core library.  Shameer's
> stub driver is 100 LoC.  I also expect that the pool of people willing
> to volunteer to be reviewers for PCI related device specific drivers is
> large than we might see for arbitrary drivers.

Yes. Also, I expect that more people understand how a PCI driver works
than how an s390 channel subsystem driver works :)

I think we'll just have to hope that attempts to add e.g. migration
support to a driver outside of vfio-pci show up on the correct mailing
lists and that the right people notice it or can be pointed towards it.

>
>> > > +New driver submissions are therefore requested to have approval via
>> > > +Sign-off/Acked-by/etc for any interactions with parent drivers.  
>> > 
>> > s/Sign-off/Reviewed-by/ ?
>> > 
>> > I would not generally expect the reviewers listed to sign off on other
>> > people's patches.  
>> 
>> It happens quite a lot when those people help write the patches too :)
>
> This is what "etc" is for, the owners are involved and have endorsed it
> in some way, that's all we care about.

Fair enough.


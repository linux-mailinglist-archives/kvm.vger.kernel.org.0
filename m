Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28B95E7C72
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 16:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbiIWOBi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 10:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbiIWOBL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 10:01:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E10F13A380
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 07:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663941669;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xjBO7tA9U+8DAn/vreMh0HlzjoAqH166EctUNXQAP6U=;
        b=ZMatY6Gf216R4WG4Jcpc6ed1MPqW8Ftji+5YxpiqArJ26gMhhmkw+BV0xOkNX57ay/KHmH
        07Fp7o1tvJXY0AbyzN3VrViOgYEaIkTRlAhCbkVsrtLWEJISm0N29P9WEF1tE64X9a9Zc0
        1gbXupD+f8gH9v23TpdAjcqWoYAEwhc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-30-UsC3BSuHOY6UBfzeRcNcSQ-1; Fri, 23 Sep 2022 10:01:06 -0400
X-MC-Unique: UsC3BSuHOY6UBfzeRcNcSQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 387A72A2AD7B;
        Fri, 23 Sep 2022 14:01:05 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.67])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CA71D4B401E;
        Fri, 23 Sep 2022 14:00:57 +0000 (UTC)
Date:   Fri, 23 Sep 2022 15:00:55 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Laine Stump <laine@redhat.com>
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Message-ID: <Yy28FzEnoKo8UExU@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <YyxFEpAOC2V1SZwk@redhat.com>
 <YyxsV5SH85YcwKum@nvidia.com>
 <Yyx13kXCF4ovsxZg@redhat.com>
 <Yyx2ijVjKOkhcPQR@nvidia.com>
 <Yyx4cEU1n0l6sP7X@redhat.com>
 <Yyx/yDQ/nDVOTKSD@nvidia.com>
 <Yy10WIgQK3Q74nBm@redhat.com>
 <Yy20xURdYLzf0ikS@nvidia.com>
 <Yy22GFgrcyMyt3q1@redhat.com>
 <Yy24rX8NQkxR2KCV@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yy24rX8NQkxR2KCV@nvidia.com>
User-Agent: Mutt/2.2.6 (2022-06-05)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 23, 2022 at 10:46:21AM -0300, Jason Gunthorpe wrote:
> On Fri, Sep 23, 2022 at 02:35:20PM +0100, Daniel P. Berrangé wrote:
> > On Fri, Sep 23, 2022 at 10:29:41AM -0300, Jason Gunthorpe wrote:
> > > On Fri, Sep 23, 2022 at 09:54:48AM +0100, Daniel P. Berrangé wrote:
> > > 
> > > > Yes, we use cgroups extensively already.
> > > 
> > > Ok, I will try to see about this
> > > 
> > > Can you also tell me if the selinux/seccomp will prevent qemu from
> > > opening more than one /dev/vfio/vfio ? I suppose the answer is no?
> > 
> > I don't believe there's any restriction on the nubmer of open attempts,
> > its just a case of allowed or denied globally for the VM.
> 
> Ok
> 
> For iommufd we plan to have qemu accept a single already opened FD of
> /dev/iommu and so the selinux/etc would block all access to the
> chardev.

A selinux policy update would be needed to allow read()/write() for the
inherited FD, whle keeping open() blocked

> Can you tell me if the thing invoking qmeu that will open /dev/iommu
> will have CAP_SYS_RESOURCE ? I assume yes if it is already touching
> ulimits..

The privileged libvirtd runs with privs equiv to root, so all
capabilities are present.

The unprivileged libvirtd runs with same privs as your user account,
so no capabilities. I vaguely recall there was some way to enable
use of PCI passthrough for unpriv libvirtd, but needed a bunch of
admin setup steps ahead of time.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


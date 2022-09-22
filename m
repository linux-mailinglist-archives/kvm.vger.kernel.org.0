Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475515E6627
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 16:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbiIVOtY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 10:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbiIVOtP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 10:49:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5396AE9B
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 07:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663858153;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+3KLRyHAdGwi8cYpp6Jq5hcEOwKHMI+iwRGU9p7YXP0=;
        b=LlRc8EwCQPetxvxdNqKonvTgnJ4jkXW32dUHWsMNZWggVz+tzsE+m2EyB6XjQsdUiXGREc
        nAzPC29tthlXE4own8/35e/jge1Ys9/kCrC6iuhXjUqD4AC6tEJ9MH7dyg49fMcOJolhKF
        X/fCm5YHzJA3NYa3IciCN7hku17uc3E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-KV2SJTllOVmJ0b4UDpMoOA-1; Thu, 22 Sep 2022 10:49:10 -0400
X-MC-Unique: KV2SJTllOVmJ0b4UDpMoOA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A7872932494;
        Thu, 22 Sep 2022 14:49:09 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0413F40C2064;
        Thu, 22 Sep 2022 14:49:05 +0000 (UTC)
Date:   Thu, 22 Sep 2022 15:49:02 +0100
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
Message-ID: <Yyx13kXCF4ovsxZg@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <BN9PR11MB52762909D64C1194F4FCB4528C479@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d5e33ebb-29e6-029d-aef4-af5c4478185a@redhat.com>
 <Yyoa+kAJi2+/YTYn@nvidia.com>
 <20220921120649.5d2ff778.alex.williamson@redhat.com>
 <YytbiCx3CxCnP6fr@nvidia.com>
 <YyxFEpAOC2V1SZwk@redhat.com>
 <YyxsV5SH85YcwKum@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YyxsV5SH85YcwKum@nvidia.com>
User-Agent: Mutt/2.2.6 (2022-06-05)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022 at 11:08:23AM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 22, 2022 at 12:20:50PM +0100, Daniel P. Berrangé wrote:
> > On Wed, Sep 21, 2022 at 03:44:24PM -0300, Jason Gunthorpe wrote:
> > > On Wed, Sep 21, 2022 at 12:06:49PM -0600, Alex Williamson wrote:
> > > > The issue is where we account these pinned pages, where accounting is
> > > > necessary such that a user cannot lock an arbitrary number of pages
> > > > into RAM to generate a DoS attack.  
> > > 
> > > It is worth pointing out that preventing a DOS attack doesn't actually
> > > work because a *task* limit is trivially bypassed by just spawning
> > > more tasks. So, as a security feature, this is already very
> > > questionable.
> > 
> > The malicious party on host VM hosts is generally the QEMU process.
> > QEMU is normally prevented from spawning more tasks, both by SELinux
> > controls and be the seccomp sandbox blocking clone() (except for
> > thread creation).  We need to constrain what any individual QEMU can
> > do to the host, and the per-task mem locking limits can do that.
> 
> Even with syscall limits simple things like execve (enabled eg for
> qemu self-upgrade) can corrupt the kernel task-based accounting to the
> point that the limits don't work.

Note, execve is currently blocked by default too by the default
seccomp sandbox used with libvirt, as well as by the SELinux
policy again.  self-upgrade isn't a feature that exists (yet).

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


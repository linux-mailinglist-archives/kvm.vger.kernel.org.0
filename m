Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965595E7648
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 10:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbiIWIzH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 04:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbiIWIzE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 04:55:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D0956B85
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 01:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663923300;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oPg9uzCzNmVV8r2XBpynge7CiHHyMGk8yDCw0a6Idgg=;
        b=N/YxIvYJ6AnnQO5fTtML0bA3rX+FhaSscCdZxjzLaLel9HkQBghpGlk64JX6/nTY+1GHSK
        CufqmjUQSVFWxBYtroT88JYNGu3dNRi7OvBvkq0oNVt2RWUx4jsYKFm5WrRUWDEBkR8AZL
        vf/s2LL7/1wxJDDuwN/a7ZOmZvpuLUo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-6-CL72IekFNYmfv6iN96Bhog-1; Fri, 23 Sep 2022 04:54:57 -0400
X-MC-Unique: CL72IekFNYmfv6iN96Bhog-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C68C3801F51;
        Fri, 23 Sep 2022 08:54:57 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.67])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E3E22166B30;
        Fri, 23 Sep 2022 08:54:50 +0000 (UTC)
Date:   Fri, 23 Sep 2022 09:54:48 +0100
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
Message-ID: <Yy10WIgQK3Q74nBm@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <d5e33ebb-29e6-029d-aef4-af5c4478185a@redhat.com>
 <Yyoa+kAJi2+/YTYn@nvidia.com>
 <20220921120649.5d2ff778.alex.williamson@redhat.com>
 <YytbiCx3CxCnP6fr@nvidia.com>
 <YyxFEpAOC2V1SZwk@redhat.com>
 <YyxsV5SH85YcwKum@nvidia.com>
 <Yyx13kXCF4ovsxZg@redhat.com>
 <Yyx2ijVjKOkhcPQR@nvidia.com>
 <Yyx4cEU1n0l6sP7X@redhat.com>
 <Yyx/yDQ/nDVOTKSD@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yyx/yDQ/nDVOTKSD@nvidia.com>
User-Agent: Mutt/2.2.6 (2022-06-05)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022 at 12:31:20PM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 22, 2022 at 04:00:00PM +0100, Daniel P. Berrangé wrote:
> > On Thu, Sep 22, 2022 at 11:51:54AM -0300, Jason Gunthorpe wrote:
> > > On Thu, Sep 22, 2022 at 03:49:02PM +0100, Daniel P. Berrangé wrote:
> > > > On Thu, Sep 22, 2022 at 11:08:23AM -0300, Jason Gunthorpe wrote:
> > > > > On Thu, Sep 22, 2022 at 12:20:50PM +0100, Daniel P. Berrangé wrote:
> > > > > > On Wed, Sep 21, 2022 at 03:44:24PM -0300, Jason Gunthorpe wrote:
> > > > > > > On Wed, Sep 21, 2022 at 12:06:49PM -0600, Alex Williamson wrote:
> > > > > > > > The issue is where we account these pinned pages, where accounting is
> > > > > > > > necessary such that a user cannot lock an arbitrary number of pages
> > > > > > > > into RAM to generate a DoS attack.  
> > > > > > > 
> > > > > > > It is worth pointing out that preventing a DOS attack doesn't actually
> > > > > > > work because a *task* limit is trivially bypassed by just spawning
> > > > > > > more tasks. So, as a security feature, this is already very
> > > > > > > questionable.
> > > > > > 
> > > > > > The malicious party on host VM hosts is generally the QEMU process.
> > > > > > QEMU is normally prevented from spawning more tasks, both by SELinux
> > > > > > controls and be the seccomp sandbox blocking clone() (except for
> > > > > > thread creation).  We need to constrain what any individual QEMU can
> > > > > > do to the host, and the per-task mem locking limits can do that.
> > > > > 
> > > > > Even with syscall limits simple things like execve (enabled eg for
> > > > > qemu self-upgrade) can corrupt the kernel task-based accounting to the
> > > > > point that the limits don't work.
> > > > 
> > > > Note, execve is currently blocked by default too by the default
> > > > seccomp sandbox used with libvirt, as well as by the SELinux
> > > > policy again.  self-upgrade isn't a feature that exists (yet).
> > > 
> > > That userspace has disabled half the kernel isn't an excuse for the
> > > kernel to be insecure by design :( This needs to be fixed to enable
> > > features we know are coming so..
> > > 
> > > What would libvirt land like to see given task based tracking cannot
> > > be fixed in the kernel?
> > 
> > There needs to be a mechanism to control individual VMs, whether by
> > task or by cgroup. User based limits are not suited to what we need
> > to achieve.
> 
> The kernel has already standardized on user based limits here for
> other subsystems - libvirt and qemu cannot ignore that it exists. It
> is only a matter of time before qemu starts using these other
> subsystem features (eg io_uring) and has problems.
> 
> So, IMHO, the future must be that libvirt/etc sets an unlimited
> rlimit, because the user approach is not going away in the kernel and
> it sounds like libvirt cannot accommodate it at all.
> 
> This means we need to provide a new mechanism for future libvirt to
> use. Are you happy with cgroups?

Yes, we use cgroups extensively already.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


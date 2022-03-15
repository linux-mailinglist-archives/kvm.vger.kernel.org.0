Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F341C4D979B
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 10:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346597AbiCOJ1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 05:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235697AbiCOJ1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 05:27:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EE1AD48890
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 02:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647336383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=musgu39DMn+QpLBIcTaqCJ85bbJTBT0GNCkqT/YTdCw=;
        b=XdKbNuLhCZls7eYUybtus0lMJgHF9Rvcw2BYfWSkUc1g5RqgYQywLANMXWmS4e7qb8pWmq
        wV017ySpVfxG0jqYcVdqIZp9tZTd//A2zczdfoa1IRmhBxqJGX/XDgI8pNsEiik76lu9jr
        4/+JJJb3EtwVJ3SzfrLMrfVy1gPa0OE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-gjlaw87DM8G4TWOA9TQRfg-1; Tue, 15 Mar 2022 05:26:19 -0400
X-MC-Unique: gjlaw87DM8G4TWOA9TQRfg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 109F3185A79C;
        Tue, 15 Mar 2022 09:26:19 +0000 (UTC)
Received: from localhost (unknown [10.39.194.62])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 74D0D141DC2B;
        Tue, 15 Mar 2022 09:26:18 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jgg@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        yishaih@nvidia.com, linux-doc@vger.kernel.org, corbet@lwn.net
Subject: Re: [PATCH v3] vfio-pci: Provide reviewers and acceptance criteria
 for vendor drivers
In-Reply-To: <164728932975.54581.1235687116658126625.stgit@omen>
Organization: Red Hat GmbH
References: <164728932975.54581.1235687116658126625.stgit@omen>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Tue, 15 Mar 2022 10:26:17 +0100
Message-ID: <87a6drh8hy.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 14 2022, Alex Williamson <alex.williamson@redhat.com> wrote:

> Vendor or device specific extensions for devices exposed to userspace
> through the vfio-pci-core library open both new functionality and new
> risks.  Here we attempt to provided formalized requirements and
> expectations to ensure that future drivers both collaborate in their
> interaction with existing host drivers, as well as receive additional
> reviews from community members with experience in this area.
>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Yishai Hadas <yishaih@nvidia.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Acked-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---

(...)

> diff --git a/Documentation/driver-api/vfio-pci-vendor-driver-acceptance.rst b/Documentation/driver-api/vfio-pci-vendor-driver-acceptance.rst
> new file mode 100644
> index 000000000000..3a108d748681
> --- /dev/null
> +++ b/Documentation/driver-api/vfio-pci-vendor-driver-acceptance.rst

What about Christoph's request to drop the "vendor" name?
vfio-pci-device-specific-driver-acceptance.rst would match the actual
title of the document, and the only drawback I see is that it is a bit
longer.

> @@ -0,0 +1,35 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +Acceptance criteria for vfio-pci device specific driver variants
> +================================================================
> +
> +Overview
> +--------
> +The vfio-pci driver exists as a device agnostic driver using the
> +system IOMMU and relying on the robustness of platform fault
> +handling to provide isolated device access to userspace.  While the
> +vfio-pci driver does include some device specific support, further
> +extensions for yet more advanced device specific features are not
> +sustainable.  The vfio-pci driver has therefore split out
> +vfio-pci-core as a library that may be reused to implement features
> +requiring device specific knowledge, ex. saving and loading device
> +state for the purposes of supporting migration.
> +
> +In support of such features, it's expected that some device specific
> +variants may interact with parent devices (ex. SR-IOV PF in support of
> +a user assigned VF) or other extensions that may not be otherwise
> +accessible via the vfio-pci base driver.  Authors of such drivers
> +should be diligent not to create exploitable interfaces via such
> +interactions or allow unchecked userspace data to have an effect
> +beyond the scope of the assigned device.
> +
> +New driver submissions are therefore requested to have approval via
> +Sign-off/Acked-by/etc for any interactions with parent drivers.

s/Sign-off/Reviewed-by/ ?

I would not generally expect the reviewers listed to sign off on other
people's patches.

> +Additionally, drivers should make an attempt to provide sufficient
> +documentation for reviewers to understand the device specific
> +extensions, for example in the case of migration data, how is the
> +device state composed and consumed, which portions are not otherwise
> +available to the user via vfio-pci, what safeguards exist to validate
> +the data, etc.  To that extent, authors should additionally expect to
> +require reviews from at least one of the listed reviewers, in addition
> +to the overall vfio maintainer.
> diff --git a/Documentation/maintainer/maintainer-entry-profile.rst b/Documentation/maintainer/maintainer-entry-profile.rst
> index 5d5cc3acdf85..8b4971c7e3fa 100644
> --- a/Documentation/maintainer/maintainer-entry-profile.rst
> +++ b/Documentation/maintainer/maintainer-entry-profile.rst
> @@ -103,3 +103,4 @@ to do something different in the near future.
>     ../nvdimm/maintainer-entry-profile
>     ../riscv/patch-acceptance
>     ../driver-api/media/maintainer-entry-profile
> +   ../driver-api/vfio-pci-vendor-driver-acceptance
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4322b5321891..fd17d1891216 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -20314,6 +20314,16 @@ F:	drivers/vfio/mdev/
>  F:	include/linux/mdev.h
>  F:	samples/vfio-mdev/
>  
> +VFIO PCI VENDOR DRIVERS

VFIO PCI DEVICE SPECIFIC DRIVERS ?

> +R:	Jason Gunthorpe <jgg@nvidia.com>
> +R:	Yishai Hadas <yishaih@nvidia.com>
> +R:	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> +R:	Kevin Tian <kevin.tian@intel.com>
> +L:	kvm@vger.kernel.org
> +S:	Maintained
> +P:	Documentation/driver-api/vfio-pci-vendor-driver-acceptance.rst
> +F:	drivers/vfio/pci/*/
> +
>  VFIO PLATFORM DRIVER
>  M:	Eric Auger <eric.auger@redhat.com>
>  L:	kvm@vger.kernel.org

Other than that, looks good to me (and thanks to the people volunteering
for review!)


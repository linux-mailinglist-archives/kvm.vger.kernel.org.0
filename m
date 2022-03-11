Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 494E44D5DEB
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 09:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240110AbiCKIx2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 03:53:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238186AbiCKIx1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 03:53:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4251A1BAF24
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 00:52:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646988743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/479Pk+vprXDZIn8pdu3Nkd2rq1k38blx/MzMekbdF8=;
        b=YPLrxT0Bt5T3A1FYksS3CfBLGJoAVn0/uLrwq/u2dOHxmh5aRxC+u118HAna6Tqivb6qvj
        tese6q57+6f8OzU0r8q+qTV3DDIZueO/VGspUZF1g+WEy45lp4DOPBOZ3KM0BQAV4b0I4s
        SkIRo+YijWghW5W8YVQ8DCQmdoEtF7U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-68-0SfKBHKbMTqm_PjtgjAZ2Q-1; Fri, 11 Mar 2022 03:52:19 -0500
X-MC-Unique: 0SfKBHKbMTqm_PjtgjAZ2Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 786A5801DDC;
        Fri, 11 Mar 2022 08:52:17 +0000 (UTC)
Received: from localhost (unknown [10.39.194.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7987D7369C;
        Fri, 11 Mar 2022 08:52:06 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        Xu Zaibo <xuzaibo@huawei.com>
Subject: Re: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
In-Reply-To: <20220310134954.0df4bb12.alex.williamson@redhat.com>
Organization: Red Hat GmbH
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
 <20220303230131.2103-9-shameerali.kolothum.thodi@huawei.com>
 <20220304205720.GE219866@nvidia.com>
 <20220307120513.74743f17.alex.williamson@redhat.com>
 <aac9a26dc27140d9a1ce56ebdec393a6@huawei.com>
 <20220307125239.7261c97d.alex.williamson@redhat.com>
 <BN9PR11MB5276EBE887402EBE22630BAB8C099@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220308123312.1f4ba768.alex.williamson@redhat.com>
 <BN9PR11MB527634CCF86829E0680E5E678C0A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220310134954.0df4bb12.alex.williamson@redhat.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Fri, 11 Mar 2022 09:52:05 +0100
Message-ID: <87tuc4hnwq.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 10 2022, Alex Williamson <alex.williamson@redhat.com> wrote:

> Do you think we should go so far as to formalize this via a MAINTAINERS
> entry, for example:
>
> diff --git a/Documentation/vfio/vfio-pci-vendor-driver-acceptance.rst b/Documentation/vfio/vfio-pci-vendor-driver-acceptance.rst
> new file mode 100644
> index 000000000000..54ebafcdd735
> --- /dev/null
> +++ b/Documentation/vfio/vfio-pci-vendor-driver-acceptance.rst
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
> +Sign-off for any interactions with parent drivers.  Additionally,
> +drivers should make an attempt to provide sufficient documentation
> +for reviewers to understand the device specific extensions, for
> +example in the case of migration data, how is the device state
> +composed and consumed, which portions are not otherwise available to
> +the user via vfio-pci, what safeguards exist to validate the data,
> +etc.  To that extent, authors should additionally expect to require
> +reviews from at least one of the listed reviewers, in addition to the
> +overall vfio maintainer.
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4322b5321891..4f7d26f9aac6 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -20314,6 +20314,13 @@ F:	drivers/vfio/mdev/
>  F:	include/linux/mdev.h
>  F:	samples/vfio-mdev/
>  
> +VFIO PCI VENDOR DRIVERS
> +R:	Your Name <your.name@here.com>
> +L:	kvm@vger.kernel.org
> +S:	Maintained
> +P:	Documentation/vfio/vfio-pci-vendor-driver-acceptance.rst
> +F:	drivers/vfio/pci/*/

This works as long as the only subdirectories are for vendor drivers;
should something else come up, we'd need to add an exclude statement, so
no biggie.

> +
>  VFIO PLATFORM DRIVER
>  M:	Eric Auger <eric.auger@redhat.com>
>  L:	kvm@vger.kernel.org
>
> Ideally we'd have at least Yishai, Shameer, Jason, and yourself listed
> as reviewers (Connie and I are included via the higher level entry).
> Thoughts from anyone?  Volunteers for reviewers if we want to press
> forward with this as formal acceptance criteria?  Thanks,
>
> Alex

I like having this formalized. More eyeballs are good (especially as
getting good review is one of the worst bottlenecks), and I'd trust
people having worked on other vendor drivers having a better grip on
issues that have not been my priority.


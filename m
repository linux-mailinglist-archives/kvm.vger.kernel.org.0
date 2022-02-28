Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2F74C7B0E
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 21:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiB1U4V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 15:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiB1U4T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 15:56:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8172828982;
        Mon, 28 Feb 2022 12:55:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09A4D60F6D;
        Mon, 28 Feb 2022 20:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E433C340F1;
        Mon, 28 Feb 2022 20:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646081739;
        bh=YRRAW7NH8ELRkvx1wzAZhDrBKDAX4XvjIQ75sXi51+U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=VYdC0gymIDmS7tsSBW0FrDM7xLmKmxwQNGAqvztcWzuJey2FKGYKZknu7kO7KU6Dk
         odyHxuxLvDBfYiEtB3PjJRfvnkYDVXfe5f4khMP1A4LfPo2zeVq2QrP24LH9RvX8gX
         x/0h5zUE8NfPkYZldbt3WsouWWopnCeZ9w8iV02kVrORQY6J2l3EUQQbo0LJyfaaHm
         RmfQ+V46PQkMlyI0eJX/GcvKmH2y0gsOvk/VkOi21e/52kYfnvpPlSc021sNpSUJts
         4UJJvhGnYczmDcE+B49ubS8u/3GeFDQlynui1gJjU+0q/I40fHRkwubuAC/Og5n4J+
         IISWAQEmvB4aA==
Date:   Mon, 28 Feb 2022 14:55:37 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, jgg@nvidia.com, cohuck@redhat.com,
        mgurtovoy@nvidia.com, yishaih@nvidia.com, linuxarm@huawei.com,
        liulongfang@huawei.com, prime.zeng@hisilicon.com,
        jonathan.cameron@huawei.com, wangzhou1@hisilicon.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org
Subject: Re: [PATCH v6 03/10] hisi_acc_qm: Move PCI device IDs to common
 header
Message-ID: <20220228205537.GA520961@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228132346.77624e5b.alex.williamson@redhat.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 28, 2022 at 01:23:46PM -0700, Alex Williamson wrote:
> On Mon, 28 Feb 2022 14:12:59 -0600
> Bjorn Helgaas <helgaas@kernel.org> wrote:
> 
> > On Mon, Feb 28, 2022 at 10:33:38AM -0700, Alex Williamson wrote:
> > > [Cc+ Bjorn, linux-pci]
> > > 
> > > On Mon, 28 Feb 2022 09:01:14 +0000
> > > Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:
> > >   
> > > > Move the PCI Device IDs of HiSilicon ACC devices to
> > > > a common header and use a uniform naming convention.  
> > 
> > > > --- a/include/linux/pci_ids.h
> > > > +++ b/include/linux/pci_ids.h
> > > > @@ -2529,6 +2529,12 @@
> > > >  #define PCI_DEVICE_ID_KORENIX_JETCARDF3	0x17ff
> > > >  
> > > >  #define PCI_VENDOR_ID_HUAWEI		0x19e5
> > > > +#define PCI_DEVICE_ID_HUAWEI_ZIP_PF	0xa250
> > > > +#define PCI_DEVICE_ID_HUAWEI_ZIP_VF	0xa251
> > > > +#define PCI_DEVICE_ID_HUAWEI_SEC_PF	0xa255
> > > > +#define PCI_DEVICE_ID_HUAWEI_SEC_VF	0xa256
> > > > +#define PCI_DEVICE_ID_HUAWEI_HPRE_PF	0xa258
> > > > +#define PCI_DEVICE_ID_HUAWEI_HPRE_VF	0xa259  
> > 
> > We usually don't add things to pci_ids.h unless they're used in more
> > than one place (see the comment at the top of the file).  AFAICT,
> > these device IDs are only used in one file, so you can leave the
> > #defines in the file that uses them or use bare hex values.
> 
> Later in this series the VF IDs are added to a vendor variant of the
> vfio-pci driver:
> 
> https://lore.kernel.org/all/20220228090121.1903-5-shameerali.kolothum.thodi@huawei.com/
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> new file mode 100644
> index 000000000000..8129c3457b3b
> --- /dev/null
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> ...
> +static const struct pci_device_id hisi_acc_vfio_pci_table[] = {
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_HUAWEI_SEC_VF) },
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_HUAWEI_HPRE_VF) },
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_HUAWEI_ZIP_VF) },
> +	{ }
> +};
> 
> So I think the VFs IDs meet the requirements, but perhaps not the PF
> IDs.  Would it be ok if the PFs were dropped?  Thanks,

Sure :)

Bjorn

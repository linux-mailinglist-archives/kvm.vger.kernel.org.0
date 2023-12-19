Return-Path: <kvm+bounces-4869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 87D1E8191B4
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 21:50:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F081283CDE
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 20:50:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DDCA39AEC;
	Tue, 19 Dec 2023 20:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VdaZlSb0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C3839AC4
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 20:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703018993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DCnkEm8mnZPoFEQqTjO/xpK1FKr76sdrS9KYSSaCjpM=;
	b=VdaZlSb0iHEC0iIvocV2BdwMHAH3MCzZa4RXehpkfcvtgGTvZ6sZKUcMNATUsetPVV2tBH
	GmXz5KuKC8DNs0eNc6q2l3JVCKTDRebmDyJZgZ5XAKs6x7U/f0T0KI7gbQSdsscEqC/hha
	V8v/cR+sNSK+SL9IWCnwGPcW+dkTqgQ=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-202--zIT83tDP7mH8lIljfTHQA-1; Tue, 19 Dec 2023 15:49:50 -0500
X-MC-Unique: -zIT83tDP7mH8lIljfTHQA-1
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3ba3e8f9f00so6164969b6e.3
        for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 12:49:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703018989; x=1703623789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DCnkEm8mnZPoFEQqTjO/xpK1FKr76sdrS9KYSSaCjpM=;
        b=SflpbskzPNa8HyWxv8H+x8/CVle0lL+8KCQGs/oSNI0ePuXT3QDrbQGNg9PGQrNdR5
         faLqLd9C7k1vI97UEdU+qBo+pow5NAMN7jK5eczbeiV4XDM7dtjjFgQzJiy3uMDJIimp
         kff4mBUXc7qcUfwpspicnNlbxjaxn/NCKswFhqeW8Tq2c4WS2MrdHf49bscKnSEr/IBW
         VNUTUTNHyLQX8XAywAy1gGfQM489CrrHCD1WTt5I+Njar8/mJhTyQQ54pDcdud7UcdtL
         B+oXLQ4S+IbFI2NT2hZqOeRjR1HrlRTNjx4drPe1Bdg+xrypxWt+EnTFrTS3Ve73ddVd
         YibQ==
X-Gm-Message-State: AOJu0Yxh7OTuFtv7rryVNjHCr1CFQg2DfJvMMvQZG+PsM+y95cXZejGW
	/8l2doBGIPb/AW7GCl/aoBWLkXYuKyj2X3bJqNB1KLGD4SI0pi0I3Fa/jCYzGjh4MahdkjvmI9j
	3nN8k62qRrByKNZqzyhbj
X-Received: by 2002:a05:6808:1403:b0:3bb:67d5:39c7 with SMTP id w3-20020a056808140300b003bb67d539c7mr1165765oiv.37.1703018988978;
        Tue, 19 Dec 2023 12:49:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE8jBBNekiPqSBRf7ZgrtRf7bRz2tjnIZ0p6DbgAYtlU40zwswvgUi2lWPxVmqdrpczN+312Q==
X-Received: by 2002:a05:6808:1403:b0:3bb:67d5:39c7 with SMTP id w3-20020a056808140300b003bb67d539c7mr1165756oiv.37.1703018988642;
        Tue, 19 Dec 2023 12:49:48 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id 24-20020aca1118000000b003bb69d53697sm128643oir.1.2023.12.19.12.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 12:49:48 -0800 (PST)
Date: Tue, 19 Dec 2023 13:49:45 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Yishai Hadas <yishaih@nvidia.com>, jasowang@redhat.com, jgg@nvidia.com,
 kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
 parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
 joao.m.martins@oracle.com, si-wei.liu@oracle.com, leonro@nvidia.com,
 maorg@nvidia.com
Subject: Re: [PATCH V10 vfio 0/9] Introduce a vfio driver over virtio
 devices
Message-ID: <20231219134945.397aaa26.alex.williamson@redhat.com>
In-Reply-To: <20231219134344-mutt-send-email-mst@kernel.org>
References: <20231219093247.170936-1-yishaih@nvidia.com>
	<20231219101452.10105890.alex.williamson@redhat.com>
	<20231219134344-mutt-send-email-mst@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 19 Dec 2023 13:44:25 -0500
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Tue, Dec 19, 2023 at 10:14:52AM -0700, Alex Williamson wrote:
> > On Tue, 19 Dec 2023 11:32:38 +0200
> > Yishai Hadas <yishaih@nvidia.com> wrote:
> >   
> > > This series introduce a vfio driver over virtio devices to support the
> > > legacy interface functionality for VFs.
> > > 
> > > Background, from the virtio spec [1].
> > > --------------------------------------------------------------------
> > > In some systems, there is a need to support a virtio legacy driver with
> > > a device that does not directly support the legacy interface. In such
> > > scenarios, a group owner device can provide the legacy interface
> > > functionality for the group member devices. The driver of the owner
> > > device can then access the legacy interface of a member device on behalf
> > > of the legacy member device driver.
> > > 
> > > For example, with the SR-IOV group type, group members (VFs) can not
> > > present the legacy interface in an I/O BAR in BAR0 as expected by the
> > > legacy pci driver. If the legacy driver is running inside a virtual
> > > machine, the hypervisor executing the virtual machine can present a
> > > virtual device with an I/O BAR in BAR0. The hypervisor intercepts the
> > > legacy driver accesses to this I/O BAR and forwards them to the group
> > > owner device (PF) using group administration commands.
> > > --------------------------------------------------------------------
> > > 
> > > The first 6 patches are in the virtio area and handle the below:
> > > - Introduce the admin virtqueue infrastcture.
> > > - Expose the layout of the commands that should be used for
> > >   supporting the legacy access.
> > > - Expose APIs to enable upper layers as of vfio, net, etc
> > >   to execute admin commands.
> > > 
> > > The above follows the virtio spec that was lastly accepted in that area
> > > [1].
> > > 
> > > The last 3 patches are in the vfio area and handle the below:
> > > - Expose some APIs from vfio/pci to be used by the vfio/virtio driver.
> > > - Introduce a vfio driver over virtio devices to support the legacy
> > >   interface functionality for VFs. 
> > > 
> > > The series was tested successfully over virtio-net VFs in the host,
> > > while running in the guest both modern and legacy drivers.
> > > 
> > > [1]
> > > https://github.com/oasis-tcs/virtio-spec/commit/03c2d32e5093ca9f2a17797242fbef88efe94b8c
> > > 
> > > Changes from V9: https://lore.kernel.org/kvm/20231218083755.96281-1-yishaih@nvidia.com/
> > > Virtio:
> > > - Introduce a new config option VIRTIO_PCI_ADMIN_LEGACY which considers X86 or
> > >   COMPILE_TEST, then use it instead of CONFIG_X86.
> > > Vfio:
> > > Patch #9:
> > > - Change Kconfig to depend on VIRTIO_PCI_ADMIN_LEGACY.
> > > - Drop a redundant blank line at the end of Makefile.
> > > 
> > > The above changes were suggested by Alex.
> > > 
> > > Changes from V8: https://lore.kernel.org/kvm/20231214123808.76664-1-yishaih@nvidia.com/
> > > Virtio:
> > > - Adapt to support the legacy IO functionality only on X86, as
> > >   was suggested by Michael.
> > > Vfio:
> > > Patch #9:
> > > - Change Kconfig to depend on X86, as suggested by Alex. 
> > > - Add Reviewed-by: Kevin Tian <kevin.tian@intel.com>.
> > > 
> > > Changes from V7: https://lore.kernel.org/kvm/20231207102820.74820-1-yishaih@nvidia.com/
> > > Virtio:
> > > Patch #6
> > > - Let virtio_pci_admin_has_legacy_io() return false on non X86 systems,
> > >   as was discussed with Michael.
> > > Vfio:
> > > Patch #7, #8:
> > > - Add Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > > Patch #9:
> > > - Improve the Kconfig description and the commit log, as was suggested by Kevin.
> > > - Rename translate_io_bar_to_mem_bar() to virtiovf_pci_bar0_rw(), as
> > >   was suggested by Kevin.
> > > - Refactor to have virtiovf_pci_write_config() as we have
> > >   virtiovf_pci_read_config(), as was suggested by Kevin.
> > > - Drop a note about MSIX which doesn't give any real value, as was
> > >   suggested by Kevin.
> > > 
> > > Changes from V6: https://lore.kernel.org/kvm/20231206083857.241946-1-yishaih@nvidia.com/
> > > Vfio:
> > > - Put the pm_runtime stuff into translate_io_bar_to_mem_bar() and
> > >   organize the callers to be more success oriented, as suggested by Jason.
> > > - Add missing 'ops' (i.e. 'detach_ioas' and 'device_feature'), as mentioned by Jason.
> > > - Clean virtiovf_bar0_exists() to cast to bool automatically, as
> > >   suggested by Jason.
> > > - Add Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>.
> > > 
> > > Changes from V5: https://lore.kernel.org/kvm/20231205170623.197877-1-yishaih@nvidia.com/
> > > Vfio:
> > > - Rename vfio_pci_iowrite64 to vfio_pci_core_iowrite64 as was mentioned
> > >   by Alex.
> > > 
> > > Changes from V4: https://lore.kernel.org/all/20231129143746.6153-7-yishaih@nvidia.com/T/
> > > Virtio:
> > > - Drop the unused macro 'VIRTIO_ADMIN_MAX_CMD_OPCODE' as was asked by
> > >   Michael.
> > > - Add Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > > Vfio:
> > > - Export vfio_pci_core_setup_barmap() in place and rename
> > >   vfio_pci_iowrite/read<xxx> to have the 'core' prefix as part of the
> > >   functions names, as was discussed with Alex.
> > > - Improve packing of struct virtiovf_pci_core_device, as was suggested
> > >   by Alex.
> > > - Upon reset, set 'pci_cmd' back to zero, in addition, if
> > >   the user didn't set the 'PCI_COMMAND_IO' bit, return -EIO upon any
> > >   read/write towards the IO bar, as was suggested by Alex.
> > > - Enforce by BUILD_BUG_ON that 'bar0_virtual_buf_size' is power of 2 as
> > >   part of virtiovf_pci_init_device() and clean the 'sizing calculation'
> > >   code accordingly, as was suggested by Alex.
> > > 
> > > Changes from V3: https://www.spinics.net/lists/kvm/msg333008.html
> > > Virtio:
> > > - Rebase on top of 6.7 rc3.
> > > Vfio:
> > > - Fix a typo, drop 'acc' from 'virtiovf_acc_vfio_pci_tran_ops'.
> > > 
> > > Changes from V2: https://lore.kernel.org/all/20231029155952.67686-8-yishaih@nvidia.com/T/
> > > Virtio:
> > > - Rebase on top of 6.7 rc1.
> > > - Add a mutex to serialize admin commands execution and virtqueue
> > >   deletion, as was suggested by Michael.
> > > - Remove the 'ref_count' usage which is not needed any more.
> > > - Reduce the depth of the admin vq to match a single command at a given time.
> > > - Add a supported check upon command execution and move to use a single
> > >   flow of virtqueue_exec_admin_cmd().
> > > - Improve the description of the exported commands to better match the
> > >   specification and the expected usage as was asked by Michael.
> > > 
> > > Vfio:
> > > - Upon calling to virtio_pci_admin_legacy/common_device_io_read/write()
> > >   supply the 'offset' within the relevant configuration area, following
> > >   the virtio exported APIs.
> > > 
> > > Changes from V1: https://lore.kernel.org/all/20231023104548.07b3aa19.alex.williamson@redhat.com/T/
> > > Virtio:
> > > - Drop its first patch, it was accepted upstream already.
> > > - Add a new patch (#6) which initializes the supported admin commands
> > >   upon admin queue activation as was suggested by Michael.
> > > - Split the legacy_io_read/write commands per common/device
> > >   configuration as was asked by Michael.
> > > - Don't expose any more the list query/used APIs outside of virtio.
> > > - Instead, expose an API to check whether the legacy io functionality is
> > >   supported as was suggested by Michael.
> > > - Fix some Krobot's note by adding the missing include file.
> > > 
> > > Vfio:
> > > - Refer specifically to virtio-net as part of the driver/module description
> > >   as Alex asked.
> > > - Change to check MSIX enablement based on the irq type of the given vfio
> > >   core device. In addition, drop its capable checking from the probe flow
> > >   as was asked by Alex.
> > > - Adapt to use the new virtio exposed APIs and clean some code accordingly.
> > > - Adapt to some cleaner style code in some places (if/else) as was suggested
> > >   by Alex.
> > > - Fix the range_intersect_range() function and adapt its usage as was
> > >   pointed by Alex.
> > > - Make struct virtiovf_pci_core_device better packed.
> > > - Overwrite the subsystem vendor ID to be 0x1af4 as was discussed in
> > >   the ML.
> > > - Add support for the 'bar sizing negotiation' as was asked by Alex.
> > > - Drop the 'acc' from the 'ops' as Alex asked.
> > > 
> > > Changes from V0: https://www.spinics.net/lists/linux-virtualization/msg63802.html
> > > 
> > > Virtio:
> > > - Fix the common config map size issue that was reported by Michael
> > >   Tsirkin.
> > > - Do not use vp_dev->vqs[] array upon vp_del_vqs() as was asked by
> > >   Michael, instead skip the AQ specifically.
> > > - Move admin vq implementation into virtio_pci_modern.c as was asked by
> > >   Michael.
> > > - Rename structure virtio_avq to virtio_pci_admin_vq and some extra
> > >   corresponding renames.
> > > - Remove exported symbols virtio_pci_vf_get_pf_dev(),
> > >   virtio_admin_cmd_exec() as now callers are local to the module.
> > > - Handle inflight commands as part of the device reset flow.
> > > - Introduce APIs per admin command in virtio-pci as was asked by Michael.
> > > 
> > > Vfio:
> > > - Change to use EXPORT_SYMBOL_GPL instead of EXPORT_SYMBOL for
> > >   vfio_pci_core_setup_barmap() and vfio_pci_iowrite#xxx() as pointed by
> > >   Alex.
> > > - Drop the intermediate patch which prepares the commands and calls the
> > >   generic virtio admin command API (i.e. virtio_admin_cmd_exec()).
> > > - Instead, call directly to the new APIs per admin command that are
> > >   exported from Virtio - based on Michael's request.
> > > - Enable only virtio-net as part of the pci_device_id table to enforce
> > >   upon binding only what is supported as suggested by Alex.
> > > - Add support for byte-wise access (read/write) over the device config
> > >   region as was asked by Alex.
> > > - Consider whether MSIX is practically enabled/disabled to choose the
> > >   right opcode upon issuing read/write admin command, as mentioned
> > >   by Michael.
> > > - Move to use VIRTIO_PCI_CONFIG_OFF instead of adding some new defines
> > >   as was suggested by Michael.
> > > - Set the '.close_device' op to vfio_pci_core_close_device() as was
> > >   pointed by Alex.
> > > - Adapt to Vfio multi-line comment style in a few places.
> > > - Add virtualization@lists.linux-foundation.org in the MAINTAINERS file
> > >   to be CCed for the new driver as was suggested by Jason.
> > > 
> > > Yishai
> > > 
> > > Feng Liu (4):
> > >   virtio: Define feature bit for administration virtqueue
> > >   virtio-pci: Introduce admin virtqueue
> > >   virtio-pci: Introduce admin command sending function
> > >   virtio-pci: Introduce admin commands
> > > 
> > > Yishai Hadas (5):
> > >   virtio-pci: Initialize the supported admin commands
> > >   virtio-pci: Introduce APIs to execute legacy IO admin commands
> > >   vfio/pci: Expose vfio_pci_core_setup_barmap()
> > >   vfio/pci: Expose vfio_pci_core_iowrite/read##size()
> > >   vfio/virtio: Introduce a vfio driver over virtio devices
> > > 
> > >  MAINTAINERS                                 |   7 +
> > >  drivers/vfio/pci/Kconfig                    |   2 +
> > >  drivers/vfio/pci/Makefile                   |   2 +
> > >  drivers/vfio/pci/vfio_pci_rdwr.c            |  57 +-
> > >  drivers/vfio/pci/virtio/Kconfig             |  15 +
> > >  drivers/vfio/pci/virtio/Makefile            |   3 +
> > >  drivers/vfio/pci/virtio/main.c              | 576 ++++++++++++++++++++
> > >  drivers/virtio/Kconfig                      |   5 +
> > >  drivers/virtio/Makefile                     |   1 +
> > >  drivers/virtio/virtio.c                     |  37 +-
> > >  drivers/virtio/virtio_pci_admin_legacy_io.c | 244 +++++++++
> > >  drivers/virtio/virtio_pci_common.c          |  14 +
> > >  drivers/virtio/virtio_pci_common.h          |  42 +-
> > >  drivers/virtio/virtio_pci_modern.c          | 259 ++++++++-
> > >  drivers/virtio/virtio_pci_modern_dev.c      |  24 +-
> > >  include/linux/vfio_pci_core.h               |  20 +
> > >  include/linux/virtio.h                      |   8 +
> > >  include/linux/virtio_config.h               |   4 +
> > >  include/linux/virtio_pci_admin.h            |  23 +
> > >  include/linux/virtio_pci_modern.h           |   2 +
> > >  include/uapi/linux/virtio_config.h          |   8 +-
> > >  include/uapi/linux/virtio_pci.h             |  68 +++
> > >  22 files changed, 1385 insertions(+), 36 deletions(-)
> > >  create mode 100644 drivers/vfio/pci/virtio/Kconfig
> > >  create mode 100644 drivers/vfio/pci/virtio/Makefile
> > >  create mode 100644 drivers/vfio/pci/virtio/main.c
> > >  create mode 100644 drivers/virtio/virtio_pci_admin_legacy_io.c
> > >  create mode 100644 include/linux/virtio_pci_admin.h
> > >   
> > 
> > The vfio parts look good to me.  I'll merge the last 3 patches in the
> > series through the vfio tree once virtio maintainers are satisfied and
> > provide a branch or tag to merge the dependencies.  Thanks,
> > 
> > Alex  
> 
> You can go ahead and merge the virtio patches too, with my ack:
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> These are self contained enough that I don't expect any conflicts.

Applied to vfio next branch for v6.8.  I pushed the topic branch should
there be a need to merge it back into virtio:

https://github.com/awilliam/linux-vfio/tree/v6.8/vfio/virtio

Thanks,
Alex



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95EC4007F1
	for <lists+kvm@lfdr.de>; Sat,  4 Sep 2021 00:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235560AbhICWhR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 18:37:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39822 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234663AbhICWhQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 18:37:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630708575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rwKa+44bKbHBNC+2rWVzRx9WTUrRxLn2X9ZkWTDNkxg=;
        b=IrTrc9ZvseHDoeTqLxOArlkMD1jmHdoxOgIH2oTgzZRXOUxcE5Mj2SlDV78gheQNZd2pg1
        1mpjHECiYnHuX4rjGKg721pV6BxbCcvOtSppSFjTvwfX8Ytv1fwPqKdqXEqZOAo8qgy63g
        iR8rEsnX5qvVnv5pbeaWEwM0IGoUUOs=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-535-F1Sf44n4N6KzVG4NB6-SZQ-1; Fri, 03 Sep 2021 18:36:14 -0400
X-MC-Unique: F1Sf44n4N6KzVG4NB6-SZQ-1
Received: by mail-oi1-f200.google.com with SMTP id s10-20020a056808008a00b00268c82cc7a0so388168oic.14
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 15:36:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=rwKa+44bKbHBNC+2rWVzRx9WTUrRxLn2X9ZkWTDNkxg=;
        b=i7lRg22I7rWPQHgvoHoVL/hFaPVIW4alxBAvRyhbtlLTCuiynl+pR1+2OgzvMaRY95
         f6x543Xvs0fIsjAGFeQQ6PeV79/OR1Rebn2LosBY39fTIerqrSgnNU/SAQ+l8hwkDtzT
         czN1caQUwWzofBrgYmBzH2PYy1XLgPR9DbkHGDNBHfZVDUCSHPDRWqgLC+8NRE9jN5Gr
         2jQPzsLl3RLvjQZkr76p8Bx5HpgBP1VZmmAI9RKAXYvW/8rpVdhMBSoHJnlUGDb5EShH
         a4VfwOcpeANf2VlnX2kfcT6v0zqZvgAAECxZZo+HkOJUK63bLHZZU7pW9v0VQk9+/nTf
         1Jmw==
X-Gm-Message-State: AOAM532A5CtwPGFOfUdSC0P2gdmuC/Z6L1uvxlg3sAaFVtEYoXbj2/+F
        6/6ibkfUExlv3VV1px1QK4g7OdWTouQH/aAPcmmRTGk+dxt4U66Oh/1GK6wSTuMCwyuXAcde1ac
        rGDuDVgl+ORLa
X-Received: by 2002:a05:6830:4097:: with SMTP id x23mr1153227ott.289.1630708573240;
        Fri, 03 Sep 2021 15:36:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/++UCa4obz2CM+u4lvSbx58T7j9XgltwAvQziKR2fpVTLFa/iicRro4S30cpCWBQN6MaXbg==
X-Received: by 2002:a05:6830:4097:: with SMTP id x23mr1153215ott.289.1630708572972;
        Fri, 03 Sep 2021 15:36:12 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id a4sm148464otv.49.2021.09.03.15.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 15:36:12 -0700 (PDT)
Date:   Fri, 3 Sep 2021 16:36:10 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Colin Xu <colin.xu@intel.com>
Cc:     kvm@vger.kernel.org, zhenyuw@linux.intel.com,
        hang.yuan@linux.intel.com, swee.yee.fonn@intel.com,
        fred.gao@intel.com
Subject: Re: [PATCH v2] vfio/pci: Add OpRegion 2.0 Extended VBT support.
Message-ID: <20210903163610.67b65b05.alex.williamson@redhat.com>
In-Reply-To: <3b6ae9e-c6e9-4f7f-9fec-5a69ed47ae24@outlook.office365.com>
References: <441994e-52e-c1bb-c72d-b6db52b39e3f@outlook.office365.com>
        <20210827023716.105075-1-colin.xu@intel.com>
        <20210830142742.402af95f.alex.williamson@redhat.com>
        <c24b3d2c-3664-ff59-2a1a-8d2282335422@outlook.office365.com>
        <20210902154603.06c1d1e7.alex.williamson@redhat.com>
        <3b6ae9e-c6e9-4f7f-9fec-5a69ed47ae24@outlook.office365.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 3 Sep 2021 10:23:44 +0800 (CST)
Colin Xu <colin.xu@intel.com> wrote:

> On Thu, 2 Sep 2021, Alex Williamson wrote:
> 
> > On Thu, 2 Sep 2021 15:11:11 +0800 (CST)
> > Colin Xu <colin.xu@intel.com> wrote:
> >  
> >> On Mon, 30 Aug 2021, Alex Williamson wrote:
> >>
> >> Thanks Alex for your detailed comments. I replied them inline.
> >>
> >> A general question after these replies is:
> >> which way to handle the readonly OpRegion is preferred?
> >> 1) Shadow (modify the RVDA location and OpRegion version for some
> >> special version, 2.0).
> >> 2) On-the-fly modification for reading.
> >>
> >> The former doesn't need add extra fields to avoid remap on every read, the
> >> latter leaves flexibility for write operation.  
> >
> > I'm in favor of the simplest, most consistent solution.  In retrospect,
> > that probably should have been exposing the VBT as a separate device
> > specific region from the OpRegion and we'd just rely on userspace to do
> > any necessary virtualization before exposing it to a guest.  However,
> > v2.1 support already expanded the region to include the VBT, so we'd
> > have a compatibility problem changing that at this point.
> >
> > Therefore, since we have no plans to enable write support, the simplest
> > solution is probably to shadow all versions.  There's only one instance
> > of this device and firmware tables on the host, so we can probably
> > afford to waste a few pages of memory to simplify.
> >  
> 
> 
> >>> On Fri, 27 Aug 2021 10:37:16 +0800
> >>> Colin Xu <colin.xu@intel.com> wrote:
> >>>  
> >>>> Due to historical reason, some legacy shipped system doesn't follow
> >>>> OpRegion 2.1 spec but still stick to OpRegion 2.0, in which the extended
> >>>> VBT is not contigious after OpRegion in physical address, but any
> >>>> location pointed by RVDA via absolute address. Thus it's impossible
> >>>> to map a contigious range to hold both OpRegion and extended VBT as 2.1.
> >>>>
> >>>> Since the only difference between OpRegion 2.0 and 2.1 is where extended
> >>>> VBT is stored: For 2.0, RVDA is the absolute address of extended VBT
> >>>> while for 2.1, RVDA is the relative address of extended VBT to OpRegion
> >>>> baes, and there is no other difference between OpRegion 2.0 and 2.1,
> >>>> it's feasible to amend OpRegion support for these legacy system (before
> >>>> upgrading the system firmware), by kazlloc a range to shadown OpRegion
> >>>> from the beginning and stitch VBT after closely, patch the shadow
> >>>> OpRegion version from 2.0 to 2.1, and patch the shadow RVDA to relative
> >>>> address. So that from the vfio igd OpRegion r/w ops view, only OpRegion
> >>>> 2.1 is exposed regardless the underneath host OpRegion is 2.0 or 2.1
> >>>> if the extended VBT exists. vfio igd OpRegion r/w ops will return either
> >>>> shadowed data (OpRegion 2.0) or directly from physical address
> >>>> (OpRegion 2.1+) based on host OpRegion version and RVDA/RVDS. The shadow
> >>>> mechanism makes it possible to support legacy systems on the market.
> >>>>
> >>>> V2:
> >>>> Validate RVDA for 2.1+ before increasing total size. (Alex)
> >>>>
> >>>> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> >>>> Cc: Hang Yuan <hang.yuan@linux.intel.com>
> >>>> Cc: Swee Yee Fonn <swee.yee.fonn@intel.com>
> >>>> Cc: Fred Gao <fred.gao@intel.com>
> >>>> Signed-off-by: Colin Xu <colin.xu@intel.com>
> >>>> ---
> >>>>  drivers/vfio/pci/vfio_pci_igd.c | 117 ++++++++++++++++++++------------
> >>>>  1 file changed, 75 insertions(+), 42 deletions(-)
> >>>>
> >>>> diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
> >>>> index 228df565e9bc..9cd44498b378 100644
> >>>> --- a/drivers/vfio/pci/vfio_pci_igd.c
> >>>> +++ b/drivers/vfio/pci/vfio_pci_igd.c
> >>>> @@ -48,7 +48,10 @@ static size_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *buf,
> >>>>  static void vfio_pci_igd_release(struct vfio_pci_device *vdev,
> >>>>  				 struct vfio_pci_region *region)
> >>>>  {
> >>>> -	memunmap(region->data);
> >>>> +	if (is_ioremap_addr(region->data))
> >>>> +		memunmap(region->data);
> >>>> +	else
> >>>> +		kfree(region->data);  
> >>>
> >>>
> >>> Since we don't have write support to the OpRegion, should we always
> >>> allocate a shadow copy to simplify?  Or rather than a shadow copy,
> >>> since we don't support mmap of the region, our read handler could
> >>> virtualize version and rvda on the fly and shift accesses so that the
> >>> VBT appears contiguous.  That might also leave us better positioned for
> >>> handling dynamic changes (ex. does the data change when a monitor is
> >>> plugged/unplugged) and perhaps eventually write support.
> >>>  
> >> Always shadow sounds a more simple solution. On-the-fly offset shifting
> >> may need some extra code:
> >> - A fields to store remapped RVDA, otherwise have to remap on every read.
> >> Should I remap everytime, or add the remapped RVDA in vfio_pci_device.
> >> - Some fields to store extra information, like the old and modified
> >> opregion version. Current it's parsed in init since it's one time run. To
> >> support on-the-fly modification, need save them somewhere instead of parse
> >> on every read.
> >> - Addr shift calculation. Read could called on any start with any size,
> >> will need add some addr shift code.  
> >
> > I think it's a bit easier than made out here.  RVDA is either zero or
> > OPREGION_SIZE when it's virtualized, so the existence of a separate
> > mapping for the VBT is enough to know the value, where I think we'd
> > hold that mapping for the life of the region.  We also don't need to
> > store the version, the transformation is static, If the VBT mapping
> > exists and the read version is 2.0, it's replaced with 2.1, otherwise
> > we leave it alone.  I expect we can also chunk accesses to aligned
> > 1/2/4 byte reads (QEMU is already doing this).  That simplifies both
> > the transition between OpRegion and VBT as well as the field
> > virtualization.
> >  
> emmm version doesn't need to be stored since the host version isn't be 
> changed.

It'd be changed for the guest if we're virtualizing a v2.0 OpRegion
into v2.1 to make RVDA relative, but it's still not strictly necessary
to store the host or virtual version to do that.

> But need a place to store the mapped virtual addr so that can 
> unmap on release. In shadow case, we have the shadow addr, but don't save 
> OpRegion and VBT virtual addr.

Yes, we're using the void* data field of struct vfio_pci_region for
storing the opregion mapping, this could easily point to a structure
containing both the opregion and vbt mappings and size for each.

> > I could almost convince myself that this is viable, but I'd like to see
> > an answer to the question above, is any of the OpRegion or VBT volatile
> > such that we can't rely on a shadow copy exclusively?
> >  
> Most of the fields in OpRegion and VBT are written by BIOS and read only 
> by driver as static information. Some fields are used for communication 
> between BIOS and driver, either written by driver and read by BIOS or 
> vice versa, like driver can notify BIOS that driver is ready to process 
> ACPI video extension calls, or when panel backlight change and BIOS notify 
> driver via ACPI, driver can read PWM duty cycle, etc.
> So strictly speaking, there are some cases that the data is volatile and 
> can't fully rely on the shadow copy. To handle them accurately, all the 
> fields need to be processed according to the actual function the field 
> supports. As you mentioned above, two separate regions for OpRegion 
> and VBT could be better. However currently there is only one region. So 
> the shadow makes it still use single region, but the read ops shouldn't 
> fully rely on the shadow, but need always read host data. That could also 
> make the write ops support in future easier. The read/write ops could 
> parse and filter out some functions that host doesn't want to expose for 
> virtualization.
> This brings a small question: need save the mapped OpRegion and VBT 
> virtual addr so that no need remap every time, and also for unmap on
> release. Which structure is ok to added these saved virtual address?

See above, struct vfio_pci_region.data

> >>>>  }
> >>>>
> >>>>  static const struct vfio_pci_regops vfio_pci_igd_regops = {
> >>>> @@ -59,10 +62,11 @@ static const struct vfio_pci_regops vfio_pci_igd_regops = {
> >>>>  static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
> >>>>  {
> >>>>  	__le32 *dwordp = (__le32 *)(vdev->vconfig + OPREGION_PCI_ADDR);
> >>>> -	u32 addr, size;
> >>>> -	void *base;
> >>>> +	u32 addr, size, rvds = 0;
> >>>> +	void *base, *opregionvbt;  
> >>>
> >>>
> >>> opregionvbt could be scoped within the branch it's used.
> >>>  
> >> Previous revision doesn't move it into the scope. I'll amend in next
> >> version.  
> >>>>  	int ret;
> >>>>  	u16 version;
> >>>> +	u64 rvda = 0;
> >>>>
> >>>>  	ret = pci_read_config_dword(vdev->pdev, OPREGION_PCI_ADDR, &addr);
> >>>>  	if (ret)
> >>>> @@ -89,66 +93,95 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
> >>>>  	size *= 1024; /* In KB */
> >>>>
> >>>>  	/*
> >>>> -	 * Support opregion v2.1+
> >>>> -	 * When VBT data exceeds 6KB size and cannot be within mailbox #4, then
> >>>> -	 * the Extended VBT region next to opregion is used to hold the VBT data.
> >>>> -	 * RVDA (Relative Address of VBT Data from Opregion Base) and RVDS
> >>>> -	 * (Raw VBT Data Size) from opregion structure member are used to hold the
> >>>> -	 * address from region base and size of VBT data. RVDA/RVDS are not
> >>>> -	 * defined before opregion 2.0.
> >>>> +	 * OpRegion and VBT:
> >>>> +	 * When VBT data doesn't exceed 6KB, it's stored in Mailbox #4.
> >>>> +	 * When VBT data exceeds 6KB size, Mailbox #4 is no longer large enough
> >>>> +	 * to hold the VBT data, the Extended VBT region is introduced since
> >>>> +	 * OpRegion 2.0 to hold the VBT data. Since OpRegion 2.0, RVDA/RVDS are
> >>>> +	 * introduced to define the extended VBT data location and size.
> >>>> +	 * OpRegion 2.0: RVDA defines the absolute physical address of the
> >>>> +	 *   extended VBT data, RVDS defines the VBT data size.
> >>>> +	 * OpRegion 2.1 and above: RVDA defines the relative address of the
> >>>> +	 *   extended VBT data to OpRegion base, RVDS defines the VBT data size.
> >>>>  	 *
> >>>> -	 * opregion 2.1+: RVDA is unsigned, relative offset from
> >>>> -	 * opregion base, and should point to the end of opregion.
> >>>> -	 * otherwise, exposing to userspace to allow read access to everything between
> >>>> -	 * the OpRegion and VBT is not safe.
> >>>> -	 * RVDS is defined as size in bytes.
> >>>> -	 *
> >>>> -	 * opregion 2.0: rvda is the physical VBT address.
> >>>> -	 * Since rvda is HPA it cannot be directly used in guest.
> >>>> -	 * And it should not be practically available for end user,so it is not supported.
> >>>> +	 * Due to the RVDA difference in OpRegion VBT (also the only diff between
> >>>> +	 * 2.0 and 2.1), while for OpRegion 2.1 and above it's possible to map
> >>>> +	 * a contigious memory to expose OpRegion and VBT r/w via the vfio
> >>>> +	 * region, for OpRegion 2.0 shadow and amendment mechanism is used to
> >>>> +	 * expose OpRegion and VBT r/w properly. So that from r/w ops view, only
> >>>> +	 * OpRegion 2.1 is exposed regardless underneath Region is 2.0 or 2.1.
> >>>>  	 */
> >>>>  	version = le16_to_cpu(*(__le16 *)(base + OPREGION_VERSION));
> >>>> -	if (version >= 0x0200) {
> >>>> -		u64 rvda;
> >>>> -		u32 rvds;
> >>>>
> >>>> +	if (version >= 0x0200) {
> >>>>  		rvda = le64_to_cpu(*(__le64 *)(base + OPREGION_RVDA));
> >>>>  		rvds = le32_to_cpu(*(__le32 *)(base + OPREGION_RVDS));
> >>>> +
> >>>> +		/* The extended VBT must follows OpRegion for OpRegion 2.1+ */  
> >>>
> >>>
> >>> Why?  If we're going to make our own OpRegion to account for v2.0, why
> >>> should it not apply to the same scenario for >2.0?  
> >> Below check is to validate the correctness for >2.0. Accroding to spec,
> >> RVDA must equal to OpRegion size. If RVDA doesn't follow spec, the
> >> OpRegion and VBT may already corrupted so returns error here.
> >> For 2.0, RVDA is the absolute address, VBT may or may not follow OpRegion
> >> so these is no such check for 2.0.
> >> If you mean "not apply to the same scenario for >2.0" by "only shadow for
> >> 2.0 and return as 2.1, while not using shadow for >2.0", that's because I
> >> expect to keep the old logic as it is and only change the behavior for
> >> 2.0. Both 2.0 and >2.0 can use shadow mechanism.  
> >
> > I was under the impression that the difference in RVDA between 2.0 and
> > 2.1 was simply the absolute versus relative addressing and we made a
> > conscious decisions here to only support implementations where the VBT
> > is contiguous with the OpRegion, but the spec supported that
> > possibility.  Of course I don't have access to the spec to verify, but
> > if my interpretation is correct then the v2.0 support here could easily
> > handle a non-contiguous v2.1+ VBT as well.
> >  
> The team hasn't release the spec to public so I can't paste it here. What 
> it describes RVDA for 2.1+ is typically RVDA will be equal to OpRegion 
> size only when VBT exceeds 6K (if <6K, mailbox 4 is large enough to hold
> VBT then no need to use RVDA). Technically it's correct that even if it's 
> non-contiguous v2.1+ VBT, it still can be handled.
> Current i915 will handle it even if v2.1+ is not contiguous, so I guess 
> probably it's better to deal with it as i915.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/gpu/drm/i915/display/intel_opregion.c?h=v5.13.13#n935

So even a v2.1+ OpRegion where (RVDA > OPREGION_SIZE) should be made
contiguous within this vendor region.  Thanks,

Alex


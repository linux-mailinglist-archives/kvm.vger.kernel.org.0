Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293533FF5C8
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 23:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347515AbhIBVrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 17:47:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27031 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244085AbhIBVrI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Sep 2021 17:47:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630619168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U8NzZZzUxeOPHnZogbv7mCsVmCSNZ4OMlcUHg0tTUJ4=;
        b=iNmBVI5JMsqV3JEd8h13KBYwt+0+HAdX642jz3KYP2TtGORtFfEFv8AvEb1wnsB6murhMF
        gp4U1qPMBhD20BtQGuiFQHlP7FmH9CN0eDhQXNgOGKKErFfwIpk03jaCdTLW48kwr8VqvA
        fMkB0pD3X7j21eASP0pFKkEfFmWIdWA=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-CtAbLVQjPOOKMRhb9KgZgw-1; Thu, 02 Sep 2021 17:46:07 -0400
X-MC-Unique: CtAbLVQjPOOKMRhb9KgZgw-1
Received: by mail-ot1-f69.google.com with SMTP id k18-20020a9d7dd2000000b0051aec75d1abso1868192otn.5
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 14:46:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=U8NzZZzUxeOPHnZogbv7mCsVmCSNZ4OMlcUHg0tTUJ4=;
        b=CgmnR5Ab/cKZem6n82zWaEC45hjA5SFbXhLRLO2uEQG5sQ4NB0Klk2Zy81yQuGpV56
         qNxCxFD2XsgWqizu4WF9ni8Ku/Oo+40Qs2XbNmXCFMDMDQl1bwON13YliQGtI/zop+TD
         nCJ5zn9E6OQmEw2xB/uHNdbZFaP7cv160l9sBRPBMRjZ/4p/AI9wroPB2A73e+eyLzTb
         293KV5KZM4g9k6zTRSm9PEIhWP7pAi0syid/4silo7FKdCtbHL8KDVtlJaZUu6zD2o5k
         72EhEH7US9Odj3rtgcEJiZSHst1MAlL6RtqaC5QbLId1U5E+NQhuc2CDKHmLSkl+p4Sr
         ywvQ==
X-Gm-Message-State: AOAM532teWdX31K/wkO1TsC3/YUI1PU+me/mkCLnRQLuD9RXgeG0Ewy6
        KFYla6kAxisMbnJoxK5mKns0J6akQxlYJhTzglrcJ7miJrOqtKzpQ8gDYGzph0Wc6M+4+ZakozH
        6qaNuSqKlK1OI
X-Received: by 2002:a9d:7dd5:: with SMTP id k21mr319531otn.54.1630619166671;
        Thu, 02 Sep 2021 14:46:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy3+51sK7S/sk6HtPoSssbwn99/gktsJJQId3oGtZ8dGR548zz5ivPI9lX9GEKXgwTmCe1HXQ==
X-Received: by 2002:a9d:7dd5:: with SMTP id k21mr319516otn.54.1630619166406;
        Thu, 02 Sep 2021 14:46:06 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id q17sm583944otc.28.2021.09.02.14.46.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 14:46:05 -0700 (PDT)
Date:   Thu, 2 Sep 2021 15:46:03 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Colin Xu <colin.xu@intel.com>
Cc:     kvm@vger.kernel.org, zhenyuw@linux.intel.com,
        hang.yuan@linux.intel.com, swee.yee.fonn@intel.com,
        fred.gao@intel.com
Subject: Re: [PATCH v2] vfio/pci: Add OpRegion 2.0 Extended VBT support.
Message-ID: <20210902154603.06c1d1e7.alex.williamson@redhat.com>
In-Reply-To: <c24b3d2c-3664-ff59-2a1a-8d2282335422@outlook.office365.com>
References: <441994e-52e-c1bb-c72d-b6db52b39e3f@outlook.office365.com>
        <20210827023716.105075-1-colin.xu@intel.com>
        <20210830142742.402af95f.alex.williamson@redhat.com>
        <c24b3d2c-3664-ff59-2a1a-8d2282335422@outlook.office365.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2 Sep 2021 15:11:11 +0800 (CST)
Colin Xu <colin.xu@intel.com> wrote:

> On Mon, 30 Aug 2021, Alex Williamson wrote:
> 
> Thanks Alex for your detailed comments. I replied them inline.
> 
> A general question after these replies is:
> which way to handle the readonly OpRegion is preferred?
> 1) Shadow (modify the RVDA location and OpRegion version for some 
> special version, 2.0).
> 2) On-the-fly modification for reading.
> 
> The former doesn't need add extra fields to avoid remap on every read, the
> latter leaves flexibility for write operation.

I'm in favor of the simplest, most consistent solution.  In retrospect,
that probably should have been exposing the VBT as a separate device
specific region from the OpRegion and we'd just rely on userspace to do
any necessary virtualization before exposing it to a guest.  However,
v2.1 support already expanded the region to include the VBT, so we'd
have a compatibility problem changing that at this point.

Therefore, since we have no plans to enable write support, the simplest
solution is probably to shadow all versions.  There's only one instance
of this device and firmware tables on the host, so we can probably
afford to waste a few pages of memory to simplify.

> > On Fri, 27 Aug 2021 10:37:16 +0800
> > Colin Xu <colin.xu@intel.com> wrote:
> >  
> >> Due to historical reason, some legacy shipped system doesn't follow
> >> OpRegion 2.1 spec but still stick to OpRegion 2.0, in which the extended
> >> VBT is not contigious after OpRegion in physical address, but any
> >> location pointed by RVDA via absolute address. Thus it's impossible
> >> to map a contigious range to hold both OpRegion and extended VBT as 2.1.
> >>
> >> Since the only difference between OpRegion 2.0 and 2.1 is where extended
> >> VBT is stored: For 2.0, RVDA is the absolute address of extended VBT
> >> while for 2.1, RVDA is the relative address of extended VBT to OpRegion
> >> baes, and there is no other difference between OpRegion 2.0 and 2.1,
> >> it's feasible to amend OpRegion support for these legacy system (before
> >> upgrading the system firmware), by kazlloc a range to shadown OpRegion
> >> from the beginning and stitch VBT after closely, patch the shadow
> >> OpRegion version from 2.0 to 2.1, and patch the shadow RVDA to relative
> >> address. So that from the vfio igd OpRegion r/w ops view, only OpRegion
> >> 2.1 is exposed regardless the underneath host OpRegion is 2.0 or 2.1
> >> if the extended VBT exists. vfio igd OpRegion r/w ops will return either
> >> shadowed data (OpRegion 2.0) or directly from physical address
> >> (OpRegion 2.1+) based on host OpRegion version and RVDA/RVDS. The shadow
> >> mechanism makes it possible to support legacy systems on the market.
> >>
> >> V2:
> >> Validate RVDA for 2.1+ before increasing total size. (Alex)
> >>
> >> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> >> Cc: Hang Yuan <hang.yuan@linux.intel.com>
> >> Cc: Swee Yee Fonn <swee.yee.fonn@intel.com>
> >> Cc: Fred Gao <fred.gao@intel.com>
> >> Signed-off-by: Colin Xu <colin.xu@intel.com>
> >> ---
> >>  drivers/vfio/pci/vfio_pci_igd.c | 117 ++++++++++++++++++++------------
> >>  1 file changed, 75 insertions(+), 42 deletions(-)
> >>
> >> diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
> >> index 228df565e9bc..9cd44498b378 100644
> >> --- a/drivers/vfio/pci/vfio_pci_igd.c
> >> +++ b/drivers/vfio/pci/vfio_pci_igd.c
> >> @@ -48,7 +48,10 @@ static size_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *buf,
> >>  static void vfio_pci_igd_release(struct vfio_pci_device *vdev,
> >>  				 struct vfio_pci_region *region)
> >>  {
> >> -	memunmap(region->data);
> >> +	if (is_ioremap_addr(region->data))
> >> +		memunmap(region->data);
> >> +	else
> >> +		kfree(region->data);  
> >
> >
> > Since we don't have write support to the OpRegion, should we always
> > allocate a shadow copy to simplify?  Or rather than a shadow copy,
> > since we don't support mmap of the region, our read handler could
> > virtualize version and rvda on the fly and shift accesses so that the
> > VBT appears contiguous.  That might also leave us better positioned for
> > handling dynamic changes (ex. does the data change when a monitor is
> > plugged/unplugged) and perhaps eventually write support.
> >  
> Always shadow sounds a more simple solution. On-the-fly offset shifting 
> may need some extra code:
> - A fields to store remapped RVDA, otherwise have to remap on every read.
> Should I remap everytime, or add the remapped RVDA in vfio_pci_device.
> - Some fields to store extra information, like the old and modified 
> opregion version. Current it's parsed in init since it's one time run. To 
> support on-the-fly modification, need save them somewhere instead of parse 
> on every read.
> - Addr shift calculation. Read could called on any start with any size, 
> will need add some addr shift code.

I think it's a bit easier than made out here.  RVDA is either zero or
OPREGION_SIZE when it's virtualized, so the existence of a separate
mapping for the VBT is enough to know the value, where I think we'd
hold that mapping for the life of the region.  We also don't need to
store the version, the transformation is static, If the VBT mapping
exists and the read version is 2.0, it's replaced with 2.1, otherwise
we leave it alone.  I expect we can also chunk accesses to aligned
1/2/4 byte reads (QEMU is already doing this).  That simplifies both
the transition between OpRegion and VBT as well as the field
virtualization.

I could almost convince myself that this is viable, but I'd like to see
an answer to the question above, is any of the OpRegion or VBT volatile
such that we can't rely on a shadow copy exclusively?

> >>  }
> >>
> >>  static const struct vfio_pci_regops vfio_pci_igd_regops = {
> >> @@ -59,10 +62,11 @@ static const struct vfio_pci_regops vfio_pci_igd_regops = {
> >>  static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
> >>  {
> >>  	__le32 *dwordp = (__le32 *)(vdev->vconfig + OPREGION_PCI_ADDR);
> >> -	u32 addr, size;
> >> -	void *base;
> >> +	u32 addr, size, rvds = 0;
> >> +	void *base, *opregionvbt;  
> >
> >
> > opregionvbt could be scoped within the branch it's used.
> >  
> Previous revision doesn't move it into the scope. I'll amend in next 
> version.
> >>  	int ret;
> >>  	u16 version;
> >> +	u64 rvda = 0;
> >>
> >>  	ret = pci_read_config_dword(vdev->pdev, OPREGION_PCI_ADDR, &addr);
> >>  	if (ret)
> >> @@ -89,66 +93,95 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
> >>  	size *= 1024; /* In KB */
> >>
> >>  	/*
> >> -	 * Support opregion v2.1+
> >> -	 * When VBT data exceeds 6KB size and cannot be within mailbox #4, then
> >> -	 * the Extended VBT region next to opregion is used to hold the VBT data.
> >> -	 * RVDA (Relative Address of VBT Data from Opregion Base) and RVDS
> >> -	 * (Raw VBT Data Size) from opregion structure member are used to hold the
> >> -	 * address from region base and size of VBT data. RVDA/RVDS are not
> >> -	 * defined before opregion 2.0.
> >> +	 * OpRegion and VBT:
> >> +	 * When VBT data doesn't exceed 6KB, it's stored in Mailbox #4.
> >> +	 * When VBT data exceeds 6KB size, Mailbox #4 is no longer large enough
> >> +	 * to hold the VBT data, the Extended VBT region is introduced since
> >> +	 * OpRegion 2.0 to hold the VBT data. Since OpRegion 2.0, RVDA/RVDS are
> >> +	 * introduced to define the extended VBT data location and size.
> >> +	 * OpRegion 2.0: RVDA defines the absolute physical address of the
> >> +	 *   extended VBT data, RVDS defines the VBT data size.
> >> +	 * OpRegion 2.1 and above: RVDA defines the relative address of the
> >> +	 *   extended VBT data to OpRegion base, RVDS defines the VBT data size.
> >>  	 *
> >> -	 * opregion 2.1+: RVDA is unsigned, relative offset from
> >> -	 * opregion base, and should point to the end of opregion.
> >> -	 * otherwise, exposing to userspace to allow read access to everything between
> >> -	 * the OpRegion and VBT is not safe.
> >> -	 * RVDS is defined as size in bytes.
> >> -	 *
> >> -	 * opregion 2.0: rvda is the physical VBT address.
> >> -	 * Since rvda is HPA it cannot be directly used in guest.
> >> -	 * And it should not be practically available for end user,so it is not supported.
> >> +	 * Due to the RVDA difference in OpRegion VBT (also the only diff between
> >> +	 * 2.0 and 2.1), while for OpRegion 2.1 and above it's possible to map
> >> +	 * a contigious memory to expose OpRegion and VBT r/w via the vfio
> >> +	 * region, for OpRegion 2.0 shadow and amendment mechanism is used to
> >> +	 * expose OpRegion and VBT r/w properly. So that from r/w ops view, only
> >> +	 * OpRegion 2.1 is exposed regardless underneath Region is 2.0 or 2.1.
> >>  	 */
> >>  	version = le16_to_cpu(*(__le16 *)(base + OPREGION_VERSION));
> >> -	if (version >= 0x0200) {
> >> -		u64 rvda;
> >> -		u32 rvds;
> >>
> >> +	if (version >= 0x0200) {
> >>  		rvda = le64_to_cpu(*(__le64 *)(base + OPREGION_RVDA));
> >>  		rvds = le32_to_cpu(*(__le32 *)(base + OPREGION_RVDS));
> >> +
> >> +		/* The extended VBT must follows OpRegion for OpRegion 2.1+ */  
> >
> >
> > Why?  If we're going to make our own OpRegion to account for v2.0, why
> > should it not apply to the same scenario for >2.0?  
> Below check is to validate the correctness for >2.0. Accroding to spec, 
> RVDA must equal to OpRegion size. If RVDA doesn't follow spec, the 
> OpRegion and VBT may already corrupted so returns error here.
> For 2.0, RVDA is the absolute address, VBT may or may not follow OpRegion 
> so these is no such check for 2.0.
> If you mean "not apply to the same scenario for >2.0" by "only shadow for 
> 2.0 and return as 2.1, while not using shadow for >2.0", that's because I 
> expect to keep the old logic as it is and only change the behavior for 
> 2.0. Both 2.0 and >2.0 can use shadow mechanism.

I was under the impression that the difference in RVDA between 2.0 and
2.1 was simply the absolute versus relative addressing and we made a
conscious decisions here to only support implementations where the VBT
is contiguous with the OpRegion, but the spec supported that
possibility.  Of course I don't have access to the spec to verify, but
if my interpretation is correct then the v2.0 support here could easily
handle a non-contiguous v2.1+ VBT as well.

> >> +		if (rvda != size && version > 0x0200) {
> >> +			memunmap(base);
> >> +			pci_err(vdev->pdev,
> >> +				"Extended VBT does not follow opregion on version 0x%04x\n",
> >> +				version);
> >> +			return -EINVAL;
> >> +		}
> >> +
> >> +		/* The extended VBT is valid only when RVDA/RVDS are non-zero. */
> >>  		if (rvda && rvds) {
> >> -			/* no support for opregion v2.0 with physical VBT address */
> >> -			if (version == 0x0200) {
> >> +			size += rvds;
> >> +		}
> >> +	}
> >> +
> >> +	if (size != OPREGION_SIZE) {  
> >
> >
> > @size can only != OPREGION_SIZE due to the above branch, so the below
> > could all be scoped under the version test, or perhaps to a separate
> > function.  
> I'll move to a separate function, which does the stitch and amendment.
> >
> >  
> >> +		/* Allocate memory for OpRegion and extended VBT for 2.0 */
> >> +		if (rvda && rvds && version == 0x0200) {  
> >
> >
> > We go down this path even if the VBT was contiguous with the OpRegion.
> >  
> Yes for 2.0, if RVDA = (OpRegion addr + size) as absolute address, still 
> remap the two regions separately. Seems like not necessary to check if 
> contiguous and decide remap once or twice. Follow spec to remap is 
> straightforward to understand the difference in RVDA (abs. vs rel.)
> Did I miss some consideration here?

I probably forgot that RVDA needs to be modified regardless.  Thanks,

Alex

> >> +			void *vbt_base;
> >> +
> >> +			vbt_base = memremap(rvda, rvds, MEMREMAP_WB);
> >> +			if (!vbt_base) {
> >>  				memunmap(base);
> >> -				pci_err(vdev->pdev,
> >> -					"IGD assignment does not support opregion v2.0 with an extended VBT region\n");
> >> -				return -EINVAL;
> >> +				return -ENOMEM;
> >>  			}
> >>
> >> -			if (rvda != size) {
> >> +			opregionvbt = kzalloc(size, GFP_KERNEL);
> >> +			if (!opregionvbt) {
> >>  				memunmap(base);
> >> -				pci_err(vdev->pdev,
> >> -					"Extended VBT does not follow opregion on version 0x%04x\n",
> >> -					version);
> >> -				return -EINVAL;
> >> +				memunmap(vbt_base);
> >> +				return -ENOMEM;
> >>  			}
> >>
> >> -			/* region size for opregion v2.0+: opregion and VBT size. */
> >> -			size += rvds;
> >> +			/* Stitch VBT after OpRegion noncontigious */
> >> +			memcpy(opregionvbt, base, OPREGION_SIZE);
> >> +			memcpy(opregionvbt + OPREGION_SIZE, vbt_base, rvds);
> >> +
> >> +			/* Patch OpRegion 2.0 to 2.1 */
> >> +			*(__le16 *)(opregionvbt + OPREGION_VERSION) = 0x0201;  
> >
> >
> > = cpu_to_le16(0x0201);
> >
> >  
> >> +			/* Patch RVDA to relative address after OpRegion */
> >> +			*(__le64 *)(opregionvbt + OPREGION_RVDA) = OPREGION_SIZE;  
> >
> >
> > = cpu_to_le64(OPREGION_SIZE);
> >
> >
> > I think this is what triggered the sparse errors.  Thanks,  
> Thanks I got the sparse errors, will fix this in next version.
> 
> >
> > Alex
> >  
> >> +
> >> +			memunmap(vbt_base);
> >> +			memunmap(base);
> >> +
> >> +			/* Register shadow instead of map as vfio_region */
> >> +			base = opregionvbt;
> >> +		/* Remap OpRegion + extended VBT for 2.1+ */
> >> +		} else {
> >> +			memunmap(base);
> >> +			base = memremap(addr, size, MEMREMAP_WB);
> >> +			if (!base)
> >> +				return -ENOMEM;
> >>  		}
> >>  	}
> >>
> >> -	if (size != OPREGION_SIZE) {
> >> -		memunmap(base);
> >> -		base = memremap(addr, size, MEMREMAP_WB);
> >> -		if (!base)
> >> -			return -ENOMEM;
> >> -	}
> >> -
> >>  	ret = vfio_pci_register_dev_region(vdev,
> >>  		PCI_VENDOR_ID_INTEL | VFIO_REGION_TYPE_PCI_VENDOR_TYPE,
> >>  		VFIO_REGION_SUBTYPE_INTEL_IGD_OPREGION,
> >>  		&vfio_pci_igd_regops, size, VFIO_REGION_INFO_FLAG_READ, base);
> >>  	if (ret) {
> >> -		memunmap(base);
> >> +		if (is_ioremap_addr(base))
> >> +			memunmap(base);
> >> +		else
> >> +			kfree(base);
> >>  		return ret;
> >>  	}
> >>  
> >
> >  
> 
> --
> Best Regards,
> Colin Xu
> 


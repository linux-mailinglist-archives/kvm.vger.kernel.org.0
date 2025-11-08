Return-Path: <kvm+bounces-62410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD680C434F8
	for <lists+kvm@lfdr.de>; Sat, 08 Nov 2025 22:37:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB5313AE9A6
	for <lists+kvm@lfdr.de>; Sat,  8 Nov 2025 21:37:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF4C7286413;
	Sat,  8 Nov 2025 21:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="lAP2oxQe";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="mWxUOEOt"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD842556E;
	Sat,  8 Nov 2025 21:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762637836; cv=none; b=k5j+vic78Y7JrbyBBK7wB89A5VzIHM0nhPZwFtMx9I9JcZg/ZAma9laOeNHb5ktDsf9qi6WN/bouZDw/ZXNt2JWZ/LFLefOsVKCHjk5X2d9/JZsPI5/CP8egTDSnfnSlIe49+qZPhAzGWJXOm73hzxaNSc6Wf97Ka7eQLtuyeHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762637836; c=relaxed/simple;
	bh=tqRXJEE6t0G/CkZOZKgSO/5cqL3qn1wQsFqLb2HciZk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qr4rTqPFqy5m7OJR9theFwkCv9cM++qOhsWd8fs1B5PaRMJ6kkFt+KtS2z/uo2zdJsnSm843vfvVM3adSpFTPfwEw8nJlFlhShRDHPVY76XWg1LJWjhcEwwdTO6zITd7f5NdYFWtYaHDxGKk5kX01zIpl8xCnS19k3NwK68VIH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=lAP2oxQe; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=mWxUOEOt; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 222D11D0013D;
	Sat,  8 Nov 2025 16:37:13 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Sat, 08 Nov 2025 16:37:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762637832;
	 x=1762724232; bh=R2o8dRgLBu6k5ntCRvLmVSXDys99jeWl6z7XGHj9RW4=; b=
	lAP2oxQeNiHKRliIm1PcHfwLBDgv991Wm5AooHXTjLKN38MIDzmaIdTEs3+7hJHB
	deMPH/xfMKVDAfJ40FdUPx2EHpga2VQBkKwThj5Tem4yF5PXz9TvVgJVS89lF6e4
	RiN+qS+HBkipJ+2G4q64Ly6He58vw+nZHXCMKTFI+jDNaSIYkt2BhzSLbmfSbx/3
	65wd1NOzWmfiWgfOkRnINGdhB4G4hMpHiRiOSD6LUeoA1duNPJFtZv9BYay9NU0Z
	3xLqLok730nf5opeg9LtKRIAJ6ytbuxowcb8SkSvOT400/ufHaSuloEBGHiOP9hQ
	z3DceOUbRfUd2E6Iw/m5Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762637832; x=
	1762724232; bh=R2o8dRgLBu6k5ntCRvLmVSXDys99jeWl6z7XGHj9RW4=; b=m
	WxUOEOtZ/x5a/JeOaOTU8goZcuCEgXqEgPZO/8dSXu7VeolmPh/f1762YI+BFPJD
	0UbZQvuCDjOQa9HrVV3ExZz2YVLA6szC7Nv84hTg4H+HdN7BQgF6vxatKCcJOIpe
	2YzOn65faeUkjV3xVSMgUpsnIxYQcdtabsSD3DhBbgaJIvjm5m67gCMGlBjlSYmD
	i4F6ePdJ8EO6vSAX8OKYVkX+u1cGXB52cNJ3S7XkqKJ52NIEp5732D1I7AMdTQ6p
	lcYfqd9WlrJB9NqYMq1em3+DG9ae2wc8u3YtBUsF4msy99s5qbXgGi/H7+uKJR10
	okosFptTL8M42B5jhiHpg==
X-ME-Sender: <xms:CLgPaYvH-tS2HvtA52PPJbVpmJPwG1OcKiu42GRg0eLUT-A7Q1CNGA>
    <xme:CLgPaexHH2ADw_xmN4yICl2TYm7i0VdWM2e5SgisaD8aGOCiWogXSgpq7nDTHtC4n
    iTTUFsnPgmZO19oM_I5VwTnNJvjwLqdRIE9s8C-w2PsjUZsXbK36A>
X-ME-Received: <xmr:CLgPabB29WNLeB7klUeaLXPjl9KSDLf76f8kuFPITUZG7PnreHwRYgaB>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduleefieegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhephedvtdeuveejudffjeefudfhueefjedvtefgffdtieeiudfhjeejhffhfeeu
    vedunecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgvgiesshhhrgiisghothdrohhrghdp
    nhgspghrtghpthhtohepiedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghmrg
    hsthhrohesfhgsrdgtohhmpdhrtghpthhtohepughmrghtlhgrtghksehgohhoghhlvgdr
    tghomhdprhgtphhtthhopegrlhgvgidrfihilhhlihgrmhhsohhnsehrvgguhhgrthdrtg
    homhdprhgtphhtthhopehjghhgseiiihgvphgvrdgtrgdprhgtphhtthhopehkvhhmsehv
    ghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlse
    hvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:CLgPacfHlbEkngtk9NsOIKFhcTSrPkwSFV_lo1gZ0YssB3kuIWU8kA>
    <xmx:CLgPaVlQv_l4_Gok10C4sMrpsARXSfq6OEzxkdwnAoaAB89TFOiFnQ>
    <xmx:CLgPaTEwf3cynC29zfuAd8_8ZqtlSRsfD2cET29rcuPkig6MVFrKJw>
    <xmx:CLgPad5m4_wLtku7Hw4VIUGn-5jsI9NS_OPWLtt1fF9Zu0bzleqY5w>
    <xmx:CLgPad_SCKnCcGQcFP9cUDEoovz4NiOMqyE2prgDCqMhZNwe4_fs2eng>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 8 Nov 2025 16:37:11 -0500 (EST)
Date: Sat, 8 Nov 2025 14:37:10 -0700
From: Alex Williamson <alex@shazbot.org>
To: Alex Mastro <amastro@fb.com>
Cc: David Matlack <dmatlack@google.com>, Alex Williamson
 <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio: selftests: Skip vfio_dma_map_limit_test if
 mapping returns -EINVAL
Message-ID: <20251108143710.318702ec.alex@shazbot.org>
In-Reply-To: <aQ+l5IRtFaE24v0g@devgpu015.cco6.facebook.com>
References: <20251107222058.2009244-1-dmatlack@google.com>
	<aQ6MFM1NX8WsDIdX@devgpu015.cco6.facebook.com>
	<aQ+l5IRtFaE24v0g@devgpu015.cco6.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 8 Nov 2025 12:19:48 -0800
Alex Mastro <amastro@fb.com> wrote:

> On Fri, Nov 07, 2025 at 04:17:24PM -0800, Alex Mastro wrote:
> > On Fri, Nov 07, 2025 at 10:20:58PM +0000, David Matlack wrote:  
> > > Skip vfio_dma_map_limit_test.{unmap_range,unmap_all} (instead of
> > > failing) on systems that do not support mapping in the page-sized region
> > > at the top of the u64 address space. Use -EINVAL as the signal for
> > > detecting systems with this limitation, as that is what both VFIO Type1
> > > and iommufd return.
> > > 
> > > A more robust solution that could be considered in the future would be
> > > to explicitly check the range of supported IOVA regions and key off
> > > that, instead of inferring from -EINVAL.
> > > 
> > > Fixes: de8d1f2fd5a5 ("vfio: selftests: add end of address space DMA map/unmap tests")
> > > Signed-off-by: David Matlack <dmatlack@google.com>  
> > 
> > Makes sense -- thanks David. Agree about keying this off
> > VFIO_IOMMU_TYPE1_INFO_CAP_IOVA_RANGE longer term.
> > 
> > Reviewed-by: Alex Mastro <amastro@fb.com>  
> 
> Here's my attempt at adding some machinery to query iova ranges, with
> normalization to iommufd's struct. I kept the vfio capability chain stuff
> relatively generic so we can use it for other things in the future if needed.

Seems we were both hacking on this, I hadn't seen you posted this
before sending:

https://lore.kernel.org/kvm/20251108212954.26477-1-alex@shazbot.org/T/#u

Maybe we can combine the best merits of each.  Thanks,

Alex

> I can sequence this after your fix?
> 
> diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools/testing/selftests/vfio/lib/include/vfio_util.h
> index 240409bf5f8a..fb5efec52316 100644
> --- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
> +++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
> @@ -4,9 +4,12 @@
>  
>  #include <fcntl.h>
>  #include <string.h>
> -#include <linux/vfio.h>
> +
> +#include <uapi/linux/types.h>
> +#include <linux/iommufd.h>
>  #include <linux/list.h>
>  #include <linux/pci_regs.h>
> +#include <linux/vfio.h>
>  
>  #include "../../../kselftest.h"
>  
> @@ -206,6 +209,9 @@ struct vfio_pci_device *vfio_pci_device_init(const char *bdf, const char *iommu_
>  void vfio_pci_device_cleanup(struct vfio_pci_device *device);
>  void vfio_pci_device_reset(struct vfio_pci_device *device);
>  
> +struct iommu_iova_range *vfio_pci_iova_ranges(struct vfio_pci_device *device,
> +					      size_t *nranges);
> +
>  int __vfio_pci_dma_map(struct vfio_pci_device *device,
>  		       struct vfio_dma_region *region);
>  int __vfio_pci_dma_unmap(struct vfio_pci_device *device,
> diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
> index a381fd253aa7..3297a41fdc31 100644
> --- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
> +++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
> @@ -29,6 +29,145 @@
>  	VFIO_ASSERT_EQ(__ret, 0, "ioctl(%s, %s, %s) returned %d\n", #_fd, #_op, #_arg, __ret); \
>  } while (0)
>  
> +static struct vfio_info_cap_header *next_cap_hdr(void *buf, size_t bufsz,
> +						 size_t *cap_offset)
> +{
> +	struct vfio_info_cap_header *hdr;
> +
> +	if (!*cap_offset)
> +		return NULL;
> +
> +	/* Cap offset must be in bounds */
> +	VFIO_ASSERT_LT(*cap_offset, bufsz);
> +	/* There must be enough remaining space to contain the header */
> +	VFIO_ASSERT_GE(bufsz - *cap_offset, sizeof(*hdr));
> +	hdr = (struct vfio_info_cap_header *)((u8 *)buf + *cap_offset);
> +	/* If there is a next, offset must monotonically increase */
> +	if (hdr->next)
> +		VFIO_ASSERT_GT(hdr->next, *cap_offset);
> +	*cap_offset = hdr->next;
> +
> +	return hdr;
> +}
> +
> +static struct vfio_info_cap_header *vfio_iommu_info_cap_hdr(struct vfio_iommu_type1_info *buf,
> +							    u16 cap_id)
> +{
> +	struct vfio_info_cap_header *hdr;
> +	size_t cap_offset = buf->cap_offset;
> +
> +	if (!(buf->flags & VFIO_IOMMU_INFO_CAPS))
> +		return NULL;
> +
> +	if (cap_offset)
> +		VFIO_ASSERT_GE(cap_offset, sizeof(struct vfio_iommu_type1_info));
> +
> +	while ((hdr = next_cap_hdr(buf, buf->argsz, &cap_offset))) {
> +		if (hdr->id == cap_id)
> +			return hdr;
> +	}
> +
> +	return NULL;
> +}
> +
> +/* Return buffer including capability chain, if present. Free with free() */
> +static struct vfio_iommu_type1_info *vfio_iommu_info_buf(struct vfio_pci_device *device)
> +{
> +	struct vfio_iommu_type1_info *buf;
> +
> +	buf = malloc(sizeof(*buf));
> +	VFIO_ASSERT_NOT_NULL(buf);
> +
> +	*buf = (struct vfio_iommu_type1_info) {
> +		.argsz = sizeof(*buf),
> +	};
> +
> +	ioctl_assert(device->container_fd, VFIO_IOMMU_GET_INFO, buf);
> +
> +	buf = realloc(buf, buf->argsz);
> +	VFIO_ASSERT_NOT_NULL(buf);
> +
> +	ioctl_assert(device->container_fd, VFIO_IOMMU_GET_INFO, buf);
> +
> +	return buf;
> +}
> +
> +/*
> + * Normalize vfio_iommu_type1 to report iommufd's iommu_iova_range. Free with
> + * free().
> + */
> +static struct iommu_iova_range *vfio_iommu_iova_ranges(struct vfio_pci_device *device,
> +						       size_t *nranges)
> +{
> +	struct vfio_iommu_type1_info_cap_iova_range *cap_range;
> +	struct vfio_iommu_type1_info *buf;
> +	struct vfio_info_cap_header *hdr;
> +	struct iommu_iova_range *ranges = NULL;
> +
> +	buf = vfio_iommu_info_buf(device);
> +	VFIO_ASSERT_NOT_NULL(buf);
> +
> +	hdr = vfio_iommu_info_cap_hdr(buf, VFIO_IOMMU_TYPE1_INFO_CAP_IOVA_RANGE);
> +	if (!hdr)
> +		goto free_buf;
> +
> +	cap_range = container_of(hdr, struct vfio_iommu_type1_info_cap_iova_range, header);
> +	if (!cap_range->nr_iovas)
> +		goto free_buf;
> +
> +	ranges = malloc(cap_range->nr_iovas * sizeof(*ranges));
> +	VFIO_ASSERT_NOT_NULL(ranges);
> +
> +	for (u32 i = 0; i < cap_range->nr_iovas; i++) {
> +		ranges[i] = (struct iommu_iova_range){
> +			.start = cap_range->iova_ranges[i].start,
> +			.last = cap_range->iova_ranges[i].end,
> +		};
> +	}
> +
> +	*nranges = cap_range->nr_iovas;
> +
> +free_buf:
> +	free(buf);
> +	return ranges;
> +}
> +
> +struct iommu_iova_range *iommufd_iova_ranges(struct vfio_pci_device *device,
> +					     size_t *nranges)
> +{
> +	struct iommu_iova_range *ranges;
> +	int ret;
> +
> +	struct iommu_ioas_iova_ranges query = {
> +		.size = sizeof(query),
> +		.ioas_id = device->ioas_id,
> +	};
> +
> +	ret = ioctl(device->iommufd, IOMMU_IOAS_IOVA_RANGES, &query);
> +	VFIO_ASSERT_EQ(ret, -1);
> +	VFIO_ASSERT_EQ(errno, EMSGSIZE);
> +	VFIO_ASSERT_GT(query.num_iovas, 0);
> +
> +	ranges = malloc(query.num_iovas * sizeof(*ranges));
> +	VFIO_ASSERT_NOT_NULL(ranges);
> +
> +	query.allowed_iovas = (uintptr_t)ranges;
> +
> +	ioctl_assert(device->iommufd, IOMMU_IOAS_IOVA_RANGES, &query);
> +	*nranges = query.num_iovas;
> +
> +	return ranges;
> +}
> +
> +struct iommu_iova_range *vfio_pci_iova_ranges(struct vfio_pci_device *device,
> +					      size_t *nranges)
> +{
> +	if (device->iommufd)
> +		return iommufd_iova_ranges(device, nranges);
> +
> +	return vfio_iommu_iova_ranges(device, nranges);
> +}
> +
>  iova_t __to_iova(struct vfio_pci_device *device, void *vaddr)
>  {
>  	struct vfio_dma_region *region;
> diff --git a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
> index 4f1ea79a200c..78983c4c293b 100644
> --- a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
> +++ b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
> @@ -3,6 +3,8 @@
>  #include <sys/mman.h>
>  #include <unistd.h>
>  
> +#include <uapi/linux/types.h>
> +#include <linux/iommufd.h>
>  #include <linux/limits.h>
>  #include <linux/mman.h>
>  #include <linux/sizes.h>
> @@ -243,12 +245,31 @@ FIXTURE_TEARDOWN(vfio_dma_map_limit_test)
>  	ASSERT_EQ(munmap(self->region.vaddr, self->mmap_size), 0);
>  }
>  
> +static iova_t last_legal_iova(struct vfio_pci_device *device)
> +{
> +	struct iommu_iova_range *ranges;
> +	size_t nranges;
> +	iova_t ret;
> +
> +	ranges = vfio_pci_iova_ranges(device, &nranges);
> +	VFIO_ASSERT_NOT_NULL(ranges);
> +
> +	ret = ranges[nranges - 1].last;
> +	free(ranges);
> +
> +	return ret;
> +}
> +
>  TEST_F(vfio_dma_map_limit_test, unmap_range)
>  {
> +	iova_t last_iova = last_legal_iova(self->device);
>  	struct vfio_dma_region *region = &self->region;
>  	u64 unmapped;
>  	int rc;
>  
> +	if (last_iova != ~(iova_t)0)
> +		SKIP(return, "last legal iova=0x%lx\n", last_iova);
> +
>  	vfio_pci_dma_map(self->device, region);
>  	ASSERT_EQ(region->iova, to_iova(self->device, region->vaddr));
>  
> @@ -259,10 +280,14 @@ TEST_F(vfio_dma_map_limit_test, unmap_range)
>  
>  TEST_F(vfio_dma_map_limit_test, unmap_all)
>  {
> +	iova_t last_iova = last_legal_iova(self->device);
>  	struct vfio_dma_region *region = &self->region;
>  	u64 unmapped;
>  	int rc;
>  
> +	if (last_iova != ~(iova_t)0)
> +		SKIP(return, "last legal iova=0x%lx\n", last_iova);
> +
>  	vfio_pci_dma_map(self->device, region);
>  	ASSERT_EQ(region->iova, to_iova(self->device, region->vaddr));
>  
> 



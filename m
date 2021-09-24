Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BBE417CFA
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 23:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347392AbhIXVZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 17:25:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31534 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347389AbhIXVZm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 17:25:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632518648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D2P6cceoNnKPikciwDNgGPZeGhDKaWsAlVV8sCNRAu4=;
        b=bYbQUhoD03IrHYROfEG2iTaYddPd4UnHlgnsLi30L8RkbYwuMtfR4zO0bplPhrvVeKBpQh
        4sS9Z4rkQIRvczSy4FlyYzOI3zHwYcmyH91CevMrJVXQ26yMMKc4lImg5sa+aweoKgosTV
        VWGEud6c2wvg9OR9W3xFX+LEtAlSJdw=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-mQ4Vmj9tM2uq3GrQ3hJLJQ-1; Fri, 24 Sep 2021 17:24:07 -0400
X-MC-Unique: mQ4Vmj9tM2uq3GrQ3hJLJQ-1
Received: by mail-oo1-f71.google.com with SMTP id f2-20020a4a2202000000b0028c8a8074deso9182918ooa.20
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 14:24:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D2P6cceoNnKPikciwDNgGPZeGhDKaWsAlVV8sCNRAu4=;
        b=1KGZa2MWqgMW4ZtG25Pml797gaSvb7NlbpsNZde/AYQU+4PvX6bIL8QDmwJ+Ga3+Tp
         a+t4nfeosCmz4D+E1MGaU2x0M7YEnEN0lbU9Zjn+4DZDx6iRDoDePXADFMorut4WMr69
         lm6HlTHfO57g0H869tvN6s9MlqixmHNxvZ8o65ZieKVPpVxXG2x6fzOX6I87Mx9pJx8s
         /CP4XdXdAqUevZqiSTAaRFERZ7cLsjwnxIlHC2E41BN7pc/llIjhImwHtsiViRhbE5d9
         abrmhHYNVwNRyWoV9ccn6I/Sp2EqbAxp+i4QJ6N1d+WhzwpkzAaJYFnVB1izyU891PKT
         9k9A==
X-Gm-Message-State: AOAM5335PewKNXiYuH80QxrkIU45YKV/sTRSfa4nDMIPgslHMtIIA+TH
        CIXWP+EMu4Ge6ZNVFCCiGLFBZW9n5h3djBOmdmN4CkmKJHLACxdbYKmVzvUhaHzJSUIsEh/RSEs
        ViWGpzETSljFw
X-Received: by 2002:a05:6830:2693:: with SMTP id l19mr6063654otu.49.1632518646229;
        Fri, 24 Sep 2021 14:24:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxtchWxCuyqKBJNeSPcoQjV5ZlQIp+fuwBS175k89Zcumln7uGvijpPeoMRInI+5modnNyDoA==
X-Received: by 2002:a05:6830:2693:: with SMTP id l19mr6063642otu.49.1632518646004;
        Fri, 24 Sep 2021 14:24:06 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id w23sm2468454ooj.19.2021.09.24.14.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 14:24:05 -0700 (PDT)
Date:   Fri, 24 Sep 2021 15:24:04 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Colin Xu <colin.xu@intel.com>
Cc:     kvm@vger.kernel.org, zhenyuw@linux.intel.com,
        hang.yuan@linux.intel.com, swee.yee.fonn@intel.com,
        fred.gao@intel.com
Subject: Re: [PATCH v6] vfio/pci: Add OpRegion 2.0+ Extended VBT support.
Message-ID: <20210924152404.6f16ac8d.alex.williamson@redhat.com>
In-Reply-To: <20210914091155.109515-1-colin.xu@intel.com>
References: <20210914042929.94501-1-colin.xu@intel.com>
        <20210914091155.109515-1-colin.xu@intel.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Sep 2021 17:11:55 +0800
Colin Xu <colin.xu@intel.com> wrote:

> Due to historical reason, some legacy shipped system doesn't follow
> OpRegion 2.1 spec but still stick to OpRegion 2.0, in which the extended
> VBT is not contiguous after OpRegion in physical address, but any
> location pointed by RVDA via absolute address. Also although current
> OpRegion 2.1+ systems appears that the extended VBT follows OpRegion,
> RVDA is the relative address to OpRegion head, the extended VBT location
> may change to non-contiguous to OpRegion. In both cases, it's impossible
> to map a contiguous range to hold both OpRegion and the extended VBT and
> expose via one vfio region.
> 
> The only difference between OpRegion 2.0 and 2.1 is where extended
> VBT is stored: For 2.0, RVDA is the absolute address of extended VBT
> while for 2.1, RVDA is the relative address of extended VBT to OpRegion
> baes, and there is no other difference between OpRegion 2.0 and 2.1.
> To support the non-contiguous region case as described, the updated read
> op will patch OpRegion version and RVDA on-the-fly accordingly. So that
> from vfio igd OpRegion view, only 2.1+ with contiguous extended VBT
> after OpRegion is exposed, regardless the underneath host OpRegion is
> 2.0 or 2.1+. The mechanism makes it possible to support legacy OpRegion
> 2.0 extended VBT systems with on the market, and support OpRegion 2.1+
> where the extended VBT isn't contiguous after OpRegion.
> 
> V2:
> Validate RVDA for 2.1+ before increasing total size. (Alex)
> 
> V3: (Alex)
> Split read and write ops.
> On-the-fly modify OpRegion version and RVDA.
> Fix sparse error on assign value to casted pointer.
> 
> V4: (Alex)
> No need support write op.
> Direct copy to user buffer with several shift instead of shadow.
> Copy helper to copy to user buffer and shift offset.
> 
> V5: (Alex)
> Simplify copy help to only cover common shift case.
> Don't cache patched version and rvda. Patch on copy if necessary.
> 
> V6:
> Fix comment typo and max line width.
> 
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Cc: Hang Yuan <hang.yuan@linux.intel.com>
> Cc: Swee Yee Fonn <swee.yee.fonn@intel.com>
> Cc: Fred Gao <fred.gao@intel.com>
> Signed-off-by: Colin Xu <colin.xu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_igd.c | 231 ++++++++++++++++++++++++--------
>  1 file changed, 173 insertions(+), 58 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
> index 228df565e9bc..081be59c7948 100644
> --- a/drivers/vfio/pci/vfio_pci_igd.c
> +++ b/drivers/vfio/pci/vfio_pci_igd.c
> @@ -25,19 +25,119 @@
>  #define OPREGION_RVDS		0x3c2
>  #define OPREGION_VERSION	0x16
>  
> +struct igd_opregion_vbt {
> +	void *opregion;
> +	void *vbt_ex;
> +};
> +
> +/**
> + * igd_opregion_shift_copy() - Copy OpRegion to user buffer and shift position.
> + * @dst: User buffer ptr to copy to.
> + * @off: Offset to user buffer ptr. Increased by bytes on return.
> + * @src: Source buffer to copy from.
> + * @pos: Increased by bytes on return.
> + * @remaining: Decreased by bytes on return.
> + * @bytes: Bytes to copy and adjust off, pos and remaining.
> + *
> + * Copy OpRegion to offset from specific source ptr and shift the offset.
> + *
> + * Return: 0 on success, -EFAULT otherwise.
> + *
> + */
> +static inline unsigned long igd_opregion_shift_copy(char __user *dst,
> +						    loff_t *off,
> +						    void *src,
> +						    loff_t *pos,
> +						    loff_t *remaining,
> +						    loff_t bytes)

@bytes and @remaining should be size_t throughout.

> +{
> +	if (copy_to_user(dst + (*off), src, bytes))
> +		return -EFAULT;
> +
> +	*off += bytes;
> +	*pos += bytes;
> +	*remaining -= bytes;
> +
> +	return 0;
> +}
> +
>  static size_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *buf,
>  			      size_t count, loff_t *ppos, bool iswrite)
>  {
>  	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
> -	void *base = vdev->region[i].data;
> -	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +	struct igd_opregion_vbt *opregionvbt = vdev->region[i].data;
> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK, off = 0, remaining;
>  
>  	if (pos >= vdev->region[i].size || iswrite)
>  		return -EINVAL;
>  
>  	count = min(count, (size_t)(vdev->region[i].size - pos));
> +	remaining = count;
> +
> +	/* Copy until OpRegion version */
> +	if (remaining && pos < OPREGION_VERSION) {
> +		loff_t bytes = min(remaining, OPREGION_VERSION - pos);
> +
> +		if (igd_opregion_shift_copy(buf, &off,
> +					    opregionvbt->opregion + pos, &pos,
> +					    &remaining, bytes))
> +			return -EFAULT;
> +	}
> +
> +	/* Copy patched (if necessary) OpRegion version */
> +	if (remaining && pos < OPREGION_VERSION + sizeof(__le16)) {
> +		loff_t bytes = min(remaining,
> +				   OPREGION_VERSION + (loff_t)sizeof(__le16) -
> +				   pos);
> +		__le16 version = *(__le16 *)(opregionvbt->opregion +
> +					     OPREGION_VERSION);
> +
> +		/* Patch to 2.1 if OpRegion 2.0 has extended VBT */
> +		if (le16_to_cpu(version) == 0x0200 && opregionvbt->vbt_ex)
> +			version = cpu_to_le16(0x0201);
> +
> +		if (igd_opregion_shift_copy(buf, &off,
> +					    &version, &pos,
> +					    &remaining, bytes))

This looks wrong, what if pos was (OPREGION_VERSION + 1)?  We'd copy
the first byte instead of the second.  We need to add (pos -
OPREGION_VERSION) to the source.


> +			return -EFAULT;
> +	}
> +
> +	/* Copy until RVDA */
> +	if (remaining && pos < OPREGION_RVDA) {
> +		loff_t bytes = min((loff_t)remaining, OPREGION_RVDA - pos);
> +
> +		if (igd_opregion_shift_copy(buf, &off,
> +					    opregionvbt->opregion + pos, &pos,
> +					    &remaining, bytes))
> +			return -EFAULT;
> +	}
> +
> +	/* Copy modified (if necessary) RVDA */
> +	if (remaining && pos < OPREGION_RVDA + sizeof(__le64)) {
> +		loff_t bytes = min(remaining, OPREGION_RVDA +
> +					      (loff_t)sizeof(__le64) - pos);
> +		__le64 rvda = cpu_to_le64(opregionvbt->vbt_ex ?
> +					  OPREGION_SIZE : 0);
> +
> +		if (igd_opregion_shift_copy(buf, &off,
> +					    &rvda, &pos,
> +					    &remaining, bytes))

Same here, + (pos - OPREGION_RVDA)

> +			return -EFAULT;
> +	}
>  
> -	if (copy_to_user(buf, base + pos, count))
> +	/* Copy the rest of OpRegion */
> +	if (remaining && pos < OPREGION_SIZE) {
> +		loff_t bytes = min(remaining, OPREGION_SIZE - pos);
> +
> +		if (igd_opregion_shift_copy(buf, &off,
> +					    opregionvbt->opregion + pos, &pos,
> +					    &remaining, bytes))
> +			return -EFAULT;
> +	}
> +
> +	/* Copy extended VBT if exists */
> +	if (remaining &&
> +	    copy_to_user(buf + off, opregionvbt->vbt_ex, remaining))

And here, + (pos - OPREGION_SIZE)

Also this doesn't apply to mainline, please rebase to linux-next or at
least the latest rc kernel.  Thanks,

Alex


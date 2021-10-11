Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1E242991B
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 23:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235343AbhJKVrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 17:47:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34205 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231186AbhJKVrE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Oct 2021 17:47:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633988703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aE7fZ7rnu+RZO7buiKp9cNjPMZyO6dLzADEyPj5dQa8=;
        b=VAJo30y+jVTQQbrEHzPT5VdXbt+XG2xDDHvnF/bdKg4fVHzmtteXiqbtBNdRK8ssbX5eTs
        RVsKGQqbD4TTG5DMHMrNQA5G8CFtVjO7hgSP3VJitlQjA11JQFa5iLvrdjUzlER9qcxHai
        Whwvz+pNAqn75/1V0BrkfRTEbPa3QO0=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-iHhnxxJBOwuuJLkEnwjZBw-1; Mon, 11 Oct 2021 17:45:02 -0400
X-MC-Unique: iHhnxxJBOwuuJLkEnwjZBw-1
Received: by mail-oo1-f71.google.com with SMTP id x14-20020a056820104e00b002b624048711so10783075oot.6
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 14:45:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aE7fZ7rnu+RZO7buiKp9cNjPMZyO6dLzADEyPj5dQa8=;
        b=HtrXE4eMXlFCH7BNWoWN8nXQ3lQgffp2pbhe3esyvuGzX52O8Zx5Brs4nz6b1Mq9jU
         87MST2TAyOFzzsA0ZFB7CjC4DXr9crVFthKphvLysg7Sl8AeXP/k3+Q1cD4X14lo9eQA
         j9goYCAzDHgBkyK8QzktjsOvrLKGnfbyJso8b0zht+EVbuQ5DOVilFq89N4iYqsvdtc9
         wJQVlCqSn8Q/dCfiw0VTDuLP1MO//4nLrlqjJNwhdqDgovYVQi+3eHX+HrNQQV2Eg3G3
         yRfiYfuIbz7D5B85N4oedjS8LdckKILHSsRpiTceQ52XB5VN64WCXuQLdfu5wRj99BCp
         6vEw==
X-Gm-Message-State: AOAM531diMZIyaDdNQxVxKnJc6UnJosadJtNmJNsAFJz6Lwby332Q2Y+
        x1LQNtkCx9F0/CxZt7az3Hb5CLdfTkB/ouP5N6tpPaXFbnhrbrHwSoSqVtzEz7HMaXF7PRieeJr
        Ir3bdkWMzGVHg
X-Received: by 2002:a05:6830:557:: with SMTP id l23mr4802687otb.125.1633988701468;
        Mon, 11 Oct 2021 14:45:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRL9dYVXBXiqdgCI3kRAwqZRrrpKHOAdSX3opmPJY5wu1M0vgpChHKy6EB5TTgTuNwaaqmcw==
X-Received: by 2002:a05:6830:557:: with SMTP id l23mr4802672otb.125.1633988701204;
        Mon, 11 Oct 2021 14:45:01 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id l11sm1988899otd.8.2021.10.11.14.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 14:45:00 -0700 (PDT)
Date:   Mon, 11 Oct 2021 15:44:59 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Colin Xu <colin.xu@gmail.com>
Cc:     kvm@vger.kernel.org, colin.xu@intel.com, zhenyuw@linux.intel.com,
        hang.yuan@linux.intel.com, swee.yee.fonn@intel.com,
        fred.gao@intel.com
Subject: Re: [PATCH v7] vfio/pci: Add OpRegion 2.0+ Extended VBT support.
Message-ID: <20211011154459.21f9b477.alex.williamson@redhat.com>
In-Reply-To: <20211003155310.83694-1-colin.xu@gmail.com>
References: <c7c01710-153e-2684-7887-8fd112ce040@gmail.com>
        <20211003155310.83694-1-colin.xu@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun,  3 Oct 2021 23:53:10 +0800
Colin Xu <colin.xu@gmail.com> wrote:
...
>  static ssize_t vfio_pci_igd_rw(struct vfio_pci_core_device *vdev,
>  			       char __user *buf, size_t count, loff_t *ppos,
>  			       bool iswrite)
>  {
>  	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
> -	void *base = vdev->region[i].data;
> -	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +	struct igd_opregion_vbt *opregionvbt = vdev->region[i].data;
> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK, off = 0;
> +	size_t remaining;
>  
>  	if (pos >= vdev->region[i].size || iswrite)
>  		return -EINVAL;
>  
>  	count = min(count, (size_t)(vdev->region[i].size - pos));
> +	remaining = count;
> +
> +	/* Copy until OpRegion version */
> +	if (remaining && pos < OPREGION_VERSION) {
> +		size_t bytes = min(remaining, OPREGION_VERSION - (size_t)pos);


mint_t(size_t,...) is probably the better option than casting the
individual operands, especially when we're casting multiple operands as
below.


> +
> +		if (igd_opregion_shift_copy(buf, &off,
> +					    opregionvbt->opregion + pos, &pos,
> +					    &remaining, bytes))
> +			return -EFAULT;
> +	}
>  
...
>  	/*
> -	 * Support opregion v2.1+
> -	 * When VBT data exceeds 6KB size and cannot be within mailbox #4, then
> -	 * the Extended VBT region next to opregion is used to hold the VBT data.
> -	 * RVDA (Relative Address of VBT Data from Opregion Base) and RVDS
> -	 * (Raw VBT Data Size) from opregion structure member are used to hold the
> -	 * address from region base and size of VBT data. RVDA/RVDS are not
> -	 * defined before opregion 2.0.
> +	 * OpRegion and VBT:
> +	 * When VBT data doesn't exceed 6KB, it's stored in Mailbox #4.
> +	 * When VBT data exceeds 6KB size, Mailbox #4 is no longer large enough
> +	 * to hold the VBT data, the Extended VBT region is introduced since
> +	 * OpRegion 2.0 to hold the VBT data. Since OpRegion 2.0, RVDA/RVDS are
> +	 * introduced to define the extended VBT data location and size.
> +	 * OpRegion 2.0: RVDA defines the absolute physical address of the
> +	 *   extended VBT data, RVDS defines the VBT data size.
> +	 * OpRegion 2.1 and above: RVDA defines the relative address of the
> +	 *   extended VBT data to OpRegion base, RVDS defines the VBT data size.
>  	 *
> -	 * opregion 2.1+: RVDA is unsigned, relative offset from
> -	 * opregion base, and should point to the end of opregion.
> -	 * otherwise, exposing to userspace to allow read access to everything between
> -	 * the OpRegion and VBT is not safe.
> -	 * RVDS is defined as size in bytes.
> -	 *
> -	 * opregion 2.0: rvda is the physical VBT address.
> -	 * Since rvda is HPA it cannot be directly used in guest.
> -	 * And it should not be practically available for end user,so it is not supported.
> +	 * Due to the RVDA difference in OpRegion VBT (also the only diff between
> +	 * 2.0 and 2.1), expose OpRegion and VBT as a contiguous range for
> +	 * OpRegion 2.0 and above makes it possible to support the non-contiguous


The lines ending between$ and contiguous$ are still just over 80
columns.  Thanks,

Alex


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2BB01EB4E9
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 07:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgFBFIV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 01:08:21 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31442 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726084AbgFBFIU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Jun 2020 01:08:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591074499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i21+6+jn+AssAfqfuTEOtmF/3IbU/JSkgC0yQOaoU/8=;
        b=Bbovmp2QK55FZ3j3U/wnnBgkkJOduw2qZPvBWWdNCMx7mAluZGBw0wvBQjwcvqDZotXIo3
        fNgMZsf4p7VHN9nDkEI8RMle3Sv+JsNgyZggRiJ+pIP4aabcpsq8wUQy/9mM3E/E/Z4FQ+
        baDpqFqrR5jYV37UJWG0iB45AYVBvdc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-6X16j0zSMs6BAezXbRq5jg-1; Tue, 02 Jun 2020 01:08:09 -0400
X-MC-Unique: 6X16j0zSMs6BAezXbRq5jg-1
Received: by mail-wm1-f69.google.com with SMTP id t145so493627wmt.2
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 22:08:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i21+6+jn+AssAfqfuTEOtmF/3IbU/JSkgC0yQOaoU/8=;
        b=J9PxALtwym+AIlUZ/TkjoXwzhe1yGnRWZbN45868VwNV9fVxAH/ARc/B9lKyXvg98v
         ZBNXH1sdqCtyQCBrDMYgtLrK1b1pdO23CFKN6wEQjvaIoDugQDHPteOvO7ZDgMxLM+bO
         QN0pQnlVhoyTJGgnvKP5ZpqravGGMkPjMGnXV47d+SioNG93RXhJ0LrcDdw5W8dACoHk
         khgBwZsSd/TwIEsdhLSwF4znX6R9qB3Om6NEWOon8Ko0426bZp1lZci31d4PMhWECiHN
         GrEEJ6o/cZwjL2pJiJ3OL6F0GqG6VUNYaZZj/GEoxUsI/5eQ/1/otDtERM+AIMRfbk/4
         lv0A==
X-Gm-Message-State: AOAM532I95VJXmiM+EbirgcjKToamLGGGIV5v6j/OiN3z/0BPvpTyKHj
        BZF7V5tQUWoUDU4VqVk4+J/p4MXAvWfuWbBpWrT1QHeQiug1WDwRsJrZcgZ2FOIgc7mwfraPMKu
        1GrdDRG4m+1lS
X-Received: by 2002:a5d:4c81:: with SMTP id z1mr26712888wrs.371.1591074487435;
        Mon, 01 Jun 2020 22:08:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7ZFXMW684yAQznwucY1IA0VuesC1zA8zze+z7mJFUahZ6qoJQid59fnWEYmNevYhEMFGybw==
X-Received: by 2002:a5d:4c81:: with SMTP id z1mr26712868wrs.371.1591074487279;
        Mon, 01 Jun 2020 22:08:07 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id a126sm1761521wme.28.2020.06.01.22.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 22:08:06 -0700 (PDT)
Date:   Tue, 2 Jun 2020 01:08:03 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.miller@broadcom.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, eli@mellanox.com
Subject: Re: [PATCH 5/6] vdpa: introduce virtio pci driver
Message-ID: <20200602010332-mutt-send-email-mst@kernel.org>
References: <20200529080303.15449-1-jasowang@redhat.com>
 <20200529080303.15449-6-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529080303.15449-6-jasowang@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 29, 2020 at 04:03:02PM +0800, Jason Wang wrote:
> +static void vp_vdpa_set_vq_ready(struct vdpa_device *vdpa,
> +				 u16 qid, bool ready)
> +{
> +	struct vp_vdpa *vp_vdpa = vdpa_to_vp(vdpa);
> +
> +	vp_iowrite16(qid, &vp_vdpa->common->queue_select);
> +	vp_iowrite16(ready, &vp_vdpa->common->queue_enable);
> +}
> +

Looks like this needs to check and just skip the write if
ready == 0, right? Of course vdpa core then insists on calling
vp_vdpa_get_vq_ready which will warn. Maybe just drop the
check from core, move it to drivers which need it?

...


> +static const struct pci_device_id vp_vdpa_id_table[] = {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_REDHAT_QUMRANET, PCI_ANY_ID) },
> +	{ 0 }
> +};

This looks like it'll create a mess with either virtio pci
or vdpa being loaded at random. Maybe just don't specify
any IDs for now. Down the road we could get a
distinct vendor ID or a range of device IDs for this.

> +MODULE_DEVICE_TABLE(pci, vp_vdpa_id_table);
> +
> +static struct pci_driver vp_vdpa_driver = {
> +	.name		= "vp-vdpa",
> +	.id_table	= vp_vdpa_id_table,
> +	.probe		= vp_vdpa_probe,
> +	.remove		= vp_vdpa_remove,
> +};
> +
> +module_pci_driver(vp_vdpa_driver);
> +
> +MODULE_AUTHOR("Jason Wang <jasowang@redhat.com>");
> +MODULE_DESCRIPTION("vp-vdpa");
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION("1");
> -- 
> 2.20.1


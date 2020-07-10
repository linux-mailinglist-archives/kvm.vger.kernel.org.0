Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46E7A21B8A7
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 16:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgGJO3m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 10:29:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47097 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726925AbgGJO3m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 10:29:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594391380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tX5iNdDkKREb5eC682c495Xdf8tAVwyuaAtEmkGgwUw=;
        b=EszR1O9JMy37hRTqyQo3OCv/xZMejiW3URc/bzHTwHuZZiiK9iyiWf/g5W5IE1Ryyi5MPw
        ariaPVFF0uQMtx15FQ+NXZ8Ql0+x/eZxI3zEYqQAvbB72MdNtkQJbURxetkUp51gWPUSVr
        Gg4NmuvfSQjCEFM+LGb0CLTkVDphwyg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-R9jDj9pwMjaAZtxLZtrCeA-1; Fri, 10 Jul 2020 10:29:38 -0400
X-MC-Unique: R9jDj9pwMjaAZtxLZtrCeA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 501501082;
        Fri, 10 Jul 2020 14:29:37 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 611CF10016DA;
        Fri, 10 Jul 2020 14:29:33 +0000 (UTC)
Date:   Fri, 10 Jul 2020 08:29:32 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Huacai Chen <chenhc@lemote.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] PCI: Move PCI_VENDOR_ID_REDHAT definition to pci_ids.h
Message-ID: <20200710082932.65984c88@x1.home>
In-Reply-To: <20200709220324.GA21641@bjorn-Precision-5520>
References: <1594195170-11119-1-git-send-email-chenhc@lemote.com>
        <20200709220324.GA21641@bjorn-Precision-5520>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Jul 2020 17:03:24 -0500
Bjorn Helgaas <helgaas@kernel.org> wrote:

> [+cc Kirti, Alex, kvm]
> 
> On Wed, Jul 08, 2020 at 03:59:30PM +0800, Huacai Chen wrote:
> > Instead of duplicating the PCI_VENDOR_ID_REDHAT definition everywhere,
> > move it to include/linux/pci_ids.h is better.
> > 
> > Signed-off-by: Huacai Chen <chenhc@lemote.com>  
> 
> Applied with Gerd's ack to pci/misc for v5.9, thanks!
> 
> I also updated this in samples/vfio-mdev/mdpy-defs.h:
> 
>   -#define MDPY_PCI_VENDOR_ID     0x1b36 /* redhat */
>   +#define MDPY_PCI_VENDOR_ID     PCI_VENDOR_ID_REDHAT

Thanks, Bjorn!

Alex

> > ---
> >  drivers/gpu/drm/qxl/qxl_dev.h           | 2 --
> >  drivers/net/ethernet/rocker/rocker_hw.h | 1 -
> >  include/linux/pci_ids.h                 | 2 ++
> >  3 files changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/qxl/qxl_dev.h b/drivers/gpu/drm/qxl/qxl_dev.h
> > index a0ee416..a7bc31f 100644
> > --- a/drivers/gpu/drm/qxl/qxl_dev.h
> > +++ b/drivers/gpu/drm/qxl/qxl_dev.h
> > @@ -131,8 +131,6 @@ enum SpiceCursorType {
> >  
> >  #pragma pack(push, 1)
> >  
> > -#define REDHAT_PCI_VENDOR_ID 0x1b36
> > -
> >  /* 0x100-0x11f reserved for spice, 0x1ff used for unstable work */
> >  #define QXL_DEVICE_ID_STABLE 0x0100
> >  
> > diff --git a/drivers/net/ethernet/rocker/rocker_hw.h b/drivers/net/ethernet/rocker/rocker_hw.h
> > index 59f1f8b..62fd84c 100644
> > --- a/drivers/net/ethernet/rocker/rocker_hw.h
> > +++ b/drivers/net/ethernet/rocker/rocker_hw.h
> > @@ -25,7 +25,6 @@ enum {
> >  
> >  #define ROCKER_FP_PORTS_MAX 62
> >  
> > -#define PCI_VENDOR_ID_REDHAT		0x1b36
> >  #define PCI_DEVICE_ID_REDHAT_ROCKER	0x0006
> >  
> >  #define ROCKER_PCI_BAR0_SIZE		0x2000
> > diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> > index 0ad5769..5c709a1 100644
> > --- a/include/linux/pci_ids.h
> > +++ b/include/linux/pci_ids.h
> > @@ -2585,6 +2585,8 @@
> >  
> >  #define PCI_VENDOR_ID_ASMEDIA		0x1b21
> >  
> > +#define PCI_VENDOR_ID_REDHAT		0x1b36
> > +
> >  #define PCI_VENDOR_ID_AMAZON_ANNAPURNA_LABS	0x1c36
> >  
> >  #define PCI_VENDOR_ID_CIRCUITCO		0x1cc8
> > -- 
> > 2.7.0
> >   
> 


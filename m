Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36F0D19AD4B
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 16:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732874AbgDAOBh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 10:01:37 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41594 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732587AbgDAOBh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Apr 2020 10:01:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585749695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JTgkw/DNWNFnGK1V1mn43DeF8IkK7OE1WypLeTHLQVQ=;
        b=GyDvtzxgdJe+NPo3SEjtIIeob7qke8JOdWOTN6yrCmOrAJJQCaamHpD32LB7fnhppxdtRP
        vrT1CItyR7CVx2RtVvweQfbYDFNTfCPObT6BUunWfPgq8WdcRwK1qxzkcqtJAGVbDvlEIR
        tMwYkVpdoBB2EJT8T06PiMFdbRQB1Ic=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-a3xzo1WtMciuM2Zh8uB4yQ-1; Wed, 01 Apr 2020 10:01:34 -0400
X-MC-Unique: a3xzo1WtMciuM2Zh8uB4yQ-1
Received: by mail-wm1-f70.google.com with SMTP id o5so10186wmo.6
        for <kvm@vger.kernel.org>; Wed, 01 Apr 2020 07:01:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=JTgkw/DNWNFnGK1V1mn43DeF8IkK7OE1WypLeTHLQVQ=;
        b=nbodK7p8tgT7DuCVDPxRdBIX1fIs1Wjyljvv9erQc5/P4QIr/4bMq+AQw8m1VdZHe4
         A6W2gcZITLGfZdaxwcWONYOfmeO5zrB8Rt4iuaVYoyPUK/0SariOf3+/o3QB22x6PkHD
         pJVxQL6zcR+Oc9mVqxHwt8O2lQcf4lxSgAUDCTbJd9813KZN9NIyhNC0+na5GSESe0nd
         k3pp2J3Ok76nDNvQhhrU6lMte2pTgr6ZUMZvu7J7sR0w1H7CPB6WsIpJ9OUPbtdHZr6P
         E6OtnxSsB9eoe8r5bZP4/DMWlfCTd35wQcnLd65eGDDb0YeiQ60vZvQIeVVChD/2rC+e
         c6fg==
X-Gm-Message-State: ANhLgQ2h7SikZeyhTqt01lFeUSx42uozpPVK+eAU5OgxGndQW9W+vbtS
        LWyZZtlbiFLGBnTVjK3Kvbtpd2qMKiRSzZpBFcdD/JIAyFUTbbCb87/B8n8u0EFPzFdQiddmJYt
        G9yeJ670oH6C7
X-Received: by 2002:adf:9321:: with SMTP id 30mr24990271wro.330.1585749692208;
        Wed, 01 Apr 2020 07:01:32 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsFbKox39mO56Wdb4IkMUuB5u4BTlW+FZYATXuysnk2/9j76LmESJqT/c2PrF73AgslT1nk9A==
X-Received: by 2002:adf:9321:: with SMTP id 30mr24990241wro.330.1585749691892;
        Wed, 01 Apr 2020 07:01:31 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id 98sm3113112wrk.52.2020.04.01.07.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 07:01:31 -0700 (PDT)
Date:   Wed, 1 Apr 2020 10:01:26 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, jgg@mellanox.com,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com,
        xiao.w.wang@intel.com, lingshan.zhu@intel.com, eperezma@redhat.com,
        lulu@redhat.com, parav@mellanox.com, kevin.tian@intel.com,
        stefanha@redhat.com, rdunlap@infradead.org, hch@infradead.org,
        aadam@redhat.com, jiri@mellanox.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn
Subject: Re: [PATCH V9 1/9] vhost: refine vhost and vringh kconfig
Message-ID: <20200401095820-mutt-send-email-mst@kernel.org>
References: <20200326140125.19794-1-jasowang@redhat.com>
 <20200326140125.19794-2-jasowang@redhat.com>
 <fde312a4-56bd-f11f-799f-8aa952008012@de.ibm.com>
 <41ee1f6a-3124-d44b-bf34-0f26604f9514@redhat.com>
 <4726da4c-11ec-3b6e-1218-6d6d365d5038@de.ibm.com>
 <39b96e3a-9f4e-6e1d-e988-8c4bcfb55879@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <39b96e3a-9f4e-6e1d-e988-8c4bcfb55879@de.ibm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 01, 2020 at 03:02:00PM +0200, Christian Borntraeger wrote:
> 
> 
> On 01.04.20 14:56, Christian Borntraeger wrote:
> > 
> > On 01.04.20 14:50, Jason Wang wrote:
> >>
> >> On 2020/4/1 下午7:21, Christian Borntraeger wrote:
> >>> On 26.03.20 15:01, Jason Wang wrote:
> >>>> Currently, CONFIG_VHOST depends on CONFIG_VIRTUALIZATION. But vhost is
> >>>> not necessarily for VM since it's a generic userspace and kernel
> >>>> communication protocol. Such dependency may prevent archs without
> >>>> virtualization support from using vhost.
> >>>>
> >>>> To solve this, a dedicated vhost menu is created under drivers so
> >>>> CONIFG_VHOST can be decoupled out of CONFIG_VIRTUALIZATION.
> >>> FWIW, this now results in vhost not being build with defconfig kernels (in todays
> >>> linux-next).
> >>>
> >>
> >> Hi Christian:
> >>
> >> Did you meet it even with this commit https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=a4be40cbcedba9b5b714f3c95182e8a45176e42d?
> > 
> > I simply used linux-next. The defconfig does NOT contain CONFIG_VHOST and therefore CONFIG_VHOST_NET and friends
> > can not be selected.
> > 
> > $ git checkout next-20200401
> > $ make defconfig
> >   HOSTCC  scripts/basic/fixdep
> >   HOSTCC  scripts/kconfig/conf.o
> >   HOSTCC  scripts/kconfig/confdata.o
> >   HOSTCC  scripts/kconfig/expr.o
> >   LEX     scripts/kconfig/lexer.lex.c
> >   YACC    scripts/kconfig/parser.tab.[ch]
> >   HOSTCC  scripts/kconfig/lexer.lex.o
> >   HOSTCC  scripts/kconfig/parser.tab.o
> >   HOSTCC  scripts/kconfig/preprocess.o
> >   HOSTCC  scripts/kconfig/symbol.o
> >   HOSTCC  scripts/kconfig/util.o
> >   HOSTLD  scripts/kconfig/conf
> > *** Default configuration is based on 'x86_64_defconfig'
> > #
> > # configuration written to .config
> > #
> > 
> > $ grep VHOST .config
> > # CONFIG_VHOST is not set
> > 
> >  
> >> If yes, what's your build config looks like?
> >>
> >> Thanks
> 
> This was x86. Not sure if that did work before.
> On s390 this is definitely a regression as the defconfig files 
> for s390 do select VHOST_NET
> 
> grep VHOST arch/s390/configs/*
> arch/s390/configs/debug_defconfig:CONFIG_VHOST_NET=m
> arch/s390/configs/debug_defconfig:CONFIG_VHOST_VSOCK=m
> arch/s390/configs/defconfig:CONFIG_VHOST_NET=m
> arch/s390/configs/defconfig:CONFIG_VHOST_VSOCK=m
> 
> and this worked with 5.6, but does not work with next. Just adding
> CONFIG_VHOST=m to the defconfig solves the issue, something like

And a bunch of other places I guess... and I guess we need to
select VHOST_RING too?
Also Jason, I just noticed that you added:

config VHOST_RING
        tristate
+        select VHOST_IOTLB
        help
          This option is selected by any driver which needs to access
          the host side of a virtio ring.

but are you sure this will do the right thing if VHOST_RING itself
selected?


> ---
>  arch/s390/configs/debug_defconfig | 5 +++--
>  arch/s390/configs/defconfig       | 5 +++--
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
> index 46038bc58c9e..0b83274341ce 100644
> --- a/arch/s390/configs/debug_defconfig
> +++ b/arch/s390/configs/debug_defconfig
> @@ -57,8 +57,6 @@ CONFIG_PROTECTED_VIRTUALIZATION_GUEST=y
>  CONFIG_CMM=m
>  CONFIG_APPLDATA_BASE=y
>  CONFIG_KVM=m
> -CONFIG_VHOST_NET=m
> -CONFIG_VHOST_VSOCK=m
>  CONFIG_OPROFILE=m
>  CONFIG_KPROBES=y
>  CONFIG_JUMP_LABEL=y
> @@ -561,6 +559,9 @@ CONFIG_VFIO_MDEV_DEVICE=m
>  CONFIG_VIRTIO_PCI=m
>  CONFIG_VIRTIO_BALLOON=m
>  CONFIG_VIRTIO_INPUT=y
> +CONFIG_VHOST=m
> +CONFIG_VHOST_NET=m
> +CONFIG_VHOST_VSOCK=m
>  CONFIG_S390_CCW_IOMMU=y
>  CONFIG_S390_AP_IOMMU=y
>  CONFIG_EXT4_FS=y
> diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
> index 7cd0648c1f4e..39e69c4e8cf7 100644
> --- a/arch/s390/configs/defconfig
> +++ b/arch/s390/configs/defconfig
> @@ -57,8 +57,6 @@ CONFIG_PROTECTED_VIRTUALIZATION_GUEST=y
>  CONFIG_CMM=m
>  CONFIG_APPLDATA_BASE=y
>  CONFIG_KVM=m
> -CONFIG_VHOST_NET=m
> -CONFIG_VHOST_VSOCK=m
>  CONFIG_OPROFILE=m
>  CONFIG_KPROBES=y
>  CONFIG_JUMP_LABEL=y
> @@ -557,6 +555,9 @@ CONFIG_VFIO_MDEV_DEVICE=m
>  CONFIG_VIRTIO_PCI=m
>  CONFIG_VIRTIO_BALLOON=m
>  CONFIG_VIRTIO_INPUT=y
> +CONFIG_VHOST=m
> +CONFIG_VHOST_NET=m
> +CONFIG_VHOST_VSOCK=m
>  CONFIG_S390_CCW_IOMMU=y
>  CONFIG_S390_AP_IOMMU=y
>  CONFIG_EXT4_FS=y
> -- 
> 2.25.1


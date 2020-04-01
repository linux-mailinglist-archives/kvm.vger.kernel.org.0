Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2EBB19ADA5
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 16:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732958AbgDAOSP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 10:18:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32198 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732205AbgDAOSN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 10:18:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585750692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=koigHvjQZC19eKDd8fYYKD1byFLtuNk9rFfv+MSme6o=;
        b=RkCOGQhNZFYpWV8BiKhBBm64nzMj1wRLeU/7/GGi2aYZtRbFH3rO4ZJki9BUK14X9V4c+B
        jmRph7Uwb/k1CiQWF1hCxctaFf8ZGfmL4vL8cC8KogeBMGPbIXJ/RYZuv3nqIT/zV/FpT0
        kmkKPKJihoTmwYt7qoWaPVS1YAQcEuI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-J6TNiRPNPOSX2Wyd6ebffA-1; Wed, 01 Apr 2020 10:18:09 -0400
X-MC-Unique: J6TNiRPNPOSX2Wyd6ebffA-1
Received: by mail-wr1-f70.google.com with SMTP id e10so14625853wru.6
        for <kvm@vger.kernel.org>; Wed, 01 Apr 2020 07:18:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=koigHvjQZC19eKDd8fYYKD1byFLtuNk9rFfv+MSme6o=;
        b=ryZUZiFEJDX5vUJT+RR6k/VDcCcuq98OwTCrvcjobWcCxyPnua1iLX+nss+kxToYwg
         SWu+NNOtznTjXBRGHifXwGvWV1u5JDm/zVPeoZjX42fGj3nwhxt288pfOcWVG1sfv+cx
         uP8IgG8FUM7SuEuMc0eLt7q+k4q+5S77vxpCKHRD1JzL1541wnnmNmiEDe8GHDWissOE
         PvAqnr8GX3+HLQBTifD32suQ8D051lZoVX3YuR/GN5OBON0lruSrYkuTAvdObhZsG4jg
         vWyGB6jzszzlGAaXIShJQURrI2Zqn93JiqCMCC8CI1INkou7g7PrFu/7e+inU+8y2G0v
         nqGw==
X-Gm-Message-State: AGi0PuY86Zlrfn14KRsw+1yVSrxXOFJ5sWu6MFMFszgUhTL93E4jI9BL
        gj8orHAGMy/b2Jgxl2vQyOv688tzYRyN/s38flJKjzrQ7ANNVtVuGbufXzIFbX+YLDlgCl6uN2n
        CxDISvR2TdUHe
X-Received: by 2002:a05:600c:2949:: with SMTP id n9mr4854308wmd.129.1585750687901;
        Wed, 01 Apr 2020 07:18:07 -0700 (PDT)
X-Google-Smtp-Source: APiQypIDbSLF7skcDOxwD6+QUFmg2lPeWzSgOX1pVJzAYBHdhN6pMa1uaSvkuWaE5DTOSSwxR6SXXw==
X-Received: by 2002:a05:600c:2949:: with SMTP id n9mr4854274wmd.129.1585750687676;
        Wed, 01 Apr 2020 07:18:07 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id r5sm2901223wmr.15.2020.04.01.07.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 07:18:07 -0700 (PDT)
Date:   Wed, 1 Apr 2020 10:18:03 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, kevin.tian@intel.com, stefanha@redhat.com,
        rdunlap@infradead.org, hch@infradead.org, aadam@redhat.com,
        jiri@mellanox.com, shahafs@mellanox.com, hanand@xilinx.com,
        mhabets@solarflare.com, gdawar@xilinx.com, saugatm@xilinx.com,
        vmireyno@marvell.com, zhangweining@ruijie.com.cn
Subject: Re: [PATCH V9 1/9] vhost: refine vhost and vringh kconfig
Message-ID: <20200401101634-mutt-send-email-mst@kernel.org>
References: <20200326140125.19794-1-jasowang@redhat.com>
 <20200326140125.19794-2-jasowang@redhat.com>
 <fde312a4-56bd-f11f-799f-8aa952008012@de.ibm.com>
 <41ee1f6a-3124-d44b-bf34-0f26604f9514@redhat.com>
 <4726da4c-11ec-3b6e-1218-6d6d365d5038@de.ibm.com>
 <39b96e3a-9f4e-6e1d-e988-8c4bcfb55879@de.ibm.com>
 <c423c5b1-7817-7417-d7af-e07bef6368e7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c423c5b1-7817-7417-d7af-e07bef6368e7@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 01, 2020 at 10:13:29PM +0800, Jason Wang wrote:
> 
> On 2020/4/1 下午9:02, Christian Borntraeger wrote:
> > 
> > On 01.04.20 14:56, Christian Borntraeger wrote:
> > > On 01.04.20 14:50, Jason Wang wrote:
> > > > On 2020/4/1 下午7:21, Christian Borntraeger wrote:
> > > > > On 26.03.20 15:01, Jason Wang wrote:
> > > > > > Currently, CONFIG_VHOST depends on CONFIG_VIRTUALIZATION. But vhost is
> > > > > > not necessarily for VM since it's a generic userspace and kernel
> > > > > > communication protocol. Such dependency may prevent archs without
> > > > > > virtualization support from using vhost.
> > > > > > 
> > > > > > To solve this, a dedicated vhost menu is created under drivers so
> > > > > > CONIFG_VHOST can be decoupled out of CONFIG_VIRTUALIZATION.
> > > > > FWIW, this now results in vhost not being build with defconfig kernels (in todays
> > > > > linux-next).
> > > > > 
> > > > Hi Christian:
> > > > 
> > > > Did you meet it even with this commit https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=a4be40cbcedba9b5b714f3c95182e8a45176e42d?
> > > I simply used linux-next. The defconfig does NOT contain CONFIG_VHOST and therefore CONFIG_VHOST_NET and friends
> > > can not be selected.
> > > 
> > > $ git checkout next-20200401
> > > $ make defconfig
> > >    HOSTCC  scripts/basic/fixdep
> > >    HOSTCC  scripts/kconfig/conf.o
> > >    HOSTCC  scripts/kconfig/confdata.o
> > >    HOSTCC  scripts/kconfig/expr.o
> > >    LEX     scripts/kconfig/lexer.lex.c
> > >    YACC    scripts/kconfig/parser.tab.[ch]
> > >    HOSTCC  scripts/kconfig/lexer.lex.o
> > >    HOSTCC  scripts/kconfig/parser.tab.o
> > >    HOSTCC  scripts/kconfig/preprocess.o
> > >    HOSTCC  scripts/kconfig/symbol.o
> > >    HOSTCC  scripts/kconfig/util.o
> > >    HOSTLD  scripts/kconfig/conf
> > > *** Default configuration is based on 'x86_64_defconfig'
> > > #
> > > # configuration written to .config
> > > #
> > > 
> > > $ grep VHOST .config
> > > # CONFIG_VHOST is not set
> > > 
> > > > If yes, what's your build config looks like?
> > > > 
> > > > Thanks
> > This was x86. Not sure if that did work before.
> > On s390 this is definitely a regression as the defconfig files
> > for s390 do select VHOST_NET
> > 
> > grep VHOST arch/s390/configs/*
> > arch/s390/configs/debug_defconfig:CONFIG_VHOST_NET=m
> > arch/s390/configs/debug_defconfig:CONFIG_VHOST_VSOCK=m
> > arch/s390/configs/defconfig:CONFIG_VHOST_NET=m
> > arch/s390/configs/defconfig:CONFIG_VHOST_VSOCK=m
> > 
> > and this worked with 5.6, but does not work with next. Just adding
> > CONFIG_VHOST=m to the defconfig solves the issue, something like
> 
> 
> Right, I think we probably need
> 
> 1) add CONFIG_VHOST=m to all defconfigs that enables
> CONFIG_VHOST_NET/VSOCK/SCSI.
> 
> or
> 
> 2) don't use menuconfig for CONFIG_VHOST, let NET/SCSI/VDPA just select it.
> 
> Thanks

I think I prefer 2, but does it auto-select VHOST_IOTLB then?
Generally what was the reason to drop select VHOST from devices?


> 
> > 
> > ---
> >   arch/s390/configs/debug_defconfig | 5 +++--
> >   arch/s390/configs/defconfig       | 5 +++--
> >   2 files changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
> > index 46038bc58c9e..0b83274341ce 100644
> > --- a/arch/s390/configs/debug_defconfig
> > +++ b/arch/s390/configs/debug_defconfig
> > @@ -57,8 +57,6 @@ CONFIG_PROTECTED_VIRTUALIZATION_GUEST=y
> >   CONFIG_CMM=m
> >   CONFIG_APPLDATA_BASE=y
> >   CONFIG_KVM=m
> > -CONFIG_VHOST_NET=m
> > -CONFIG_VHOST_VSOCK=m
> >   CONFIG_OPROFILE=m
> >   CONFIG_KPROBES=y
> >   CONFIG_JUMP_LABEL=y
> > @@ -561,6 +559,9 @@ CONFIG_VFIO_MDEV_DEVICE=m
> >   CONFIG_VIRTIO_PCI=m
> >   CONFIG_VIRTIO_BALLOON=m
> >   CONFIG_VIRTIO_INPUT=y
> > +CONFIG_VHOST=m
> > +CONFIG_VHOST_NET=m
> > +CONFIG_VHOST_VSOCK=m
> >   CONFIG_S390_CCW_IOMMU=y
> >   CONFIG_S390_AP_IOMMU=y
> >   CONFIG_EXT4_FS=y
> > diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
> > index 7cd0648c1f4e..39e69c4e8cf7 100644
> > --- a/arch/s390/configs/defconfig
> > +++ b/arch/s390/configs/defconfig
> > @@ -57,8 +57,6 @@ CONFIG_PROTECTED_VIRTUALIZATION_GUEST=y
> >   CONFIG_CMM=m
> >   CONFIG_APPLDATA_BASE=y
> >   CONFIG_KVM=m
> > -CONFIG_VHOST_NET=m
> > -CONFIG_VHOST_VSOCK=m
> >   CONFIG_OPROFILE=m
> >   CONFIG_KPROBES=y
> >   CONFIG_JUMP_LABEL=y
> > @@ -557,6 +555,9 @@ CONFIG_VFIO_MDEV_DEVICE=m
> >   CONFIG_VIRTIO_PCI=m
> >   CONFIG_VIRTIO_BALLOON=m
> >   CONFIG_VIRTIO_INPUT=y
> > +CONFIG_VHOST=m
> > +CONFIG_VHOST_NET=m
> > +CONFIG_VHOST_VSOCK=m
> >   CONFIG_S390_CCW_IOMMU=y
> >   CONFIG_S390_AP_IOMMU=y
> >   CONFIG_EXT4_FS=y


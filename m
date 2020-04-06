Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76EEC19F147
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 10:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgDFIEL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 6 Apr 2020 04:04:11 -0400
Received: from mga03.intel.com ([134.134.136.65]:2094 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbgDFIEK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Apr 2020 04:04:10 -0400
IronPort-SDR: JZzQJGOyCd6k2hmqtLo4LmE5lQLCXA0/kt7xheeEh7qSmhlh9BNqAP1fawcwiB58sFBy2JLP+G
 7zmQSe/QRGfg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2020 01:04:07 -0700
IronPort-SDR: 1OJ442ZbcwfC0uDA+eB/bMqW6pbv08iG0+Ch4FZv1jzDvPXIuBJV0qg1f8I2CvoQPhulJPko93
 qXCheqOdXo6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,350,1580803200"; 
   d="scan'208";a="296594628"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Apr 2020 01:04:07 -0700
Received: from fmsmsx156.amr.corp.intel.com (10.18.116.74) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 6 Apr 2020 01:04:07 -0700
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 fmsmsx156.amr.corp.intel.com (10.18.116.74) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 6 Apr 2020 01:04:06 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.209]) with mapi id 14.03.0439.000;
 Mon, 6 Apr 2020 16:04:03 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Auger Eric <eric.auger@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [PATCH v2 04/22] hw/iommu: introduce HostIOMMUContext
Thread-Topic: [PATCH v2 04/22] hw/iommu: introduce HostIOMMUContext
Thread-Index: AQHWBkpipXk9AcbvW0ea4lbMrBMnp6hg3OsAgArnvHA=
Date:   Mon, 6 Apr 2020 08:04:02 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A2230B3@SHSMSX104.ccr.corp.intel.com>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-5-git-send-email-yi.l.liu@intel.com>
 <aa1bfbd5-e6de-6475-809e-a6ca46089aaa@redhat.com>
In-Reply-To: <aa1bfbd5-e6de-6475-809e-a6ca46089aaa@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

> From: Auger Eric < eric.auger@redhat.com>
> Sent: Tuesday, March 31, 2020 1:23 AM
> To: Liu, Yi L <yi.l.liu@intel.com>; qemu-devel@nongnu.org;
> Subject: Re: [PATCH v2 04/22] hw/iommu: introduce HostIOMMUContext
> 
> Yi,
> 
> On 3/30/20 6:24 AM, Liu Yi L wrote:
> > Currently, many platform vendors provide the capability of dual stage
> > DMA address translation in hardware. For example, nested translation
> > on Intel VT-d scalable mode, nested stage translation on ARM SMMUv3,
> > and etc. In dual stage DMA address translation, there are two stages
> > address translation, stage-1 (a.k.a first-level) and stage-2 (a.k.a
> > second-level) translation structures. Stage-1 translation results are
> > also subjected to stage-2 translation structures. Take vSVA (Virtual
> > Shared Virtual Addressing) as an example, guest IOMMU driver owns
> > stage-1 translation structures (covers GVA->GPA translation), and host
> > IOMMU driver owns stage-2 translation structures (covers GPA->HPA
> > translation). VMM is responsible to bind stage-1 translation structures
> > to host, thus hardware could achieve GVA->GPA and then GPA->HPA
> > translation. For more background on SVA, refer the below links.
> >  - https://www.youtube.com/watch?v=Kq_nfGK5MwQ
> >  - https://events19.lfasiallc.com/wp-content/uploads/2017/11/\
> > Shared-Virtual-Memory-in-KVM_Yi-Liu.pdf
> >
[...]
> > +void host_iommu_ctx_init(void *_iommu_ctx, size_t instance_size,
> > +                         const char *mrtypename,
> > +                         uint64_t flags)
> > +{
> > +    HostIOMMUContext *iommu_ctx;
> > +
> > +    object_initialize(_iommu_ctx, instance_size, mrtypename);
> > +    iommu_ctx = HOST_IOMMU_CONTEXT(_iommu_ctx);
> > +    iommu_ctx->flags = flags;
> > +    iommu_ctx->initialized = true;
> > +}
> > +
> > +static const TypeInfo host_iommu_context_info = {
> > +    .parent             = TYPE_OBJECT,
> > +    .name               = TYPE_HOST_IOMMU_CONTEXT,
> > +    .class_size         = sizeof(HostIOMMUContextClass),
> > +    .instance_size      = sizeof(HostIOMMUContext),
> > +    .abstract           = true,
> Can't we use the usual .instance_init and .instance_finalize?
sorry, I somehow missed this comment. In prior patch, .instace_init
was used, but the current major init method is via host_iommu_ctx_init(),
so .instance_init is not really necessary.
https://www.spinics.net/lists/kvm/msg210878.html

Regards,
Yi Liu

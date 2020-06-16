Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533CA1FBA2B
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 18:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732660AbgFPQJ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 12:09:29 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36196 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732614AbgFPQJW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 12:09:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592323760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2y8KD7xWbYjXU/cEL7LgtQkBTECAhlAA76XR+Aplj6k=;
        b=ck+7g/pm5dEJrlRpsCQ3SjWkZzbQNm1DFXFpqF7BtZSJ82uYgPqMbIWmITFnxF9NKwRPGT
        CoJXVSblruzWaOqH8JBDR3/NKPJXY/Ds7PwTq7UkDAM+vV4mFDdZNS66nVhn2pD/dbia1A
        5tKeNai1EQCKcV3eklT4K/ce88GBZXQ=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-8Vm3W3ZjNiOFQd1EtpEWiQ-1; Tue, 16 Jun 2020 12:09:19 -0400
X-MC-Unique: 8Vm3W3ZjNiOFQd1EtpEWiQ-1
Received: by mail-qt1-f199.google.com with SMTP id u48so17073575qth.17
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 09:09:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2y8KD7xWbYjXU/cEL7LgtQkBTECAhlAA76XR+Aplj6k=;
        b=Tm2vPdG5ar7Gbk7HPT/mlHibbp21j+cyMy/bnK5NlFJL74ccbDBnpo3lPkmwXMm3G6
         J6cnRJ1FUUVFuasYolHiyy3mLE8DNWi4GsUngoqCrDqgy66tFdRmiVHUyKHBrLHzFNru
         iNo8/O1Tqp9mif5bAPsZiLn8i6Y8+qfLRZLmBVv9RFr4x8KgU3PUo02UnbaWLuSaqgC1
         7HPplDVWHAPgC9D06HN3i+BFbKz/O+/NS6+2Ccj4CoY5u7TtU0Fpclji8uo+ySttSYX6
         xdNrN2jJoucU9kI/Y9a+uMYwDIsaKgZ32CtxVTNNOYNDotn9S6r/Q1ub/L14iJULO9pa
         49FA==
X-Gm-Message-State: AOAM531N+OVhCkfkEbu5OO2m7KEym5WzOXCNnx4PZj4v+sce+aBExEPA
        yxwk52X4M0JHLU4nnS8Z20qbDzda5jmVkKdYJrz98hKC46KjmP+qvwp/5yg2Co9yvZ6tI+bCZ3u
        AM1sTJBzdY9zC
X-Received: by 2002:ad4:54ea:: with SMTP id k10mr3112691qvx.66.1592323758929;
        Tue, 16 Jun 2020 09:09:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyoN5ZsEbH2t5hBW9WW5hOk33D7AAL34ncw5O7fmuB3JLmLE9egHSi0toqNT8A+dCzhofL/5Q==
X-Received: by 2002:ad4:54ea:: with SMTP id k10mr3112676qvx.66.1592323758723;
        Tue, 16 Jun 2020 09:09:18 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id y1sm15552040qta.82.2020.06.16.09.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 09:09:17 -0700 (PDT)
Date:   Tue, 16 Jun 2020 12:09:16 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 00/15] vfio: expose virtual Shared Virtual Addressing
 to VMs
Message-ID: <20200616160916.GC11838@xz-x1>
References: <1591877734-66527-1-git-send-email-yi.l.liu@intel.com>
 <20200615100214.GC1491454@stefanha-x1.localdomain>
 <MWHPR11MB16451F1E4748DF97D6A1DDD48C9D0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200616154928.GF1491454@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200616154928.GF1491454@stefanha-x1.localdomain>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 16, 2020 at 04:49:28PM +0100, Stefan Hajnoczi wrote:
> Isolation between applications is preserved but there is no isolation
> between the device and the application itself. The application needs to
> trust the device.
> 
> Examples:
> 
> 1. The device can snoop secret data from readable pages in the
>    application's virtual memory space.
> 
> 2. The device can gain arbitrary execution on the CPU by overwriting
>    control flow addresses (e.g. function pointers, stack return
>    addresses) in writable pages.

To me, SVA seems to be that "middle layer" of secure where it's not as safe as
VFIO_IOMMU_MAP_DMA which has buffer level granularity of control (but of course
we pay overhead on buffer setups and on-the-fly translations), however it's far
better than DMA with no IOMMU which can ruin the whole host/guest, because
after all we do a lot of isolations as process based.

IMHO it's the same as when we see a VM (or the QEMU process) as a whole along
with the guest code.  In some cases we don't care if the guest did some bad
things to mess up with its own QEMU process.  It is still ideal if we can even
stop the guest from doing so, but when it's not easy to do it the ideal way, we
just lower the requirement to not spread the influence to the host and other
VMs.

Thanks,

-- 
Peter Xu


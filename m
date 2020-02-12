Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0947215AC83
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 17:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbgBLQAG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 11:00:06 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45429 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728555AbgBLQAG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Feb 2020 11:00:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581523205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GIgWy4UzqzvKKoSqexQFDNIRRINuD+NmWSIWAy1UUjw=;
        b=SgornEzVWw+fBMhraZqXpfbSrZdlywlumH9mCZOW6CCGhOAIP5UE45XG571sgvS0G1qCQH
        hfp+31AQq0xBtKuSGjwcCG6oye6t7/EA79HNAirKBG1KL7IkeH5ho3OsjBRB7x5AO5Isxv
        FaKCblQ9V6CcbmVUpelu7Tp2q60rIWs=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-9Ep2m-PKPJydV040F5qU_g-1; Wed, 12 Feb 2020 11:00:03 -0500
X-MC-Unique: 9Ep2m-PKPJydV040F5qU_g-1
Received: by mail-qt1-f198.google.com with SMTP id y3so1530776qti.15
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 08:00:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GIgWy4UzqzvKKoSqexQFDNIRRINuD+NmWSIWAy1UUjw=;
        b=MnhusMJt1rCOs2D4rucEeoJHFqb2beclShK2fBgvwhwqQJOCiBd807sMcFiS6XhMVJ
         M6/4fn6SgaGYEWbpTVoZdA4fc/39t0f84DPkSHr/Lln7iAtQCqg5WDw3lVKXX7UrSA8e
         Cdqru/kMNul4zr93IPTL9/b9VpS00pvsePrvxSSFdswrtotYak7iCS7pf9oVlzm1PSnQ
         f8p7X90TBatKDldxBKvYQeKPamxikN+2YyWZemuIUig2LVRjjue7fie7I/Wy0u03KD+t
         gzZaNpOnvat2U/G4Bgg2T4mmuLQUqOOouc8pfAZ/TskqjeRjJpB4pNppPdDhyjE4D1Ha
         sTjA==
X-Gm-Message-State: APjAAAXOFDX++XSkUQUPp6EMUE7jIoHbUyeoFVFqrAyJw50V5kBqvb3i
        dZQtnVmdsvkR3q5nnDbMFoz+2F1X6dJ1F8YIYT5doW4xaA1t2V9h9KLTe64iJgE1uK+CbxhvPq1
        bXi5AQcIIbxM+
X-Received: by 2002:ac8:5510:: with SMTP id j16mr20022919qtq.262.1581523202876;
        Wed, 12 Feb 2020 08:00:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqzNF1roNv2zMtbIsGRMgoRPnCGtj8LPssqv/WDb1qtL0FOOHYKRnnc8HynjcKjY1JyS2w3suw==
X-Received: by 2002:ac8:5510:: with SMTP id j16mr20022896qtq.262.1581523202567;
        Wed, 12 Feb 2020 08:00:02 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id 89sm390685qth.3.2020.02.12.08.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 08:00:01 -0800 (PST)
Date:   Wed, 12 Feb 2020 10:59:58 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v3 03/25] hw/iommu: introduce IOMMUContext
Message-ID: <20200212155958.GB1083891@xz-x1>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-4-git-send-email-yi.l.liu@intel.com>
 <20200131040644.GG15210@umbus.fritz.box>
 <A2975661238FB949B60364EF0F2C25743A199306@SHSMSX104.ccr.corp.intel.com>
 <20200211165843.GG984290@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A1BA4D8@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A1BA4D8@SHSMSX104.ccr.corp.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 12, 2020 at 07:15:13AM +0000, Liu, Yi L wrote:

[...]

> While considering your suggestion on dropping one of the two abstract
> layers. I came up a new proposal as below:
> 
> We may drop the IOMMUContext in this series, and rename DualStageIOMMUObject
> to HostIOMMUContext, which is per-vfio-container. Add an interface in PCI
> layer(e.g. an callback in  PCIDevice) to let vIOMMU get HostIOMMUContext.
> I think this could cover the requirement of providing explicit method for
> vIOMMU to call into VFIO and then program host IOMMU.
> 
> While for the requirement of VFIO to vIOMMU callings (e.g. PRQ), I think it
> could be done via PCI layer by adding an operation in PCIIOMMUOps. Thoughts?

Hmm sounds good. :)

The thing is for the calls to the other direction (e.g. VFIO injecting
faults to vIOMMU), that's neither per-container nor per-device, but
per-vIOMMU.  PCIIOMMUOps suites for that job I'd say, which is per-vIOMMU.

Let's see how it goes.

-- 
Peter Xu


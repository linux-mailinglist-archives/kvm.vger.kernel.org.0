Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5BA3BD766
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 06:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633890AbfIYEbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 00:31:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56896 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390426AbfIYEbE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 00:31:04 -0400
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 560C9356CE
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 04:31:04 +0000 (UTC)
Received: by mail-pf1-f200.google.com with SMTP id v6so3089704pfm.1
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 21:31:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4ynUg0HQbXYGY2EZQxVg6auXL0jYkF08J5NPdzyoPwU=;
        b=eHHZRqxMYeK/XzuAcVf18YrbKQbD7noSg0sKuWDgCUklmmJHiSNhR3seq0tAAp/Wci
         Vz65EFB1yM+zNB0GTdkcaeWJYJTil3p53bIjoH4y6C31nA8lcDqM3MTTKEPSdZ04BFow
         9g+qGjWosT5xsuzr4QlXSC3Y8Uxe/DzllW1h5fmePtc4cePmlpfUStdmmWaGRCmaIfrZ
         BZsLkx4sXsFWhq8hj5x7vSW1m+o/H8K1/K4ep6iI52nnNyjF4O5orme2o0ug9YWgzfsi
         87ywfm8KHP3QwL/5lXbkc2Cw44DkFs06lXdzgUWyoieuM0gBy4qAGglDrXjosPi0hu+v
         miaQ==
X-Gm-Message-State: APjAAAWocDf5g+8cZhLH+49kYxG2xBxIFvi4xYdk9vNBj+JRjJIpQG4I
        7nB6G9OTfp07C1hGj05qOUTsa2Iz3iDALSgIzcbK4Il+KlcxhqJeeRkl39k+zxXmKBFsUGQVmJG
        wSHGXA/gFGyvZ
X-Received: by 2002:a17:902:7796:: with SMTP id o22mr7013574pll.222.1569385863819;
        Tue, 24 Sep 2019 21:31:03 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxYc48a4lrqvlO6kVhQ/UCi7qF+uCt4R+18KQwSaFo3Uxwb45dh8PhpKk4Lh42FKW2HgHzXYg==
X-Received: by 2002:a17:902:7796:: with SMTP id o22mr7013535pll.222.1569385863511;
        Tue, 24 Sep 2019 21:31:03 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ep10sm6428239pjb.2.2019.09.24.21.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 21:31:02 -0700 (PDT)
Date:   Wed, 25 Sep 2019 12:30:50 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>, kevin.tian@intel.com,
        Yi Sun <yi.y.sun@linux.intel.com>, kvm@vger.kernel.org,
        sanjay.k.kumar@intel.com, yi.y.sun@intel.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC PATCH 2/4] iommu/vt-d: Add first level page table interfaces
Message-ID: <20190925043050.GK28074@xz-x1>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
 <20190923122454.9888-3-baolu.lu@linux.intel.com>
 <20190923203102.GB21816@araj-mobl1.jf.intel.com>
 <9cfe6042-f0fb-ea5e-e134-f6f5bb9eb7b0@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9cfe6042-f0fb-ea5e-e134-f6f5bb9eb7b0@linux.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 24, 2019 at 09:38:53AM +0800, Lu Baolu wrote:
> > > intel_mmmap_range(domain, addr, end, phys_addr, prot)
> > 
> > Maybe think of a different name..? mmmap seems a bit weird :-)
> 
> Yes. I don't like it either. I've thought about it and haven't
> figured out a satisfied one. Do you have any suggestions?

How about at least split the word using "_"?  Like "mm_map", then
apply it to all the "mmm*" prefixes.  Otherwise it'll be easily
misread as mmap() which is totally irrelevant to this...

Regards,

-- 
Peter Xu

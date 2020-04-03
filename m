Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86E9619D96F
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 16:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403953AbgDCOr2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 10:47:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58842 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728235AbgDCOr2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 10:47:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585925247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pIMdHeam2Dd57E1ij8qf+M+ClKnpGrmjjcDtBAmNnvM=;
        b=E99SWDGmnlc3PPt11NiDMETMd4uXykPtiWvVXdEGeOC6BeMg5wG9o6MjZZhCyh3ma25gij
        eMMkAs8iR8yYows6Jl4XCf3oz9xX9EromFCSJgU3YA/IBuEtEuibKP4euFCydvrTs9VfNF
        WnvZQ6Oa3DEoaSTliqNZxBQwSSFHtZU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-262pD_bnO4ebuuk9wxYmuQ-1; Fri, 03 Apr 2020 10:47:25 -0400
X-MC-Unique: 262pD_bnO4ebuuk9wxYmuQ-1
Received: by mail-wr1-f72.google.com with SMTP id u16so3193756wrp.14
        for <kvm@vger.kernel.org>; Fri, 03 Apr 2020 07:47:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pIMdHeam2Dd57E1ij8qf+M+ClKnpGrmjjcDtBAmNnvM=;
        b=Pvwx4TLQERTbVjmD+RLggDAFpKjQFBvJouUTMVpTFu2NnQ/Hll6rqcZauIlG1RB30j
         A6JtYiifBwFy6vTcuaqtcsg3Qm2AEEdW4jIboHm2XYL5dRYR1jeEo5UGMYeggQSbuzLn
         zwlI9MoTHrRkjipsbkM3F37K4Mpb8Jy9HblAD5y6m+WtXcY7fwt6mrY5UdYHgnjMK3Mh
         hgc5Mc0/jVMmHvASmZSNxonnxleqNqNyr+UO8+nz7xeKndQP1e3mXgESBvmnxCDWi5rQ
         XksO71WD+E1x/BByeq6wfJAMlnNevYqst59aRn/thmwCe17DgfMK7+h2jyaS8H+GSIll
         RrxQ==
X-Gm-Message-State: AGi0PubYcd/s2it/czCVV4N2/VzVK/WrwqudQ9LD0rRw2C2Dls55+xsF
        2yvJ1XgV7KhHtm7dnsmqI/Z4r8iHPemjEvUADb2ycFXj9nh5MJ2nBfMuDlWjRGF+LGfklsD5OLT
        6lNfhSCXUj302
X-Received: by 2002:a7b:c148:: with SMTP id z8mr8859431wmi.31.1585925244240;
        Fri, 03 Apr 2020 07:47:24 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ/slyncg9POzbP4k32yikwz4uR//iAykjMgD1RX8ERy9OxRDOu6M5CxkUlQ8AKnuQ1Xi3O1w==
X-Received: by 2002:a7b:c148:: with SMTP id z8mr8859410wmi.31.1585925244062;
        Fri, 03 Apr 2020 07:47:24 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::3])
        by smtp.gmail.com with ESMTPSA id n6sm12456186wrp.30.2020.04.03.07.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 07:47:23 -0700 (PDT)
Date:   Fri, 3 Apr 2020 10:47:19 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        eric.auger@redhat.com, pbonzini@redhat.com, mst@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        hao.wu@intel.com, jean-philippe@linaro.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH v2 19/22] intel_iommu: process PASID-based iotlb
 invalidation
Message-ID: <20200403144719.GL103677@xz-x1>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-20-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1585542301-84087-20-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 29, 2020 at 09:24:58PM -0700, Liu Yi L wrote:
> This patch adds the basic PASID-based iotlb (piotlb) invalidation
> support. piotlb is used during walking Intel VT-d 1st level page
> table. This patch only adds the basic processing. Detailed handling
> will be added in next patch.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Eduardo Habkost <ehabkost@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


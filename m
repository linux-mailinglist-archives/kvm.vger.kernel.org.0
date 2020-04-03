Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C32419D975
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 16:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390915AbgDCOt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 10:49:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24493 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727431AbgDCOt0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 10:49:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585925365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2yQcmseEyeVg6GPm96uWfFnmAMUahKPoXBAjzFAW3yI=;
        b=SvteODAShmkpdQg4Zz/rFbjlTBB194bWfG7pr8s2eejjrN/sL3jRy218fwL2D8OjCYGYzE
        wiZlZi6E4U/7dLfcROjFe2juAtQDHSqgtDurI0O5eUma2kqhdIFZNRqZm7S4tee+BgIro+
        soTlzD/6gdwxJl55RQNCeURJgeu/6mo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38--4MazU2GN-akwzbiQ9G4fw-1; Fri, 03 Apr 2020 10:49:23 -0400
X-MC-Unique: -4MazU2GN-akwzbiQ9G4fw-1
Received: by mail-wm1-f71.google.com with SMTP id j18so2144466wmi.1
        for <kvm@vger.kernel.org>; Fri, 03 Apr 2020 07:49:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2yQcmseEyeVg6GPm96uWfFnmAMUahKPoXBAjzFAW3yI=;
        b=mHe2FsrOLi/ZStUqzp15H/Lw1JBD0J9Xm0Gv2yRr6yd7nrmTSxcsHFd5gOAFrF1EB7
         9OXzjhappBW6psgoLIbUSkLdygHYHHJZlbxCCEr5sWLhE6fU44D3ah5rBybmfTozRGoO
         Eu0sToyEdpDHBaLaeUMvWJRtcDEJpQdKSyPy/bmWeUlppWa2EToQ5/nBQUa4i3U1MGc0
         2QMe0/OskfU42YWvxtl0b2xgP85eOobp9TnuOiR+qL+8yMNIGm0CA7cZzLfH8PoK3Ajx
         6hDL/Um4Yof+F4Nq+aNM24FjBc5LZRZZzcibigCLuvCKOB1Omk//SI1oVZEQhD1cCnuU
         K/Nw==
X-Gm-Message-State: AGi0PuakjTP6316aNT9Cb1Zfps1z1XLTEAc2BI4+t1BacdxhodoLdB3H
        Z3jdbKU4Li7EmqQSRcd1uX1LsFSLpLQ/jHK9ujn/UR1+E4/TINn8ATyzyyfpD8LDQE1FM1f9L3W
        wNHi1UfZYomdD
X-Received: by 2002:a5d:4844:: with SMTP id n4mr1876788wrs.314.1585925362128;
        Fri, 03 Apr 2020 07:49:22 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ0AZHkfLKjPMnhj2b2pI772WnqimjJzNleJGck0W25rIEhP0qlqVTo5gotJo7M/k58Z4J98w==
X-Received: by 2002:a5d:4844:: with SMTP id n4mr1876773wrs.314.1585925361963;
        Fri, 03 Apr 2020 07:49:21 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::3])
        by smtp.gmail.com with ESMTPSA id a13sm12168426wrh.80.2020.04.03.07.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 07:49:21 -0700 (PDT)
Date:   Fri, 3 Apr 2020 10:49:16 -0400
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
Subject: Re: [PATCH v2 22/22] intel_iommu: modify x-scalable-mode to be
 string option
Message-ID: <20200403144916.GM103677@xz-x1>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-23-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1585542301-84087-23-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 29, 2020 at 09:25:01PM -0700, Liu Yi L wrote:
> Intel VT-d 3.0 introduces scalable mode, and it has a bunch of capabilities
> related to scalable mode translation, thus there are multiple combinations.
> While this vIOMMU implementation wants simplify it for user by providing
> typical combinations. User could config it by "x-scalable-mode" option. The
> usage is as below:
> 
> "-device intel-iommu,x-scalable-mode=["legacy"|"modern"|"off"]"
> 
>  - "legacy": gives support for SL page table
>  - "modern": gives support for FL page table, pasid, virtual command
>  - "off": no scalable mode support
>  -  if not configured, means no scalable mode support, if not proper
>     configured, will throw error
> 
> Note: this patch is supposed to be merged when  the whole vSVA patch series
> were merged.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Eduardo Habkost <ehabkost@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


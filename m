Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7B151599F1
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 20:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729202AbgBKTnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 14:43:42 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23307 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727668AbgBKTnm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Feb 2020 14:43:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581450219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h7KUPmf86zB702J560kJNk/Uikfj86BS/GU0xdCnSuI=;
        b=Gd8po4U1AAP81UyZ7+/RqTmZ7O+baLh+pRr8mJfr+U37d8llD7Kl+3DxbRuFS+liw60d+V
        xaIX7/5/mqL3wkmPkYEuxt9fNVwLQvQiGNlQeDvL1T3kNYLH7hNzkKbDXyKCcQyWq4HVSq
        1N6wRG/snGbFXL8xwDsOAec2oq8jPRI=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-9_nmaTUCO1iku6jrzGYITQ-1; Tue, 11 Feb 2020 14:43:34 -0500
X-MC-Unique: 9_nmaTUCO1iku6jrzGYITQ-1
Received: by mail-qt1-f200.google.com with SMTP id b13so4146964qtp.8
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 11:43:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h7KUPmf86zB702J560kJNk/Uikfj86BS/GU0xdCnSuI=;
        b=hEo+L7q1dOv2Cjyls6BiDkOAKbMjNQ3W1A7DJNoxxW+k7/SfnveX7J4jx/1R1MQzlS
         LDXT0CwVUjtyFiYPAXFLQ6K6ii308j+R+0BjdMfJYN30462ZZucoYi03LK8jKvYO0R5/
         AXYXETyIt7v6irB+RX+Ih0fJ/FEyiftyUFxf1v68zT9OxSpif6ZhBaR+Dz0kgmfcnv8m
         i5m5Fpm9LUqYgBhvOHks2q6U+w01catCpZ/go3n0LgYZJaVvn6+mioBfvqKm+y+Uszgm
         AStn55M3zgNzLDoe5xAlRlvHA3zjar3jqmjK8lZwTElU1gH4aXJA8FFKypr4bhcjVBbr
         eFpQ==
X-Gm-Message-State: APjAAAW8tREYj+5/XTmM2kCQitTESdtDkdxPPuDpdvZHLyOy0jRRjRnu
        hblk2L0eO8Fvkmu1hUk5vGzKOGGsrxwHL3blWm1j+9oVlX4OWf8Om2TZbV5anJelCPXUyYXkU/v
        1JFcozD1LqSqt
X-Received: by 2002:a05:620a:412:: with SMTP id 18mr7737118qkp.213.1581450214428;
        Tue, 11 Feb 2020 11:43:34 -0800 (PST)
X-Google-Smtp-Source: APXvYqzaQKrkmzYTPMBwqDXhjjHJJr6Jkmjr2WXR0RK4oj5iaQ+jZhyfSdQZUhqw4MyroKiz2WqNWw==
X-Received: by 2002:a05:620a:412:: with SMTP id 18mr7737098qkp.213.1581450214196;
        Tue, 11 Feb 2020 11:43:34 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id x197sm2540447qkb.28.2020.02.11.11.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 11:43:33 -0800 (PST)
Date:   Tue, 11 Feb 2020 14:43:31 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, david@gibson.dropbear.id.au,
        pbonzini@redhat.com, alex.williamson@redhat.com, mst@redhat.com,
        eric.auger@redhat.com, kevin.tian@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, kvm@vger.kernel.org, hao.wu@intel.com,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC v3 13/25] intel_iommu: modify x-scalable-mode to be string
 option
Message-ID: <20200211194331.GK984290@xz-x1>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-14-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1580300216-86172-14-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 29, 2020 at 04:16:44AM -0800, Liu, Yi L wrote:
> From: Liu Yi L <yi.l.liu@intel.com>
> 
> Intel VT-d 3.0 introduces scalable mode, and it has a bunch of capabilities
> related to scalable mode translation, thus there are multiple combinations.
> While this vIOMMU implementation wants simplify it for user by providing
> typical combinations. User could config it by "x-scalable-mode" option. The
> usage is as below:
> 
> "-device intel-iommu,x-scalable-mode=["legacy"|"modern"]"

Maybe also "off" when someone wants to explicitly disable it?

> 
>  - "legacy": gives support for SL page table
>  - "modern": gives support for FL page table, pasid, virtual command
>  -  if not configured, means no scalable mode support, if not proper
>     configured, will throw error
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
> ---
>  hw/i386/intel_iommu.c          | 27 +++++++++++++++++++++++++--
>  hw/i386/intel_iommu_internal.h |  3 +++
>  include/hw/i386/intel_iommu.h  |  2 ++
>  3 files changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
> index 1c1eb7f..33be40c 100644
> --- a/hw/i386/intel_iommu.c
> +++ b/hw/i386/intel_iommu.c
> @@ -3078,7 +3078,7 @@ static Property vtd_properties[] = {
>      DEFINE_PROP_UINT8("aw-bits", IntelIOMMUState, aw_bits,
>                        VTD_HOST_ADDRESS_WIDTH),
>      DEFINE_PROP_BOOL("caching-mode", IntelIOMMUState, caching_mode, FALSE),
> -    DEFINE_PROP_BOOL("x-scalable-mode", IntelIOMMUState, scalable_mode, FALSE),
> +    DEFINE_PROP_STRING("x-scalable-mode", IntelIOMMUState, scalable_mode_str),
>      DEFINE_PROP_BOOL("dma-drain", IntelIOMMUState, dma_drain, true),
>      DEFINE_PROP_END_OF_LIST(),
>  };
> @@ -3708,8 +3708,11 @@ static void vtd_init(IntelIOMMUState *s)
>      }
>  
>      /* TODO: read cap/ecap from host to decide which cap to be exposed. */
> -    if (s->scalable_mode) {
> +    if (s->scalable_mode && !s->scalable_modern) {
>          s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS;
> +    } else if (s->scalable_mode && s->scalable_modern) {
> +        s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_PASID
> +                   | VTD_ECAP_FLTS | VTD_ECAP_PSS;

This patch might be good to be the last one after all the impls are
ready.

>      }
>  
>      vtd_reset_caches(s);
> @@ -3845,6 +3848,26 @@ static bool vtd_decide_config(IntelIOMMUState *s, Error **errp)
>          return false;
>      }
>  
> +    if (s->scalable_mode_str &&
> +        (strcmp(s->scalable_mode_str, "modern") &&
> +         strcmp(s->scalable_mode_str, "legacy"))) {
> +        error_setg(errp, "Invalid x-scalable-mode config");

Maybe "..., Please use 'modern', 'legacy', or 'off'." to show options.

> +        return false;
> +    }
> +
> +    if (s->scalable_mode_str &&
> +        !strcmp(s->scalable_mode_str, "legacy")) {
> +        s->scalable_mode = true;
> +        s->scalable_modern = false;
> +    } else if (s->scalable_mode_str &&
> +        !strcmp(s->scalable_mode_str, "modern")) {
> +        s->scalable_mode = true;
> +        s->scalable_modern = true;
> +    } else {
> +        s->scalable_mode = false;
> +        s->scalable_modern = false;
> +    }
> +
>      return true;
>  }
>  
> diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
> index 862033e..c4dbb2c 100644
> --- a/hw/i386/intel_iommu_internal.h
> +++ b/hw/i386/intel_iommu_internal.h
> @@ -190,8 +190,11 @@
>  #define VTD_ECAP_PT                 (1ULL << 6)
>  #define VTD_ECAP_MHMV               (15ULL << 20)
>  #define VTD_ECAP_SRS                (1ULL << 31)
> +#define VTD_ECAP_PSS                (19ULL << 35)
> +#define VTD_ECAP_PASID              (1ULL << 40)
>  #define VTD_ECAP_SMTS               (1ULL << 43)
>  #define VTD_ECAP_SLTS               (1ULL << 46)
> +#define VTD_ECAP_FLTS               (1ULL << 47)
>  
>  /* CAP_REG */
>  /* (offset >> 4) << 24 */
> diff --git a/include/hw/i386/intel_iommu.h b/include/hw/i386/intel_iommu.h
> index 8571a85..1ef2917 100644
> --- a/include/hw/i386/intel_iommu.h
> +++ b/include/hw/i386/intel_iommu.h
> @@ -244,6 +244,8 @@ struct IntelIOMMUState {
>  
>      bool caching_mode;              /* RO - is cap CM enabled? */
>      bool scalable_mode;             /* RO - is Scalable Mode supported? */
> +    char *scalable_mode_str;        /* RO - admin's Scalable Mode config */
> +    bool scalable_modern;           /* RO - is modern SM supported? */
>  
>      dma_addr_t root;                /* Current root table pointer */
>      bool root_scalable;             /* Type of root table (scalable or not) */
> -- 
> 2.7.4
> 

-- 
Peter Xu


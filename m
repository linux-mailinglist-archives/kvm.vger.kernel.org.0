Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6063019194D
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 19:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbgCXSj3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 14:39:29 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:45749 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727146AbgCXSj2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 14:39:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585075166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sL0eAVRaIWASbETqSE83z4WnVFPyEX+txd4A0EQ2lwc=;
        b=dNLfwQlZAciArUmgRl0VaIbZ7T8rLImlwhi2GyNeZDeSfgc7UDiAZumC1c9tt7m5nn42n4
        QrgWM2aJJ0eVkoCmm60a3cDADbTFPp97cWIy0s5AVlj9scoCSbvbVvH+Ba6QModVLW3ggm
        I/6J+ExDObDpYwb1+Jdh08mhMqmpWQQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-daU4sS-uNLeGEoyvyya15A-1; Tue, 24 Mar 2020 14:39:24 -0400
X-MC-Unique: daU4sS-uNLeGEoyvyya15A-1
Received: by mail-wr1-f71.google.com with SMTP id d17so9651395wrw.19
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 11:39:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sL0eAVRaIWASbETqSE83z4WnVFPyEX+txd4A0EQ2lwc=;
        b=i08xfI5xZuezRJHY/W3EzzAVVlDiBnWnkEMa7YNFCkG21zi18DrjnJDGUy28AKmhd4
         E2iTkAaHMPpwJCHyY6x06RvbXRQBzW1OvJWGS+Y1LzkJtHc6mm+jWwKgCOvx0Wdcqf74
         GF8J0YuIhUAYZ734ULh/GeMTnOwTUenUY2cXdTEhm0QttzB+uuRITQdtwmY201AiNSp4
         X2AD3ZBxqt4OCPF8hSZsSwki4904ZPjToaRyo1q3lRgj8uT82Lnxg5ftzbXXoyHTIgNa
         evOMwIyUSvjRCgO4ewdcnB5ab6qgXffjNcz7KqKMTnzYOfaDrgUzKcL2uHYSFyg/h3uv
         V17A==
X-Gm-Message-State: ANhLgQ2M+WbdkWhqC+92sx8CKZHeDq2NrZFqZ4Cf4sAeuVi0TAVCrz2/
        ZcBFbobeNNOwS44kOLY0zozyll3nrsN5Ock3oqGgYhQkXNywa0XyXdzs/RBha/NBIWjCRTElEKg
        TuZzbs9aGw3ZI
X-Received: by 2002:adf:bc4a:: with SMTP id a10mr37906509wrh.7.1585075163723;
        Tue, 24 Mar 2020 11:39:23 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vs86kYZ/+t0REuC2ggpfxrOYEhm3LfxtXq73FBGwpUfdi0cWoVqJ/8tqEMfzSw3nK3hElg0AQ==
X-Received: by 2002:adf:bc4a:: with SMTP id a10mr37906470wrh.7.1585075163494;
        Tue, 24 Mar 2020 11:39:23 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id v2sm31518906wrt.58.2020.03.24.11.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 11:39:22 -0700 (PDT)
Date:   Tue, 24 Mar 2020 14:39:18 -0400
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
Subject: Re: [PATCH v1 22/22] intel_iommu: modify x-scalable-mode to be
 string option
Message-ID: <20200324183918.GG127076@xz-x1>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-23-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1584880579-12178-23-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 22, 2020 at 05:36:19AM -0700, Liu Yi L wrote:
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
> ---
>  hw/i386/intel_iommu.c          | 29 +++++++++++++++++++++++++++--
>  hw/i386/intel_iommu_internal.h |  4 ++++
>  include/hw/i386/intel_iommu.h  |  2 ++
>  3 files changed, 33 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
> index 72cd739..ea1f5c4 100644
> --- a/hw/i386/intel_iommu.c
> +++ b/hw/i386/intel_iommu.c
> @@ -4171,7 +4171,7 @@ static Property vtd_properties[] = {
>      DEFINE_PROP_UINT8("aw-bits", IntelIOMMUState, aw_bits,
>                        VTD_HOST_ADDRESS_WIDTH),
>      DEFINE_PROP_BOOL("caching-mode", IntelIOMMUState, caching_mode, FALSE),
> -    DEFINE_PROP_BOOL("x-scalable-mode", IntelIOMMUState, scalable_mode, FALSE),
> +    DEFINE_PROP_STRING("x-scalable-mode", IntelIOMMUState, scalable_mode_str),
>      DEFINE_PROP_BOOL("dma-drain", IntelIOMMUState, dma_drain, true),
>      DEFINE_PROP_END_OF_LIST(),
>  };
> @@ -4802,8 +4802,12 @@ static void vtd_init(IntelIOMMUState *s)
>      }
>  
>      /* TODO: read cap/ecap from host to decide which cap to be exposed. */
> -    if (s->scalable_mode) {
> +    if (s->scalable_mode && !s->scalable_modern) {
>          s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS;
> +    } else if (s->scalable_mode && s->scalable_modern) {
> +        s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_PASID
> +                   | VTD_ECAP_FLTS | VTD_ECAP_PSS | VTD_ECAP_VCS;
> +        s->vccap |= VTD_VCCAP_PAS;
>      }
>  
>      vtd_reset_caches(s);
> @@ -4935,6 +4939,27 @@ static bool vtd_decide_config(IntelIOMMUState *s, Error **errp)
>          return false;
>      }
>  
> +    if (s->scalable_mode_str &&
> +        (strcmp(s->scalable_mode_str, "modern") &&
> +         strcmp(s->scalable_mode_str, "legacy"))) {

The 'off' check is missing?

> +        error_setg(errp, "Invalid x-scalable-mode config,"
> +                         "Please use \"modern\", \"legacy\" or \"off\"");
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
> index b5507ce..52b25ff 100644
> --- a/hw/i386/intel_iommu_internal.h
> +++ b/hw/i386/intel_iommu_internal.h
> @@ -196,8 +196,12 @@
>  #define VTD_ECAP_PT                 (1ULL << 6)
>  #define VTD_ECAP_MHMV               (15ULL << 20)
>  #define VTD_ECAP_SRS                (1ULL << 31)
> +#define VTD_ECAP_PSS                (19ULL << 35)
> +#define VTD_ECAP_PASID              (1ULL << 40)
>  #define VTD_ECAP_SMTS               (1ULL << 43)
> +#define VTD_ECAP_VCS                (1ULL << 44)
>  #define VTD_ECAP_SLTS               (1ULL << 46)
> +#define VTD_ECAP_FLTS               (1ULL << 47)
>  
>  /* CAP_REG */
>  /* (offset >> 4) << 24 */
> diff --git a/include/hw/i386/intel_iommu.h b/include/hw/i386/intel_iommu.h
> index 9782ac4..07494d4 100644
> --- a/include/hw/i386/intel_iommu.h
> +++ b/include/hw/i386/intel_iommu.h
> @@ -268,6 +268,8 @@ struct IntelIOMMUState {
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


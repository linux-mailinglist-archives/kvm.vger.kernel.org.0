Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99DAE19D967
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 16:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403942AbgDCOp7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 10:45:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42125 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727431AbgDCOp6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 10:45:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585925157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iN/CbA1yKfXyMnQx0SzzSH5BI6P5yxTNjMIXWyXOGOY=;
        b=ZXseD8AauH5Zid0UCyRFKX0DwnL5iX4Bfy3hqmK6Oc1YAx1x/F/4sIbEWM2Kx2nkRqPqFO
        osoyRnI9vxIPd0aPLeHU7oai+/7ksygdr0loKgBnn98bHRNoyk6KsB+/evxigh3h7LlDt0
        uOy+PvxqJP2NT7NX+Ch8sZjZguVUC/0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-fwtkTMEZNHW0t4KEeQIT7g-1; Fri, 03 Apr 2020 10:45:55 -0400
X-MC-Unique: fwtkTMEZNHW0t4KEeQIT7g-1
Received: by mail-wr1-f69.google.com with SMTP id k11so3177974wrm.19
        for <kvm@vger.kernel.org>; Fri, 03 Apr 2020 07:45:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iN/CbA1yKfXyMnQx0SzzSH5BI6P5yxTNjMIXWyXOGOY=;
        b=aWsVNdnfU2O+Nz8+i28oB/7or23UCa5+nmzX5ottuW+HmCn+sYqd8JiEVQMyR1afzV
         usJJuxDagaG1NXdNH9eHHSFCU5fZamEUQtfp3yVUuMOLy+urZeTDlI9J059K7jVnPjk+
         AJ4iCjQO4DY5qv6VOWEu6IjrpVX92urK27HYCXD49XPpcoCiPdFP3hLp/ZnsZxEgiryM
         TTzTfh/DV/6j01mhG8zlfyeL9bfHNZPgJttNEA8o393HDXd76GqJH9eqeQniv1FEMcbd
         IemuCQl/vAWGVUZXubaLojSdJON39KR2S9BrTU/p43NzbjM3AMSIQMEp49HKDosD8je7
         4XzA==
X-Gm-Message-State: AGi0PuZ6N1+7inhOrUD+kSN96FovtT9Zi0oCt67AeystbAeqsMJVzdqb
        EbDi/4/QTxFH9dFT08RlpUPyj1qkj7vNRdnZ8sq8v5be9V+VYpv4WcSn7FIIa20WpumeY+Pbf+Z
        UH0/Co7jmWp8p
X-Received: by 2002:adf:ef08:: with SMTP id e8mr9992253wro.66.1585925154481;
        Fri, 03 Apr 2020 07:45:54 -0700 (PDT)
X-Google-Smtp-Source: APiQypJQUSM+EcrNQwnOPmHznd6lP97OMO57MVRtXCwy5VT9rjOUXg+VldAWcpLpM/epVCYWtsVK9A==
X-Received: by 2002:adf:ef08:: with SMTP id e8mr9992229wro.66.1585925154195;
        Fri, 03 Apr 2020 07:45:54 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::3])
        by smtp.gmail.com with ESMTPSA id j68sm12524581wrj.32.2020.04.03.07.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 07:45:53 -0700 (PDT)
Date:   Fri, 3 Apr 2020 10:45:48 -0400
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
Subject: Re: [PATCH v2 16/22] intel_iommu: replay pasid binds after context
 cache invalidation
Message-ID: <20200403144548.GK103677@xz-x1>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-17-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1585542301-84087-17-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 29, 2020 at 09:24:55PM -0700, Liu Yi L wrote:
> This patch replays guest pasid bindings after context cache
> invalidation. This is a behavior to ensure safety. Actually,
> programmer should issue pasid cache invalidation with proper
> granularity after issuing a context cache invalidation.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Eduardo Habkost <ehabkost@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  hw/i386/intel_iommu.c          | 51 ++++++++++++++++++++++++++++++++++++++++++
>  hw/i386/intel_iommu_internal.h |  6 ++++-
>  hw/i386/trace-events           |  1 +
>  3 files changed, 57 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
> index d87f608..883aeac 100644
> --- a/hw/i386/intel_iommu.c
> +++ b/hw/i386/intel_iommu.c
> @@ -68,6 +68,10 @@ static void vtd_address_space_refresh_all(IntelIOMMUState *s);
>  static void vtd_address_space_unmap(VTDAddressSpace *as, IOMMUNotifier *n);
>  
>  static void vtd_pasid_cache_reset(IntelIOMMUState *s);
> +static void vtd_pasid_cache_sync(IntelIOMMUState *s,
> +                                 VTDPASIDCacheInfo *pc_info);
> +static void vtd_pasid_cache_devsi(IntelIOMMUState *s,
> +                                  VTDBus *vtd_bus, uint16_t devfn);
>  
>  static void vtd_panic_require_caching_mode(void)
>  {
> @@ -1853,7 +1857,10 @@ static void vtd_iommu_replay_all(IntelIOMMUState *s)
>  
>  static void vtd_context_global_invalidate(IntelIOMMUState *s)
>  {
> +    VTDPASIDCacheInfo pc_info;
> +
>      trace_vtd_inv_desc_cc_global();
> +
>      /* Protects context cache */
>      vtd_iommu_lock(s);
>      s->context_cache_gen++;
> @@ -1870,6 +1877,9 @@ static void vtd_context_global_invalidate(IntelIOMMUState *s)
>       * VT-d emulation codes.
>       */
>      vtd_iommu_replay_all(s);
> +
> +    pc_info.flags = VTD_PASID_CACHE_GLOBAL;
> +    vtd_pasid_cache_sync(s, &pc_info);
>  }
>  
>  /**
> @@ -2005,6 +2015,22 @@ static void vtd_context_device_invalidate(IntelIOMMUState *s,
>                   * happened.
>                   */
>                  vtd_sync_shadow_page_table(vtd_as);
> +                /*
> +                 * Per spec, context flush should also followed with PASID
> +                 * cache and iotlb flush. Regards to a device selective
> +                 * context cache invalidation:

If context entry flush should also follow another pasid cache flush,
then this is still needed?  Shouldn't the pasid flush do the same
thing again?

> +                 * if (emaulted_device)
> +                 *    modify the pasid cache gen and pasid-based iotlb gen
> +                 *    value (will be added in following patches)

Let's avoid using "following patches" because it'll be helpless after
merged.  Also, the pasid cache gen is gone.

> +                 * else if (assigned_device)
> +                 *    check if the device has been bound to any pasid
> +                 *    invoke pasid_unbind regards to each bound pasid
> +                 * Here, we have vtd_pasid_cache_devsi() to invalidate pasid
> +                 * caches, while for piotlb in QEMU, we don't have it yet, so
> +                 * no handling. For assigned device, host iommu driver would
> +                 * flush piotlb when a pasid unbind is pass down to it.
> +                 */
> +                 vtd_pasid_cache_devsi(s, vtd_bus, devfn_it);
>              }
>          }
>      }
> @@ -2619,6 +2645,12 @@ static gboolean vtd_flush_pasid(gpointer key, gpointer value,
>          /* Fall through */
>      case VTD_PASID_CACHE_GLOBAL:
>          break;
> +    case VTD_PASID_CACHE_DEVSI:
> +        if (pc_info->vtd_bus != vtd_bus ||
> +            pc_info->devfn == devfn) {

Do you mean "!="?

> +            return false;
> +        }
> +        break;
>      default:
>          error_report("invalid pc_info->flags");
>          abort();
> @@ -2827,6 +2859,11 @@ static void vtd_replay_guest_pasid_bindings(IntelIOMMUState *s,
>          walk_info.flags |= VTD_PASID_TABLE_DID_SEL_WALK;
>          /* loop all assigned devices */
>          break;
> +    case VTD_PASID_CACHE_DEVSI:
> +        walk_info.vtd_bus = pc_info->vtd_bus;
> +        walk_info.devfn = pc_info->devfn;
> +        vtd_replay_pasid_bind_for_dev(s, start, end, &walk_info);
> +        return;
>      case VTD_PASID_CACHE_FORCE_RESET:
>          /* For force reset, no need to go further replay */
>          return;
> @@ -2912,6 +2949,20 @@ static void vtd_pasid_cache_sync(IntelIOMMUState *s,
>      vtd_iommu_unlock(s);
>  }
>  
> +static void vtd_pasid_cache_devsi(IntelIOMMUState *s,
> +                                  VTDBus *vtd_bus, uint16_t devfn)
> +{
> +    VTDPASIDCacheInfo pc_info;
> +
> +    trace_vtd_pasid_cache_devsi(devfn);
> +
> +    pc_info.flags = VTD_PASID_CACHE_DEVSI;
> +    pc_info.vtd_bus = vtd_bus;
> +    pc_info.devfn = devfn;
> +
> +    vtd_pasid_cache_sync(s, &pc_info);
> +}
> +
>  /**
>   * Caller of this function should hold iommu_lock
>   */
> diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
> index b9e48ab..9122601 100644
> --- a/hw/i386/intel_iommu_internal.h
> +++ b/hw/i386/intel_iommu_internal.h
> @@ -529,14 +529,18 @@ struct VTDPASIDCacheInfo {
>  #define VTD_PASID_CACHE_GLOBAL         (1ULL << 1)
>  #define VTD_PASID_CACHE_DOMSI          (1ULL << 2)
>  #define VTD_PASID_CACHE_PASIDSI        (1ULL << 3)
> +#define VTD_PASID_CACHE_DEVSI          (1ULL << 4)
>      uint32_t flags;
>      uint16_t domain_id;
>      uint32_t pasid;
> +    VTDBus *vtd_bus;
> +    uint16_t devfn;
>  };
>  #define VTD_PASID_CACHE_INFO_MASK    (VTD_PASID_CACHE_FORCE_RESET | \
>                                        VTD_PASID_CACHE_GLOBAL  | \
>                                        VTD_PASID_CACHE_DOMSI  | \
> -                                      VTD_PASID_CACHE_PASIDSI)
> +                                      VTD_PASID_CACHE_PASIDSI | \
> +                                      VTD_PASID_CACHE_DEVSI)
>  typedef struct VTDPASIDCacheInfo VTDPASIDCacheInfo;
>  
>  /* PASID Table Related Definitions */
> diff --git a/hw/i386/trace-events b/hw/i386/trace-events
> index 60d20c1..3853fa8 100644
> --- a/hw/i386/trace-events
> +++ b/hw/i386/trace-events
> @@ -26,6 +26,7 @@ vtd_pasid_cache_gsi(void) ""
>  vtd_pasid_cache_reset(void) ""
>  vtd_pasid_cache_dsi(uint16_t domain) "Domian slective PC invalidation domain 0x%"PRIx16
>  vtd_pasid_cache_psi(uint16_t domain, uint32_t pasid) "PASID slective PC invalidation domain 0x%"PRIx16" pasid 0x%"PRIx32
> +vtd_pasid_cache_devsi(uint16_t devfn) "Dev selective PC invalidation dev: 0x%"PRIx16
>  vtd_re_not_present(uint8_t bus) "Root entry bus %"PRIu8" not present"
>  vtd_ce_not_present(uint8_t bus, uint8_t devfn) "Context entry bus %"PRIu8" devfn %"PRIu8" not present"
>  vtd_iotlb_page_hit(uint16_t sid, uint64_t addr, uint64_t slpte, uint16_t domain) "IOTLB page hit sid 0x%"PRIx16" iova 0x%"PRIx64" slpte 0x%"PRIx64" domain 0x%"PRIx16
> -- 
> 2.7.4
> 

-- 
Peter Xu


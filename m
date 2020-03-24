Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A83B4191912
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 19:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgCXS0e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 14:26:34 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:51503 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727443AbgCXS0d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 14:26:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585074392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V6jHAxEN32/ukQnnlbxQIqoT3ejEMpdc3eZJXOAV41c=;
        b=LN4caIMSP7DbF486BKlced2S6TNN+bw+g5yW2DdAC0SZiQjuQ+Hz6Lp7QY7q1EPsl29d0k
        dE5PLCQMlEHmMbrS6yMsRXwVYZXbCgj9xGFV6YLI8ydYnAWSobChSkKe2sH1DxpkvNaMOW
        BpNXc5YhPGZMdSjg8AONu8vBW87puAY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-RtRPb1F_M6aR8Y99RzpT4A-1; Tue, 24 Mar 2020 14:26:30 -0400
X-MC-Unique: RtRPb1F_M6aR8Y99RzpT4A-1
Received: by mail-wr1-f72.google.com with SMTP id q18so9603568wrw.5
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 11:26:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V6jHAxEN32/ukQnnlbxQIqoT3ejEMpdc3eZJXOAV41c=;
        b=kacBamQY5e04VH/Ve3fBFK+9EY8bssH3r4O6vlNyPWx4x0bQ1AQD1EbAzV+vkjE+cF
         UO4JnraVA3gWIjIGZCktS3Y/k60Wqve12YqCrx3G1+pqpJFboNI+k7ISbhuUGiAlpktm
         15q2pGcjCCBNoYzWh0exQt48tEQ15ArIXH5yfPGDRasyLWXyxIR9DJvB+DCrgjRKvi8Y
         3e4kv1xvlKxzDJf9oGn4rr320zP0V95eriPoqufKB+tY0dWWl0Hx7LPisQHM9NHXuV03
         xXbSJATwFkUy8wbAQGJKzdHTRK5QwuMHOkam0YDFeXSa9YwN34BeF6DqONAHDEUM2t4s
         qDVw==
X-Gm-Message-State: ANhLgQ03FCA4PWlreAJrCD06K2kJ9W5U5D5xXh1VVpPfsiwbuTS3Klzi
        Sw4502fZjVCXmsry7DtT4BqKLSOuUvhSPgZcWCkB82hiiAIa96/0W69egd0+XZx6Ft0EvS7a/rv
        68awfWhpO/FYq
X-Received: by 2002:a05:600c:296:: with SMTP id 22mr7343400wmk.79.1585074388978;
        Tue, 24 Mar 2020 11:26:28 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvIYCrCeR8MIkoCWO59wRujpo/tfT33/kWbC4hZFUxGDVim/pLeqwAA9a3AhHLtgMFxuoR30g==
X-Received: by 2002:a05:600c:296:: with SMTP id 22mr7343377wmk.79.1585074388757;
        Tue, 24 Mar 2020 11:26:28 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id t12sm14061877wrm.0.2020.03.24.11.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 11:26:28 -0700 (PDT)
Date:   Tue, 24 Mar 2020 14:26:23 -0400
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
Subject: Re: [PATCH v1 19/22] intel_iommu: process PASID-based iotlb
 invalidation
Message-ID: <20200324182623.GD127076@xz-x1>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-20-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1584880579-12178-20-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 22, 2020 at 05:36:16AM -0700, Liu Yi L wrote:
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
> ---
>  hw/i386/intel_iommu.c          | 57 ++++++++++++++++++++++++++++++++++++++++++
>  hw/i386/intel_iommu_internal.h | 13 ++++++++++
>  2 files changed, 70 insertions(+)
> 
> diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
> index b007715..b9ac07d 100644
> --- a/hw/i386/intel_iommu.c
> +++ b/hw/i386/intel_iommu.c
> @@ -3134,6 +3134,59 @@ static bool vtd_process_pasid_desc(IntelIOMMUState *s,
>      return (ret == 0) ? true : false;
>  }
>  
> +static void vtd_piotlb_pasid_invalidate(IntelIOMMUState *s,
> +                                        uint16_t domain_id,
> +                                        uint32_t pasid)
> +{
> +}
> +
> +static void vtd_piotlb_page_invalidate(IntelIOMMUState *s, uint16_t domain_id,
> +                             uint32_t pasid, hwaddr addr, uint8_t am, bool ih)
> +{
> +}
> +
> +static bool vtd_process_piotlb_desc(IntelIOMMUState *s,
> +                                    VTDInvDesc *inv_desc)
> +{
> +    uint16_t domain_id;
> +    uint32_t pasid;
> +    uint8_t am;
> +    hwaddr addr;
> +
> +    if ((inv_desc->val[0] & VTD_INV_DESC_PIOTLB_RSVD_VAL0) ||
> +        (inv_desc->val[1] & VTD_INV_DESC_PIOTLB_RSVD_VAL1)) {
> +        error_report_once("non-zero-field-in-piotlb_inv_desc hi: 0x%" PRIx64
> +                  " lo: 0x%" PRIx64, inv_desc->val[1], inv_desc->val[0]);
> +        return false;
> +    }
> +
> +    domain_id = VTD_INV_DESC_PIOTLB_DID(inv_desc->val[0]);
> +    pasid = VTD_INV_DESC_PIOTLB_PASID(inv_desc->val[0]);
> +    switch (inv_desc->val[0] & VTD_INV_DESC_IOTLB_G) {
> +    case VTD_INV_DESC_PIOTLB_ALL_IN_PASID:
> +        vtd_piotlb_pasid_invalidate(s, domain_id, pasid);
> +        break;
> +
> +    case VTD_INV_DESC_PIOTLB_PSI_IN_PASID:
> +        am = VTD_INV_DESC_PIOTLB_AM(inv_desc->val[1]);
> +        addr = (hwaddr) VTD_INV_DESC_PIOTLB_ADDR(inv_desc->val[1]);
> +        if (am > VTD_MAMV) {

I saw this of spec 10.4.2, MAMV:

        Independent of value reported in this field, implementations
        supporting SMTS must support address-selective PASID-based
        IOTLB invalidations (p_iotlb_inv_dsc) with any defined address
        mask.

Does it mean we should even support larger AM?

Besides that, the patch looks good to me.

> +            error_report_once("Invalid am, > max am value, hi: 0x%" PRIx64
> +                    " lo: 0x%" PRIx64, inv_desc->val[1], inv_desc->val[0]);
> +            return false;
> +        }
> +        vtd_piotlb_page_invalidate(s, domain_id, pasid,
> +             addr, am, VTD_INV_DESC_PIOTLB_IH(inv_desc->val[1]));
> +        break;
> +
> +    default:
> +        error_report_once("Invalid granularity in P-IOTLB desc hi: 0x%" PRIx64
> +                  " lo: 0x%" PRIx64, inv_desc->val[1], inv_desc->val[0]);
> +        return false;
> +    }
> +    return true;
> +}
> +
>  static bool vtd_process_inv_iec_desc(IntelIOMMUState *s,
>                                       VTDInvDesc *inv_desc)
>  {
> @@ -3248,6 +3301,10 @@ static bool vtd_process_inv_desc(IntelIOMMUState *s)
>          break;
>  
>      case VTD_INV_DESC_PIOTLB:
> +        trace_vtd_inv_desc("p-iotlb", inv_desc.val[1], inv_desc.val[0]);
> +        if (!vtd_process_piotlb_desc(s, &inv_desc)) {
> +            return false;
> +        }
>          break;
>  
>      case VTD_INV_DESC_WAIT:
> diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
> index 6f32d7b..314e2c4 100644
> --- a/hw/i386/intel_iommu_internal.h
> +++ b/hw/i386/intel_iommu_internal.h
> @@ -457,6 +457,19 @@ typedef union VTDInvDesc VTDInvDesc;
>  #define VTD_INV_DESC_PASIDC_PASID_SI   (1ULL << 4)
>  #define VTD_INV_DESC_PASIDC_GLOBAL     (3ULL << 4)
>  
> +#define VTD_INV_DESC_PIOTLB_ALL_IN_PASID  (2ULL << 4)
> +#define VTD_INV_DESC_PIOTLB_PSI_IN_PASID  (3ULL << 4)
> +
> +#define VTD_INV_DESC_PIOTLB_RSVD_VAL0     0xfff000000000ffc0ULL
> +#define VTD_INV_DESC_PIOTLB_RSVD_VAL1     0xf80ULL
> +
> +#define VTD_INV_DESC_PIOTLB_PASID(val)    (((val) >> 32) & 0xfffffULL)
> +#define VTD_INV_DESC_PIOTLB_DID(val)      (((val) >> 16) & \
> +                                             VTD_DOMAIN_ID_MASK)
> +#define VTD_INV_DESC_PIOTLB_ADDR(val)     ((val) & ~0xfffULL)
> +#define VTD_INV_DESC_PIOTLB_AM(val)       ((val) & 0x3fULL)
> +#define VTD_INV_DESC_PIOTLB_IH(val)       (((val) >> 6) & 0x1)
> +
>  /* Information about page-selective IOTLB invalidate */
>  struct VTDIOTLBPageInvInfo {
>      uint16_t domain_id;
> -- 
> 2.7.4
> 

-- 
Peter Xu


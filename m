Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA941191896
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 19:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgCXSIH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 14:08:07 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:43077 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727366AbgCXSIG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 14:08:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585073285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o9VfLtJGvU0fUYHvZhFRdklkTco3oGHxaMAk7MxTBnM=;
        b=PMXp+sOUpsKQ/QTUEWP+lOaBSeO/kfcXbO6pduv+8YQQ1X5cGq3wjzpSADpWmrFw0vjf6f
        dfi3JvUevoNlSWDZf+VXil1tIzH3B4kLf3UAaI6LDb2T8XttOirs4h9jUpu2cEHSctO4ha
        59CsCK1FYacD+JVlIH3HaOrfqarzR70=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-xU1-6Sf0MbOu3WnNjIeE6w-1; Tue, 24 Mar 2020 14:08:03 -0400
X-MC-Unique: xU1-6Sf0MbOu3WnNjIeE6w-1
Received: by mail-wr1-f71.google.com with SMTP id p2so9585600wrw.8
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 11:08:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o9VfLtJGvU0fUYHvZhFRdklkTco3oGHxaMAk7MxTBnM=;
        b=ZQL10l+ZopNCBWHULohCbqLS68DJDc+ojZWBB9FG+rWYpc0ok3+8OtJxoP2t90k0gN
         Gx5NRFrcRTLeEolOf9+VTPDxirlmigndVjIBo1CKhMF5adCltpwipd9LeIjfYSl5KYxI
         DYyl8TESb0fR7FtgkQT/e0mDSqFz+1mBN6eMMvfOzA5k3+0JFhmni2cB62lbXoXh16pE
         85Y3v2FMylrPkRrlo+fEUwGT8SzjdcTZOvaR7KmFzvq+9/ptoStlHpQD0IjeElrGc53Y
         IgVYqVtLeJmY6HGyyQ6zq/EKoVdVjBzf5GxeU34oA/imkyPtDs/guduDEw9M/3XUhv9w
         mcgA==
X-Gm-Message-State: ANhLgQ2itI55nnw8XNLtEYnw9I7AnVwNtypVgJ25KmauwJEgOn4z7yDS
        k8SprkCre8eG01kda9mAW7EyW5cBiaKA9+JqezCAbr9ZZwJR8aGQ3BbByNWz6pl9/6p8pEG64BN
        QWChSNnkG9L3K
X-Received: by 2002:adf:e98a:: with SMTP id h10mr27948322wrm.370.1585073282523;
        Tue, 24 Mar 2020 11:08:02 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvE8lDc4aoctvV5poB+k76p6FHaiGufJuqzX/crtbLgsKOF//dAt/qo48ojBqgwBugtg6Du9g==
X-Received: by 2002:adf:e98a:: with SMTP id h10mr27948305wrm.370.1585073282349;
        Tue, 24 Mar 2020 11:08:02 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id c18sm28384987wrx.5.2020.03.24.11.07.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 11:08:01 -0700 (PDT)
Date:   Tue, 24 Mar 2020 14:07:55 -0400
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
Subject: Re: [PATCH v1 16/22] intel_iommu: replay pasid binds after context
 cache invalidation
Message-ID: <20200324180755.GA127076@xz-x1>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-17-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1584880579-12178-17-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 22, 2020 at 05:36:13AM -0700, Liu Yi L wrote:
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
>  hw/i386/intel_iommu.c          | 68 ++++++++++++++++++++++++++++++++++++++++++
>  hw/i386/intel_iommu_internal.h |  6 +++-
>  hw/i386/trace-events           |  1 +
>  3 files changed, 74 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
> index 8ec638f..1e0ccde 100644
> --- a/hw/i386/intel_iommu.c
> +++ b/hw/i386/intel_iommu.c
> @@ -68,6 +68,10 @@ static void vtd_address_space_refresh_all(IntelIOMMUState *s);
>  static void vtd_address_space_unmap(VTDAddressSpace *as, IOMMUNotifier *n);
>  
>  static void vtd_pasid_cache_reset(IntelIOMMUState *s);
> +static void vtd_replay_guest_pasid_bindings(IntelIOMMUState *s,
> +                                           uint16_t *did, bool is_dsi);
> +static void vtd_pasid_cache_devsi(IntelIOMMUState *s,
> +                                  VTDBus *vtd_bus, uint16_t devfn);
>  
>  static void vtd_panic_require_caching_mode(void)
>  {
> @@ -1865,6 +1869,8 @@ static void vtd_context_global_invalidate(IntelIOMMUState *s)
>       * VT-d emulation codes.
>       */
>      vtd_iommu_replay_all(s);
> +
> +    vtd_replay_guest_pasid_bindings(s, NULL, false);

I think the only uncertain thing is whether you still want to rework
the vtd_replay_guest_pasid_bindings() interface.  It'll depend on the
future discussion of previous patches.  Besides that this patch looks
good to me.

-- 
Peter Xu


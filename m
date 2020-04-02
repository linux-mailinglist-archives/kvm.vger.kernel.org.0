Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3DA19C88A
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 20:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733055AbgDBSJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 14:09:40 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42768 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728225AbgDBSJj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 14:09:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585850978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BYGlXLwwyBgS36YV5wEkNKPI/aX5YIakZvgpmmU8bos=;
        b=HegxnBPvIoH5Fhhvf8Rj89MlqIUtkqL8KQpexPL+Sh/WgET4yJNjVh0iaMcW1wL208+ltO
        9V0hhG5Wv7vapROUbzQKASvs0ddPQnM2uu4NQiVzQqLZoIXi/2W8Pz1m4kGH16vsOtfL0b
        +3Mn1b8O8Kz5BmrNkbFdnl/K68g6gOM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-gl87SGMBNN6EovTMUjJgug-1; Thu, 02 Apr 2020 14:09:28 -0400
X-MC-Unique: gl87SGMBNN6EovTMUjJgug-1
Received: by mail-wr1-f72.google.com with SMTP id l17so1835077wro.3
        for <kvm@vger.kernel.org>; Thu, 02 Apr 2020 11:09:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BYGlXLwwyBgS36YV5wEkNKPI/aX5YIakZvgpmmU8bos=;
        b=of7ySHP4eRJoiIcBOyG6CGSY6EttIWvxRKbzjSnisrXfncYlTC8IPTI/pIZZzF5bUA
         dCBDzBxyMusy36K8UAzfUZEMNcpEOTmSlHB05FDYcfGPhOSGRjy6omHr7xyAJbeMzHXh
         kq384s8u7rRatJLJovzGSE/SaEtxz3YASPOnWGHTdeQ48g1WgjutVMLFUZUAUFs3heoX
         LoYsoslUL5jqLoZCfIY8zjsy38dR4mVU+/in9Ji2RqlTsqffBQFpOFDifGwrRgD4Y8ym
         E/T7i4LDHeySksUq1cOXDPzJopNE/CeIHAWLuUIfM30MfmPflL4oIjXm/jjsLIPN57HG
         YgOg==
X-Gm-Message-State: AGi0PubkZn+e19/NpdFjDmFNsGoDPjsmrZfe/RByg91AosDTnQVDSATU
        1BV4sssd7QbcC0cdafzxUbzVGv2AIMFCQZGY5zXsxiahucnSjINerwFlevAPQCrsEIes03yD09z
        DGG1U68i6jgEq
X-Received: by 2002:a7b:c343:: with SMTP id l3mr4761401wmj.38.1585850966853;
        Thu, 02 Apr 2020 11:09:26 -0700 (PDT)
X-Google-Smtp-Source: APiQypLyG70A7UCR5fhQk5BBlq4+WqeXvaVHltohvb6yhXwm60j2oQgl8OXZkqzptTlvn5SGWC9XLQ==
X-Received: by 2002:a7b:c343:: with SMTP id l3mr4761369wmj.38.1585850966592;
        Thu, 02 Apr 2020 11:09:26 -0700 (PDT)
Received: from xz-x1 (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id n11sm9367892wrg.72.2020.04.02.11.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 11:09:25 -0700 (PDT)
Date:   Thu, 2 Apr 2020 14:09:20 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        eric.auger@redhat.com, pbonzini@redhat.com, mst@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        hao.wu@intel.com, jean-philippe@linaro.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v2 15/22] intel_iommu: bind/unbind guest page table to
 host
Message-ID: <20200402180920.GD103677@xz-x1>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-16-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1585542301-84087-16-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 29, 2020 at 09:24:54PM -0700, Liu Yi L wrote:
> +static int vtd_bind_guest_pasid(IntelIOMMUState *s, VTDBus *vtd_bus,
> +                                int devfn, int pasid, VTDPASIDEntry *pe,
> +                                VTDPASIDOp op)
> +{
> +    VTDHostIOMMUContext *vtd_dev_icx;
> +    HostIOMMUContext *iommu_ctx;
> +    DualIOMMUStage1BindData *bind_data;
> +    struct iommu_gpasid_bind_data *g_bind_data;
> +    int ret = -1;
> +
> +    vtd_dev_icx = vtd_bus->dev_icx[devfn];
> +    if (!vtd_dev_icx) {
> +        /* means no need to go further, e.g. for emulated devices */
> +        return 0;
> +    }
> +
> +    iommu_ctx = vtd_dev_icx->iommu_ctx;
> +    if (!iommu_ctx) {
> +        return -EINVAL;
> +    }
> +
> +    if (!(iommu_ctx->stage1_formats
> +             & IOMMU_PASID_FORMAT_INTEL_VTD)) {
> +        error_report_once("IOMMU Stage 1 format is not compatible!\n");
> +        return -EINVAL;
> +    }
> +
> +    bind_data = g_malloc0(sizeof(*bind_data));
> +    bind_data->pasid = pasid;
> +    g_bind_data = &bind_data->bind_data.gpasid_bind;
> +
> +    g_bind_data->flags = 0;
> +    g_bind_data->vtd.flags = 0;
> +    switch (op) {
> +    case VTD_PASID_BIND:
> +        g_bind_data->version = IOMMU_UAPI_VERSION;
> +        g_bind_data->format = IOMMU_PASID_FORMAT_INTEL_VTD;
> +        g_bind_data->gpgd = vtd_pe_get_flpt_base(pe);
> +        g_bind_data->addr_width = vtd_pe_get_fl_aw(pe);
> +        g_bind_data->hpasid = pasid;
> +        g_bind_data->gpasid = pasid;
> +        g_bind_data->flags |= IOMMU_SVA_GPASID_VAL;
> +        g_bind_data->vtd.flags =
> +                             (VTD_SM_PASID_ENTRY_SRE_BIT(pe->val[2]) ? 1 : 0)

This evaluates to 1 if VTD_SM_PASID_ENTRY_SRE_BIT(pe->val[2]), or 0.
Do you want to use IOMMU_SVA_VTD_GPASID_SRE instead of 1?  Same
question to all the rest.

> +                           | (VTD_SM_PASID_ENTRY_EAFE_BIT(pe->val[2]) ? 1 : 0)
> +                           | (VTD_SM_PASID_ENTRY_PCD_BIT(pe->val[1]) ? 1 : 0)
> +                           | (VTD_SM_PASID_ENTRY_PWT_BIT(pe->val[1]) ? 1 : 0)
> +                           | (VTD_SM_PASID_ENTRY_EMTE_BIT(pe->val[1]) ? 1 : 0)
> +                           | (VTD_SM_PASID_ENTRY_CD_BIT(pe->val[1]) ? 1 : 0);
> +        g_bind_data->vtd.pat = VTD_SM_PASID_ENTRY_PAT(pe->val[1]);
> +        g_bind_data->vtd.emt = VTD_SM_PASID_ENTRY_EMT(pe->val[1]);
> +        ret = host_iommu_ctx_bind_stage1_pgtbl(iommu_ctx, bind_data);
> +        break;
> +    case VTD_PASID_UNBIND:
> +        g_bind_data->version = IOMMU_UAPI_VERSION;
> +        g_bind_data->format = IOMMU_PASID_FORMAT_INTEL_VTD;
> +        g_bind_data->gpgd = 0;
> +        g_bind_data->addr_width = 0;
> +        g_bind_data->hpasid = pasid;
> +        g_bind_data->gpasid = pasid;
> +        g_bind_data->flags |= IOMMU_SVA_GPASID_VAL;
> +        ret = host_iommu_ctx_unbind_stage1_pgtbl(iommu_ctx, bind_data);
> +        break;
> +    default:
> +        error_report_once("Unknown VTDPASIDOp!!!\n");
> +        break;
> +    }
> +
> +    g_free(bind_data);
> +
> +    return ret;
> +}

-- 
Peter Xu


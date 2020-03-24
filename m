Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 979AC191948
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 19:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgCXSgU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 14:36:20 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:45735 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727267AbgCXSgU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 14:36:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585074979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i4A/xqWSGLtPDET9zjSQHOttB/0+koxppHPGSrmNT/M=;
        b=FT2BC/JpMmzKCcZFk7a3uZGGu9BOqNxYq1S/kQzEMCtHjbyHh/+PA8EPGgMusWCD60nUiM
        UpMTZcXcUCM83xojzu4Ttf76N3YML63GeQBsYkBrAhOjJV1+IDvPtWOvXoY4yiPkzWF7uX
        04TGcumMzCitjHVp4KfRodaZN8E+lI4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-g0jmaSRDOfS9frMUe7aQHA-1; Tue, 24 Mar 2020 14:36:18 -0400
X-MC-Unique: g0jmaSRDOfS9frMUe7aQHA-1
Received: by mail-wr1-f72.google.com with SMTP id y1so4645180wrn.10
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 11:36:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i4A/xqWSGLtPDET9zjSQHOttB/0+koxppHPGSrmNT/M=;
        b=P5ihk7dvDHPuB1Qnb+Q/mu2YS1UcVqnoAdfpKd4+cLk20s1D6bDuW5kxsDwvnNQiOR
         OscbBAOljArNnePkhrEWvUKHlZQnL7nby38ku5RagnTGiYEtrL4tYxmyIGRVA50/XFOj
         yYLQZtdrw1t32pkTAPCADoAVblNXtiGGH1kKYjNNu/EHV5GnkqspvwkEBd04/lfADD9W
         kQWl8xbSg3PM4V0szNN5ocabB5DwQVeJdkNOqXppTGRwXUYBq5H2O5Lo0CyGhCTIr6kg
         FJ6nm+8HWMfzvpO2B/DqcA6tfolQ4GLf1Xsph2pX3mvJCsryxcKbitFW+UBmlidXfvh9
         UASQ==
X-Gm-Message-State: ANhLgQ3pPWwOrtA8x0WMU3ht9SgVC8V5yOhFt5TdvRGOyErnz+LnWo0+
        WjJebD8FW9zDHCfdwv/mbCwwgtdDJuheVni/btsjc9tSb4dHv3MfsuILa9cnRk7u6wfYO5GOKcL
        hof6sUOOPi2nc
X-Received: by 2002:a5d:4acd:: with SMTP id y13mr3531506wrs.61.1585074976858;
        Tue, 24 Mar 2020 11:36:16 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vswjB7Y+RnrWBQSeLWj9J4uwH9jrlwONHl7Gfp7nEUBIP16iMzsQGvZ9SX3IEZQ+jsiACKa8g==
X-Received: by 2002:a5d:4acd:: with SMTP id y13mr3531473wrs.61.1585074976615;
        Tue, 24 Mar 2020 11:36:16 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id b15sm29609833wru.70.2020.03.24.11.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 11:36:15 -0700 (PDT)
Date:   Tue, 24 Mar 2020 14:36:11 -0400
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
Subject: Re: [PATCH v1 21/22] intel_iommu: process PASID-based Device-TLB
 invalidation
Message-ID: <20200324183611.GF127076@xz-x1>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-22-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1584880579-12178-22-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 22, 2020 at 05:36:18AM -0700, Liu Yi L wrote:
> This patch adds an empty handling for PASID-based Device-TLB
> invalidation. For now it is enough as it is not necessary to
> propagate it to host for passthru device and also there is no
> emulated device has device tlb.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Eduardo Habkost <ehabkost@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>

OK this patch seems to be mostly meaningless... but OK since you've
wrote it... :)

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


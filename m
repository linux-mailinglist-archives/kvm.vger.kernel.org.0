Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF3F42AA56
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 19:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbhJLROy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 13:14:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38504 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229495AbhJLROy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 13:14:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634058771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=00X4So4uR796Ea/bPKg+767c04yNCwEu1JrgohdW37E=;
        b=OofNkGWN0KM53v+cUo1t6r2cBOnAZBqJqA4nkVDhY/nfe97eCCPdoPTQYPWkRxF4CmTYLR
        kS84tEr3fqRHUWS1V0ygvjDgsn4kDufeyt8UjumhPti8RQNfeigzIz8BfhYXLT2MebbhkV
        z21id17bF2+kARcZq6mDp38+FmALdvc=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-fcZU_vZIPZeJkJnaCdwl6Q-1; Tue, 12 Oct 2021 13:12:50 -0400
X-MC-Unique: fcZU_vZIPZeJkJnaCdwl6Q-1
Received: by mail-oo1-f72.google.com with SMTP id w1-20020a4a2741000000b002b6eb5b596cso4110761oow.9
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 10:12:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=00X4So4uR796Ea/bPKg+767c04yNCwEu1JrgohdW37E=;
        b=ncv/UsZzcZaaQI3sEKTz19I/8s6nCssKA6QP5/ZAhhY0dhdwxU6W1Q03J6hqeEDhTI
         7xdnlSdn5vccjPEqLjRTYXd6eIiTVyCCxix+7gI9BQXjzOBLPeK9e2f1wGlEUIyfHnF4
         SkjQd09QaTmECMDap+XmEASz5ayih0qufO0Xono7nuCv3Xa6Poxz7D+hT/mxXIyo0mHk
         ctdpSrQq5I1BvMno5OlR1lEe18UFHpQGNcICLeD78GC63hswi2TvHeV4kxIgRjVi2RXs
         m9AD7HCb8p4FBvquHgNElbxoTZckAg1A7Ha6xiFLJ68MG24J4lFaxzCfK3tfR5h1bCD4
         3YDw==
X-Gm-Message-State: AOAM530FSeMLNUI0JNvEHHY7Q5sWc45JTOniCAa6kKG3w6vNca/bmHeJ
        Zb2Ql86qqYWNJZepWKAjzf+3FvyLiaTvDVgUj186ekmazQ6RS1Sg4z6rS4d/TkhDBpWKnyidknu
        h6DorkLnfog7m
X-Received: by 2002:aca:31cb:: with SMTP id x194mr4423820oix.62.1634058769652;
        Tue, 12 Oct 2021 10:12:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzAkhUVgHdqGmXKPNJMLXqF6ENjzLpbK7YE2BQ5OOkbFwbeAF3cU/sBeFZP1L934L6i/d+J2Q==
X-Received: by 2002:aca:31cb:: with SMTP id x194mr4423812oix.62.1634058769466;
        Tue, 12 Oct 2021 10:12:49 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id k2sm2183817oot.37.2021.10.12.10.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 10:12:49 -0700 (PDT)
Date:   Tue, 12 Oct 2021 11:12:48 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Colin Xu <colin.xu@gmail.com>
Cc:     kvm@vger.kernel.org, colin.xu@intel.com, zhenyuw@linux.intel.com,
        hang.yuan@linux.intel.com, swee.yee.fonn@intel.com,
        fred.gao@intel.com
Subject: Re: [PATCH v8] vfio/pci: Add OpRegion 2.0+ Extended VBT support.
Message-ID: <20211012111248.2314ad0b.alex.williamson@redhat.com>
In-Reply-To: <20211012124855.52463-1-colin.xu@gmail.com>
References: <20211011154459.21f9b477.alex.williamson@redhat.com>
        <20211012124855.52463-1-colin.xu@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Oct 2021 20:48:55 +0800
Colin Xu <colin.xu@gmail.com> wrote:

> From: Colin Xu <colin.xu@intel.com>
> 
> Due to historical reason, some legacy shipped system doesn't follow
> OpRegion 2.1 spec but still stick to OpRegion 2.0, in which the extended
> VBT is not contiguous after OpRegion in physical address, but any
> location pointed by RVDA via absolute address. Also although current
> OpRegion 2.1+ systems appears that the extended VBT follows OpRegion,
> RVDA is the relative address to OpRegion head, the extended VBT location
> may change to non-contiguous to OpRegion. In both cases, it's impossible
> to map a contiguous range to hold both OpRegion and the extended VBT and
> expose via one vfio region.
> 
> The only difference between OpRegion 2.0 and 2.1 is where extended
> VBT is stored: For 2.0, RVDA is the absolute address of extended VBT
> while for 2.1, RVDA is the relative address of extended VBT to OpRegion
> baes, and there is no other difference between OpRegion 2.0 and 2.1.
> To support the non-contiguous region case as described, the updated read
> op will patch OpRegion version and RVDA on-the-fly accordingly. So that
> from vfio igd OpRegion view, only 2.1+ with contiguous extended VBT
> after OpRegion is exposed, regardless the underneath host OpRegion is
> 2.0 or 2.1+. The mechanism makes it possible to support legacy OpRegion
> 2.0 extended VBT systems with on the market, and support OpRegion 2.1+
> where the extended VBT isn't contiguous after OpRegion.
> 
> V2:
> Validate RVDA for 2.1+ before increasing total size. (Alex)
> 
> V3: (Alex)
> Split read and write ops.
> On-the-fly modify OpRegion version and RVDA.
> Fix sparse error on assign value to casted pointer.
> 
> V4: (Alex)
> No need support write op.
> Direct copy to user buffer with several shift instead of shadow.
> Copy helper to copy to user buffer and shift offset.
> 
> V5: (Alex)
> Simplify copy help to only cover common shift case.
> Don't cache patched version and rvda. Patch on copy if necessary.
> 
> V6:
> Fix comment typo and max line width.
> 
> V7:
> Keep bytes to copy/remain as size_t.
> Proper shift byte address on copy source.
> Rebase to linux-next.
> 
> V8:
> Replace min() with min_t() to avoid type cast.
> Wrap long lines.
> 
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Cc: Hang Yuan <hang.yuan@linux.intel.com>
> Cc: Swee Yee Fonn <swee.yee.fonn@intel.com>
> Cc: Fred Gao <fred.gao@intel.com>
> Signed-off-by: Colin Xu <colin.xu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_igd.c | 234 ++++++++++++++++++++++++--------
>  1 file changed, 175 insertions(+), 59 deletions(-)

Looks good, applied to vfio next branch for v5.16.  Thanks,

Alex


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8612C159A68
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 21:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731791AbgBKURf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 15:17:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54381 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728021AbgBKURf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 15:17:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581452254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2n1XuFh1TfPRhW8BtVWDxws+sMTjPmhnwZU8q2safFI=;
        b=R8dn+eyu4RFdzpf6ZFXKQTSwzWS2WRRe6hEmsw7prDa7X2pQL7DQnuBe6eFaaeR4i267Qy
        nRYlsyLetzkKOCJiGdAxgEen1C17fWs63t318KcP0Cp1j64MkuDAk++diOnTyAvgwC1dla
        h1UbptDIgY7TogBioQEesOAqFw+1NL8=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-yaEaGwPYNXSYWIjykJ7_qw-1; Tue, 11 Feb 2020 15:17:32 -0500
X-MC-Unique: yaEaGwPYNXSYWIjykJ7_qw-1
Received: by mail-qk1-f200.google.com with SMTP id q135so7949449qke.22
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 12:17:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2n1XuFh1TfPRhW8BtVWDxws+sMTjPmhnwZU8q2safFI=;
        b=aJKWOTs/EyJmvUFwGfeO7d+sjme2KAqyopWhj88fV1uoaMGeJBUGeBRWbSGVLTFCY9
         Nm3fjQFlEq3jGo/ueXrRWAVfxPza4If3PuYWVtY/ckctA+WTX670feiD95b9TxMZ8lxc
         ctJ8ViT+V1icq9oD2NhKZIkrq6eNUB7gdtrsNPH2j1Arj0utDsuXTnH5w0QEOb4c/NMF
         2nKL8PZyE3WLPO6wBQeD/RrgR9XSiIx60GQFJ3x2ZR683fPqes6sv33xjnv2bmCpyMG7
         WgyQQh+2bb4rSyjsBL7O6OxXRlk/0ml+Ymt6N4JIi7A2q3ffp8UVcu1ndVtoA6pkbv7e
         nS+Q==
X-Gm-Message-State: APjAAAVzA4NB2DsM4RkswkIYRPmvLdrMP+RMkogwYONurh5H/MqClV7y
        xCZmeWvO5sB8jG3H8LyAql2IQafnxRDcm+5jKL4tjlHj1sd4Wzuw2ma1aB+nVijr4SED2BpEmBr
        BnGbLVjj6KDCA
X-Received: by 2002:ac8:70d5:: with SMTP id g21mr16029171qtp.46.1581452251962;
        Tue, 11 Feb 2020 12:17:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqzPgOox0hoFSqBwyM/SG+T29FHEd69AnhPYMbf1Hp8+R4QUO+KGBpbRLIGWBg/HA0g58mdBtg==
X-Received: by 2002:ac8:70d5:: with SMTP id g21mr16029153qtp.46.1581452251773;
        Tue, 11 Feb 2020 12:17:31 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id 8sm2582400qkm.92.2020.02.11.12.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 12:17:30 -0800 (PST)
Date:   Tue, 11 Feb 2020 15:17:28 -0500
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
Subject: Re: [RFC v3 15/25] intel_iommu: process pasid cache invalidation
Message-ID: <20200211201728.GM984290@xz-x1>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-16-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1580300216-86172-16-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 29, 2020 at 04:16:46AM -0800, Liu, Yi L wrote:
> From: Liu Yi L <yi.l.liu@intel.com>
> 
> This patch adds PASID cache invalidation handling. When guest enabled
> PASID usages (e.g. SVA), guest software should issue a proper PASID
> cache invalidation when caching-mode is exposed. This patch only adds
> the draft handling of pasid cache invalidation. Detailed handling will
> be added in subsequent patches.
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


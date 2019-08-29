Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35920A0F63
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 04:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfH2CJr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 22:09:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45012 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbfH2CJr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 22:09:47 -0400
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 42234C054907
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 02:09:47 +0000 (UTC)
Received: by mail-pf1-f199.google.com with SMTP id w16so1238116pfn.12
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 19:09:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cWz9sGB+WBliUQqYKGmTy4CKie+Spvd6Fx2kg3YzjVg=;
        b=hivCUaD0Iv29NrgcLJEn/yinv5qfs5Ad5FByrvoIBfpc1Wq3QRe7VNJuQMZ1m/mH7+
         gudxZLJytfNZVOrcIKdVlwbSx1uyvRV+CcTAcobDhP3Q6P5Iz+7nFhUemocUJ7SA3lqC
         vq7yWNuPat19iWauEfEQ4nN6Fo7LcPC0sLA8ImEwuNB8k8YM0gXqMP/CIH+4vZN5J432
         JlUkdeLxTiPVPXRIOGkSrcc1jxyQrkQtfyuyMoAF+N7A1hS9vO8EVc21GtTituV/5RGz
         pG9/o9AhCD78ocgwmWvOlMP//A9WR2AE+YYhv4JmPl3leNQgtBC7CmlWtqOgbxaiJmyw
         0vTQ==
X-Gm-Message-State: APjAAAXF++EiCHlAoAWmQwuIzwXwrKZhc//BDW3Qld5BVsNfTaijHa5g
        UlIrwC8FjYDpuxpcUkeCgpXIvlxaaOG1AZHBSUbNWP791eR4UB94iWtupfcgDEUIOPxxSyA/bAy
        8PRmxs1zcOw3L
X-Received: by 2002:a17:90a:fa95:: with SMTP id cu21mr7538036pjb.43.1567044586744;
        Wed, 28 Aug 2019 19:09:46 -0700 (PDT)
X-Google-Smtp-Source: APXvYqydpBl4a4u3UFZMu8NHSxmpgKb5IpM9yElt8QSTfIHghvIUhueai7ynoRWwLrFVTt0WrknE2Q==
X-Received: by 2002:a17:90a:fa95:: with SMTP id cu21mr7538021pjb.43.1567044586575;
        Wed, 28 Aug 2019 19:09:46 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x128sm772805pfd.52.2019.08.28.19.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 19:09:45 -0700 (PDT)
Date:   Thu, 29 Aug 2019 10:09:35 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 4/4] KVM: selftests: Remove duplicate guest mode handling
Message-ID: <20190829020935.GG8729@xz-x1>
References: <20190827131015.21691-1-peterx@redhat.com>
 <20190827131015.21691-5-peterx@redhat.com>
 <20190828114613.a2rvpip45c3ywdnj@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190828114613.a2rvpip45c3ywdnj@kamzik.brq.redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 28, 2019 at 01:46:13PM +0200, Andrew Jones wrote:

[...]

> > +unsigned int vm_get_page_size(struct kvm_vm *vm)
> > +{
> > +	return vm->page_size;
> > +}
> > +
> > +unsigned int vm_get_page_shift(struct kvm_vm *vm)
> > +{
> > +	return vm->page_shift;
> > +}
> 
> We could get by with just one of the above two, but whatever

Right... and imho if we export kvm_vm struct we don't even any
helpers. :) But I didn't touch that.

> > +
> > +unsigned int vm_get_max_gfn(struct kvm_vm *vm)
> > +{
> > +	return vm->max_gfn;
> > +}
> > -- 
> > 2.21.0
> >
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks!

-- 
Peter Xu

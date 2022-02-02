Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8964A76E0
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 18:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346280AbiBBRar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 12:30:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:20638 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234244AbiBBRaq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Feb 2022 12:30:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643823046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ARK8JuI2/Z9yWWBIIvnvP+Vpd7t0FPVLNXUAPYXWbuU=;
        b=hFeVprcL/10GhwCpsDvDePSHjS98W7gkt7GiE4sXiD6QRtVcvjB59aubVfC4F5NrkITOzy
        V6e2W+9YHU3J/TSddKlD/h9LH6rsgXmCsTm6ILeF7hVbZpXK4haVfTMlhpMzTnKRGHtlb6
        j7haFdjDNMlrlyK9XcFNOXbFHcgdhME=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-RBVSsbr7OGmonRfw7FPeOw-1; Wed, 02 Feb 2022 12:30:45 -0500
X-MC-Unique: RBVSsbr7OGmonRfw7FPeOw-1
Received: by mail-oi1-f197.google.com with SMTP id bq20-20020a05680823d400b002cf93c09f23so9149805oib.1
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 09:30:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ARK8JuI2/Z9yWWBIIvnvP+Vpd7t0FPVLNXUAPYXWbuU=;
        b=sNDh/9nBG5dtLnImCrG6j+3geSEEyXbSucm0oDvB7dTHNSEyE52LUxx4NM5a6CeymX
         wyq5e6nx0jIbGCbajEFFZ6cXj816nqk4BeCg8ev+xSwBOiQTz7IPIqoEOQ9+iFaat36l
         zmKyTCSLxLRXDE3gFHDo3gi1olFP4agc4GfMM6uFwzJgsHJIg23b20hSvsbyG7l70MH1
         cP0fmWKr8nnTYtmhWY97WAoY5KI4saTM05goVYFRtR+ZTRYvOCf2ls0o3NEYHItE9kT6
         XJRq9ZteNxIZYL6pw2GNqODicj5R/XlXFTGOYfXpdAsHVMKgUlHF5WL4EMuoy4L2L01b
         8Uuw==
X-Gm-Message-State: AOAM530KHdh319J43L34i6pXlH603qVgeAOTfy3Bn3p77AKUr3xuzPUb
        mPC0/c6WzoH5UJXcnDiWHkyINDvkkchUY+CS2Tkps9LiI5hxrd6iKgWAimDi9UWZZs77TbWtFd5
        Z7x4DTPG+hVVU
X-Received: by 2002:a9d:226b:: with SMTP id o98mr17394670ota.125.1643823043030;
        Wed, 02 Feb 2022 09:30:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxa1ulr875j7x7Dy544lRgUzL/mvKbrd24FxjT+1UwW5AH4hYjxYo2X7ptav2DX65k3R2wHSA==
X-Received: by 2002:a9d:226b:: with SMTP id o98mr17394656ota.125.1643823042832;
        Wed, 02 Feb 2022 09:30:42 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id 6sm19835290oig.29.2022.02.02.09.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 09:30:42 -0800 (PST)
Date:   Wed, 2 Feb 2022 10:30:41 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
Message-ID: <20220202103041.2b404d13.alex.williamson@redhat.com>
In-Reply-To: <a29ae3ea51344e18b9659424772a4b42@huawei.com>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
        <20220202131448.GA2538420@nvidia.com>
        <a29ae3ea51344e18b9659424772a4b42@huawei.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2 Feb 2022 14:34:52 +0000
Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:

> > -----Original Message-----
> > From: Jason Gunthorpe [mailto:jgg@nvidia.com]
> 
> > 
> >    I see pf_qm_state_pre_save() but didn't understand why it wanted to
> >    send the first 32 bytes in the PRECOPY mode? It is fine, but it
> >    will add some complexity to continue to do this.  
> 
> That was mainly to do a quick verification between src and dst compatibility
> before we start saving the state. I think probably we can delay that check
> for later.

In the v1 migration scheme, this was considered good practice.  It
shouldn't be limited to PRECOPY, as there's no requirement to use
PRECOPY, but the earlier in the migration process that we can trigger a
device or data stream compatibility fault, the better.  TBH, even in
the case where a device doesn't support live dirty tracking for a
PRECOPY phase, using it for compatibility testing continues to seem
like good practice.  Thanks,

Alex


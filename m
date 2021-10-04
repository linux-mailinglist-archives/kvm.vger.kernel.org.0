Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E386942092C
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 12:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhJDKP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 06:15:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42675 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231575AbhJDKP4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 06:15:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633342447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DQy3hcmEG7f8p0XG7+HQIaO0VC6GZhQxwlTyx9Ls2o8=;
        b=DcTMgRFP0aJ6s8KATFUTjUECkBE8aVOY1rdWWhX60kvLcZ8iECMkGdvPV83ePvU4cIOjbj
        z4fNQwL5lOgANoBQCM8MtVpFZVNUlpA+UhmoXA4UZ1fDLf9p+JCUF8B4qqZ3lz/3/EZCqO
        1MVQKaFHy3EGfoaqm3K3HHJr3xLO5Zc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-UP35Tcj_Pc6aqcMrnITMpA-1; Mon, 04 Oct 2021 06:14:06 -0400
X-MC-Unique: UP35Tcj_Pc6aqcMrnITMpA-1
Received: by mail-wm1-f72.google.com with SMTP id d12-20020a1c730c000000b0030b4e0ecf5dso4638227wmb.9
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 03:14:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DQy3hcmEG7f8p0XG7+HQIaO0VC6GZhQxwlTyx9Ls2o8=;
        b=p35NZgZDkTnvi1q6D5XnIQ6hs2S4i+k0FRPI4NwNHo6tVpg5Gyhx0wo+/cVgkj4pAE
         mULPuFiha7bF9PVIJ2/vURnjsooAOlMS0HFRky2MQlSUq8SbjzRSeYcDfklGAVf5YaCd
         KaJ1IAdJYL10GQQYr54DL5u2yf3M3mlNBhAEO6ajrcgptpUXSrvPRHUukyv1YVcQgknT
         OnYXhsp0P/5zT7FSxruDESPh+LJZHYVTTtjUFz1WWVEei/aIhUzNwVRadOGlfVGC/S27
         xgClcA1jYGF5G/eF/sBxfs5ClsQ1u6LZH/7Ls5MAgU6/vk0DlVWubbnjz16MA6wQAZhe
         1J6Q==
X-Gm-Message-State: AOAM530x5gqLT3WjS4C4HihXGmF3p3GZ3Fb7VQuVrRYmbj8L3xI7nNlw
        ImXjRb4mU5xabkm3SO71hS7nObaS6pthTqkl7i3hV1CGOYGqM7fjL6eco/roUd+XpLuepMOv7/7
        LUSpGa0ymfyUl
X-Received: by 2002:adf:9bc9:: with SMTP id e9mr7896343wrc.388.1633342445246;
        Mon, 04 Oct 2021 03:14:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6xmecZPd8EJ7UEjc/MNxBc0yktAFhzsCIEptziVSR332G2Q0OLjV37vXubMNa2VB7PxiVzw==
X-Received: by 2002:adf:9bc9:: with SMTP id e9mr7896330wrc.388.1633342445124;
        Mon, 04 Oct 2021 03:14:05 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id l21sm7802830wmg.18.2021.10.04.03.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 03:14:04 -0700 (PDT)
Date:   Mon, 4 Oct 2021 12:14:03 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     qemu-devel@nongnu.org, Eric Auger <eric.auger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH v2 2/5] hw/arm/virt: Add a control for the the highmem
 redistributors
Message-ID: <20211004101403.i65r26cc22a5ktqi@gator>
References: <20211003164605.3116450-1-maz@kernel.org>
 <20211003164605.3116450-3-maz@kernel.org>
 <20211004094408.xfftmls7h6bbypuk@gator>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004094408.xfftmls7h6bbypuk@gator>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 04, 2021 at 11:44:08AM +0200, Andrew Jones wrote:
> On Sun, Oct 03, 2021 at 05:46:02PM +0100, Marc Zyngier wrote:
...
> >  
> > -    return MACHINE(vms)->smp.cpus > redist0_capacity ? 2 : 1;
> > +    return (MACHINE(vms)->smp.cpus > redist0_capacity &&
> > +            vms->highmem_redists) ? 2 : 1;
> 
> Wouldn't it be equivalent to just use vms->highmem here?

OK, I see in the last patch that we may disable highmem_redists
but not highmem.

In that case,

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew


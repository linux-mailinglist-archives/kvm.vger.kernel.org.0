Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407CD36CE81
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 00:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236742AbhD0WPY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 18:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235558AbhD0WPX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 18:15:23 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C602EC06175F
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 15:14:10 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id i190so2754412pfc.12
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 15:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b9OCs7id8pi+ryQexV1IMMjOOnzy/IfZRKUbhiicKKA=;
        b=hGIytqWalDSz4yo3XfkJ/bVJqyWnwevkDw3bFScVmX49bg82lVNb67laTVt9GgKYVA
         jr2f+oN7zauoUoyzQzijkFt7GaEchn7QeUtoTvVj9/rztZbBT+uxSZw7ZtoVCZoU4xSE
         jvFSipsS3bn+/Fp6/1FtypxVnvtOg5WQXKQvdl3xCUem2XgtfAe3Z9lLwXTPSb8NMnOn
         DPDdcv1Nhvr3Am5Yl1Og7oZHgL026V4T6NSWQQcm8VxCPh2aSaq1Rbk1qT4Z+cPUcJeT
         CUfR0q0MlWtsT9/+XP6Lq+LlOKUhZQyJKIFA/tZa/axiIMC73+rPN9eq55BrZmKXPtCG
         f26g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b9OCs7id8pi+ryQexV1IMMjOOnzy/IfZRKUbhiicKKA=;
        b=Spa6ycWtoJGnrfVIDooz5IENV5GSZqpRJOTS54IH0NLqyaUYOKM7iDxiZI/CHUJoar
         4MDEe2DORH29cwPrTwUvGvX2pUWB+5MTVmMc7b9B8SNFyea0NGUmwhCTAOP0339sDTO9
         u2+z6Qhn5//8c8gIw5ajodkp7KWtVPH7llWvferiom6Fsc7qN1mS6NZvnNgNHoby6DDQ
         ES7RUNz1GXSWVlQohtJoP8JQqOGLi7JSe/88DoWsBt4moGyrRp8IOM39Ur5PJy1q9Rde
         yMTU61cGBFR8V8wqk5pvyETvHgwSvacGwJuDUDO4SBlySNndQsDm5H2doTQfGEzozOX2
         4rwA==
X-Gm-Message-State: AOAM532eM4Ej0DWhiGLK6vgfVnGm8PWfRTwVx3c8MPmMPwZ9Ja2I8HXC
        ruKh3ak2cP384uRF50VMGHRJSw==
X-Google-Smtp-Source: ABdhPJy4660WUs5Ni83P8/+zXwwtdfeeVFWNVff8ZfmIG26kfRA/VFq5xfN7UnxFv90k9fhYDX6+uA==
X-Received: by 2002:a05:6a00:162c:b029:22b:4491:d63a with SMTP id e12-20020a056a00162cb029022b4491d63amr25393295pfc.28.1619561649963;
        Tue, 27 Apr 2021 15:14:09 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id p10sm3205358pfo.210.2021.04.27.15.14.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 15:14:09 -0700 (PDT)
Date:   Tue, 27 Apr 2021 22:14:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        srutherford@google.com, joro@8bytes.org, brijesh.singh@amd.com,
        thomas.lendacky@amd.com, venu.busireddy@oracle.com
Subject: Re: [PATCH v2 2/2] KVM: x86: add MSR_KVM_MIGRATION_CONTROL
Message-ID: <YIiMrWS60NuesU63@google.com>
References: <20210421173716.1577745-1-pbonzini@redhat.com>
 <20210421173716.1577745-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421173716.1577745-3-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 21, 2021, Paolo Bonzini wrote:
> Add a new MSR that can be used to communicate whether the page
> encryption status bitmap is up to date and therefore whether live
> migration of an encrypted guest is possible.
> 
> The MSR should be processed by userspace if it is going to live
> migrate the guest; the default implementation does nothing.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

...

> @@ -91,6 +93,8 @@ struct kvm_clock_pairing {
>  /* MSR_KVM_ASYNC_PF_INT */
>  #define KVM_ASYNC_PF_VEC_MASK			GENMASK(7, 0)
>  
> +/* MSR_KVM_MIGRATION_CONTROL */
> +#define KVM_PAGE_ENC_STATUS_UPTODATE		(1 << 0)

Why explicitly tie this to encryption status?  AFAICT, doing so serves no real
purpose and can only hurt us in the long run.  E.g. if a new use case for
"disabling" migration comes along and it has nothing to do with encryption, then
it has the choice of either using a different bit or bastardizing the existing
control.

I've no idea if such a use case is remotely likely to pop up, but allowing for
such a possibility costs us nothing.

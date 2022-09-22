Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25EB95E6EC1
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 23:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbiIVVs0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 17:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiIVVsY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 17:48:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB57ED5EA
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 14:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663883303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eClHEiaGY+V73ww0FsJUa6mh3+Y82NAzO9R+KDs/BPU=;
        b=fVfc/v+Npkll3fvesXY5If9pePJ+2xO8V3ABHt+lx6SoNisqOvLU09toHPsjVwR8/CWGs0
        Je9J61BSLaRmZt1yRXfMvehhyAryqmYcKPBu3kf8i8td3djLsH04wEjWHkK84l7LErdGqf
        rWXKwPe0GrngQc4KJiGY3eiK0vblZbY=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-428-8c7EWjs6M-ehJpDNt0kJBQ-1; Thu, 22 Sep 2022 17:48:22 -0400
X-MC-Unique: 8c7EWjs6M-ehJpDNt0kJBQ-1
Received: by mail-qk1-f197.google.com with SMTP id bj42-20020a05620a192a00b006cf663bca6aso1807441qkb.3
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 14:48:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=eClHEiaGY+V73ww0FsJUa6mh3+Y82NAzO9R+KDs/BPU=;
        b=8PMyyGM6wOa61bpF9Be35Bfi0eVX0kJBdqofO9L0ubN/yU84u+tsu3NVoyHNczN1a4
         sY0Vie8A/4EBfgzwlq2CpxLRVqXLCe6N29JgZrHnWjgq3Ep6EnRgdkZiodpXAAmp94kD
         ivukJ8e7Z0toAZJGg6nUaO86yC8LC6w6Py4vUKPAC7eiLHZ2HCL4ns/2liAGo5TAqxIM
         oSuqPECFXe2wKhYUWUn8AweLYyC02xajUQQeDbF2+LAgWTkKVzGGVWElwbDjYmvxDLh6
         HkAtp9W5JMnV4FnKZr4J3YV+TsYEgJq1rYuKqhs3BnlKgj81VyMLFUkb9ovWHlKp4Hgo
         Y+cg==
X-Gm-Message-State: ACrzQf3rQ8oOY1/5xW/vOV4lKZ6sFLOgFc2hsO3eHyGnr1fzXK4Oj9gY
        PM3QkPMgdaFDT5j8aIPMyUneM/xoCVpwx0OWQC0pU32ksEsXNHjOrquKIiBSne0xYxdjLU6nj6y
        oDUptYxyw3O95
X-Received: by 2002:a05:620a:4e3:b0:6cf:427b:c20b with SMTP id b3-20020a05620a04e300b006cf427bc20bmr3680503qkh.164.1663883301757;
        Thu, 22 Sep 2022 14:48:21 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6JiazJoJ7P1B2iQiBzeghsaJe7Quv/mrNWuNPqUxoRHJU/QK2FCPX/n64KpWw2fHGBa9Wv3w==
X-Received: by 2002:a05:620a:4e3:b0:6cf:427b:c20b with SMTP id b3-20020a05620a04e300b006cf427bc20bmr3680488qkh.164.1663883301544;
        Thu, 22 Sep 2022 14:48:21 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id r13-20020ac8794d000000b003438a8e842fsm4137374qtt.44.2022.09.22.14.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 14:48:21 -0700 (PDT)
Date:   Thu, 22 Sep 2022 17:48:19 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
        pbonzini@redhat.com, zhenyzha@redhat.com, shan.gavin@gmail.com,
        gshan@redhat.com, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 2/6] KVM: Add KVM_CAP_DIRTY_LOG_RING_ORDERED capability
 and config option
Message-ID: <YyzYI/bvp/JnbcxS@xz-m1.local>
References: <20220922170133.2617189-1-maz@kernel.org>
 <20220922170133.2617189-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220922170133.2617189-3-maz@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022 at 06:01:29PM +0100, Marc Zyngier wrote:
> In order to differenciate between architectures that require no extra
> synchronisation when accessing the dirty ring and those who do,
> add a new capability (KVM_CAP_DIRTY_LOG_RING_ORDERED) that identify
> the latter sort. TSO architectures can obviously advertise both, while
> relaxed architectures most only advertise the ORDERED version.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  include/linux/kvm_dirty_ring.h |  6 +++---
>  include/uapi/linux/kvm.h       |  1 +
>  virt/kvm/Kconfig               | 14 ++++++++++++++
>  virt/kvm/Makefile.kvm          |  2 +-
>  virt/kvm/kvm_main.c            | 11 +++++++++--
>  5 files changed, 28 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
> index 906f899813dc..7a0c90ae9a3f 100644
> --- a/include/linux/kvm_dirty_ring.h
> +++ b/include/linux/kvm_dirty_ring.h
> @@ -27,7 +27,7 @@ struct kvm_dirty_ring {
>  	int index;
>  };
>  
> -#ifndef CONFIG_HAVE_KVM_DIRTY_RING
> +#ifndef CONFIG_HAVE_KVM_DIRTY_LOG

s/LOG/LOG_RING/ according to the commit message? Or the name seems too
generic.

Pure question to ask: is it required to have a new cap just for the
ordering?  IIUC if x86 was the only supported anyway before, it means all
released old kvm binaries are always safe even without the strict
orderings.  As long as we rework all the memory ordering bits before
declaring support of yet another arch, we're good.  Or am I wrong?

Thanks,

-- 
Peter Xu


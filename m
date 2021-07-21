Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447373D155B
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 19:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236484AbhGURGV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 13:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhGURGU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 13:06:20 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6ADC061575
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 10:46:56 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id oz7so4490291ejc.2
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 10:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AxTvururg15eAgQqT/Vw3IaCmq/AtpICOLNE7tzoQWM=;
        b=s0WASEAsAruBpiL/ESXJp2VeA5h+VTH0uEnk+LjAD3MHgy72GUAmI0zBPcvrD8s0SA
         BWd9ei0B8Hv1rK7VYNbIu6CBlaBhnbfO64qTWXLIdQniLZyup1q2j9Bl5Ub6BeGijcX8
         o2GowuJAhyePRBqL1PylmSGGCsNgtoGiloJFlPnxkrNT2U81r5Mxayn2fG2GDKvW/6Wr
         JHGyMNfwDGxoCXuUwC54Cph9OIE9di/Zn5VNuNjuxY1xSE8IY6oZOFZOwV1+s5UgN5EL
         WdegzQ2TXCJbEAUWTyI+Nys4iqZoAnBRb0CZnuj1SZTVekfvqquMS7B2ygo0sDqp4kYi
         SlKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AxTvururg15eAgQqT/Vw3IaCmq/AtpICOLNE7tzoQWM=;
        b=Lh5/h/fqvlCyktXHW2c2tOTR9wpNy9KQcQDC5H0D+i+ii9XuOWPrBQM42L2+SUZVeE
         jZLNMeEbs/FNmHm93+4u5/XhXwuf8AANvRSsf09lZZ3XX3Ofi41nMgsM8sSwXcb4HhDR
         DSr1VWQfnWxhBldxDFxD4GcGrs4uXuO98bXM6uTEDUlD0mdHvSo+S5yx1fv/ofvDOhmm
         1yFSu5mqpbhzmAuJkk302ChGNd8DVQ2SdTMzzIeABS+ikWRUpXurnc3QgYfWTMYKhULX
         a9dubutpOLXBwde+xzvNuQUyZC26o91uF4pI4y5P2Uw2YXCyxtARp6Ieg9cUnVNRB3JT
         CpdA==
X-Gm-Message-State: AOAM532y45m+GZshvJJfELl63mcMFkLfEYFBsJTV2vjjcg6tbP2KJaBI
        VR0pz8hWg3gyk9ODD2jUIitCTA==
X-Google-Smtp-Source: ABdhPJy4TQnKuFecqxFoIlEfztLPuXcjzFwaiFkqmvuxoQO+VS6qVLl59Uri6H53MV/Z29iViIl6mw==
X-Received: by 2002:a17:907:170c:: with SMTP id le12mr41029420ejc.288.1626889615495;
        Wed, 21 Jul 2021 10:46:55 -0700 (PDT)
Received: from myrica (adsl-84-226-111-173.adslplus.ch. [84.226.111.173])
        by smtp.gmail.com with ESMTPSA id qo6sm8570087ejb.122.2021.07.21.10.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 10:46:55 -0700 (PDT)
Date:   Wed, 21 Jul 2021 19:46:34 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Oliver Upton <oupton@google.com>
Cc:     Alexandru Elisei <Alexandru.Elisei@arm.com>,
        salil.mehta@huawei.com, lorenzo.pieralisi@arm.com,
        kvm@vger.kernel.org, corbet@lwn.net, maz@kernel.org,
        linux-kernel@vger.kernel.org, jonathan.cameron@huawei.com,
        catalin.marinas@arm.com, pbonzini@redhat.com, will@kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 0/5] KVM: arm64: Pass PSCI to userspace
Message-ID: <YPhdehJ2m/EEGkdT@myrica>
References: <20210608154805.216869-1-jean-philippe@linaro.org>
 <c29ff5c8-9c94-6a6c-6142-3bed440676bf@arm.com>
 <YPW+Hv3r586zKxpY@myrica>
 <CAOQ_QsjyP0PMGOorTss2Fpn011mHPwVqQ72x26Gs2L0bg2amsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ_QsjyP0PMGOorTss2Fpn011mHPwVqQ72x26Gs2L0bg2amsQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 19, 2021 at 12:37:52PM -0700, Oliver Upton wrote:
> On Mon, Jul 19, 2021 at 11:02 AM Jean-Philippe Brucker
> <jean-philippe@linaro.org> wrote:
> > We forward the whole PSCI function range, so it's either KVM or userspace.
> > If KVM manages PSCI and the guest calls an unimplemented function, that
> > returns directly to the guest without going to userspace.
> >
> > The concern is valid for any other range, though. If userspace enables the
> > HVC cap it receives function calls that at some point KVM might need to
> > handle itself. So we need some negotiation between user and KVM about the
> > specific HVC ranges that userspace can and will handle.
> 
> Are we going to use KVM_CAPs for every interesting HVC range that
> userspace may want to trap? I wonder if a more generic interface for
> hypercall filtering would have merit to handle the aforementioned
> cases, and whatever else a VMM will want to intercept down the line.
> 
> For example, x86 has the concept of 'MSR filtering', wherein userspace
> can specify a set of registers that it wants to intercept. Doing
> something similar for HVCs would avoid the need for a kernel change
> each time a VMM wishes to intercept a new hypercall.

Yes we could introduce a VM device group for this:
* User reads attribute KVM_ARM_VM_HVC_NR_SLOTS, which defines the number
  of available HVC ranges.
* User writes attribute KVM_ARM_VM_HVC_SET_RANGE with one range
  struct kvm_arm_hvc_range {
          __u32 slot;
  #define KVM_ARM_HVC_USER (1 << 0) /* Enable range. 0 disables it */
          __u16 flags;
	  __u16 imm;
          __u32 fn_start;
          __u32 fn_end;
  };
* KVM forwards any HVC within this range to userspace.
* If one of the ranges is PSCI functions, disable KVM PSCI.

Since it's more work for KVM to keep track of ranges, I didn't include it
in the RFC, and I'm going to leave it to the next person dealing with this
stuff :)

Thanks,
Jean

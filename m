Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88DE310875
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 10:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhBEJyw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 04:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbhBEJwQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 04:52:16 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13915C061356
        for <kvm@vger.kernel.org>; Fri,  5 Feb 2021 01:51:35 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id f16so5456646wmq.5
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 01:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VjKGmSN62P3b8Gz6m1qtw9F99Y61/6CwerUG3tU7MY4=;
        b=hWd/h67FoDG08zJsdEf7THf5fsb8v5CDM+WHa00/AqDgZTi/FJ+XGDpt9noS8j92eT
         c1yHqJWnhx8pzofgcTkG621MIs+ZYNlzfNozMBJ4JGCLPQtNYcZpfLKnYu5xL/x6BT71
         aEdAxyGZOr6ngMqNl+eTVJ0vkLcZMUIAF37j+R6ukekbSONzz5ikB96WW1ggQpbmjh4e
         pzHSlO7VExl5U8GM7ducj2019BOduKzXoVXs1I8Eb0OZbXXoEFER+3Mi9BFjFmjfFpH9
         0gGWV1VKYh/xeHfSCvsqZuEIO8leB844woCNQpyIv7/edOIt3pyLFA5cl+hc11LUi2l0
         BUGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VjKGmSN62P3b8Gz6m1qtw9F99Y61/6CwerUG3tU7MY4=;
        b=iHFuF805sCgXPpN7UQieX9yrB29pkMcPQgfJ+FWnQUtDRg7jOG+5a8WxKDrjnGFe/d
         xxFjO5ndIm4UGSNiVlSzCDiZGpsy15RtayNN/yaYFdNZq/ACmo8uDcWE8KZXdGePAVwz
         R7uPdlix6zsC9ClYWExlCCYHLtTYboV+SfOYXx0wzPEUaKnxd0da2mXbSjP8hn5sz0mS
         XJpm/xa7L0J4O+CGbErY9P8Rm1hn7URqUSUgb0PHay5KSGfRE42ZBMlDGSzrWvSVnnKI
         CPeWKdozcOPHUjiEtZ2eXKfq5QXB0OcHGC52dRLgvzSkO6riOHgLmwaPpIL4VoX7744m
         H/wg==
X-Gm-Message-State: AOAM530upbUSOGCOije5Q+EST6lA6QomJkJykZ9DTDzCeYXdgYMtAyiO
        bP3H2eZivP6tkLxkfd3EZFT/pA==
X-Google-Smtp-Source: ABdhPJyBpgLCQ/JhIkBboD0wFrqF+LmtaNQmOXy+bUTKCu4KXYd0D+Ym0BJGOgt45t7ajfN+ikeD0w==
X-Received: by 2002:a1c:7d0c:: with SMTP id y12mr2849282wmc.184.1612518693792;
        Fri, 05 Feb 2021 01:51:33 -0800 (PST)
Received: from myrica ([2001:1715:4e26:a7e0:116c:c27a:3e7f:5eaf])
        by smtp.gmail.com with ESMTPSA id m18sm11669198wrx.17.2021.02.05.01.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 01:51:33 -0800 (PST)
Date:   Fri, 5 Feb 2021 10:51:14 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     Robin Murphy <robin.murphy@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        Will Deacon <will@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, jiangkunkun@huawei.com,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Cornelia Huck <cohuck@redhat.com>, lushenming@huawei.com,
        Kirti Wankhede <kwankhede@nvidia.com>,
        James Morse <james.morse@arm.com>, wanghaibin.wang@huawei.com,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [RFC PATCH 01/11] iommu/arm-smmu-v3: Add feature detection for
 HTTU
Message-ID: <YB0VErwkA0ivRXTd@myrica>
References: <20210128151742.18840-1-zhukeqian1@huawei.com>
 <20210128151742.18840-2-zhukeqian1@huawei.com>
 <f8be5718-d4d9-0565-eaf0-b5a128897d15@arm.com>
 <df1b8fb2-b853-e797-0072-9dbdffc4ff67@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df1b8fb2-b853-e797-0072-9dbdffc4ff67@huawei.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Keqian,

On Fri, Feb 05, 2021 at 05:13:50PM +0800, Keqian Zhu wrote:
> > We need to accommodate the firmware override as well if we need this to be meaningful. Jean-Philippe is already carrying a suitable patch in the SVA stack[1].
> Robin, Thanks for pointing it out.
> 
> Jean, I see that the IORT HTTU flag overrides the hardware register info unconditionally. I have some concern about it:
> 
> If the override flag has HTTU but hardware doesn't support it, then driver will use this feature but receive access fault or permission fault from SMMU unexpectedly.
> 1) If IOPF is not supported, then kernel can not work normally.
> 2) If IOPF is supported, kernel will perform useless actions, such as HTTU based dma dirty tracking (this series).
> 
> As the IORT spec doesn't give an explicit explanation for HTTU override, can we comprehend it as a mask for HTTU related hardware register?

To me "Overrides the value of SMMU_IDR0.HTTU" is clear enough: disregard
the value of SMMU_IDR0.HTTU and use the one specified by IORT instead. And
that's both ways, since there is no validity mask for the IORT value: if
there is an IORT table, always ignore SMMU_IDR0.HTTU.

That's how the SMMU driver implements the COHACC bit, which has the same
wording in IORT. So I think we should implement HTTU the same way.

One complication is that there is no equivalent override for device tree.
I think it can be added later if necessary, because unlike IORT it can be
tri state (property not present, overriden positive, overridden negative).

Thanks,
Jean


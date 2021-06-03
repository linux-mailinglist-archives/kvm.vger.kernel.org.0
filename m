Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B77399B3E
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 09:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhFCHJK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 03:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhFCHJK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 03:09:10 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7738DC06174A
        for <kvm@vger.kernel.org>; Thu,  3 Jun 2021 00:07:25 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id r13so2725796wmq.1
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 00:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nuviainc-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=swTqT+JBPk12ncEzOYoOSk8MfnzP+PLyF+iYHFtT61c=;
        b=fuALpjEBCmQS3d00X52WWRgr/gePIoNMXojP7jyYk+Z9NXNArq9QJV0UMq93XENuxb
         fq3zTi+yMmLIxYtuRzzDcvMtbra02NbNl4bnKmiU582LjAX27DrulwpZOlKUCYb2BihK
         9QlAAfvoVfe4oQInhgY0qp8VPCUnYsYWcok8HJUpDqZVXGJOXIt/A6Lcg9Va7S7cZKMC
         l11FW3UwfNBSfXxAa8L9EmgQ+2/AdGuBIVINOb8QSSQ1WBzEdQL9sGj5RyX6KjdLA6xk
         9qMpJREaHSDGdWHz2BROw4Kd+IOpfZ50XVjpLUZmP55yTQn9CbfDIAyv/DRFq9L+TP3Z
         nP9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=swTqT+JBPk12ncEzOYoOSk8MfnzP+PLyF+iYHFtT61c=;
        b=fnpXMIWurGMbzWl4QmMchMasxN2Gg001ruM1if0lWmgXcnd8udDIo9P2Ryhkiow8Zq
         LIXN47yUsE2hSTWlqYVZ30LTl2O6Q4GExwTSBuWsDCdt74o8N/1X6S5kYfclsG+6mdpA
         DQz5eahA/PPK2W9fLutzKYqQfAeiX3rTJrkzC2jFqaiQLzm7dZgez5DgBHgbipiQ9gcO
         5XoP9HqO4cLZRcODqjnS0AeqAxRLMjWuO1QCPx2MxBBwgim4imCCMz51iB+RdSHVx1DE
         aQJAMhZOyWqd4vUyfOyfZ5x0q4J2TdCsDhVKp4erraFvhmUsMozjRyyuxKFl+E5+oERX
         vwtw==
X-Gm-Message-State: AOAM533yVokKP6wcCu6ZUyY7HFevI5CtHsnsgULdYKi8d/GbIarke8xs
        TlyfxilvaB9yG3UObAxs+9e8ZAPCinPryQ==
X-Google-Smtp-Source: ABdhPJyKYnBJGEQb+Nkwb/uT2+RRLkdLFQM3//Ylsfzfcko0Ag534F59xhbPPyCcGmi7N7vecIQT8Q==
X-Received: by 2002:a05:600c:2209:: with SMTP id z9mr35507257wml.120.1622704044067;
        Thu, 03 Jun 2021 00:07:24 -0700 (PDT)
Received: from localhost ([82.44.17.50])
        by smtp.gmail.com with ESMTPSA id o9sm2186295wrw.69.2021.06.03.00.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 00:07:23 -0700 (PDT)
Date:   Thu, 3 Jun 2021 08:07:22 +0100
From:   Jamie Iles <jamie@nuviainc.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH v4 00/66] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
Message-ID: <YLh/qsmKDJ86n75w@hazel>
Mail-Followup-To: Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
References: <20210510165920.1913477-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510165920.1913477-1-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Mon, May 10, 2021 at 05:58:14PM +0100, Marc Zyngier wrote:
> Here the bi-annual drop of the KVM/arm64 NV support code.
> 
> Not a lot has changed since [1], except for a discovery mechanism for
> the EL2 support, some tidying up in the idreg emulation, dropping RMR
> support, and a rebase on top of 5.13-rc1.
> 
> As usual, blame me for any bug, and nobody else.
> 
> It is still massively painful to run on the FVP, but if you have a
> Neoverse V1 or N2 system that is collecting dust, I have the right
> stuff to keep it busy!

I've been testing this series on FVP and get a crash when returning from 
__kvm_vcpu_run_vhe because the autiasp is failing.

The problem is when the L1 boots and during EL2 setup sets hcr_el2 to 
HCR_HOST_NVHE_FLAGS and so enables HCR_APK|HCR_API.  Then the guest 
enter+exit logic in L0 starts performing the key save restore, but as we 
didn't go through __hyp_handle_ptrauth, we haven't saved the host keys 
and invoked vcpu_ptrauth_enable() so restore the host keys back to 0.

I wonder if the pointer auth keys should be saved+restored 
unconditionally for a guest when running nested rather than the lazy 
faulting that we have today?  Alternatively we would need to duplicate 
the lazy logic for hcr_el2 writes.  A quick hack of saving the host keys 
in __kvm_vcpu_run_vhe before sysreg_save_host_state_vhe is enough to 
allow me to boot an L1 with --nested and then an L2.

Do we also need to filter out HCR_APK|HCR_API for hcr_el2 writes when 
pointer authentication hasn't been exposed to the guest?  I haven't yet 
tried making ptrauth visible to the L1.

Thanks,

Jamie

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07B539D933
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 11:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhFGKBm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 06:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhFGKBl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 06:01:41 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7975AC061766
        for <kvm@vger.kernel.org>; Mon,  7 Jun 2021 02:59:50 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id a20so16925239wrc.0
        for <kvm@vger.kernel.org>; Mon, 07 Jun 2021 02:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nuviainc-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p4DLt66lUCYjaFVIOgZH75INGuDN8geDg/llZgnm7Ic=;
        b=v+wDKQVWu9yMRQlxnrjcHW+YzayMQw8AKbw0Sotye6dq6Mi/XirZdCp+SVNLSNDUH6
         KnVPIi7G03WsdOSYqvHd5Qc9rE6Ecr2yquz0U/t1CxhCeMVmY7pHgQqo5UUuKnuv66yD
         3IxkiD8fgYT76I/fGm3OO6dyf8hVmZ6JUEsAxDr7wQvkbldYEDC6/ZiW9h/QUlHXjuSa
         KiSH4xUr3mQtUm9S97PATjYfHMsIZyny5eSguSytWJD1hwTV5gcNLx1Y6MeiDRiSzYLh
         /YYeUsrPtK7KK1ZWQdQmufTNGSlm2eQtRfG/TZ0qs/majukVbye/OQcd6qlqhLBo0z3g
         ySSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p4DLt66lUCYjaFVIOgZH75INGuDN8geDg/llZgnm7Ic=;
        b=EHreSsbu0lnx+pdNc25UvMrgc7ar3ydpFYlH4l0ifk8iPBuh7bf7BSKsM9t0xMCMXO
         mDUtnCv/mlUqEghRFWdYOVSJqTGw0lIOn1kPz1eSy7dDp6c2OerVKIb0m5OmkJ/kBa9c
         v3Agk0IzCAgdNpu0MmryjEiownksqbgGLWouReAaizBDP2XA+AX1FkWQV4JPPPkTGbub
         9H1ms7jjcmCbD/MUx0z9XzJFwdnfffxUCbEGfGG9xf49VsXo6WNxt+hTJcx0oHcRRcci
         jZpbU2niHIcQ9B7KtC+buUzXE89fQsklvCjZ23wTD1IPd6jMMbzzSofmdFce2MScxRkF
         FD1Q==
X-Gm-Message-State: AOAM532h65lkvVo5D943wc26sGU82YtWXiY+eU23I1vkyWvTDC96Wd3p
        H6AHUrKnQjVbIBjXHD6kf87gzw==
X-Google-Smtp-Source: ABdhPJxqSJVg78qWie75iU0nfkVmt/mrlTFme0qOfok5xe8IqNIFyAUXePcJPqifJe8VM+aT7yJP6g==
X-Received: by 2002:adf:fa88:: with SMTP id h8mr16381574wrr.364.1623059986701;
        Mon, 07 Jun 2021 02:59:46 -0700 (PDT)
Received: from localhost ([82.44.17.50])
        by smtp.gmail.com with ESMTPSA id 89sm16240879wri.94.2021.06.07.02.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 02:59:46 -0700 (PDT)
Date:   Mon, 7 Jun 2021 10:59:45 +0100
From:   Jamie Iles <jamie@nuviainc.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Jamie Iles <jamie@nuviainc.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
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
Message-ID: <YL3uEToHum2xgyOz@hazel>
References: <20210510165920.1913477-1-maz@kernel.org>
 <YLh/qsmKDJ86n75w@hazel>
 <87zgw7z6j6.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgw7z6j6.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 03, 2021 at 09:39:09AM +0100, Marc Zyngier wrote:
> Hi Jamie,
> 
> Funny, your email has a "Mail-Followup-To:" field that contains
> everyone but you... Not ideal! ;-)

Oops, new mutt config, thanks.

> On Thu, 03 Jun 2021 08:07:22 +0100,
> Jamie Iles <jamie@nuviainc.com> wrote:
> > 
> > Hi Marc,
> > 
> > On Mon, May 10, 2021 at 05:58:14PM +0100, Marc Zyngier wrote:
> > > Here the bi-annual drop of the KVM/arm64 NV support code.
> > > 
> > > Not a lot has changed since [1], except for a discovery mechanism for
> > > the EL2 support, some tidying up in the idreg emulation, dropping RMR
> > > support, and a rebase on top of 5.13-rc1.
> > > 
> > > As usual, blame me for any bug, and nobody else.
> > > 
> > > It is still massively painful to run on the FVP, but if you have a
> > > Neoverse V1 or N2 system that is collecting dust, I have the right
> > > stuff to keep it busy!
> > 
> > I've been testing this series on FVP and get a crash when returning from 
> > __kvm_vcpu_run_vhe because the autiasp is failing.
> 
> Ah, the joy of testing with older guests. I guess i should upgrade by
> test rig and play with some newer guests at L1.
> 
> > 
> > The problem is when the L1 boots and during EL2 setup sets hcr_el2 to 
> > HCR_HOST_NVHE_FLAGS and so enables HCR_APK|HCR_API.  Then the guest 
> > enter+exit logic in L0 starts performing the key save restore, but as we 
> > didn't go through __hyp_handle_ptrauth, we haven't saved the host keys 
> > and invoked vcpu_ptrauth_enable() so restore the host keys back to 0.
> > 
> > I wonder if the pointer auth keys should be saved+restored 
> > unconditionally for a guest when running nested rather than the lazy 
> > faulting that we have today?
> 
> I'd like to try and avoid that in order to keep the basic logic as
> simple as possible for the time being, and as close to the tried and
> trusted flow we have today.
> 
> > Alternatively we would need to duplicate
> > the lazy logic for hcr_el2 writes.  A quick hack of saving the host keys 
> > in __kvm_vcpu_run_vhe before sysreg_save_host_state_vhe is enough to 
> > allow me to boot an L1 with --nested and then an L2.
> >
> > Do we also need to filter out HCR_APK|HCR_API for hcr_el2 writes when 
> > pointer authentication hasn't been exposed to the guest?  I haven't yet 
> > tried making ptrauth visible to the L1.
> 
> I think this is the real thing. We should never propagate trap bits
> for features we don't want to support in guests. The L1 kernel sets
> these bits unconditionally, despite PtrAuth never being advertised,
> which trips the host code.
> 
> Could you try the untested hack below?

That fixes the issue that I was seeing, lgtm.

Thanks Marc!

Jamie

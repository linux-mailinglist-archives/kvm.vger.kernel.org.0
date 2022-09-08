Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20FDC5B1EEE
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 15:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbiIHN3A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 09:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbiIHN2g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 09:28:36 -0400
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0FFD512754D;
        Thu,  8 Sep 2022 06:28:25 -0700 (PDT)
Received: from 8bytes.org (p4ff2bb62.dip0.t-ipconnect.de [79.242.187.98])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id 6ACB624069C;
        Thu,  8 Sep 2022 15:28:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1662643704;
        bh=tDuhKm9wQfdx7sUd4hZrnBHJRGruWciJVuKdXgXOhg8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nbzo8AaKCmLcJF6ywBTO/rjFGCww8jqPWoQ6WcBpBVILlVrrzm/ywTVSN6gtAJpvI
         A4WA5AxpHDg5Sd62NU3n5V/Vi1+huBSshzEAQAZS7xn++DhH0oznzPGAGwNcfBbTfq
         Twt1k1zJR6eHTY8BdmbO1Ww2bxQuZSP3YVyPip5R53rnIHglAbsB0bCYX0JzWlq5Om
         M3nAYqpIKCggsduzZcJAnKN/jYWRx4aw2vg7FWSxO/QqqKt7N7pAfFXxtOG8goJGLV
         xuiUyCTz0ghn5xX8vuVnC49wxhLLFEBrREVNPwdgKbdzr/ZwBoayTRYmgPniXvM4Pl
         wZdcX65MXNFqw==
Date:   Thu, 8 Sep 2022 15:28:22 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Nicolin Chen <nicolinc@nvidia.com>, will@kernel.org,
        robin.murphy@arm.com, alex.williamson@redhat.com,
        suravee.suthikulpanit@amd.com, marcan@marcan.st,
        sven@svenpeter.dev, alyssa@rosenzweig.io, robdclark@gmail.com,
        dwmw2@infradead.org, baolu.lu@linux.intel.com,
        mjrosato@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        orsonzhai@gmail.com, baolin.wang@linux.alibaba.com,
        zhang.lyra@gmail.com, thierry.reding@gmail.com, vdumpa@nvidia.com,
        jonathanh@nvidia.com, jean-philippe@linaro.org, cohuck@redhat.com,
        tglx@linutronix.de, shameerali.kolothum.thodi@huawei.com,
        thunder.leizhen@huawei.com, christophe.jaillet@wanadoo.fr,
        yangyingliang@huawei.com, jon@solid-run.com, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        kevin.tian@intel.com
Subject: Re: [PATCH v6 1/5] iommu: Return -EMEDIUMTYPE for incompatible
 domain and device/group
Message-ID: <Yxnt9uQTmbqul5lf@8bytes.org>
References: <20220815181437.28127-1-nicolinc@nvidia.com>
 <20220815181437.28127-2-nicolinc@nvidia.com>
 <YxiRkm7qgQ4k+PIG@8bytes.org>
 <Yxig+zfA2Pr4vk6K@nvidia.com>
 <YxilZbRL0WBR97oi@8bytes.org>
 <YxjQiVnpU0dr7SHC@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxjQiVnpU0dr7SHC@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 07, 2022 at 02:10:33PM -0300, Jason Gunthorpe wrote:
> Sure, rust has all sorts of nice things. But the kernel doesn't follow
> rust idioms, and I don't think this is a great place to start
> experimenting with them.

It is actually a great place to start experimenting. The IOMMU
interfaces are rather domain specific and if we get something wrong the
damage is limited to a few callers. There are APIs much more exposed in
the kernel which would be worse for that.

But anyway, I am not insisting on it.

> It has been 3 months since EMEDIUMTYPE was first proposed and 6
> iterations of the series, don't you think it is a bit late in the game
> to try to experiment with rust error handling idioms?

If I am not mistaken, I am the person who gets blamed when crappy IOMMU
code is sent upstream. So it is also up to me to decide in which state
and how close to merging a given patch series is an whether it is
already 'late in the game'.

> So, again, would you be happy with a simple 
> 
>  #define IOMMU_EINCOMPATIBLE_DEVICE xx
> 
> to make it less "re-using random error codes"?

I am wondering if this can be solved by better defining what the return
codes mean and adjust the call-back functions to match the definition.
Something like:

	-ENODEV : Device not mapped my an IOMMU
	-EBUSY  : Device attached and domain can not be changed
	-EINVAL : Device and domain are incompatible
	...

That would be much more intuitive than using something obscure like
EMEDIUMTYPE.

Regards,

	Joerg

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 232E25B046D
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 14:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiIGMz4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 08:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiIGMzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 08:55:50 -0400
X-Greylist: delayed 400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 07 Sep 2022 05:55:49 PDT
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 826AC5FF5A;
        Wed,  7 Sep 2022 05:55:47 -0700 (PDT)
Received: from 8bytes.org (p4ff2bb62.dip0.t-ipconnect.de [79.242.187.98])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id E4F5524000A;
        Wed,  7 Sep 2022 14:49:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1662554947;
        bh=yGOX5Lwpalcu82yNs8ayh8dOtcer41jlk77UdSRJHzA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uE78GVEgI4yTOR9KWvlR6IpZa67YTCKueETuj+yYYkM1pR/p3SMYfJwUC1JIQlv2e
         2ntTjhAKoTFc7sIl+Vu7+2KELvGsyWVaHSJ3AqSumJvsfUrT3HcwqC38Dl7VcnwroB
         8BFi6rWMsQWaBAZ6yGKr4LVWwTh2MQqqZIfvRsznMzAr1tqMQ4wbun1jLc6Q3oK5qR
         4cEjQ7+thJq/JFFPPZao/wMUvReiwhSBhAhxKOJVjYvypVQZSPwSzv7INhTevRqlKz
         tyLofbz/SQzQ1doEpWKl93VLrcpVkkQeTqcmZ4zf7b9+DgCzs3P+Ahm8FeqJQInzIE
         YZOdibS6/esUA==
Date:   Wed, 7 Sep 2022 14:49:05 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     will@kernel.org, catalin.marinas@arm.com, jean-philippe@linaro.org,
        inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, tglx@linutronix.de, maz@kernel.org,
        alex.williamson@redhat.com, cohuck@redhat.com,
        iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/3] iommu/dma: Some housekeeping
Message-ID: <YxiTQRbsoJDG2QZJ@8bytes.org>
References: <cover.1660668998.git.robin.murphy@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1660668998.git.robin.murphy@arm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 16, 2022 at 06:28:02PM +0100, Robin Murphy wrote:
> Robin Murphy (3):
>   iommu/dma: Clean up Kconfig
>   iommu/dma: Move public interfaces to linux/iommu.h
>   iommu/dma: Make header private

Applied, thanks.

>  include/linux/dma-iommu.h                   | 93 ---------------------

Squashed the updated file path in MAINTAINERS into the last patch.

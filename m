Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB9B6C4A6D
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 13:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjCVM1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 08:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbjCVM1c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 08:27:32 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA882DE5A
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 05:27:31 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PhSR72JStz4xFR;
        Wed, 22 Mar 2023 23:27:31 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     kvm <kvm@vger.kernel.org>,
        Timothy Pearson <tpearson@raptorengineering.com>
Cc:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <2000135730.16998523.1678123860135.JavaMail.zimbra@raptorengineeringinc.com>
References: <2000135730.16998523.1678123860135.JavaMail.zimbra@raptorengineeringinc.com>
Subject: Re: [PATCH v2 3/4] powerpc/iommu: Add iommu_ops to report capabilities and
Message-Id: <167948793435.559204.9498535193091997320.b4-ty@ellerman.id.au>
Date:   Wed, 22 Mar 2023 23:25:34 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.0 required=5.0 tests=SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 6 Mar 2023 11:31:00 -0600 (CST), Timothy Pearson wrote:
>  allow blocking domains
> 
> Up until now PPC64 managed to avoid using iommu_ops. The VFIO driver
> uses a SPAPR TCE sub-driver and all iommu_ops uses were kept in
> the Type1 VFIO driver. Recent development added 2 uses of iommu_ops to
> the generic VFIO which broke POWER:
> - a coherency capability check;
> - blocking IOMMU domain - iommu_group_dma_owner_claimed()/...
> 
> [...]

Applied to powerpc/next.

[3/4] powerpc/iommu: Add iommu_ops to report capabilities and
      https://git.kernel.org/powerpc/c/a940904443e432623579245babe63e2486ff327b

cheers

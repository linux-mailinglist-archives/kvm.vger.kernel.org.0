Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 924106C4A6B
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 13:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbjCVM1e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 08:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbjCVM1c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 08:27:32 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE462CC57
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 05:27:31 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PhSR52qY4z4xFV;
        Wed, 22 Mar 2023 23:27:29 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     kvm <kvm@vger.kernel.org>,
        Timothy Pearson <tpearson@raptorengineering.com>
Cc:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <525438831.16998517.1678123820075.JavaMail.zimbra@raptorengineeringinc.com>
References: <525438831.16998517.1678123820075.JavaMail.zimbra@raptorengineeringinc.com>
Subject: Re: [PATCH v2 1/4] powerpc/iommu: Add "borrowing" iommu_table_group_ops
Message-Id: <167948793435.559204.7948325972421120627.b4-ty@ellerman.id.au>
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

On Mon, 6 Mar 2023 11:30:20 -0600 (CST), Timothy Pearson wrote:
> PPC64 IOMMU API defines iommu_table_group_ops which handles DMA windows
> for PEs: control the ownership, create/set/unset a table the hardware
> for dynamic DMA windows (DDW). VFIO uses the API to implement support
> on POWER.
> 
> So far only PowerNV IODA2 (POWER8 and newer machines) implemented this and other cases (POWER7 or nested KVM) did not and instead reused
> existing iommu_table structs. This means 1) no DDW 2) ownership transfer
> is done directly in the VFIO SPAPR TCE driver.
> 
> [...]

Applied to powerpc/next.

[1/4] powerpc/iommu: Add "borrowing" iommu_table_group_ops
      https://git.kernel.org/powerpc/c/9d67c94335096311c0bc7556ad1022de7385790b

cheers

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F19257B4FFE
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 12:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236396AbjJBKQd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 06:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236428AbjJBKQ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 06:16:27 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25AB6D3;
        Mon,  2 Oct 2023 03:16:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5421FC433C8;
        Mon,  2 Oct 2023 10:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696241784;
        bh=Zp1fUQdvvDOBn2zC04x0dm4q+E+VpLrN7Vzr5lIB0F4=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=Midz3GQE/+bTWncFNRiewuFy1y+nRs0kSgUdvSA4XWlS/09Qu45v/gb1i005N0cPh
         rXwF7Oe0TnNvp4jLr8oo+MjsOOoPCqhzbj/OJ4y9/2murYaOOD8NoOqcRMgQEAZmmU
         xvUBTl0MUGrtgu5mplBZPpk+DaQibzza4hCFSr7bFLrrAtjR22ByCCERGPb4DxLUvI
         YkPB89+gv64FHQOCiDoMROyDqUONytht3mmvA2saKayiCGqbO+fpcHvHjaP9yvMBG4
         3084LKsoDEDxdHDv+6XOWtsCztDia7huFEYcCEmS/MCOVOILzwJHSlFAcPfWRZ2CdC
         03auPIhXKKWqg==
From:   Leon Romanovsky <leon@kernel.org>
To:     eperezma@redhat.com, gal@nvidia.com,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Dragos Tatulea <dtatulea@nvidia.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
In-Reply-To: <20230928164550.980832-2-dtatulea@nvidia.com>
References: <20230928164550.980832-2-dtatulea@nvidia.com>
Subject: Re: (subset) [PATCH vhost v2 00/16] vdpa: Add support for vq
 descriptor mappings
Message-Id: <169624178143.78680.3290011186914893676.b4-ty@kernel.org>
Date:   Mon, 02 Oct 2023 13:16:21 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-a055d
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On Thu, 28 Sep 2023 19:45:11 +0300, Dragos Tatulea wrote:
> This patch series adds support for vq descriptor table mappings which
> are used to improve vdpa live migration downtime. The improvement comes
> from using smaller mappings which take less time to create and destroy
> in hw.
> 
> The first part adds the vdpa core changes from Si-Wei [0].
> 
> [...]

Applied, thanks!

[01/16] vdpa/mlx5: Expose descriptor group mkey hw capability
        https://git.kernel.org/rdma/rdma/c/d424348b060d87

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

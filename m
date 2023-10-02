Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D80B77B4FFB
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 12:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236383AbjJBKQa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 06:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbjJBKQT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 06:16:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546E9B3;
        Mon,  2 Oct 2023 03:16:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE6EC433C8;
        Mon,  2 Oct 2023 10:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696241775;
        bh=VLliXuAF8QPVy04D/rtFQGZqAS64x++mfdCoI8VRoW8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r0etBzUwLk2CCjZoBGPM1zTIaXAL+w7ERcTqoBJI+KZWZQ4s8EOCD4jzlE4PHGzRI
         ZNUoqFn+6/vf7dL+COR1dtbqPuFSfY/AkuueyJzRK0oYHgMqc/9OpOjBFzrIfJ9q0u
         oDz0d9S8YDSccLiG81AHjqkmCIox4eSUc0LQElaMFHgToCvnIApVl4kUTEaJ4+rsRK
         6u/AMv0PgdQJx2hL6xqxI/Ao5ccRccvEZN4uVc8OrjrrBAgl+dqIxxgi8VlTQbLmJR
         SyzQUDgk6M18uTZH9DMAjGXOVBI9qgLq3RlzYbpwsFX2QiIkpcDC0KO/nbyJxG/TKR
         C7XshL7DUPdNw==
Date:   Mon, 2 Oct 2023 13:16:12 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dragos Tatulea <dtatulea@nvidia.com>
Cc:     eperezma@redhat.com, gal@nvidia.com,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH vhost v2 00/16] vdpa: Add support for vq descriptor
 mappings
Message-ID: <20231002101612.GB7059@unreal>
References: <20230928164550.980832-2-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230928164550.980832-2-dtatulea@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 28, 2023 at 07:45:11PM +0300, Dragos Tatulea wrote:
> This patch series adds support for vq descriptor table mappings which
> are used to improve vdpa live migration downtime. The improvement comes
> from using smaller mappings which take less time to create and destroy
> in hw.
> 
> The first part adds the vdpa core changes from Si-Wei [0].
> 
> The second part adds support in mlx5_vdpa:
> - Refactor the mr code to be able to cleanly add descriptor mappings.
> - Add hardware descriptor mr support.
> - Properly update iotlb for cvq during ASID switch.
> 
> Changes in v2:
> 
> - The "vdpa/mlx5: Enable hw support for vq descriptor mapping" change
>   was split off into two patches to avoid merge conflicts into the tree
>   of Linus.
> 
>   The first patch contains only changes for mlx5_ifc.h. This must be
>   applied into the mlx5-next tree [1] first. Once this patch is applied
>   on mlx5-next, the change has to be pulled fom mlx5-next into the vhost
>   tree and only then the remaining patches can be applied.
> 
> [0] https://lore.kernel.org/virtualization/1694248959-13369-1-git-send-email-si-wei.liu@oracle.com
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/log/?h=mlx5-next
> 
> Dragos Tatulea (13):
>   vdpa/mlx5: Expose descriptor group mkey hw capability

I prepared shared branch with this patch.
https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/log/?h=mlx5-vhost

Thanks

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB2797B4D92
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 10:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235928AbjJBIsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 04:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235908AbjJBIsG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 04:48:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51D7D3
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 01:48:00 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CE9C433C9;
        Mon,  2 Oct 2023 08:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696236480;
        bh=vrQ7miInyl6pwUaFhZ+rv70R1449cA6MMPCwUyQ7Rq4=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=sQV2gfXbR8xwbRZrmbsMgWY/6Nmh5abJDFUMn7nS5LK9sVnrb4F3mXV6rBjLO+Adx
         IwxRloQwOmhHRhHAwtc3wUSqBHYCiKUveP335CnW5fDcxCwwuaDRW6bOgJ0BITBX2q
         4+f2vNyH8zCnUxTaBywAN3Yl/3N/rcdsa6qd6lXknoNrxra2pxQQr6Y22yqlLH8NsV
         kKIh0yLKrLUtla3xytNzgJuGtxO2jnLJXkVleeoijOUzMovDko28wro+2meJ+1S6Ir
         zg1vE9wY3QP6y1zZ9PpXwQJvLE50o94cvhsG8RYp4kB+fAqNUeOX77U1Li/jy93m/0
         gthjo/eyxn8IA==
From:   Leon Romanovsky <leon@kernel.org>
To:     alex.williamson@redhat.com, Jason Gunthorpe <jgg@ziepe.ca>,
        Yishai Hadas <yishaih@nvidia.com>
Cc:     kvm@vger.kernel.org, kevin.tian@intel.com,
        joao.m.martins@oracle.com, maorg@nvidia.com,
        Leon Romanovsky <leon@kernel.org>
In-Reply-To: <20230911093856.81910-1-yishaih@nvidia.com>
References: <20230911093856.81910-1-yishaih@nvidia.com>
Subject: Re: (subset) [PATCH vfio 0/9] Add chunk mode support for mlx5 driver
Message-Id: <169623647704.22791.15036809955233219831.b4-ty@kernel.org>
Date:   Mon, 02 Oct 2023 11:47:57 +0300
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


On Mon, 11 Sep 2023 12:38:47 +0300, Yishai Hadas wrote:
> This series adds 'chunk mode' support for mlx5 driver upon the migration
> flow.
> 
> Before this series, we were limited to 4GB state size, as of the 4 bytes
> max value based on the device specification for the query/save/load
> commands.
> 
> [...]

Applied, thanks!

[1/9] net/mlx5: Introduce ifc bits for migration in a chunk mode
      https://git.kernel.org/rdma/rdma/c/5aa4c9608d2d5f

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

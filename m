Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054E34D05CC
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 18:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244601AbiCGR7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 12:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244597AbiCGR7J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 12:59:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E349A24096;
        Mon,  7 Mar 2022 09:58:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 810E7612B9;
        Mon,  7 Mar 2022 17:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB57CC340EF;
        Mon,  7 Mar 2022 17:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646675893;
        bh=gazcKZzgOMmSP34WtlNhqLux7k7BCtkMMXddlVmZA+s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=M29FFm2tsdbuQ710xXUgckm9HhFuiy2BNyfWugbQYKZIp+XdMoC5jTGX980bSY8w7
         lu7VXxBAqTXjUlwNbhyZKGIjnaE40l3gknIui8Zw7SQ86tpGGc17mUDPkfmH8bUFkT
         KeMmUpJ1T13xfCc6kECLsNSORtPehRhU+cUJ1AtvwagN8KuGLZaUrd4tGSrwNRcoKt
         nvP2eqHJs9a/B9v8arCE3/BprnWzE/COXMGxT7qYElXSSsZmONK/XCqI6Z3HMEPnxQ
         Z889NSzkTwhv2FK7nG2HY51ox6doVxGTEjuBZv6EHixEuYrZHHsjbzIuL6X9hPPYKT
         BL/9rylULXNeQ==
Date:   Mon, 7 Mar 2022 11:58:12 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH vfio-next] PCI/IOV: Fix wrong kernel-doc identifier
Message-ID: <20220307175812.GA1275204@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8cecf7df45948a256dc56148cf9e87b2f2bb4198.1646652504.git.leonro@nvidia.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 07, 2022 at 01:33:25PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Replace "-" to be ":" in comment section to be aligned with
> kernel-doc format.
> 
> drivers/pci/iov.c:67: warning: Function parameter or member 'dev' not described in 'pci_iov_get_pf_drvdata'
> drivers/pci/iov.c:67: warning: Function parameter or member 'pf_driver' not described in 'pci_iov_get_pf_drvdata'
> 
> Fixes: a7e9f240c0da ("PCI/IOV: Add pci_iov_get_pf_drvdata() to allow VF reaching the drvdata of a PF")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/pci/iov.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index 28ec952e1221..952217572113 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -49,8 +49,8 @@ EXPORT_SYMBOL_GPL(pci_iov_vf_id);
>  
>  /**
>   * pci_iov_get_pf_drvdata - Return the drvdata of a PF
> - * @dev - VF pci_dev
> - * @pf_driver - Device driver required to own the PF
> + * @dev: VF pci_dev
> + * @pf_driver: Device driver required to own the PF
>   *
>   * This must be called from a context that ensures that a VF driver is attached.
>   * The value returned is invalid once the VF driver completes its remove()
> -- 
> 2.35.1
> 

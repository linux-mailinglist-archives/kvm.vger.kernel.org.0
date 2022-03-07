Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFE2F4D03FF
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 17:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244137AbiCGQYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 11:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237939AbiCGQYD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 11:24:03 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096645133B;
        Mon,  7 Mar 2022 08:23:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=FMQ1E1bsFd87Wb4baInab2zNiCCqgb6SQhj2GFL1ZAg=; b=qybcquY44zS39Oq9UeTRbcv/iZ
        UQUS/v95X+AmYBBT51LLDfkTEF7hlLbnhd5jRhwCeIoTiEcUIkcxjW0V4GsnSH3WavLrDjPidwLQE
        1oW2YK5QYoDnlGPhQo0eP7BE4DQmk6AK1M130qgG7L1qs09+Du9GYYAepRPIpUnaT47M0gzdnEbiI
        Z0rSg6bLCZD86NXNWiaj9K90UlHKTpSFyO/ZmdVIXHne+PXJdBVcqKqI1KuAEWWhPvLnrzWNzEnOB
        Tc/IoYNC5uX310lMB9NEhVGAn6kCvLIXix5loP2XlAa7yKg9scf1NYIyLBCYtsDyy131y09rhL4r+
        UpH1RU0w==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nRG8N-00FNLV-VI; Mon, 07 Mar 2022 16:22:56 +0000
Message-ID: <096db34d-e153-7c05-cc7e-6f89f6e751b9@infradead.org>
Date:   Mon, 7 Mar 2022 08:22:49 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH vfio-next] PCI/IOV: Fix wrong kernel-doc identifier
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <8cecf7df45948a256dc56148cf9e87b2f2bb4198.1646652504.git.leonro@nvidia.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <8cecf7df45948a256dc56148cf9e87b2f2bb4198.1646652504.git.leonro@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/7/22 03:33, Leon Romanovsky wrote:
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

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

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

-- 
~Randy

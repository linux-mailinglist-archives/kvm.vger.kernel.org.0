Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB454D1508
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 11:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345958AbiCHKqr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 05:46:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345929AbiCHKqq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 05:46:46 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6CF9D42EF1
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 02:45:50 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3CD5F1FB;
        Tue,  8 Mar 2022 02:45:50 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E71D23FA45;
        Tue,  8 Mar 2022 02:45:48 -0800 (PST)
Date:   Tue, 8 Mar 2022 10:46:10 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Sebastian Ene <sebastianene@google.com>
Cc:     kvm@vger.kernel.org, qperret@google.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, will@kernel.org,
        julien.thierry.kdev@gmail.com
Subject: Re: [PATCH kvmtool v8 3/3] Add --no-pvtime command line argument
Message-ID: <Yicz4klF1ecWDu45@monolith.localdoman>
References: <20220307144243.2039409-1-sebastianene@google.com>
 <20220307144243.2039409-4-sebastianene@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307144243.2039409-4-sebastianene@google.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Looks good to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

On Mon, Mar 07, 2022 at 02:42:44PM +0000, Sebastian Ene wrote:
> The command line argument disables the stolen time functionality when is
> specified.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  builtin-run.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/builtin-run.c b/builtin-run.c
> index 9a1a0c1..7c8be9d 100644
> --- a/builtin-run.c
> +++ b/builtin-run.c
> @@ -128,6 +128,8 @@ void kvm_run_set_wrapper_sandbox(void)
>  			" rootfs"),					\
>  	OPT_STRING('\0', "hugetlbfs", &(cfg)->hugetlbfs_path, "path",	\
>  			"Hugetlbfs path"),				\
> +	OPT_BOOLEAN('\0', "no-pvtime", &(cfg)->no_pvtime, "Disable"	\
> +			" stolen time"),				\
>  									\
>  	OPT_GROUP("Kernel options:"),					\
>  	OPT_STRING('k', "kernel", &(cfg)->kernel_filename, "kernel",	\
> -- 
> 2.35.1.616.g0bdcbb4464-goog
> 

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE646297DF
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 12:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiKOL70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 06:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbiKOL7R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 06:59:17 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E8696CD8
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:59:16 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 383BF13D5;
        Tue, 15 Nov 2022 03:59:22 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1FDB43F73B;
        Tue, 15 Nov 2022 03:59:15 -0800 (PST)
Date:   Tue, 15 Nov 2022 11:59:12 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        alexandru.elisei@arm.com, will@kernel.org
Subject: Re: [PATCH kvmtool v1 01/17] Initialize the return value in
 kvm__for_each_mem_bank()
Message-ID: <20221115115912.1d6f8273@donnerap.cambridge.arm.com>
In-Reply-To: <20221115111549.2784927-2-tabba@google.com>
References: <20221115111549.2784927-1-tabba@google.com>
        <20221115111549.2784927-2-tabba@google.com>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Nov 2022 11:15:33 +0000
Fuad Tabba <tabba@google.com> wrote:

Hi,

> If none of the bank types match, the function would return an
> uninitialized value.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>

Indeed the comment promises to return 0 if there is no error.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  kvm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kvm.c b/kvm.c
> index 42b8812..78bc0d8 100644
> --- a/kvm.c
> +++ b/kvm.c
> @@ -387,7 +387,7 @@ int kvm__for_each_mem_bank(struct kvm *kvm, enum kvm_mem_type type,
>  			   int (*fun)(struct kvm *kvm, struct kvm_mem_bank *bank, void *data),
>  			   void *data)
>  {
> -	int ret;
> +	int ret = 0;
>  	struct kvm_mem_bank *bank;
>  
>  	list_for_each_entry(bank, &kvm->mem_banks, list) {


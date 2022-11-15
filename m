Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E72F062A0E2
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 18:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbiKOR7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 12:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbiKOR6P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 12:58:15 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B89CA303CD
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 09:58:14 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF0BC13D5;
        Tue, 15 Nov 2022 09:58:20 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B31353F587;
        Tue, 15 Nov 2022 09:58:13 -0800 (PST)
Date:   Tue, 15 Nov 2022 17:58:11 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        alexandru.elisei@arm.com, will@kernel.org
Subject: Re: [PATCH kvmtool v1 02/17] Make mmap_hugetlbfs() static
Message-ID: <20221115175811.44b6e98e@donnerap.cambridge.arm.com>
In-Reply-To: <20221115111549.2784927-3-tabba@google.com>
References: <20221115111549.2784927-1-tabba@google.com>
        <20221115111549.2784927-3-tabba@google.com>
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

On Tue, 15 Nov 2022 11:15:34 +0000
Fuad Tabba <tabba@google.com> wrote:

> This function isn't used outside of util.c.
> 
> No functional change intended.

I am not sure if it was once intended to be public, but it's indeed not
used outside, and it looks like we lose this function anyway, so:

> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  include/kvm/util.h | 1 -
>  util/util.c        | 2 +-
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/include/kvm/util.h b/include/kvm/util.h
> index b494548..b0c3684 100644
> --- a/include/kvm/util.h
> +++ b/include/kvm/util.h
> @@ -140,7 +140,6 @@ static inline int pow2_size(unsigned long x)
>  }
>  
>  struct kvm;
> -void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size);
>  void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size);
>  
>  #endif /* KVM__UTIL_H */
> diff --git a/util/util.c b/util/util.c
> index 1877105..093bd3b 100644
> --- a/util/util.c
> +++ b/util/util.c
> @@ -81,7 +81,7 @@ void die_perror(const char *s)
>  	exit(1);
>  }
>  
> -void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
> +static void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
>  {
>  	char mpath[PATH_MAX];
>  	int fd;


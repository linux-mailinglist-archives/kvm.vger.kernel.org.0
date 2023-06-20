Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931D0736C54
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 14:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbjFTMxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 08:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjFTMw6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 08:52:58 -0400
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8EF0D10F8;
        Tue, 20 Jun 2023 05:52:56 -0700 (PDT)
Received: from uucp by elvis.franken.de with local-rmail (Exim 3.36 #1)
        id 1qBaqt-000882-00; Tue, 20 Jun 2023 14:52:55 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 0EDBDC0388; Tue, 20 Jun 2023 14:51:14 +0200 (CEST)
Date:   Tue, 20 Jun 2023 14:51:14 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Yu Zhao <yuzhao@google.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm/mips: update MAINTAINERS
Message-ID: <20230620125113.GE10520@alpha.franken.de>
References: <20230617185335.2025859-1-yuzhao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230617185335.2025859-1-yuzhao@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 17, 2023 at 12:53:35PM -0600, Yu Zhao wrote:
> Aleksandar Markovic was last seen in Oct 2020 [1] and cannot be
> reached for multiple days because of "Recipient inbox full".
> 
> [1] https://lore.kernel.org/all/1602103041-32017-4-git-send-email-aleksandar.qemu.devel@gmail.com/
> 
> Signed-off-by: Yu Zhao <yuzhao@google.com>
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6992b7cc7095..9de60ba04b6d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11379,7 +11379,6 @@ F:	tools/testing/selftests/kvm/aarch64/
>  
>  KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)
>  M:	Huacai Chen <chenhuacai@kernel.org>
> -M:	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
>  L:	linux-mips@vger.kernel.org
>  L:	kvm@vger.kernel.org
>  S:	Maintained
> -- 
> 2.41.0.162.gfafddb0af9-goog
> 

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]

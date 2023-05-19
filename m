Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B0E709FAB
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 21:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbjESTHp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 15:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbjESTHn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 15:07:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7821610E9;
        Fri, 19 May 2023 12:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=o2zq2yq2a0YDhfNMiopEyOFLxVDb+hBel6EWnDnT/HM=; b=z59FFPsQv6Xn/MLGm6KZKXYFQY
        Ey8PL9Td+wUj89nSUJXnZH/wZxm+RMaPTTW8gZ7GIQGoYaIlVjzlOzIlqotbwK65JwRfs9bkMTAT7
        F0id7ZHvFXje9N0KW0bpXV7PAcHCNxGccTVZzU/G2t1b49JTmzAkr69l1LrCyp2F1Nfhm1EYwqQeD
        daXS2qln5qn47dHK37NuMynqUCSzqbzG13pOjR9DuKaxjIYQG6q1CPRMzgSZ5NH5rE3jTk5KZE2oH
        8Aid0Q8C7vvUe4CQzPwXe65+rA3r4TMiCc8wbEI0nJangh/N4Q3qfv2uKQBIrfSOEqXXkxpSaL+S9
        5hLGhhPQ==;
Received: from [2601:1c2:980:9ec0::2764]
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1q05Rd-00H3ER-0u;
        Fri, 19 May 2023 19:07:17 +0000
Message-ID: <3d5f8032-582a-161a-11ab-c112d5de8fbe@infradead.org>
Date:   Fri, 19 May 2023 12:07:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH] KVM: MAINTAINERS: note that linux-kvm.org isn't current
Content-Language: en-US
To:     linux-kernel@vger.kernel.org
Cc:     Ramkumar Ramachandra <artagnon@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20230503231000.14330-1-rdunlap@infradead.org>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20230503231000.14330-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 5/3/23 16:10, Randy Dunlap wrote:
> www.linux-kvm.org is not kept current. It contains antiquated
> and historical information. Don't send people to it for current
> information on KVM.
> 

Any comments on this patch?
Is it incorrect?

Thanks.

> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Ramkumar Ramachandra <artagnon@gmail.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> ---
>  MAINTAINERS |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -- a/MAINTAINERS b/MAINTAINERS
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11334,7 +11334,7 @@ KERNEL VIRTUAL MACHINE (KVM)
>  M:	Paolo Bonzini <pbonzini@redhat.com>
>  L:	kvm@vger.kernel.org
>  S:	Supported
> -W:	http://www.linux-kvm.org
> +W:	http://www.linux-kvm.org (antiquated/historical)
>  T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
>  F:	Documentation/virt/kvm/
>  F:	include/asm-generic/kvm*

-- 
~Randy

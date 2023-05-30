Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5F617171D3
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 01:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbjE3Xj6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 19:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233933AbjE3Xjz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 19:39:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957B6106;
        Tue, 30 May 2023 16:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=3VrqmgexwdgwvHDZsx2ibMTmVuKGqVCDhDSKwBieLuw=; b=yUPt2+JmTnZVpE4w+clXdg7x49
        MbIDc1MjlHG4/lVqiVd6TXOrXwKpVgymmLA+ZgxlakJBUzgTjdFOdpi07belESGdmru5ueXNqVQVw
        n5IEb2zDAsOkLhZnG5yWxFu41CpXGuEsI4w8eIWsOqRG0rU4zEkCJYy9xTwhkolJdBbmIXcOIVT3M
        mYzIkXUt4MsagiYbnWppt3h/flvtA8tsgQLjn/TdhTY1E0WW5+ONDAkKhlQykcx8xtydrLaiwAg2M
        q2qgpF93fl8Qv596ZoIOR7WUPRdGaZ1yhHlujCnypFWIKh7WfjXRLePDr5NsfHE7Z3v80XrYETRj7
        MAnEAdIQ==;
Received: from [2601:1c2:980:9ec0::2764]
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1q48wT-00FV1Y-3D;
        Tue, 30 May 2023 23:39:54 +0000
Message-ID: <da07a09a-fa54-8147-fd04-161082bb46e9@infradead.org>
Date:   Tue, 30 May 2023 16:39:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2] KVM: MAINTAINERS: note that linux-kvm.org isn't
 current
Content-Language: en-US
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20230525153204.27960-1-rdunlap@infradead.org>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20230525153204.27960-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 5/25/23 08:32, Randy Dunlap wrote:
> www.linux-kvm.org is not kept current. It contains antiquated
> and historical information. Don't send people to it for current
> information on KVM.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> ---
> v2: change wording; drop one bouncing email address (Ramkumar)
> 
>  MAINTAINERS |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -- a/MAINTAINERS b/MAINTAINERS
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11359,7 +11359,7 @@ KERNEL VIRTUAL MACHINE (KVM)
>  M:	Paolo Bonzini <pbonzini@redhat.com>
>  L:	kvm@vger.kernel.org
>  S:	Supported
> -W:	http://www.linux-kvm.org
> +W:	http://www.linux-kvm.org (historical/not up-to-date)
>  T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
>  F:	Documentation/virt/kvm/
>  F:	include/asm-generic/kvm*

Any comments about this patch?
Is there a problem with it?

thanks.

-- 
~Randy

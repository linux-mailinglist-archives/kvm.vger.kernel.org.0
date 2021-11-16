Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1D6452FE5
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 12:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234637AbhKPLKx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 06:10:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58178 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234604AbhKPLKu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 06:10:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637060873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0H2l2J2iEQfDhvPsDCS6AGIt6MX5MnVORKpNJMsnnAo=;
        b=VresqLqVuqbOy58aBhp/RlJZ7ilzo2YNRAGJqbvkbyYBpvuXm6Hn2wt0PeZtHpp9ugm2aY
        DMSrOEZytJ5Ketu393X94jCYgvLaZ9bRK1KW2ZRCJfrjqAyg+002/fYBQUIzkJ6nLqUmPp
        iRhN7GcaTByRmY4v6VBv/Q18sDAa9yE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-kxMEO-gaMP-OW5U_U3SEqA-1; Tue, 16 Nov 2021 06:07:49 -0500
X-MC-Unique: kxMEO-gaMP-OW5U_U3SEqA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E555D804142;
        Tue, 16 Nov 2021 11:07:48 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B70335BB0D;
        Tue, 16 Nov 2021 11:07:47 +0000 (UTC)
Message-ID: <85599dcde5c8c6b74437fac28ebb62c38dafc6a8.camel@redhat.com>
Subject: Re: [PATCH] KVM: MMU: update comment on the number of page role
 combinations
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Tue, 16 Nov 2021 13:07:46 +0200
In-Reply-To: <20211116101114.665451-1-pbonzini@redhat.com>
References: <20211116101114.665451-1-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-11-16 at 05:11 -0500, Paolo Bonzini wrote:
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e977634333d4..354fd2a918d5 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -291,9 +291,9 @@ struct kvm_kernel_irq_routing_entry;
>   * the number of unique SPs that can theoretically be created is 2^n, where n
>   * is the number of bits that are used to compute the role.
>   *
> - * But, even though there are 18 bits in the mask below, not all combinations
> + * But, even though there are 20 bits in the mask below, not all combinations
I to be honest counted 19 bits there (which includes the 'smm' bit), but I might have
made a mistake. I do wonder maybe it is better to just remove that comment with explicit
number?

Best regards,
	Maxim Levitsky


>   * of modes and flags are possible.  The maximum number of possible upper-level
> - * shadow pages for a single gfn is in the neighborhood of 2^13.
> + * shadow pages for a single gfn is in the neighborhood of 2^15.
>   *
>   *   - invalid shadow pages are not accounted.
>   *   - level is effectively limited to four combinations, not 16 as the number



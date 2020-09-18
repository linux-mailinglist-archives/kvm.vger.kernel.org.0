Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24052708E3
	for <lists+kvm@lfdr.de>; Sat, 19 Sep 2020 00:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgIRWUw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 18:20:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25593 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726064AbgIRWUw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Sep 2020 18:20:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600467651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SIQtXAOsqtM1oR4TaQIH/rJT9lHX2iWTxjKAODYSNDk=;
        b=bQYXesedVeL84cl2d8EznyW11UXiM/mS6LpbnROhZXwUmzrHgFxZhXUTwKD98Fkx4DtHwv
        0t3k/z50mnjxKNiU35dcb0+NJYrN6kloGHZSSzHIblCJevBr6sC4aSFdIClUhHguegQYF6
        LUazl0o3PfNKgWxX9xVaL+ZajmZ76Ds=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-GIJgSdXhOFSi3TC435yf-w-1; Fri, 18 Sep 2020 18:20:49 -0400
X-MC-Unique: GIJgSdXhOFSi3TC435yf-w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B197188C12D;
        Fri, 18 Sep 2020 22:20:48 +0000 (UTC)
Received: from localhost (unknown [10.10.67.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF75873677;
        Fri, 18 Sep 2020 22:20:47 +0000 (UTC)
Date:   Fri, 18 Sep 2020 18:20:46 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org
Subject: Re: [Qemu-devel] [PATCH] i386/kvm: fix FEATURE_HYPERV_EDX value in
 hyperv_passthrough case
Message-ID: <20200918222046.GF57321@habkost.net>
References: <20190820103030.12515-1-zhenyuw@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190820103030.12515-1-zhenyuw@linux.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 20, 2019 at 06:30:30PM +0800, Zhenyu Wang wrote:
> Fix typo to use correct edx value for FEATURE_HYPERV_EDX when
> hyperv_passthrough is enabled.
> 
> Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>

CCing other maintainers (please use ./scripts/get_maintainer.pl
to make sure maintainers don't miss patches).

Queued, thanks!

> ---
>  target/i386/kvm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 2abc881324..101229bce4 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -1152,7 +1152,7 @@ static int hyperv_handle_properties(CPUState *cs,
>          if (c) {
>              env->features[FEAT_HYPERV_EAX] = c->eax;
>              env->features[FEAT_HYPERV_EBX] = c->ebx;
> -            env->features[FEAT_HYPERV_EDX] = c->eax;
> +            env->features[FEAT_HYPERV_EDX] = c->edx;
>          }
>          c = cpuid_find_entry(cpuid, HV_CPUID_ENLIGHTMENT_INFO, 0);
>          if (c) {
> -- 
> 2.20.1
> 
> 

-- 
Eduardo


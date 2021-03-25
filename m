Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792053496C7
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 17:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhCYQ2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 12:28:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26361 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229669AbhCYQ21 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 12:28:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616689707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DH8v/mJfXUA91yRwJZuk088ZpE3xOULkExoChd07zMA=;
        b=ULj2nXn/SfcA7hsy0pmmE3DFqcnWYAJXu3BfI2jTjwFMAxw6Q3dvuDvMR3R2GV55JcHczR
        dS8c3qGAMkmfL9m+4onZd6jX+claNoEo8sTy3Jxcxx8lpFtQNdthacfNeo6i1a3frohyDz
        4mlKtjodzS2UhYfKSW/vTR0MNTrzQL4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-N0usjx7hM_eZNCdtdBLLLw-1; Thu, 25 Mar 2021 12:28:24 -0400
X-MC-Unique: N0usjx7hM_eZNCdtdBLLLw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B82FC180FCA2;
        Thu, 25 Mar 2021 16:28:23 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B5EE29685;
        Thu, 25 Mar 2021 16:28:22 +0000 (UTC)
Date:   Thu, 25 Mar 2021 17:28:19 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     nikos.nikoleris@arm.com, alexandru.elisei@arm.com
Subject: Re: [PATCH kvm-unit-tests 0/2] arm64: One fix and one improvement
Message-ID: <20210325162819.fq3f3hflwkl56qfg@kamzik.brq.redhat.com>
References: <20210325155657.600897-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325155657.600897-1-drjones@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 25, 2021 at 04:56:55PM +0100, Andrew Jones wrote:
> Fix the loading of argc. Nikos reported an issue with its alignment
> while testing target-efi (aligned to four bytes is OK, as long as we
> only load four bytes like we should). Also, take a patch developed
> while working on target-efi which can make debugging a bit more
> convenient (by doing some subtraction for the test developer).
> 
> Andrew Jones (2):
>   arm64: argc is an int
>   arm64: Output PC load offset on unhandled exceptions
> 
>  arm/cstart64.S        | 2 +-
>  arm/flat.lds          | 1 +
>  lib/arm64/processor.c | 7 +++++++
>  3 files changed, 9 insertions(+), 1 deletion(-)
> 
> -- 
> 2.26.3
>

Thanks for the review, Nikos!

Applied to arm/queue

https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue

Thanks,
drew 


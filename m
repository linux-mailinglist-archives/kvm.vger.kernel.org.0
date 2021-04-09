Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FF835A49F
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 19:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbhDIR3V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 13:29:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21150 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232642AbhDIR3U (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Apr 2021 13:29:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617989346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4jOEysMDcr2tvzutbV8RQEQptQcRllpRkvzLUbWY8aI=;
        b=KbD00JninpC4v5tlMKpjlo4X3e4MLmcB5sw6tWzORc8lYheoV4/0j6Yo0tPxtvYJUdk52E
        Ig3ALfRgoYjqW6SC//J80v2+fOvbSMJ4fKmH8rLs7FeucUqLJwNGD6hsznpuSCd1OuNNNe
        /rVSXsapjkIrAbUI/SG9PIe9LtgvryU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-oQDzYZuqOK6evyLxW4_uMw-1; Fri, 09 Apr 2021 13:29:02 -0400
X-MC-Unique: oQDzYZuqOK6evyLxW4_uMw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5CB0107ACCD;
        Fri,  9 Apr 2021 17:29:01 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.185])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 78E1E19704;
        Fri,  9 Apr 2021 17:28:57 +0000 (UTC)
Date:   Fri, 9 Apr 2021 19:28:54 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, alexandru.elisei@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests 1/8] arm/arm64: Reorganize cstart assembler
Message-ID: <20210409172854.fymhqxna5vwjjk73@kamzik.brq.redhat.com>
References: <20210407185918.371983-1-drjones@redhat.com>
 <20210407185918.371983-2-drjones@redhat.com>
 <cd8f7e2a-9d53-6793-a0dd-bf58ab491ad1@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd8f7e2a-9d53-6793-a0dd-bf58ab491ad1@arm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 09, 2021 at 06:18:05PM +0100, Nikos Nikoleris wrote:
> On 07/04/2021 19:59, Andrew Jones wrote:
> > +exceptions_init:
> > +	mrc	p15, 0, r2, c1, c0, 0	@ read SCTLR
> > +	bic	r2, #CR_V		@ SCTLR.V := 0
> > +	mcr	p15, 0, r2, c1, c0, 0	@ write SCTLR
> > +	ldr	r2, =vector_table
> > +	mcr	p15, 0, r2, c12, c0, 0	@ write VBAR
> > +
> > +	mrs	r2, cpsr
> > +
> > +	/*
> > +	 * Input r0 is the stack top, which is the exception stacks base
> 
> Minor, feel free to ignore - wouldn't it be better to put this comment at
> the start of this routine to inform the caller?

Yes, that's a good suggestion. Will do for v2.

> 
> I am not sure about the practical implications of having an .init section
> but in any case, moving secondary_entry helper functions to .text seems
> sensible.
> 
> Reviewed-by Nikos Nikoleris <nikos.nikoleris@arm.com>

Thanks,
drew


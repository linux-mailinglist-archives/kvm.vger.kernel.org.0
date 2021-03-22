Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950D8343C1F
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 09:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhCVIyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 04:54:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32314 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229482AbhCVIxr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Mar 2021 04:53:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616403226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pssS4RZUY845Ih5JssJgGRrZ/xA2JgSjfiNKphl/u0Y=;
        b=GST2x98bJFAdQSAVhrNzLg0x+77rk6PSmBHT/+TRU/jOXAqSpjNQIgi0Cmf3yn5fUbIs3w
        ocTdJfCM8144hv1evGe6hyBZSvy66jXYaTHISt8G/NlnEKf8PK8tP2mPR1ximClazF0nuw
        01CKxYPozCrDOyTit2qkIau0AKx+Cac=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-LnucKic3PvCeVhpyb6zPZg-1; Mon, 22 Mar 2021 04:53:42 -0400
X-MC-Unique: LnucKic3PvCeVhpyb6zPZg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44A35190A7A3;
        Mon, 22 Mar 2021 08:53:41 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A919E6A03C;
        Mon, 22 Mar 2021 08:53:39 +0000 (UTC)
Date:   Mon, 22 Mar 2021 09:53:36 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com,
        andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Fix the devicetree parser for
 stdout-path
Message-ID: <20210322085336.2lxg457refhvntls@kamzik.brq.redhat.com>
References: <20210318180727.116004-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318180727.116004-1-nikos.nikoleris@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 18, 2021 at 06:07:23PM +0000, Nikos Nikoleris wrote:
> This set of patches fixes the way we parse the stdout-path
> property in the DT. The stdout-path property is used to set up
> the console. Prior to this, the code ignored the fact that
> stdout-path is made of the path to the uart node as well as
> parameters. As a result, it would fail to find the relevant DT
> node. In addition to minor fixes in the device tree code, this
> series pulls a new version of libfdt from upstream.
> 
> v1: https://lore.kernel.org/kvm/20210316152405.50363-1-nikos.nikoleris@arm.com/
> 
> Changes in v2:
>   - Added strtoul and minor fix in strrchr
>   - Fixes in libfdt_clean
>   - Minor fix in lib/libfdt/README
> 
> Thanks,
> 
> Nikos
>

Applied to arm/queue

https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue

Thanks,
drew 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38C432C671
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347019AbhCDA2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:28:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30997 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240455AbhCCOjr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 09:39:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614782299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aA0ryNvB4RqgkXaIipbDqJ057yJGCC4FNfu7WES52T0=;
        b=IJav01vY9PosaaSLGiKdf2r+YAkrOUonIxCgMuNbaIvTlA8aQGOaEk1oi5Ze+rVhjnq3MR
        pvt1YF3Rni1KfiQc9Sd7uFBfT+R1ZYGF6MuPqZXr5uSgVSaOMsThtPuHqR2Z1oQ2Mb0Hfo
        reJRYAVFitgeRKpKAEsLnw6/Spxls9A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-7Qtqn3AiOJi1lChWk9bqlg-1; Wed, 03 Mar 2021 09:38:15 -0500
X-MC-Unique: 7Qtqn3AiOJi1lChWk9bqlg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33580100A8ED;
        Wed,  3 Mar 2021 14:38:14 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-115-146.ams2.redhat.com [10.36.115.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 201D11E2B4;
        Wed,  3 Mar 2021 14:38:02 +0000 (UTC)
Subject: Re: [PATCH v1 2/2] exec: Get rid of phys_mem_set_alloc()
To:     David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Peter Xu <peterx@redhat.com>
References: <20210303130916.22553-1-david@redhat.com>
 <20210303130916.22553-3-david@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <dae7136e-964a-2235-8301-4d9487e8ed30@redhat.com>
Date:   Wed, 3 Mar 2021 15:38:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210303130916.22553-3-david@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/2021 14.09, David Hildenbrand wrote:
> As the last user is gone, we can get rid of phys_mem_set_alloc() and
> simplify.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Halil Pasic <pasic@linux.ibm.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: Igor Mammedov <imammedo@redhat.com>
> Cc: Peter Xu <peterx@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>   include/sysemu/kvm.h |  4 ----
>   softmmu/physmem.c    | 36 +++---------------------------------
>   2 files changed, 3 insertions(+), 37 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>


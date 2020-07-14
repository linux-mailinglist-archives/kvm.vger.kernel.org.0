Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BA621E7C4
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 08:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgGNGBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 02:01:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51284 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725306AbgGNGA7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 02:00:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594706458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xA+AGEEDIXYwXJAHC9PpCVfllA/Q9UsGCwd9OJ0DYbM=;
        b=TK0hO9ptlWPBF04AxQCfiF7eywyJbz42RBgDrdpbVtf6GlL6706vk7ouPuD2/CU1esaC6Y
        KaBpZOe3O+9aX74Tb65ix0o8hkah4lP/jh4UGLj8sG058oRgNNBDw4vHtmR4i0XJrMkBIs
        rY/TddhxKC9aijUmL+yM3el0oxMrnD4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-QlTnBVpuP1eP33xEmbi10Q-1; Tue, 14 Jul 2020 02:00:55 -0400
X-MC-Unique: QlTnBVpuP1eP33xEmbi10Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9758BD1C40;
        Tue, 14 Jul 2020 06:00:54 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.163])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E65460BEC;
        Tue, 14 Jul 2020 06:00:52 +0000 (UTC)
Date:   Tue, 14 Jul 2020 08:00:50 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [kvm-unit-tests PATCH] lib/alloc_page: Revert to 'unsigned long'
 for @size params
Message-ID: <20200714060050.sn7ic4xasbx7ejuf@kamzik.brq.redhat.com>
References: <20200714042046.13419-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714042046.13419-1-sean.j.christopherson@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 13, 2020 at 09:20:46PM -0700, Sean Christopherson wrote:
> Revert to using 'unsigned long' instead of 'size_t' for free_pages() and
> get_order().  The recent change to size_t for free_pages() breaks i386
> with -Werror as the assert_msg() formats expect unsigned longs, whereas
> size_t is an 'unsigned int' on i386 (though both longs and ints are 4
> bytes).
> 
> Message formatting aside, unsigned long is the correct choice given the
> current code base as alloc_pages() and free_pages_by_order() explicitly
> expect, work on, and/or assert on the size being an unsigned long.
> 
> Fixes: 73f4b202beb39 ("lib/alloc_page: change some parameter types")
> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: Andrew Jones <drjones@redhat.com>
> Cc: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  lib/alloc_page.c | 2 +-
>  lib/alloc_page.h | 2 +-
>  lib/bitops.h     | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>

Fixes compilation on arm32.

Reviewed-by: Andrew Jones <drjones@redhat.com>


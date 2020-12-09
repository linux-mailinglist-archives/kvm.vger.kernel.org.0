Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4382D409E
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 12:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730276AbgLILFY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 06:05:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60896 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730333AbgLILFS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 06:05:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607511832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V9ED7y33WZFdYac2SIgpnjaRtqiWoNdY5OgIrvna/kU=;
        b=GBdtDQYc46LSDuJS4wJpfTHirafupyDPqGzIxvhCqbqw58YjEEs3nRh30rlCoKNLE+rIp6
        sb8gQrhNzSy9JNL/rWzvIqI6reS8BOUi8ZMgidMaGtmzTM3mfBKtVcLhesLQcpjhVy6Yna
        JV/dVvU1+j6/0liFa+7q+k/61uH5PXg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-aIRfv37mOk2CODuPjm8zaQ-1; Wed, 09 Dec 2020 06:03:48 -0500
X-MC-Unique: aIRfv37mOk2CODuPjm8zaQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D02857051;
        Wed,  9 Dec 2020 11:03:47 +0000 (UTC)
Received: from gondolin (ovpn-113-135.ams2.redhat.com [10.36.113.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 382B75D9D3;
        Wed,  9 Dec 2020 11:03:43 +0000 (UTC)
Date:   Wed, 9 Dec 2020 12:03:40 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 2/2] s390x: lib: Move to GPL 2 and SPDX
 license identifiers
Message-ID: <20201209120340.342f9993.cohuck@redhat.com>
In-Reply-To: <20201208150902.32383-3-frankja@linux.ibm.com>
References: <20201208150902.32383-1-frankja@linux.ibm.com>
        <20201208150902.32383-3-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  8 Dec 2020 10:09:02 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> In the past we had some issues when developers wanted to use code
> snippets or constants from the kernel in a test or in the library. To
> remedy that the s390x maintainers decided to move all files to GPL 2
> (if possible).
> 
> At the same time let's move to SPDX identifiers as they are much nicer
> to read.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/asm-offsets.c     | 4 +---
>  lib/s390x/asm/arch_def.h    | 4 +---
>  lib/s390x/asm/asm-offsets.h | 4 +---
>  lib/s390x/asm/barrier.h     | 4 +---
>  lib/s390x/asm/cpacf.h       | 1 +
>  lib/s390x/asm/facility.h    | 4 +---
>  lib/s390x/asm/float.h       | 4 +---
>  lib/s390x/asm/interrupt.h   | 4 +---
>  lib/s390x/asm/io.h          | 4 +---
>  lib/s390x/asm/mem.h         | 4 +---
>  lib/s390x/asm/page.h        | 4 +---
>  lib/s390x/asm/pgtable.h     | 4 +---
>  lib/s390x/asm/sigp.h        | 4 +---
>  lib/s390x/asm/spinlock.h    | 4 +---
>  lib/s390x/asm/stack.h       | 4 +---
>  lib/s390x/asm/time.h        | 4 +---
>  lib/s390x/css.h             | 4 +---
>  lib/s390x/css_dump.c        | 4 +---
>  lib/s390x/css_lib.c         | 4 +---
>  lib/s390x/interrupt.c       | 4 +---
>  lib/s390x/io.c              | 4 +---
>  lib/s390x/mmu.c             | 4 +---
>  lib/s390x/mmu.h             | 4 +---
>  lib/s390x/sclp-console.c    | 5 +----
>  lib/s390x/sclp.c            | 4 +---
>  lib/s390x/sclp.h            | 5 +----
>  lib/s390x/smp.c             | 4 +---
>  lib/s390x/smp.h             | 4 +---
>  lib/s390x/stack.c           | 4 +---
>  lib/s390x/vm.c              | 3 +--
>  lib/s390x/vm.h              | 3 +--
>  31 files changed, 31 insertions(+), 90 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>


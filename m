Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F13E4144D15
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 09:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgAVIQc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 03:16:32 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49499 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726605AbgAVIQc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jan 2020 03:16:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579680991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vfeSJ6F0nEddjP+igWsid6S/Vas3Bh+OdHl4YzNrPGo=;
        b=R7gaOycxmh3t8Y3PKGnME/yB9kr0O+HLm0vw1CUBnXM27TbX76K18UeV8xwVkbcUCuAJIa
        1QY/VbJptIBUh6NbXSxCmCZXvhq0ZWZZB35wDEQcwuVoMdL2TbHYYEw+fFKh9Un3FKbrkx
        icKv5N6oh43dFG6uRqmywgtij+BERZg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-3zhFXkHjOzauUNphW-sXNw-1; Wed, 22 Jan 2020 03:16:29 -0500
X-MC-Unique: 3zhFXkHjOzauUNphW-sXNw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2C99800D48
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2020 08:16:28 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7048D5C1BB;
        Wed, 22 Jan 2020 08:16:25 +0000 (UTC)
Date:   Wed, 22 Jan 2020 09:16:23 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] Remove the old api folder
Message-ID: <20200122081623.j2i2olcpc6ixf6hv@kamzik.brq.redhat.com>
References: <20200121174719.31156-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121174719.31156-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 21, 2020 at 06:47:19PM +0100, Thomas Huth wrote:
> The api tests are quite neglected - the tests work for 32-bit i386 only
> and there hasn't been any change in this folder since more than 2.5 years.
> Additionally, there is nowadays another way of testing the KVM API - the
> KVM selftests (as part of the Linux kernel sources) have a much higher
> traction and feature much more tests already, so it's unlikely that the
> API tests in the kvm-unit-tests repository will get much more attention
> in the future. Thus let's delete the api folder now to remove the burder
> from the kvm-unit-test maintainers of dragging this code along.
> If someone still wants to run the dirty-log-perf test for example, they
> can check out an older state of the repository (and then e.g. port the
> code to the KVM selftests framework instead).
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  Makefile              |   2 -
>  api/api-sample.cc     |  30 -------
>  api/dirty-log-perf.cc | 146 -------------------------------
>  api/dirty-log.cc      |  84 ------------------
>  api/exception.cc      |  33 -------
>  api/exception.hh      |  19 ----
>  api/identity.cc       | 120 -------------------------
>  api/identity.hh       |  45 ----------
>  api/kvmxx.cc          | 199 ------------------------------------------
>  api/kvmxx.hh          |  86 ------------------
>  api/memmap.cc         |  96 --------------------
>  api/memmap.hh         |  43 ---------
>  configure             |  17 ----
>  x86/Makefile.common   |  19 +---
>  14 files changed, 1 insertion(+), 938 deletions(-)
>  delete mode 100644 api/api-sample.cc
>  delete mode 100644 api/dirty-log-perf.cc
>  delete mode 100644 api/dirty-log.cc
>  delete mode 100644 api/exception.cc
>  delete mode 100644 api/exception.hh
>  delete mode 100644 api/identity.cc
>  delete mode 100644 api/identity.hh
>  delete mode 100644 api/kvmxx.cc
>  delete mode 100644 api/kvmxx.hh
>  delete mode 100644 api/memmap.cc
>  delete mode 100644 api/memmap.hh
>

No objections from me.

Acked-by: Andrew Jones <drjones@redhat.com>


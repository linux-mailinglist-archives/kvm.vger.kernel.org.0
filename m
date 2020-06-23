Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0913204DB4
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 11:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732146AbgFWJSZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 05:18:25 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27299 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731735AbgFWJSY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Jun 2020 05:18:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592903903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CfnLed3EmdqbWeg4skLqNDsC7ZqeohtA8a6yn0mbkZo=;
        b=C5Pm8fs6kFL4iSEegLTj3XT8cjiILnTW0cl36e/LC1IPwYK7O5aChtuFlS40KJIRK9wulM
        ew2P+URSEa8y0TI/n1r9OlxPg/7VsT7J49P871d+7rysbJX7Vx9ZolfN7JaIZy3nON7G/F
        PdJW1JjqnvVOOLxDrtCSoWYycaHEhdI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-6TrjvSv5OmqkNy4Q1L1BvQ-1; Tue, 23 Jun 2020 05:18:19 -0400
X-MC-Unique: 6TrjvSv5OmqkNy4Q1L1BvQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC6C5107ACCD;
        Tue, 23 Jun 2020 09:18:18 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.84])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EE73D11A9F2;
        Tue, 23 Jun 2020 09:18:14 +0000 (UTC)
Date:   Tue, 23 Jun 2020 11:18:07 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Laurent Vivier <lvivier@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 0/2] target/arm: Fix using pmu=on on KVM
Message-ID: <20200623091807.vlqy53ckagcrhoah@kamzik.brq.redhat.com>
References: <20200623090622.30365-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200623090622.30365-1-philmd@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 11:06:20AM +0200, Philippe Mathieu-Daudé wrote:
> Since v2:
> - include Drew test fix (addressed Peter review comments)
> - addressed Drew review comments
> - collected R-b/A-b
> 
> Andrew Jones (1):
>   tests/qtest/arm-cpu-features: Add feature setting tests
> 
> Philippe Mathieu-Daudé (1):
>   target/arm: Check supported KVM features globally (not per vCPU)
> 
>  target/arm/kvm_arm.h           | 21 ++++++++-----------
>  target/arm/cpu.c               |  2 +-
>  target/arm/cpu64.c             | 10 ++++-----
>  target/arm/kvm.c               |  4 ++--
>  target/arm/kvm64.c             | 14 +++++--------
>  tests/qtest/arm-cpu-features.c | 38 ++++++++++++++++++++++++++++++----
>  6 files changed, 56 insertions(+), 33 deletions(-)
> 
> -- 
> 2.21.3
> 
>

Hi Phil,

Thanks for including the test patch. To avoid breaking bisection, if one
were to use qtest to bisect something, then the order of patches should
be reversed. I guess Peter can apply them that way without a repost
though.

Thanks,
drew 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00DCA57E09
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 10:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfF0IRA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 04:17:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51762 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbfF0IQ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 04:16:59 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 85F7F81DFE;
        Thu, 27 Jun 2019 08:16:55 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D00AC5D71D;
        Thu, 27 Jun 2019 08:16:52 +0000 (UTC)
Date:   Thu, 27 Jun 2019 10:16:50 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        lkft-triage@lists.linaro.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        karl.heubaum@oracle.com, andre.przywara@arm.com, cdall@kernel.org
Subject: Re: Pre-required Kconfigs for kvm unit tests
Message-ID: <20190627081650.frxivyrykze5mqdv@kamzik.brq.redhat.com>
References: <CA+G9fYtVU2FoQ_cH71edFH-YfyFWZwi4s7tPxMW6aFG0pDEjPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtVU2FoQ_cH71edFH-YfyFWZwi4s7tPxMW6aFG0pDEjPA@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Thu, 27 Jun 2019 08:16:59 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 27, 2019 at 12:45:18PM +0530, Naresh Kamboju wrote:
> Hi,
> 
> We (kernel validation team) at Linaro running KVM unit tests [1] on arm64
> and x86_64 architectures. Please share the Kernel configs fragments required
> for better testing coverage.
> Thank you.
> 
> [1] https://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
>

For arm64 if you're testing on a host with a latest kernel installed,
which of course has KVM enabled, and all the kvm-unit-tests test are
passing (except for the GIC tests that are not appropriate for your
host, which will be skipped), then you're getting all the coverage
those tests provide.

I'm not sure about x86_64, but I imagine a similar statement to what
I said for arm64 applies. If you don't get all passes, then you can
check your host's config to see if there are KVM* symbols disabled
that look relevant.

drew

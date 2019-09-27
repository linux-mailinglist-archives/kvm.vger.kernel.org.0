Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E52DC051D
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 14:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbfI0M0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 08:26:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36396 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbfI0M0j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 08:26:39 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 86F4A301A3AE;
        Fri, 27 Sep 2019 12:26:39 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 157176092F;
        Fri, 27 Sep 2019 12:26:37 +0000 (UTC)
Date:   Fri, 27 Sep 2019 14:26:35 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 4/6] arm: selftest: Split variable output
 data from test name
Message-ID: <20190927122635.mqrmbltk2qevfl24@kamzik.brq.redhat.com>
References: <20190927104227.253466-1-andre.przywara@arm.com>
 <20190927104227.253466-5-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190927104227.253466-5-andre.przywara@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 27 Sep 2019 12:26:39 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 27, 2019 at 11:42:25AM +0100, Andre Przywara wrote:
> For some tests we mix variable diagnostic output with the test name,
> which leads to variable test line, confusing some higher level
> frameworks.
> 
> Split the output to always use the same test name for a certain test,
> and put diagnostic output on a separate line using the INFO: tag.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/selftest.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arm/selftest.c b/arm/selftest.c
> index 28a17f7..a0c1ab8 100644
> --- a/arm/selftest.c
> +++ b/arm/selftest.c
> @@ -43,13 +43,16 @@ static void check_setup(int argc, char **argv)
>  			phys_addr_t memsize = PHYS_END - PHYS_OFFSET;
>  			phys_addr_t expected = ((phys_addr_t)val)*1024*1024;
>  
> -			report("size = %" PRIu64 " MB", memsize == expected,
> -							memsize/1024/1024);
> +			report("memory size matches expectation",
> +			       memsize == expected);
> +			report_info("found %" PRIu64 " MB", memsize/1024/1024);
>  			++nr_tests;
>  
>  		} else if (strcmp(argv[i], "smp") == 0) {
>  
> -			report("nr_cpus = %d", nr_cpus == (int)val, nr_cpus);
> +			report("number of CPUs matches expectation",
> +			       nr_cpus == (int)val);
> +			report_info("found %d CPUs", nr_cpus);
>  			++nr_tests;
>  		}
>  
> -- 
> 2.17.1
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

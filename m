Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5A3D7448BE
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 13:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjGALg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 07:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbjGALg5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 07:36:57 -0400
Received: from out-44.mta1.migadu.com (out-44.mta1.migadu.com [IPv6:2001:41d0:203:375::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B7C125
        for <kvm@vger.kernel.org>; Sat,  1 Jul 2023 04:36:56 -0700 (PDT)
Date:   Sat, 1 Jul 2023 13:36:53 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688211414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YBvC6sOrm4wRWuwcqWzdggFaCdorVGVrRBynMg0oiWk=;
        b=rhh57uYrqwtoXOc2YgD3mDla4psJPn+fvpp/Elx3LRx9eU9FAwnKJ3YcMm9RXe0EYr/4dO
        WDqS+ML1qVlQO4jhmgYxwI4xMbp0uBNIYQaPvMFx1mfQbRQAWohaRt1Ys6Hlw4hwWoNxIh
        eMEPpOmhhz0Aie/lCbKR7HYzwyzh42Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
        oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com,
        alexandru.elisei@arm.com, mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 5/6] arm: pmu: Add
 pmu-mem-access-reliability test
Message-ID: <20230701-daff0cec48c2329abd7ede9f@orel>
References: <20230619200401.1963751-1-eric.auger@redhat.com>
 <20230619200401.1963751-6-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619200401.1963751-6-eric.auger@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 19, 2023 at 10:04:00PM +0200, Eric Auger wrote:
...
> @@ -1201,6 +1257,9 @@ int main(int argc, char *argv[])
>  	} else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
>  		run_event_test(argv[1], test_basic_event_count, false);
>  		run_event_test(argv[1], test_basic_event_count, true);
> +	} else if (strcmp(argv[1], "pmu-mem-access-reliability") == 0) {
> +		run_event_test(argv[1], test_mem_access_reliability, false);
> +		run_event_test(argv[1], test_mem_access_reliability, true);

This breaks compilation for arm since this patch is missing the stub.
I've added it.

Thanks,
drew

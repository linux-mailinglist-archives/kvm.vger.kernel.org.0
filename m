Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A475F5FDC15
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 16:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiJMOI4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 10:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiJMOIy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 10:08:54 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BCB3B991
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 07:08:52 -0700 (PDT)
Date:   Thu, 13 Oct 2022 16:03:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665669829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tMLLjzExU7dyZIpfIM2MYbSkAvR8HWFe064JD3V1aBg=;
        b=AN8cjlpDr2rWEnrEFuzFjON5zg80dq84VcuqMn+zG+JQhjvhtiouj1GWpAzzuRlEjA/ow9
        4j9KaJrutga6GTEJQ4VgqQWqCtzB0JVbRvTQ91ZQfRFoGFHgD2vkpI5TJByeB9Sx/XlprQ
        QiUi+YR439OKeTM6VKzUR++rjRVRJLc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        Colton Lewis <coltonlewis@google.com>,
        Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v2 0/3] KVM: selftests: Rename perf_test_util to memstress
Message-ID: <20221013140348.gsyap4eackrcz6nk@kamzik>
References: <20221012165729.3505266-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221012165729.3505266-1-dmatlack@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 12, 2022 at 09:57:26AM -0700, David Matlack wrote:
> This series renames the perf_test_util to memstress. patch 1 renames the files
> perf_test_util.[ch] to memstress.[ch], and patch 2 replaces the perf_test_
> prefix on symbols with memstress_.
> 
> The reason for this rename, as with any rename, is to improve readability.
> perf_test_util is too generic and does not describe at all what the library
> does, other than being used for perf tests.
> 
> I considered a lot of different names (naming is hard) and eventually settled
> on memstress for a few reasons:
> 
>  - "memstress" better describes the functionality proveded by this library,
>    which is to run a VM that reads/writes to memory from all vCPUs in parallel
>    (i.e. stressing VM memory).
> 
>  - "memstress" contains the same number of characters as "perf_test", making
>    it a drop in replacement in symbols wihout changing line lengths.
> 
>  - The lack of underscore between "mem" and "stress" makes it clear "memstress"
>    is a noun, avoiding confusion in function names.
> 
> Looking to the future, I think "memstress" will remain a good name. Specifically
> there are some in-flight improvements that will make this library even more of
> a "memory stress tester":
> 
>  - A proposed series by yours truly [1] extends memstress/perf_test_util to
>    support execute from memory, in addition to reading/writing.
> 
>  - Colton Lewis within Google is looking into adding support for more complex
>    memory access patterns.
> 
> [1] https://lore.kernel.org/kvm/20220401233737.3021889-2-dmatlack@google.com/
> 
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Cc: Colton Lewis <coltonlewis@google.com>
> Cc: Ricardo Koller <ricarkol@google.com>
> Acked-by: Andrew Jones <andrew.jones@linux.dev>
> 
> v2:
>  - Add precursor patch to rename pta to args [Sean]
> 
> v1: https://lore.kernel.org/kvm/20220919232300.1562683-1-dmatlack@google.com/
>  - Rebased on top of kvm/queue
>  - Drop RFC tag.
>  - Add Andrew's Acked-by.
> 
> RFC: https://lore.kernel.org/kvm/20220725163539.3145690-1-dmatlack@google.com/
>

For the series

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

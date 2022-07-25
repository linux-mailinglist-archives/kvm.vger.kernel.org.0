Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA38580334
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 18:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236564AbiGYQ5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 12:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236081AbiGYQ5R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 12:57:17 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3EA63DF
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 09:57:15 -0700 (PDT)
Date:   Mon, 25 Jul 2022 18:57:11 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1658768233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hXIsG/ER28svLpnFSDYU/MJwEmMJZuw6Vcy1KBjYwi8=;
        b=N/yNJ8C9Z+uEotr1vTybLwAa+jsyyd3369l/Op9mKgAjWg++54voYNjMcMwnLffYcMhlPy
        UzchFo+HMii4+zKJzdsK0C3o13ONZeqrwx/kUAENOLI92/6nni1vLujn+g5LqhALOzOp4N
        3ZJO/zfq+NKtSlhqebvNzVZiZD4J778=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Ricardo Koller <ricarkol@google.com>
Subject: Re: [RFC PATCH 0/2] KVM: selftests: Rename perf_test_util to
 memstress
Message-ID: <20220725165711.apcurnmn6nnh7uov@kamzik>
References: <20220725163539.3145690-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725163539.3145690-1-dmatlack@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 25, 2022 at 04:35:37PM +0000, David Matlack wrote:
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

Naming is hard, acking rename patches that have good justifications is
easy.  For the series,

Acked-by: Andrew Jones <andrew.jones@linux.dev>

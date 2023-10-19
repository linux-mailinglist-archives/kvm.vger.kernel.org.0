Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB18D7D02B9
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 21:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345827AbjJSTs5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 15:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346254AbjJSTsx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 15:48:53 -0400
Received: from out-204.mta1.migadu.com (out-204.mta1.migadu.com [IPv6:2001:41d0:203:375::cc])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453EACA
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 12:48:51 -0700 (PDT)
Date:   Thu, 19 Oct 2023 19:48:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697744929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RNFnPBmT2kHe/G+q+68d98VWZ+QYophr/LlHSTV8/EI=;
        b=anX6JKvlYo0Yi9SMAJDTrarE3mzr6InthamthjBiN5U3lQpOmda0W+juCnabIfAyRx5xpJ
        23fhU9sPZms4E20zsQ6y3S86ZU4juOKMvm0FtsUnlpgrUTFzJh6uHYZ+yuYPRzHJTTLG0w
        MLQ4uhmS5R9Yj5+YvakGPyxDFHXAnhs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Eric Auger <eauger@redhat.com>
Cc:     Mark Brown <broonie@kernel.org>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org,
        Jing Zhang <jingzhangos@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 4/5] tools headers arm64: Update sysreg.h with kernel
 sources
Message-ID: <ZTGIGRXVWySGzDo8@linux.dev>
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-5-oliver.upton@linux.dev>
 <73b94274-4561-1edd-6b1e-8c6245133af2@redhat.com>
 <3c5332b0-9035-4cb8-96ce-7a9b8d513c3a@sirena.org.uk>
 <8baca35a-9154-97e6-d682-032fc69d2da6@redhat.com>
 <ZTBzAR1KsWuurob7@linux.dev>
 <48d09c9f-78d9-e5eb-d85a-e75a6df81396@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48d09c9f-78d9-e5eb-d85a-e75a6df81396@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 19, 2023 at 10:43:34AM +0200, Eric Auger wrote:

[...]

> OK np. I did not notice you picked the series up and I jumped in too
> late. Anyway that was worthwhile for my education ;-)

And as always, patches welcome :) We're getting close to the next
release and I'd like to have the majority of the kvmarm PR baking in
next for a while. But fixes are easy to stack on top.

Thanks again for the reviews.

-- 
Best,
Oliver

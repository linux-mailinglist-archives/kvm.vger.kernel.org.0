Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2929D6DD64A
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 11:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjDKJKP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 05:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbjDKJJt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 05:09:49 -0400
Received: from out-18.mta0.migadu.com (out-18.mta0.migadu.com [IPv6:2001:41d0:1004:224b::12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F5D46B1
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 02:08:46 -0700 (PDT)
Date:   Tue, 11 Apr 2023 11:08:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1681204125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I2iC8buvK2tS8ozL9BHGlo/Sy4UT6qIVUL5c6wk4p6g=;
        b=jDlTpk0mHI9HGFG/mMYsZ8feUXZFsTYrXMBV5wrpq5gBMwvb/D9qBQrkCPFRqNvyAJEb4W
        P4y8LBz10RyPFh4MBpBmxUQknrrQybLiS/mbE8byvPCvvIGCxYHg6xrzoKogdNXTySydbl
        /Ezp9qgwjnJyILNj90gjOzfVQUX4280=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.linux.dev,
        qemu-arm@nongnu.org
Subject: Re: [kvm-unit-tests PATCH v10 0/7] MTTCG sanity tests for ARM
Message-ID: <hlno75xnob6jwbpfzwbwsjje2ujgfzw5kwvwmu2627obkmpqk2@dtcvgno2dkge>
References: <20230307112845.452053-1-alex.bennee@linaro.org>
 <20230321152649.zae7edlfub76fyqq@orel>
 <87mt3erhe3.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87mt3erhe3.fsf@linaro.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 11, 2023 at 08:43:49AM +0100, Alex Bennée wrote:
> 
> Andrew Jones <andrew.jones@linux.dev> writes:
...
> > Someday mkstandalone could maybe learn how to build
> > a directory hierarchy using the group names, e.g.
> >
> >  tests/mttcg/tlb/all_other
> 
> So nodefault isn't enough for this?
>

nodefault is enough to avoid running a test with run_tests.sh,
when its group hasn't been explicitly selected, i.e.

 ./run_tests.sh

doesn't run the test

 ./run_tests.sh -g test-group-name

does run the test.

standalone test filtering is only done by filename (but
potentially pathname), which is why I suggested we someday use
the group names as directory names. Anyway, that's future work.
This series just needs to ensure it gets its group names right.

Thanks,
drew

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2AF68CA95
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 00:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjBFXdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 18:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjBFXdH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 18:33:07 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B79BBA4;
        Mon,  6 Feb 2023 15:33:06 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1675726384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jEFEAA9/CFuhiUmVZK0xjgJMU7aqZIve5gky9EqH2Kk=;
        b=Z9BfjV6LiKODTzCSutmLhH4KqzfGy45M/Kswe6IaYWFqwphx8pXw0S4OcqyiruEPpxU/8w
        rC6V17reO5+1aPLNUgNMVyrFciHVvM5C5RL1nb8aluvEms6MhbWgL4OJf5iL3wC5n0k8rm
        NFqUThJosfAjyuA1aUgv4y/3oeyrybNpRv5IT/fzsVNEQUQJsZhobyfQwIHS88RcxYmKXI
        rsrETHEasaYnD5ktVBfZC1UubQvblmkJxuzL94Sax5LZLx+ns4Foav2WpfPdTcyNN+6iIq
        oTFIULx1ttxRaeKQ3kMYXwSv1Xl5fgk/XMXs+2+UbhQmQKVpFNDDj6Sq+D4Xdg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1675726384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jEFEAA9/CFuhiUmVZK0xjgJMU7aqZIve5gky9EqH2Kk=;
        b=A5Ek8e0Yg551Afv+hTl4MyEaBsT4ixMYhs4ahf2gWVMxNMhnycQxap0bX3dnv1Z4X/WLkk
        HDmdsAgtLr1eSqDA==
To:     Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        arjan@linux.intel.com
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [PATCH v6 02/11] cpu/hotplug: Move idle_thread_get() to
 <linux/smpboot.h>
In-Reply-To: <20230202215625.3248306-3-usama.arif@bytedance.com>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230202215625.3248306-3-usama.arif@bytedance.com>
Date:   Tue, 07 Feb 2023 00:33:03 +0100
Message-ID: <877cwuxtcg.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 02 2023 at 21:56, Usama Arif wrote:
> If the architecture code is to register its new pre-bringup states with
> the cpuhp core, having a special-case wrapper to pass extra arguments is
> non-trivial and it's easier just to let the arch register its function
> pointer to be invoked with the standard API.
>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>

Same issue vs. the SOB chain.

Other than that:

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

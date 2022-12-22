Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1336541DA
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 14:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbiLVNaD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 08:30:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiLVNaC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 08:30:02 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB245DEBD;
        Thu, 22 Dec 2022 05:30:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UC5sPR3EvgT3U5gH57DbtpsT89KjhvNVVQKmHsn4rzQ=; b=pvxSS0Tp+/m9AZ/Pk1hcjKHD5W
        J7yJt/hn3P4egTwDSx7qAx/tUFRPjGgZcioR0HAKog6Vw0NaR5ZSXR2oZxBEEUZPyirTFKZckV7gd
        TRAuv92umVFH3eVVnZr83f/Has9QPB8elFC8TkLnXzOlNA9XiKYRcLCLQXs1Zvbd9zqFX9GkV+hAb
        +bmOw3cUA7MDdWbAemWPeAo+fJaUnHZDDanqHoCfSi+JStk4IVpyqH3uHA2hiC8JrYx69iVt/KY1R
        TihL+IUXZ3Qm2BmQ4KWLz2ssWnMPwEPf3jMIW7T+H4LfQbTLpiil1yC+jdJaliXKih/zwtYbKB/SW
        gck2/lLA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1p8Ldu-00DqLI-0m;
        Thu, 22 Dec 2022 13:29:50 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id AD3FB30006D;
        Thu, 22 Dec 2022 14:29:50 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 90AE02D9A10D8; Thu, 22 Dec 2022 14:29:50 +0100 (CET)
Date:   Thu, 22 Dec 2022 14:29:50 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kan.liang@linux.intel.com, wei.w.wang@intel.com,
        Like Xu <like.xu@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: Re: [PATCH v2 01/15] perf/x86/lbr: Simplify the exposure check for
 the LBR_INFO registers
Message-ID: <Y6RbzsVHy6UZht0Q@hirez.programming.kicks-ass.net>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-2-weijiang.yang@intel.com>
 <449b561a-7053-8994-bcfe-581c0abb8d85@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <449b561a-7053-8994-bcfe-581c0abb8d85@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 22, 2022 at 06:57:50PM +0800, Like Xu wrote:
> Hi Peter, would you help apply this one in your tip/perf tree,
> as it doesn't seem to be closely tied to the KVM changes. Thanks.

OK, I'll go queue it for perf/core after -rc1

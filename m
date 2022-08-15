Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64BE592F95
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 15:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242882AbiHONPS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 09:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242967AbiHONPD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 09:15:03 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45881C939;
        Mon, 15 Aug 2022 06:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tTGETpHW5R2mfqk8rZP1Ho8w5dJ89jQ8JLN7hMMSh2A=; b=U9vEcKA+E3hf104AkcSM3CjngV
        K7qex48Y6/ZDo6P9BXtf9o59ImVLCCO5d2HYo7q6vqm83WwLmaX0BRPM85HBe0wQ+iE9990zuB/1O
        JWfIopv/daORDTAW4jmoCrAQL1M+l8Ytd2GAedYbW548u1E3gML4ojsTfixJ8IVsn6z143HmCo2Qi
        mPJJa/ZXrgZUZvFGYLENTSjzLumxT+4lu7zQdPCDf8xeszlBL+/nYtoGXqmK5XO3w9MraLXnVAyvj
        K/Y7JOrweyfTt2sQqETJP/XXNpqEuJsIziHjVkrDEPeaSv9kW/Ov98EaJuW93ITdyHdnoPhA8dNXM
        5WDDV+uQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oNZva-002g3n-6d; Mon, 15 Aug 2022 13:14:46 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 34D7F980153; Mon, 15 Aug 2022 15:14:45 +0200 (CEST)
Date:   Mon, 15 Aug 2022 15:14:45 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/7] perf/x86/core: Update x86_pmu.pebs_capable for
 ICELAKE_{X,D}
Message-ID: <YvpGxaSRK3T5SOQB@worktop.programming.kicks-ass.net>
References: <20220721103549.49543-1-likexu@tencent.com>
 <20220721103549.49543-2-likexu@tencent.com>
 <959fedce-aada-50e4-ce8d-a842d18439fa@redhat.com>
 <YvoSXyy7ojZ9ird/@worktop.programming.kicks-ass.net>
 <94e6c414-38e1-ebd7-0161-34548f0b5aae@gmail.com>
 <YvozNSvcxet0gX6b@worktop.programming.kicks-ass.net>
 <a592d15d-7c29-d18e-809d-b32bf3dee276@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a592d15d-7c29-d18e-809d-b32bf3dee276@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 15, 2022 at 08:48:36PM +0800, Like Xu wrote:

> In the SDM world, we actually have three PEBS sub-features:
> 
> [July 2017] 18.5.4.1 Extended PEBS (first on Goldmont Plus)
> [January 2019] 18.9.2 Adaptive PEBS (first on Tremont)
> [April 2021] IA32_PERF_CAPABILITIES.PEBS_BASELINE in the Table 2-2. IA-32
> Architectural MSRs
> 
> Waiting Kan to confirm the real world.

Right, so it's possible GLM would need the FMS thing, but AFAIK ICX
has Baseline and therefore shouldn't need it.

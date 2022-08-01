Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67CDB586DF9
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 17:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbiHAPn7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 11:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbiHAPn6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 11:43:58 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F3A14D01
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 08:43:57 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id m2so4048361pls.4
        for <kvm@vger.kernel.org>; Mon, 01 Aug 2022 08:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=srygWdx8d4se0PmEFGFe6jDGC1ROcbuSUTTUzXR+U60=;
        b=UBQr3olEQOSB/KKSSuv6X2/OWLC0qDCajvMUWhtTnpIezahdrC29P2taYJ7JcBD2Yt
         G+pgegJ4gU8RhkcXRnGMPSdxuUvJsCudQ7uWYgw/dAfDsczAmgQcHXFAvCK9tvzkHRRv
         J4sx96tb0UHpMVEltPpuUWP3/86K6A4kZZDKSWTuvPzF6CC9aWp6ME0eW0d4BiqsGdKq
         9oYIffAdAgi5H/zXGKQ5v3AuKyw6ke9geqv3pMkSw8HB0KpqvFLxaH6I3Y9DasmK+rHP
         NDOMLGWV0Lw8H2HGTviObas4tGW7vcDel27AxcskQa4SJBc2HkXeNtp5YArFCFdEEr4H
         HyMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=srygWdx8d4se0PmEFGFe6jDGC1ROcbuSUTTUzXR+U60=;
        b=SDKBsNo6XoHTyUSKmzbKCM//rtaO7uuegB1Kj0SfaS+7UW0jLZt7Gxs81/hkWJuDBG
         Q8gInFzR509K00agC1w45K8Zbq6c9DosWIUcfkU8Xsj+RZ+ptp50jUOVNaNsfoC7etYC
         SaxbkqoMpvTHmUr/2DtElPXf8oSmmMTdqyiAKI9ZriDrRxsjpA+Q35LxXu/5QcvaBpl1
         zJfzdEudTRuQYddhWBlRm9yowefbGnrlv31KjG/FprmVSc39lLMSE3zGIFSN64AgsGjw
         jHsDV/fHF/EO/zB+bDIgKdbPTBDvmHTaDgK7PVO/GW9fiwHHotu24ZMHC6tPNM11Lzra
         WbLw==
X-Gm-Message-State: ACgBeo08Qnq+onLhuEHuIRhAe1oqEB9VJjSGHQrkYO0WRtrNd4JSwxsO
        zoeUv7ryPc/UyVMcSaIF22wkHw==
X-Google-Smtp-Source: AA6agR5nlbTBKy69JPsbsgakwUHpDOTbE3KRr+tIryr+gj7s3empLDRv9U6XD86NUgqryiNgT7lMjQ==
X-Received: by 2002:a17:902:d487:b0:16e:e328:fd41 with SMTP id c7-20020a170902d48700b0016ee328fd41mr7340018plg.73.1659368636576;
        Mon, 01 Aug 2022 08:43:56 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i127-20020a625485000000b0052d87effe9asm2332755pfb.18.2022.08.01.08.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 08:43:56 -0700 (PDT)
Date:   Mon, 1 Aug 2022 15:43:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests  PATCH] x86/pmu: Reset the expected count of the
 fixed counter 0 when i386
Message-ID: <Yuf0uJeN5n3AvXPg@google.com>
References: <20220801131814.24364-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801131814.24364-1-likexu@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 01, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> The pmu test check_counter_overflow() always fails with the "./configure
> --arch=i386". The cnt.count obtained from the latter run of measure()
> (based on fixed counter 0) is not equal to the expected value (based
> on gp counter 0) and there is a positive error with a value of 2.
> 
> The two extra instructions come from inline wrmsr() and inline rdmsr()
> inside the global_disable() binary code block. Specifically, for each msr
> access, the i386 code will have two assembly mov instructions before
> rdmsr/wrmsr (mark it for fixed counter 0, bit 32), but only one assembly
> mov is needed for x86_64 and gp counter 0 on i386.
> 
> Fix the expected init cnt.count for fixed counter 0 overflow based on
> the same fixed counter 0, not always using gp counter 0.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  x86/pmu.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 01be1e9..4bb24e9 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -304,6 +304,10 @@ static void check_counter_overflow(void)
>  
>  		if (i == nr_gp_counters) {
>  			cnt.ctr = fixed_events[0].unit_sel;
> +			cnt.count = 0;
> +			measure(&cnt, 1);

Not directly related to this patch...

Unless I've missed something, every invocation of start_event() and measure() first
sets evt.count=0.  Rather than force every caller to ensure count is zeroed, why not
zero the count during start_event() and then drop all of the manual zeroing?

diff --git a/x86/pmu.c b/x86/pmu.c
index 01be1e90..ef804272 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -141,7 +141,7 @@ static void global_disable(pmu_counter_t *cnt)

 static void start_event(pmu_counter_t *evt)
 {
-    wrmsr(evt->ctr, evt->count);
+    wrmsr(evt->ctr, 0);
     if (is_gp(evt))
            wrmsr(MSR_P6_EVNTSEL0 + event_to_global_idx(evt),
                            evt->config | EVNTSEL_EN);


Accumulating counts can be handled by reading the current count before start_event(),
and doing something like stuffing a high count to test an edge case could be handled
by an inner helper, e.g. by adding __start_event().

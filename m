Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC44587DEB
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 16:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237197AbiHBOJn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 10:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234097AbiHBOJm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 10:09:42 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890AD2B25B
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 07:09:41 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id f7so14044408pjp.0
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 07:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=2gNvEAENo1OIVuK749BPGwDzRCqdAQhy7NAuMimv7uU=;
        b=TL7SWXq4x35jo30zd59pKFzHPuDAJhaqqiYFTExOJUX8Qnt3qbbyi5FRV5JhIEV/xx
         X5jB/2QnlvfDGZdRPFOBrOJQ5CqFJpI/IfMuqzQVXHcDdg069C+Cd41J+taSOaOyJELx
         LH3ltSlzWikLuXgVvEs7NsEeTjHwr8dycY8AJAwA9ijPrV4X74kOC4VsDiWcjTkaAbBZ
         crnr3GvdIDGNx6MXmBEUtgE0RcU6Sk+Yb3tX8AkL1SrHTXWL3ucNTBh/VT5Q6DzdAmOf
         Xwxk+OC34KFrc0O4J/Yg3nXVGYSheer2jHJX2wERezRAj5dio2pSmH2MKXSMrrYkWQ3Q
         TCDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=2gNvEAENo1OIVuK749BPGwDzRCqdAQhy7NAuMimv7uU=;
        b=FHBfnN12EmUCJA45iutVa6pZkx3UHMUvfF/YDGkErkDf3RIDvMb736CDtHfbCW8Col
         Bb71qjeyxJLbUoHLWbkcfqMWy7twi3tP7uBPcvBfVMHavEH+iMUU6efd4N6CLj2g+8j1
         CSdrGxEJ8tMtfLiTSKMdFr5nAHhLReVdyPN/RsVNs7qMVM6NafNvUkaWYYTQF97b7GE2
         KFPz9GjYnk14If4x3rRm1JMJgOcuK4vSWmCjXupzbL3UQG7Uib2L7UMec8vSkHVvPz55
         oDkq4x+j49XwzcuVyJT1/pkcZ7c5xM8WZADaCLZgNdNygSJDRAU0KNN6HzJcLrmNMfTC
         8WwA==
X-Gm-Message-State: ACgBeo0kYK8ManvYOw8ROgV/nayfRWEqOmxSNcvcrvB7IBXdjdljZt/N
        83kHKMaLbE1KIMgO3kAUKNwAmg==
X-Google-Smtp-Source: AA6agR5GQ1NVe4vUCI8/Kh7Cm9nzm2Ne3oyf9Equi45y5D1WPzqdheuHpkzaG8A4MYjfM6RxsPdu9Q==
X-Received: by 2002:a17:90b:1e46:b0:1f2:9f69:3f5e with SMTP id pi6-20020a17090b1e4600b001f29f693f5emr24533367pjb.228.1659449380854;
        Tue, 02 Aug 2022 07:09:40 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k16-20020a170902ce1000b0016d05661f00sm11790595plg.189.2022.08.02.07.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 07:09:40 -0700 (PDT)
Date:   Tue, 2 Aug 2022 14:09:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] x86/pmu: Reset the expected count of the
 fixed counter 0 when i386
Message-ID: <YukwIDuo/uN3CXT3@google.com>
References: <20220801131814.24364-1-likexu@tencent.com>
 <Yuf0uJeN5n3AvXPg@google.com>
 <9dce3dbb-ffa1-687a-d1c4-8234d1bf6cfb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9dce3dbb-ffa1-687a-d1c4-8234d1bf6cfb@gmail.com>
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

On Tue, Aug 02, 2022, Like Xu wrote:
> On 1/8/2022 11:43 pm, Sean Christopherson wrote:
> > Not directly related to this patch...
> > 
> > Unless I've missed something, every invocation of start_event() and measure() first
> > sets evt.count=0.  Rather than force every caller to ensure count is zeroed, why not
> > zero the count during start_event() and then drop all of the manual zeroing?
> > 
> 
> None object to this idea, after all, there is obvious redundancy here.
> 
> > diff --git a/x86/pmu.c b/x86/pmu.c
> > index 01be1e90..ef804272 100644
> > --- a/x86/pmu.c
> > +++ b/x86/pmu.c
> > @@ -141,7 +141,7 @@ static void global_disable(pmu_counter_t *cnt)
> > 
> >   static void start_event(pmu_counter_t *evt)
> >   {
> > -    wrmsr(evt->ctr, evt->count);
> > +    wrmsr(evt->ctr, 0);
> 
> Now we have to fix the last call to measure() in check_counter_overflow(),
> since it will also call start_event() after it has been modified and in that
> case, the requested high count has to be passed in from another function
> parameter.

Drat, I suspected an overflow case would want to use a non-zero count, and I
explicitly looked for that case and _still_ missed it.

Anyways, why not just open code measure() for that one-off case?

		__start_event(&cnt, cnt.count);
		loop();
		stop_event(&cnt);

> Also, the naming of start_event() does not imply that the counter will be set
> to zero implicitly, it just lets a counter continue to run, not caring about
> the current value of the counter, which is more flexible.

Sure, but flexibility isn't the only consideration.  Readability and robustness
also matter.  And IMO, requiring callers to zero out a field in the common case
isn't exactly flexible.

Looking at pmu.c more, measure() is guilty of the same bad behavior.  It forces
the common case to pass in unnecessary information in order to give flexibility to
a single use case.  It's just syntatic sugar, but it really does help readers as
it's not obvious that the "1" specifies the number of events, whereas measure_one()
vs. measure_many() are relatively self-explanatory.

---
 x86/pmu.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 01be1e90..e67f1fc2 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -177,7 +177,7 @@ static void stop_event(pmu_counter_t *evt)
 	evt->count = rdmsr(evt->ctr);
 }

-static void measure(pmu_counter_t *evt, int count)
+static void measure_many(pmu_counter_t *evt, int count)
 {
 	int i;
 	for (i = 0; i < count; i++)
@@ -187,6 +187,11 @@ static void measure(pmu_counter_t *evt, int count)
 		stop_event(&evt[i]);
 }

+static void measure_one(pmu_counter_t *evt)
+{
+	measure_many(evt, 1);
+}
+
 static bool verify_event(uint64_t count, struct pmu_event *e)
 {
 	// printf("%d <= %ld <= %d\n", e->min, count, e->max);
@@ -210,7 +215,7 @@ static void check_gp_counter(struct pmu_event *evt)

 	for (i = 0; i < nr_gp_counters; i++, cnt.ctr++) {
 		cnt.count = 0;
-		measure(&cnt, 1);
+		measure_one(&cnt);
 		report(verify_event(cnt.count, evt), "%s-%d", evt->name, i);
 	}
 }
@@ -238,7 +243,7 @@ static void check_fixed_counters(void)
 	for (i = 0; i < nr_fixed_counters; i++) {
 		cnt.count = 0;
 		cnt.ctr = fixed_events[i].unit_sel;
-		measure(&cnt, 1);
+		measure_one(&cnt);
 		report(verify_event(cnt.count, &fixed_events[i]), "fixed-%d", i);
 	}
 }
@@ -267,7 +272,7 @@ static void check_counters_many(void)
 		n++;
 	}

-	measure(cnt, n);
+	measure_many(cnt, n);

 	for (i = 0; i < n; i++)
 		if (!verify_counter(&cnt[i]))
@@ -286,7 +291,7 @@ static void check_counter_overflow(void)
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
 		.count = 0,
 	};
-	measure(&cnt, 1);
+	measure_one(&cnt);
 	count = cnt.count;

 	/* clear status before test */
@@ -312,7 +317,7 @@ static void check_counter_overflow(void)
 		else
 			cnt.config &= ~EVNTSEL_INT;
 		idx = event_to_global_idx(&cnt);
-		measure(&cnt, 1);
+		measure_one(&cnt);
 		report(cnt.count == 1, "cntr-%d", i);
 		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
 		report(status & (1ull << idx), "status-%d", i);
@@ -333,7 +338,7 @@ static void check_gp_counter_cmask(void)
 		.count = 0,
 	};
 	cnt.config |= (0x2 << EVNTSEL_CMASK_SHIFT);
-	measure(&cnt, 1);
+	measure_one(&cnt);
 	report(cnt.count < gp_events[1].min, "cmask");
 }


base-commit: 14b54ed754c8a8cae7a22895e4a0b745a3227a4b
--


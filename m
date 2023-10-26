Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4169C7D8BDF
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 00:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344764AbjJZWzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 18:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjJZWy7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 18:54:59 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580811AB
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 15:54:57 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da04fb79246so1074328276.2
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 15:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698360896; x=1698965696; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/PM5QRoJM5E7sHxdU8Gpjb3WFwx2mvG39y2sogXNJnc=;
        b=Iscmo+e/Vgq5HNgCpEb7sBAezNDvU36C/6HFzQZRV7N9oNthzc6ErojSxiDaAYN8ao
         3S8ZkGKFnqjfDVL+C+xst7/uTUIUz3ZmqDjRRyQ0QVtZlKsvvYNDPGt/b7cJc8D7FTZI
         2ZJWZn/lWVcKDZ1j6oCy+pUkRqCDNa7jwdS+DXSVSbw8IH7MYUXEQ9EybFCvCDH0urQl
         rZFP2KRqEl+89Aaxagz16WWM0g9OaXsHtSXK58VKoubqPoja6g7A33E9ujwc3hfYiYX6
         kEDa8wyU5UC+QVnqjC3khfDw+QSxMkCnWc6Z5Mdsmp5k08jCGjHxtagZIF5KInnS/1HC
         23FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698360896; x=1698965696;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/PM5QRoJM5E7sHxdU8Gpjb3WFwx2mvG39y2sogXNJnc=;
        b=td/DBe1+TxPZOkYZIqlT5PICszl/sA8K9aAJ2spTB/bX9geO9zog/U3fC4MzlAfqjH
         4OIlcVNlPRmmb6jj3NwPfV8YUt5iv4AtdPeXIIodKP0r/E0kkXYEFUNsGMeRMccS62Hv
         Cjzb5LlkioUe1RNzY/hWYISERgFj7EHx0x35t+OcM2dR74MOLIcbKZSK3CjQ/Qc3t2ej
         qEjfTTVEnyGODiatL8pPiK4Pj8X22yn4HPfsI+i8SebBXQWMJLa+uzQ5cfuqLv/CnREr
         CWcIb4jK4XynW9sqJTv5DYLTAuvHMQZj49BHVPA3u68Hu/r1qdqLafL/tYbMjjPmh0Tg
         HOCQ==
X-Gm-Message-State: AOJu0Yw0mr7emQgmniToc7Ld7NSKstgvq1KajGOuvo01T2TtEvkbliec
        Sby4dNR0O+09780mcGhjM4ZHKmNSuEs=
X-Google-Smtp-Source: AGHT+IErkEF/8uXxnLXeqR1mA+NdLf9/5+DzWEFWLO0C17ItryM4hgcXADqSB6htfL1r3+UGfZ+aiSEUAmw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1746:b0:d9a:59cb:8bed with SMTP id
 bz6-20020a056902174600b00d9a59cb8bedmr15832ybb.5.1698360896597; Thu, 26 Oct
 2023 15:54:56 -0700 (PDT)
Date:   Thu, 26 Oct 2023 15:54:55 -0700
In-Reply-To: <ZTrj1CRKLOVbcytz@google.com>
Mime-Version: 1.0
References: <20231024002633.2540714-1-seanjc@google.com> <20231024002633.2540714-9-seanjc@google.com>
 <ZTrOYztylSn7jNIE@google.com> <ZTrR638_KyKOwLIz@google.com> <ZTrj1CRKLOVbcytz@google.com>
Message-ID: <ZTruPxjaU7NfrSOC@google.com>
Subject: Re: [PATCH v5 08/13] KVM: selftests: Test Intel PMU architectural
 events on gp counters
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jinrong Liang <cloudliang@tencent.com>,
        Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 26, 2023, Mingwei Zhang wrote:
> On Thu, Oct 26, 2023, Sean Christopherson wrote:
> > Heh, already did this too.  Though I'm not entirely sure it's more readable.  It's
> > definitely more precise and featured :-)
> > 
> Oh dear, this is challenging to my rusty inline assembly skills :)
> 
> > #define GUEST_MEASURE_EVENT(_msr, _value, clflush, FEP)				\
> > do {										\
> > 	__asm__ __volatile__("wrmsr\n\t"					\
> > 			     clflush "\n\t"					\
> > 			     "mfence\n\t"					\
> > 			     "1: mov $" __stringify(NUM_BRANCHES) ", %%ecx\n\t"	\
> > 			     FEP "loop .\n\t"					\
> > 			     FEP "mov %%edi, %%ecx\n\t"				\
> > 			     FEP "xor %%eax, %%eax\n\t"				\
> > 			     FEP "xor %%edx, %%edx\n\t"				\
> > 			     "wrmsr\n\t"					\
> > 			     : "+c"((int){_msr})				\
> isn't it NUM_BRANCHES?

Nope.  It's hard to see because this doesn't provide the usage, but @_msr is an
MSR index that is consumed by the first "wrmsr", i.e. this blob relies on the
compiler to preload ECX, EAX, and EDX for WRMSR.  NUM_BRANCHES is manually loaded
into ECX after WRMSR (WRMSR and LOOP both hardcode consuming ECX).

Ha!  I can actually drop the "+c" clobbering trick since ECX is restored to its
input value before the asm blob finishes.  EDI is also loaded with _@msr so that
it can be quickly reloaded into ECX for the WRMSR to disable the event.

The purpose of doing both WRMSRs in assembly is to ensure the compiler doesn't
insert _any_ code into the measured sequence, e.g. so that a random Jcc doesn't
throw off instructions retired.

> > 			     : "a"((uint32_t)_value), "d"(_value >> 32),	\
> > 			       "D"(_msr)					\
> > 	);									\
> > } while (0)
> >
> 
> do we need this label '1:' in the above code? It does not seems to be
> used anywhere within the code.

It's used by the caller as the target for CLFLUSH{,OPT}.

	if (this_cpu_has(X86_FEATURE_CLFLUSHOPT))				\
		GUEST_MEASURE_EVENT(_ctrl_msr, _value, "clflushopt 1f", FEP);	\
	else if (this_cpu_has(X86_FEATURE_CLFLUSH))				\
		GUEST_MEASURE_EVENT(_ctrl_msr, _value, "clflushopt 1f", FEP);	\
	else									\
		GUEST_MEASURE_EVENT(_ctrl_msr, _value, "nop", FEP);		\
> 
> why is clflush needed here?

As suggested by Jim, it allows verifying LLC references and misses by forcing
the CPU to evict the cache line that holds the MOV at 1: (and likely holds most
of the asm blob).

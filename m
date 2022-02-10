Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217454B16A0
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 20:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241311AbiBJTz7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 14:55:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240256AbiBJTz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 14:55:58 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65F75F4D
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 11:55:57 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id f17so11545764wrx.1
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 11:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yKXi8a/Wa+eHPps1BTbaSB0zXEKBLOSOppniPn0Pfis=;
        b=KIXghY7d76EqIZgH/qH4nyQVkopww5BOB6AJy5l4PXaZ5jCK7em88mfurNu5Ida8hL
         Hd+qyi5a01MP6MBUf4LDsMSa+Q/8B31GglQs5wpcLDcvT/hC6tt1QlH7qUDUoS8JAwOw
         7uHT4UFJ8t2UVgK4jkm3eRQZVA0ct581Cve2ixO7l/cmytZ0lORhDcl+wgZfw2RqDVO0
         z1N0LQMOp+1/fL734/hGMOcRUL0GCzFqxoAW3V43RR3NU3Zc2D/7ra3WXmw1mvTcTIo9
         9pPeliJJD17cI7jkOpIxXlwlftl5ba7R4J8a30KTRiPadnfw1AmfUy4cVogqC4BybqtC
         SECg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yKXi8a/Wa+eHPps1BTbaSB0zXEKBLOSOppniPn0Pfis=;
        b=n6e7pp1+lCv0Vnj5XIgHC9l8BgEsBS3+Rg1my1DhnBl/L9rFF7BygyTP/3oMd9j8mq
         7fmTt+4ul/k9xlW3oOzPR71w4G7PdZGTvpxhqUZ64IMnO+cVxOKCryA3yI3oE4x7M1DX
         saEpan80EgDA836MtMjVeoFyh8KQPY9oXqAMnyD/iGoAmf3JtYK70tqzWGfqFU18sIyL
         knjvu5zewowOIcy+H2+kB/cCrqEVKFjYSEGqt7R6b28I7z9Px7N8sIFvNXWYWwk5vLg8
         r2VhSgZLL8jL1BlscS36tIXHYDdDrETTy3fgPSwpiyh7DX91ThBVBLzLQGVbbWk11GQY
         ObhQ==
X-Gm-Message-State: AOAM531DJUhgxhCcQhd0lO72QgB1UCzkAX/j5/WPDrg1izSzYlwmwlgg
        K6J5Z0mzpi7TI6+x0fW3UdTADXZOIg8pqCR/JR8wtw==
X-Google-Smtp-Source: ABdhPJxD0pCxNdOmKrGTVovOyqWedlEr8LeptuwH7w5huyxy8bVVuZzqCTDtFsTK21uvq0eYwkNSjCcnEv50EEynGBI=
X-Received: by 2002:a05:6000:1ac5:: with SMTP id i5mr7904367wry.703.1644522956333;
 Thu, 10 Feb 2022 11:55:56 -0800 (PST)
MIME-Version: 1.0
References: <20220117085307.93030-1-likexu@tencent.com> <20220117085307.93030-3-likexu@tencent.com>
 <20220202144308.GB20638@worktop.programming.kicks-ass.net>
 <CALMp9eRBOmwz=mspp0m5Q093K3rMUeAsF3vEL39MGV5Br9wEQQ@mail.gmail.com>
 <YgO/3usazae9rCEh@hirez.programming.kicks-ass.net> <69c0fc41-a5bd-fea9-43f6-4724368baf66@intel.com>
 <CALMp9eS=1U7T39L-vL_cTXTNN2Li8epjtAPoP_+Hwefe9d+teQ@mail.gmail.com>
 <67a731dd-53ba-0eb8-377f-9707e5c9be1b@intel.com> <CABOYuvbPL0DeEgV4gsC+v786xfBAo3T6+7XQr7cVVzbaoFoEAg@mail.gmail.com>
 <7b5012d8-6ae1-7cde-a381-e82685dfed4f@linux.intel.com> <CALMp9eTOaWxQPfdwMSAn-OYAHKPLcuCyse7BpsSOM35vg5d0Jg@mail.gmail.com>
 <e06db1a5-1b67-28ac-ee4c-34ece5857b1f@linux.intel.com> <CALMp9eSjDro169JjTXyCZn=Rf3PT0uHhdNXEifiXGYQK-Zn8LA@mail.gmail.com>
 <d86ba87b-d98a-53a0-b2cd-5bf77b97b592@linux.intel.com>
In-Reply-To: <d86ba87b-d98a-53a0-b2cd-5bf77b97b592@linux.intel.com>
From:   David Dunn <daviddunn@google.com>
Date:   Thu, 10 Feb 2022 11:55:45 -0800
Message-ID: <CABOYuvZ9SZAWeRkrhhhpMM4XwzMzXv9A1WDpc6z8SUBquf0SFQ@mail.gmail.com>
Subject: Re: [PATCH kvm/queue v2 2/3] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
To:     "Liang, Kan" <kan.liang@linux.intel.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kan,

On Thu, Feb 10, 2022 at 11:46 AM Liang, Kan <kan.liang@linux.intel.com> wrote:

> No, we don't, at least for Linux. Because the host own everything. It
> doesn't need the MSR to tell which one is in use. We track it in an SW way.
>
> For the new request from the guest to own a counter, I guess maybe it is
> worth implementing it. But yes, the existing/legacy guest never check
> the MSR.

This is the expectation of all software that uses the PMU in every
guest.  It isn't just the Linux perf system.

The KVM vPMU model we have today results in the PMU utilizing software
simply not working properly in a guest.  The only case that can
consistently "work" today is not giving the guest a PMU at all.

And that's why you are hearing requests to gift the entire PMU to the
guest while it is running. All existing PMU software knows about the
various constraints on exactly how each MSR must be used to get sane
data.  And by gifting the entire PMU it allows that software to work
properly.  But that has to be controlled by policy at host level such
that the owner of the host knows that they are not going to have PMU
visibility into guests that have control of PMU.

Dave Dunn

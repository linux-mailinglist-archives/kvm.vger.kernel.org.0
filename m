Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C04608FA9
	for <lists+kvm@lfdr.de>; Sat, 22 Oct 2022 23:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiJVVKn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Oct 2022 17:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiJVVKk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Oct 2022 17:10:40 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F9271BE0;
        Sat, 22 Oct 2022 14:10:33 -0700 (PDT)
Received: from [127.0.0.1] ([73.223.250.219])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 29ML8eEF2420262
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Sat, 22 Oct 2022 14:08:40 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 29ML8eEF2420262
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2022100601; t=1666472925;
        bh=6+RY9iRcpIT3J7CLCZno8RRf3RLOv3Q087OMBJ+x97E=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=ua66S0skPTe1vO2SZSgS2viQ/FflA40OHsC3Pj6699LV7Bi5V/d4NdVcSlOqA15Yn
         Nxm+uQeMGlSaUqJ/UCCEnLlIQypZc8URTE/hnB9O4RElzY8oWyusHAZz+Big61WNVW
         jKkHpNeZOqeT0AwMD9RpBbQ+H/skXhgNMWlz4jvAKEZrm2PTg4L7BywspYB4c9QL62
         nhjMptrmaBHP98aAzh+knOS3p4JrTDZ/pZNm/n0YPcMp20ttKwmBF1BTTw4u/WY9dq
         5GEHlfxQWApwWVJ7xHiyQr7b43sUqLOFqnD1YuYPQef4GAupHNcFBvO/Xb1Vs1wwBz
         p/E3WpuQTLe2Q==
Date:   Sat, 22 Oct 2022 14:08:37 -0700
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     Borislav Petkov <bp@alien8.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
CC:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Jane Malalane <jane.malalane@citrix.com>,
        Kees Cook <keescook@chromium.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-perf-users@vger.kernel.org,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_1/5=5D_perf/x86/intel/lbr=3A_use_?= =?US-ASCII?Q?setup=5Fclear=5Fcpu=5Fcap_instead_of_clear=5Fcpu=5Fcap?=
User-Agent: K-9 Mail for Android
In-Reply-To: <Y1EOBAaLbv2CXBDL@zn.tnic>
References: <20220718141123.136106-1-mlevitsk@redhat.com> <20220718141123.136106-2-mlevitsk@redhat.com> <Yyh9RDbaRqUR1XSW@zn.tnic> <c105971a72dfe6d46ad75fb7e71f79ba716e081c.camel@redhat.com> <YzGlQBkCSJxY+8Jf@zn.tnic> <c1168e8bd9077a2cc9ef61ee06db7a4e8c0f1600.camel@redhat.com> <Y1EOBAaLbv2CXBDL@zn.tnic>
Message-ID: <892F8AE5-9FF9-4452-A6A7-A130C49D0C51@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On October 20, 2022 1:59:48 AM PDT, Borislav Petkov <bp@alien8=2Ede> wrote:
>On Wed, Sep 28, 2022 at 01:49:34PM +0300, Maxim Levitsky wrote:
>> Patch 5 is the main fix - it makes the kernel to be tolerant to a
>> broken CPUID config (coming hopefully from hypervisor), where you have
>> a feature (AVX2 in my case) but not a feature on which this feature
>> depends (AVX)=2E
>
>I really really don't like it when people are fixing the wrong thing=2E
>
>Why does the kernel need to get fixed when something else can't get its
>CPUID dependencies straight? I don't even want to know why something
>would set AVX2 without AVX?!?!
>
>Srsly=2E
>
>Some of your other bits look sensible and I'd take a deeper look but
>this does not make any sense=2E This is a hypervisor problem - not a
>kernel one=2E
>
>Thx=2E
>

Yes, this is utterly nonsensical and it will break user space applications=
 left, right, and center=2E

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C891F695987
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 07:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbjBNG6s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 01:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbjBNG6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 01:58:47 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF2B1BFD;
        Mon, 13 Feb 2023 22:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=hh93QJSzJXeEFYKHfLEX59pgmkulE3ucU5Z5DuwzoT0=; b=apa+FEsMWUYD8e604xabkawSxQ
        KsvIQ74dbLwwgh2oU+lz25uQtePA00wysP9fiowY6m4Uw/7UgUUycqT0zGkchQFlXeO4LFIL/VjrH
        DZLu621K7GLCFKwMEb1DCok5hanfOXPSSqEUXhEacO10scniA6sE8/iu6c+WVEXyS/Vgy3wnzu0Ef
        5bpL79n7Tpaaz9jqtHnIuC3g5cS68BptDCiNClQ+pgtVq7RTWr76X+JGJscLKwaqrbvJh2NyBCMmC
        uC34d05rfIgJMEFbddtm/DYpnLhhEP1OVfSVFpCXYz1mDJL09WHe4j1kAB4TinORZLpwIiRvHUgWX
        tG/Jn3bg==;
Received: from [2001:871:43:561d:6595:7615:85ec:f86d] (helo=[IPv6:::1])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pRpFS-009c31-1g;
        Tue, 14 Feb 2023 06:57:07 +0000
Date:   Tue, 14 Feb 2023 07:57:48 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     Usama Arif <usama.arif@bytedance.com>,
        Thomas Gleixner <tglx@linutronix.de>, kim.phillips@amd.com
CC:     arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: =?US-ASCII?Q?Re=3A_=5BExternal=5D_Re=3A_=5BPAT?= =?US-ASCII?Q?CH_v8_9/9=5D_x86/smpboot=3A_?= =?US-ASCII?Q?Serialize_topology_updates_for_secondary_bringup?=
User-Agent: K-9 Mail for Android
In-Reply-To: <5b696beb-52e2-716c-83c6-3bb70e5c9565@bytedance.com>
References: <20230209154156.266385-1-usama.arif@bytedance.com> <20230209154156.266385-10-usama.arif@bytedance.com> <87v8k5s3dq.ffs@tglx> <BE9F9210-4DBD-4A9F-BA5A-A7B5BA580FCC@infradead.org> <5b696beb-52e2-716c-83c6-3bb70e5c9565@bytedance.com>
Message-ID: <81F5E360-7BE1-46A1-80DE-79871DA3BCBB@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13 February 2023 23:30:20 CET, Usama Arif <usama=2Earif@bytedance=2Ecom=
> wrote:
>
>
>On 13/02/2023 20:53, David Woodhouse wrote:
>>=20
>>=20
>> On 13 February 2023 21:43:13 CET, Thomas Gleixner <tglx@linutronix=2Ede=
> wrote:
>>> On Thu, Feb 09 2023 at 15:41, Usama Arif wrote:
>>>> From: David Woodhouse <dwmw@amazon=2Eco=2Euk>
>>>>=20
>>>> The toplogy update is performed by the AP via smp_callin() after the =
BSP
>>>> has called do_wait_cpu_initialized(), setting the AP's bit in
>>>> cpu_callout_mask to allow it to proceed=2E
>>>>=20
>>>> In preparation to enable further parallelism of AP bringup, add locki=
ng to
>>>> serialize the update even if multiple APs are (in future) permitted t=
o
>>>> proceed through the next stages of bringup in parallel=2E
>>>=20
>>> This one is also only relevant for further parallelisation, right?
>>=20
>> I believe so, yes=2E But it's low-hanging fruit and might as well go in=
 now=2E
>
>Yes, only needed if we parallelize further, i=2Ee=2E after do_wait_cpu_in=
itialized=2E As David said, its a simple enough and easy patch, but its not=
 needed for parallelizing INIT/SIPI=2E
>
>I tested Davids' part2 branch (https://git=2Einfradead=2Eorg/users/dwmw2/=
linux=2Egit/shortlog/refs/heads/parallel-6=2E2-rc7) again just to be sure, =
and the only commit that makes a significant difference in smpboot time on =
top of part1 (this series) is reusing timer calibration (100ms to 34ms)=2E
>
>Parallelizing do_wait_cpu_initialized didn't significantly improve smpboo=
t time (only reduced to 31ms on average of 4 runs so maybe within the margi=
n of error?), so I think its better to move this patch into its own series =
with any further parallelization only if it shows a further improvement in =
smpboot time?

Let's do it anyway; it's harmless to make it thread-safe even if it doesn'=
t get invoked that way today=2E There is further parallelism to be had with=
 letting the APs run themselves all the way to the online state, and the "p=
art2" in my tree is only the next step towards that=2E

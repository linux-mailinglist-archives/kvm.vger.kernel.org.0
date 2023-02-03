Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A486891AB
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 09:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbjBCIKz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 03:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbjBCIKB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 03:10:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BEA6811C;
        Fri,  3 Feb 2023 00:08:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4698161E14;
        Fri,  3 Feb 2023 08:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159E1C433D2;
        Fri,  3 Feb 2023 08:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675411727;
        bh=aT42vj9PJCG8bxaMvvXlX2rC47FcFL9/q7LjTigNKCs=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=YabQY1ZDzX1r0QQdTCNkgUwpYzS3PBaRFLbfkzKDxLoUMnUuviY0oNN4ALZWQWHU5
         SxSVjkGWaEyz5yRD/EDmDswe8u15W39POSBv5aGBr6sEksGNNiFAiv9seeJz+28zWm
         bh5gJZ5uJr8aC9zq+U40p1TdT0rvshX5SowOLp8EMUm+aTNnQEm/8HRF6ZbnQkR/fo
         r7l/7HdmQW6/idTejVzd3+mMaLg3rkYbM+E05BR1OhmggoFZBu/1N/5i21DVb60+oX
         +rmR+H4CLOvPHOljHU+mmLOTL3vret5hqjDmrt7Hk4h0ALKlzYQUKAWkWe6AKMjxDS
         rI8ewIXOku+9Q==
Date:   Fri, 03 Feb 2023 08:08:42 +0000
From:   Conor Dooley <conor@kernel.org>
To:     linux-riscv@lists.infradead.org,
        Atish Patra <atishp@atishpatra.org>,
        Conor Dooley <conor.dooley@microchip.com>
CC:     Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>,
        Eric Lin <eric.lin@sifive.com>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 07/14] RISC-V: KVM: Add skeleton support for perf
User-Agent: K-9 Mail for Android
In-Reply-To: <CAOnJCUKVXGXsFBUE753-HOr_CtN-5Nsq+yBQj1eT13WyU2r54g@mail.gmail.com>
References: <20230201231250.3806412-1-atishp@rivosinc.com> <20230201231250.3806412-8-atishp@rivosinc.com> <Y9ufoeZ/4obZDJz6@wendy> <CAOnJCUKVXGXsFBUE753-HOr_CtN-5Nsq+yBQj1eT13WyU2r54g@mail.gmail.com>
Message-ID: <71788DAC-4DDF-460F-B881-58729D6D437C@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3 February 2023 08:04:00 GMT, Atish Patra <atishp@atishpatra=2Eorg> wro=
te:
>On Thu, Feb 2, 2023 at 3:34 AM Conor Dooley <conor=2Edooley@microchip=2Ec=
om> wrote:
>>
>> On Wed, Feb 01, 2023 at 03:12:43PM -0800, Atish Patra wrote:
>> > This patch only adds barebone structure of perf implementation=2E Mos=
t of
>> > the function returns zero at this point and will be implemented
>> > fully in the future=2E
>> >
>> > Signed-off-by: Atish Patra <atishp@rivosinc=2Ecom>
>> > +/* Per virtual pmu counter data */
>> > +struct kvm_pmc {
>> > +     u8 idx;
>> > +     struct perf_event *perf_event;
>> > +     uint64_t counter_val;
>>
>> CI also complained that here, and elsewhere, you used uint64_t rather
>> than u64=2E Am I missing a reason for not using the regular types?
>>
>
>Nope=2E It was a simple oversight=2E I will fix it=2E
>Do you have a link to the CI report so that I can address them all in v5 =
?

Try:
:%s/uint64_t/u64
It was just this patch, and checkpatch --strict should show it=2E

>
>> Thanks,
>> Conor=2E
>>
>> > +     union sbi_pmu_ctr_info cinfo;
>> > +     /* Event monitoring status */
>> > +     bool started;
>
>
>

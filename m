Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD3667B411
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 15:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235580AbjAYOR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 09:17:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235239AbjAYORS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 09:17:18 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3A859245
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:17:13 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id d10so13445044pgm.13
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ReVu+PCJ9uQlg1KFmeKSSoqjffPWvxnjud26226RPUY=;
        b=Gh8M3v5k6vXk2RSjppLMe5XCwjVnLXy0HtEDSA7jZPbSalQNCvggk5+LhpuDExEIkz
         sYZro5sKMmqoL4gSzvnVuQ2n1G7UyDUEGCPkupuJewluCCwEbHPeiC8JkX3npGCGJJUg
         PbmB1MWAi8fKqLf0WCvj6sk4HpTJn1NMlax5AbUNuGT3+eAGHX56ZZTYUbzPQNs7jYif
         9wWRLo5ZUQaqE2dXeOOvzPu8oZdYJjn0aox1MqBdfaDaD4yiAYlOowlSn5juGPv/jkO8
         SqgVxJm/fO3pUxmJaYk/dgyP+o+JrWnYJgTg0wD7LZsGsGIZBUZ213DKAkg94md7qSPH
         cHpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ReVu+PCJ9uQlg1KFmeKSSoqjffPWvxnjud26226RPUY=;
        b=v2eaBrDO26NPidTpDJkRtEt2OKap2xZyeqHv3d7zhfPyfySXcQBddcV8rGOnIVbgMf
         l5v28SpPMwUIHKly2vMgcnIogxcfBjwXVaCHW60v9HphPGOcWwGRarjwJfETCs3nBofe
         D4pzf9+2cGc4HgTv+rYD31z0J1FbD6qldO3uqdhM6aXC1j5u74Ll4Ss3DRh1PZ3KddZE
         zx/lFytj6suXA18t05EA38VV4gMT/PGt/3yLp2/Md4Y93umLyseObZ8AkvLo/Zg3xpkI
         bKgrYnvEsd0vuKB85s0L6TBuXzfIv02Xvn6BE5nRQn3EPKrTxqouO7/qiPjCoKfWnCTo
         vXiw==
X-Gm-Message-State: AO0yUKWR+Htxgg11PSL6Jwv++BlKabSCG5NVPbNTqdeWRbJI1zWI26pf
        tXAy8VDewtfTZ/eqxNj+dqeGHw==
X-Google-Smtp-Source: AK7set/7+CxnNLwdtSUfIvLtR83xajY7Nn9O4wzHZvSigazZuAvJSODKrHXtx0pV/2V5NDrnnbmbEw==
X-Received: by 2002:a05:6a00:23cb:b0:581:bfac:7a52 with SMTP id g11-20020a056a0023cb00b00581bfac7a52mr725774pfc.1.1674656233189;
        Wed, 25 Jan 2023 06:17:13 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id z28-20020a056a001d9c00b00580cc63dce8sm799363pfw.77.2023.01.25.06.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:17:12 -0800 (PST)
Date:   Wed, 25 Jan 2023 06:17:09 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     Reiji Watanabe <reijiw@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev, maz@kernel.org,
        alexandru.elisei@arm.com, oliver.upton@linux.dev
Subject: Re: [kvm-unit-tests PATCH v3 3/4] arm: pmu: Add tests for 64-bit
 overflows
Message-ID: <Y9E55cTs+iAK31ns@google.com>
References: <20230109211754.67144-1-ricarkol@google.com>
 <20230109211754.67144-4-ricarkol@google.com>
 <CAAeT=FxoS2-cmMe-3FeXPXcvE4wNosZeZy2RGPXz5xisq5fj7A@mail.gmail.com>
 <Y9CRxb2YvPtX340D@google.com>
 <CAAeT=FyP0658CNXT6csZpvMvZ4n+X5igLw4W9z0jQTs12y3aCQ@mail.gmail.com>
 <12974616-10ac-e44b-7bd2-0db68fb63eb5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12974616-10ac-e44b-7bd2-0db68fb63eb5@redhat.com>
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

On Wed, Jan 25, 2023 at 08:55:50AM +0100, Eric Auger wrote:
> Hi,
> 
> On 1/25/23 05:11, Reiji Watanabe wrote:
> > On Tue, Jan 24, 2023 at 6:19 PM Ricardo Koller <ricarkol@google.com> wrote:
> >> On Wed, Jan 18, 2023 at 09:58:38PM -0800, Reiji Watanabe wrote:
> >>> Hi Ricardo,
> >>>
> >>> On Mon, Jan 9, 2023 at 1:18 PM Ricardo Koller <ricarkol@google.com> wrote:
> >>>> @@ -898,12 +913,12 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
> >>>>
> >>>>         pmu_reset_stats();
> >>> This isn't directly related to the patch.
> >>> But, as bits of pmovsclr_el0 are already set (although interrupts
> >>> are disabled), I would think it's good to clear pmovsclr_el0 here.
> >>>
> >>> Thank you,
> >>> Reiji
> >>>
> >> There's no need in this case as there's this immediately before the
> >> pmu_reset_stats();
> >>
> >>         report(expect_interrupts(0), "no overflow interrupt after counting");
> >>
> >> so pmovsclr_el0 should be clear.
> > In my understanding, it means that no overflow *interrupt* was reported,
> > as the interrupt is not enabled yet (pmintenset_el1 is not set).
> > But, (as far as I checked the test case,) the both counters should be
> > overflowing here. So, pmovsclr_el0 must be 0x3.
> 
> I would tend to agree with Reiji.  The PMOVSSET_EL0<idx> will impact the
> next test according to aarch64/debug/pmu/AArch64.CheckForPMUOverflow and
> I think the overflow reg should be reset.

Ahh, right. The overflow interrupt could fire as soon as they are
enabled again. OK, will add a fix in the next version.

> 
> Eric
> >
> > Or am I misunderstanding something?
> >
> > Thank you,
> > Reiji
> >
> >
> >>>> -       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> >>>> -       write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> >>>> +       write_regn_el0(pmevcntr, 0, pre_overflow);
> >>>> +       write_regn_el0(pmevcntr, 1, pre_overflow);
> >>>>         write_sysreg(ALL_SET, pmintenset_el1);
> >>>>         isb();
> >>>>
> 

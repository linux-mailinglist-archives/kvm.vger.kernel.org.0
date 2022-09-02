Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C45AD5AB218
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 15:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238214AbiIBNvp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 09:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235709AbiIBNvX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 09:51:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F0FC2773;
        Fri,  2 Sep 2022 06:25:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0921B82B29;
        Fri,  2 Sep 2022 13:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF7EC433D6;
        Fri,  2 Sep 2022 13:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662124742;
        bh=jWqEiknW8RwuhPMRa9jUaXySZbEvtLL9Yky5wfGrb2k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CgrtUwKx+JuYZ38FAteb2DXrh+F0UcLIBdeuhxvNzY5928n8PaIpn3q77LQr4qCHL
         ufuqPYJNK9IxEECrIo0oKB6t1lyEmwqfhyB4eDr5bn+es+0oJke7lZFF1ZXH3DxMyY
         eR7T4NUy7Lv9wastzberTfJtkNnCLDlUd29Z/inInUQL3oml7lkiiBaipHfRjBqYoB
         YFHOafnNmeDDW9Ef91fmX+d6UrPVV/IHWmE1zYbSzyjALYyGa97QhOaK5g02MlA7y5
         nd14HhDgvbWcRNQAhT0iHCoQj5xW5IeqcEyqAR27avB13lk8S5QgWQ21yVWlvnIQMV
         HDrED6OjVQgew==
Date:   Fri, 2 Sep 2022 21:09:45 +0800
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Conor.Dooley@microchip.com
Cc:     paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, anup@brainfault.org, atishp@atishpatra.org,
        bigeasy@linutronix.de, tglx@linutronix.de, rostedt@goodmis.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 0/5] riscv: add PREEMPT_RT support
Message-ID: <YxIAmT2X9TU1CZhC@xhacker>
References: <20220831175920.2806-1-jszhang@kernel.org>
 <4488b1ec-aa34-4be5-3b9b-c65f052f5270@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4488b1ec-aa34-4be5-3b9b-c65f052f5270@microchip.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 01, 2022 at 04:41:52PM +0000, Conor.Dooley@microchip.com wrote:
> On 31/08/2022 18:59, Jisheng Zhang wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > This series is to add PREEMPT_RT support to riscv:
> > patch1 adds the missing number of signal exits in vCPU stat
> > patch2 switches to the generic guest entry infrastructure
> > patch3 select HAVE_POSIX_CPU_TIMERS_TASK_WORK which is a requirement for
> > RT
> > patch4 adds lazy preempt support
> > patch5 allows to enable PREEMPT_RT
> > 
> 
> What version of the preempt_rt patch did you test this with?

v6.0-rc1 + v6.0-rc1-rt patch

> 
> Maybe I am missing something, but I gave this a whirl with
> v6.0-rc3 + v6.0-rc3-rt5 & was meant by a bunch of complaints.
> I am not familiar with the preempt_rt patch, so I am not sure what
> level of BUG()s or WARNING()s are to be expected, but I saw a fair
> few...

Could you please provide corresponding log? Usually, this means there's
a bug in related drivers, so it's better to fix them now rather than
wait for RT patches mainlined.

PS: which HW are you using?

Thanks

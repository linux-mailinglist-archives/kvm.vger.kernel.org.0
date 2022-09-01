Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22FD75A9979
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 15:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234431AbiIANyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 09:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233968AbiIANx7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 09:53:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF7CBF4C;
        Thu,  1 Sep 2022 06:53:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77293B826E2;
        Thu,  1 Sep 2022 13:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D679C433C1;
        Thu,  1 Sep 2022 13:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662040435;
        bh=HdsYKZmyvUhpJZba03oAmfYjwzHbDOVaQz9sEmXDhww=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CGrJY5mf/CEotU+aiZKDeb0eBpmRY6SlPOv3KQjdek5+gw7JXxzyEgfpFkMyRHDtj
         OpRCF7x7vDdT4ldIXyVuKFV0kDWHvR1XmBpvtqnEXHXZWzTuciKoZ4s5LFRa14UjM7
         Ca8tJnTRfof1qW4GTQ8tcSMXSfQT8fCZ8NhWrDg2/fsys4mP5DMpJDMn9DcpL8h6Ir
         5JgVvucNoMULavFe9OFOMiydvLfqfATmqGPaqNHLcfk4BVWRT27AWssjozNakNrNzH
         hXi8x0XmPLCvRSmudnfTfmfRuq2I+6QsASRvqVR7NICjAXDMGJEeaRFmwP884Q6P1u
         N091/JLRHBgEA==
Date:   Thu, 1 Sep 2022 21:44:37 +0800
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 0/5] riscv: add PREEMPT_RT support
Message-ID: <YxC3Ra5iZDdYX7sW@xhacker>
References: <20220831175920.2806-1-jszhang@kernel.org>
 <YxBZZWopVftK/WBk@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YxBZZWopVftK/WBk@linutronix.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 01, 2022 at 09:04:05AM +0200, Sebastian Andrzej Siewior wrote:
> On 2022-09-01 01:59:15 [+0800], Jisheng Zhang wrote:
> > I assume patch1, patch2 and patch3 can be reviewed and merged for
> > riscv-next, patch4 and patch5 can be reviewed and maintained in rt tree,
> > and finally merged once the remaining patches in rt tree are all
> > mainlined.
> 
> I would say so, yes.
> 
> What about JUMP_LABEL support? Do you halt all CPUs while patching the
> code?
> 

FWICT, riscv JUMP_LABEL implementation doesn't rely on stop all cpus while
patching text.

Thanks

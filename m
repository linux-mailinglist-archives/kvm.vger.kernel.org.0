Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5965A8F21
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 09:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbiIAHEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 03:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbiIAHEW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 03:04:22 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB15A6C115;
        Thu,  1 Sep 2022 00:04:08 -0700 (PDT)
Date:   Thu, 1 Sep 2022 09:04:05 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1662015847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+6TS55y82TYJlsjJwC1/zBEVFCDtqxUms69ssI0wGGA=;
        b=3RxOlbonJl5WFm8YJXSc0uAQRFGPk+DSXUCw++ela5eCvo5xJkEVEUbMFxjkRyt19MarwZ
        DNPfLMrc24rrP9cADg9WhtlDUH6D5/PLLhdIz0NBges7lyBseRZRYTfcJvMhwU5BukTgcj
        Qkk+/yYaiT1ncZcPjrLdFt457h+D1Q6GEFoPPsoEmThVEozsGEjuWS+sS3soDzXHd1a43A
        dgejUhFMJAQ3RGqwdu3fieeFS22nB1+g+aMmCins0gGqPEumNbs5hm3ZU3rb4FW6BLdtIK
        rfO0argpb218v1MWsH+roKH4nSfLKhYboE/AEt+Wjj88GouOyYLDeNyhzyd4LQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1662015847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+6TS55y82TYJlsjJwC1/zBEVFCDtqxUms69ssI0wGGA=;
        b=0lKMXKwZ85CHlGzucCsfuA1C4+BIzcDZjLS7nOki0RRQQtjslBtagCDNvKZIOeW3XCncam
        fnw0X6HxbUgwxXAQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jisheng Zhang <jszhang@kernel.org>
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
Message-ID: <YxBZZWopVftK/WBk@linutronix.de>
References: <20220831175920.2806-1-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220831175920.2806-1-jszhang@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-09-01 01:59:15 [+0800], Jisheng Zhang wrote:
> I assume patch1, patch2 and patch3 can be reviewed and merged for
> riscv-next, patch4 and patch5 can be reviewed and maintained in rt tree,
> and finally merged once the remaining patches in rt tree are all
> mainlined.

I would say so, yes.

What about JUMP_LABEL support? Do you halt all CPUs while patching the
code?

Sebastian

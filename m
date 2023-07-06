Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A273C749B32
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 13:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbjGFLzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 07:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjGFLzo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 07:55:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0288EE54;
        Thu,  6 Jul 2023 04:55:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D09606191D;
        Thu,  6 Jul 2023 11:55:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4006C433C7;
        Thu,  6 Jul 2023 11:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688644542;
        bh=ZVX2FMUo6DUhnVIuypz+Mg6dxvARnYElPp//q0SE0qU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aeK1eaSynsCDDKxSD1F3WceQUwfJ0lwG8w7w2wvYdL8l4k+X4A4MkxqN9Y//Vwo8K
         zduOA5Y4ba9Bt1DoD1eAV69H46QcjEHXBNfhl1fJo16ly2PKYxhvJgBqjZtCkuG45e
         iegT1G25Wd2n64fjlSfxpmNd3wCSK3EaJU2BOyB8Gf/YNy8MkkgFxfBJMdPagVp6rj
         8t9HxLcCMvfjFm8rSm46+m8ErvaSrux1gc0n1lYSeP9c+6z444zhcf+koQiZBP3dEF
         hl8/yImExn67ElaNHSXK8bcXcY912fUYoh+gN9G2pSP32K7DEUstz7jhEa9uKKrWyh
         xqF79eKz9qH/w==
Date:   Thu, 6 Jul 2023 13:55:39 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
        bpf@vger.kernel.org, x86@kernel.org,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Juerg Haefliger <juerg.haefliger@canonical.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Nadav Amit <namit@vmware.com>,
        Dan Carpenter <error27@gmail.com>,
        Chuang Wang <nashuiliang@gmail.com>,
        Yang Jihong <yangjihong1@huawei.com>,
        Petr Mladek <pmladek@suse.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, Song Liu <song@kernel.org>,
        Julian Pidancet <julian.pidancet@oracle.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>,
        Juri Lelli <juri.lelli@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Yair Podemsky <ypodemsk@redhat.com>
Subject: Re: [RFC PATCH 11/14] context-tracking: Introduce work deferral
 infrastructure
Message-ID: <ZKaru+Ka5kmlwrs/@lothringen>
References: <20230705181256.3539027-1-vschneid@redhat.com>
 <20230705181256.3539027-12-vschneid@redhat.com>
 <ZKXtfWZiM66dK5xC@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZKXtfWZiM66dK5xC@localhost.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 06, 2023 at 12:23:57AM +0200, Frederic Weisbecker wrote:
> Le Wed, Jul 05, 2023 at 07:12:53PM +0100, Valentin Schneider a écrit :
> +bool ct_set_cpu_work(unsigned int cpu, unsigned int work)
> +{
> +	struct context_tracking *ct = per_cpu_ptr(&context_tracking, cpu);
> +	unsigned int old, new, state;
> +	bool ret = false;
> +
> +	preempt_disable();
> +
> +	work <<= CONTEXT_WORK;
> +	state = atomic_read(&ct->state);
> +	/*
> +	 * Try setting the work until either
> +	 * - the target CPU is on the kernel
> +	 * - the work has been set
> +	 */
> +	for (;;) {
> +		/* Only set if running in user/guest */
> +		old = state;
> +		old &= ~CONTEXT_MASK;
> +		old |= CONTEXT_USER;
> +
> +		new = old | work;
> +
> +		state = atomic_cmpxchg(&ct->state, old, new);
> +		if (state & work) {

And this should be "if (state == old)", otherwise there is
a risk that someone else had set the work but atomic_cmpxchg()
failed due to other modifications is the meantime. It's then
dangerous in that case to defer the work because atomic_cmpxchg()
failures don't imply full ordering. So there is a risk that the
target executes the work but doesn't see the most recent data.

Thanks.

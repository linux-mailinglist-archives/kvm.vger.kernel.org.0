Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3D77498CA
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 11:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbjGFJyI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 05:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbjGFJyE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 05:54:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F388C1BE8;
        Thu,  6 Jul 2023 02:54:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 514BD618D7;
        Thu,  6 Jul 2023 09:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277FEC433C9;
        Thu,  6 Jul 2023 09:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688637239;
        bh=Vme8i+8ZjqtCno6CMa53lKwCLxQgLuTEKq8y8x78RyY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K7oSQpH7enTD5ZMIXGersjb+eY+WfjWQlx23EVs5zrVRdsGfuA5hOU8OQRDadpMGR
         zEqbLacQL8xgg//uANI/Pl6VhMj39f/bjNmRu4GTXr1mkVZtqlain2RaoXt9HqZtnk
         4zCANtybIAn2X5KQX+bN8AO5b0JId3ArIfsZEBOLhQzqDSV/jPXP+Q7n9qBOGO6UX4
         hLyzSN9KUXNMpTSWY8PNvQGKLQtLuIAtukPmR47WXlJVgBm+hJ3FC/3YNqgwO8Nbgv
         9LfraiT2DNi6NY9hrCpoV8srdK/tTXx63FZCy1rf9Ah0hXz9SmzXYZfwAmnwE1R9SH
         6zRSCUyYxRkrQ==
Date:   Thu, 6 Jul 2023 11:53:56 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Valentin Schneider <vschneid@redhat.com>,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
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
Message-ID: <ZKaPNKE43MuyQKi7@lothringen>
References: <20230705181256.3539027-1-vschneid@redhat.com>
 <20230705181256.3539027-12-vschneid@redhat.com>
 <ZKXtfWZiM66dK5xC@localhost.localdomain>
 <20230705224104.GE2813335@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230705224104.GE2813335@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 06, 2023 at 12:41:04AM +0200, Peter Zijlstra wrote:
> On Thu, Jul 06, 2023 at 12:23:57AM +0200, Frederic Weisbecker wrote:
> > If this is just about a dozen, can we stuff them in the state like in the
> > following? We can potentially add more of them especially on 64 bits we could
> > afford 30 different works, this is just shrinking the RCU extended quiescent
> > state counter space. Worst case that can happen is that RCU misses 65535
> > idle/user <-> kernel transitions and delays a grace period...
> 
> We can make all this a 64bit only feature and use atomic_long_t :-)

Works for me :)

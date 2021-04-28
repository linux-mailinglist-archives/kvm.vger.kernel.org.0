Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B65036E0E7
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 23:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhD1V2E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 17:28:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229691AbhD1V2E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 17:28:04 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB10F6143C;
        Wed, 28 Apr 2021 21:27:15 +0000 (UTC)
Date:   Wed, 28 Apr 2021 17:27:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Joerg Roedel <jroedel@suse.de>, Jian Cai <caij2003@gmail.com>,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH 1/4] x86/xen/entry: Rename xenpv_exc_nmi to
 noist_exc_nmi
Message-ID: <20210428172714.53adac43@gandalf.local.home>
In-Reply-To: <20210426230949.3561-2-jiangshanlai@gmail.com>
References: <20210426230949.3561-1-jiangshanlai@gmail.com>
        <20210426230949.3561-2-jiangshanlai@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 27 Apr 2021 07:09:46 +0800
Lai Jiangshan <jiangshanlai@gmail.com> wrote:

> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> There is no any functionality change intended.  Just rename it and
> move it to arch/x86/kernel/nmi.c so that we can resue it later in
> next patch for early NMI and kvm.

Nit, but in change logs, please avoid stating "next patch" as searching git
history (via git blame or whatever) there is no such thing as "next patch".

Just state: "so that we can reuse it for early NMI and KVM."

I also just noticed the typo in "resue". Or maybe both NMI and KVM should
be sued again ;-)

-- Steve

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0392636F9BC
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbhD3MGg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:06:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229911AbhD3MGf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:06:35 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85786613EF;
        Fri, 30 Apr 2021 12:05:44 +0000 (UTC)
Date:   Fri, 30 Apr 2021 08:05:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <20210430080542.5d42d169@oasis.local.home>
In-Reply-To: <d77ee423-53fc-d552-1ff8-6fdf75e416a7@redhat.com>
References: <20210426230949.3561-1-jiangshanlai@gmail.com>
        <20210426230949.3561-2-jiangshanlai@gmail.com>
        <20210428172714.53adac43@gandalf.local.home>
        <d77ee423-53fc-d552-1ff8-6fdf75e416a7@redhat.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 30 Apr 2021 09:15:51 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> > Nit, but in change logs, please avoid stating "next patch" as searching git
> > history (via git blame or whatever) there is no such thing as "next patch".  
> 
> Interesting, I use next patch(es) relatively often, though you're right 
> that something like "in preparation for" works just as well.  Yes, it's 
> the previous in "git log", but you get what it's meant in practice. :)

It's not always the previous in a git log. Git log sorts by time, and
if an unrelated commit was created in between those two patches, it
will be in between them.

-- Steve

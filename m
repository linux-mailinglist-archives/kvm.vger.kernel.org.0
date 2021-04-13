Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C40E35E542
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 19:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347267AbhDMRnh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 13:43:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231512AbhDMRnh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 13:43:37 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E74760FEA;
        Tue, 13 Apr 2021 17:43:15 +0000 (UTC)
Date:   Tue, 13 Apr 2021 13:43:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     syzbot <syzbot+61e04e51b7ac86930589@syzkaller.appspotmail.com>
Cc:     akpm@linux-foundation.org, axboe@kernel.dk, bp@alien8.de,
        hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        masahiroy@kernel.org, mingo@redhat.com, pbonzini@redhat.com,
        peterz@infradead.org, rafael.j.wysocki@intel.com,
        seanjc@google.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        will@kernel.org, x86@kernel.org
Subject: Re: [syzbot] possible deadlock in del_gendisk
Message-ID: <20210413134314.16068eeb@gandalf.local.home>
In-Reply-To: <20210413134147.54556d9d@gandalf.local.home>
References: <000000000000ae236f05bfde0678@google.com>
        <20210413134147.54556d9d@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Apr 2021 13:41:47 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> As the below splats look like it has nothing to do with this patch, and
> this patch will add a WARN() if there's broken logic somewhere, I bet the
> bisect got confused (if it is automated and does a panic_on_warning),
> because it will panic for broken code that his patch detects.
> 
> That is, the bisect was confused because it was triggering on two different
> issues. One that triggered the reported splat below, and another that this
> commit detects and warns on.

Is it possible to update the the bisect to make sure that if it is failing
on warnings, to make sure the warnings are somewhat related, before decided
that its the same bug?

-- Steve

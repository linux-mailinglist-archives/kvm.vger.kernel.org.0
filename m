Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376323A1B67
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 19:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhFIRDw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 13:03:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230205AbhFIRDu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 13:03:50 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 538C660C40;
        Wed,  9 Jun 2021 17:01:55 +0000 (UTC)
Date:   Wed, 9 Jun 2021 13:01:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: Ensure liveliness of nested VM-Enter fail
 tracepoint message
Message-ID: <20210609130153.42b3ca81@oasis.local.home>
In-Reply-To: <YMDoeDTrAMmfl6+k@google.com>
References: <20210607175748.674002-1-seanjc@google.com>
        <CANRm+CxWovvM187BKtuvS1_WWnSdKc6wFA5swF-sJPJqYSWnUg@mail.gmail.com>
        <YMDoeDTrAMmfl6+k@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 9 Jun 2021 09:12:40 -0700
Sean Christopherson <seanjc@google.com> wrote:

> > I can observe tons of other kvm tracepoints warning like this after
> > commit 9a6944fee68e25 (tracing: Add a verifier to check string
> > pointers for trace events), just echo 1 >
> > /sys/kernel/tracing/events/kvm/enable and boot a linux guest.  
> 
> Can you provide your .config?  With all of events/kvm and events/kvmmmu enabled
> I don't get any warnings running a Linux guest, a nested Linux guest, and
> kvm-unit-tests.
> 
> Do you see the behavior with other tracepoints?  E.g. enabling all events on my
> systems yields warnings for a USB module, but everything else is clean.

Right, I tested this with running KVM guests when it was added. I was
actually surprised with Sean's report saying it was a kvm trace event,
until I noticed that the problem event is only triggered on error paths.

-- Steve

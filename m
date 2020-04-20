Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE381B17D7
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 23:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgDTVAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 17:00:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:50632 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgDTVAN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Apr 2020 17:00:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CAA6FAC7F;
        Mon, 20 Apr 2020 21:00:09 +0000 (UTC)
Date:   Mon, 20 Apr 2020 13:56:41 -0700
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     Marc Zyngier <maz@kernel.org>
Cc:     tglx@linutronix.de, pbonzini@redhat.com, kvm@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>, peterz@infradead.org,
        torvalds@linux-foundation.org, bigeasy@linutronix.de,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        joel@joelfernandes.org, will@kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v2] kvm: Replace vcpu->swait with rcuwait
Message-ID: <20200420205641.6sgsllj6pmsnwrvp@linux-p48b>
References: <20200324044453.15733-1-dave@stgolabs.net>
 <20200324044453.15733-4-dave@stgolabs.net>
 <20200420164132.tjzk5ebx35m66yce@linux-p48b>
 <418acdb5001a9ae836095b7187338085@misterjones.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <418acdb5001a9ae836095b7187338085@misterjones.org>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Apr 2020, Marc Zyngier wrote:

>This looks like a change in the semantics of the tracepoint. Before this
>change, 'waited' would have been true if the vcpu waited at all. Here, 
>you'd
>have false if it has been interrupted by a signal, even if the vcpu 
>has waited
>for a period of time.

Hmm but sleeps are now uninterruptible as we're using TASK_IDLE.

Thanks,
Davidlohr

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC48D33ED4A
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 10:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhCQJoi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 05:44:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:42366 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229535AbhCQJoJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 05:44:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615974248; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=15SYZUOsoJrtHlD7au1IPSvMhYe6ENPbMXJkbZtfksA=;
        b=dnwcW+yYQOAKzjFfBsPO6BtIwTwnPdajOyVerDHNue20QLH8yCOrCRdlnUJR1xMcwzyYwt
        QXg49q5jxymBUMCTic3MEhn9xxxc/k490Pw3Ur9tcuOkA/oQbHaYG9wtxEd/XblLvuGhOM
        BPLp23zWhfiMnPN3eGIQakgwhhpAZTU=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 00502AB8C;
        Wed, 17 Mar 2021 09:44:07 +0000 (UTC)
Date:   Wed, 17 Mar 2021 10:44:06 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm: memcg awareness
Message-ID: <YFHPZjyUn3AsQnN2@dhcp22.suse.cz>
References: <1615959984-7122-1-git-send-email-wanpengli@tencent.com>
 <YFG2Z1q9MJGr8Zek@dhcp22.suse.cz>
 <CANRm+Cxi4qupXkYyZpPbvHcLkuWGxin4+w7EC+z0+Aidi5+B5A@mail.gmail.com>
 <CANRm+CwLBAPwwZzHB8U2SDMHKer_NtOKfAk52=EHUpG-SqxJWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+CwLBAPwwZzHB8U2SDMHKer_NtOKfAk52=EHUpG-SqxJWg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed 17-03-21 16:04:51, Wanpeng Li wrote:
> On Wed, 17 Mar 2021 at 16:04, Wanpeng Li <kernellwp@gmail.com> wrote:
> >
> > On Wed, 17 Mar 2021 at 15:57, Michal Hocko <mhocko@suse.com> wrote:
> > >
> > > On Wed 17-03-21 13:46:24, Wanpeng Li wrote:
> > > > From: Wanpeng Li <wanpengli@tencent.com>
> > > >
> > > > KVM allocations in the arm kvm code which are tied to the life
> > > > of the VM process should be charged to the VM process's cgroup.
> > >
> > > How much memory are we talking about?
> > >
> > > > This will help the memcg controler to do the right decisions.
> > >
> > > This is a bit vague. What is the right decision? AFAICS none of that
> > > memory is considered during oom victim selection. The only thing memcg
> > > controler can help with is to contain and account this additional
> > > memory. This might help to better isolate multiple workloads on the same
> > > system. Maybe this is what you wanted to say? Or maybe this is a way to
> > > prevent untrusted users from consuming a lot of memory?
> >
> 
> https://patchwork.kernel.org/project/kvm/patch/20190211190252.198101-1-bgardon@google.com/
> 
> > It is explained in this patchset for x86 kvm which is upstream, I
> > think I don't need to copy and paste. :)

How is one supposed to know that? If you want to spare some typing then
you could have referenced 4183683918ef ("kvm: vmx: Add memcg accounting
to KVM allocations").

Btw. that explanation is rather vague as well. It doesn't explain any of
my above questions. It is not my take to judge whether these are
important for the respective maintainers I just want to point out that
once somebody revisits this code and try to find out why the accounting
has been added then this will be far from clear because "memcg doing the
right thing" doesn't tell much in itself.
-- 
Michal Hocko
SUSE Labs

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C9536C85E
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 17:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238675AbhD0PKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 11:10:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235466AbhD0PKN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 11:10:13 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 796A9613E2;
        Tue, 27 Apr 2021 15:09:28 +0000 (UTC)
Date:   Tue, 27 Apr 2021 11:09:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     peterz@infradead.org, bristot@redhat.com, bsegall@google.com,
        dietmar.eggemann@arm.com, greg@kroah.com,
        gregkh@linuxfoundation.org, joshdon@google.com,
        juri.lelli@redhat.com, linux-kernel@vger.kernel.org,
        linux@rasmusvillemoes.dk, mgorman@suse.de, mingo@kernel.org,
        valentin.schneider@arm.com, vincent.guittot@linaro.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: sched: Move SCHED_DEBUG sysctl to debugfs
Message-ID: <20210427110926.24f41fbb@gandalf.local.home>
In-Reply-To: <20210427145925.5246-1-borntraeger@de.ibm.com>
References: <20210412102001.287610138@infradead.org>
        <20210427145925.5246-1-borntraeger@de.ibm.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 27 Apr 2021 16:59:25 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Peter,
> 
> I just realized that we moved away sysctl tunabled to debugfs in next.
> We have seen several cases where it was benefitial to set
> sched_migration_cost_ns to a lower value. For example with KVM I can
> easily get 50% more transactions with 50000 instead of 500000. 
> Until now it was possible to use tuned or /etc/sysctl.conf to set
> these things permanently. 
> 
> Given that some people do not want to have debugfs mounted all the time
> I would consider this a regression. The sysctl tunable was always 
> available.
> 
> I am ok with the "informational" things being in debugfs, but not
> the tunables. So how do we proceed here?

Should there be a schedfs created?

This is the reason I created the tracefs file system, was to get the
tracing code out of debugfs, as debugfs is a catch all for everything and
can lead to poor and insecure interfaces that people do not want to add on
systems that they still want tracing on.

Or perhaps we should add a "tunefs" for tunables that are stable interfaces
that should not be in /proc but also not in debugfs.

-- Steve


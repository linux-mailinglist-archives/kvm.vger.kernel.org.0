Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C499336D43D
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 10:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237950AbhD1ItX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 04:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237934AbhD1ItW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 04:49:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFFAC06138B;
        Wed, 28 Apr 2021 01:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HH9Gce1uOwCDDNzzHrLHk28gGwN7n6kj6W6fnuW2Cc4=; b=GaPgxHqJZPoKkBJrPX4zFODEo+
        DWqFeO94cTEfwvsJM6YjXWCG8bsMSrYvCi/HaP6Ms8VGomeZ6cyc11ECmNXCak/NjhF85LzMAMCRe
        sWZP8Lu2+cWLDzbTNG9PIFCWf2ZpM+WTutk6bryAJc1MxnIufnkdJyWO289l/D7P1MT+r/P0O10QX
        PGjsGdtN+rzApeZOQjv/a6YNnfwGCBvr3NvlPQE1tN5TbdUR+mvBH8FSgAoRpbqVaAk0RKClHAx7a
        CD6aYMm+tqb+tYRHJXac4AAyDWd2j2nxaLczlwmZaBWia+UwwX9nmdBNsoubzbHP0iwpItDLyQOiV
        +a5oNLkA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lbfrB-0083ig-LM; Wed, 28 Apr 2021 08:47:47 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5B28830003A;
        Wed, 28 Apr 2021 10:47:41 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4B3B22BF7B843; Wed, 28 Apr 2021 10:47:41 +0200 (CEST)
Date:   Wed, 28 Apr 2021 10:47:41 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>, bristot@redhat.com,
        bsegall@google.com, dietmar.eggemann@arm.com, greg@kroah.com,
        gregkh@linuxfoundation.org, joshdon@google.com,
        juri.lelli@redhat.com, linux-kernel@vger.kernel.org,
        linux@rasmusvillemoes.dk, mgorman@suse.de, mingo@kernel.org,
        valentin.schneider@arm.com, vincent.guittot@linaro.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: sched: Move SCHED_DEBUG sysctl to debugfs
Message-ID: <YIkhLVi4weT02O/N@hirez.programming.kicks-ass.net>
References: <20210412102001.287610138@infradead.org>
 <20210427145925.5246-1-borntraeger@de.ibm.com>
 <20210427110926.24f41fbb@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210427110926.24f41fbb@gandalf.local.home>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 27, 2021 at 11:09:26AM -0400, Steven Rostedt wrote:
> Or perhaps we should add a "tunefs" for tunables that are stable interfaces
> that should not be in /proc but also not in debugfs.

As said in that other email, I very emphatically do not want to do that.
I want to actively discourage people from 'tuning' and start to debug.


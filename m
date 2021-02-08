Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD2C313298
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 13:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbhBHMmq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 07:42:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbhBHMlR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 07:41:17 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07AA9C061788;
        Mon,  8 Feb 2021 04:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QYHzFu7RFjTlSdRSBJft/6IvHdnl3ucwkIIGdwOHaTI=; b=M6Vbj529/FrUUsDCBH3YO2zH/I
        2uguc/8aT2Ymw7wv+8quB5S/whXFbGzgoXuWAqIjd7EYl3R3bRlBeIFPvol8vYs5wTKSl8akTxHkC
        c3bbUNTzqFHA0luYYL2J8ImQEUZYg07IgPKM5XygZpPevys2G99uDtRaZwNygya08nVzHnUsKpBxs
        fhteJcW44UUXqMCl6EdoXsucxW6mxt9LJ64iLvcB10YyLhERtLRpcZX+6WoeWuMTQGdMGMJ6j1eCs
        WY4M2U6QPjdjcB/oO+OjdbFBRVA3n/PsFJnoZJGbxCsRlC2PewFOhZVVjjAzd041+3a6v4Q2syrD8
        vwowdcOA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l95pj-005xx7-8Y; Mon, 08 Feb 2021 12:40:04 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 4D9BE3010D2;
        Mon,  8 Feb 2021 13:40:02 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 34C5F20D8A013; Mon,  8 Feb 2021 13:40:02 +0100 (CET)
Date:   Mon, 8 Feb 2021 13:40:02 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jim Mattson <jmattson@google.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RESEND] perf/x86/kvm: Add Cascade Lake Xeon steppings to
 isolation_ucodes[]
Message-ID: <YCExIkeNU/g0GcCD@hirez.programming.kicks-ass.net>
References: <20210205191324.2889006-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205191324.2889006-1-jmattson@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 05, 2021 at 11:13:24AM -0800, Jim Mattson wrote:
> Cascade Lake Xeon parts have the same model number as Skylake Xeon
> parts, so they are tagged with the intel_pebs_isolation
> quirk. However, as with Skylake Xeon H0 stepping parts, the PEBS
> isolation issue is fixed in all microcode versions.
> 
> Add the Cascade Lake Xeon steppings (5, 6, and 7) to the
> isolation_ucodes[] table so that these parts benefit from Andi's
> optimization in commit 9b545c04abd4f ("perf/x86/kvm: Avoid unnecessary
> work in guest filtering").
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>

Thanks!

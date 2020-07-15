Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F9E220A94
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 12:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729699AbgGOK5K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 06:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbgGOK5K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 06:57:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6200C061755;
        Wed, 15 Jul 2020 03:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=K8h4KI86Mzb6BYGGyc/D5d7vo4fVAFqxYqHc3CALsmU=; b=BGOcXPSin+HC2fF1VqIS2IqzXw
        YGPNLIs6u0i4juJ6jLImClXgjkl/hxvLhGvj1eiIwTuEcj2kgDhn5u6DM88nmQDKbFGgiCcgyySpw
        gParcOSrVYvhyiZNKOn+DfeACZ9Ocs9TrRzsRLcdRCSbsWrIdTBx760Ir3sQ8gWmYlxLt0/+sxfVx
        xxVGGbbbEmmWZBphVSBO7n8aI+TQanyTc0mG+sXVGwxO2ubsUUdrGKoi+fVxeddBO1jINLWyEN1oh
        TbLk/A4GJCz6hdj/J7aX87Yc7dq8bkDqmHIJpZx96V571lVNVCldLVdBsHS0jFDf2l7fkWXQZ7K9g
        XGLSiGaw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvf5V-0006Ya-Er; Wed, 15 Jul 2020 10:56:37 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B5DEA300446;
        Wed, 15 Jul 2020 12:56:29 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A5F9C203A6143; Wed, 15 Jul 2020 12:56:29 +0200 (CEST)
Date:   Wed, 15 Jul 2020 12:56:29 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 45/75] x86/sev-es: Adjust #VC IST Stack on entering
 NMI handler
Message-ID: <20200715105629.GK10769@hirez.programming.kicks-ass.net>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200714120917.11253-46-joro@8bytes.org>
 <20200715094702.GF10769@hirez.programming.kicks-ass.net>
 <20200715102653.GN16200@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715102653.GN16200@suse.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 15, 2020 at 12:26:53PM +0200, Joerg Roedel wrote:
> On Wed, Jul 15, 2020 at 11:47:02AM +0200, Peter Zijlstra wrote:

> > That's pretty disguisting :-(
> 
> Yeah, but its needed because ... IST :(
> I am open for suggestions on how to make it less disgusting. Or maybe
> you like it more if you think of it as a software implementation of what
> hardware should actually do to make IST less painful.

No bright ideas, sadly..


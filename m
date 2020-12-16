Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A862DC3F1
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 17:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgLPQUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 11:20:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47304 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725970AbgLPQUo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 11:20:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608135558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NvwN0KhsppEK1+P8dEsWBA2V2X6Dxj3xU/xarmioCGw=;
        b=djBDSriitaBDT1HRZW1Ly+F78HcywHQpa8srQ5gMB/QNKTUmAOUQiiO4uSDjLBH/35CeEE
        6BdOo2R3yeLilDCy5Ws+sI+312flXkbEttRvUhfFw3p3vmbcsti66PsxaRQRPv5kdDCCxh
        syhdLzoipXkVQP6KLKOXiW+22pNu2Ac=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-YdEBWAkLM9KxAGAL72zdGg-1; Wed, 16 Dec 2020 11:19:13 -0500
X-MC-Unique: YdEBWAkLM9KxAGAL72zdGg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3D47108442F;
        Wed, 16 Dec 2020 16:19:11 +0000 (UTC)
Received: from treble (ovpn-112-170.rdu2.redhat.com [10.10.112.170])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 762517D577;
        Wed, 16 Dec 2020 16:19:10 +0000 (UTC)
Date:   Wed, 16 Dec 2020 10:19:08 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Dexuan Cui <decui@microsoft.com>, Ingo Molnar <mingo@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jeyu@kernel.org, ardb@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Jason Baron <jbaron@akamai.com>
Subject: Re: [RFC][PATCH] jump_label/static_call: Add MAINTAINERS
Message-ID: <20201216161908.puepcasfywfqv2pf@treble>
References: <MW4PR21MB1857CC85A6844C89183C93E9BFC59@MW4PR21MB1857.namprd21.prod.outlook.com>
 <20201216092649.GM3040@hirez.programming.kicks-ass.net>
 <20201216105926.GS3092@hirez.programming.kicks-ass.net>
 <20201216133014.GT3092@hirez.programming.kicks-ass.net>
 <20201216134249.GU3092@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201216134249.GU3092@hirez.programming.kicks-ass.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 16, 2020 at 02:42:49PM +0100, Peter Zijlstra wrote:
> > +STATIC BRANCH/CALL
> > +M:	Peter Zijlstra <peterz@infradead.org>
> > +M:	Josh Poimboeuf <jpoimboe@redhat.com>
> > +M:	Jason Baron <jbaron@akamai.com>
> > +R:	Steven Rostedt <rostedt@goodmis.org>
> > +R:	Ard Biesheuvel <ardb@kernel.org>
> > +S:	Supported
> 
> F:	arch/*/include/asm/jump_label*.h
> F:	arch/*/include/asm/static_call*.h
> F:	arch/*/kernel/jump_label.c
> F:	arch/*/kernel/static_call.c
> 
> These too?
> 
> > +F:	include/linux/jump_label*.h
> > +F:	include/linux/static_call*.h
> > +F:	kernel/jump_label.c
> > +F:	kernel/static_call.c

Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

-- 
Josh


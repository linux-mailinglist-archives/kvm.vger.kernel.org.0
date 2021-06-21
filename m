Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84CF73AE9D1
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 15:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhFUNQC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 09:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhFUNQC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Jun 2021 09:16:02 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B96DC061574;
        Mon, 21 Jun 2021 06:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Qu1aJMR4flK0FS15KBa/VkE4TUOWBJPRGztPmWnzK6c=; b=K0W+z+kc1UHE1xUwN23ov4DCXk
        UfNfytG81fCmu7N1/rVD6hDM5ZQASQVrfULgFCTHfXTbo9+aPfqSaT686/FlRf/IwfnQ/TtfLVnLz
        VTKBasZqrJunBpw1tyc3XWvYjCMfmCjZ08PSmYaSulth3AgwY811iHeAxtu6rh9aDyQHcEnjmfgsA
        au8SKJM6tRKOQWnfcL0S1IpZ7sVpSBHxn2J2c024z/r+YWKwmwrIHsSFa1/RS0lixLfFPTKB+NK9g
        B3+8DmaOt7MHjr1DfH9FPY6c/okFymw5ZmHpv7Erm5QUf64OA4Waf1YfeGCZouAuWoftnmYPQH3Wq
        5HRpb+nQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lvJjl-00AFAZ-NK; Mon, 21 Jun 2021 13:13:20 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 579303001C0;
        Mon, 21 Jun 2021 15:13:18 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 41770203C06B1; Mon, 21 Jun 2021 15:13:18 +0200 (CEST)
Date:   Mon, 21 Jun 2021 15:13:18 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
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
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v7 0/2] x86/sev: Fixes for SEV-ES Guest Support
Message-ID: <YNCQbmC6kuL4K1Mp@hirez.programming.kicks-ass.net>
References: <20210618115409.22735-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210618115409.22735-1-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 18, 2021 at 01:54:07PM +0200, Joerg Roedel wrote:
> Joerg Roedel (2):
>   x86/sev: Make sure IRQs are disabled while GHCB is active
>   x86/sev: Split up runtime #VC handler for correct state tracking

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

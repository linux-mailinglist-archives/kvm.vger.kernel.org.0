Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFC9539345
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 16:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345279AbiEaOpQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 10:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236138AbiEaOpP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 10:45:15 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504AA655E;
        Tue, 31 May 2022 07:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=z4qdvj6k827PaJs2Jp8xMpkXGtZPqp3Y126ciDm2JAY=; b=eD9Mg9yS6Dh1kK1FvpyQGSH5Fg
        7QTb1wtk4WUBt8U57dmT8eJkCcD9HDCyC5y1fgq0NdeqvIifCQ7XV3ooW17fziNctJLOsICFm2zWs
        nBeVGrbv9sV9HzSjiYHXj3VRhe7WlrZoxvokjUiknqn0kVs3rapRpbxlsAu/ujb1tpcLdyopdCFUX
        sIPl4FpGF1nS8qoY2UIAKaSD1ArKipkyzMAYINo+FfTWETwF8o37wtDeeyyFUmUjXKP/OS2z82gZl
        gTXi7I9j4I5mEtSzQTHWV74fjdU7YjokO96JQnmC7l4u37r6TsLy6/09bg7iS8rlzCCeA1UOk6DtF
        m7s2uQvQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nw36g-003Tdk-2F; Tue, 31 May 2022 14:44:27 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3B7E03005B7;
        Tue, 31 May 2022 16:44:23 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 268B32097B44C; Tue, 31 May 2022 16:44:23 +0200 (CEST)
Date:   Tue, 31 May 2022 16:44:23 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jack Allister <jalliste@amazon.com>
Cc:     bp@alien8.de, diapop@amazon.co.uk, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, metikaya@amazon.co.uk,
        mingo@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Subject: Re: ...\n
Message-ID: <YpYpxzt4rmG+LFy9@hirez.programming.kicks-ass.net>
References: <YpYaYK7a28DFT5Ne@hirez.programming.kicks-ass.net>
 <20220531140236.1435-1-jalliste@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220531140236.1435-1-jalliste@amazon.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 31, 2022 at 02:02:36PM +0000, Jack Allister wrote:
> The reasoning behind this is that you may want to run a guest at a
> lower CPU frequency for the purposes of trying to match performance
> parity between a host of an older CPU type to a newer faster one.

That's quite ludicrus. Also, then it should be the host enforcing the
cpufreq, not the guest.

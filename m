Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68F00628981
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 20:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236925AbiKNTjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 14:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236699AbiKNTjG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 14:39:06 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C25ABCB8
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 11:39:06 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id y203so12011096pfb.4
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 11:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SnbT0F5ei2zxpbGJdU9XNCzE9p0oJuYz4GOLTiCpLbY=;
        b=WYxmPu+wDNYloeKdgtQYDwuM5rpBLsj/3qGX/b5FGWYDa8m3KbaOrCSdELRDJRStKC
         g4ToEL/ryHuTmJh74b3sEieYkmuHZyxNe3C0ZJd6H+YphD0qPfNfUOUdro21o+T/f9MG
         IybjCUidfdvIEwsWuLv3vrDMvOxs5ak+r7wENGAVPBTdopXaYb42aLkCUsJ0LmMXzCBk
         qGc1NVP6HTUD0aPnWMqGVaEVay0LfwrKHft0Py3fnGDQMBYNW++Y6ldLfEtY1M/RBuGH
         sa6EHTgnxnHCuRP5r4vhSkjQPAK/vtQ0Yy3s2mx9mPYLb0UqFD0ISdA1ZVCdjsYlIfp6
         lcTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SnbT0F5ei2zxpbGJdU9XNCzE9p0oJuYz4GOLTiCpLbY=;
        b=elTt2jDmkp5QnywJLhqSYCu2zbSaGW3+/RmeDZd6u2Q4xJetodc47psXgQEBmnEeDF
         vXkJpLm38B6G/KNfTbzA7IOtDUkwgewIy1Bo+pYJbXJsLWEIHsjmL+WT0p3uHjwk+2iJ
         fHhBsAlbPM5jLaJ/cFl+TxJBfQ3mHO2abFjBDRh652jPrftlrmBLxQfFqAyqtsQnPr1H
         tiuOZ+HxHk+AHZDACqHiY694Gv6HDb5EjEoZ4/7TLeJwfwOYKVSwefsgiXLHZf49KB1n
         dI3SNuInLkH8RrA1yli9929YOo5nh44p0SxC0MOLTQkmQHvXEla0zOpu7WllPasSzKk5
         6Wbw==
X-Gm-Message-State: ANoB5pkKD6f8fpRFsi6IZNqQaXvuvEEMPOzyWO8Mc9oX2I+TwnbAOq9Q
        YO0JMvOlu7Nk2xCwIvAUfLyqlA==
X-Google-Smtp-Source: AA0mqf6lQYmCXpIt7hVWi6z5CEkxKq5njWgSA9/s9neHKdLfsysNwsR/UgevB9VCTsM/2RDhsfCjIQ==
X-Received: by 2002:a63:f91e:0:b0:464:bb6a:50de with SMTP id h30-20020a63f91e000000b00464bb6a50demr12404508pgi.502.1668454745659;
        Mon, 14 Nov 2022 11:39:05 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 200-20020a6216d1000000b0056ba7ce4d5asm7107874pfw.52.2022.11.14.11.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 11:39:05 -0800 (PST)
Date:   Mon, 14 Nov 2022 19:39:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Durrant <paul@xen.org>
Subject: Re: [PATCH] KVM: x86/xen: Make number of event channels defines less
 magical
Message-ID: <Y3KZVUCCH+YQDbqu@google.com>
References: <20221114181632.3279119-1-seanjc@google.com>
 <629d6d90ce95b9db74f0101a4428be1119c4bfc7.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <629d6d90ce95b9db74f0101a4428be1119c4bfc7.camel@infradead.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 14, 2022, David Woodhouse wrote:
> On Mon, 2022-11-14 at 18:16 +0000, Sean Christopherson wrote:
> > Use BITS_PER_BYTE and sizeof_field() to compute the number of Xen event
> > channels.  The compat version at least uses sizeof_field(), but the
> > regular version open codes sizeof_field(), BITS_PER_BYTE, and combines
> > literals in the process, which makes it far too difficult to understand
> > relatively straightforward code.
> > 
> > No functional change intended.
> 
> Slightly dubious about changing the regular one, since that's just
> imported directly from Xen public header files.

Ugh.  I worried that might be the case.  An alternative approach to help document
things from a KVM perspective would be something like:

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 93c628d3e3a9..7769f3b98af0 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1300,6 +1300,9 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
 
 static inline int max_evtchn_port(struct kvm *kvm)
 {
+       BUILD_BUG_ON(EVTCHN_2L_NR_CHANNELS !=
+                    (sizeof_field(struct shared_info, evtchn_pending) * BITS_PER_BYTE));
+
        if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode)
                return EVTCHN_2L_NR_CHANNELS;
        else


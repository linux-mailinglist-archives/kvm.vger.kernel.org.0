Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A8D668732
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 23:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240277AbjALWow (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 17:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240317AbjALWov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 17:44:51 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802255E640
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 14:44:49 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id r18so13775043pgr.12
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 14:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EeqsYbPpxfJWvTt+bhcGbc3dFC6Uvdv57wMBIqHRb9o=;
        b=Sy/u1uw8JnqTqWOwChROVISdeBeRBaaUY/OivQqU1XTV7J28WUkJKdFqN2sCdgkcih
         yk4v7LtmwUNy1+ITlQHTHvnSObkiTyj476fvIBfa0QhdRBCPO62+fX3OP+Md346nJwAr
         Z2Z+XlIx2c2Loru9BU9MmSj4tZJ8FGANiRwRQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EeqsYbPpxfJWvTt+bhcGbc3dFC6Uvdv57wMBIqHRb9o=;
        b=vMkDNogrK+o9JjZ/EsTGozfqRxO9DxV9m8IcpfmQcrmhzC8zO8uDMVRCh4h0eDDtxR
         4iC1A9tXtO+Ih8XoR7HN9CuRj+3tOB+txxf7+jKK9oO60/g93qcxegW2jBV5ob1lSqBj
         a2h9gy9zekoPHd7G0/iAfGVpBCs0BSFbYpBKFv4PmrmQ7yDDibPZjIHDNQZLiEQXc2jU
         xe9QNqnNf0caZTehRuh+wQlbOUMn8YpPYsdtaaW+Nyd1DmH9kfoa9UW2q2pSrXaO0czH
         FH96DLlnS6TBYnjxjXpPesI2sI4KVXrwDKo0E5WiqzajD3zCZ93foEPyjhTue80LRygE
         dE5g==
X-Gm-Message-State: AFqh2kr+1Z7rDA9dxXdyrogQz1kjrLqYc2nkmxG79l6UMVnpXsXuAwQZ
        IfMue2XERRvuqOTG+RCUYRo3RQ==
X-Google-Smtp-Source: AMrXdXuT6rw2c83a5xiZbmvnFGz+zmKFF8iBdpkkGnPrrbiGWwgVglCbXrz8h/CXWglWWgcIVXcaXA==
X-Received: by 2002:a05:6a00:993:b0:581:c2d3:dc5e with SMTP id u19-20020a056a00099300b00581c2d3dc5emr66641575pfg.11.1673563489013;
        Thu, 12 Jan 2023 14:44:49 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 4-20020a620404000000b00576ee69c130sm12308549pfe.4.2023.01.12.14.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 14:44:48 -0800 (PST)
Date:   Thu, 12 Jan 2023 14:44:47 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Replace 0-length arrays with flexible arrays
Message-ID: <202301121444.104E492D@keescook>
References: <20230105190548.never.323-kees@kernel.org>
 <Y7xPSEMOWqz+3kgD@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7xPSEMOWqz+3kgD@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 09, 2023 at 05:30:48PM +0000, Sean Christopherson wrote:
> On Thu, Jan 05, 2023, Kees Cook wrote:
> > Zero-length arrays are deprecated[1]. Replace struct kvm_nested_state's
> > "data" union 0-length arrays with flexible arrays. (How are the
> > sizes of these arrays verified?)
> 
> It's not really interpreted as an array, it's a mandatory single-entry "array".
[...]
> >  
> >  	/*
> > -	 * Define data region as 0 bytes to preserve backwards-compatability
> > +	 * Define union of flexible arrays to preserve backwards-compatability
> 
> I think I'd actually prefer the "as 0 bytes" comment.  The important part is that
> the size of "data" be zero, how that happens is immaterial.

Oh, dur, I can read the comment. :)

It has to stay the old size -- this was a way to add an optional extra
struct to the end. Got it!

-- 
Kees Cook

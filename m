Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4CA5AF04F
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 18:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234098AbiIFQY0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 12:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233857AbiIFQXc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 12:23:32 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177D980E82
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 08:52:50 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so15402229pjq.3
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 08:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=+OcePk/Bv09ExjAP7BHAcxsu7OpjeROhvqTIml1fT1Q=;
        b=DjcbpAh8RRFnKssWVF75sciVELyuzsZgECOFtvs17ZeuEbCl4DZ0FmZA/pp48+iYgR
         wyA23ZUkj6bzoi7UcH+ssP3okgktA20bZZ6RZ/TvIvr0qn+SwSJbRkLXXyrmidOHHB6E
         /h4tBE35eWUWVYDuLmQloK5k8P84GCdb+Z2oO64toEY1qMx7TP/R6xqR8lz01mKV9VCJ
         cc9RGA9HYRCSnegXVXBRmidy6X5bFMxE1emdqrs8unnmPF5hamPMVA3tC9qLr5FQ1uJl
         VKfTACwnJ0VfI1m05ai9IucgBPIzYDPwrVCFSsakQ/2nTfdpmNxrrSQ0482EJmgL6TME
         mYgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=+OcePk/Bv09ExjAP7BHAcxsu7OpjeROhvqTIml1fT1Q=;
        b=bzeUi/4YKrKWig4zSSEkVQwV72YBN0EnIy3OYtr2JwgCAPlpiar1mu2SMZxGrHscJy
         KQRa/3hakvHVcvb8VbfDqxGqYYAn3/Yf7R/qU5EqpLf1pjUqirivwyUvNuHyJMUSbCVK
         EUTtaQAsnqJuKlSGbUhICfhSPmPBsKt+ELJAzqCtBRIwxaJ8bVZo54F+9X+Xm66HpVAm
         PxSlvYD2P3FmWdsnJaEXqcHo0iAoR/e7BuYkPvcCxXs9noWQQYfPvHZb3Mxub+ADGqYx
         UM+Zmfi5/K2L5Icg+U8rMhNUNWjQtJvr34Qs8HKR9aM3xvlQIfUejTYln5Jurl+gq6+j
         FdYw==
X-Gm-Message-State: ACgBeo338iAcXmuRK3jNw3ifCt2+jRmV6fIIIcg/rpFl7hpW48cQBSf9
        0LWn++kTUR88b8SyXLblL4aVmw==
X-Google-Smtp-Source: AA6agR5fECWXXnuZZ7taMZF75MjeXn8RkjNbQlCotJv1KPuOGQJYHNa8bx4D8cdRVQ1z792IfFnc4w==
X-Received: by 2002:a17:90a:940d:b0:1fe:39c5:4ce1 with SMTP id r13-20020a17090a940d00b001fe39c54ce1mr26182503pjo.74.1662479569463;
        Tue, 06 Sep 2022 08:52:49 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id v28-20020aa799dc000000b00536531536adsm10430038pfi.47.2022.09.06.08.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 08:52:48 -0700 (PDT)
Date:   Tue, 6 Sep 2022 15:52:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     bugzilla-daemon@kernel.org
Cc:     kvm@vger.kernel.org
Subject: Re: [Bug 216388] On Host, kernel errors in KVM, on guests, it shows
 CPU stalls
Message-ID: <YxdszchEjprmJVwX@google.com>
References: <bug-216388-28872@https.bugzilla.kernel.org/>
 <bug-216388-28872-i1w5cFfw4N@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-216388-28872-i1w5cFfw4N@https.bugzilla.kernel.org/>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 03, 2022, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=216388
> 
> --- Comment #15 from Robert Dinse (nanook@eskimo.com) ---
> Please forgive my lack of knowledge regarding git, but is there a way to get a
> patch that took the kernel from 5.18.19 to 5.19.0 now that earlier releases of
> 5.19.x are not on the kernel.org site?

Strictly speaking, no.  Stable branches, i.e. v5.18.x in this case, are effectively
forks.  After v5.18.0, everything that goes into v5.18.y is a unique commit, even
if bug fixes are based on an upstream (master branch) commit.

Visually, it's something like this.

v5.18.0 --> v5.18.1 --> v5.18.2 --> v5.18.y
\
 -> ... -> v5.19.0 -> v5.19.1
           \
            -> ... -> v5.20


IIUC, in this situation v5.18.0 isn't stable enough to test on its own, but the
v5.18.19 candidate is fully healthy.  In that case, if you wanted to bisect between
v5.18.0 and v5.19.0 to figure out what broke in v5.19, the least awful approach
would be to first find what commit(s) between v5.18.0 and v5.18.19 fixed the unrelated
instability in v5.18.0, and then manually apply that commit(s) at every stage when
bisecting between v5.18.0 and v5.19.0 to identify the buggy commit that introduced
the CPU/RCU stalls.

> I know there is a patch that goes from 5.18.19 to 5.19.6

I assume you mean v5.18.19 => v5.18.20?

> and one that goes 5.19.5 to 5.19.6 but I just want to look at the changes
> between 5.18.19 and 5.19.0.

If you just want to look at the changes, you can always do

	git diff <commit A>..<commit B>

e.g.

	git diff v5.18.18..v5.19

but that's going to show _all_ changes in a single diff, i.e. pinpointing exactly
what change broke/fixed something is extremely difficult.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5863E95A4
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 18:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhHKQNu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 12:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhHKQNt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 12:13:49 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E70C061765
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 09:13:25 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id a8so4238321pjk.4
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 09:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zLG0IhppbEuJ5I37GZ3ktmpdVCYinF/Aoi/BpZiVyOY=;
        b=UuG/nIza6FTbl6CUnlqf8n2GzjzaCWJRZkma3t2gozBz49i5DMRD7zqm8hTfUImQTK
         ZconzCnYaL/QSVlLZ32omkhOCX/b0kv/9SVvhIzX8mmWwuY95melD24SJoN/62CDoLI4
         TcLYNXdUNtmGqFQ470ULaTKpW0sisc4iX1N79c2Y/CrIMwXLAoM9sMWcpBky/1Von2Ip
         qAJ/6V8/RWvy8BE6atotoMw/htjry5FccYaNivKkJ7n3Nerv5qauj1iQ9prg48Vt6eWT
         fuwBjA2B8yGCvRhNI3d1lZ/jMz431jOR+UxsPOwne0rZ0Jdl/yMdVeTo+HMQM5gGxqt5
         qdIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zLG0IhppbEuJ5I37GZ3ktmpdVCYinF/Aoi/BpZiVyOY=;
        b=OwnbpXNDXQSElP7zYMx2OEwU4Z3/Ip839CUEdow9fmiGFhk9DDlZNQkawRO2IeiGXr
         8etiiIU3CNNH3xIw9wpoNm5cwkmHK9tRk/vgjvG8UqkZ9Pm/WwlW13YAd6Lf3dntxG2v
         ZNtzrSqZWm+1ZtR3/PsMG8dwQmxbmBVhgDLU8uKiTwcOOWVcD6ajOkwIvfm775NB+UI2
         ksD3gCvXgdk8PIl+x+EN7HhkVxK1PX1JLy86B8xrCQTeJUqUDbgSMMrv4mqT+GDtJmsP
         cl6fD6i6A1RD+V1aMbtRXtXqQizzjfN323Fn5Zv6YO0c+TM+Rwx6fv7dTdg7V0yoGrmS
         R8Bw==
X-Gm-Message-State: AOAM532BJSuZeHeB9NUNIN5fVwbKqGB/FTB/B6t13+oTLpqeuLJc3Trt
        b0xM9dE7Vf80aLs4CnXSteMQ84Sjpv4dig==
X-Google-Smtp-Source: ABdhPJwQgyzOHA9X6j+BerQ3nsX8xhB0omJPH+oiEAdnYHUsBrYfm7DochSgLjPLecm0tpLkr27n+g==
X-Received: by 2002:a63:5002:: with SMTP id e2mr534268pgb.256.1628698405248;
        Wed, 11 Aug 2021 09:13:25 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c15sm25647878pjr.22.2021.08.11.09.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:13:24 -0700 (PDT)
Date:   Wed, 11 Aug 2021 16:13:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Babu Moger <babu.moger@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, thuth@redhat.com,
        drjones@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 1/2] x86: access: Fix timeout failure by
 limiting number of flag combinations
Message-ID: <YRP3HxfCRMQBt2Ty@google.com>
References: <162826604263.32391.7580736822527851972.stgit@bmoger-ubuntu>
 <162826611747.32391.16149996928851353357.stgit@bmoger-ubuntu>
 <YQ1pA9nN6DP0veQ1@google.com>
 <1f30bd0f-da1b-2aa0-e0c8-76d3b5410bcd@amd.com>
 <7d0aa9b1-2eb7-8c89-9c2b-7712c5031aed@amd.com>
 <4af3323d-90e9-38a0-f11a-f4e89d0c0b50@amd.com>
 <b348c0f6-70fa-053f-86fa-8284b7bc33a4@redhat.com>
 <29220431-5b08-9419-636e-d4331648aed1@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29220431-5b08-9419-636e-d4331648aed1@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 11, 2021, Babu Moger wrote:
> 
> On 8/11/21 2:09 AM, Paolo Bonzini wrote:
> > On 11/08/21 01:38, Babu Moger wrote:
> >> No. This will not work. The PKU feature flag is bit 30. That is 2^30
> >> iterations to cover the tests for this feature. Looks like I need to split
> >> the tests into PKU and non PKU tests. For PKU tests I may need to change
> >> the bump frequency (in ac_test_bump_one) to much higher value. Right now,
> >> it is 1. Let me try that,
> > 
> > The simplest way to cut on tests, which is actually similar to this patch,
> > would be:
> > 
> > - do not try all combinations of PTE access bits when reserved bits are set
> > 
> > - do not try combinations with more than one reserved bit set
> 
> Did you mean this? Just doing this reduces the combination by huge number.
> I don't need to add your first PTE access combinations.
> 
> diff --git a/x86/access.c b/x86/access.c
> index 47807cc..a730b6b 100644
> --- a/x86/access.c
> +++ b/x86/access.c
> @@ -317,9 +317,7 @@ static _Bool ac_test_legal(ac_test_t *at)
>      /*
>       * Shorten the test by avoiding testing too many reserved bit
> combinations
>       */
> -    if ((F(AC_PDE_BIT51) + F(AC_PDE_BIT36) + F(AC_PDE_BIT13)) > 1)
> -        return false;
> -    if ((F(AC_PTE_BIT51) + F(AC_PTE_BIT36)) > 1)
> +    if ((F(AC_PDE_BIT51) + F(AC_PDE_BIT36) + F(AC_PDE_BIT13) +
> F(AC_PTE_BIT51) + F(AC_PTE_BIT36)) > 1)
>          return false;
> 
>      return true;

Looks good to me, is it sufficient to keep the overall runtime sane?.  And maybe
update the comment too, e.g. something like

	/*
	 * Skip testing multiple reserved bits to shorten the test.  Reserved
	 * bit page faults are terminal and multiple reserved bits do not affect
	 * the error code; the odds of a KVM bug are super low, and the odds of
	 * actually being able to detect a bug are even lower.
	 */

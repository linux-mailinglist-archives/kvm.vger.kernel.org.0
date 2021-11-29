Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE604626B9
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236356AbhK2W40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 17:56:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235581AbhK2Wzf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 17:55:35 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EA2C052906
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 11:04:22 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id b11so12929197pld.12
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 11:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S3AVMHNWfhWSMesZ3G/17wyBD7gMf/LwW96LGEoc5LA=;
        b=F2A4H5QgtUzAumwSxEfu7k5HX5qb5Tp1FaaCsvJ4FQYtqun5Uo3cs8Jz4q7IiS3Ky+
         Ei0INK3ywer1s4AiTOLfZeLN5kNq5EmlPA7hVGE32guBtRjUQYZfsl52n1DDjWhT3H62
         g67e5SKj50mVbS4j9InoE1p4a0UTSVWZVz3jaRdCIBkAISP2vibLybPsHpp4WJHyb4rb
         EZNYNovJlNFI0a/QE3MJqW0Pp1gCVXYq9ud+VsSQ098J1wn5lH2xap0/MtJSYyCTlI4B
         9xX+pVfzqlsYpQ4Nv1LAMnn0q5c8Z37WWg+89FYWvr3G7viwxPc8ddSpmJC04FgFT+GX
         PUHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S3AVMHNWfhWSMesZ3G/17wyBD7gMf/LwW96LGEoc5LA=;
        b=M1xc3KOl7ZeoJdalYjcUwehJ9qAI7RSHD3mszBYtPxTrFMPruwY0Be0DjTm0J+bLlN
         kjYbp1xXwj8JWR9/CPlfvP7lJ8eevaBzILpRh9hj5vobg28JJdRJAHqkQJSyjVHa4ZEz
         3DMa8pzOPwzRL34jEtELNjt0CaUnX5wBQaftx6S6ZUWUcCWaEre/XjDX3iF4ZgN/mupl
         JEy1uCxY8d3ML+RkBMibU/DzFp1J7ez34uqe6TG+19D6cD8D9jtfwnWPlAqd3PmA7T3D
         lP9X0+Kvuk8yztiMM2HeL9KX1NrAmEErwp0A0ByOCZpG23KhRPbR6Gaqr9lzRrZ0j8EO
         j05w==
X-Gm-Message-State: AOAM530bbDjc7clmdsz6BZRm2CLclK0Qf9hgyO0YRIHOg8Ub5OZmHjKb
        6PVRXZAK0qnfxgeYRNf+AAVrdCbEXyw8Ww==
X-Google-Smtp-Source: ABdhPJwbfuw911iaBr7+scgkjefSYEOXR5UR0UqMuHdjodX3D8fdK95uq1PBm+P1AsFMk6SyyRTqvQ==
X-Received: by 2002:a17:902:e544:b0:144:e3fa:3c2e with SMTP id n4-20020a170902e54400b00144e3fa3c2emr63002546plf.17.1638212661599;
        Mon, 29 Nov 2021 11:04:21 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s16sm18381981pfu.109.2021.11.29.11.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 11:04:21 -0800 (PST)
Date:   Mon, 29 Nov 2021 19:04:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 00/39] x86/access: nVMX: Big overhaul
Message-ID: <YaUkMQQQ4KdlmDq5@google.com>
References: <20211125012857.508243-1-seanjc@google.com>
 <34ff357d-c073-4a68-117d-63ccff1085cb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34ff357d-c073-4a68-117d-63ccff1085cb@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 26, 2021, Paolo Bonzini wrote:
> On 11/25/21 02:28, Sean Christopherson wrote:
> > This started out as a very simple test (patch 39/39) to expose a KVM bug
> > where KVM doesn't sync a shadow MMU on a vmcs12->vpid change.  Except the
> > test didn't fail.  And it turns out, completely removing INVLPG from the
> > base access test doesn't fail when using shadow paging either.
> > 
> > The underlying problem in both cases is that the access test is flat out
> > stupid when it comes to handling page tables.  Instead of allocating page
> > tables once and manipulating them on each iteration, it "allocates" a new
> > paging structure when necessary on every. single. iteration.  In addition
> > to being incredibly inefficient (allocation also zeros the entire 4kb page,
> > so the test zeros absurd amounts of memory), writing upper level PTEs on
> > every iteration triggers write-protection mechanisms in KVM.  In effect,
> > KVM ends up synchronizing the relevant SPTEs on every iteration, which
> > again is ridiculously slow and makes it all but impossible to actually
> > test that KVM handles other TLB invalidation scenarios.
> > 
> > Trying to solve that mess by pre-allocating the page tables exposed a
> > whole pile of 5-level paging issues.  I'd say the test's 5-level support
> > is held together by duct tape, but I've fixed many things with duct tape
> > that are far less fragile.
> > 
> > The second half of this series is cleanups in the nVMX code to prepare
> > for adding the (INV)VPID variants.  Not directly related to the access
> > tests, but it annoyed me to no end that simply checking if INVVPID is
> > supported was non-trivial.
> 
> Queued, thanks.  The new tests are pretty slow on debug kernels (about 3
> minutes each).  I'll check next week if there's any low hanging fruit---or
> anything broken.

Hrm, by "debug kernels", do you mean with KASAN, UBSAN, etc...?  I don't think I
tested those.  And with or without EPT enabled?

The tests are definitely much slower than the base access test and its nVMX variant
as they trigger exits on every INVLPG, but three minutes is a bit extreme.

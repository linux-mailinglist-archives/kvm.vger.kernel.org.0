Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D3A307DF2
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 19:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbhA1S2R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 13:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbhA1SZv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 13:25:51 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79413C061355
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 10:25:02 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id a20so4344819pjs.1
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 10:25:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lg+DTCcbBZLKqzRlWlD6ac7iinsWBA/mKJ1HztBD7pM=;
        b=H0cf+d26CVi2apbOt03UHpB51v4eg7npvkj3EZdTXEl8GgrPJPKNHc7c8ZFswyPrL/
         Syz9wOfVGOjo2j/UZDQneF8yguCZ7yNLbAOg84WAPtiZLX6N/6P5XMwRB7r+SD/HxW0M
         nXr46/oc4DH0QE8+qaiOV3mFjfZ2wT18cUWJfWrPm9mKPkzyqH40p8egkZYcs7SR0yW+
         gpGG4w/z3zHf0PvvUA3IEnm6qsneYWVB8+CdjkzOw4N6PZSisWz25HhKPBDpUhnl0pRy
         MAldBhRm+YKEemIJQuKGtlvv15Yieiwnu3cWoMPEnQL3g67ma+f//ZlD5KlFgXDwdPSK
         Zx3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lg+DTCcbBZLKqzRlWlD6ac7iinsWBA/mKJ1HztBD7pM=;
        b=rduR5YFDwjFysIObSuENfHkDVQnPdKcVn/btC1+vTFB78fw3GyxBDGeisghOFzXZSX
         uYhOm0bwXL3JT2izTG4T7FERRZeOOWC7JiMx1EFU+OMTx16C13IbhLjTyYpftWMbc575
         /QDoBJsjNYtFxioTgN/u8QeCG0Q/IGa4L1yISGAfuNRUGaPEIhh7DKMNai21cGXmgj4m
         6bNZTvXJ5PGKPS8NrtNb3A6e+Y2SN4fFcDup69kdBGDdI6JaYz2kfulouZ7jWKDUVH8x
         NE4WReRiN/m3Bk4+1c/ylc+10IgEP530vGP+UfrouiJfBBMR7QlS+0XmqkQKPZrTuroA
         /ioQ==
X-Gm-Message-State: AOAM530RifFyY5DJY3PfWDBPmzwtOphUeX0/VX3r3aX+vhqyli1N8O6J
        Cra3PYnN9TBGZDRH3WAuwUYhmA==
X-Google-Smtp-Source: ABdhPJyHZw8H5G05+qZC5J0iLc18ovAaIr+j/mnygSmuXhCai9rRyOhchLqaQr5LzNjqN/W/T+ALEA==
X-Received: by 2002:a17:90a:bf06:: with SMTP id c6mr618123pjs.220.1611858301894;
        Thu, 28 Jan 2021 10:25:01 -0800 (PST)
Received: from google.com ([2620:15c:f:10:91fd:c415:8a8b:ccc4])
        by smtp.gmail.com with ESMTPSA id 21sm6034852pfh.56.2021.01.28.10.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 10:25:01 -0800 (PST)
Date:   Thu, 28 Jan 2021 10:24:55 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v14 00/13] Introduce support for guest CET feature
Message-ID: <YBMBd1qxvQh47zcB@google.com>
References: <20201106011637.14289-1-weijiang.yang@intel.com>
 <c6e87502-6443-62f7-5df8-d7fcee0bca58@redhat.com>
 <YBL8wOsgzTtKWXgU@google.com>
 <32c9cdf7-7432-1212-2fe4-fe35ad27105a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32c9cdf7-7432-1212-2fe4-fe35ad27105a@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 28, 2021, Paolo Bonzini wrote:
> On 28/01/21 19:04, Sean Christopherson wrote:
> > On Thu, Jan 28, 2021, Paolo Bonzini wrote:
> > > On 06/11/20 02:16, Yang Weijiang wrote:
> > > > Control-flow Enforcement Technology (CET) provides protection against
> > > > Return/Jump-Oriented Programming (ROP/JOP) attack. There're two CET
> > > > sub-features: Shadow Stack (SHSTK) and Indirect Branch Tracking (IBT).
> > > > SHSTK is to prevent ROP programming and IBT is to prevent JOP programming.
> > 
> > ...
> > 
> > > I reviewed the patch and it is mostly okay.  However, if I understand it
> > > correctly, it will not do anything until host support materializes, because
> > > otherwise XSS will be 0.
> > 
> > IIRC, it won't even compile due to the X86_FEATURE_SHSTK and X86_FEATURE_IBT
> > dependencies.
> 
> Of course, but if that was the only issue I would sort it out with Boris as
> usual.  OTOH if it is dead code I won't push it to Linus.

Yes, at best it's dead code.  At worst, if it somehow became undead, the guest
state would bleed into the host and wouldn't be migrated as the kernel wouldn't
touch CET state when doing XSAVES/XRSTORS.

I floated the idea of pulling in just enough of the kernel bits to enable KVM,
but that didn't go anywhere.

https://lkml.kernel.org/r/20200723162531.GF21891@linux.intel.com

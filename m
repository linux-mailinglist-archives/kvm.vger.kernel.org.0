Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33F7815B161
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 20:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbgBLTxV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 14:53:21 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33236 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbgBLTxV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 14:53:21 -0500
Received: by mail-pg1-f194.google.com with SMTP id 6so1772036pgk.0
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 11:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1AWXJaZ+M/XEkvhiKGrLr+34R/ByznWv2S2mVXPNnjg=;
        b=YamDIrDwFddysAcDWua56hzXv7lDB4HKrdSODVsPwHBE4HHsAYGn+XDZXaLyGGJLuD
         4N6BTWo6LRFS5vXXP6KAh/l1wvA65OHmtw/S1qbPAdcyTCBTaxonp4pggsf0hy6oitMf
         nKfCWU9CgVkCLAkcf+IIObAX4N2fivvdfm3BKqhD7SygUsmFFS04afPpEQEn/CexEjIi
         Uoi9/c1Q4IzArRa+H3OBoOJPbEYqEFKDZcI5QfDUAP1xlIRyhb8ado0qBp7XXWgoaWkS
         jgAsn9GLQd68qpur8Cz34vSBaC/8FytAq/rnOnK9IxLsgg83nRXtIFX/rUaMDekw5LFg
         HThw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1AWXJaZ+M/XEkvhiKGrLr+34R/ByznWv2S2mVXPNnjg=;
        b=ro25pVpgC9J67818qofgn/uxm4ESrjZnQyCUaLkZo+4MLzZozWU40hwHwLDrhvntpW
         LTBo2+7u1oqUeMlSGzXDl7tcDHXTW4JgSXEzhMufXN8I7KBeqQHaLvl8XC4nPjLT8WpX
         UKlKDOgEMLm7WxlzMz466WN5P5nPEjb3iQPXT/8obsulUFMJR5Rf1XL7nuGvK9uwPEBw
         oBh2ro0Jxz/+Coc1FeY2388siXjIJYtMQPr76694e0XOmB0OBQ+nhqk9a5DiEviYLTA/
         EFHSs1xs1tyCNtdy1UWHYrRLW0ahyBJMN6b3BnoNV2JzqvMjjlvOOkD8c543/cCwTXP3
         IGYQ==
X-Gm-Message-State: APjAAAX9yhUtWOp/3RUIYHz2G1G7/oZaeA3crG9kGv2imd4ErsYbkRsL
        krQl315izkyx+SU85ZF5CrSqMQ==
X-Google-Smtp-Source: APXvYqwiBlO43Srtx0lyJj2MrAKlNqXYg1FIQ7p5Qm51cLDiEjDInDuC0790jSVHcD0Qe04DoyWBZg==
X-Received: by 2002:aa7:84c4:: with SMTP id x4mr10064136pfn.144.1581537199973;
        Wed, 12 Feb 2020 11:53:19 -0800 (PST)
Received: from google.com ([2620:15c:100:202:d78:d09d:ec00:5fa7])
        by smtp.gmail.com with ESMTPSA id x21sm49255pfn.164.2020.02.12.11.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 11:53:18 -0800 (PST)
Date:   Wed, 12 Feb 2020 11:53:14 -0800
From:   Oliver Upton <oupton@google.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [GIT PULL] KVM changes for Linux 5.6-rc2
Message-ID: <20200212195314.GA27069@google.com>
References: <20200212164714.7733-1-pbonzini@redhat.com>
 <CAHk-=wh6KEgPz_7TFqSgg3T29SrCBU+h64t=BWyCKwJOrk3RLQ@mail.gmail.com>
 <b90a886e-b320-43d3-b2b6-7032aac57abe@redhat.com>
 <CAHk-=wh8eYt9b8SrP0+L=obHWKU0=vXj8BxBNZ3DYd=6wZTKqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wh8eYt9b8SrP0+L=obHWKU0=vXj8BxBNZ3DYd=6wZTKqw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 12, 2020 at 11:38:20AM -0800, Linus Torvalds wrote:
> On Wed, Feb 12, 2020 at 11:19 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > > So this clearly never even got a _whiff_ of build-testing.
> >
> > Oh come on.
> 
> Seriously - if you don't even _look_ at the warnings the build
> generates, then it hasn't been build-tested.
> 
> I don't want to hear "Oh come on". I'm 100% serious.
> 
> Build-testing is not just "building". It's the "testing" of the build
> too. You clearly never did _any_ testing of the build, since the build
> had huge warnings.
> 
> Without the checking of the result, "build-testing" is just
> "building", and completely irrelevant.
> 
> If you have problems seeing the warnings, add a "-Werror" to your scripts.
> 
> I do not want to see a _single_ warning in the kernel build. Yes, we
> have one in the samples code, and even that annoys the hell out of me.
> 
> And exactly because we don't have any warnings in the default build,
> it should be really really easy to check for new ones - it's not like
> you have to wade through pages of warnings to see if any of them are
> your new ones.
> 
> So no "Oh come on". You did *zero* testing of this crap, and you need
> to own that fact instead of making excuses about it.
> 
>                    Linus

I should've caught this before even a build test, let alone sending it
out. My apologies for such an obvious + crap mistake.

--
Oliver

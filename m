Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A84F3C91B1
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 22:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240871AbhGNUFg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 16:05:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43533 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242308AbhGNUEq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Jul 2021 16:04:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626292913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sQM1t+sm3YURTxJOPDtOEB2n2+vo2zYAMj6B34VXxkw=;
        b=AyArrd0hoYixa8BNGuVxyinQ9DwUV3DbMp2IBq4B1A5tSMtXTLuKRDSHqmM8jqYmanmDwN
        /sBfw3W5XcKdILmM52gZpzHBFgScIngdXhhVCXjdWbdKSR2SwkoVTZtngSz0RT3c8tfg20
        2e/Vi23yHsaKpUBjCm61YOLFHZYh+9U=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-GjwHDs8hNMefvAk7fd1ASg-1; Wed, 14 Jul 2021 16:01:52 -0400
X-MC-Unique: GjwHDs8hNMefvAk7fd1ASg-1
Received: by mail-qt1-f197.google.com with SMTP id g4-20020ac80ac40000b029024ead0ebb62so2604727qti.13
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 13:01:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sQM1t+sm3YURTxJOPDtOEB2n2+vo2zYAMj6B34VXxkw=;
        b=ZxMasK2UtiOCFV0iapW1f+M9BDzDH4HlEW8nJzngU5EV7xkGhpFB4wbBhW871LgjXr
         0/HeWCcPWd8oZ7w53Yola7uPv4f3xkDwX9nJaTNbnOMDNWMJ0DBs9/0OEgpx5BU+SY1h
         YkItAjgNCArUrI3KoTSscvxuIJqhKRDeLvomV6J1bkDdx+DeWGLDKVjVNgJQvxmgJSUF
         qV6hKvmcJLVnJ90X5YME0jGHiCr5k3zw1SBjlGoyew/qVIn4Hb/4xokRqIoC9GRqruSY
         cX71wVhVCz8ujOezrcP5ZqTmtXL2aHgcJdKMFB0AQQbLvtNyLQmOneUmoNhRyBRjoPHt
         SADw==
X-Gm-Message-State: AOAM532KcsE2HH4PopZtkFgq9Vpza8jdZIv6qLfVLtvGGelSlEUED1M7
        +xibM4DjAkKfKwDKs/DiSTyOTNWDjAtSGIka3lkd10TSXAc6Y7QikA++UfLWlM8EOVCqpxNTIfH
        /5DWpAZpqSx60
X-Received: by 2002:a05:620a:24c7:: with SMTP id m7mr11467462qkn.143.1626292911998;
        Wed, 14 Jul 2021 13:01:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyk3zeWWq9kFBADIM8pqrA3Tmt8g/FfXldlWPscDEzBqvEiYx2I+tAs3oIgkN/bg/94hw4gdg==
X-Received: by 2002:a05:620a:24c7:: with SMTP id m7mr11467440qkn.143.1626292911820;
        Wed, 14 Jul 2021 13:01:51 -0700 (PDT)
Received: from gator ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id p187sm1505865qkd.101.2021.07.14.13.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 13:01:51 -0700 (PDT)
Date:   Wed, 14 Jul 2021 22:01:48 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Will Deacon <will@kernel.org>
Cc:     Fuad Tabba <tabba@google.com>, kvmarm@lists.cs.columbia.edu,
        maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com,
        christoffer.dall@arm.com, pbonzini@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Subject: Re: [PATCH v2 09/13] KVM: arm64: Add trap handlers for protected VMs
Message-ID: <20210714200148.vjujrwsn2qsfd6kd@gator>
References: <20210615133950.693489-1-tabba@google.com>
 <20210615133950.693489-10-tabba@google.com>
 <20210701140821.GI9757@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210701140821.GI9757@willie-the-truck>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 01, 2021 at 03:08:22PM +0100, Will Deacon wrote:
> On Tue, Jun 15, 2021 at 02:39:46PM +0100, Fuad Tabba wrote:
> > Add trap handlers for protected VMs. These are mainly for Sys64
> > and debug traps.
> 
> I think one big thing missing from this patch is some rationale around
> which features are advertised and which are not. Further, when traps
> are enabled later on, there doesn't seem to be one place which drives the
> logic, so it's quite hard to reason about.
> 
> So I think we need both some documentation to describe the architectural
> environment provided to protected VMs, but also a way to couple the logic
> which says "We hide this feature from the ID registers because of foo"
> with the logic that says "And here is the control bit to trap this feature".

I think it would be better to have documentation that says "We expose this
feature because foo". If the feature doesn't have any rationale to be
exposed, then it's just not. It may also make sense to document features
that should never be exposed, if there are features like that, in order to
ensure nobody comes along and exposes them later.

Thanks,
drew


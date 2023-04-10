Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC406DCA0B
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 19:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjDJReJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 13:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbjDJReH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 13:34:07 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D402135
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 10:34:06 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id x4-20020a17090a788400b002466b299ed7so1674427pjk.1
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 10:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681148046;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DgdTqbVzw71tTd4ag9o32WVDiPYnzhfJtt3L4vDyud4=;
        b=SoqPMZpTyZwP61CDjwraoEOUKQ6SbjHX5rIqhvDo+V15EwzSz9z/OJD+azI4zR1tOb
         4MVQ2pDBpi0ly5BnCIcrORoO6aB/+3LRpoaeIUl15+Im9xxSL/02WNUzNhEYtcC4VtEk
         ZC1HyoiNtCkJq3odced1ushJymkc1fD55J5Ab27faYzhMZzHJ9toLDxGQm0am4E0MOHG
         YEZpkvgvo1sKCJ/7hPVVz1F2hvZmMW+dKCZGNPzjbDjz2Faybod4XYLUZUQcqJEAOkTy
         NYPPaxJ39JRV3kj2L0hE4K88Qu3/H1xdnZWh5dh2JSVhwhN4kO45vQgbwgOooZTay2Wf
         SQuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681148046;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DgdTqbVzw71tTd4ag9o32WVDiPYnzhfJtt3L4vDyud4=;
        b=TEM6akxkncsvKfD51UZms7QzPsNphk+G5vcMUhVwjRtJakKk3CoABFey0j1XTNQqD8
         JGqiK3XvBxgDmUSRIsovEa9qByuwR3U+mEQCcU8zimz4EY8jeEbWrPR9S0BMzUqZ6tPX
         w3X5I9gRNGqG3/NWRhy/QH+VTnuae3fnAAZYGhJhLfVJZSRLpe6V3h2oTRKmw4Axe0ye
         QEuleLd6wKDS5NWwqedmORGKfnpBhIEwnlHpdYiIepUsKH/EI4E1xaCvB3VY9pyKTh22
         00gA363L+yoEsd1GQnJ31UNkrcawPMrjSp3Pq91Dg+vGLR599dEWzAWsLGn+2w8k6CkS
         6ilA==
X-Gm-Message-State: AAQBX9fP+KBJ9UhX7ULngqblqBXhwTD0zd9sUiS26+g5YPDz4zygmpbV
        5VBy5eZYp36mA/nNxm4Cx8ZpHA7eGJ0=
X-Google-Smtp-Source: AKy350ZX/Ak5ilZtqnDLczx2zquL7tVIK7wY1EV8/XMVzoKj6mD25j6VAkLA+BoYuwvKaT0fD3CGQ9Rb9iU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:d50a:0:b0:513:57ce:d61c with SMTP id
 c10-20020a63d50a000000b0051357ced61cmr2136243pgg.7.1681148046446; Mon, 10 Apr
 2023 10:34:06 -0700 (PDT)
Date:   Mon, 10 Apr 2023 10:34:05 -0700
In-Reply-To: <20230405004520.421768-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230405004520.421768-1-seanjc@google.com>
Message-ID: <ZDRIjY2yycby7EZX@google.com>
Subject: Re: [PATCH v4 0/6] KVM: x86: Fix unpermitted XTILE CPUID reporting
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 04, 2023, Sean Christopherson wrote:
> This is v4 of Aaron's "Clean up the supported xfeatures" series.
> 
> Fix a bug where KVM treats/reports XTILE_CFG as supported without
> XTILE_DATA being supported if userspace queries the supported CPUID but
> doesn't request access to AMX, a.k.a. XTILE_DATA.  If userspace reflects
> that CPUID info back into KVM, the resulting VM may use it verbatim and
> attempt to shove bad data into XCR0: XTILE_CFG and XTILE_DATA must be
> set/cleared as a pair in XCR0, despite being enumerated separately.
> 
> This is effectively compile-tested only on my end.

Aaron, can you give this series a quick spin (and review) to make sure it works
as intended?  I'd like to get this into 6.4, but I'd really like it to be tested
on AMX hardware first.

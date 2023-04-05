Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2DA16D8ADD
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 01:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbjDEXDR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 19:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjDEXDP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 19:03:15 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25AAD4EED
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 16:03:15 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id e14-20020a056a00162e00b0062804a7a79bso17033937pfc.23
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 16:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680735794;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0t8CCFi1UeZd8iB0cNmEVhrSX6Sm6Hke/FGg2hJtAyU=;
        b=DUGmym16WM/+jVAIOKbd8jXgPO+HUkyMphYpf/c9YLS3zBjcm3tV3arhwElzFajD37
         1WdWmJFsUWdZXTLwp9o5GtmeNlgwLhUOmA5/6k4bDt2S6VCPpUsRuFbCh8GCWUW6Bu6C
         Xl3ztYVh1K38GM7O+7C8F7B181tF8Enp9NKywYUfsCmWEu6v+Flq/T2grwWwXGqmXFBp
         jSF2WXZYDvMoqHZ1qvQuH7LncABraVs46wr2TUljsh9StCiKPIVKuHF5hwsTU4EuA9i8
         ZupIniwS1eahGnpUQLCFmZsZWYnFfCMCbrxfy+8DvuGCvrHfINSJjBmLI6W2m0MwxxbQ
         y5cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680735794;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0t8CCFi1UeZd8iB0cNmEVhrSX6Sm6Hke/FGg2hJtAyU=;
        b=f60i47adGd9f3/MumLLNbc3k7NjojgRspFl/dq6JTqsvStNF5SbwsEYo80qGZWj73M
         DG/ESLvXZyX1o/zJaPRgWSfVQ6viaVjVa/5RiGssyOhpNXwaWDVRlheviJ/Q3Q5txmCZ
         J5pYygwy9uNuwgrBnEvYU/Rq70EMdsHLevwd0cDVHvEdEHBbVeVKIDvs1WFEUZDVUFvJ
         S0X4+na5E+TbuFNGoqL1BswSqFKsBUu/sdWm9PkHKJIou4qFUel1PWfTt9P29ockcQCn
         oUEhZ5yaOj6FlYY7mG5jr3Y6DvQmJpR6NvaCmOhECIZ7kuBzMukIRKdG82UKincBxlbK
         KpSA==
X-Gm-Message-State: AAQBX9cUye2e7vFHwPKo9YxR3Xqc4EP8zkZBMArI4esXL7KQF6VxJP9S
        JbW2iltDZbK4U8v/hypkZMgSCdpUQMA=
X-Google-Smtp-Source: AKy350bRAVLiHRnATrtUqhdOsaVAlEn9PRKzMI4vrt1dOpVBLZqZxbkCU7EtdS08gsLQTHx+6Op7Ie8lv/c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7b97:b0:19f:1dfc:9fd4 with SMTP id
 w23-20020a1709027b9700b0019f1dfc9fd4mr3074870pll.1.1680735794646; Wed, 05 Apr
 2023 16:03:14 -0700 (PDT)
Date:   Wed,  5 Apr 2023 16:01:00 -0700
In-Reply-To: <20230329123814.76051-1-thuth@redhat.com>
Mime-Version: 1.0
References: <20230329123814.76051-1-thuth@redhat.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <168073550254.619716.10085104611122942655.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86/flat.lds: Silence warnings about empty
 loadable segments
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 29 Mar 2023 14:38:14 +0200, Thomas Huth wrote:
> Recent versions of objcopy (e.g. from Fedora 37) complain:
> 
>  objcopy: x86/vmx.elf: warning: empty loadable segment detected at
>   vaddr=0x400000, is this intentional?
> 
> Seems like we can silence these warnings by properly specifying
> program headers in the linker script.
> 
> [...]

Applied to kvm-x86 next, thanks!

On the topic of annoying warnings, this one is also quite annoying: 

  ld: warning: setjmp64.o: missing .note.GNU-stack section implies executable stack
  ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker

I thought "-z noexecstack" would make it go away, but either I'm wrong or I'm not
getting the flag set in the right place.

[1/1] x86/flat.lds: Silence warnings about empty loadable segments
      https://github.com/kvm-x86/kvm-unit-tests/commit/0a06949aafac

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

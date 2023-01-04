Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09BC765DF02
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 22:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240435AbjADV1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 16:27:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240467AbjADV0u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 16:26:50 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF4543C05
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 13:20:40 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id j18-20020a170902da9200b00189b3b16addso24921890plx.23
        for <kvm@vger.kernel.org>; Wed, 04 Jan 2023 13:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9Tq7FtjdAxMenZUdP94jpiY1WQWtFexBAUHIvWXe5/E=;
        b=rhMJnL5Kf2ZkCYhp3cK7TEhpRX5YMA+GtsfOOIzbLggq6rTracB5eJx9MQdqkYxe7e
         eWtu0sMivWTwYWdxQFeBdPgyWfqnVbfvWFNK/eEEffjHrcxg0a34bg0jOuEvv6DC2jlF
         osfjOEOcWnv4olDRNPZEXB/95n3/lJ3b/Q0mvhQn4CcHuQsD3ECZOglQoirZar7eerZK
         9pB3UCmCj6CGjh1dMNPSIeq+fIqGUsEkMAFBuv39udy4xCmk7EVtMfnP8HzYV3NbaOhc
         /8GgMYDt1PxTHijgHXP9IOWQWjcl3FERTxE7FxEjU+ApJ9iYGHC9xwuKPPt1OSP6uKiD
         qYGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Tq7FtjdAxMenZUdP94jpiY1WQWtFexBAUHIvWXe5/E=;
        b=BfmdUWa/JsuNpWGzfozLyoU39gw6MUCCEr7H0uJD/dg+ZLGNQwK6POAP6GwWi5oFqv
         ATwbro2LxwZmtLcgFYBf33yQQikfFyZSQaYKTt+YVDKat26hp8ggivJwgO+/Bz1ci+TW
         TnuyyA/VBFWssyECCm2brKi33lIkWIn/PS8xoZUtY4OBZEdKCGonajeBqGOXmoIKPXiR
         9tRNsc9pUXb7p2v60UbN65l9snJRJzyKVrhX0+ItVaRCwGgZfh8MsIp0+9gMEVjzxD1U
         gW9LmzwYF/4XEdwBoZ4f8050qXZxMiOOEt7CaEPvf/2RZNu8HmT1aKvG0elTsDpiChyj
         xVgA==
X-Gm-Message-State: AFqh2kqZp7xn9w+7AF+nw1Y8htOERLcl4dXnKZyNRyDCc49zgqEvljRf
        ouLLMh0K2qz9dZAFKXM14D57sC994MBHH4/JRQ==
X-Google-Smtp-Source: AMrXdXtYvWz/PGzmklWTOEIC+Zs5FTse5JdOKgdHAQi/lUm8mTSUtejZOuNeKzMqkBt1J1UiQZgXBrmGeK6x3rKaMA==
X-Received: from ackerleytng-cloudtop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1f5f])
 (user=ackerleytng job=sendgmr) by 2002:a17:902:bb8f:b0:192:fa87:f109 with
 SMTP id m15-20020a170902bb8f00b00192fa87f109mr88333pls.173.1672867215663;
 Wed, 04 Jan 2023 13:20:15 -0800 (PST)
Date:   Wed, 04 Jan 2023 13:20:13 -0800
In-Reply-To: <1cacbda18e3c7dcccd92a7390b0ca7f4ba073f85.1667110240.git.isaku.yamahata@intel.com>
Mime-Version: 1.0
Message-ID: <diqz5ydmov3m.fsf@google.com>
Subject: Re: [PATCH v10 098/108] KVM: TDX: Implement callbacks for MSR
 operations for TDX
From:   Ackerley Tng <ackerleytng@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        pbonzini@redhat.com, erdemaktas@google.com, seanjc@google.com,
        sagis@google.com, dmatlack@google.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


I believe we should also have a handler for .msr_filter_changed.

Without an .msr_filter_changed handler, a host crash can occur if we
first set up a vcpu for the TD, and then set an MSR filter.

If we first set up a vcpu for the TD, and then set an MSR filter, upon
vcpu_enter_guest, the .msr_filter_changed handler (currently
vmx_msr_filter_changed()) will be invoked. to_vmx(vcpu) interprets the
containing struct of struct kvm_vcpu to be a struct vcpu_vmx instead of
a struct vcpu_tdx.

In my case, I was working on a selftest and the missing handler caused a
NULL dereference in vmx_disable_intercept_for_msr() because
vmx->vmcs01.msr_bitmap is NULL.


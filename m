Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9B7718E24
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 00:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbjEaWJG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 18:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbjEaWIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 18:08:51 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A8C138
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 15:08:33 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba88ec544ddso187520276.1
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 15:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685570913; x=1688162913;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0hSLOmieJuqorPFommfTQmlpTMkPq2YyL5DBFvSu9IM=;
        b=5URtwXSeGQwbrSdQVpva19Dzf/0FII0w40om/zh1LrR9rUmxLfD7gV2WbCJdzvWYFR
         P/IiKn0yGJ41N6rvGMFPqkfG4/WUCL4r9bySWdATYWU2l8jGwlaXsir5CqMcEY7+TmBw
         +Js3lZo0G4xq8V8zIvEhVQ8W7QLRZvaylhhdgzR6le2NAZH9xGa8n4m+bmfI5APLryVi
         iDdGYWjg6t5tx/EqgyMOpBLcnU8E2auLtkaMgXTB0CJ+BHXJhsGVltazZdffz/2YbYyY
         SqUR1LdmNEw6bE6i4ShrVQ6OQUK0GLiCzxqlqBa3dicqi9adBehxuPQOe7uifrPgJWb+
         2yMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685570913; x=1688162913;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0hSLOmieJuqorPFommfTQmlpTMkPq2YyL5DBFvSu9IM=;
        b=MYPzEJi6v7rG2qq2dUMmtD54e9WFdLUCezMpp9JREfZS1CmYoUYcI5X34Vg3gj3m0I
         MAgr68t+A+sz/gpH/tSwAJnNlqS/TQKTkASAR+f0MJfK5GACHX8E4sEYAeECjk0NGmjq
         PGUtzHivSoKo8/7pg7O0+9ltLvyWKORRWIVNMb0VpKiZukD/7+CW4zF+6xfkypDaUA0v
         n9WUiyTGLbM1EnJpvREYZe7Iz9zJ2dt3nMqXLc2uV2UdAL5tckAwOPzeDQ9tZp3nAyw5
         89/2FFhkOLIFm9roglV8AE7w9zhuZYvPe2fGlMPEmv//YTtPrwdeYuWGnuz2++eEJEYG
         /VLQ==
X-Gm-Message-State: AC+VfDzSbF/7fBUZH9Kb+NrYM7kNwXsbidUTtzZJTXAPWw8uPkL53X7n
        sYRq7U2GRfRxzBLq7yyzJVysNuuCqjY=
X-Google-Smtp-Source: ACHHUZ6kFREOs9uAWEc4cI/LZqdi+/M359Gzm0H8uZdn3jzoOzC16tSeS0LU/SMbQ1TCI5oJh/K+ve8xjs0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:249:0:b0:bab:a276:caac with SMTP id
 70-20020a250249000000b00baba276caacmr4212216ybc.3.1685570912962; Wed, 31 May
 2023 15:08:32 -0700 (PDT)
Date:   Wed, 31 May 2023 15:08:31 -0700
In-Reply-To: <20230510140410.1093987-3-mhal@rbox.co>
Mime-Version: 1.0
References: <20230510140410.1093987-1-mhal@rbox.co> <20230510140410.1093987-3-mhal@rbox.co>
Message-ID: <ZHfFX/PDrwKtx5cv@google.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Add tests for vcpu_array[0] races
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, shuah@kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 10, 2023, Michal Luczaj wrote:
> Exercise races between xa_insert()+xa_erase() in KVM_CREATE_VCPU vs. users
> of kvm_get_vcpu() and kvm_for_each_vcpu(): KVM_IRQ_ROUTING_XEN_EVTCHN,
> KVM_RESET_DIRTY_RINGS, KVM_SET_PMU_EVENT_FILTER, KVM_X86_SET_MSR_FILTER.
> 
> Warning: long time-outs.

Heh, yeah.  I'm inclined to leave this as a test that's archived on lkml, but
not merged into mainline.

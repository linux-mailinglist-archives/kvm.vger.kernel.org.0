Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9469570743D
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 23:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbjEQV2t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 17:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjEQV2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 17:28:45 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BFD1FD4
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 14:28:40 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-561c11762b7so18760167b3.3
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 14:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684358919; x=1686950919;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2U//1HaqKRad3YxcpM56jnvDfvX6xGIz9OVATVBgbMA=;
        b=tSaGmziXCuNZfqUQrEkatzGF35vhAvQ0IUU9JqMsTs3yjD7bsqOh/xaLzZZJ+1jGVJ
         tg8ANWmyQyPUYzfMS+tGcUR/Ka2NwMQbmcZKalUmHL/k+tXKN1oZHLvyUZ+0malc/YQ9
         ofaxXQcgKXhGdlj/55HDjtQKY1e8NcAzO53uBYNuvY+9fyGR/nsFyJ8O8O1Zot4kBUs0
         VVL+0fh6MgRyIYZwvuOnH1FkYA8F3k1MDrG01J/sOXTQffQ8hURH7QHLjyoj0w67as7d
         kXfrndbftio5xkGAsEyh3V05jpxjQ7K47WdKWrmbNbWjBLzKVCe7GGo9NID8YpQT3dxZ
         /m+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684358919; x=1686950919;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2U//1HaqKRad3YxcpM56jnvDfvX6xGIz9OVATVBgbMA=;
        b=DZSmb7bpK64FM2njctcFuYXCDIp7Jk7ySSas7OwGHOMdbOiDDXsZM4Ua1Hk2n7QgYZ
         xQZwLE1hczXT2LMMtisE9a+7Sex0HgcgKJ9KNJ59RBYMQ9whtaZJA9YBUGzmdnDDl1/4
         SUCaboMXsGLqPJAMGO3EHRIIxvhwY4kIsLNN/y5zbEGkLmt0UK2r4Q819651EVq34FTa
         IiFCoYUGbdl108mqgmRa2i8iIrPc9JtAyHzgtuwH4MNA41HCk6PMeu3gbXbDbpvPjpe+
         KwPsPj5SkjZpnf5fdrzwWPXPa5FFvFYNPKRu/OqBsQXZbOw4MbUiMQHR0Zkok1oAaraZ
         gsog==
X-Gm-Message-State: AC+VfDzAH1osIIRLPCTeg0k1FL0p8pErm+gRh8ogZJu6k8mYe+1fwOhG
        wnYEl0ZkqnhBwbiRlQysly4/16z1SAI=
X-Google-Smtp-Source: ACHHUZ7sdyIC1kxCapYW50rX7lK3Ggjlqjf/JnqIztWHaa0sMAdk0yeb7RjFGK4UAdaSqD7D3W0oA4Geh7U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ca44:0:b0:54f:a35e:e79a with SMTP id
 y4-20020a81ca44000000b0054fa35ee79amr23994145ywk.8.1684358919790; Wed, 17 May
 2023 14:28:39 -0700 (PDT)
Date:   Wed, 17 May 2023 14:28:38 -0700
In-Reply-To: <20230423101112.13803-3-binbin.wu@linux.intel.com>
Mime-Version: 1.0
References: <20230423101112.13803-1-binbin.wu@linux.intel.com> <20230423101112.13803-3-binbin.wu@linux.intel.com>
Message-ID: <ZGVHBosyCEOrokyJ@google.com>
Subject: Re: [PATCH 2/2] KVM: x86: Fix some comments
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
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

On Sun, Apr 23, 2023, Binbin Wu wrote:
> msrs_to_save_all is out-dated after commit 2374b7310b66
> (KVM: x86/pmu: Use separate array for defining "PMU MSRs to save").
> Update the comments to msrs_to_save_base.
> 
> Fix a typo in x86 mmu.rst.

Please split this into two patches, these are two completely unrelated changes.
Yes, they're tiny, but the mmu.rst change is more than just a trivial typo, e.g.
it can't be reasonably reviewed by someone without at least passing knowledge of
NPT, LA57, etc.

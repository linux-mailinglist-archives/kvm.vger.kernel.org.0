Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 268F6725142
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 02:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240367AbjFGAzB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 20:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239738AbjFGAy6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 20:54:58 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57B4170B
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 17:54:57 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-569fee67d9dso2221447b3.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 17:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686099297; x=1688691297;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9JXuPOLvrVg9/ksu6Mrrqfogv4kOQAht/SYRJa//Rr0=;
        b=Op0Pthgyxp87IhRuxWauKzySxGWWBhArFXPrQ8NKc2gA9FwHTRDArNPyIWmhQ3MztH
         tyYj+T0csfvejiks6cXJ30V9Et83VN1FBekCDFC7OSk+E/RyZFyAT7jPE1ijZlKqqR0Q
         q9CwMwMTjYputBZWNTqfE4H+lr7yTJCxaCMjkKEc+O5NuVNTai6xFZI5d1vOZmeRjiU2
         YA1M+XmyneGWARP3gwQdQ2aVBKWxdb/9JtomlEzGY95wXl2lbPXa8bROKvMpkXIFXFt2
         cAOQlPc5raVHKv7BPCbofWqgNBE8eSrv1enP3Sc0fIa12D94uv6rH5TKtE0AHhwr8q8m
         Hfgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686099297; x=1688691297;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9JXuPOLvrVg9/ksu6Mrrqfogv4kOQAht/SYRJa//Rr0=;
        b=MtNQ8Xo6WI9UAcId6TbW8aI21SB95QoMtr3CC5R342+WiYp2R/yHpilId8rJLfYHpM
         bj0g+QUb3hYNrK5S2AE10KUfvo9H2h0wrm/yz+q2X04tTVA9DRL+j9VC61rRkMjDepvA
         lGcsvf5p4a7VpyqgtL65V97UmS3FCGKuAgkpoMYdMdEHNB7yLz3Dq0kIUejzh7bakhWa
         qfCo8bRHVo7jg13YZ6JxkzqUVhXMUCG9VfDNa4OGba8pYC92W+33Xze1xKQNrITMSp5z
         U2J02OQStrzrhQi6y0T8VYkrkaY4/4m8qrss5ZhOPdZCsa0wbqqIFEXCXMRFayLK7Tkz
         QtgA==
X-Gm-Message-State: AC+VfDwOQttsi1IKzNfdNBHU/KX7SYTmVuDTp+gdW6Bv//53u9tcJgm+
        bFZf4v+kSMjlUONovldfOhKDvU+Gf4w=
X-Google-Smtp-Source: ACHHUZ5jlBs1POQKngX/PYCp0EblPlBRAXZfRu9mwOLPLiQpRYYQT7AMDcl6WhSgILliK29VWwZnYvu1U/o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:1994:0:b0:565:8b2e:b324 with SMTP id
 142-20020a811994000000b005658b2eb324mr7477940ywz.3.1686099297042; Tue, 06 Jun
 2023 17:54:57 -0700 (PDT)
Date:   Tue,  6 Jun 2023 17:54:07 -0700
In-Reply-To: <20230607001226.1398889-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230607001226.1398889-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <168609780581.1416323.11712101389299064130.b4-ty@google.com>
Subject: Re: [PATCH v3] KVM: selftests: Allow specify physical cpu list in
 demand paging test
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 06 Jun 2023 17:12:26 -0700, Sean Christopherson wrote:
> Mimic the dirty log test and allow the user to pin demand paging test
> tasks to physical CPUs.
> 
> Put the help message into a general helper as suggested by Sean.
> 
> 

Somewhat speculatively applied to kvm-x86 selftests, as I'm OOO later this week
and want to get this into linux-next before I go offline.  Holler if you don't
like the end result.

Thanks!

[1/1] KVM: selftests: Allow specify physical cpu list in demand paging test
      https://github.com/kvm-x86/linux/commit/d4ec586c60ab

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes

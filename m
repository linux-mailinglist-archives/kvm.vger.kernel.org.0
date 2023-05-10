Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF026FE32D
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 19:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236082AbjEJRXN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 13:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235006AbjEJRXL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 13:23:11 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88A35258
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 10:23:08 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-644d9bf05b7so3503582b3a.3
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 10:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683739388; x=1686331388;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+hAaVCKo1eByEZXhLUJu/Zdb96FUwCt8+VS8aKYztbs=;
        b=ztGvKBH/eztgMhM0RLd+O7UK4hn2rF/L45uOk92SBGXnpAEcUwIqLhIefWwCVWwTwc
         8pW52i1CXmr3euS5PHkF6V6Fk2FaDymVz7BYQpPJa5mvcP0XIstkwie36AqrzBuK1WlO
         /dt78RDyEBNDjju75aCH/51uHKGBYJ0pUzXuv909SrJLb+vr9ZxQkS+h4ktGx/ZtwqAg
         wzYxMPDIK1cN+0M5kGTzbFwwYezhQNW+oNnikz5aX229mT8/VjXaKVbojnwBRtsLqDtv
         O9f1whvhgGZNbQkKDZKgIaMmEFFM7jSrYQFuvyhQP2suqDcEdahUe5XEs5ecyubs3oOw
         8MBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683739388; x=1686331388;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+hAaVCKo1eByEZXhLUJu/Zdb96FUwCt8+VS8aKYztbs=;
        b=MH/auU/gczmZ2l26DgnHgdbBzvnI69/IHB29ueSrUWE1pwtBIvlbydzrWtiG6suLIC
         DRj4PTohEHtAH8YOZPNXLsgr434a7CL7J7XUKyIbXHrWEQo/Z59DZGLVc28l2NBVVXRr
         vc25gNP9GW1q95MLdN2auv+M130Zds3uq7Y2SRsESKIKSfQPvewschGo7ngMswFjQylI
         YBcmmmrMq/cUucivAEpVc3reOArTjTEDPhrIEGG17UugOG/H2T80OF13aBzq0A8unt7b
         qx5NzRysYWw6w6+L7j/Ij6KfuI6hjz161od77yrFj34f3keYZlI9SEHEbBXUFGXMxNo4
         CJjw==
X-Gm-Message-State: AC+VfDyCscWqbzFkz1owkDmhNR6joT9cfBHLQFNP3VkLOzroYisxCAw4
        g534OWwF7UlrC1TTTlBgso5K6vSuDhCdLdXWpbWQxQ==
X-Google-Smtp-Source: ACHHUZ5su4KURLaEkl/4yAdIgxwtjNl8aZ5TnfoE4jORvAYbsDhMn3lXw++ZvCljQBDkDUBhrusuFQ==
X-Received: by 2002:a05:6a21:168f:b0:ef:7d7b:433a with SMTP id np15-20020a056a21168f00b000ef7d7b433amr19655518pzb.47.1683739388289;
        Wed, 10 May 2023 10:23:08 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id s145-20020a632c97000000b0050bc4ca9024sm3429417pgs.65.2023.05.10.10.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 10:23:07 -0700 (PDT)
Date:   Wed, 10 May 2023 10:23:04 -0700
From:   David Matlack <dmatlack@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com
Subject: Re: [PATCH v2 5/6] KVM: x86: Keep a per-VM MTRR state
Message-ID: <ZFvS+AXATLVfB5vQ@google.com>
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
 <20230509135300.1855-1-yan.y.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509135300.1855-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 09, 2023 at 09:53:00PM +0800, Yan Zhao wrote:
> +void kvm_mtrr_init(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	if (vcpu->vcpu_id)
> +		return;

vcpu_id is provided by userspace so I don't think there's any guarantee
that a vCPU with vcpu_id == 0 exists.

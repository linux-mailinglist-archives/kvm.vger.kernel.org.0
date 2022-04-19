Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95334507272
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 18:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354274AbiDSQER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 12:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354210AbiDSQEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 12:04:12 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9463E329B9
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 09:01:28 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id n33-20020a17090a5aa400b001d28f5ee3f9so2307395pji.4
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 09:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yFkFjqpOiICUZKBBXqsv6xYMwtD9akgoqB/oPFVYH6s=;
        b=XUI8d/MUyS+Z6t573L3e0zuWKytIV2vZPTKhN/jpInIJdtPnyFpa3mkD2THyk7ulh+
         Kqkl8braNAE9j+cVqi7h+zsguIoHKpwdt1ulMzRFn9XAtlCXgEOceJ/X9P8kPhdyy6RS
         OVkWATHLx+hgWUtYYauSZ6X5JObL8xWSV6fUicas6A0xH3fX0hdPhsb3TMwEmzIgh/Gy
         I4vZggAjTylrVzA/eostCtJqoIKLdgQQ3CRHVlNXJeM70gzFnU/wRP+jUh75enA0xueE
         183IFLFuwju1wx0+xzjYChKiiozVGiLMpIX+hd8ZM54/iy97hS3wlE0UGmPbHw99186R
         82Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yFkFjqpOiICUZKBBXqsv6xYMwtD9akgoqB/oPFVYH6s=;
        b=DeJhnGPOReO7OW4u51PtKfMd4MmeZ4JrV/etP3vcMko9g+eX8b/0vs33S0gzkHKfCz
         qGfGpvdqJmfNA/oUbbJXjzzMNyhC3rM6iL6tnCqjYkP4EZoatmo/RYwch8QMWGnZUXPo
         TYRosgsVbJa4xe2ZFn9/SbCJqYpm5TYaPgkISsAQtDVAg7OLwehBc94RK7Ujz7uLg3IT
         p2KMCTZXjr7/rv7tcf1DhXcs7IoqTksQJ3ctjKY7CYdTpsQ4BMahyCXHNBuJL2b9z+Bu
         7Uqaq1KgpiOBYMDL7n3uD8mvrL02b95mD8YNLJF0mj5TTB+hpnWEu4lVyghT5aSnWL2o
         rx/g==
X-Gm-Message-State: AOAM53061XsGRf6RPaAW3Tzz7a5C2Flb7fkwFsxjUdidz717eF8WOGqt
        H1N38L9DFcPTsDqlpn8Um1Petdotdx/wRw==
X-Google-Smtp-Source: ABdhPJz7yUN7JdXLKZI7zWnZgfsDj/Q4UEhY0oOMe0d/DOdZqQMBqZRMVdNAYhpKxscDLCxPy8+FKA==
X-Received: by 2002:a17:90a:2983:b0:1cb:8d6e:e10b with SMTP id h3-20020a17090a298300b001cb8d6ee10bmr19430845pjd.208.1650384087908;
        Tue, 19 Apr 2022 09:01:27 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i6-20020a17090a718600b001d27a7d1715sm8704344pjk.21.2022.04.19.09.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 09:01:27 -0700 (PDT)
Date:   Tue, 19 Apr 2022 16:01:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Peter Gonda <pgonda@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the kvm tree
Message-ID: <Yl7c06VX5Pf4ZKsa@google.com>
References: <20220419153423.644c0fa1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419153423.644c0fa1@canb.auug.org.au>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 19, 2022, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the kvm tree, today's linux-next build (arm64 defconfig)
> failed like this:
> 
> arch/arm64/kvm/psci.c: In function 'kvm_prepare_system_event':
> arch/arm64/kvm/psci.c:184:32: error: 'struct <anonymous>' has no member named 'flags'
>   184 |         vcpu->run->system_event.flags = flags;
>       |                                ^
> 
> Caused by commit
> 
>   c24a950ec7d6 ("KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES")
> 
> In this commit, the uapi structure changes do not match the documentation
> changes :-(  Does it matter that the ABI may be changed by this commit
> (depending on the alignment of the structure members)?

Yeah, it's a bit of mess.  I believe we have a way out, waiting on Paolo to weigh in.

https://lore.kernel.org/all/YlisiF4BU6Uxe+iU@google.com

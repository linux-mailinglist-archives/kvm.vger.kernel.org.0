Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C914E788CDF
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 17:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240880AbjHYP7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 11:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244307AbjHYP6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 11:58:39 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC582685
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 08:58:36 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-c8f360a07a2so1263515276.2
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 08:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692979116; x=1693583916;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=n9OoCnMu5ggn9ls0qYy10cPYlblntSxvFSs/ugRa5x0=;
        b=UpPobNiK6GZBSsEfCqQ0ai2dVcmgd0u4n48/qFsCCR5MLCFfecBdFqfXiH7EH3FhTS
         IGgJnrLX5HZkcRwcf1aHvAMnhUQT32TUPxcK3UkccosXMr76DTeUzzHDdnSiGbpXr5eH
         7fRImDD7iiek6uDBXsvm7ppwLWEA/jfQgpDResE6gGP536RI4EfqbxOx8cMRm4DYFLAu
         /2Y5Nv7iwkrjVDXbJKoML7sstrsAn0Ke4/OeX6o73zSDzO1e0uVmmoqndqoFgxLqq5Hf
         Q6KXCeQoOvHpAEMLoKgHKkxaa08EwWNcgkOyRXwc5mWAdQuTZ20dGEYCciiHIYg05ijV
         lWpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692979116; x=1693583916;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n9OoCnMu5ggn9ls0qYy10cPYlblntSxvFSs/ugRa5x0=;
        b=iCLOBMwQ5X8J4T9vBOV8qjdTKsxTbo3lQpxyQpT9/0uz/N72aZJBikgmvugzjZgpaj
         h7WD3yoAgIrgkYFG/ma4AgV5nwW/S3arJM1Yjm2H4uXwuAs0c7ANeCNHyC0OZOJZwZNx
         lH1ZXnUmaHj84aH2tHQXhB3WweVQAoHpbj5pmPwOiJCMJ0mtxTrB7F/O/pxFPk+3sb02
         UyFLAQOPdUdNeR7MGmVwThyvWn0haC81HCJG3nV8Ic/1vO4ZUmyU4DNY/mjFhf+i/b1p
         g3P+8vsC3UXn2Ydtifn7oMQ7PeNfT8dbFO4kXfQjntGqw3TepbrlT7NZkhnjpzwOgWer
         XHpw==
X-Gm-Message-State: AOJu0Yyx8LP1EkCCuqZGX9F5d2PHtHv3X+hT1/Kk69UrD53H2OlF5Kod
        ZMEsOK4GunYQ+hINQgA0ROgweHEAzsU=
X-Google-Smtp-Source: AGHT+IG3Lo+auwpH673RK736RHVhxUVht74h+63VIXkKwVAjdbIbXl5h5PENZT8JZpZZVT8KBfUSH2N/EkE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:a2cc:0:b0:d13:856b:c10a with SMTP id
 c12-20020a25a2cc000000b00d13856bc10amr465337ybn.3.1692979115872; Fri, 25 Aug
 2023 08:58:35 -0700 (PDT)
Date:   Fri, 25 Aug 2023 08:58:34 -0700
In-Reply-To: <99289fd4-0a1e-3c05-8934-732ef7815942@linux.ibm.com>
Mime-Version: 1.0
References: <20230824124522.75408-1-frankja@linux.ibm.com> <99289fd4-0a1e-3c05-8934-732ef7815942@linux.ibm.com>
Message-ID: <ZOjPqhpejWWJrEgE@google.com>
Subject: Re: [GIT PULL 00/22] KVM: s390: Changes for 6.6
From:   Sean Christopherson <seanjc@google.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com, Ilya Leoshkevich <iii@linux.ibm.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 25, 2023, Janosch Frank wrote:
> On 8/24/23 14:43, Janosch Frank wrote:
> > Hello Paolo,
> > 
> > please pull the following changes for 6.6.
> > 
> 
> @Paolo:
> Seems like neither Claudio (who picked the selftest) nor I had a closer look
> into the x86 selftest changes and Nina just informed me that this might lead
> to problems.
> 
> Please hold back on this pull request, I'll send a new one on Monday where
> we'll pull in the selftest changes and have a fixed up version of the
> selftest. I've spoken to Ilya privately and he's ok with Claudio fixing this
> up.

If you haven't already done a merge, I pushed

  https://github.com/kvm-x86/linux.git tags/kvm-x86-selftests-immutable-6.6

to guarantee a stable point (I have a few last minute selftests fixes for 6.6
that I'm planning on applying "soon").

Thanks for dealing with the conflicts, let me know if you run into any problems.

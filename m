Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE8E651013
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 17:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbiLSQP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 11:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbiLSQO4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 11:14:56 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3A113D49
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 08:14:39 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id u5so9549799pjy.5
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 08:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5dL/5e66Q421m8/scPuFx+mndERQbshrnwDDg3EMSsc=;
        b=qR+VevN661+iIuH02xO+YfS45M/ZR1cMO1J/nhGa4mYsarAqugAWZG0qrD9QBtNOqq
         bgY55YbQrxbEodLAWCRxjZ30qiz20kG2kkiyqLGZiq4y+APUg8E7MO6Hj95aTsqIPGq5
         23+V/eLiiE6BUDMXkf4hGBHJ0OKt1CTHWIy1v+s5SYaOHRL7Zp382cc7tiKdmgTrGMGN
         vBvJ704/VmBjE0Q5uP1wKCoKsT3d56s8AqLGjc1+MtYpEaebR3g/OcBBORdjU/4zg68l
         H+A0Jcyw8ZnHeQhVVFU5KMKc+DS4DpewNIt15/TmFdvVK5XxMkX/PNZqEk/65c7dE94O
         Kxzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5dL/5e66Q421m8/scPuFx+mndERQbshrnwDDg3EMSsc=;
        b=tYIAHIRVsnPiYZEp/e2i9QUHUgAEWsiy9yb2X9lVBgW9YtD3tcPFYj6sdDWWQ4NLcK
         H2BiNQTaDqBfTttH0UCWfQQFvd7WPir/vkAlNMo8X9N+qmUpqW0uq72mkcOtbJN4IfUv
         VUWZ9Tk3UJEb8H/ao+KipaGqEy4fVcCiz3ms5fsIRiSfgAihtBpJ1qycOdt9bSSCBdIO
         3LXd4Da/XMeBjCDaIZ4FOnsNl0qFS2uqT7T+rGk7s1LX0VN6Q6c3sk6XZ/jZ3R+jFoEr
         HEvbPpXd6jGXFP08Xax+mymQg0WoJdCDaGnv+GzEb/awLEY61ILy/C9A9IuHXn8NtgS9
         qXnA==
X-Gm-Message-State: AFqh2koryYHbAgJhRaYWgVGCgA7E5wbbWDOtP6FNr34f70h4VYGsz3ee
        gKmlk3VkCUIYD/oAh/Z+LQqXTQ==
X-Google-Smtp-Source: AMrXdXvmp3Jyv+LOxgrryADAvlI8P5f1UyM6BBcn0v37B0TGn7ATjOYxPhmskeOx8cTau2VjzR025A==
X-Received: by 2002:a17:90a:e28d:b0:218:84a0:65eb with SMTP id d13-20020a17090ae28d00b0021884a065ebmr1217698pjz.1.1671466478651;
        Mon, 19 Dec 2022 08:14:38 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id pw6-20020a17090b278600b00213c7cf21c0sm6113969pjb.5.2022.12.19.08.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 08:14:38 -0800 (PST)
Date:   Mon, 19 Dec 2022 16:14:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Install sanitised kernel headers before
 compilation
Message-ID: <Y6CN6kWo+KPD5wOi@google.com>
References: <20221219095540.52208-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219095540.52208-1-likexu@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 19, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> On many automated test boxes, selftests in a completely clean src tree
> will be compiled independently: "make -j -C tools/testing/selftests/kvm".
> Sometimes the compilation will fail and produce a false positive just
> due to missing kernel headers (or others hidden behind the complete
> kernel compilation or installation).
> 
> Optimize this situation by explicitly adding the installation of sanitised
> kernel headers before compilation to the Makefile.
> 
> Reported-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  tools/testing/selftests/kvm/Makefile | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 947676983da1..a33e2f72d745 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -202,6 +202,11 @@ TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(UNAME_M))
>  LIBKVM += $(LIBKVM_$(UNAME_M))
>  
>  INSTALL_HDR_PATH = $(top_srcdir)/usr
> +
> +ifeq ($(shell make -j -C ../../../.. headers_install),)
> +	$(error "Please install sanitised kernel headers manually.")
> +endif

Auto-installation of headers was recently removed[*], presumably whatever problem
existed with KSFT_KHDR_INSTALL also exists with this approach.

FWIW, I also find the need to manually do headers_install annoying, but it's easy
to workaround via bash aliases.

[*] https://lore.kernel.org/lkml/cover.1657296695.git.guillaume.tucker@collabora.com

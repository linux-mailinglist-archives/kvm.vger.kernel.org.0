Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B536C54FBDB
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 19:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235898AbiFQRFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 13:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiFQRFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 13:05:47 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A377F20F49
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 10:05:46 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id y17so3364468ilj.11
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 10:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4H2OpO4Kq2nG0nxCJ9datcKzR+qnlWf0xbhrv9fe1rg=;
        b=TAW7FS7zVXqHvHquvWRUQSMyzmPJ7tVyu2hHHYvaoGtbMpC3bvIPJXHUxS9qNhnINm
         wSXH9O+r0cwO6KhCpDEx338Kah83pU5a3zDo9kRz9MGy4ghVVUq07fZhEOaB+H7/tBHE
         pxfoQYK9cyLp6rM03k/p676mk+vzD2+ivKwtSld2NPfIB6UgCvYUtGuDYBsbMkS6+gTo
         D3qN/kHn4K+B3p5f5lVhB+VC3WhGti/2TGpGL07sdlUYqoZhZKx5dnzs4GMQZwV8aWv/
         meOmImm6DM4nFffycP2bPx/OQn62KZQZu5a44W3Jcg2odtaG57Nqkn2XuXXAmXbf04uE
         +SNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4H2OpO4Kq2nG0nxCJ9datcKzR+qnlWf0xbhrv9fe1rg=;
        b=jAQmb2vs41D0IdqYWPgIrBoQzZB/65Y1J0W7qWiEzq0ilUVANtGz14WuHy+qYpCOnc
         aiYTGwfx7jT4s/ZZfEfW9iYSIZJYkYtRM6p5WfCxBqpdLcTfklnq8uXPeE7U6nG9WBoS
         3iDPqSOREyJiHD+j7wHnOWnNBT6a8AP9yPdn6PXiKjAAGH9BgSywxMXhyWo87VjQbVZi
         5uJ2z03XN37lRZd5LNWRT+AJjbxjN6zJkgSo85WDUEmUNTNW02BYopUM8A9wMpAXlXno
         ncl7fSIfyDBi/CINAb5McT5VZq2h0/RFylUt/XCuJgCiUy4sWTw52ATZOlifglxhDX6n
         aaEw==
X-Gm-Message-State: AJIora+kZ1Soa0k2g133BENOL/AIkhocUNuUg2Q1Qir6pfFef58s1dXN
        fOWOj2k9PDUMk3YfIeAWFvtCDQ==
X-Google-Smtp-Source: AGRyM1v7haoW1qtEvfc6oB7VBdPNkjITEbnsE7OeCDQzUUJ+pWxoufWWLAR+Wwwpo1c+rmP0BujHbQ==
X-Received: by 2002:a92:d309:0:b0:2d8:e639:4e02 with SMTP id x9-20020a92d309000000b002d8e6394e02mr1742450ila.313.1655485545817;
        Fri, 17 Jun 2022 10:05:45 -0700 (PDT)
Received: from google.com (110.41.72.34.bc.googleusercontent.com. [34.72.41.110])
        by smtp.gmail.com with ESMTPSA id p4-20020a927404000000b002d1d8de99e7sm511812ilc.40.2022.06.17.10.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 10:05:45 -0700 (PDT)
Date:   Fri, 17 Jun 2022 17:05:42 +0000
From:   Colton Lewis <coltonlewis@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        thuth@redhat.com, maz@kernel.org
Subject: Re: [PATCH 2/4] KVM: selftests: Increase UCALL_MAX_ARGS to 7
Message-ID: <Yqy0ZhmF8NF4Jzpe@google.com>
References: <20220615193116.806312-1-coltonlewis@google.com>
 <20220615193116.806312-3-coltonlewis@google.com>
 <20220616121006.ch6x7du6ycevjo5m@gator>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616121006.ch6x7du6ycevjo5m@gator>
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

On Thu, Jun 16, 2022 at 02:10:06PM +0200, Andrew Jones wrote:
> We probably want to ensure all architectures are good with this. afaict,
> riscv only expects 6 args and uses UCALL_MAX_ARGS to cap the ucall inputs,
> for example.

All architectures use UCALL_MAX_ARGS for that. Are you saying there
might be limitations beyond the value of the macro? If so, who should
verify whether this is ok?

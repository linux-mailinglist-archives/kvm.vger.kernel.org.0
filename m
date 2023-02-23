Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C30D6A11B6
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 22:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjBWVLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 16:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjBWVLt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 16:11:49 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871DC5BBAD;
        Thu, 23 Feb 2023 13:11:31 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id r27so13311791lfe.10;
        Thu, 23 Feb 2023 13:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0U2GzDndiF3iYNKQDD320xsKS6V4XAkNkl7HZbDIbmI=;
        b=J/+UbcT6kH/Vb+mPkMVyZu8WHYBxOhPxkfICEnUvIUv7P5rtvhdIzsU8ZZROntQPkS
         roTR12RZLvL4lJL2qvnSfIMZ3zuV8HmnrfRkjaY1CPtAqEZ/wqGmPT1dH0gKIR24Guom
         9x+JsvOVBqgf2M/vt9pi72bKChnIZo3csMOi1OQ4axtTjNSuBQq2fJzjarn5KggOrj8b
         33ilEtaFae5At9H+K30OEh2ifxen4qfEVx+QEgFLJM8guNAAXtddM8hOwmkDiimr77MK
         vbAoeOJ5dBDo8DqEYavk0bLJn4Y999WX807p6FSpr2PwX1zowiDEVbhMTs4IRHPIzY/z
         pMcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0U2GzDndiF3iYNKQDD320xsKS6V4XAkNkl7HZbDIbmI=;
        b=BqX9yLFYk3I90gmsgRbq4Gyd1/w9nsUnlBSq0RzeZXfMA3R7M6xgQZKrW2UhxamQH7
         s2mXQhi+R4HArfPeTbe3WQ0od0pRuegq96tqBwOFWjthoodWGM/u8vP7C8Xajfb1hDm1
         zB2VMNhDkfTBwKF2OQ+CWpUM3tSL9LTpQA9J4tcsUp0JQAN4X0lXGnlrSczLvBlRhxOK
         GGYkcw17ZPNcS3JOOuwIclgK1YjyoBwtMbODYS01lbOPCg/GuA6paEKBMGNG+dSmsNhp
         JjQ2qiswGAOz/qksPqi7NeQpWmSMkX+uDCDfptipnd3dB7iXBVrvnmqaR+wres3bkBza
         +H6Q==
X-Gm-Message-State: AO0yUKVK2gbcQ5HPLVTJCITtBktQrx7cCxMm4PC+DojisLi+HS6ZcGRr
        +bFLY/rugCifql+sx8omMcCsz1eWVkc=
X-Google-Smtp-Source: AK7set+W1suMQajDeHsDE8227LaASmLJP9ic6cw5A+Zjgkr2Zvs85Ts0qHNqupXLYocTmg7+nDmgeQ==
X-Received: by 2002:ac2:46ec:0:b0:4dc:807a:d137 with SMTP id q12-20020ac246ec000000b004dc807ad137mr4546615lfo.4.1677186689679;
        Thu, 23 Feb 2023 13:11:29 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id x23-20020ac24897000000b004b564e1a4e0sm663550lfc.76.2023.02.23.13.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 13:11:29 -0800 (PST)
Date:   Thu, 23 Feb 2023 23:11:27 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2] KVM: SVM: hyper-v: placate modpost section mismatch
 error
Message-ID: <20230223231127.000045e2@gmail.com>
In-Reply-To: <27364a82-fa60-1454-e25d-15239905baf3@redhat.com>
References: <20230222162511.7964-1-rdunlap@infradead.org>
        <Y/ZG8u6/aUtpsVDa@google.com>
        <27364a82-fa60-1454-e25d-15239905baf3@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 22 Feb 2023 19:32:53 +0100
Paolo Bonzini <pbonzini@redhat.com> wrote:

Maybe we can use __always_inline? I just noticed this thread today by chance.

https://lore.kernel.org/all/20210624095147.880513802@infradead.org/

> On 2/22/23 17:46, Sean Christopherson wrote:
> >    Tag svm_hv_hardware_setup() with __init to fix a modpost warning as the
> >    non-stub implementation accesses __initdata (svm_x86_ops), i.e. would
> >    generate a use-after-free if svm_hv_hardware_setup() were actually invoked
> >    post-init.  The helper is only called from svm_hardware_setup(), which is
> >    also __init, i.e. other than the modpost warning, lack of __init is benign.
> 
> Done.  It's caused by the compiler deciding not to inline the function, 
> probably.
> 
> Also Cc'ed stable.
> 
> Paolo
> 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E96961067F
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 01:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235617AbiJ0Xp0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 19:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234966AbiJ0XpZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 19:45:25 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5A847B9B
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 16:45:23 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id f193so3308632pgc.0
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 16:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zzzRUOnynCIGIBnzFfZ6YQXNoXMYKqSRMGRqT+ANxec=;
        b=iaErYXx173nvycrpKUE1ZoExMJZVhiLagTJ5auyCekmtU4zcNO7ulDFu9VnJLt/Qno
         nh97gAYxBmvDNQ57EiywfhV/9x0UNVwVu8y+cVTnBMzyDFHhjP8uhS7QTNO7iH8uBpbG
         6cFUuYigYiOBjL4hr/dY+l15DzF3BtnSAoLfQGMGDFFFWto0k8rTZFenSKYAHgTCQG2F
         HlBl62ZG6bEP0oqelHt26XNSMVJi9f3zVnTtGNtNAqC3qCgj6wmQtAjDyF34P2Srl/Z3
         PijEDC1hhG3gSsgX01ZIMpN8G0rMKw0Gng4IrB8aBNZQ7D/wIvn9nCzQWXkr0sgRTmp4
         SqIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zzzRUOnynCIGIBnzFfZ6YQXNoXMYKqSRMGRqT+ANxec=;
        b=2CpVN8zdvYH3Rih4XTE48DuvRuefMy24xcqBr4NNc585nKmBA6F3x+8XgRKoQKVdc+
         6Nc5ggvSuCj0DZTWLkr59LJLAaUcgUpFcaGD85VgVkNr8EhZeHUsakcpOebOpLHOcRh6
         fpK8aW2phDgxEg6X7zId+nvTruxieKAfPEDgt1oq8iPiX9sSjZEfmHoGKKk70fbqM8KR
         NHIffjP6yMt2pLWsA8GWR65Vf4nHDnXgvbi16tBMqEDdFmy/u2q5mxjkb17hN8ozobl7
         xYhwQo1gI7YpkpSzSiQprHaNSjuBDGVv5GpDs+SnY3E56tV75FENbn678eWOf9dN+Guo
         ZItQ==
X-Gm-Message-State: ACrzQf2QG1jUZIOItmZ8TUC6YokY/7w2J0xUQM7WKSrPM3gnmCtMUPm3
        LzzYjs6JTfssfmiuGZd8WEvWBA==
X-Google-Smtp-Source: AMsMyM6KRQEyGoNAwVrM38RVZGrplUVWFNPUJzf2b4UeEfwdTxUs8R/gOF3HTNTkOpPtq3E1Ivvqqw==
X-Received: by 2002:a05:6a00:124e:b0:565:ba3c:58bf with SMTP id u14-20020a056a00124e00b00565ba3c58bfmr51848513pfi.82.1666914323244;
        Thu, 27 Oct 2022 16:45:23 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id v30-20020aa799de000000b0056bb191f176sm1745165pfi.14.2022.10.27.16.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 16:45:22 -0700 (PDT)
Date:   Thu, 27 Oct 2022 23:45:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 5/8] KVM: x86/mmu: Use BIT{,_ULL}() for PFERR masks
Message-ID: <Y1sYDz5yLpRzj+EA@google.com>
References: <20221018214612.3445074-1-dmatlack@google.com>
 <20221018214612.3445074-6-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018214612.3445074-6-dmatlack@google.com>
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

On Tue, Oct 18, 2022, David Matlack wrote:
> Use the preferred BIT() and BIT_ULL() to construct the PFERR masks
> rather than open-coding the bit shifting.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

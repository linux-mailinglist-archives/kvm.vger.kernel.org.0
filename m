Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1618060EBDC
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 00:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbiJZWvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 18:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbiJZWvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 18:51:10 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F6C6C74F
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 15:51:08 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id i3so16966942pfc.11
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 15:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nx9X2AqXx9kL9mqmehn81a2HA6pr+SJoh7OoN2qbwyg=;
        b=nTy1bgcyfdBnKCEA1LTRIjdKcEPy77U2IWejK1U4ZU8Mwb3Wif+sWjP7DCYH3DEsqc
         92vqfo7DKXhusqba9tOHKyHhBMByqRefuKOmhO4wW+3IT2VjeetQqsvshPZL4XKNhz3t
         tvLLK0Um2V8i0V4Xf0wPtynXDJ537WODNoSgOl4mw2TnGarMtVWL/4pSAxmFMCzzkoGw
         4K036WnrhymXaCoJMPNjtp4+3IHjSDw0k8TVKA1W5zfbgx914pUwJIhN+lbr7VLugXVZ
         k2WmuFUKsQlcItNkjvoEMXu4GF98OZxVE4cTUovqyAS7R7r60SnEBF4m8MG1GVGTAz89
         BY0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nx9X2AqXx9kL9mqmehn81a2HA6pr+SJoh7OoN2qbwyg=;
        b=yDd1C47ObxjsfkQ6XTWJgQLUPBOsFouuSJy+B+xlDQuR61Gqz4gULTXwwqurN0qE6n
         ZmasNgEq04qVhIubyF+upS7lrJtAhYW96VOnDa2PUvR8ovkfYYf8J85niqAXmf2PKik/
         El3tOLPtGVcG1bRKQiomRHBCiM0ibh9ZPlNjN4KOYaSw3Q6yrOCbDc6HkCcxzah4IYsn
         3+oYPkW5yRg5MExOxIiTSX8v7wPpUY+t1ttMveZeQ4TZBLMDR9JQr2Lu/MNg8ZPDulXW
         setniRBZohIL+FAKJJHrKlLc7kn3qvJ9Ri9Ors2Nr8kkHJgGEO8YieZInBGuuWC64neB
         MApg==
X-Gm-Message-State: ACrzQf3adttIbtP4ou14dk3CAuHeAJe3YCVy7Vn0TJ7C0cfoPDOGaLyf
        qe3mTu1dVNgt3h6BDvSMa5bsGQ==
X-Google-Smtp-Source: AMsMyM5uDq5gVub7K6AXTfD48w2JCLbepkn5cs6Jmiy268Ba9Ircho3cVoNYIgMVXu023dtlOil2+w==
X-Received: by 2002:a63:de0e:0:b0:46f:23c6:e7d9 with SMTP id f14-20020a63de0e000000b0046f23c6e7d9mr12115216pgg.68.1666824668124;
        Wed, 26 Oct 2022 15:51:08 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b7-20020a170903228700b00178b06fea7asm3409669plh.148.2022.10.26.15.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 15:51:07 -0700 (PDT)
Date:   Wed, 26 Oct 2022 22:51:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v4 4/4] kvm: x86: Allow to respond to generic signals
 during slow PF
Message-ID: <Y1m52MUZm9m3s17K@google.com>
References: <20221011195809.557016-1-peterx@redhat.com>
 <20221011195947.557281-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011195947.557281-1-peterx@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"KVM: x86/mmu:" for the shortlog.

On Tue, Oct 11, 2022, Peter Xu wrote:
> Enable x86 slow page faults to be able to respond to non-fatal signals,
> returning -EINTR properly when it happens.

Probably worth adding:

  Opportunistically rename kvm_handle_bad_page() to kvm_handle_error_pfn()
  as an error pfn doesn't necessarily mean the page is "bad".

> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

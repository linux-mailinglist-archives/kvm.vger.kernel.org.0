Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 759BD6D9D3F
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 18:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239913AbjDFQKC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 12:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239910AbjDFQJ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 12:09:59 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97D79ED7
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 09:09:56 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-545dd1a1e31so345152197b3.22
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 09:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680797396;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FRMRkG2g/9liuKyR9/FweFwBQfdTNklXoYWd9JmqE/k=;
        b=jmx73uJLJfJdsu94t6oO0LOG8hzvfWyAKQUaoGyp1hbrsS5ZfOMX2Imh6Nh3ckLs+z
         /RSMXU/SFpevBaBtuhnTm9mY4FWJaSugUsuQO6+a193l5dBerM4ZPhiwSDuIy08K2erX
         2HC+n1HaXaoIacJPe5BQvID27EyOWCiwmAhxqkaUozvbEW37iVop7+YlVk1qpK4Bvy/E
         i7Q4E0qi5LxpI1Zyo+XzihI4nOZ7scJ6LJ7s0GgDEywxJXGiGzPMAPIh2ks1HaLqy7T5
         yD/BpuGknDrGD5l4oaL3bJEID+/kDZBEFLwNHItzQ2t10SibA7JgFZDmLI4hMdd6EL6j
         BJ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680797396;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FRMRkG2g/9liuKyR9/FweFwBQfdTNklXoYWd9JmqE/k=;
        b=vNHiKHuyUueNZW3bID+N/J1ucjgkdo4rOpIypyvb5ALPTvNoz/cwhtO76VPDwK8CpA
         Jdcu2mCsQoWEFUKziIgkkX48cmmOaJoonoIwDD8zKdvx3OY9G85bNjow9LD8mpfq4aIG
         aUta2W4be/iRqeH7OC7in6oIq5aWnlOmdlojrbZy8mCLl2bHden8GQYSPzEkdExQ2B/o
         kIPQovhNPzV+TDgbbuiTeZpQ8JoS87WzjHJR3vfi6V3RvTZMI/FFJzjSBs6xIRP434aJ
         0cmxgfbYbuJ2vzaZDP34/+/hyT54H4gEdSgKtK4I+tb7vmLy3GOe7TOUgGY3z0AOqi/3
         1MTA==
X-Gm-Message-State: AAQBX9eD73L1r9dsRZuN2dbMxFum6Ka52L1wE5VJKVvCll3kdTaNQVJt
        OP8gSgLkjpto1RF/oktMhBZKcjLc0hw=
X-Google-Smtp-Source: AKy350ZB8l/LJrmkRI8Hwj6Yt/N72KPpNWXOcuCCCaCnOvdjHf0Ba2PQNa3ccjltCgHcoUSZygW8cIv7kLc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:da4f:0:b0:b8b:f8b1:1c80 with SMTP id
 n76-20020a25da4f000000b00b8bf8b11c80mr1511700ybf.7.1680797396114; Thu, 06 Apr
 2023 09:09:56 -0700 (PDT)
Date:   Thu, 6 Apr 2023 09:09:54 -0700
In-Reply-To: <9896a0bf26e48dab853049f40733df5bb0e287a1.camel@intel.com>
Mime-Version: 1.0
References: <20230319082225.14302-1-binbin.wu@linux.intel.com> <9896a0bf26e48dab853049f40733df5bb0e287a1.camel@intel.com>
Message-ID: <ZC7sQLdYpweORB6o@google.com>
Subject: Re: [PATCH v2 0/4] x86: Add test cases for LAM
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 06, 2023, Huang, Kai wrote:
> On Sun, 2023-03-19 at 16:22 +0800, Binbin Wu wrote:
> > Intel Linear-address masking (LAM) [1], modifies the checking that is applied to
> > *64-bit* linear addresses, allowing software to use of the untranslated address
> > bits for metadata.
> > 
> > The patch series add test cases for LAM:
> > 
> 
> I think you should just merge this series to the patchset which enables LAM
> feature?

No, please keep them separate.  A lore link in the KUT series is more than
sufficient, and even that isn't really necesary.  b4 and other tooling get
confused by series that contain patches for two (or more) different repositories,
i.e. posting everything in one bundle makes my life harder, not easier.

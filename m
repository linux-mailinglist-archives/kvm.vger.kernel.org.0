Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24BAA5B8F06
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 20:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiINSri (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 14:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiINSrh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 14:47:37 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0B67C33F
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 11:47:36 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-127d10b4f19so43412524fac.9
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 11:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=0Ek/HRaf972gvU9RwzNQRGnbBssP9QSR+5S7SeziE9Y=;
        b=azlBjnjfhXwEr+xe43qSB1ph/i95fOfOdFBQof+FlC/RsZ/NRUSW5pRJXDVAtvfLE8
         JmacJZHvDZGA35fiesHpGswkgSL/kpFpli3zarN8vDshO8ylHXs6S1FZ9k7pSN2TWfYR
         Fbwkt7WyfSXz4Qi8APs1VEN9WuMTTowfIkgn/f0LG0W8d+roD4OQigwb3YaSRIucq4wM
         K/1V1ih5vo+9H8wUpTADu1PXBZ6G0KCHKMgdq44yv7xJxFSZMQMuiOHKIyI6rCY5kkaV
         tB0Fq3kBZsRZFcqGjkGw0swQKCGHA2857tqLDXr9NPTLTFUOvwkFZyU48rz1P6S97JSu
         L9/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=0Ek/HRaf972gvU9RwzNQRGnbBssP9QSR+5S7SeziE9Y=;
        b=vnpMTkhWVKJFvEJRajaG1Rewed7tLMmUZbuHvHBywWSg1wB4ZUg25EtK7Z6E7BcsKi
         o44ZklpOEoWNvXFbAsOhhEevn6EbrdvvLiZmtty7LwchXRbiCFwABJbqMctEEtZdWbeI
         WEOdES+fCkESU6qTtIbudgnKDaH8AYlM8Of+a4/HErP6RnqNjn0/4adaI5QYs9dcT9mr
         ug78Z/vmhEEJdDRJ88OprUc2gD5Bx0P4uQjJvBH/vgljD5aAw4k3MymNwpkU4bYjchUv
         s7Hl1i6L/gn9VRBoyRZ6oWVyElIBDJCekrp3bfFb4HfUFcgqRFHz9nkkoDZy4o00Soqw
         I8rw==
X-Gm-Message-State: ACgBeo3ma251Hez1IbeuGjKw8HOmdv3+MWzQqVxjUczvg8E3dOfV4fmS
        4Lv94vbTsE+K+GJ4v+PuaQtyTDJkJK8zM8OE62AloQ==
X-Google-Smtp-Source: AA6agR5cQaDNSZOMbGjCEXMwHaNcoyDTxJAdMtmYUXVqdTeoOuZtCFJ2yVfXmh1LyjSKtTEVQLGhvLCPxrgiGgfEAjQ=
X-Received: by 2002:a05:6870:a78e:b0:12b:542b:e5b2 with SMTP id
 x14-20020a056870a78e00b0012b542be5b2mr3151455oao.112.1663181256015; Wed, 14
 Sep 2022 11:47:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220831162124.947028-1-aaronlewis@google.com> <20220831162124.947028-6-aaronlewis@google.com>
In-Reply-To: <20220831162124.947028-6-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 14 Sep 2022 11:47:25 -0700
Message-ID: <CALMp9eTuCj=EFFM2mkMh03dSDjy42DSCZjiR6Sx1osFJm0aQOA@mail.gmail.com>
Subject: Re: [PATCH v4 5/7] selftests: kvm/x86: Add flags when creating a pmu
 event filter
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Aug 31, 2022 at 9:21 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> Now that the flags field can be non-zero, pass it in when creating a
> pmu event filter.
>
> This is needed in preparation for testing masked events.
>
> No functional change intended.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>

I'm not sure this warrants a separate commit, but okay.

Reviewed-by: Jim Mattson <jmattson@google.com>

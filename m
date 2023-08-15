Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1E7177C7C1
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 08:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbjHOGYS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 02:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235142AbjHOGX3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 02:23:29 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4336D2
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 23:23:27 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-9923833737eso675119466b.3
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 23:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1692080606; x=1692685406;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ihpcpC9x0qrHU5Z9SjDeYCC8o63Nz0ytctzqE2AosKk=;
        b=Y7rNM45V9oIHBQtBhk3Lo3gEk8eo0A4MmW+hU/dfDm36rx5n0EBcungGfvrHQ5ShKV
         dRYXaFbdHstABKjFMyi+Aeu8PgR+h4DnFygQqHTplAkBl4LCi5i0XIqp8b4R38vehn9H
         h1QJLi5gAw/Zby83jNwenjOtYO7c7IKPmRWht6T4Mrz+kixlRzsQ4tJX4hxATDWsy0yX
         osu06PF0mbGZrtOEwysEP5cCUs4a+dFbVyAAGu15lf5IlqK4ZqXKN9paSkTADvpTjrlv
         dmqf0CXmQ3uJ4+trZ3p6AVFML5TsqW5iaPX8yT5kr0ahmz3/xRtcs9959NMwlv3et1zx
         9AYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692080606; x=1692685406;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ihpcpC9x0qrHU5Z9SjDeYCC8o63Nz0ytctzqE2AosKk=;
        b=JZDoNuT4o/T9uHfZlB5KtW63xhlZ/vOqcavdg8xtWZDTE48L5xwaKF1sJlJN5cPjJf
         igceAkGXbK8KJkFJdoKrTCYwdCe5pHLeJjlKMubKAgKQw9HPYWUpGMj6hgJdgRoVyXeJ
         4gKn9b13y2/4VqIiLjGQZPQNVdOIGkiUZA62QbdznT+5UnnqYoTe3IHcbnN6jXu0ncu1
         xNr4kBtF/OHYrDfNkyVZltkLU/NsFn91lgwdYPzL58uuXMdrm/PX+Nao2xwN2x72ld0d
         CLL4zBOTNiQFb42Nuhka5DZiscRgSFeov3sj4dU5t6e+JvQxeZud6JQzUE1iOl1Bq+s0
         KO4g==
X-Gm-Message-State: AOJu0YybSpSDA6RPOrcHkbrGlIoj4O4QhyOKebi+v5CCkc/1Y5so81lE
        BnQ5s0toMGNgQm4W6AQQSXA1zw==
X-Google-Smtp-Source: AGHT+IF0FmSGWKxGB1J6k0FmQ7BK2/l/KB/mKdA5jpRuYdg2YkPeddgc0p9v/xiReToBR8pEXtJZKQ==
X-Received: by 2002:a17:906:31c7:b0:989:34a0:45b0 with SMTP id f7-20020a17090631c700b0098934a045b0mr11331777ejf.49.1692080606113;
        Mon, 14 Aug 2023 23:23:26 -0700 (PDT)
Received: from ?IPV6:2003:f6:af04:8000:fc77:9a50:624c:93ed? (p200300f6af048000fc779a50624c93ed.dip0.t-ipconnect.de. [2003:f6:af04:8000:fc77:9a50:624c:93ed])
        by smtp.gmail.com with ESMTPSA id d3-20020a1709063ec300b0099bcb44493fsm6642437ejj.147.2023.08.14.23.23.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 23:23:25 -0700 (PDT)
Message-ID: <105d31d9-7e3d-c78d-6878-37d50376f6f5@grsecurity.net>
Date:   Tue, 15 Aug 2023 08:23:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [kvm-unit-tests GIT PULL] x86: Fixes, cleanups and new testscases
Content-Language: en-US, de-DE
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20230622211440.2595272-1-seanjc@google.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <20230622211440.2595272-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22.06.23 23:14, Sean Christopherson wrote:
> Please pull a variety of (mostly) x86 changes.  There's one non-x86 change to
> fix a bug in processing "check" entries in unittests.cfg files.  The majority
> of the x86 changes revolve around nSVM, PMU, and emulator tests.
> 
> The following changes since commit 02d8befe99f8205d4caea402d8b0800354255681:
> 
>   pretty_print_stacks: modify relative path calculation (2023-04-20 10:26:06 +0200)
> 
> are available in the Git repository at:
> 
>   https://github.com/kvm-x86/kvm-unit-tests.git tags/kvm-x86-2023.06.22
> 
> for you to fetch changes up to e3a9b2f5490e854dfcccdde4bcc712fe928b02b4:
> 
>   x86/emulator64: Test non-canonical memory access exceptions (2023-06-12 11:06:19 -0700)
> 
> ----------------------------------------------------------------
> [...]

Ping! What happened to this one? Doesn't seem to be merged for over a
month now.

Thanks,
Mathias

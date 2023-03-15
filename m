Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A96F6BBDB2
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 20:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbjCOT53 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 15:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbjCOT50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 15:57:26 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52FBF14992
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 12:57:25 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n203-20020a25dad4000000b0091231592671so21326510ybf.1
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 12:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678910244;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t0VuZOXGCp21EgyUi4sXnOhOFTS9jJF8Mnh7KUFr9qc=;
        b=hEkSXcAhJCOiR/8RIzc/6jiqDNeU6+gZnt11cCFESKFs6nzUDHV743zvo0uWLeF39a
         Qolz+KvOZ2c/MTCRHPldPWxr7w/7NlREa7Um9mGMHrm7yVzmX02qzCULdnz6qwEfHF4m
         JyFjIqR1kgTjqXLYjfanMIkFG0pP+Q/fzI7KGxVuBiiNjkgjy1o4u0ojf0mcGFg/gz3D
         hnhRSFl5zsm/H/7uG8iodhOu4/M1tWz33yHAPyDNsQrOCTQgYBls+OJcB8OgCadAmQX1
         LeEh9IET3+IEaiRXM0OBwG+05rr+V3WSGnS86ZbmopJhiU7zSMwM/FLSU6HYyZa75d0c
         cTlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678910244;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t0VuZOXGCp21EgyUi4sXnOhOFTS9jJF8Mnh7KUFr9qc=;
        b=RcqvuutmvyYjVpbJrEeGAdOD020h9Jrdu1LMF6Cy6ENAmJ+kZrYrrqNHfNrQa1CA3K
         UwIBymP/3YLbhEpuDZ9N+bQFv7g0GDfzDnyk5pbnXkgs+3YJDnU81iOQoaog7qiUwm/1
         vppU676NeSbTBoPc/m8s7qe+bF/MaRXuXerFdLqOcQn0NG5IyoHITI9D5d4+I+D5sJT5
         G1EfMiGdfzrpp8Rm8e2WsINN+GZX2lgtqlP72VoTM7S54GlO3Dqk0JmX44d+SOoyL6Eg
         NZ/pQ1f3tCzmlg4X4Lp3guhmAnxXluLJ4i5GZAwqnBP2F1CbhPKxfxuugvkGxnfXrxLc
         U0Ng==
X-Gm-Message-State: AO0yUKV7Ml7Ygcc94RKluVswP3at26mr+9pV7tnDbCjLWU9ZYy9CO/et
        tkYq5xceTR03GT7Hmos++sIQUtHCzMY=
X-Google-Smtp-Source: AK7set9tQKA1DM8rbX+ez6TfYLy9b430NMIoXlhV3hPmwwwd3eU52O7LCjCHfQqXo/rQnaJf9X6nvdVum5U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:9888:0:b0:a88:ba7:59b with SMTP id
 l8-20020a259888000000b00a880ba7059bmr26597302ybo.9.1678910244519; Wed, 15 Mar
 2023 12:57:24 -0700 (PDT)
Date:   Wed, 15 Mar 2023 12:57:22 -0700
In-Reply-To: <20230202165950.483430-1-sveith@amazon.de>
Mime-Version: 1.0
References: <f3a957786a82bdd41fe558c40ec93c3fb9ea2ee2.camel@infradead.org> <20230202165950.483430-1-sveith@amazon.de>
Message-ID: <ZBIjImc+xEMhJkQM@google.com>
Subject: Re: [PATCH v2] KVM: x86: add KVM_VCPU_TSC_VALUE attribute
From:   Sean Christopherson <seanjc@google.com>
To:     Simon Veith <sveith@amazon.de>
Cc:     dwmw2@infradead.org, dff@amazon.com, jmattson@google.com,
        joro@8bytes.org, kvm@vger.kernel.org, oupton@google.com,
        pbonzini@redhat.com, tglx@linutronix.de, vkuznets@redhat.com,
        wanpengli@tencent.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please don't send vN+1 In-Reply-To vN, the threading messes up lore and other
tooling, and becomes really problematic for humans when N gets large.

On Thu, Feb 02, 2023, Simon Veith wrote:
> In the case of live migration, using the KVM_VCPU_TSC_OFFSET approach to
> preserve the TSC value and apply a known offset would require
> duplicating the TSC scaling computations in userspace to account for
> frequency differences between source and destination TSCs.
> 
> Hence, if userspace wants to set the TSC to some known value without
> having to deal with TSC scaling, and while also being resilient against
> scheduling delays, neither KVM_SET_MSRS nor KVM_VCPU_TSC_VALUE are
> suitable options.

Requiring userspace to handle certain aspects of TSC scaling doesn't seem
particularly onerous, at least not relative to all the other time insanity.  In
other words, why should KVM take on more complexity and a mostly-redundant uAPI?

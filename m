Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72D1767D3AA
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 19:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjAZSAA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 13:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbjAZR7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 12:59:54 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492E14B765
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 09:59:54 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id u1-20020a5d8181000000b006ee29a8c421so1341502ion.19
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 09:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LpnAABfNYMCevlz4tb2h+SDR8QhnmLfkAsv1SE09GPo=;
        b=YA1fD7c0egcvtXTSS6hbyMbK4+zw1mfhAd3PdeR4eZ/Y3ANXwpAx0rShmYsh7VJroB
         i05+ePxqa1yw905X/0GkOM4wfs38/NpwLvENDBF0vvLxXqd2EWbhkOs+xMyI7g3O3tm4
         7bxmWbj0WYg9GnCr1f2C+LJ8r+w0GTEuyCLg0B9Yq3hjhB4klghNQBviv/2xDwbCkcv6
         UMHhaVJ8Ga0c/9P6AYylPhq80ed6SLZHa3T2lusIheXFHhXDl3ydL7HKqaXySH6FAdwR
         nTs0E+VhDhyVYPkdfOFIkMXjbNHqDR4Nq6e+z90fp5782jWub/KDHle1OTceyWCJIqbC
         d45w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LpnAABfNYMCevlz4tb2h+SDR8QhnmLfkAsv1SE09GPo=;
        b=5lXooG+TVvAOJKqTypuenNxAbW5ekcvVWjRl1rgcyDF+GjW/Xsdk67d3U85Atmlkgj
         pBrM0/z8H3yDA+aWXEGsoy9NPRpxoxbauD3m+OdUGQByDbF1gzmg9Wn8ugukEHH4hCjk
         Xs48osc51EKtfp2dz7G/pi7ui63zrXWTjoIwV1V13/Ul1GzqYYfAt1QY4/SRHYScGa3e
         FeNl+R3Ews9iub491BclDlSpdn3u3oIi4hFIePKNVqL7JCjHI0WZAIsYLVVBOdxqfDRz
         JP+AiD4Igjlwx5lR5U/ru+oRAdh1QqKO6QufUZVO1xUZxDvxHaesadB1xc/BP+ogwU87
         FUuQ==
X-Gm-Message-State: AO0yUKVHyQ07XQclLF7evXXQPR/aVfEnfgbDQq86b8nz+WZ29T5FZP+q
        ISMhYZS+0JrJC8lrMQSgGNtz8GmFHyB9LidYSw==
X-Google-Smtp-Source: AK7set8l0SyObHwIbf9YnozGsTObjZVNUmvyf8s3C2ojUOhaQ+yLaiVEa0TcfJx3CV8uLDFzic5spaVU4DHiLxKMMQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a6b:8d16:0:b0:70a:962d:723c with SMTP
 id p22-20020a6b8d16000000b0070a962d723cmr521454iod.54.1674755993726; Thu, 26
 Jan 2023 09:59:53 -0800 (PST)
Date:   Thu, 26 Jan 2023 17:59:53 +0000
In-Reply-To: <Y8ghnd58W8F8e1GK@google.com> (message from Sean Christopherson
 on Wed, 18 Jan 2023 16:43:09 +0000)
Mime-Version: 1.0
Message-ID: <gsntcz71qiqu.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 3/3] KVM: selftests: Print summary stats of memory latency distribution
From:   Colton Lewis <coltonlewis@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, bgardon@google.com, oupton@google.com,
        ricarkol@google.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> This test shouldn't need to guesstimate the frequency, just use a  
> VM-scoped
> KVM_GET_TSC_KHZ, which will provide KVM's default TSC frequency, i.e. the  
> host
> frequency.  For hardware with a constant TSC, which is everything modern,  
> that
> will be as accurate as we can get.  For hardware without a constant TSC,  
> well, buy
> new hardware :-)


Thanks. That simplifies things. I encountered that number before but was
unsure if I could trust it for reasons I no longer remember.

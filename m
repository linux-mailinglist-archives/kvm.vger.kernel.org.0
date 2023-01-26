Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60EE067D3AB
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 19:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbjAZSAP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 13:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbjAZSAO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 13:00:14 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E49F4B765
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 10:00:12 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-506466c484fso28346747b3.13
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 10:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EwQcYnrS7yH6KQ/Pqu/8KZdCplRO/Yr1JEfDzYU7D2U=;
        b=svojaW2Hcp0ISSx+9H0DMw5n4A1Nslz9EYU2qxsQ6U5z/Rqj4uhtE8MHd3yMXUUIcF
         E7yATs0hGWnUmsgg48D7lYIuasUcRyCrdcxdV2YsZTDbyz2Kl5UoC0VjKserDvxINYan
         GacHXDShYX/zZNFn3bzpfiejjfypvl1KoeL69MEAffpuK+XaMkPXIkrtj5I+RMdZAino
         Y3SV7NtqgbEHPyt+ISJVUbi3PSZeXHAEVnfo6z7uhPMupe80pxRFxFDz+Oh/aZARpNW3
         /InnBH4hXq2f8mKbt4EXPXKemaFFBtI/94HG+unHO/I1h4O3YTb22aav7EIQG0ewdiVL
         dtMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EwQcYnrS7yH6KQ/Pqu/8KZdCplRO/Yr1JEfDzYU7D2U=;
        b=NL9Iw4zPnrqlyGEyyLMvhPsSXyRU0fYekhd5r+d52mcfuZ0kDULbDAOL5Cg1tw1N7g
         94OlKpDe4yaOcvZa0ZHXHdlC25OtqZC7wYd++iKVIk/Tit+cjx5uppcMJQ1yMk/LBl7B
         ItlhHGS04NnTAXaMhliFt1yPC2WVYrKrVCyUjLVujCex6ZD5yReF3JX7rBIivkrJJ9qN
         3zj1AnxRmNjqGov2M76gzMklSQ0aMhozdcshD+WdFLbuAXAFvEU7TICcbbTfSFxvPTW0
         VcQTiRAk9/63/adVsuUvNFIGosqbA97ySg1VvhAfd3FXwtKO1pgXcpDNeOhm6pdZlfqV
         wvsg==
X-Gm-Message-State: AFqh2kqQbSeTaCYdqic7aRVVu9oow11+pK3FnL9JG9svpgLfjngANQUw
        Sl36csZ83KCmWZ+qhRHLz3YJ2vx7bYj6QWdZVw==
X-Google-Smtp-Source: AMrXdXv77V3Y5l4qgYRr+5XHvYre5Vyw+3n2okPw0YM8VHW5VuoYYExOnzYwTsXEzI62MjM+R8tnyKKrJmXUJa5+KQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a0d:da83:0:b0:3c3:8b8e:13ee with SMTP
 id c125-20020a0dda83000000b003c38b8e13eemr4061507ywe.77.1674756011471; Thu,
 26 Jan 2023 10:00:11 -0800 (PST)
Date:   Thu, 26 Jan 2023 18:00:10 +0000
In-Reply-To: <Y8gjG6gG5UR6T3Yg@google.com> (message from Sean Christopherson
 on Wed, 18 Jan 2023 16:49:31 +0000)
Mime-Version: 1.0
Message-ID: <gsntbkmlqiqd.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 1/3] KVM: selftests: Allocate additional space for latency samples
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

> On Tue, Nov 15, 2022, Colton Lewis wrote:
>> Allocate additional space for latency samples. This has been separated
>> out to call attention to the additional VM memory allocation.

> A blurb in the changelog is sufficient, no need to split allocation and  
> use into two
> patches.  I would actually collapse all three into one.  The changes  
> aren't so big
> that errors will be difficult to bisect, and without the final printing,  
> the other
> changes are useless for all intents and purposes, i.e. if for some reason  
> we want
> to revert the sampling, it will be all or nothing.

Will do. It's easier to merge commits than split them up.


> I do think it makes sense to separate the system counter stuff to a  
> separate
> patch (and land it in generic code), e.g. add helpers to read the system  
> counter
> from the guest and convert the result to nanoseconds in a separate
> patch.

Will do.

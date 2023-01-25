Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C5667B87B
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 18:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235513AbjAYR1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 12:27:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235311AbjAYR1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 12:27:00 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064DF16ACE
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 09:26:59 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id o13so19265109pjg.2
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 09:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LI/e7a+7qI8RLdBO66ly8Lxu3fk1Ck2EdZpclV0qcG0=;
        b=DQJZXBxAMXpFUQBapuAvmpcvpRZyv9Dra9mtZ7D9fLqcPjtyzryFqzSPvfZaJSrB5c
         VAVHEWD5GNumhrai1p7cQ5ERHArBa5CTkiGw3EEr5Bct46pFvIPxbxAjyLzRYZE7/TQQ
         MnomKD/1RYvXk/S02f09snznq7pIdDfRE2MnpdvhLGWtg6uX3VyGjINfNr1to3GjO7CD
         hZK/29F+Xg9A1+Gkx6VWDfiLDUJz3xe+sLffg8UdE8j7QEF7vUUS4PscUbO8+xBIZC4v
         NM3pzX8whPRTrmAjhJ8XH85ANQAWWXMaj6SFMyz+NEbDLsbdjDgvHvNrzx7dKD7ybTFP
         xORw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LI/e7a+7qI8RLdBO66ly8Lxu3fk1Ck2EdZpclV0qcG0=;
        b=4gFZYbd1tjKs+UZfP8yv8ztpswSqxVE9Rpj01RJGvGo+I+z2FPwRTNxDg/GMumQYw+
         zo+fzz4gmwuUoo8oH9RtcjYtX6pcS9usWE/ODtn+6cBPjRBnHGPf5Wh948bbnmNxHlmL
         MNR/aUnBJs3eGCLrZ+X3A/HItfRIgOH0x52WqupSyCu1V+QM1rNdwIbiwv5Y2D0jTOLM
         U1pckPg59I2KzNvKYwqoAjQ1Y7Xu8pYYQsiPcifF1DB9nitktrHQEGSfQhafMu9jqaW/
         NbzYsgI4CsOM6re8DrTI9MQEFzfoZY72/K45Jb0Zy+bKosCAxQrOQsWNiDqHqm9oHadc
         rgaw==
X-Gm-Message-State: AO0yUKXQgmsSeclJt9tPxOorKRHuZQn8GFrB1FNqra7VHBbmG2v3DkRl
        stPyIjXEhnbJAQYRXoOSy9/jfw==
X-Google-Smtp-Source: AK7set+b8K3FPVsVdc87DvMbnIrj9bklg11lwWCMJJ+e+tgsnArjT3rRlbxsTd0u5B98MuQLZHg+5Q==
X-Received: by 2002:a17:90a:eb06:b0:22c:952:ab22 with SMTP id j6-20020a17090aeb0600b0022c0952ab22mr289551pjz.1.1674667618360;
        Wed, 25 Jan 2023 09:26:58 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 15-20020a17090a0f8f00b0022bb3ee9b68sm1954747pjz.13.2023.01.25.09.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 09:26:57 -0800 (PST)
Date:   Wed, 25 Jan 2023 17:26:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: A question of KVM selftests' makefile
Message-ID: <Y9FmXVJw4PkLKryW@google.com>
References: <20230125085350.xg6u73ozznpum4u5@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125085350.xg6u73ozznpum4u5@linux.intel.com>
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

On Wed, Jan 25, 2023, Yu Zhang wrote:
> Hi all,
> 
>   Currently, unlike the build system of Linux kernel, KVM selftests will
> have to run "make clean && make" to rebuild the entire test suite, once
> a header file is modified.
> 
>   Is it designed like this on purpose,

My #1 rule: never assume anything weird in KVM was an explicit design choice :-)

>   or does anyone wanna change it?

Yes!

>   I hacked the makefile by using "-MD" as EXTRA_CFLAGS, so that dependency
> rules can be generated for each target object, whose prerequisites contains
> the source file and the included header files as well.
> 
>   However, this change has its own costs. E.g., new ".o" and ".d" files will
> occupy more storage. And performance-wise, the benifit could be limited,
> because for now, most header files are needed by almost every ".c" files.
> But with the evolution of KVM selftests, more ".h" files may be added. Some
> of which may be of special usage. E.g., file "include/x86_64/mce.h" is only
> used by "x86_64/ucna_injection_test". Having to rebuild the whole test suite
> just because one specific header is touched would be annoying.
> 
>   I am not sure if this change is worthy,

Absolutely worthy, I've run afoul of the lack of dependency tracking far too many
times.

> or if there's a better solution.

This part I don't know.  I would have cobbled together something long ago if I
wasn't so clueless about Makefiles.

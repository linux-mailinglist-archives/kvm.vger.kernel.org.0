Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A659F6A8A79
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 21:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjCBUeN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 15:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjCBUeM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 15:34:12 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02077113C0
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 12:34:10 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id c4so287075pfl.0
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 12:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677789250;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9HY0gUXeqwRPu+/je2pxI+jNm8F1qWO7K5B9XWnJIlI=;
        b=V/LM6gUTMAx5CEl93Wbi9y7uv4wJufny6aJNPk8Cj6O0CeVqUVTjPuH2x5tuSfWyH2
         Hb2iGt1QhKKPXIdEJ5K21AdZxP7cf257iyZERqe43jO8/E9dqX+auCokI0G9bGTbbrE5
         gQqmAxeDEkXj/Oyl0S+9NQ8JIzD31u66G2vB6xNY/VSTxIY1r0TEmBXmAa6yfOc2/Z5X
         OGfGnwubjoM4eI5DEOI1tuWBYhcu9JaJTlFN05uYDDbiGWZT9LqEafK0KFjBZ9mgmGRj
         hnorK9whd0ahRPajWE2Xi+xvhNuhPc5qTiGjsHm8u75sGmURbL45alAmnUtpIbgjasAS
         3Wqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677789250;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9HY0gUXeqwRPu+/je2pxI+jNm8F1qWO7K5B9XWnJIlI=;
        b=H4e4CbRQNFcmY7WJwjmjlRlTyz+PFc+fUi1uYkb7UbaakunoJt+opkTo9ru+UC2iC+
         g10XB3nSlLwkK096s4ms0Q/RKdGP6/5go9B6QE9t667rmGJDXu46n2a0GvkerUkzAvXW
         tm9QOiMYh5gxuZ0USr5cbHxNzuWcssHmWCjzcmnniIW7/xpxH0qG7/8NE2/XkK9AKJsQ
         Q14H8b6GhTb3VCUVP1Fna9TcaF1BFgiuFUQHoZE/3z/zouBamCdIpsnwrRwdHfhkL0Tn
         opX0i1sV70XV9l9ZROE5riMkc5mrIC0PhF0VHGi1Fd2NxbJDOBJygGq8CKsoJYXfDdYq
         ZE9w==
X-Gm-Message-State: AO0yUKVPrIbj3j+QfvHrehmspR0fpY+iQDNB5zzL+pRkqVk8UVgcEMrl
        wVi/ZJDfclasp7Bomqu9ZLyYWQ==
X-Google-Smtp-Source: AK7set/JuEQVlAKHdJmYCG2shDh+wxcrd8FMJah2C5RcimDd3u6QTsAKRDWzAI7s9ufiGLr4pIRiqg==
X-Received: by 2002:a62:25c5:0:b0:5d4:e4c8:23ac with SMTP id l188-20020a6225c5000000b005d4e4c823acmr9686576pfl.21.1677789250147;
        Thu, 02 Mar 2023 12:34:10 -0800 (PST)
Received: from google.com (77.62.105.34.bc.googleusercontent.com. [34.105.62.77])
        by smtp.gmail.com with ESMTPSA id r25-20020a62e419000000b005dfd011192fsm132317pfh.8.2023.03.02.12.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 12:34:09 -0800 (PST)
Date:   Thu, 2 Mar 2023 20:34:06 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        seanjc@google.com
Subject: Re: [PATCH v3 8/8] KVM: selftests: Add XCR0 Test
Message-ID: <ZAEIPm05Ev12Mr0l@google.com>
References: <20230224223607.1580880-1-aaronlewis@google.com>
 <20230224223607.1580880-9-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224223607.1580880-9-aaronlewis@google.com>
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

On Fri, Feb 24, 2023, Aaron Lewis wrote:
> Check both architectural rules and KVM's own software-defined rules to
> ensure the supported xfeatures[1] don't violate any of them.
> 
> The architectural rules[2] and KVM's rules ensure for a given
> feature, e.g. sse, avx, amx, etc... their associated xfeatures are
> either all sets or none of them are set, and any dependencies
> are enabled if needed.
> 
> [1] EDX:EAX of CPUID.(EAX=0DH,ECX=0)
> [2] SDM vol 1, 13.3 ENABLING THE XSAVE FEATURE SET AND XSAVE-ENABLED
>     FEATURES
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>

Sorry, I did not get the point of this test? I run your test in an old
(unpatched) kernel on two machines: 1) one with AMX and 2) one without
it. (SPR and Skylake). Neither of them fails. Do you want to clarify a
little bit?


Thanks.
-Mingwei

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC74D6172A4
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 00:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbiKBXak (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 19:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbiKBXaY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 19:30:24 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6FD1A3B6
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 16:23:31 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id k7so302509pll.6
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 16:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D5UOn18RrY1kkOpbW2QL63D1zwjztb/uPifmt+JHluE=;
        b=FR0ybTgIZjoKnZi5Mib7oQrXwF2+wv6m5cxf/vvOSW1O4EZxFc0m6ycK0oRCc8t8MP
         d3lXB7sehh6iIySdXjDv6fFaY9MSAgqgbv+MzHn1BCYdVN//xsVjou+XkCjjPBdDc7dl
         hV39EtCrLfcw3fF+vNitKiCMLJpnClRAuMLfaYXKWbWLaXS5L88cek7gWO/OIYo6pPwP
         jcwt4/hO63/uNplZUHnMkFdiRyc6wcsCkD2wSsTH3HOKutqTC0Yk6e0rHopsv8P1iBOF
         Uv0/nrIxOPTgaflFegcV7vkCAFupfsgItZekTiX7+q2K7bS7BqKEhwMnPS6eGOSLearQ
         R32Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D5UOn18RrY1kkOpbW2QL63D1zwjztb/uPifmt+JHluE=;
        b=teYezDfETzbZL+Cq5vpu2kdWAjDw0ItsCpkOSqbpYRwn3/Kt0OEssldTgKMg+5Bkc5
         rYXpt+SR2ak2LdGchKxllQnZriMyFvLR8WUDmiOdBi2U4SMhD4r19kA4B884Rj98BSqj
         7A3W6vvwTsVKefYXqpq2Jlcz3gMZrT+59ksl6K0zMHGR6K8rrqCVjC4Gpeol6dgb0ZOe
         0mZXvAbqKP3k/McAF8BPexoi09yJpaPQn4EEc78+/le7bh0GvAVUBO3yllO0NwNN+Q4M
         4jK6CPAlHgxvr3zNtfp8qrPToltTLgTVjka1aPEOXymwYiCUsmqeBO1aVQnj8+NVqDBl
         BHVg==
X-Gm-Message-State: ACrzQf1VbekNBVtFD0ziVMe3Ws64+nuhl4c9lxtXIJicIDwHwpjZhJFn
        qGYj7tGh3AamXxnRAU93FAE0Kg==
X-Google-Smtp-Source: AMsMyM4Pgwbdgb7e4rINkonA5nQchbcJL7kQyKebJ3spcEHUjs9rcRheSadqMe1cQ99fQ00EkIvhgw==
X-Received: by 2002:a17:902:ea02:b0:181:f8d2:1c2b with SMTP id s2-20020a170902ea0200b00181f8d21c2bmr27618378plg.107.1667431373021;
        Wed, 02 Nov 2022 16:22:53 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e10-20020a170902784a00b00172fad607b3sm8763812pln.207.2022.11.02.16.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 16:22:52 -0700 (PDT)
Date:   Wed, 2 Nov 2022 23:22:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH v9 1/4] KVM: selftests: implement random number generator
 for guest code
Message-ID: <Y2L7yXZ8lhj75jJI@google.com>
References: <20221102160007.1279193-1-coltonlewis@google.com>
 <20221102160007.1279193-2-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102160007.1279193-2-coltonlewis@google.com>
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

On Wed, Nov 02, 2022, Colton Lewis wrote:
> Implement random number generator for guest code to randomize parts
> of the test, making it less predictable and a more accurate reflection
> of reality.
> 
> The random number generator chosen is the Park-Miller Linear
> Congruential Generator, a fancy name for a basic and well-understood
> random number generator entirely sufficient for this purpose. Each
> vCPU calculates its own seed by adding its index to the seed provided.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

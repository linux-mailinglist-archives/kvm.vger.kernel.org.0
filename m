Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6FEE5FA31E
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 20:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiJJSD6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 14:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiJJSD4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 14:03:56 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F10377EB6
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 11:03:56 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id r18so10825158pgr.12
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 11:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uDlNcVsaedASdVOGAGBworBLmX+3Vrc8Fh3iEviz+uI=;
        b=ayxJzB6AbGpIgkQLnL3vGqAPR++fSBo+Fqo+by/pk6C5oL5DA4b3+PepQjlkJ3aLPp
         M/sFQ02lbV2liqR+cL9OcoOP5Vh5eYZq6DN98tDS3NyoX2ibN0tgv9sXNqnxJI50fVdg
         T6Dgz0MUybZkx3QUuGJtpfSi/r4RYywD2oCcLulKpeBfRHRqBAlhAa6VlieLShqKzBVP
         yAjTWjsR0fCXXURkWhQ9dLE9Bq0sqgriZq89Auk96cECpX/Eg32wY9fBmiGLJXbsvQSB
         EWW0yHo6yFcINbR49LnuUhTjIOnzH6r+Rvpbnm+qrBYUOVOK1Fyp9KWeGWZJGHBmloiz
         gKzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uDlNcVsaedASdVOGAGBworBLmX+3Vrc8Fh3iEviz+uI=;
        b=kJUeoy/+6cXghs+pNDvEzFBTcBFx0ziiraB98nJV03rDHSIFi+G9p5BNksiTe0XUnU
         KwrAJI104gZPGk0ClYne+7MCpKEYbFuxp2Wl9PunzxxuxPJFuvy3VqgUKLf71ZCGWC/z
         gX4T2RNwYqmbGoqsB2a6rFE+gl7KthzxyADYAOHB05gCAKvDY1zCH7PTFVmfnTN16hMc
         w/XTc7O7e85AGvI861yFiomtx4b3l/zUT/pPJGCe13mb1o6sssLuhYby2jO2sclky9He
         d6wYK0ktZEluQZyQTbc+VkcLT2n3OCnDnqxr3qA08Sy8UBmZxzLCgoLyJmvt5Y8ZhNcz
         trnA==
X-Gm-Message-State: ACrzQf1UtqrUcRW36lfQRbYSExfZ/j/2jCHGj4FH0zENK7aebetZUaPQ
        F9S03GhjN9Pi61uxe3JaXe/epQ==
X-Google-Smtp-Source: AMsMyM6Ykd2BrYQ/giRfnw9wTQsdLDMt5+qF5BdmmeGZcupFj8mCUftl6/cACOWsmpZnLTOItrVqzQ==
X-Received: by 2002:aa7:9d11:0:b0:563:9272:b659 with SMTP id k17-20020aa79d11000000b005639272b659mr2517844pfp.86.1665425035547;
        Mon, 10 Oct 2022 11:03:55 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z15-20020a170902d54f00b0016d4f05eb95sm6859507plf.272.2022.10.10.11.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 11:03:55 -0700 (PDT)
Date:   Mon, 10 Oct 2022 18:03:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, oupton@google.com, ricarkol@google.com,
        andrew.jones@linux.dev
Subject: Re: [PATCH v6 1/3] KVM: selftests: implement random number
 generation for guest code
Message-ID: <Y0Rehzc6VbnOGIwF@google.com>
References: <20220912195849.3989707-1-coltonlewis@google.com>
 <20220912195849.3989707-2-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912195849.3989707-2-coltonlewis@google.com>
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

On Mon, Sep 12, 2022, Colton Lewis wrote:
> Implement random number generation for guest code to randomize parts
> of the test, making it less predictable and a more accurate reflection
> of reality.
> 
> Create a -r argument to specify a random seed. If no argument is
> provided, the seed defaults to 0. The random seed is set with
> perf_test_set_random_seed() and must be set before guest_code runs to
> apply.
> 
> The random number generator chosen is the Park-Miller Linear
> Congruential Generator, a fancy name for a basic and well-understood
> random number generator entirely sufficient for this purpose. Each
> vCPU calculates its own seed by adding its index to the seed provided.

Why not grab the kernel's pseudo-RNG from prandom_seed_state() + prandom_u32_state()?

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D657E599180
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 01:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242563AbiHRXwM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 19:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346097AbiHRXwD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 19:52:03 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2969EDEA49
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 16:51:59 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id jm11so2761570plb.13
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 16:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=oaC18ebf8HrnX38abtQXUfLjaqpAibW92E0Qqkdt/rc=;
        b=T+KC6Nt1AiimE8ajVV6KYoQlIjigEeIHZOXa96RmlUjkUaKHBFLPChl56oXynEXv06
         m6LiSq7U+1u3ZSYIhZe58zoOesMMElcJ9Je7BgFd4b6vuLSUZftlmdztHdhDkUvFt2Wa
         F6TnsVHJlZbWjZ2nQBBXjqEpMGLfWJUA6Tlx/sJKolGWyPrMx+6X/lKBYW2pSsy/c5fn
         DPnak6w/X9MluZeAV8+stZfVacubj1+36xrJmO0c38xyGrWM+zDLC4VNfnHwEhPKUJtE
         xs/VyPE2SMKQxexOpnTP5g9KPEbp347Ffg5ahkkGN0XiNSMBSKq56N1kNKwXfddWYrIV
         HOTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=oaC18ebf8HrnX38abtQXUfLjaqpAibW92E0Qqkdt/rc=;
        b=Uy5+5T6BBLTFB9SSB2pAJWVyWgelqzgAmCQTkXLMF2MKqlyZ1AwpAXqKNnHsPzExMR
         PeHX89IeGuZm2DJzKWX4gd6AYGgjrPoEXI8Otd7/SyMjp9uUuhAB1p5Gv0KrEePRBOcj
         5gbbB3wYCEsdcjG2KZiH1FqdnjQLahC9DTaOKMl66ZYYJ9pHGftva3F4GLpxbpT3ezeE
         jJfqrbLXWG5G4WMjTi7D0y5r6oae79toUH436r9sqb7eehdZ0r6uzfKbz0bB7azHaEjW
         uOCgyyJU/y/JeegtXHqHADNdnkpP67L9H8jJx7MwwAGgbRsELNg6NL4zvcXAPZI8bBE7
         mrLA==
X-Gm-Message-State: ACgBeo1ngo54lzqAzmlnkCccVQDpgCIdHO3Mt2o6AVQGFNTXuF253Zsg
        r6rszPOIvP7+AbTq590pAsCQlujThqan1Q==
X-Google-Smtp-Source: AA6agR7RugQg8R049DKqEu9NlWz+7KkOdqsnKfMKK3JgKLU3K4/GDSKuwTWOmbpCclmxkVbpasa2hA==
X-Received: by 2002:a17:902:8d8a:b0:16f:21fb:b97a with SMTP id v10-20020a1709028d8a00b0016f21fbb97amr4712515plo.160.1660866718568;
        Thu, 18 Aug 2022 16:51:58 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f68-20020a625147000000b0052a297324cbsm2181877pfb.41.2022.08.18.16.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 16:51:58 -0700 (PDT)
Date:   Thu, 18 Aug 2022 23:51:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Li kunyu <kunyu@nfschina.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] kvm/kvm_main: The npages variable does not need to
 be initialized and assigned, it is used after assignment
Message-ID: <Yv7QmoHtVDNU7dYk@google.com>
References: <20220812101523.8066-1-kunyu@nfschina.com>
 <20220812103009.8362-1-kunyu@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220812103009.8362-1-kunyu@nfschina.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please use "KVM: " for the shortlog scope, and write an actual shortlog.  E.g.

  KVM: Drop unnecessary initialization of "npages" in hva_to_pfn_slow()

On Fri, Aug 12, 2022, Li kunyu wrote:
> The npages variable does not need to be initialized and assigned, it is
> first assigned before it is used.
> 
> Signed-off-by: Li kunyu <kunyu@nfschina.com>
> ---

With a proper shortlog,

Reviewed-by: Sean Christopherson <seanjc@google.com>

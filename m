Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB7935B2887
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 23:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiIHV1s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 17:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiIHV1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 17:27:45 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DE1A5993
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 14:27:45 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id v1so5825525plo.9
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 14:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=tNz6sUDLYT3e7yFiPMDST01YGryWrmTyyL5wc2tCzUU=;
        b=QB56rA49XIYYaL+5n416TMQR7QkRyq6IFKkYOBPOFtLfRjvNWbmBfbSlh78sxydW2L
         h6N3MEe7L4GOxCW/I1NzmGXcj/9r4QjZ7GFv0KGR91ZVWB709QdDcF+NmmIVOjSEffkH
         JqRI/x8AM2OCx7pFnJhYBNJJum32YhFHknGlJpYI9SNEcUbkP6375EmQEZZfZz3/RXce
         y7fA536hPxWYWnWxvwInF+h9sclTQ1UjCus6E8h+th1CbQkw/TnKEGpmdbb507jIO8Bm
         BZLhq6jOGhjwwfrQAczJg/xJ6M5sso2sj5hd+kNSarh/6aH6wJkgCu9PCkhz3O8Mh/Bl
         ItgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=tNz6sUDLYT3e7yFiPMDST01YGryWrmTyyL5wc2tCzUU=;
        b=lvhFi3PL0TCNTepWX6LE2WrzNdaxi27PwkFSsDR8i0fHd5nCWskq5BgKX3TInCFhUP
         aCRVSi6/5taaVGhJBCwfujCeE01UtGPzALS+OziZGbNmA+AGSic8K4k/UeYzSVWwWnQg
         Gugh0gOtNKUKlvfHaeHAoGyBZObeRc5qUeuuSyBeeGSNxdzGKqhC3mwE+SExJHHHcpoJ
         YYUetdbGWYrs9/NQgziRNii0Ya831Oo25g90uGjULep+2pCPD8MyClMjRz30vRTHVM0R
         EKqJoSYR1dXgR5fKINdxiLXH0AhRtap+LHoPoME/FtqFyBoY67nQB3FsUsKz7dSJeOmb
         DZ1Q==
X-Gm-Message-State: ACgBeo1tc7C+xcImndfR/wi5VbSbtv2I2C3HhsxAVdNm+7zsw+Yzj5+w
        NYFYmSzeQwhMb3RWgs+U96FzG6/JrxUD1LEA
X-Google-Smtp-Source: AA6agR5MBlEyYviP0pTmj23mtLYE6mNlvK8rEHr8k1m8jsw5q6vkh+f/KENStEHl2JgCeYf3ZW9H/g==
X-Received: by 2002:a17:902:ce8b:b0:177:f1f0:8914 with SMTP id f11-20020a170902ce8b00b00177f1f08914mr5516364plg.137.1662672464552;
        Thu, 08 Sep 2022 14:27:44 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id f195-20020a6238cc000000b0053b850b17c8sm62707pfa.152.2022.09.08.14.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 14:27:43 -0700 (PDT)
Date:   Thu, 8 Sep 2022 14:27:38 -0700
From:   David Matlack <dmatlack@google.com>
To:     Vishal Annapurve <vannapurve@google.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
        shuah@kernel.org, bgardon@google.com, seanjc@google.com,
        oupton@google.com, peterx@redhat.com, vkuznets@redhat.com,
        drjones@redhat.com
Subject: Re: [V1 PATCH 2/5] selftests: kvm: Introduce kvm_arch_main and
 helpers
Message-ID: <YxpeSnTrLGPz1sjn@google.com>
References: <20220903012849.938069-1-vannapurve@google.com>
 <20220903012849.938069-3-vannapurve@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220903012849.938069-3-vannapurve@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 03, 2022 at 01:28:46AM +0000, Vishal Annapurve wrote:
> Introduce following APIs:
> 1) kvm_arch_main : to be called at the startup of each test.
> 2) kvm_arch_post_vm_load: called after guest elf image is loaded into
>    memory to populate any global state in guest memory.

nit: Can you throw the post_vm_load in a separate commit? It's a
logically distinct change. Also suggest naming it
kvm_arch_post_vm_elf_load() to make it obvious it runs after
kvm_vm_elf_load().

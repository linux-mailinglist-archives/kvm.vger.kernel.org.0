Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D09C64E583B
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 19:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbiCWSSJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 14:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245521AbiCWSRw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 14:17:52 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D361988B30
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 11:16:22 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id x4so2683282iop.7
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 11:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nMqxdIZgJ4df2glO3AXxvZM8Vb5idq1c8Jw7C91a7Vc=;
        b=p43R9GLwlW8RzbEXi8zCiRwYsoq1VH3VbGU7vQ8dDRiLQNTTwvSxVUgbRv97gty1nU
         gBWq8BpTOJl3argEvXZePHDxsmy1SR8wOHYa9Mc5QC84mXyij9bggiFnh6GG7MsGhONZ
         DWNUl/8mdwnRLkc+0BskLlHPtksxf9odD3frJghi5DKJtnnybDhNTpCAsjT7VOiEkeT6
         OSN407EU7F9qBwpdyBSK/G+TqEHrtUeM9w1btYhMRm4bDdhtf6x+t0PuNcoEwqZO8NmB
         0ND+M4SL+uaZW51ehTiehp0P+GScV8fbrdXwb5riFHisJTGltXQTF35BvRNfbvcmrGdc
         BcQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nMqxdIZgJ4df2glO3AXxvZM8Vb5idq1c8Jw7C91a7Vc=;
        b=JpLlKW0Ea4q21/dBbaOewIDXVmkD1Ts3IfkoFDv7ZM68flWWI6VVBHisybjD2ILIVk
         N1grNhTkoD825NbxLYzgzca+OaEccRwvpItxyLZM1PwXvCKfkoRIKg8SYJByOcB7qMT2
         AqXxrQ+DBQolORKLO1y5CLmKraLzjHvZwbUMHYhseLTLNT6stPr/Ny9y08J1s+6q4Shg
         beACV/uk926uawfIzZJ4t9zsC7RAusaun3jA0khQQmNqus1ojWt9MECszYNORS8P4ppu
         lUgtchB93MCkbscBUOtMnYQ20ueyauoA3dJAeFAd6uucYgVo1EuUQA5Wx0xzw+WJsV5b
         FIfA==
X-Gm-Message-State: AOAM532mbg6G0KNyHdrNOeNNX9FMSEt5vk2H5BegHzegbvMJ9ZMiVopz
        RjJSdLpwHvlljDGE5LEg3AbaLA==
X-Google-Smtp-Source: ABdhPJz21mhhHYj2VEdsCwKHh095WxTo6GZp1tVD+4wVhwAzkpj23tCt6tZvUXBt2e4Xi/BR9V8V6A==
X-Received: by 2002:a05:6638:328f:b0:31a:12ca:b4d3 with SMTP id f15-20020a056638328f00b0031a12cab4d3mr610421jav.19.1648059382139;
        Wed, 23 Mar 2022 11:16:22 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id f9-20020a5ec709000000b00645ec64112asm279808iop.42.2022.03.23.11.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 11:16:21 -0700 (PDT)
Date:   Wed, 23 Mar 2022 18:16:18 +0000
From:   Oliver Upton <oupton@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mlevitsk@redhat.com, jmattson@google.com
Subject: Re: [PATCH 3/3] Documentation: KVM: add API issues section
Message-ID: <Yjtj8qESPWIL221r@google.com>
References: <20220322110712.222449-1-pbonzini@redhat.com>
 <20220322110712.222449-4-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322110712.222449-4-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On Tue, Mar 22, 2022 at 12:07:12PM +0100, Paolo Bonzini wrote:
> Add a section to document all the different ways in which the KVM API sucks.
> 
> I am sure there are way more, give people a place to vent so that userspace
> authors are aware.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Do you think we should vent about our mistakes inline with the
descriptions of the corresponding UAPI? One example that comes to mind
is ARM's CNTV_CVAL_EL0/CNTVCT_EL0 mixup, which is mentioned in 4.68
'KVM_SET_ONE_REG'. That, of course, doesn't cover the
previously-undocumented bits of UAPI that are problematic :)

If we go that route we likely should have a good format for documenting
the ugliness.

--
Thanks,
Oliver

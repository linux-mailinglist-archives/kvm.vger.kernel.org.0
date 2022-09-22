Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A895E701F
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 01:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbiIVXLj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 19:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbiIVXLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 19:11:37 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF48E6A08
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 16:11:36 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id b5so2483424pgb.6
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 16:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=wU8HbpvAN01fYPWDpPeQW+W40dxFMIs6MZVqDQ4tqB4=;
        b=mEsgY2C1av//H/NJpLsy36fKVPpfHbPNBf3PkU0I+gQDt8F1zNj9+yBeIQvBLgBSID
         OJdrpd3FrGRFFR4BVjwAOptq065iPngR0mS2KI8fQ8D+ik+nBaY8EAviAUYBsSm1SID9
         aEltopZFQrRf0nPKtOJ6w8mDST8D4UBNBzSEMt9AD0yNuVYFzrfIZP7h7+5vNI0HFUdu
         9srZED4FUNSCrdrns/WxgQL31teHzykJ0SbNWrXWrnoYFpQjhWAK4uyRP9uWD7OWphdT
         LOiR+Bviw8qar69Yx3563e24IwTCfYmQt1m9ylV4I5AUB12GqK/zGJdyhmRook0pxUEO
         Z5ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=wU8HbpvAN01fYPWDpPeQW+W40dxFMIs6MZVqDQ4tqB4=;
        b=y8sFsk5GDBwH6L5BqdN/9q/9YWJSyjxRD5HmJSNzauFgTNuHeo+RihO4HOjeKwIJ7s
         PduNUBtYTxECvLYqBzusa1wFuLL2aHOtrZmXzBugOvvBhAkBHPKMHBEJ8ZINpHJTvLgF
         /fEkF9mlMdChZz48Y+WM5m0TSWL6aSdgpTDcnJQcXOTmZKjvAPzMIio53DYMe/E9Aew8
         Gi5BdL9wDL9fCsuy3dlims8XqpQFTc4o5jVHT4dxwSZzfIMjPkojivfq5osfG79qdl6S
         Yomkqpfytm1xkVjxpapQis7+ZWawFyYy637Uik/vOdvKaiF8tx9xpk1b7G5kuTGEDGe4
         Ra6Q==
X-Gm-Message-State: ACrzQf0M+7Is0Ms9scvT3mdMgzs7991RrACnvjDbZXJ/OtgUiRcxD1zs
        tduCZyKtAU13jgTNukU/Yk9IRw==
X-Google-Smtp-Source: AMsMyM7p0wDpqCDfl/xZ9tSGFd36/AFM4jDrMYWtpMCXUJ0SIA5YpMq974UC4pfIuNk8lsnD0chPzQ==
X-Received: by 2002:a05:6a00:13aa:b0:540:dc91:83df with SMTP id t42-20020a056a0013aa00b00540dc9183dfmr5922857pfg.5.1663888295484;
        Thu, 22 Sep 2022 16:11:35 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u20-20020a627914000000b00540a8074c9dsm4984385pfc.166.2022.09.22.16.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 16:11:35 -0700 (PDT)
Date:   Thu, 22 Sep 2022 23:11:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/7] x86/pmu: Corner cases fixes and optimization
Message-ID: <Yyzroz9x4jKShOKa@google.com>
References: <20220831085328.45489-1-likexu@tencent.com>
 <Yyzh3VD+Gji8t9OO@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yyzh3VD+Gji8t9OO@google.com>
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

On Thu, Sep 22, 2022, Sean Christopherson wrote:
> Regarding the "defer" patches, your patches are ok (with one or two tweaks), but
> there are existing bugs that I believe will interact poorly with using reprogram_pmi
> more agressively.  Nothing major, but I'd prefer to get everything squared away
> before merging, and definitely want your input on my proposed fixes.  I'll post
> the patches shortly.

I take that back, there are issues with deferred overflow handling.  I'll follow-up
in the patch.

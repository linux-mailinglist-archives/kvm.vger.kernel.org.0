Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF55E5EADC2
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 19:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbiIZRNI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 13:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiIZRMr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 13:12:47 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD30167E1
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 09:23:14 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id o99-20020a17090a0a6c00b002039c4fce53so12970852pjo.2
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 09:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=JFKlJ2MGsQrWVjIv+RYS+VzjSSmj7RXm6uSQIAWjCEk=;
        b=X5LV306DdtfVtHaREjkJHrW+K+1Xh4tTvzyy2Iu9PFp9ikjMVCheE6c5ofZsMCPyt7
         q6IvHkKGlRyJWztvTVJpff7HkDh5CgZRAMD2vYEil0OJcEeuY+nfmv6iN8IJEQiZykHW
         +XWbU5Wd8cFzsrcWsyJ/5edl85xGfd69mGjC2vK4T/LolWj7O9poBkFfPWMYpj7/BGSL
         5DEI+zkQrANEab6U/0J3dGqmcDd34CXvE0sgPvdTzbpt9y212PYrBy1O63hplriPZ194
         BhA14kot4BpdY960Q4pb5mi3My/ko27Ramya+6jNqzhvlJiXAtyh8mtMoPy2zMYeE3RU
         j8Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=JFKlJ2MGsQrWVjIv+RYS+VzjSSmj7RXm6uSQIAWjCEk=;
        b=roha+h1UrYYvIk3lcW/0jAwI3Oa/I9ZUh6RNhoZ3XF8xzxMMxaTB7xNoCwLkHoNM/G
         18j4dHYP3OFDIzkobTM9dFKfE+PdCLpGyStMZXUUvfDXuR9Hl6SyrikkRpd02j1bQybo
         lBO3yKv34astjNPlp+IAWu2KCLDD46aCTpv2BSujJMCoqh8UulzX4ya+1zEVkdDf0BgW
         hAqVV28j7frrRmVz+4hgKZ7dRN3eQ1D9R7kVFjQfqvpplYTqZhDgeH3XAbUZjA5ez/C+
         3p0bBW2WU2lUhL1/zqUABS1LShP77LVauxNNlpj1nIxWOSOJg2z2QufTisFJtXAehBXq
         Nl1g==
X-Gm-Message-State: ACrzQf2N7zyZsDLH43THJlllQMnvV8zcJmcCZO3fQW89All6QjY+fScS
        btL+eoFX2TnrJE1FbqDOm1nLAGLsk7VKYA==
X-Google-Smtp-Source: AMsMyM4KWVOWdHPs8fZGMGtuhaNdRXe8EIjCH8VsPFahea+1GYGLkZvfEiG+qLeiMf2MKgMiXuVemQ==
X-Received: by 2002:a17:90a:8906:b0:202:d763:72ab with SMTP id u6-20020a17090a890600b00202d76372abmr25343966pjn.56.1664209393293;
        Mon, 26 Sep 2022 09:23:13 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c37-20020a631c65000000b0043949b480a8sm10804820pgm.29.2022.09.26.09.23.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 09:23:12 -0700 (PDT)
Date:   Mon, 26 Sep 2022 16:23:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM: x86: First batch of updates for 6.1, i.e.
 kvm/queue
Message-ID: <YzHR7I2CIzT9itFp@google.com>
References: <YypJ62Q9bHXv07qg@google.com>
 <CABgObfY5VRxSfKX_EoubCdaimDAhvdnZ8NhgZZXRVnQFmboi8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgObfY5VRxSfKX_EoubCdaimDAhvdnZ8NhgZZXRVnQFmboi8Q@mail.gmail.com>
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

On Mon, Sep 26, 2022, Paolo Bonzini wrote:
> On Wed, Sep 21, 2022 at 1:17 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > First batch of x86 updates for 6.1, i.e. for kvm/queue.  I was planning to get
> > this out (much) earlier and in a smaller batch, but KVM Forum and the INIT bug
> > I initially missed in the nested events series threw a wrench in those plans.
> >
> > Note, there's one arm64 patch hiding in here to account KVM's stage-2 page
> > tables in the kernel's memory stats.
> 
> Thanks, I didn't get a respin so I just rebased to remove the problematic
> commits.

Sorry, was planning on getting that done today.

> >   - The aforementioned nested events series (Paolo, Sean)
> 
> Applied on top.
> 
> >   - APICv/AVIC fixes/cleanups (Sean)
> >   - Hyper-V TLB flush enhancements (Vitaly)
> 
> These should wait for 6.2.

Agreed, I was overly optimistic in hoping the series wouldn't require additional
changes.

> >   - Small-ish PMU fixes (Like, Sean)
> >   - Misc cleanups (Miaohe, et al)
> 
> These can be in a separate pull request.

I think it makes sense to grab a few "safe" PMU fixes from Like, but for everything
else I'll wait for 6.2 as well.

Thanks!

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 755C153644B
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 16:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352785AbiE0Olm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 10:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352061AbiE0Olg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 10:41:36 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7360C54F9D
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 07:41:35 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id w3so4298630plp.13
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 07:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JPPq8h1B4bEGushaFSAYcIViRYdKUAavl2MPbSmUKI8=;
        b=TBGs7rcCR2uKAlmWhfZhRnVlVmZim8DZA2VsubM9QO+mQdhhgIYNKz2sZvbdxshMs7
         jhbVzSCn6ww4oiLiGf6fKY6sA+A2zMuWRv/aX+tKoc36J5gYkInezAnrUqenHDwt2s+W
         mDUG08v7amdK+kixiQz27IN/cGQWfJfckLS3xp4FQzrhWj5OE0xdQL/l2PSiR5lh2BU/
         7oScyb+u16VOYU+LnNhyBAzJht79ps3sPi9bED+lq+OfejnNz1h4Jcft0CXsy22/1ycn
         ptbkJOaZB1iPGOdgWF1W3h+B2fXnXbJsbK8zaZKGYR7vZ04LmyYYp7lZrh2CWPVgbyIY
         rbWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JPPq8h1B4bEGushaFSAYcIViRYdKUAavl2MPbSmUKI8=;
        b=lBqscpnYoUvkmqkv9akVuVsH2TVGh6UB2cBiSiIP62a6NVgDK23AxlYoYRg+0KSeno
         9hNiIp5Dt1pOESoK/Y/UdES/nugL2x6WoHeK5S3y4mQPvtXE8A6j17/8Jj98XIdVXEVN
         YhI9+rUszwcog2uqSW8D8GMZrDqOtTXQ55Q0sJpi13f/0Il48jEk/fMiML3+EEh5J+dF
         KM5wFNqOD/6vYV4b2iWt1s/T3bHOhtfBfwW7H1+6Ii8kc0CUgcPTvIPnwEeZkNcU2fW4
         d/hQFZNWXq7izzuG67ifNjaATglVsRlj4CnuBEnf060RKloF3hIMbiiDLu7Ec2NGBTsL
         Mw2g==
X-Gm-Message-State: AOAM533HraTL/LzdI7whYClkxOAY0KlJRHBtij14pDMDsX1BODr5wzO/
        yZMDqKkFQvnUfLDw3KuxEQQQvA==
X-Google-Smtp-Source: ABdhPJx2fBHzGvW6UAA95BB95r/bLNDwrfY+ykttgjeLgbfhLKuRJjoat/vWv+LHE0VCe4EQDo7dSg==
X-Received: by 2002:a17:902:ecca:b0:161:cad8:6ff4 with SMTP id a10-20020a170902ecca00b00161cad86ff4mr43009627plh.111.1653662494731;
        Fri, 27 May 2022 07:41:34 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u10-20020a170902e5ca00b001619cec6f95sm3788074plf.257.2022.05.27.07.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 07:41:33 -0700 (PDT)
Date:   Fri, 27 May 2022 14:41:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dan Cross <cross@oxidecomputer.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/2] kvm-unit-tests: configure changes for illumos.
Message-ID: <YpDjGdzsX+VHy1R8@google.com>
References: <20220526071156.yemqpnwey42nw7ue@gator>
 <20220526173949.4851-1-cross@oxidecomputer.com>
 <20220526173949.4851-3-cross@oxidecomputer.com>
 <Yo/v5tN8fKCb/ufB@google.com>
 <CAA9fzEFF=fdfV7qE-PU5fMD+XyrskQjvxPbgZ1yyS4fRTeBO2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9fzEFF=fdfV7qE-PU5fMD+XyrskQjvxPbgZ1yyS4fRTeBO2g@mail.gmail.com>
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

On Thu, May 26, 2022, Dan Cross wrote:
> On Thu, May 26, 2022 at 5:23 PM Sean Christopherson <seanjc@google.com> wrote:
> > Why not simply move the check to run_tests.sh?  I can't imaging it's performance
> > sensitive, and I doubt I'm the only one that builds tests on one system and runs
> > them on a completely different system.
> 
> `run_tests.sh` already has the test. Changing it to a warning here
> was at the suggestion of Thomas and Drew.

Ah, hence the earlier comment about removing the check entirely.  Either works
for me, thanks!

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F1C6E4E07
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 18:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbjDQQJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 12:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbjDQQJC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 12:09:02 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9343F659D
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 09:09:00 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1a273b3b466so477275ad.1
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 09:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681747740; x=1684339740;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jVbeyzgsNcrqesMaVtP5RhdMEl2wfubFqKSuuoHqnmQ=;
        b=lkFRW3i70XvQOYBgKuQALhJ/cAfIQhCwin7kREDm8G68nJ0qn4FbAITqT8UxMq+suu
         3/EMnv/8qJpyLvrUUcoeuquTUjIltpqWZExaKa/+55GkgiAGYqqwzU5bED83zwgSTS1G
         60xGUGsftld/Ly2y5p9UHHwptSd7aXCEmvQJ/FyQY30nxOM08EH9e/oEJEtJmbuWLFu1
         DEHRuo7JocNKmmrPN45TIhOJA5PSSFj1skfMoZM3dzduRCIvm51mcj6rA5uuhmHQC365
         QhxeiTtHNHleX4CIbLVH2lv6siGOZZp92MTfNij2PKCvdvYmkzxZESDtw4CQwgCLz0eS
         R0RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681747740; x=1684339740;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jVbeyzgsNcrqesMaVtP5RhdMEl2wfubFqKSuuoHqnmQ=;
        b=QF1wZi5EKfKdFCn5febWcwKpyadZdDeuV3HelvZZBD3zgqroI0RPuT9+bLAU5Jdu1j
         9eMqe9NGv9dg/9GtMmq4j5sXbDC3Bh3xBvSyaETZ+A8ugRtH4KmThEYVaRC4DtBo1KUm
         Wl4iksDaMDQak757VXMDXIrSbRKbqDgXoLlfwuGNiT4rQLObh+lFMG4BbhUpYRQnwlwk
         CgSmwTraC6CzgRbJ1HEdKyIdeysLzVAZNy0lJTrEvKBLPxT/CenEXj6TcuNjF7yiXMi1
         7ZVgCG1bhO/6pNSOWe1i8w0lZxCNFcgD/9h0GPZa8z+bbQIXU7ZhAffOxgSX/96HL6m1
         WN5w==
X-Gm-Message-State: AAQBX9dt+B8gb+A2f70C1z8qRJWjaIp8/fwXzlh4KEf+x4hHa22nZfNS
        doy5RZlwQsYKmRuyUQQ3DeXprq1GtvKW160CTQ1NRA==
X-Google-Smtp-Source: AKy350abhyf+u5tr+uctoHG7DvlMRYLV758Z69Tyqkakar4EhCYoUJ2OETsv3cXSTFYFNJllD6McWw==
X-Received: by 2002:a17:902:6505:b0:19a:c659:e1cc with SMTP id b5-20020a170902650500b0019ac659e1ccmr507398plk.2.1681747739742;
        Mon, 17 Apr 2023 09:08:59 -0700 (PDT)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id z17-20020a17090a541100b0024739d29252sm5595747pjh.15.2023.04.17.09.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 09:08:59 -0700 (PDT)
Date:   Mon, 17 Apr 2023 16:08:56 +0000
From:   Aaron Lewis <aaronlewis@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 5/8] KVM: selftests: Add vsprintf() to KVM selftests
Message-ID: <ZD1vGBz9FuKWKKGl@google.com>
References: <20230301053425.3880773-1-aaronlewis@google.com>
 <20230301053425.3880773-6-aaronlewis@google.com>
 <ZBzLpk/FXjhTJssQ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBzLpk/FXjhTJssQ@google.com>
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

On Thu, Mar 23, 2023, Sean Christopherson wrote:
> On Wed, Mar 01, 2023, Aaron Lewis wrote:
> > Add string formatting support to the guest by adding a local version
> > of vsprintf with no dependencies on LIBC.
> 
> Heh, this confused me for a second.  Just squash this with the previous patch,
> copying an entire file only to yank parts out is unnecessary and confusing.
> 

Sure, I can squash them together.  I thought doing it this way would
make it easier to review because you have a diff against the original in
this series.  If that's not helpful there's no point in having it.

> > There were some minor fix-ups needed to get it compiling in selftests:
> >  - isdigit() was added as a local helper.
> >  - boot.h was switch for test_util.h.
> >  - printf and sprintf were removed.  Support for printing will go
> >    through the ucall framework.
> 
> As usual, just state what the patch does, not what you did in the past.
> 
> >  #endif /* SELFTEST_KVM_TEST_UTIL_H */
> > diff --git a/tools/testing/selftests/kvm/lib/printf.c b/tools/testing/selftests/kvm/lib/printf.c
> > index 1237beeb9540..d356e55cbc28 100644
> > --- a/tools/testing/selftests/kvm/lib/printf.c
> > +++ b/tools/testing/selftests/kvm/lib/printf.c
> > @@ -13,7 +13,12 @@
> >   *
> >   */
> >  
> > -#include "boot.h"
> > +#include "test_util.h"
> > +
> > +int isdigit(int ch)
> 
> static?
> 
> > +{
> > +	return (ch >= '0') && (ch <= '9');
> > +}
> 

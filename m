Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E91E5B36C8
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 13:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbiIILxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 07:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbiIILxi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 07:53:38 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72651135D7F
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 04:53:36 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id u9so3415386ejy.5
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 04:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=vB66b24g0hSLZ6Pt3TfniC0l853mYLIK5ti4vMkqfx0=;
        b=Nt6dwMAQBJbbwBfewC1DcWh+mMmy3lOTBa91c7X6eJ7aJZJ6XqSIfxjL49kPTjmuEF
         7SrMVEdqCWPKq9AB1fqD9ggzlnQQn2xWwOWShy6NBmymVWcfyFLvphUr5u4F/HY9emFd
         Tf2HPq4I/ysoofY57sQ3YKu3QJeMEnutetoW8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=vB66b24g0hSLZ6Pt3TfniC0l853mYLIK5ti4vMkqfx0=;
        b=Dj5L5w8nD/SckG7e9nVd4NOZ2lQypGSK3S6xC1NqU03RYFspEJHdG/SHNjJXUdFk9d
         P9FiQJlWkRoKwNGG7NSO0EF5Eck5HHML89fyS/rVM9qYRqODIhzqgRxuS0eZvV2kCb5w
         iyB9cBY/ECqqNurSyOaSVqtenP+BlCqRLdPbATQ1dZMjWbVNomWZZbSwHG1kFN8pAEb0
         VJqYF7CQTztfrRz55RihIChYaZBk8p6POQEX7Ff+evTjmT686Fy9sX5VmxTVBvU/YfT5
         AdodMdd1NBZmSKw4/AYFWLZF1PfvTYBRf9e8HAkHSDe12M2wGCpfQdvD+OOy6izqfzwA
         RhVw==
X-Gm-Message-State: ACgBeo1X1X1mi4mKgfkCt0bHOJbLjLuSEPmo2Q5b9MYGIUX8EzUH5w9X
        X1nTf6Y3qDetu8BcmAzMch9xpjjMhJkCOoli
X-Google-Smtp-Source: AA6agR6uh9qkCXpwofcRVJ10VzvGF1+CSXEG728ZLNID9iYubHi1GH7xKHHgjyYw+uOY/E/3PtYe+Q==
X-Received: by 2002:a17:907:6da1:b0:73d:877d:c56c with SMTP id sb33-20020a1709076da100b0073d877dc56cmr9718442ejc.342.1662724414732;
        Fri, 09 Sep 2022 04:53:34 -0700 (PDT)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com. [209.85.221.53])
        by smtp.gmail.com with ESMTPSA id bm21-20020a170906c05500b0073ce4abf093sm140905ejb.214.2022.09.09.04.53.33
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 04:53:33 -0700 (PDT)
Received: by mail-wr1-f53.google.com with SMTP id d2so2352976wrn.1
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 04:53:33 -0700 (PDT)
X-Received: by 2002:a05:6000:1a8f:b0:228:e3c3:679 with SMTP id
 f15-20020a0560001a8f00b00228e3c30679mr7132453wry.281.1662724413325; Fri, 09
 Sep 2022 04:53:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220909045225.3a572a57.alex.williamson@redhat.com>
In-Reply-To: <20220909045225.3a572a57.alex.williamson@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 9 Sep 2022 07:53:17 -0400
X-Gmail-Original-Message-ID: <CAHk-=wj3rrkPvPJB_u4qoHK4=PVUuBHKB67f_oZO62EE22pNPQ@mail.gmail.com>
Message-ID: <CAHk-=wj3rrkPvPJB_u4qoHK4=PVUuBHKB67f_oZO62EE22pNPQ@mail.gmail.com>
Subject: Re: [GIT PULL] VFIO fix for v6.0-rc5
To:     Alex Williamson <alex.williamson@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 9, 2022 at 6:52 AM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> VFIO fix for v6.0-rc5
>
>  - Fix zero page refcount leak (Alex Williamson)

Ugh. This is disgusting.

Don't get me wrong - I've pulled this, but I think there's some deeper
problem that made this patch required.

Why is pin_user_pages_remote() taking a reference to a reserved page?
Maybe it just shouldn't (and then obviously we should fix the unpin
case to match too).

Adding a few GUP people to the participants for comments.

Anybody?

            Linus

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73BED3737B6
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 11:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbhEEJlR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 05:41:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30875 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231494AbhEEJlQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 05:41:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620207620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u6KBu7aHasKqgWwazHoVN54CeHN25mFYlkhheFdm9C0=;
        b=SZzSI5BNqhAjaPxzZcXcPRtCdlNpZ1BG+Qg0VDiR0NuaW7m9jnlc8cm5YvaPTqI2AN9HtF
        Uo1JHc8Rp3pHempHX6xY7tBXn6IqHUMr8xgoeqLWibLZBmvHtc3nJ2sBysIE37p677noGG
        Lky3RTnrsMLX+LQCsG2fb167sXZ22xk=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-zeMpk6FfPnO8Wqzh1-vMyA-1; Wed, 05 May 2021 05:40:18 -0400
X-MC-Unique: zeMpk6FfPnO8Wqzh1-vMyA-1
Received: by mail-ej1-f69.google.com with SMTP id bx15-20020a170906a1cfb029037415131f28so244319ejb.18
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 02:40:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u6KBu7aHasKqgWwazHoVN54CeHN25mFYlkhheFdm9C0=;
        b=JLvQ0nIAxIcxVeQFTx2kwXSVC0I+sY76n6sqBDg2SDiYszH4URjSKHk+0PqfsRE4Xq
         /RU2qeRuiiHJY80VcuPHVoVS8dtk97C5JYhFVAScKsCxHCQBBZfD42SAONIkGDcUQRc3
         7JGOZj1UzpWMaLA3inVj9R9Uw9lZSEkmATxbSOrlC0VGcmE+e+F2ZHFls5pk5TLz/d6o
         72UKMZaNI9D4zq0ncLO7JHay4ZWWCnFSyNl0EUNkXLva67N7rkKreOvYMmQzj9MKdUk8
         7Lp/8QIqs/x0h0PHLZ5d7TTKA9xNDiYFpeXfpR3Cb0egFBAuxLXh0smsNZDj+xJlI04j
         k1Gg==
X-Gm-Message-State: AOAM532Na2jrBXNDudDqFQbzy2MIC4f4wzSutI7E0nJcJsvy7kylViPM
        Z287/miyw+0mRcyUJl8i9xv5GlkQQRIKJrGmv9f9OIDbrW21hJ0IOhOrLuo1/NABVJNRpKEc51u
        bLXQXy9Em7lVN
X-Received: by 2002:a17:906:2e17:: with SMTP id n23mr27037692eji.266.1620207617073;
        Wed, 05 May 2021 02:40:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygP1+3b8mE6aHVZIc9snR5pppl00aDCntPFGJzSHLzkBPzAvPO8An/W4LetTgP0eOKQtI5hw==
X-Received: by 2002:a17:906:2e17:: with SMTP id n23mr27037671eji.266.1620207616833;
        Wed, 05 May 2021 02:40:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b8sm2601778ejc.29.2021.05.05.02.40.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 02:40:16 -0700 (PDT)
Subject: Re: [kvm-unit-tests GIT PULL 0/9] s390x update 2021-05-05
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
References: <20210505084301.17395-1-frankja@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3b084b6d-4de3-4bdb-6ce6-ada5d2bbc0b3@redhat.com>
Date:   Wed, 5 May 2021 11:40:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210505084301.17395-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/21 10:42, Janosch Frank wrote:
> Dear Paolo,
> 
> please merge or pull the following changes:
> * IO extensions (Pierre)
> * New reviewer (Claudio)
> * Minor changes
> 
> MERGE:
> https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/7
> 
> PIPELINE:
> https://gitlab.com/frankja/kvm-unit-tests/-/pipelines/297509337
> 
> PULL:
> The following changes since commit abe823807d13e451ca5c37f1b5ada5847e08084f:
> 
>    nSVM: Test addresses of MSR and IO permissions maps (2021-04-22 11:59:25 -0400)
> 
> are available in the Git repository at:
> 
>    https://gitlab.com/frankja/kvm-unit-tests.git s390x-pull-2021-05-05
> 
> for you to fetch changes up to 7231778d3773f70582e705cf910976c79138d0c9:
> 
>    s390x: Fix vector stfle checks (2021-05-05 08:01:45 +0000)
> 
> 
> Claudio Imbrenda (2):
>    s390x: mvpg: add checks for op_acc_id
>    MAINTAINERS: s390x: add myself as reviewer
> 
> Janosch Frank (1):
>    s390x: Fix vector stfle checks
> 
> Pierre Morel (6):
>    s390x: css: Store CSS Characteristics
>    s390x: css: simplifications of the tests
>    s390x: css: extending the subchannel modifying functions
>    s390x: css: implementing Set CHannel Monitor
>    s390x: css: testing measurement block format 0
>    s390x: css: testing measurement block format 1
> 
>   MAINTAINERS         |   1 +
>   lib/s390x/css.h     | 115 ++++++++++++++++++++-
>   lib/s390x/css_lib.c | 236 ++++++++++++++++++++++++++++++++++++++++----
>   s390x/css.c         | 216 ++++++++++++++++++++++++++++++++++++++--
>   s390x/mvpg.c        |  28 +++++-
>   s390x/vector.c      |   4 +-
>   6 files changed, 568 insertions(+), 32 deletions(-)
> 

Pulled, thanks.

Paolo


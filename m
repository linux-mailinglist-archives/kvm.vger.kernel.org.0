Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4862F274F1D
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 04:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbgIWClw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 22:41:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54436 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727267AbgIWClv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 22:41:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600828910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cRJ5CFj5OtmkqKWFLpUeJucgnj77XgoLW1oKHADwyBo=;
        b=RQpOrDYqqERwjoEZTCEXJ5Z63jK4760M3rj0vZxrziXCuAoFUAN1AWULvmzba/wZG3+T4a
        yVp8gxEB9H0Kc+LyPeit3nyBYetCUCkIY4dnVr7zaDO0p6kew8c/pk5Agm3SRx3MIbbX58
        YDDMRGdYOcn+RiYYTp1myuh6Pls1F0g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-0sjAt93aNoCDbuOgrQ8fGw-1; Tue, 22 Sep 2020 22:41:48 -0400
X-MC-Unique: 0sjAt93aNoCDbuOgrQ8fGw-1
Received: by mail-wr1-f72.google.com with SMTP id l17so8162179wrw.11
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 19:41:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cRJ5CFj5OtmkqKWFLpUeJucgnj77XgoLW1oKHADwyBo=;
        b=IwhpHrQpJuBIJV9RfwhjII+1sQmrXCbxPs5xxIVqFlt7m0yN9Vd1iHXpkDWxPYn2j4
         MVQyc/lYKZejJIo45H2yXAju7vNZxMl8lV/Hp+k5db0tycdGPTXjcCUwvBjBvwpvkGIb
         MvAdl3rhVB3QzozhU/s79bkh3iCH5S40YYXSPxLW43ZYojy/D8BU04kSAJy/Pq1CU9PK
         PPNLs6R7ofINWUvgGmc03mgZ2YQ/qtrQQV0OHD0+1L+5Q53BwQLeoxvPajqrMfT1L/rD
         QTwlgBAEGCJ66UObftcgUiDp6dtWYnNRTEm1fOpf2WDgLAsc1hcgYpawwiMRyRgVXUKS
         trjA==
X-Gm-Message-State: AOAM531t5mV3qutyYeDgcdfDtKcTXnhgHxikfeW29Rg6byKTP7IhDUMW
        fE00qLCdgNcJ/mwzYmyEomHG23dgv6ALEagOmJrqdZyA43MTQG2cfMd7OwpIGITzXI78tIVwSMZ
        QJyp2V/BmBHCi
X-Received: by 2002:a05:600c:2146:: with SMTP id v6mr3801209wml.159.1600828907334;
        Tue, 22 Sep 2020 19:41:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMrgPaD5qDkqPfD7j2mIsQGN+T9hxbW00+wF+3B1qCAGn3ISG/co3VGmM5nPGaBhPb2xyhHQ==
X-Received: by 2002:a05:600c:2146:: with SMTP id v6mr3801199wml.159.1600828907098;
        Tue, 22 Sep 2020 19:41:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:2eaa:3549:74e8:ad2b? ([2001:b07:6468:f312:2eaa:3549:74e8:ad2b])
        by smtp.gmail.com with ESMTPSA id y1sm6413022wmi.36.2020.09.22.19.41.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 19:41:46 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 06/10] configure: Add an option to
 specify getopt
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        Cameron Esfahani <dirty@apple.com>
References: <20200901085056.33391-1-r.bolshakov@yadro.com>
 <20200901085056.33391-7-r.bolshakov@yadro.com>
 <922fee6f-f6d0-b6cd-c9b7-63ad5e3a004c@redhat.com>
 <20200922215128.GB11460@SPB-NB-133.local>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3f7e0397-9ace-29b0-6edb-ad5b4e94c9ec@redhat.com>
Date:   Wed, 23 Sep 2020 04:41:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200922215128.GB11460@SPB-NB-133.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/20 23:51, Roman Bolshakov wrote:
> Homebrew doesn't shadow system tools unlike macports. That's why the
> patch is helpful and the error below can be corrected automatically
> without human intervention. The error in the proposed below patch would
> still cause frustrating:
> 
>   "ugh. I again forgot to set PATH for this tmux window..."
> 
> May be I'm exaggarating the issue, but I don't set PATH on a per-project
> basis unless I'm doing something extremely rare or something weird :)

When I was using a Mac (with Fink... it was a few years ago :)) I used
to set PATH, COMPILER_PATH, MANPATH etc. in my .bashrc file.  Isn't it
the same?

Paolo


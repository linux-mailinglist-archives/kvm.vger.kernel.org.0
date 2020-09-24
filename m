Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F862777A0
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 19:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728577AbgIXRV1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 13:21:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25873 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726915AbgIXRV1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 13:21:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600968086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ub32XnFXc975QGS1VzDjd2TeiN7AjFEEHdpOR0ESm/k=;
        b=I+nptxIhtS9QbKh9m61DbFicrKhsuy1+2s7Kdz1WK9MOM87OZlYFes8K4NkA/9ZbOSl8SK
        vVO/bVQ0hcEH42c7TBgT5s8nKha4emMOO77pZbFAdX+4TZVmVh7cDZXmBBYKnRkc51YUmG
        lE7m3j2iBab58PTVEpBAi/nJa1xJIAc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-a3K4iQMBMo-fDCCoPVXzkA-1; Thu, 24 Sep 2020 13:21:24 -0400
X-MC-Unique: a3K4iQMBMo-fDCCoPVXzkA-1
Received: by mail-wr1-f70.google.com with SMTP id a10so1475660wrw.22
        for <kvm@vger.kernel.org>; Thu, 24 Sep 2020 10:21:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ub32XnFXc975QGS1VzDjd2TeiN7AjFEEHdpOR0ESm/k=;
        b=U45DbVIBBafeIVW3mka0JWb0XEN3uMe9g0vXzMXVS17U4z9nkxIBP9ffl/mqF9lWrA
         Mg68mz2+GnH/9E6nDskA2Uul9WsEwvlVtF3+rzukJNpGpnUqd+rg5ptoWoSLs+RCr1cl
         FFw1yQN5fjqtQ+oQ6wyQlHe0nYtgbFCQmtlbfyZyFFc/y9jiDFI3kmtjua5EyjuJyoMX
         Aq2aJLxd+zfTCCmhLZ/BVQzqqniofpk21eWzMw0zOpYYOL5rsbQwnHHautP6OG9ub9ed
         4DH1vnWILI9Af7QreCkpQW4vPRoJF4HeuWfa5BolDmSCtbf1RTV0TGOdbIqdA0C2bjxm
         uDKQ==
X-Gm-Message-State: AOAM533kkpkAR/pZbzqj0x+WT18DFktQFzantD1jkHy37Uv5tx6BRXZO
        QstR+fw8s1M5C5YrgRqJnfuxaOf1uN8nch5Y9KXjfjSpSJAtPIJVpn15iS05UVR7HJGk1BjtH/2
        UMspLvIKzqhGO
X-Received: by 2002:a1c:b608:: with SMTP id g8mr247535wmf.106.1600968082860;
        Thu, 24 Sep 2020 10:21:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfQ3U7jZKEwhJ25INrOoaOqRTW8OZXaibOuQ4y7JjYbvplavAC+9zImgKK+ufhLvtHwOnbBw==
X-Received: by 2002:a1c:b608:: with SMTP id g8mr247514wmf.106.1600968082554;
        Thu, 24 Sep 2020 10:21:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d80e:a78:c27b:93ed? ([2001:b07:6468:f312:d80e:a78:c27b:93ed])
        by smtp.gmail.com with ESMTPSA id i26sm11695wmb.17.2020.09.24.10.21.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2020 10:21:22 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: realmode: Workaround clang issues
To:     Roman Bolshakov <r.bolshakov@yadro.com>, kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>
References: <20200924120516.77299-1-r.bolshakov@yadro.com>
 <20200924171228.GA85563@SPB-NB-133.local>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ceb8c7de-66bc-f971-e768-9f2742a1d17d@redhat.com>
Date:   Thu, 24 Sep 2020 19:21:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200924171228.GA85563@SPB-NB-133.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/20 19:12, Roman Bolshakov wrote:
> I've noticed that the patch has been applied (thanks for that!) but a
> test fails for centos-7. It has gcc that doesn't support "-m16":
> https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/jobs/755387059
> 
> I'm going to come up with a patch that adds a test for the option and
> fixes the issue for older gcc, then bits = 16 would be used for modern
> compilers only.

Ok, cool!

Paolo


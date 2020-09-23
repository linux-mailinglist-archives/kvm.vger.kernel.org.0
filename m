Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33903274F13
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 04:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgIWChs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 22:37:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39362 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726548AbgIWChq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 22:37:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600828664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vqYQjjyaHIum0kcFKqvXxbjHjnxsMwCfebGsIhW6iUQ=;
        b=SsUd7hDe233iqBRkWFSqYz0V1byStPPHzZFg6Zt+Tz+HDrbL2iieUNpSIk3g3AnersIK2j
        D7yKEYKCb2g7btHHk8udRLupOdlQi1N4AlyYbF8suLCZCnWs5h4Bq7Ner/f2MlB+8rSpVa
        mnMEAKOSuS4PYVMAyt9jk5cARO8dKUg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-sdNeE11dM6Oo_RWmDkfoJQ-1; Tue, 22 Sep 2020 22:37:43 -0400
X-MC-Unique: sdNeE11dM6Oo_RWmDkfoJQ-1
Received: by mail-wr1-f71.google.com with SMTP id a2so8193788wrp.8
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 19:37:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vqYQjjyaHIum0kcFKqvXxbjHjnxsMwCfebGsIhW6iUQ=;
        b=slnk2v4+mVwqaLW9sT4lNlRKgQjToie15PT10wyvQ2waXzf7LAEhXAIs/9WEdyBrtk
         zoPEcnkDG6YHOwndkmjgiG+1pzhtlqLpV97fPlquNHIvsUUr8IPRXXgKc+fzGnNVmtiV
         kc6WPSdjQUt8jTMYtbjtBm3OVPOd5oO1wz9irZjKR+Fa+34N/UvECD9K2yFtfMr/6C3e
         KGRmRGKWYABfG7oyY8HhJNHBm7Klt7vIZk+DKaoXwGXSniODvYFo9YyYBGDt22ztYK/9
         km+oYuYM1iDBl/O0QZE0btEDPBDVtWJyY2gVSTDQ4ernwx2GMhVPBroMf3MwPRzniy4x
         OvTw==
X-Gm-Message-State: AOAM530o350n+X1U2vnPuGWwW9ISEKequODil7ApvJ/c2Toqm0gKIHdo
        skyK/ZO46IbrQRlCwRrz8nUJEZocx+MD9+LzNu3eWE/TBedkBWWHD+7O8N5eXOfBGCJNpTqmkZ7
        6GUO9nJmhEumc
X-Received: by 2002:a05:600c:2183:: with SMTP id e3mr4124829wme.49.1600828661618;
        Tue, 22 Sep 2020 19:37:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyaUjFjyRtAKKdiVD748CWYU7luPWbjuoojKJYsYQkuCCSa3hsiL7o5oZxx8ytKYatjWXYbRw==
X-Received: by 2002:a05:600c:2183:: with SMTP id e3mr4124819wme.49.1600828661376;
        Tue, 22 Sep 2020 19:37:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:2eaa:3549:74e8:ad2b? ([2001:b07:6468:f312:2eaa:3549:74e8:ad2b])
        by smtp.gmail.com with ESMTPSA id u66sm6602677wmg.44.2020.09.22.19.37.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 19:37:40 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 10/10] travis.yml: Add x86 build with
 clang 10
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
References: <20200901085056.33391-1-r.bolshakov@yadro.com>
 <20200901085056.33391-11-r.bolshakov@yadro.com>
 <fb94aa98-f586-a069-20f8-42852f150c0b@redhat.com>
 <20200914144502.GB52559@SPB-NB-133.local>
 <4d20fbce-d247-abf4-3ceb-da2c0d48fc50@redhat.com>
 <20200915155959.GF52559@SPB-NB-133.local>
 <788b7191-6987-9399-f352-2e661255157e@redhat.com>
 <20200922212507.GA11460@SPB-NB-133.local>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6aba01d9-1095-b317-6615-29941febfbf8@redhat.com>
Date:   Wed, 23 Sep 2020 04:37:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200922212507.GA11460@SPB-NB-133.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/20 23:25, Roman Bolshakov wrote:
> 
> Then everything passes in realmode test:
> $ ./x86-run x86/realmode.flat | grep FAIL
> qemu-system-x86_64: warning: host doesn't support requested feature:
> CPUID.80000001H:ECX.svm [bit 2]
> $
> 
> 
> Perhaps it's worth to respin the series.

No, just send stuff on top.  I've now pushed everything to master.

Paolo


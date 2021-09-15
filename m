Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB3D40CF5F
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 00:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbhIOWgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 18:36:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60349 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232626AbhIOWgQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Sep 2021 18:36:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631745296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2aVR2KW9hCZ2kkHP6ld7LFEUvut6M4OyuO1clchMrMg=;
        b=R4hInkYOkv27DXBqKb5zPSMmnfjTy1+rHOIiu90q2JiMKtqNHFezYwBHzXCOPyhp4wN3vC
        wR6JWGbMzTzmPJ6OGYsVJrPqkM0/8w1pWwKBxWkffN8w5LFvQQR7EPgMb05WyJerQ2hP9T
        tb6fHZDe7uAEjIpuykSEv/pxj2iQ+p8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-xI8L57-POvmpiGf4RiKMAg-1; Wed, 15 Sep 2021 18:34:55 -0400
X-MC-Unique: xI8L57-POvmpiGf4RiKMAg-1
Received: by mail-ed1-f72.google.com with SMTP id s15-20020a056402520f00b003cad788f1f6so3117737edd.22
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 15:34:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2aVR2KW9hCZ2kkHP6ld7LFEUvut6M4OyuO1clchMrMg=;
        b=4o4K/CnGaYgcN5h6J2rVe615eMYZ1LSvdIBeO85IauB7fvGKAZ6Zb0IiuFvwSIce0G
         sBUBm/b+Pm1KKxO20oKWRE3pOSNeDL/y3SF/yk4HAoZlMd04SFbSFhKUdQ0I4GeuBsvV
         zB0XdaW5bBHC6CBRvWvrU4jK/K0LlW6Zoo5y/mJ8AUj9vmvbxZAJEqx0M9MCKkkgQcmx
         g+0mXFVpTMKP/npHz6TEW8Mc+phfOV0R2LVhtoDrgD8T7Qio6xqzIsjgHnnBqK96qk++
         5MpgGfPKlUohvRiFSXXntU2jXi1tpDN1RvhmaAPTdeguJpsN6mrM7pOz3v3m+yTH2Ud8
         bJMA==
X-Gm-Message-State: AOAM532N0phjAR/MH96AEeSgP8wnQYFZj/y/eTvYqBDiIAqo5vvgCz3o
        F38jbzsfhiZp3o7SoXAVcuORwkJtl8EMFGM22BEtkpoXhEGqomrEnYLVNMSfggv04i/MGQmxlK9
        I58p3K/ybOhep
X-Received: by 2002:a17:906:4310:: with SMTP id j16mr2605717ejm.48.1631745293998;
        Wed, 15 Sep 2021 15:34:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZJrGZSlvJZDeNAgWKaufqGkjNdb1v/zNXE2aHdxS0gwiV/n++x4BlcgEyz1CR3FsYSoKbVw==
X-Received: by 2002:a17:906:4310:: with SMTP id j16mr2605695ejm.48.1631745293810;
        Wed, 15 Sep 2021 15:34:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id dn28sm573547edb.76.2021.09.15.15.34.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 15:34:53 -0700 (PDT)
Subject: Re: [PATCH 0/4] selftests: kvm: fscanf warn fixes and cleanups
To:     Shuah Khan <skhan@linuxfoundation.org>, shuah@kernel.org
Cc:     kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1631737524.git.skhan@linuxfoundation.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <56178039-ab72-fca3-38fa-a1d422e4d3ef@redhat.com>
Date:   Thu, 16 Sep 2021 00:34:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cover.1631737524.git.skhan@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/09/21 23:28, Shuah Khan wrote:
> This patch series fixes fscanf() ignoring return value warnings.
> Consolidates get_run_delay() duplicate defines moving it to
> common library.
> 
> Shuah Khan (4):
>    selftests:kvm: fix get_warnings_count() ignoring fscanf() return warn
>    selftests:kvm: fix get_trans_hugepagesz() ignoring fscanf() return
>      warn
>    selftests: kvm: move get_run_delay() into lib/test_util
>    selftests: kvm: fix get_run_delay() ignoring fscanf() return warn
> 
>   .../testing/selftests/kvm/include/test_util.h |  3 +++
>   tools/testing/selftests/kvm/lib/test_util.c   | 22 ++++++++++++++++++-
>   tools/testing/selftests/kvm/steal_time.c      | 16 --------------
>   .../selftests/kvm/x86_64/mmio_warning_test.c  |  3 ++-
>   .../selftests/kvm/x86_64/xen_shinfo_test.c    | 15 -------------
>   5 files changed, 26 insertions(+), 33 deletions(-)
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks Shuah!

Paolo


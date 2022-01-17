Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9D0490FAE
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 18:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239403AbiAQReK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 12:34:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:56112 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238108AbiAQReJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 12:34:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642440849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/G6usxaCLe1xmHZejqh+FtqWHLnJ1Grrz6ZIzPO1m+0=;
        b=L+q/mCnXQ53zfAbz17Z9f5/WsF956fwgrs1FixSwv/8o94HriQuDbKt+7dIIbjpkl0WN5M
        hQCMzCy19qZPwdXcFckqOJ8I9vxmQpposiUW1DZae+cgCpJ1gNI7PJcK5byh1iYjVr572/
        2kFdt/rH4Ht9fc3r9Ss2deuG15r15PI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-J_-RVNAtN3mODmmvkcCLPA-1; Mon, 17 Jan 2022 12:34:08 -0500
X-MC-Unique: J_-RVNAtN3mODmmvkcCLPA-1
Received: by mail-wm1-f72.google.com with SMTP id x10-20020a7bc20a000000b0034c3d77f277so293834wmi.3
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 09:34:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/G6usxaCLe1xmHZejqh+FtqWHLnJ1Grrz6ZIzPO1m+0=;
        b=MiQ2D/5viab+ACoJWoumibRkXE5MrG1bweu4xAMriS42mdWGN6ez/6yb9g8YyISaDg
         NXlz8r2wMHkJKjK6zHNe/CRrkrw2evEsSQnt2fNVsbRQ9KQ7rAUF9vcuvf8Z2NrUJ3Xx
         d56E7/6bMQCCjvicBkk0GYOUhRggN8saO0Ze8dXvlODzOKpaGRy/0TybovG/M7Fv5iBu
         sDxdoKOvKYda8QLnmpH95H27bjj3AKkUWOk5ID3Xu2EuQ79EmTtcs4nROEiNuiOW5BYM
         sybgYZocaLa85kPQnX5AGw1CwAXZflKh7SrmITggMzvqbdK8h02Cdblly4k5lSWXCnwB
         KYKg==
X-Gm-Message-State: AOAM530bTvtx0mJOzRZBM42YBQafXa5XxZbckfAr+fhMGz72kP3QtgNM
        08aR5LdRgbxznWiihxhdfMA5a2D1MHxy2c1qiUczay0od0gJIq/5SywW2MQzES0tPpGNMFW6n+d
        CCii0VQDWAeLP
X-Received: by 2002:adf:f789:: with SMTP id q9mr21217521wrp.200.1642440846778;
        Mon, 17 Jan 2022 09:34:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJze1HT2hnHTzVN5pxIxxFtSkaisLMtUxPGwnpavb1+qI5e6NxrUMDFcn+ZIRBYmQzUypXbpPA==
X-Received: by 2002:adf:f789:: with SMTP id q9mr21217505wrp.200.1642440846547;
        Mon, 17 Jan 2022 09:34:06 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id l22sm5741wmq.7.2022.01.17.09.34.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 09:34:06 -0800 (PST)
Message-ID: <578e8bc9-da28-10b3-f84a-2dcd0ae524e8@redhat.com>
Date:   Mon, 17 Jan 2022 18:34:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v3] x86: Assign a canonical address before execute invpcid
Content-Language: en-US
To:     Zhenzhong Duan <zhenzhong.duan@intel.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>
References: <20220117084618.442906-1-zhenzhong.duan@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220117084618.442906-1-zhenzhong.duan@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/17/22 09:46, Zhenzhong Duan wrote:
> Accidently we see pcid test failed as INVPCID_DESC[127:64] is
> uninitialized before execute invpcid.
> 
> According to Intel spec: "#GP If INVPCID_TYPE is 0 and the linear
> address in INVPCID_DESC[127:64] is not canonical."
> 
> By zeroing the whole invpcid_desc structure, ensure the address
> canonical and reserved bit zero in desc.
> 
> By this chance change invpcid_desc to be 128bit in size no matter
> in 64bit or 32bit mode to match the description in spec, even
> though this test case is 64bit only.
> 
> Fixes: b44d84dae10c ("Add PCID/INVPCID test")
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> ---
> v3: update patch description
> 
>   x86/pcid.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/x86/pcid.c b/x86/pcid.c
> index 527a4a9..80a4611 100644
> --- a/x86/pcid.c
> +++ b/x86/pcid.c
> @@ -5,9 +5,9 @@
>   #include "desc.h"
>   
>   struct invpcid_desc {
> -    unsigned long pcid : 12;
> -    unsigned long rsv  : 52;
> -    unsigned long addr : 64;
> +    u64 pcid : 12;
> +    u64 rsv  : 52;
> +    u64 addr : 64;
>   };
>   
>   static int write_cr0_checking(unsigned long val)
> @@ -73,12 +73,12 @@ static void test_invpcid_enabled(int pcid_enabled)
>       int passed = 0, i;
>       ulong cr4 = read_cr4();
>       struct invpcid_desc desc;
> -    desc.rsv = 0;
> +
> +    memset(&desc, 0, sizeof(desc));
>   
>       /* try executing invpcid when CR4.PCIDE=0, desc.pcid=0 and type=0..3
>        * no exception expected
>        */
> -    desc.pcid = 0;
>       for (i = 0; i < 4; i++) {
>           if (invpcid_checking(i, &desc) != 0)
>               goto report;

Queued, thanks.

Paolo


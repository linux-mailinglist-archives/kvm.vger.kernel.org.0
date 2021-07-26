Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C043D593C
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 14:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233787AbhGZLeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 07:34:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45249 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233713AbhGZLeA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 07:34:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627301669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l8qGiQz3VQ7BrS8Z7XwbbqFHsjEr3JqzjnNgGqy5mwQ=;
        b=V+R0vNmsStFvG11SAwzteagd7TpI68+aaa+kgmqZp9oNb/WbgPHQUW3ZvHTwFt+HT6y/MB
        C9CEGQsgAcq9kgmEsxCq3RXuxpNVJWntCR10di1uQ2rmgvcPUda5RYtF7Xgkk4TDGY8xMV
        kOiPpxVPTVCvPgpKhh/aXbPfAvP6tms=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-uJdiJ5TeMDSP3ABAT0GfvQ-1; Mon, 26 Jul 2021 08:14:27 -0400
X-MC-Unique: uJdiJ5TeMDSP3ABAT0GfvQ-1
Received: by mail-ed1-f72.google.com with SMTP id c1-20020aa7df010000b02903bb5c6f746eso2283466edy.10
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 05:14:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l8qGiQz3VQ7BrS8Z7XwbbqFHsjEr3JqzjnNgGqy5mwQ=;
        b=p6+2WsU+Y0H33BttLHpVyFsoXDDWZhq5ZZ+dr3aOr5OMBCutDzm3uiQt5KPzdtvjnW
         RcErlw9YR5pfnjm8WMb5mFKgbo3+97EcQMmv/A0daVIM0rv/jYOJ2XVCXgMo9XGi0Jtw
         u0l56c3LjVN38VcDP2qLdgd+Pcsli6DBe6nWkIbfr9iviC38TiFG1AO7WjmyoNleHwV2
         sZsvw1ld4SmoaCC2F9L+pNLjkBL5xSgL7I/HEPZE6lgVdjmzQQPzzfWad7lpC5G3a7xK
         RzqViomsEcXQJnoXB2ocG0aZMbRPb2bl7ACcaM0aXzJlJPH7pdxVtmHHtOuPbMtaQmNo
         jWkg==
X-Gm-Message-State: AOAM532B9tORbBsMkqQjnq4mpXM5F+GEzHnpKAPyRKk3et4ph+SH8BGK
        /WDxzX60IGONfiWKN8rzeTVp7SoUPKQ5L/oT1rbBOuV0yeNozrAdm8PSpsfjGZsnyD5d6ZhTK7R
        bmZ2lQn9Z60aj
X-Received: by 2002:a17:906:cb8b:: with SMTP id mf11mr16699915ejb.297.1627301666760;
        Mon, 26 Jul 2021 05:14:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2NZQjmaWm/QTte07gegfpOX0ZgghxEic+eXOFALiBVmq37R+ta/ALWSWiHyMd0qZy53433Q==
X-Received: by 2002:a17:906:cb8b:: with SMTP id mf11mr16699904ejb.297.1627301666586;
        Mon, 26 Jul 2021 05:14:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i6sm14083783ejr.68.2021.07.26.05.14.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 05:14:26 -0700 (PDT)
Subject: Re: [PATCH 0/2 v2] Test: nSVM: Test the effect of guest EFLAGS.TF on
 VMRUN
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, joro@8bytes.org
References: <20210719174617.241568-1-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e1549127-8a11-cf5d-6ea3-890cbe14e374@redhat.com>
Date:   Mon, 26 Jul 2021 14:14:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210719174617.241568-1-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/07/21 19:46, Krish Sadhukhan wrote:
> v1 -> v2:
> 	In patch# 1, the new function is now called __svm_vmrun() per
> 	suggestion from Sean. I have also adjusted the commit header and
> 	the commit message.
> 
> 
> Patch# 1: Adds a variant of svm_vmrun() so that custom guest code can be used.
> Patch# 2: Tests the effects of guest EFLAGS.TF on VMRUN.
> 
> [PATCH 1/2 v2] nSVM: Add a variant of svm_vmrun() for setting guest RIP
> [PATCH 2/2 v2] Test: nSVM: Test the effect of guest EFLAGS.TF on VMRUN
> 
>   x86/svm.c       |  9 +++++++--
>   x86/svm.h       |  1 +
>   x86/svm_tests.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 69 insertions(+), 2 deletions(-)
> 
> Krish Sadhukhan (2):
>        nSVM: Add a variant of svm_vmrun() for setting guest RIP to custom code
>        Test: nSVM: Test the effect of guest EFLAGS.TF on VMRUN
> 

Queued, thanks.  However, I placed this in a different test than 
svm_guest_state_test, since that one is more evaluating invalid (or 
silently canonicalized) data.

Paolo


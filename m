Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99711DC871
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 10:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbgEUIY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 04:24:29 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22746 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728481AbgEUIY2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 May 2020 04:24:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590049467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UgPlPKwQ78SmEvwlM+tSnD4eOCAOdkr7Ntl2fCb3Qdo=;
        b=KiS63N3Cn7Czi5DVNZGyjNaxec7dLbyPv4piB4gVvc776I0UdY/hFDUKDkwLBrApkfuT/U
        3FB8opFdS3gpc9WHzuLuJqx+ltoawgPsWDMFqvEQc0uWHdRK70kjlzGu8njB9Rfu59nSYt
        ggQAeYpz9afFTmSC+O3b2rdqJjCxkzo=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-eSQqsfquMReWVVIMDKDYqg-1; Thu, 21 May 2020 04:24:25 -0400
X-MC-Unique: eSQqsfquMReWVVIMDKDYqg-1
Received: by mail-ej1-f72.google.com with SMTP id by8so2472107ejb.13
        for <kvm@vger.kernel.org>; Thu, 21 May 2020 01:24:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UgPlPKwQ78SmEvwlM+tSnD4eOCAOdkr7Ntl2fCb3Qdo=;
        b=No1vcist89ybYMagneKAnnayJ3KbkCaqiPxkNZT3O0qEKiymX7+iNGWz+MdwL31LYH
         zPykcLyvQz8n6w1KltEKgwLvqA+6Yh0a6cavoSyFFkcqLLy4SF3kioHk10bJOj9BIU3O
         0Ku4Q1+Rk+uOwGQMExXRk+kseysWQVPmRjF9jToWmT+zkf4LBE5CGoV4X25f/+sL08k4
         67WwHvkOP86/A/ErOB2DsfUPWuwBVYNP4E5cmgWALq/W24zQYLO1ChrtFR0upCJiL1eo
         K9DMwE6D1bVx8Ln0Pm7flMiBqUp7npvUoQ2ZuzqIZJjXCc+sUS7KNcO9feE4HCu8SYMa
         TXlA==
X-Gm-Message-State: AOAM533ES5t+nIiMAIzLt8B1/seCxkhFbBj+wi2t9aaxP5tKxEnZlXAV
        umOyr4UUb0jByI5jZvea5C2eJHezfZq3GB92vvRViVuFxuPHaqEyXaH+O3EkZIVQfrTqnL5mfLx
        ebD/gNPf3v4kt
X-Received: by 2002:a17:907:9d5:: with SMTP id bx21mr2366552ejc.510.1590049464360;
        Thu, 21 May 2020 01:24:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyoFKBT/y+lQ+LBEKa1W8bfwlzO4IvlNszMAjhIGGbGZEJr2l2PRpnaSFM+8x03wohqDEKpng==
X-Received: by 2002:a17:907:9d5:: with SMTP id bx21mr2366545ejc.510.1590049464136;
        Thu, 21 May 2020 01:24:24 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.94.134])
        by smtp.gmail.com with ESMTPSA id s20sm4204784eju.96.2020.05.21.01.24.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 01:24:23 -0700 (PDT)
Subject: Re: [PATCH 2/2] kvm/x86: don't expose MSR_IA32_UMWAIT_CONTROL
 unconditionally
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Tao Xu <tao3.xu@intel.com>
Cc:     linux-kernel@vger.kernel.org
References: <20200520160740.6144-1-mlevitsk@redhat.com>
 <20200520160740.6144-3-mlevitsk@redhat.com>
 <b8ca9ea1-2958-3ab4-2e86-2edbee1ca9d9@redhat.com>
 <81228a0e-7797-4f34-3d6d-5b0550c10a8f@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <13f16f34-ce01-4207-1d1d-775b15a1e0f7@redhat.com>
Date:   Thu, 21 May 2020 10:24:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <81228a0e-7797-4f34-3d6d-5b0550c10a8f@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/05/20 06:33, Xiaoyao Li wrote:
> I remember there is certainly some reason why we don't expose WAITPKG to
> guest by default.

That's a userspace policy decision.  KVM_GET_SUPPORTED_CPUID should
still tell userspace that it's supported.

Paolo

> Tao, please help clarify it.


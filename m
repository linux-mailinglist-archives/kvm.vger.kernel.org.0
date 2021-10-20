Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAB14347CD
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 11:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhJTJWL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 05:22:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46574 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229704AbhJTJWK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 05:22:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634721596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OHr8I1ADCNyh3IkqXu+kSFGMzNh00bfIZFxOebGZQ0I=;
        b=FtZJ3zLN1OSA49q8dV0he8svyEzuJ+vKXkCCooOmTZuyBg0HuApU/5/ottspFCVUVQkO5m
        XMx52ujXoKjXzsex4OChSx5ZvUQp+WTZMJ3gS8rzew4fy1JGfdmLcLlnggtW2hLAm3/b75
        cQGVRFBbQAfLrA/C9T1/D/cZbVNj3ZI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-5QCD39LOOiSlZBfGH2XlHg-1; Wed, 20 Oct 2021 05:19:54 -0400
X-MC-Unique: 5QCD39LOOiSlZBfGH2XlHg-1
Received: by mail-wm1-f71.google.com with SMTP id d16-20020a1c1d10000000b0030d738feddfso2809962wmd.0
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 02:19:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OHr8I1ADCNyh3IkqXu+kSFGMzNh00bfIZFxOebGZQ0I=;
        b=IT9diiuZixd5Rt1f3N51c10hZGxCLGTUH0eRyExARzy9fv3XB8BjS62B8Ud+KjFvOk
         nYP6P59wKp0Jk6nYvTktcPvp1E8SJZD3FEJJ3OaMSfZNtrtNbMElnN2cby4rdh2PRo4H
         iGW5SQnhR+GIr1vpEwHfpEuQ+qV76qkW4Skv0eQ6QiuYaT5W3lEFcrsgCeHP6GAi1/mu
         RcurilYDUZI3Ru2gOqfpTzNXfh4IfYY6Wm9O0ymBVs9bTuB0rJFodrSGYKI24MegPS92
         36JKamsYFirbAb1ZMncq7omsJrUKBwV/heeoNM8ZKRKXBiKtKw8XmS34IBDDRf/THK72
         QfaQ==
X-Gm-Message-State: AOAM533VVN+xtj7ece5N8mvlcNTotr7Uv8cCA1TZyOAw0l7VavVrIBXJ
        E8r42nAIRnANb+aiRQvx/wbx+8iSlfuZRF4ZS21Lu49vkWTfg1CpUZhLcEfVos3ZUZKg5LUwt3D
        FRjEB12Pc4dzb
X-Received: by 2002:a7b:c4c2:: with SMTP id g2mr6607223wmk.195.1634721593625;
        Wed, 20 Oct 2021 02:19:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyiiYUod6TjDrGOf5rSFm4jDSLEbRAQsvLs/anVGCjrige706yEvHKXxis2/c7BWvlw2Ap7NQ==
X-Received: by 2002:a7b:c4c2:: with SMTP id g2mr6607205wmk.195.1634721593406;
        Wed, 20 Oct 2021 02:19:53 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id p18sm1575475wmq.4.2021.10.20.02.19.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 02:19:52 -0700 (PDT)
Message-ID: <1088c582-8afe-e5f2-8db8-0f0b05a5f7d3@redhat.com>
Date:   Wed, 20 Oct 2021 11:19:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [patch 0/4] x86/fpu/kvm: Sanitize the FPU guest/user handling
Content-Language: en-US
To:     "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Sean Christopherson <seanjc@google.com>
References: <20211017151447.829495362@linutronix.de>
 <841ACA86-CE97-4707-BF6E-AC932F1E056D@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <841ACA86-CE97-4707-BF6E-AC932F1E056D@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/10/21 21:43, Bae, Chang Seok wrote:
> On Oct 17, 2021, at 10:03, Thomas Gleixner <tglx@linutronix.de> wrote:
>>
>> The latter builds, boots and runs KVM guests, but that reallocation
>> functionality is obviously completely untested.
> 
> Compiled and booted on bare-metal and KVM (guest with the same kernel).
> No dmesg regression. No selftest regression.
> 
> Tested-by Chang S. Bae <chang.seok.bae@intel.com>

Same here.  Thanks, Chang Seok!

Paolo


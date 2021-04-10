Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE34435AE09
	for <lists+kvm@lfdr.de>; Sat, 10 Apr 2021 16:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbhDJORB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Apr 2021 10:17:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50569 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234392AbhDJORA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 10 Apr 2021 10:17:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618064205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g/h6iASCFT7PI6TFHd4C/GYcAcCOtlht2UM2//bwyFg=;
        b=VzYM1vflRywK/7L8qdOQJ/L9VDy+zSG5C+RP3SbVijpwGeQypCIKgHESvEym55FuNg5s+q
        Y5rWHSX3rR6COzk88RU24VFjxEfHk3204MbSHdN/Dk2LEPVTJhnxQz+k97CYMpg06tmyRD
        dJfqzVyxMdXtM3iBdyz118+Mo72QpOs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-d6i5jBmEOV2GnpiQ6z2pvQ-1; Sat, 10 Apr 2021 10:16:43 -0400
X-MC-Unique: d6i5jBmEOV2GnpiQ6z2pvQ-1
Received: by mail-ed1-f71.google.com with SMTP id o9so664038edq.16
        for <kvm@vger.kernel.org>; Sat, 10 Apr 2021 07:16:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g/h6iASCFT7PI6TFHd4C/GYcAcCOtlht2UM2//bwyFg=;
        b=YeraEwg//VUDmGxO3k+OQ5Zi1N6TF509FpGKzvI+wuDWF+r+fSVVb21Ga3YHWEL/no
         v7PQ4VaOZJ0WV+ijSUZAmeib410dQs/JDuTV2Q9v3HLN+yfdwUeEWvMezalmwzqNG3BE
         2VxHARxR5BravxZikpDezNJRZLVxBYxBQBRrZLqGi14Ft/G1dPUHIzAy5OfAxNnn08Of
         hCxm4D//pFSaDLbPDGYhIXEXMT5BvkeLEuB1jU1H8LYy7CsPJdlHEX+gArSVGPkHDJAh
         iXvOXCcUAhmAVCUnsyxrz20OF9LHNyS2eygIwptiv/SaB/KbXSuiikwcb7PrVn1VHGNE
         X31g==
X-Gm-Message-State: AOAM531DVNwiwCpFEG6slxTrqypcuAB0//T0s6M38mq3AZ3gj69Bt2js
        GjmPQg06DI8z6GMSXtzZiLL23TknSjFsEVWUFrm2Kd5zHeBxPYJGA0+oHGp+TakykQztKb5mluF
        Pwzhx0fH22pvx9s9BgWPYj3Ym4KR0RNM14nxAbkA7u1Og3B5taeZkIJldn07THsfZ
X-Received: by 2002:a05:6402:4388:: with SMTP id o8mr21794408edc.262.1618064202327;
        Sat, 10 Apr 2021 07:16:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxslZHJ7Dpd5bz1ZPBY/pIDDTDCfSywOWo6wASg7thgmxqZ6H7xrUdfpTkRmsa9Pfhnofs8GA==
X-Received: by 2002:a05:6402:4388:: with SMTP id o8mr21794388edc.262.1618064202092;
        Sat, 10 Apr 2021 07:16:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id r17sm3252734edx.1.2021.04.10.07.16.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Apr 2021 07:16:40 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org
References: <20210409075518.32065-1-weijiang.yang@intel.com>
 <1c641daa-c11d-69b6-e63b-ff7d0576c093@redhat.com>
 <YHCkIRvXAFmS/hUn@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] [kvm-unit-tests PATCH] x86/access: Fix intermittent test
 failure
Message-ID: <7de0a182-df9c-b30e-bcf5-eb9ac7974f9d@redhat.com>
Date:   Sat, 10 Apr 2021 16:16:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YHCkIRvXAFmS/hUn@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/04/21 20:59, Sean Christopherson wrote:
> Would it also work to move the existing invlpg() into ac_test_do_access()?

That would be better but I was afraid of the possible changes to the 
tests outside the big loop.

I'm sending a patch now.

Paolo


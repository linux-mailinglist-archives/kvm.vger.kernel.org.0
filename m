Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3C82A96A2
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 14:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727353AbgKFNEH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 08:04:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53699 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726939AbgKFNEH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 08:04:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604667846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O2OTmrm4NXICgCW64I7iUwsXcweQA4dvBj9jtNWpUdA=;
        b=iJrq/+5klb7zGAlmNzmc9gnTR+N1BbhYMJwpUBu8Sue8ajcYo1Q0SoqAWgad1d8TCpX52K
        5nj8V+sqA9AcvUF1m0fLIshBSUV/S3bAFsJTlC/GKaxZUbsrAFggiTRCgwbAQZMST7aaVu
        U/L+gJkzBOIL2P55sIXYDBzUKhKW40A=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-EW7GTdPZM-WY-1Gz5WlMEw-1; Fri, 06 Nov 2020 08:04:04 -0500
X-MC-Unique: EW7GTdPZM-WY-1Gz5WlMEw-1
Received: by mail-wm1-f72.google.com with SMTP id y26so407873wmj.7
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 05:04:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O2OTmrm4NXICgCW64I7iUwsXcweQA4dvBj9jtNWpUdA=;
        b=N6anKcIsh6fJHY/oPXt+cjW550pCR47D3UX6ymZyV2qr6+GlD2leJV5eEosgf44nHU
         XiW6wFrYb7mTcjuQBL1nDa0nRstJEaHCrHbzNQLsGkaN8rOWPotojxQlDlG1Jco6Jdml
         hOXT3Y9zV7Gi85ECawCp+BHvGawQBbAiHvqLuSVP0gHOL6FV3TbeNxcK18zg738frW4s
         qTfhlQy66aH/GvmnqlmrbGutK9Zg5s25s/SWzOBL+XTwEUzRd10aJlIX2TILRaH8V6MQ
         0d0zEQ9Hu5WTgS3sCwfnDIUdH79hGsj5QDZP0Ecip+T+MNGrcZ+g+cCkbT/8j4eI/EKa
         2OLg==
X-Gm-Message-State: AOAM531Kqn9JlosTXDdsWO6J1m2SRjJkTcnkBAoa3I4XPttKEV412/af
        NtK4CzJJS/Jyv8MSMJvsq+cmXKpNL1F55GxpoNUc2y9X7JYNZS2AcSkaK6F9o0J3uaMjv7EYCwA
        jl841htRit+bg
X-Received: by 2002:a5d:62cf:: with SMTP id o15mr2495158wrv.49.1604667843011;
        Fri, 06 Nov 2020 05:04:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyjuoP8hw6ntDIKEDMvNipQSVOYbuAfe/QZ4gqRHqWcEpvDmrw4idLKOFavKGCxSoX6LTuAQQ==
X-Received: by 2002:a5d:62cf:: with SMTP id o15mr2495136wrv.49.1604667842793;
        Fri, 06 Nov 2020 05:04:02 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id 34sm2465080wrq.27.2020.11.06.05.04.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 05:04:02 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2 3/7] lib/asm: Add definitions of memory
 areas
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com, lvivier@redhat.com
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
 <20201002154420.292134-4-imbrenda@linux.ibm.com>
 <1429868e-2348-e7a3-0668-4fc2439052f2@redhat.com>
 <20201106135830.53f027b5@ibm-vm>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7e739237-612e-3669-1ca6-ad212cd11909@redhat.com>
Date:   Fri, 6 Nov 2020 14:04:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201106135830.53f027b5@ibm-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/11/20 13:58, Claudio Imbrenda wrote:
>> x86 if anything could use a 36-bit area; the 24-bit one is out of
>> scope for what kvm-unit-tests does.
> sure... I went with what I remembered about the x86 architecture, but
> I'm not an expert
> 
> my patch was meant to be some "sensible defaults" that people with
> more knowledge should override anyway:)

Yep, got it.  Though, "why are 24-bit addresses special" (for ISA DMA 
that is only used by floppies and SoundBlaster cards) is actually way 
more for experts than "why are 36-bit addresses special" at this point 
in time!

Paolo


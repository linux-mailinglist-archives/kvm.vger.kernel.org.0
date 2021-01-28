Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9240307D90
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 19:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbhA1SO1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 13:14:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54127 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231527AbhA1SHs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 13:07:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611857181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rLpGMEsWUFtvOGdp4Bl4045lZDRmMlzwwfBz1eKojT4=;
        b=e7graWW/odro6lZVGOPqTa50wLWOVTBHs1RPFCU368FgNwVE/J+3WCPsDBIY8gP6oK+Lxy
        iF8njjBS0Y+wJGPu82f9lvx4jV00Gc2F7EWuttPdOXAmaZSRUzWoikzCODybL0Yvwjo3K8
        ZuOugehiZlQVb/V70vqH2S1gOajxrIQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-7JmswXs1OEazVsk4X8Bs1Q-1; Thu, 28 Jan 2021 13:06:19 -0500
X-MC-Unique: 7JmswXs1OEazVsk4X8Bs1Q-1
Received: by mail-ed1-f69.google.com with SMTP id f21so3585551edx.23
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 10:06:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rLpGMEsWUFtvOGdp4Bl4045lZDRmMlzwwfBz1eKojT4=;
        b=IfuXHH5npomHBiMMG9M25L2/widrgg4SvJJd8YZ9wqRcHJKIZ/2AP5MWE5E19QMb+0
         srMUIiRssUlnBhPB0zY5i5y3QX4vYBX2WGtoackoWtbYkjEVgG0ttwQKBbS23OEDKc2+
         JVF+pYa8RUV1Kg7m65sLvk+Gp6ODSW9yDxyojLr/I0NRmb+XynRrymG4FSreTOEwyr6p
         P2g+iecdqWaP6vBqIaLMkRk7jyBUjBGAP8QjOLFkyXqCbmZ9Dno3zRxvc2WLABVQJI4Q
         0G8U+tKbnqGXrMPNHHGxaOZnOnxM2F6zNZ+JEWdUsbDKCUsWYBUlcUaXsmimQAkCj+UV
         obnw==
X-Gm-Message-State: AOAM532l40MJBwC6aPnE/0aBCg4OX6WdhEtyMbW39JzREt6zRHEOXeCs
        OMqV61vaMdcaXv0G0Jr8o13gZMSY7q8rrvKJlQZP119f3rjEaAtTU8cg/aK2L0vpRpz9rHXnsgi
        4ZckIJdul9Ay3
X-Received: by 2002:a17:906:a48:: with SMTP id x8mr626109ejf.444.1611857177304;
        Thu, 28 Jan 2021 10:06:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzHfUKevTd/4l9Cq7zXQgMsfc9UehVxY6ry045/wWY1PjhtT8vA4WzaKXdxYCtMCcp0FrzTOA==
X-Received: by 2002:a17:906:a48:: with SMTP id x8mr626095ejf.444.1611857177168;
        Thu, 28 Jan 2021 10:06:17 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p15sm2652745ejd.121.2021.01.28.10.06.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 10:06:16 -0800 (PST)
Subject: Re: [PATCH v14 00/13] Introduce support for guest CET feature
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        yu.c.zhang@linux.intel.com
References: <20201106011637.14289-1-weijiang.yang@intel.com>
 <c6e87502-6443-62f7-5df8-d7fcee0bca58@redhat.com>
 <YBL8wOsgzTtKWXgU@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <32c9cdf7-7432-1212-2fe4-fe35ad27105a@redhat.com>
Date:   Thu, 28 Jan 2021 19:06:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YBL8wOsgzTtKWXgU@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/01/21 19:04, Sean Christopherson wrote:
> On Thu, Jan 28, 2021, Paolo Bonzini wrote:
>> On 06/11/20 02:16, Yang Weijiang wrote:
>>> Control-flow Enforcement Technology (CET) provides protection against
>>> Return/Jump-Oriented Programming (ROP/JOP) attack. There're two CET
>>> sub-features: Shadow Stack (SHSTK) and Indirect Branch Tracking (IBT).
>>> SHSTK is to prevent ROP programming and IBT is to prevent JOP programming.
> 
> ...
> 
>> I reviewed the patch and it is mostly okay.  However, if I understand it
>> correctly, it will not do anything until host support materializes, because
>> otherwise XSS will be 0.
> 
> IIRC, it won't even compile due to the X86_FEATURE_SHSTK and X86_FEATURE_IBT
> dependencies.

Of course, but if that was the only issue I would sort it out with Boris 
as usual.  OTOH if it is dead code I won't push it to Linus.

Paolo

>> If this is the case, I plan to apply locally v15 and hold on it until the
>> host code is committed.
>>
>> Paolo
>>
> 


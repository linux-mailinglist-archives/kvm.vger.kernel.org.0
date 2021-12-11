Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B254710A3
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 03:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhLKCTG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 21:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhLKCTG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 21:19:06 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D035C061714;
        Fri, 10 Dec 2021 18:15:29 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id l25so35671471eda.11;
        Fri, 10 Dec 2021 18:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8aqRn2SUIOh4potQe4XVSMC19lM8tBZYzY1tBnkVsCs=;
        b=b3WUs5YMwutlir2ynpVadeN3Rx7ynFx+5P8/+qM4qX40IE/A5GZLHA7Lxg4L4QB3qF
         rOgi6/u0w+9P8j2V1ciMI2nAlDyij0OzKwW8gVr1sjBNgl2GNEw3jMake/ZxAxqXZoto
         k4+qdcSFA52I8KqnKUbf0A6dClrw27bOSvgh/tKvlNsekPecU38MXJFxPnjnvt5xzJLd
         SOCpD7vYHTHLVicMZxBx8Cfh35muNmiTKSthupU4s1K83EbUP3ZZ3s3NissJ7AbyfDSM
         HN958pWmKwI44Ex+WmiHuIJbtxa/JpLTDTzI43YskyX5UAcpOINo2oOzA2qK2PUxTQnS
         EJ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8aqRn2SUIOh4potQe4XVSMC19lM8tBZYzY1tBnkVsCs=;
        b=kG5TrN8ejrGV1OlXGu8yILN0E3NvckusRx8LrqLXZf0rxRGQmOFm0z10fORPiCPkgB
         7VzVNYGlxDNEknkhwLF5zJz2++7vgQcZ8H93umJtEAg9S22KMg/P+8eyF9/Wtl8l+NSz
         o0SLR/C3wytOEqdjIo+sKH2jz/P8Kpdv9E5F1HAP/Rujv/SIbNUuVBxSzjwatq5JHYGB
         qI1CGtL7/Yhg7WAfUToYdZ2R5n8TcM+uxj5KVLz3StEbSFanQrsf90d4V/dKwaYbLRVT
         2zC+lv2hJsftxeGii/dNgzjv9dUcCcsN7EU8eVfLXket+pmrxgrtBRlnNgLGyesXvtmP
         mGCA==
X-Gm-Message-State: AOAM533Md/GCpLz2mO/W4gC0biibynBsDwmrbvP+sodCK2cyzGQNk+/g
        cjZj0B3j4GidOT0YFtBkd+E=
X-Google-Smtp-Source: ABdhPJw1wozLjtvPMMXA+6i0oAY/knATkITAGW+2ToQT/g0ZRbo6rI9Rh7szN3mXoDqa3eFN7q3rvQ==
X-Received: by 2002:a05:6402:5cc:: with SMTP id n12mr44176038edx.246.1639188928473;
        Fri, 10 Dec 2021 18:15:28 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:48f9:bea:a04c:3dfe? ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
        by smtp.googlemail.com with ESMTPSA id y15sm2611084eda.13.2021.12.10.18.15.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 18:15:28 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <438d42de-78e1-0ce9-6a06-38194de4abd4@redhat.com>
Date:   Sat, 11 Dec 2021 03:15:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] KVM: x86/svm: Add module param to control PMU
 virtualization
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211117080304.38989-1-likexu@tencent.com>
 <c840f1fe-5000-fb45-b5f6-eac15e205995@redhat.com>
 <CALMp9eRA8hw9zVEwnZEX56Gao-MibX5A+XXYS-n-+X0BkhrSvQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALMp9eRA8hw9zVEwnZEX56Gao-MibX5A+XXYS-n-+X0BkhrSvQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/21 20:25, Jim Mattson wrote:
> In the long run, I'd like to be able to override this system-wide
> setting on a per-VM basis, for VMs that I trust. (Of course, this
> implies that I trust the userspace process as well.)
> 
> How would you feel if we were to add a kvm ioctl to override this
> setting, for a particular VM, guarded by an appropriate permissions
> check, like capable(CAP_SYS_ADMIN) or capable(CAP_SYS_MODULE)?

What's the rationale for guarding this with a capability check?  IIRC 
you don't have such checks for perf_event_open (apart for getting kernel 
addresses, which is not a problem for virtualization).

Paolo

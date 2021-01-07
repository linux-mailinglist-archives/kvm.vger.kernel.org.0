Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5ED2ED6A2
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 19:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbhAGSUo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 13:20:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58087 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728184AbhAGSUn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Jan 2021 13:20:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610043557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A6HJ7qfwjQQFa0/zX8yYwuKoznigbFaw8YRs3WGQwro=;
        b=J38ERMzR/JKRmKNl1VEJJafEOO8jBydBTrnHYpIDciPzFPLb8mJGIfQ3ZMyzxoST3b+aQs
        jgtWaFV3UHLepQX7Ru4mDSgtlBkI5JozxS1NaCeHjJs/lpdrn/3BKXOAvJeiYDcIKot7P0
        i8hiOKLwwBmPazAZGljghnYJvFJ3ntQ=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-1gVfRejkPLqsSl_M-GTqPA-1; Thu, 07 Jan 2021 13:19:16 -0500
X-MC-Unique: 1gVfRejkPLqsSl_M-GTqPA-1
Received: by mail-ej1-f71.google.com with SMTP id m11so2703998ejr.20
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 10:19:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A6HJ7qfwjQQFa0/zX8yYwuKoznigbFaw8YRs3WGQwro=;
        b=Rxpwn/T3tSuRE+01gLKv3LV62uvKaobpR2PCfWZ6M/1ZGVUBlVwd4oA33ey1dEoTzs
         ss/dESFuwqr6i+/Ql1gNcxeKHqJEdSDXFDTbPVNpyr6+DP+vm3euw7e8h2ccN4rDNip/
         CpruQIsMejAnK7/mA9xwpYbbi0zn5VcIOOXtkqBjiol52SXpWpMz4eUTFP76RqkkN2Yh
         LOAylU+IsugkNVwltoMz7nPp6VMCiQsfOGWP0dG/Qn5T3cTGs6Zdtwecbj6z60aTV7ML
         0q3O0X0ZHyFEhAan619954lEcXrw5UVA0vvhnDyAnI0w+yTZUDXWwi5qZEXtwQB842pF
         guwQ==
X-Gm-Message-State: AOAM533ho1131spXP6SzAxyQ00ASvuWsgsSRwV9ksQb8/aOfqLdEl/AZ
        hcRq6KYkfUf2B7GjIDc3uLHxEaYIxXYwnhNJHK1lnfs9chMy8gM+9Eb/y4+bj6JfaiitjIx3C0y
        8F9Zzh7ukIg/U
X-Received: by 2002:a05:6402:46:: with SMTP id f6mr2564910edu.163.1610043554874;
        Thu, 07 Jan 2021 10:19:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJygSyi78s9OkXtGMdK1CXDasTKhjxLxjzYadK664iqRG7NLG5/QFZWbRvoitnHe38sdxlcZOg==
X-Received: by 2002:a05:6402:46:: with SMTP id f6mr2564897edu.163.1610043554745;
        Thu, 07 Jan 2021 10:19:14 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r18sm2947955edx.41.2021.01.07.10.19.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 10:19:13 -0800 (PST)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.11, take #1
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Qian Cai <qcai@redhat.com>,
        Shannon Zhao <shannon.zhao@linux.alibaba.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20210107112101.2297944-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9d523a25-aaf0-32f0-d03c-b26115c77e79@redhat.com>
Date:   Thu, 7 Jan 2021 19:19:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210107112101.2297944-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/01/21 12:20, Marc Zyngier wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.11-1

Pulled, thanks.

Paolo


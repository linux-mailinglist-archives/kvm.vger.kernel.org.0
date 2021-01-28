Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B28F307D6C
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 19:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhA1SHd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 13:07:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20884 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231461AbhA1SE0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 13:04:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611856980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LWWNoe1Kl8O/5xgq3+qKNWzE/mKzopSaV6Z4yzkSMwk=;
        b=GHoxULF17MV/x8Oy2AqosqfazJE79tLgFPmL4/U3V9wsfK2F4DmHTWLLtZ0vplL3Ywuovj
        4sMimJS4r+b2w2xSKnBjmjBSv/rmjIbYus3K9xengkHNV8bKbPGGqKgJWTxdRrt2sm90nF
        7OxgHoNgLxfAzto2PWAb55ltqCMPmv0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35--Z2xudwpOOGbM4TGtsPkaA-1; Thu, 28 Jan 2021 13:02:58 -0500
X-MC-Unique: -Z2xudwpOOGbM4TGtsPkaA-1
Received: by mail-ed1-f69.google.com with SMTP id ck25so3539612edb.16
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 10:02:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LWWNoe1Kl8O/5xgq3+qKNWzE/mKzopSaV6Z4yzkSMwk=;
        b=plhSoD9wiXbR4mTLSVhT3/diq1BC44W91eswnw8LBZ6xAeqKzOPf4C/Q+w6FQVFDNn
         LSCUKnOAyZ0BixxGH+kD4xMZC+AJFSiNvfNAeAeADgpBJd0dvZ0Hbf2YdWEpEXuJ+tGN
         BU4mMd/dWwit9iOSByNjtNrbi2WOVelNPcX2QOXjUxcqjkOjRxwfhjNopj6n81J3GQbq
         QhC+3I4OMnUfrcJ3JbMiOcLOUYUSZFrvW4+Dv0ZUOl6Vp/ECgPTeAyn+z8gPT9pna4GV
         i680q4JcuNHCdP8ZSA++acjgnis40G5tm6g5qy0Ncos84MPmuPq7orAHO/jBF7DqWuOH
         NAeQ==
X-Gm-Message-State: AOAM532ZFrTH0GrHe8oUhxLVPwdSzo+kwuADJzvs4G5ZMPIknEz+ZEko
        UlxOnO/elSJs0LNoajWKYR3k3ojg18sI8TStDC+1kOgWoGUJKbINFjGRzScqFjuBncfhuO5yOPL
        QKxDKZ2HLL8uG
X-Received: by 2002:a17:906:447:: with SMTP id e7mr635633eja.172.1611856977124;
        Thu, 28 Jan 2021 10:02:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJynZACnAFdmDQ6RsE2ukS8Kfxeu82Y0UYa5PGs5IJ3GI2SC/eCgyP4bYCf+CPUcppXGumVtiw==
X-Received: by 2002:a17:906:447:: with SMTP id e7mr635616eja.172.1611856976990;
        Thu, 28 Jan 2021 10:02:56 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id dm1sm3322486edb.72.2021.01.28.10.02.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 10:02:56 -0800 (PST)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.11, take #3
To:     Marc Zyngier <maz@kernel.org>
Cc:     Andrew Scull <ascull@google.com>,
        David Brazdil <dbrazdil@google.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
References: <20210128175830.3035035-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <32fac3c7-0141-d303-7412-cd8c3a8ae039@redhat.com>
Date:   Thu, 28 Jan 2021 19:02:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210128175830.3035035-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/01/21 18:58, Marc Zyngier wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.11-3

Pulled, thanks.

Paolo


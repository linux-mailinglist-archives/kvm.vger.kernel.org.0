Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6982F2EF067
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 11:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbhAHKF3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 05:05:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35731 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726120AbhAHKF3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Jan 2021 05:05:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610100242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=11l3mj1UE5jX79PBsPyiLxVECs3/fF4MoveQY9G6pbQ=;
        b=L2ue2HnwCP0h87ReHkdAziMUrd2Gh9B8VLs9kNZZvyqm6Z6btZh2wUIA0YNwkca7OIgs75
        tYyfD/CkTaiBaMZAJPlVKElUzxoN2e3nNO2mHUulwF8LSueYC38KZxbqSgrsC/Ml41NHFF
        WVJT8FIBpr+gAO0SUSDIYcT08VqmLZQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-577-ooIvuXpANyi3xmgJJoIjcA-1; Fri, 08 Jan 2021 05:04:01 -0500
X-MC-Unique: ooIvuXpANyi3xmgJJoIjcA-1
Received: by mail-wr1-f71.google.com with SMTP id d2so3935888wrr.5
        for <kvm@vger.kernel.org>; Fri, 08 Jan 2021 02:04:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=11l3mj1UE5jX79PBsPyiLxVECs3/fF4MoveQY9G6pbQ=;
        b=OmogIG+3hWo/gR9KMS4uqByy7YD3gAcI4tC7FHGb/hQzy6r6PknWFSaTVpYtP+1TCJ
         NDrJ/MIbBKA0Rx2+JFFtvFvpZRba8jfhE5vq4l9TUlMibTTM2z2St5Nbgn8aB6i4G+1F
         tSbEfZ+o7AStBz018CnjV1PH4XLuL4qiQYip82WHY7/mrMTziT4HS6/IenucJEhmc15P
         CwJEXOKoNHSwJr/WxYJNhXIXbvoQYH1Cpo511jx0FjQDsTcVgsw/6BiElcaUovfbbh+y
         D+7NK4HrncDw47VL7WcjGwLUBMmG4b9iZ8jYSY56L6NplQ+hlWt9gW8cIufPUo6BJly2
         Mv1Q==
X-Gm-Message-State: AOAM5307xNob8i3C0e1nbnC4BQpb/rQ7jmx/fDIfk51+NB6QKGgCWXuA
        oWhO5RK/Z+OcU3wXhAC07VJGyRM3NpWOKNWJyLXNzFGIIC6SRSybzdBWNvDVlviPB/EKgHTAtkX
        Jzgb4C06bTVUH
X-Received: by 2002:a1c:2091:: with SMTP id g139mr2373451wmg.133.1610100239940;
        Fri, 08 Jan 2021 02:03:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyFyMLPpPYKbyxpZXOaQ2QHZKNsKsCm/85IAHueIGD5l8QsZqKB6OB7QmV+330rv7+imjV54A==
X-Received: by 2002:a1c:2091:: with SMTP id g139mr2373427wmg.133.1610100239715;
        Fri, 08 Jan 2021 02:03:59 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x7sm10927331wmi.11.2021.01.08.02.03.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 02:03:58 -0800 (PST)
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
 <35b38baf-bd75-9054-76f8-15e642e05f55@redhat.com>
 <47864d22df766d6028f437a20aa4668a@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b75a791a-6727-1b55-ea96-d7860b4ade80@redhat.com>
Date:   Fri, 8 Jan 2021 11:03:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <47864d22df766d6028f437a20aa4668a@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/01/21 09:22, Marc Zyngier wrote:
>>
>>>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git 
>>> tags/kvmarm-fixes-5.11-1
>>
>> Looks like there are issues with the upstream changes brought in by
>> this pull request.  Unless my bisection is quick tomorrow it may not
>> make it into 5.11-rc3.  In any case, it's in my hands.
> 
> I'm not sure what you mean by "upstream changes", as there is no
> additional changes on top of what is describe in this pull request,
> which is directly based on the tag  you pulled for the merge window.
> 
> If there is an issue with any of these 18 patches themselves, please
> shout as soon as you can.

You're right, it's not related to this pull request but just to Linus's 
tree.  It was too late yesterday, and now it's all set for sending it out.

Paolo


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6640449F9C7
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 13:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348642AbiA1MsW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 07:48:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:59040 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229487AbiA1MsV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Jan 2022 07:48:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643374100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bo8ZOiKS2adjR5eMsgOruuTsYEGNkSRUgFp15Xq4s0k=;
        b=QMP7GH1WY4x+NvZZOzwM01+7NE/mdCL3pxS5wZwf6M7OfUHWIZvCUg6jgYXA0DG5ksFwhO
        5RMc3fm7yhynGyuYqsmRvtP/XLfpZCzYe43vziQubhbR7M0H9V0uY3pE4ImttSOp155B4N
        OdY0ZTOFVi0tbstKVjIvxIIK1bjvqAA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-257-Md5Jm9iSOoS9aQrcGqBKwg-1; Fri, 28 Jan 2022 07:48:19 -0500
X-MC-Unique: Md5Jm9iSOoS9aQrcGqBKwg-1
Received: by mail-ed1-f71.google.com with SMTP id p17-20020aa7c891000000b004052d1936a5so3003736eds.7
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 04:48:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Bo8ZOiKS2adjR5eMsgOruuTsYEGNkSRUgFp15Xq4s0k=;
        b=DRew/rnJv1bbRnmYPOnRHdKMAMTt7ycqiFcRd4eZajXwfJnhKy3JzwWgohyTwYn2FJ
         hNuyZz7J0Z2GF+zlHN7APJBhWKIvN+701kngAf4jK7+oOFOmlukJzGu8/PTAzsVLRyN2
         tUW/cCPSWiE1JaiUbIgS7HjId3WK5vmIozjHoH+VGM6rpBwWjOgB6aUNhHciIiAQMF9z
         YcocJBtw7vVD3kYtMQy38tbEeMRngbtFOMxz8/fM+zODcMHFq2GumyRCQUcJBvboU8jo
         2Ol6qiqlaEXdE7nX2mAw4d9/fBLAronixnb85vRo/BdrubFSJWFmsG7xJaaH4O7ejjhL
         AxYg==
X-Gm-Message-State: AOAM530RTwSfO/tq7xi0pJgmAX+BDxtuoY6xIr9X+0mqaVdbRwxBQ6VA
        gaU3QBYIhIZ3r2beypwRzUAgsBfQ0KAxLnwFn/80OlZObGMViuf8hTXJtKIeCfKwKOOF7UTW/qg
        z13auu19f1xmr
X-Received: by 2002:a05:6402:650:: with SMTP id u16mr8010745edx.167.1643374098330;
        Fri, 28 Jan 2022 04:48:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwB2OzlwLHsX6cQfqU4/ONk7VwKQxBpbkHfUGKrzVKUNTmNb3W4B/+uFDcrKSXpWkuMhcbW/Q==
X-Received: by 2002:a05:6402:650:: with SMTP id u16mr8010728edx.167.1643374098108;
        Fri, 28 Jan 2022 04:48:18 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id d3sm2657530edq.13.2022.01.28.04.48.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jan 2022 04:48:17 -0800 (PST)
Message-ID: <8a78eca4-79b2-e183-f01a-6f56124bfdeb@redhat.com>
Date:   Fri, 28 Jan 2022 13:48:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.17, take #1
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>, Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, kernel-team@android.com
References: <20220128101245.506715-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220128101245.506715-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/28/22 11:12, Marc Zyngier wrote:
> The following changes since commit 1c53a1ae36120997a82f936d044c71075852e521:
> 
>    Merge branch kvm-arm64/misc-5.17 into kvmarm-master/next (2022-01-04 17:16:15 +0000)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.17-1
> 
> for you to fetch changes up to 278583055a237270fac70518275ba877bf9e4013:
> 
>    KVM: arm64: Use shadow SPSR_EL1 when injecting exceptions on !VHE (2022-01-24 09:39:03 +0000)

Pulled, thanks.

Paolo


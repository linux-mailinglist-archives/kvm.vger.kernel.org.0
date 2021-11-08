Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C26E4480C2
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 15:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240186AbhKHOGv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 09:06:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43194 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235382AbhKHOGs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 09:06:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636380244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p8ccwATBfjWOqKpzov4v3zPTW3jVQrNm++A0cUVokOI=;
        b=Hf399CU7Oir7TnLQgri1wNNEba1qolV1jWk80fH2Ty/LJXGLHuSDwmXmnIfWtP2fA5Q2+S
        Fot7HLC6DT2kjU0JOTbhrCRju548qlnLG3Fy3JvoBUhmZyHZTMwBl0nAemYTRkfr7OoT7S
        uZouFgZdaPn4qhkwn+SZGlZBrrJzL/E=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-qp-JCagaPF-kt_Xv5CcErQ-1; Mon, 08 Nov 2021 09:03:57 -0500
X-MC-Unique: qp-JCagaPF-kt_Xv5CcErQ-1
Received: by mail-ed1-f72.google.com with SMTP id i22-20020a05640242d600b003e28aecc0afso14975569edc.1
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 06:03:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=p8ccwATBfjWOqKpzov4v3zPTW3jVQrNm++A0cUVokOI=;
        b=1VVQOwE8nzFs2hkvCwBNyiXCF9Ts5BUrsAn0oRwbF26sCL0UroTrWVOMlGl4uKJoe8
         /z0C0BRxiV5+/Kb6wAmnD7X0wUDlVu1cvK1UuCQedeg3vHrll3m2f0QOvUwv8cjhiR5s
         gj4XoAe5Goqs2V0+H++//a55Xe/3ku89ndVNXCWe1gtGAjPJDL3ShdJplyS01Iy/aQSg
         FRq1l47ez2AmPfWuqVj3fjef0iSLUFNuTUfjycpX12hc7PonS1f2tJU/S2HLLCv2zMnw
         tUAAoVepjGcTgKICTClyvq/7/quTSOa/AeaXfc4k9CUREccX7sMxnau9rRI4dX2VjurZ
         oYyw==
X-Gm-Message-State: AOAM530xHBNnQkTTpd4aWtzE74HhG2d6gya/PpceDj3HIw+BiMO4NzY5
        lyBMunTU04YboGbZZiqQoF+c71jvU/CReOcpWyupEBrTEz99P8s6kw8NzYbzAjmssmnOtazjBBu
        9yYwK5kPAFe2a
X-Received: by 2002:a05:6402:4388:: with SMTP id o8mr60752525edc.342.1636380236486;
        Mon, 08 Nov 2021 06:03:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxJLLwb7AcDoiUC17OqcacYp2Q250DFId6BnTBYP6IS5fa2PgK2OanO/rMDasNtyteAGf5Vgw==
X-Received: by 2002:a05:6402:4388:: with SMTP id o8mr60752498edc.342.1636380236185;
        Mon, 08 Nov 2021 06:03:56 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ji14sm1995669ejc.89.2021.11.08.06.03.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 06:03:55 -0800 (PST)
Message-ID: <069f7446-752f-ba66-9b50-1bd5c0144ad6@redhat.com>
Date:   Mon, 8 Nov 2021 15:03:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [GIT PULL] First batch of KVM changes for Linux 5.16
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20211102165331.599683-1-pbonzini@redhat.com>
 <f880166d-5c23-4f4d-1dc0-333055de2e3d@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <f880166d-5c23-4f4d-1dc0-333055de2e3d@de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/8/21 14:48, Christian Borntraeger wrote:
> 
>> Linus,
>>
>> The following changes since commit 
>> 8228c77d8b56e3f735baf71fefb1b548c23691a7:
>>
>>    KVM: x86: switch pvclock_gtod_sync_lock to a raw spinlock 
>> (2021-10-25 08:14:38 -0400)
>>
>> are available in the Git repository at:
>>
>> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
>>
>> for you to fetch changes up to 52cf891d8dbd7592261fa30f373410b97f22b76c:
>>
>>    Merge tag 'kvm-riscv-5.16-2' of https://github.com/kvm-riscv/linux 
>> into HEAD (2021-11-02 09:15:31 -0400)
> 
> It seems that this was not yet merged, correct?

It was:

     commit d7e0a795bf37a13554c80cfc5ba97abedf53f391
     Merge: 44261f8e287d 52cf891d8dbd
     Author: Linus Torvalds <torvalds@linux-foundation.org>
     Date:   Tue Nov 2 11:24:14 2021 -0700

     Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm

     ...

     * tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm: 
(227 commits)
       ...
       KVM: s390: add debug statement for diag 318 CPNC data
       KVM: s390: pv: properly handle page flags for protected guests
       KVM: s390: Fix handle_sske page fault handling
       ...

Paolo


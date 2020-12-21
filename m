Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFDB92DFFBC
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 19:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgLUS21 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Dec 2020 13:28:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41025 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725782AbgLUS21 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Dec 2020 13:28:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608575220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rS/dYtI//F4K7bV0mJuUUzS3DlkOae1kX99K/3SIHlU=;
        b=c6iTBqP6JE0OhckSEdUknWrrWFkpdH4WtBdEBhzwuQMitIFvYXSj/jQiYnrhJvZBXbwGno
        7zAbS37g3WO73cY3lRPTLdz/cmXWx7gmsQq42GVjC0sYm94sLXd3Q8u9A3oAhvDbVwvO8f
        YhgWZoz5MdKtgIE+ODHBcaepqAV4WgE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-eenVOavKNTunV4xRSRu_VQ-1; Mon, 21 Dec 2020 13:26:58 -0500
X-MC-Unique: eenVOavKNTunV4xRSRu_VQ-1
Received: by mail-wm1-f71.google.com with SMTP id b4so7818760wmj.4
        for <kvm@vger.kernel.org>; Mon, 21 Dec 2020 10:26:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rS/dYtI//F4K7bV0mJuUUzS3DlkOae1kX99K/3SIHlU=;
        b=ppFoD1WfYP3meDeQMS8wAFLOyH1a4WRtu69OAcZ21pWTMddtcgeNMMhistsNqtqaRy
         IgJrINDgz/FVITWPrsJn6JMzjDCULqH6pfTv22t8osOOIuywxLIBAY33jrysP38UTnhq
         BPWVLNOUCAuXfEgqrdbxdrnC9M40l79pPA8Y8NxyHdf5F3UOwzNrrucPGKzWEH2jLaOB
         YNgxgjnQDFfgXmFPZyZf5mY01QstSqXxsFohvdgo2WzLRYG0/t9D76eDKy0Q0cFa/CyY
         qCPOf78HE4XhffTbjOFuJW1Ub4c8b/BxVqxDrBlLP3Ma/k6ZAELfqgHIcdgBIZA5bWSE
         U74g==
X-Gm-Message-State: AOAM532mNxThw1TLsePZUyncV/WHgGdkXsjdBsEAQQYyMcaf9v+LkNR/
        lJ7bkfce0WleuCYlBZ2g6AkC0uLseGHVdHT1+pIIGvTqpy6VBTBRU2qfHKgkmgsWc9s2f1j+CZb
        lJJaGKd299kDA
X-Received: by 2002:a05:600c:2188:: with SMTP id e8mr18090019wme.182.1608575217041;
        Mon, 21 Dec 2020 10:26:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyMZhfQHOfHnX7nor0CK0K7VmN4wDmsJ9iebYUBKXuakLExeUShKYQ6snFKiTzD8em8boHFLw==
X-Received: by 2002:a05:600c:2188:: with SMTP id e8mr18090012wme.182.1608575216887;
        Mon, 21 Dec 2020 10:26:56 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y7sm24487637wmb.37.2020.12.21.10.26.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 10:26:56 -0800 (PST)
Subject: Re: [PATCH 0/4] KVM: x86/mmu: Bug fixes and cleanups in
 get_mmio_spte()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Richard Herbert <rherbert@sympatico.ca>
References: <20201218003139.2167891-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c706666a-3ef1-d4dc-bb3b-054867a80490@redhat.com>
Date:   Mon, 21 Dec 2020 19:26:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201218003139.2167891-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/12/20 01:31, Sean Christopherson wrote:
> Two fixes for bugs that were introduced along with the TDP MMU (though I
> strongly suspect only the one reported by Richard, fixed in patch 2/4, is
> hittable in practice).  Two additional cleanup on top to try and make the
> code a bit more readable and shave a few cycles.
> 
> Sean Christopherson (4):
>    KVM: x86/mmu: Use -1 to flag an undefined spte in get_mmio_spte()
>    KVM: x86/mmu: Get root level from walkers when retrieving MMIO SPTE
>    KVM: x86/mmu: Use raw level to index into MMIO walks' sptes array
>    KVM: x86/mmu: Optimize not-present/MMIO SPTE check in get_mmio_spte()
> 
>   arch/x86/kvm/mmu/mmu.c     | 53 +++++++++++++++++++++-----------------
>   arch/x86/kvm/mmu/tdp_mmu.c |  9 ++++---
>   arch/x86/kvm/mmu/tdp_mmu.h |  4 ++-
>   3 files changed, 39 insertions(+), 27 deletions(-)
> 

Queued, thanks (and thanks for Ccing stable on the first two already :)).

Paolo


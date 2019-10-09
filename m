Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4CA7D0C35
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 12:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbfJIKIF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 06:08:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57502 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbfJIKIF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 06:08:05 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 468ED4FCC9
        for <kvm@vger.kernel.org>; Wed,  9 Oct 2019 10:08:05 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id c17so862605wro.18
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 03:08:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AbYT7LMtNspgYUtLuc1v/mvn663HfzOAgV78ocp3jrQ=;
        b=IQqM+HUv8G7q9nTjoGQLKZjG4RPjST6ccL2mK13qGgxpSb5Cf8p+Drbgl+gRbuDUz9
         kby7pQdxm8+y+m1jdjE9tmC8Xi6JnZZKBOUrbt+eco2evJ760qmWQFlx6yph4mUwbFm+
         3seLQ27QrclMV9yMmO9j/uA/S+JvN09hLrS8t70TEuGNewhhXpxk4CZKqBs9qKaHEFy6
         UZuEYonovBZNnbTWaAszzujAyXPKFDghLe/UEoo0DSmHVkPTCftxYckkQOVxNEt0B6/3
         i2WMwHBA5j6vTu6Atnt9wxJmRvB0IG9TCJxf0VbWGjubKBfx6C/IkmmxBniPrqvPDJVY
         GNlQ==
X-Gm-Message-State: APjAAAU5hGaBoivtZcJ25sA2DLyjDeQaere7aat4rLC2cdqkYjFfO7Ku
        EwilxB/1duWu7KE1G6kP2GlgzMIFOIWVjVBEGjr0jGlwG9u9z+xiAzdXoL7QrYKFigFh1G7G3kS
        1j2UazwzmHe3t
X-Received: by 2002:a5d:4286:: with SMTP id k6mr2108623wrq.292.1570615683882;
        Wed, 09 Oct 2019 03:08:03 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyoLTfumEmNHLXDIg4ArZfA8t/p8MmvsM2zMS3WoBposHcguoCISAv4xqoFdr7PjYFbL7oEkg==
X-Received: by 2002:a5d:4286:: with SMTP id k6mr2108601wrq.292.1570615683604;
        Wed, 09 Oct 2019 03:08:03 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id q3sm2090140wru.33.2019.10.09.03.08.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 03:08:03 -0700 (PDT)
Subject: Re: [PATCH 0/5] SEV fixes and performance enhancements
To:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        David Rientjes <rientjes@google.com>
References: <cover.1570137447.git.thomas.lendacky@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <fdabc7b9-7136-b780-ad2b-5821b7c97269@redhat.com>
Date:   Wed, 9 Oct 2019 12:08:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <cover.1570137447.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/10/19 23:17, Lendacky, Thomas wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> This patch series provides fixes in the area of ASID assignment and VM
> deactivation.
> 
> Additionally, it provides some performance enhancements by reducing the
> number of WBINVD/DF_FLUSH invocations that are made.
> 
> Note: The third patch in the series modifies a file that is outside of
>       the arch/x86/kvm directory.
> 
> ---
> 
> Patches based on https://git.kernel.org/pub/scm/virt/kvm/kvm.git next
> and commit:
>   fd3edd4a9066 ("KVM: nVMX: cleanup and fix host 64-bit mode checks")
> 
> Tom Lendacky (5):
>   KVM: SVM: Serialize access to the SEV ASID bitmap
>   KVM: SVM: Guard against DEACTIVATE when performing WBINVD/DF_FLUSH
>   KVM: SVM: Remove unneeded WBINVD and DF_FLUSH when starting SEV guests
>   KVM: SVM: Convert DEACTIVATE mutex to read/write semaphore
>   KVM: SVM: Reduce WBINVD/DF_FLUSH invocations
> 
>  arch/x86/kvm/svm.c           | 105 +++++++++++++++++++++++++++--------
>  drivers/crypto/ccp/psp-dev.c |   9 +++
>  2 files changed, 92 insertions(+), 22 deletions(-)
> 

Queued, thanks.  I squashed 4/5 and 5/5 since there's not much that
survives of patch 4 after the next one.

Paolo

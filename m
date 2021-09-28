Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14B241B46C
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 18:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241885AbhI1QuO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 12:50:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33974 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241812AbhI1QuK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 12:50:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632847710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QtwllydMHGyFzLESHuCUqc8VrgYc5TwZXFenjH66G5Q=;
        b=dODjxfgIK/c0Z2e8snbS3Ok1XftjQFHtZazoQAmdtpw/sFN3gbwWadmq9ici6JvFIMY/hl
        c94vERqdpG+0fdLwrCXksXTwNAiqWTXoS27teztbf21+LwLBHVtHT/088jRNP+pGnzunmZ
        AhyipHsdaQ2I8SKKimwsFzuQhyyrIDY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-q7RzdJmxNkmgxmQLvNd5xQ-1; Tue, 28 Sep 2021 12:48:29 -0400
X-MC-Unique: q7RzdJmxNkmgxmQLvNd5xQ-1
Received: by mail-ed1-f70.google.com with SMTP id b7-20020a50e787000000b003d59cb1a923so22500255edn.5
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 09:48:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QtwllydMHGyFzLESHuCUqc8VrgYc5TwZXFenjH66G5Q=;
        b=5JCkJwxVf7Svga8mx9V+YRFn1+kbxZx9DgG3r5QPfUEo+mrANmwiqSovykZNMlmMj/
         hx0St7OkfiRJjX1/u2DUP256n3904nVE8bUFNIuN8/mbFWW/ShorL1KTnSQnWi8V51Rw
         U1QuCZ3wXnH95sooGFDG2plXaz80LldNwoyl4KarKmQBtL1mpisyjmAnrsGSyVQMR4od
         DKOunSCb/ZV5kqN3WLON8E3TawACigKWIdfhhGy2SqxNVc245u0Ao0KDk/YRkKnWAZNU
         qFXdj9jwCaRsmEqF00W3U0tWYe90H7914Vpe6mtD1PqgEYR5lhOVISRAAhk5InQojsTv
         YEjw==
X-Gm-Message-State: AOAM533z5CslggzLoffP5qE9hKXvd2A0pIgLIp/eBLJuUJIwPsv0YDO3
        aDubtPXtsYlshbaBwuGVBHdTyIHmBXaLIa2qyRiHBxOlZbJYYkvLJKKM8IIEHRAUrtpJHW35ryn
        JP+OjePD3FLyd
X-Received: by 2002:a17:906:a018:: with SMTP id p24mr7690001ejy.349.1632847707975;
        Tue, 28 Sep 2021 09:48:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5WRomeP223sMlhPYW+g/nZ1wzj0FfwwqeLtK6g6ahSepfC1HmQoBasRiPn6KMGx6W7tiHdg==
X-Received: by 2002:a17:906:a018:: with SMTP id p24mr7689966ejy.349.1632847707766;
        Tue, 28 Sep 2021 09:48:27 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w26sm5644114edu.59.2021.09.28.09.48.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 09:48:27 -0700 (PDT)
Message-ID: <c69d7f93-131a-0848-c197-fa7ab26f812d@redhat.com>
Date:   Tue, 28 Sep 2021 18:48:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 4/6] kvm: use kvfree() in kvm_arch_free_vm()
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc:     maz@kernel.org, ehabkost@redhat.com,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, kvmarm@lists.cs.columbia.edu
References: <20210903130808.30142-1-jgross@suse.com>
 <20210903130808.30142-5-jgross@suse.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210903130808.30142-5-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/09/21 15:08, Juergen Gross wrote:
> By switching from kfree() to kvfree() in kvm_arch_free_vm() Arm64 can
> use the common variant. This can be accomplished by adding another
> macro __KVM_HAVE_ARCH_VM_FREE, which will be used only by x86 for now.
> 
> Further simplification can be achieved by adding __kvm_arch_free_vm()
> doing the common part.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>

Queued this one already, thanks.

Paolo


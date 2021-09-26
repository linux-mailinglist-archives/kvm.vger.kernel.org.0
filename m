Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8C44186B3
	for <lists+kvm@lfdr.de>; Sun, 26 Sep 2021 08:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhIZG3M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Sep 2021 02:29:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37378 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229557AbhIZG3L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 26 Sep 2021 02:29:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632637655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1TiBTpYstMaABQ/rAwh18m9vsSq3OqvaFEu629LcCL8=;
        b=AT5/PG0z3EzdeorlWOjcalMkMIuqdx/kSJlyedxA9a0Z5HaOAWh19SuOyQfVfP1hscnXDo
        ndrzwXzzRB5LVNi85EvMVI55Hx7Hnns/fgrq4gRTKomf4x5KJinVbPpTd/gfSLSyo8Vl98
        RL+yotYrs93Q304RJn+4O16zB8UkSk4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-VlAUx2vDNYGW1s2vlIEj2g-1; Sun, 26 Sep 2021 02:27:33 -0400
X-MC-Unique: VlAUx2vDNYGW1s2vlIEj2g-1
Received: by mail-ed1-f71.google.com with SMTP id s12-20020a05640217cc00b003cde58450f1so14605045edy.9
        for <kvm@vger.kernel.org>; Sat, 25 Sep 2021 23:27:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1TiBTpYstMaABQ/rAwh18m9vsSq3OqvaFEu629LcCL8=;
        b=YR109+/BDR8B+6YIuWxWrJESFQPZR9ZtrUcmEGASpo7w36Cw3hGix7QQPsYPEdG09E
         MH4C7zOYAy01n2lh/rA+oj2CMxb6UW5zutKNSIgbmooN5/Ub0ho+Fik9kBfIY/HF25pZ
         ADoOVwd1ZGgPdPt7Ck037DIfvsBKoWxHcQiNJbJVYb1dSexGi/lk9Z/onK2iuQanSMr2
         igjKVZ1q70joR4qPRZs16pQHVB5reVO7Oh1Skk0w1RnKDxFgrCrBBbJASzPYEwEKp/df
         Ee+8E2d0X555p87stYShPGAcKpxinKMYOxwoLSMOZKjt6pJE7p78Pgo8icmYftijBQ5N
         BuvQ==
X-Gm-Message-State: AOAM531NYhpEXr91o8fnf8nl4UnbC57SLsUVGnf3wwzReAv95LiQS6QQ
        UlDXTVHGHOgwK/yRO/WmhTzrdlArSYWiE86ySpOSoJnqhnFtdIjscAb5ZGpDnjrKqubLkZsNRs2
        jqZWq1SzuwqqW
X-Received: by 2002:a17:906:bcf5:: with SMTP id op21mr21248191ejb.114.1632637652475;
        Sat, 25 Sep 2021 23:27:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKIxMWhBoRL018xLqTu0jQnou9ZPZ7BoXp91FbgfoN587mWDIRzysD7Ruz1/cm6u5Gy8RhTw==
X-Received: by 2002:a17:906:bcf5:: with SMTP id op21mr21248168ejb.114.1632637652217;
        Sat, 25 Sep 2021 23:27:32 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id dk27sm8333826edb.19.2021.09.25.23.27.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Sep 2021 23:27:31 -0700 (PDT)
Message-ID: <80d90ee6-0d43-3735-5c26-be8c3d72d493@redhat.com>
Date:   Sun, 26 Sep 2021 08:27:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 07/14] KVM: Don't block+unblock when halt-polling is
 successful
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-8-seanjc@google.com> <878rzlass2.wl-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <878rzlass2.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/21 11:50, Marc Zyngier wrote:
>> there is no need for arm64 to put/load
>> the vGIC as KVM hasn't relinquished control of the vCPU in any way.
> 
> This doesn't mean that there is no requirement for any state
> change. The put/load on GICv4 is crucial for performance, and the VMCR
> resync is a correctness requirement.

I wouldn't even say it's crucial for performance: halt polling cannot 
work and is a waste of time without (the current implementation of) 
put/load.

However, is activating the doorbell necessary?  If possible, polling the 
VGIC directly for pending VLPIs without touching the ITS (for example by 
emulating IAR reads) may make sense.  IIUC that must be done at EL2 
though, so maybe it would even make sense to move all of halt polling to 
EL2 for the nVHE case.  It all depends on benchmark results, of course.

Sorry for the many stupid questions I'm asking lately, but I'm trying to 
pay more attention to ARM and understand the VGIC and EL1/EL2 split better.

Paolo


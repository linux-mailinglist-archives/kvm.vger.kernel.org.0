Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9A1453661
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 16:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238599AbhKPPyE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 10:54:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54671 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238315AbhKPPxx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 10:53:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637077855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YptFOrP2nGZgxL0dz3Uz+MV2Fy+UJLC/xUWIe94Zh90=;
        b=Oq5IkzysnzgnlK2huPz8lxf57AWJpXaqQEsizF4VH2PfIFqZphUV6RlxcMgosV2MG7WbTf
        8r+iCBJ5T0BJP6o4MUtnLTo05Bfud1ipQsIojdZ/KYLcH3LFWdagEowcp9kXEc7z+42vp1
        svxy1gxx0qvy7kyJixvoDX1ru98+wz8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-IOu4GPwSPZ2JF_vyWL4whw-1; Tue, 16 Nov 2021 10:50:53 -0500
X-MC-Unique: IOu4GPwSPZ2JF_vyWL4whw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F1B815721;
        Tue, 16 Nov 2021 15:50:51 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA1605D6BA;
        Tue, 16 Nov 2021 15:50:24 +0000 (UTC)
Message-ID: <ebfa56a6-d444-e82e-bf0d-946765c7f8ae@redhat.com>
Date:   Tue, 16 Nov 2021 16:50:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/5] KVM: arm64: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20211111162746.100598-1-vkuznets@redhat.com>
 <20211111162746.100598-2-vkuznets@redhat.com>
 <a5cdff6878b7157587e92ebe4d5af362@kernel.org> <875ysxg0s1.fsf@redhat.com>
 <87k0hd8obo.wl-maz@kernel.org>
 <ad3534bc-fe3a-55f5-b022-4dbec5f29798@redhat.com> <87y25onsj6.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87y25onsj6.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 14:23, Vitaly Kuznetsov wrote:
> (I'm about to send v2 as we have s390 sorted out.)
> 
> So what do we decide about ARM?
> - Current approach (kvm->arch.max_vcpus/kvm_arm_default_max_vcpus()
>   depending on 'if (kvm)') - that would be my preference.

That would be mine too.

Paolo

> - Always kvm_arm_default_max_vcpus to make the output independent on 'if
>   (kvm)'.
> - keep the status quo (drop the patch).


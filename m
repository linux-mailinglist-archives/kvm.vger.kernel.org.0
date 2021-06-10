Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5373A2E2E
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 16:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbhFJObk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 10:31:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57936 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230488AbhFJObj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 10:31:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623335382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CXjwm022f1btPWZxExQD9Wi6mGGZrQ0Sf9jZNJK7BTY=;
        b=NRVXmT5LXdQpqhjvCVu9ihCKsOe4H5q5z/gzpcVUfqMjS8ppsiC2ierBukZ8MS5tLbKYgT
        635ckQgzfydlKVsHypaN2DOmCRBnD8d0o+/n40dxXZe8pL9ZTLuHtvxoOJrT+Vt1SGx5Ly
        rWe+K6whjFdFLHHqJawjbIzweq9jXMY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-UyekpUsNORGTcxh1qRieMg-1; Thu, 10 Jun 2021 10:29:40 -0400
X-MC-Unique: UyekpUsNORGTcxh1qRieMg-1
Received: by mail-wm1-f69.google.com with SMTP id j6-20020a05600c1906b029019e9c982271so3945391wmq.0
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 07:29:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=CXjwm022f1btPWZxExQD9Wi6mGGZrQ0Sf9jZNJK7BTY=;
        b=Xqa0kyKFDBlYHfwFs5QxllkQtg9Ohe3fgX35jasr7JF0YcuE01UDFfNfUh6a0zTDHa
         BbfQyx2cf1zwghf7Y+t1T6h8Z0fXScdSt2/+ptVIN0fh3R9WzvArm413OnHeMsREP+1U
         bztLZCnvwGNmt1leQDAgyYcrcl1I+YP45pm+CIr6g4sOnT6sdWnPwu9tCqy90WxUytsN
         I6gMMqXKfkps1Z34O8Ii9o+h1A1tUJGH4KzkeZWWpxz0a8DN0wRHv5RHLINR8hXuvV9Y
         oDmwqv8MPRbBXSzH/vR2+h2x64I8CmJ5kVT98X+g3/8WQQJ3lFFsPU33W3+kLbZiZIjX
         KRTg==
X-Gm-Message-State: AOAM5309k6W9amHzBzj1RgvgPr9mslIRNOdi9G+P8Bct4SToInVH2Rke
        ocl2dU3lO3bUlN7d7A1IlbQChT2SeJujLvXT+s4MtB/Z2I9dQV7aWvOougchl40qU+bvp+FS1+3
        S+MB/FSPIVVnI1LPgObOaU0WcaORH0h9/EM2vle8AXzw/GQh1IPXBUDefP2tF/eYx
X-Received: by 2002:a1c:cc02:: with SMTP id h2mr2923741wmb.39.1623335379146;
        Thu, 10 Jun 2021 07:29:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5YKmQhpdePLhcFwXesjKPtPyXVB/I64T17TPcEfyOuMlHO8/sT0DjK7es33C6b3nxHNYgxg==
X-Received: by 2002:a1c:cc02:: with SMTP id h2mr2923721wmb.39.1623335378876;
        Thu, 10 Jun 2021 07:29:38 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id w8sm4235981wre.70.2021.06.10.07.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 07:29:38 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 00/11] KVM: nVMX: Fixes for nested state migration
 when eVMCS is in use
In-Reply-To: <20210526132026.270394-1-vkuznets@redhat.com>
References: <20210526132026.270394-1-vkuznets@redhat.com>
Date:   Thu, 10 Jun 2021 16:29:37 +0200
Message-ID: <87mtrxyer2.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Changes since v2:
> - 'KVM: nVMX: Use '-1' in 'hv_evmcs_vmptr' to indicate that eVMCS is not in
>  use'/ 'KVM: nVMX: Introduce 'EVMPTR_MAP_PENDING' post-migration state'
>  patches instead of 'KVM: nVMX: Introduce nested_evmcs_is_used()' [Paolo]
> - 'KVM: nVMX: Don't set 'dirty_vmcs12' flag on enlightened VMPTRLD' patch
>  added [Max]
> - 'KVM: nVMX: Release eVMCS when enlightened VMENTRY was disabled' patch
>   added.
> - 'KVM: nVMX: Make copy_vmcs12_to_enlightened()/copy_enlightened_to_vmcs12()
>  return 'void'' patch added [Paolo]
> - R-b tags added [Max]
>
> Original description:
>
> Commit f5c7e8425f18 ("KVM: nVMX: Always make an attempt to map eVMCS after
> migration") fixed the most obvious reason why Hyper-V on KVM (e.g. Win10
>  + WSL2) was crashing immediately after migration. It was also reported
> that we have more issues to fix as, while the failure rate was lowered 
> signifincatly, it was still possible to observe crashes after several
> dozens of migration. Turns out, the issue arises when we manage to issue
> KVM_GET_NESTED_STATE right after L2->L2 VMEXIT but before L1 gets a chance
> to run. This state is tracked with 'need_vmcs12_to_shadow_sync' flag but
> the flag itself is not part of saved nested state. A few other less 
> significant issues are fixed along the way.
>
> While there's no proof this series fixes all eVMCS related problems,
> Win10+WSL2 was able to survive 3333 (thanks, Max!) migrations without
> crashing in testing.
>
> Patches are based on the current kvm/next tree.

Paolo, Max,

Just to double-check: are we good here? I know there are more
improvements/ideas to explore but I'd like to treat this patchset as a
set of fixes, it would be unfortunate if we miss 5.14.

-- 
Vitaly


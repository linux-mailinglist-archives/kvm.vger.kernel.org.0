Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E72C3494A8A
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 10:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241480AbiATJSD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 04:18:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:56449 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229825AbiATJSC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jan 2022 04:18:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642670281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TDl62cJLzLieM8+MJy6Z/f4cSi0IK1TE0za11DkmZ4w=;
        b=AYgQCVkDmKOVC4NUjcWHltruQKNqLq7ehjkyYvnmOnYX/oaO7Ayqtml5mk7pG0Gyyec+19
        s9o9oBCpnnQdbywMIP6N3ercmbTptS9PrrTnADpeirNo9ZJQlioOM+qDkhvWyV/0IwtjK4
        QCh8kHt+PVHdXWaznEjUbvJeIPjzPno=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-4tN46FijMNSsWu2pQjvEtQ-1; Thu, 20 Jan 2022 04:18:00 -0500
X-MC-Unique: 4tN46FijMNSsWu2pQjvEtQ-1
Received: by mail-wm1-f71.google.com with SMTP id bg16-20020a05600c3c9000b0034bea12c043so6308712wmb.7
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 01:18:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TDl62cJLzLieM8+MJy6Z/f4cSi0IK1TE0za11DkmZ4w=;
        b=7PHnK2m4CGbDNHyoe5KaaI58Eu2Q9waMy7p55J81gGxkEYsaa3V+ZaW7rb4upzwDH/
         JuFdddYRFXlTe1Mig+gjHOrH5tr3zfc5Ub31XgXGTQqtUO2M86BAt2QTTHDtbOxYWS84
         lQ8xXW8aqH+kqL+4knB8EnzbKKJZVgGgHRqH68kt40dX/3gvnflkwK6yfnCMq268xuug
         dhGzLKZ3aJwja+QpVyUkow4LJ7js879eBacmuQdSQEhp+7+moqa7hgccz3cX5OA8UvvP
         YpRS19nLfPO13RJBBGMkskis/tFWRjgTJ07VPYrT92L2tcFLgq8uZ3MxqFT3BdiHz/Ms
         ffyg==
X-Gm-Message-State: AOAM533GBCDdGs9qE5r3Jm3xwNiZDs66NtDwcbjBm03YSjc/ENeGb4QW
        fU88wFMRp7CrmmVLfJ2mXFP9mR0ZxlWkF+OboEcLERLiubwSx8R6+LiU9n5QLhpXIx06CLf4pi3
        7IVGioPzzbRrU
X-Received: by 2002:a05:600c:a47:: with SMTP id c7mr7971028wmq.23.1642670279433;
        Thu, 20 Jan 2022 01:17:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyRUHrzKn5gxWntlb8Fu8JBKs+vMEpvgw4xk4jSItBmMgSlUdakFidsONjuCM1Y6NcqCzQEdA==
X-Received: by 2002:a05:600c:a47:: with SMTP id c7mr7971010wmq.23.1642670279201;
        Thu, 20 Jan 2022 01:17:59 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id k37sm8659384wms.0.2022.01.20.01.17.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jan 2022 01:17:58 -0800 (PST)
Message-ID: <19c4168f-c65b-fc9a-fe4c-152284e18d30@redhat.com>
Date:   Thu, 20 Jan 2022 10:17:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [DROP][PATCH] KVM: x86: Fix the #GP(0) and #UD conditions for
 XSETBV emulation
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Jun Nakajima <jun.nakajima@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220117072456.71155-1-likexu@tencent.com>
 <a133d6e2-34de-8a41-475e-3858fc2902bf@redhat.com>
 <9c655b21-640f-6ce8-61b4-c6444995091e@gmail.com>
 <0d7ed850-8791-42b4-ef9a-bbaa8c52279e@redhat.com>
 <92b16faf-c9a7-4be3-43f7-3450259346e9@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <92b16faf-c9a7-4be3-43f7-3450259346e9@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/20/22 08:48, Like Xu wrote:
> 
> In the testcase "executing XSETBV with CR4.XSAVE=0",
> 
> - on the VMX, #UD delivery does not require vm-exit;

Not your fault, it would be nicer if the Intel manual told the truth;
it says: "The following instructions cause VM exits when they are
executed in VMX non-root operation: CPUID, GETSEC[1], INVD, and XSETBV."

Footnote [1] says "An execution of GETSEC causes an invalid-opcode
exception (#UD) if CR4.SMXE[Bit 14] = 0", and there is no such footnote
for XSETBV.  Nevertheless, when tracing xsave.flat, I see that there's
a #UD vmexit and not an XSETBV vmexit:

         qemu-kvm-1637698 [019] 758186.750321: kvm_entry:            vcpu 0, rip 0x4028b7
         qemu-kvm-1637698 [019] 758186.750322: kvm_exit:             vcpu 0 reason EXCEPTION_NMI rip 0x40048d info1 0x0000000000000000 info2 0x0000000000000000 intr_info 0x80000306 error_code 0x00000000
         qemu-kvm-1637698 [019] 758186.750324: kvm_emulate_insn:     0:40048d:0f 01 d1 (prot64)
         qemu-kvm-1637698 [019] 758186.750325: kvm_inj_exception:    #UD (0x0)

So while my gut feeling that #UD would not cause a vmexit was correct,
technically I was reading the SDM incorrectly.

Jun, can you have this fixed?

Paolo

> - on the SVM, #UD is trapped but goes to the ud_interception() path;


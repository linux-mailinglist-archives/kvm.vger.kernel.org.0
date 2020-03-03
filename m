Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60C2C177897
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 15:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbgCCOQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 09:16:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34762 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726536AbgCCOQW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 09:16:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583244981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MUTEP1p4YWjzskXYVbK6H4xhC2oS8H6SYOsK8O1eOyQ=;
        b=Ug88pqkaw+plaXVH+30eYqaFbzv2lgRSeptj7dsOo0pkMx6eNyr7wF2Xk7CUwGs05zrf6k
        sN6PiL84ds6NHlAq5H1uTrouZliF7PQkMxL3rjKDpHmB5rgxjcz1OpyQePLsxFZLnBb4kS
        UHI/kaW5LvcCxvBaN2YLfpjMupBrTfY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-k6mYqY7QOFuLbfB-hfkTew-1; Tue, 03 Mar 2020 09:16:19 -0500
X-MC-Unique: k6mYqY7QOFuLbfB-hfkTew-1
Received: by mail-wr1-f70.google.com with SMTP id m13so1286790wrw.3
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 06:16:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MUTEP1p4YWjzskXYVbK6H4xhC2oS8H6SYOsK8O1eOyQ=;
        b=NEUX+fNzMsGaypMT3Zb8Cvttw7tEynNeMRioqplUi0hYhwLyVsL27LWi1J4Go2aXQr
         yuvL/1qwHcRhfiWl8Z+4/ZtcSHf/b3GLHlU6B0whZ9cw6aK+wr4P2ny33EO6ZFpG+MBS
         evdYhuJcaCME2jBx/yWjEUlFWn7iGVLMV9ALi4W3V1rSHfwekaTZc2eWCNUqhPMhc/At
         2BOztXqiwDEvjpk7a9TnbyHkxm0Cn2RD9YIYiff3Ig/KSI9f8J1l3xOeirx9W2wayfmL
         7GpysBMEphzGlSIbrDRUCjgmJaRmiIAGgtUUFZijrrrDkdOgXGhLEffhSP2auZE+hvMt
         2M2A==
X-Gm-Message-State: ANhLgQ3K/R8cKbtherMDk5f6N/R32YzG5EFDD2S/6o0FIv+Ztx9DKNSJ
        qs/O9EkUqalpY+89KMadnCf5BV9X+kBCCuBlsvy9yM4gDmA6+OmjNPqcN3PHVpin5aBp+KA72zg
        yqrhhor5yTZOI
X-Received: by 2002:adf:e6c9:: with SMTP id y9mr5857110wrm.246.1583244978784;
        Tue, 03 Mar 2020 06:16:18 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsYNg7+BUQwOf9zvxhDv8luT0LXJFS2Ip7Opm1OZwN8LJ4aJ2q/o6inCPO/0+w/9WVAKxYWiQ==
X-Received: by 2002:adf:e6c9:: with SMTP id y9mr5857091wrm.246.1583244978498;
        Tue, 03 Mar 2020 06:16:18 -0800 (PST)
Received: from [192.168.178.40] ([151.20.254.94])
        by smtp.gmail.com with ESMTPSA id m25sm2351920wml.35.2020.03.03.06.16.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 06:16:18 -0800 (PST)
Subject: Re: [PATCH v2 01/66] KVM: x86: Return -E2BIG when
 KVM_GET_SUPPORTED_CPUID hits max entries
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
 <20200302235709.27467-2-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <599c3a95-a0a6-b31d-56a6-c50971d4ab59@redhat.com>
Date:   Tue, 3 Mar 2020 15:16:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200302235709.27467-2-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/20 00:56, Sean Christopherson wrote:
> (KVM hard caps CPUID 0xD at a single sub-leaf).

Hmm... no it doesn't?

                for (idx = 1, i = 1; idx < 64; ++idx) {
                        u64 mask = ((u64)1 << idx);
                        if (*nent >= maxnent)
                                goto out;

                        do_host_cpuid(&entry[i], function, idx);
                        if (idx == 1) {
                                entry[i].eax &= kvm_cpuid_D_1_eax_x86_features;
                                cpuid_mask(&entry[i].eax, CPUID_D_1_EAX);
                                entry[i].ebx = 0;
                                if (entry[i].eax & (F(XSAVES)|F(XSAVEC)))
                                        entry[i].ebx =
                                                xstate_required_size(supported,
                                                                     true);
                        } else {
                                if (entry[i].eax == 0 || !(supported & mask))
                                        continue;
                                if (WARN_ON_ONCE(entry[i].ecx & 1))
                                        continue;
                        }
                        entry[i].ecx = 0;
                        entry[i].edx = 0;
                        ++*nent;
                        ++i;
                }

I still think the patch is correct, what matters is that no KVM in
existence supports enough processor features to reach 100 or so subleaves.

Paolo


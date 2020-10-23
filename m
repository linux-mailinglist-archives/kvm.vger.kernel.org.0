Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC9B296BC0
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 11:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S461110AbgJWJHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 05:07:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55082 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S461037AbgJWJHX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 05:07:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603444041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rDSn1aAjNMgpc4B1YOGiuNHspmgqNuHO0dXhh/lQRnk=;
        b=E164Szy3tlaqFBPIYnbepCxQnn1hSSWKNR0uoDVSmzVnFYe4P1M2AUchGDUE7n25qIABU6
        s5HvNi2jzVZofp+08TfaLM4jblxLaBH3DNQ4csIIQ4gyLg8H5k/s0xz+oCNS47Ka6JMzOS
        siuy0oSnAsSpiIAyUb0ODLY+pn6xXo4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-Ti_Vp9AXMR-VBznE6X9Ucw-1; Fri, 23 Oct 2020 05:07:20 -0400
X-MC-Unique: Ti_Vp9AXMR-VBznE6X9Ucw-1
Received: by mail-wm1-f71.google.com with SMTP id g71so207094wmg.2
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 02:07:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rDSn1aAjNMgpc4B1YOGiuNHspmgqNuHO0dXhh/lQRnk=;
        b=p2nPWhx9C4XlJmNM3Rht6BGgs3HyUMMwyllEsKGYQsH1DoTZB0aDnbtyv71g4LlueY
         pLDKDbVaJ6+Iat0zYH1H7gvb6mby5YyRIQDitP703dVG9N1Gdj9fKcqy9Ho0WU7cA/vK
         VDT7VCGB/n5dx27MQQhGsqMocDVunINt8OzF8sLFBp0xamsD/KPAH/yaVDtTrRnBhZba
         weTQq6/kFkXC+nC2R48kGEcWRd9aq8qugBZy9rbM1sq4s7iQZ7ZMBJIvdDe00R+wgNfF
         q7IAfHSq1XF5acher+uAljQV84EAQ+gLzBexFzk5EhrLqxgHAfUrMingP/YvjbQMHrSW
         MwCg==
X-Gm-Message-State: AOAM532KI2V+ilsRazVm067lJDsNNOa97kvpwf9pV8GV4uLv7GSUTD3K
        1vkHknzvTgkeY/3WijfNvOeJOIKIdlK4mOUkocdjNC3GPA3j0FakD9F5vPxVuRUxi6/6B653Amq
        VrUi6i5ENmVnS
X-Received: by 2002:a1c:7e4e:: with SMTP id z75mr1254479wmc.55.1603444038822;
        Fri, 23 Oct 2020 02:07:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJymkAQVzRC+NdRJu3Qpt8v16P0bBR5YMQh/1cANaSLmKSByCA2TahG776pO8+Ion6vfQ8liog==
X-Received: by 2002:a1c:7e4e:: with SMTP id z75mr1254464wmc.55.1603444038582;
        Fri, 23 Oct 2020 02:07:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b63sm2041759wme.9.2020.10.23.02.07.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2020 02:07:17 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: Expose KVM_HINTS_REALTIME in
 KVM_GET_SUPPORTED_CPUID
To:     Jim Mattson <jmattson@google.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1603330475-7063-1-git-send-email-wanpengli@tencent.com>
 <cfd9d16f-6ddf-60d5-f73d-bb49ccd4055f@redhat.com>
 <CALMp9eR3Ng-WBrumXaJAecLWZECf-1NfzW+eTA0VxWuAcKAjAA@mail.gmail.com>
 <281bca2d-d534-1032-eed3-7ee7705cb12c@redhat.com>
 <CALMp9eQyJXko_CKPgg4xRDCsvOmA8zJvrg_kmU6weu=MwKBv0w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <823d5027-a1e5-4b91-2d35-693f3c2b9642@redhat.com>
Date:   Fri, 23 Oct 2020 11:07:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eQyJXko_CKPgg4xRDCsvOmA8zJvrg_kmU6weu=MwKBv0w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/10/20 19:13, Jim Mattson wrote:
> We don't actually use KVM_GET_SUPPORTED_CPUID at all today. If it's
> commonly being misinterpreted as you say, perhaps we should add a
> KVM_GET_TRUE_SUPPORTED_CPUID ioctl. Or, perhaps we can just fix this
> in the documentation?

Yes, I think we should fix the documentation and document the best
practices around MSRs and CPUID bits.  Mostly documenting what QEMU
does, perhaps without all the quirks it has to support old kernels that
messed things up even more.

Paolo


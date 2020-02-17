Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07AF11618A3
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 18:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729600AbgBQRQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 12:16:04 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45109 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729271AbgBQRQD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Feb 2020 12:16:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581959762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f1LZGD5WNqtz5rIbXI6TpBQUDWxl65cn90/dkNdr5mw=;
        b=caBRZNFG1aqX4qT113JEMHNGhurmwcSgHEweio/J/V60wI+DDEaKht8EnES11gxhj9CNKr
        RdrcpOFM+RLrqNgejsHMCqWqp5VYWezp8uziJ8Axjor0i+Uv9FkKmEX3bSLpHltJZaSLb9
        qvRR7GPGAh5pUuQRXsShJS6nqJt1Lxs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-p_zLbw_ZN6iaqVY2Ehw15g-1; Mon, 17 Feb 2020 12:14:48 -0500
X-MC-Unique: p_zLbw_ZN6iaqVY2Ehw15g-1
Received: by mail-wr1-f72.google.com with SMTP id l1so9301267wrt.4
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 09:14:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f1LZGD5WNqtz5rIbXI6TpBQUDWxl65cn90/dkNdr5mw=;
        b=LzQsPLd7D9tScIWf2nsyEa0P4M3T08eSK39c8+gwghnEIKEv/hsBCt7Ld2GCiJDMhm
         +yaAXIsbEZT9W/1UIdiKc5oRQdMArLVKNOo0pTKn0BlH6MIwELhhEKT8j4PzPIdW45Fb
         HTfffvwYiJ5hkV2yCgHgVRo1M3oYRk4IGeii1hAFNzW7MnwBJ0yqdg7+dZvA3CXBpFoh
         Mm99WLksbgpXuyhTpHoAeu0BXMua3NW+kVw0fq9nEmg6nuAAdGy2kKaIMKRTub4hdKDa
         6jR5ebOoO0K/2QBpry0LNzIDthidO0gqH4wHDJvcM/MlNFPIgKl4g25GP93CnRrJy1W/
         4gQg==
X-Gm-Message-State: APjAAAXDayGaB5l3Uoc4p4gP2oLfv7yxhd9+xtkwgW4DWpVYlyPcxa0V
        VibUskJuu8RX/VT+awDURgTOZf70ZxhXYyhgUZoft4LhAfzoH6MSB5RwdmLn9i1kldetQXzY6bK
        d2+e7eCWjiz/O
X-Received: by 2002:adf:f1c6:: with SMTP id z6mr22198748wro.279.1581959687161;
        Mon, 17 Feb 2020 09:14:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqzMdCEUTe/MyuDEjjJD3/8S3SMGQhBkx3p/6bMu4ZJG7y/qDDJMFMEHco03lwFK/cDS7ORBrg==
X-Received: by 2002:adf:f1c6:: with SMTP id z6mr22198735wro.279.1581959686973;
        Mon, 17 Feb 2020 09:14:46 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id u62sm117423wmu.17.2020.02.17.09.14.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 09:14:46 -0800 (PST)
Subject: Re: [PATCH] KVM: VMX: Add VMX_FEATURE_USR_WAIT_PAUSE
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20200216104858.109955-1-xiaoyao.li@intel.com>
 <87r1ytbnor.fsf@vitty.brq.redhat.com>
 <bb0302e1-c946-2695-8468-d08c3b146b76@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <aea2c71a-b4b8-14f4-c55a-2498fc09986e@redhat.com>
Date:   Mon, 17 Feb 2020 18:14:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <bb0302e1-c946-2695-8468-d08c3b146b76@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/02/20 09:57, Xiaoyao Li wrote:
> What an uncareful typo. Thanks!

No problem, queued.

Paolo

>>>   #define VMX_FEATURE_ENCLV_EXITING    ( 2*32+ 28) /* "" VM-Exit on
>>> ENCLV (leaf dependent) */
>>>     #endif /* _ASM_X86_VMXFEATURES_H */
>>
>> With the typo fixed (likely upon commit),
>>
>> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>>


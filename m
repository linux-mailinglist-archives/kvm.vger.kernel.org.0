Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1071818FE63
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 21:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgCWUBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 16:01:00 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:40896 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725903AbgCWUA7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 16:00:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584993657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cY+H9r1hyt0W+F/eh6c6o3kR9Aied7i4vmIsTGqyvm8=;
        b=YKepk1PQoth/BbGlTItKh75O0DfIwuOYZauBAJwGqPr74RJMvhRAjRVBds6OnSo4FyJb29
        fJScBbuYtHiYHdLWwVB+YHf+1GwSLbz09CAvgXvpXgErEGOr7n0+KV1EsOpVWcABP/jSPV
        XfR6PHFndWGa16LNHcwAsLPWiqsZ6vo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-tKB9RlWaP5yLP2P61dSTkw-1; Mon, 23 Mar 2020 16:00:55 -0400
X-MC-Unique: tKB9RlWaP5yLP2P61dSTkw-1
Received: by mail-wm1-f70.google.com with SMTP id x23so278361wmj.1
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 13:00:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cY+H9r1hyt0W+F/eh6c6o3kR9Aied7i4vmIsTGqyvm8=;
        b=WOZBVX9q9avyg1xPT2CvSqdjvU6OrBqRiKBRuoauje4VYx2yoCNVAx3SjuOUfFddQG
         fwUjl8ocerjx4EiuU0LzhVL3LTEdTyu29Y0OaSirsowLca8W5seW/OOMB7vdojXaq697
         7PC2qCUZdO72Fs/lVYZ4ngPTEofcWQlJaRIwYhZjOxTD2R+/HmiZj5M3ZIOkmwELKSIG
         pF6/VmbdhDB1NNu4XWRe6CuLNbDlR/56ouGBtqfNto0pQsHOXEy8Ut3BQYBY2v+1frXL
         56lNkuPnMJ454EgzIy3l12OWaCZtMVIWOqHXR47grI+KF39DCbKLD77+anW1Wr9rbwF7
         g4rA==
X-Gm-Message-State: ANhLgQ1yfh5jarTqh90pQQFt+XzAK/qlwbhJ1HHN9U/GCX1j8u2W0Ijo
        Ov6YqVKiixUcI5lJgUyvOcuVAr7GzwceJJ03GZHBLI3sRvZn5+XJjiANO5HCy4qdKp7qVjWTXeC
        nmmyPN3K4ivuK
X-Received: by 2002:adf:f3c5:: with SMTP id g5mr26655839wrp.230.1584993653911;
        Mon, 23 Mar 2020 13:00:53 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvXyqIbkkktOwq1/2ooUCj01kGPzulVzA6RfK1uS8wG/GOec0veo7shFCpnK1NWAqj8WTc9EQ==
X-Received: by 2002:adf:f3c5:: with SMTP id g5mr26655802wrp.230.1584993653686;
        Mon, 23 Mar 2020 13:00:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:24d8:ed40:c82a:8a01? ([2001:b07:6468:f312:24d8:ed40:c82a:8a01])
        by smtp.gmail.com with ESMTPSA id 98sm25182715wrk.52.2020.03.23.13.00.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2020 13:00:53 -0700 (PDT)
Subject: Re: [PATCH v3 4/9] KVM: VMX: Configure runtime hooks using
 vmx_x86_ops
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
References: <20200321202603.19355-1-sean.j.christopherson@intel.com>
 <20200321202603.19355-5-sean.j.christopherson@intel.com>
 <87ftdz9ryn.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c7915319-8795-e466-e2df-478b1bf9734c@redhat.com>
Date:   Mon, 23 Mar 2020 21:00:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <87ftdz9ryn.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/03/20 13:27, Vitaly Kuznetsov wrote:
>> -	kvm_x86_ops->check_nested_events = vmx_check_nested_events;
>> -	kvm_x86_ops->get_nested_state = vmx_get_nested_state;
>> -	kvm_x86_ops->set_nested_state = vmx_set_nested_state;
>> -	kvm_x86_ops->get_vmcs12_pages = nested_get_vmcs12_pages;
>> -	kvm_x86_ops->nested_enable_evmcs = nested_enable_evmcs;
>> -	kvm_x86_ops->nested_get_evmcs_version = nested_get_evmcs_version;
>> +	ops->check_nested_events = vmx_check_nested_events;
>> +	ops->get_nested_state = vmx_get_nested_state;
>> +	ops->set_nested_state = vmx_set_nested_state;
>> +	ops->get_vmcs12_pages = nested_get_vmcs12_pages;
>> +	ops->nested_enable_evmcs = nested_enable_evmcs;
>> +	ops->nested_get_evmcs_version = nested_get_evmcs_version;
> 
> A lazy guy like me would appreciate 'ops' -> 'vmx_x86_ops' rename as it
> would make 'git grep vmx_x86_ops' output more complete.
> 

I would prefer even more a kvm_x86_ops.nested struct but I would be okay
with a separate patch.

Paolo


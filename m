Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2604964DF
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 19:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381873AbiAUSPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 13:15:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24087 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242836AbiAUSPh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Jan 2022 13:15:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642788936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KYy1i+FH4VOW+JYk+fZtKQ5Pgx/dVWicHQgq6SNK8YA=;
        b=LfpGugZCAU/FpOkZUlMa4G9altlL2FE3SaBkAc8GfL4dnKAIB7VitQUbALCPkCSAxFsaJ6
        CFGZ0FthEnhnSMlFqvLJ9/u8i7JwutmKiMtyUB1MNM73dmWE9vwXNxxOdG8D4ZQ9wa4IZh
        4PPLLiIlv9LuqHY6HhT0U9YWUcDz/74=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-364-Jt95bB-DPKG-jBRhExOwbw-1; Fri, 21 Jan 2022 13:15:35 -0500
X-MC-Unique: Jt95bB-DPKG-jBRhExOwbw-1
Received: by mail-wm1-f72.google.com with SMTP id a189-20020a1c98c6000000b0034e32e18a21so3712825wme.9
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 10:15:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KYy1i+FH4VOW+JYk+fZtKQ5Pgx/dVWicHQgq6SNK8YA=;
        b=NqysA6Lwun92UgQKUdJBVtP43APdNYaru4NjdLl6FV0JO5gxatj180Rzka/EXoBjYq
         U6IsHycCp5oVDN/D53KKoII6+zMhGgB1senwqmlEnAsBDiGnvqW+7fG7JUm7HPzXGtq4
         g45K80TAo91AGH4f4P2088q71t7tvcifJkeXddH8CIX4peI9J9j+5HEacap/9PfSMvhU
         nWikz++k9VmZi+sw/O0C4um5NQ6Y6+Bp9ohNjDTeMfnqr8UB0FHC8YPrbINfHZvWucqf
         ENhIS+sFSbqGpAi/pTNRRlFYzjI6S2GNfvKT5OcBh9WAaptqNgijF/UNMp+GT+euPpfH
         BROg==
X-Gm-Message-State: AOAM533LcnQnxrw4n/Bd0tbhhBMAdAxZzvdtVQ8/Ymi4sIAA9DlVgcID
        Oh4pQUZn+UjIS4L/R+myIERGtzLsfpe+fR4avi1Za/laDD4MhyJQBxqDwEKm7qiyXMAPDpLock2
        fq0+6UhNfWB5q
X-Received: by 2002:a05:600c:220f:: with SMTP id z15mr1752366wml.145.1642788934066;
        Fri, 21 Jan 2022 10:15:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxyU4/ucVuurIbHqIJa+MYGyzTJ8eMdyKgy64HuuHBMxLsDJNLK+qW5VL2eBoScWepPWXyiMA==
X-Received: by 2002:a05:600c:220f:: with SMTP id z15mr1752344wml.145.1642788933895;
        Fri, 21 Jan 2022 10:15:33 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id k12sm6219225wrd.98.2022.01.21.10.15.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jan 2022 10:15:33 -0800 (PST)
Message-ID: <a3bb69a6-10a5-51b1-edf5-b6d34b9a5797@redhat.com>
Date:   Fri, 21 Jan 2022 19:15:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v6 0/6] x86/xen: Add in-kernel Xen event channel delivery
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc:     Peter Xu <peterx@redhat.com>, kvm <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
References: <33f3a978-ae3b-21de-b184-e3e4cd1dd4e3@redhat.com>
 <a727e8ae9f1e35330b3e2cad49782d0b352bee1c.camel@infradead.org>
 <e2ed79e6-612a-44a3-d77b-297135849656@redhat.com>
 <YcTpJ369cRBN4W93@google.com>
 <daeba2e20c50bbede7fbe32c4f3c0aed7091382e.camel@infradead.org>
 <YdjaOIymuiRhXUeT@google.com> <Yd5GlAKgh0L0ZQir@xz-m1.local>
 <791794474839b5bcad08b1282998d8a5cb47f0e5.camel@infradead.org>
 <cf2d56a2-2644-31f2-c2a5-07077c66243a@redhat.com>
 <37493a2c50389f7843308685f50a93201f1f39c5.camel@infradead.org>
 <YehN9pmMXy535+qS@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YehN9pmMXy535+qS@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/19/22 18:44, Sean Christopherson wrote:
> I think we can fix that usage though:
> 
> https://lore.kernel.org/all/YcTpJ369cRBN4W93@google.com

Ok, will review next week.

>>> So either we have another special case to document for the dirty ring
>>> buffer (and retroactively so, even), or we're in bad need for a solution.
>> Seems like adding that warning is having precisely the desired effect:)
>
> The WARN is certainly useful.  Part of me actually likes the restriction of needing
> to have a valid vCPU, at least for x86, as there really aren't many legitimate cases
> where KVM should be marking memory dirty without a vCPU.

Yes, I agree that every case of it has needed, at the very least, 
further scrutiny.

Paolo


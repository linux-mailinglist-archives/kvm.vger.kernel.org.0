Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D66849070F
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 12:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239032AbiAQLUi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 06:20:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53880 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236343AbiAQLUh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 06:20:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642418437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CSwkkcPBH4uW8wbUBd+sfq/hcSR5RMC3A5g8KIsw41c=;
        b=h2rLYkIexm5eTttuuMmE6SluIkhBPY58f1wNscJp+f+J/2HgRBeOn7HRIgTf0btrBqYcGC
        sAenpIWoAK0pvy+qVg+eTZbnnJ0/04FsblwdAEbxceL4gN0oKiZ8BlVAiJcBpHdmVJ+tHK
        l0Ex0+wRJnNP/9ih8fi9lGqxSb7pILU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-aIdUSZWANiaYxd09PqmSSA-1; Mon, 17 Jan 2022 06:20:36 -0500
X-MC-Unique: aIdUSZWANiaYxd09PqmSSA-1
Received: by mail-wm1-f72.google.com with SMTP id c188-20020a1c35c5000000b00346a2160ea8so5097790wma.9
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 03:20:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CSwkkcPBH4uW8wbUBd+sfq/hcSR5RMC3A5g8KIsw41c=;
        b=k76cBtKuR6qWtE2m+ZWj4dCRp8iMIS5nVDZ1oNYIkIeCYpgBfW+bTbd7v0DDhIzqE6
         ma+icWjtGmMsABMFe7X/su24PNgdG/PqQnQ/rJbgB5a7oQAtl3pvJy4tC82WAeHLNtaG
         5DSjMvaKKRFQ3c6La6TP/fibGZbkcSOOpUeuCioet1bPfAhXsi3s4B85eU+XlHOlNpAz
         tEVC35qEdBC2ZGH5fYIhDqoph0cG+0XbXRC5TD7eXEJKmxufWDkn1E4Ufs+IVKCbMRvl
         Y6f8WV0bMx1Nnd1mySTIQF5I6u2/Y/SVuL0axp1m10SkESnSsYKhLgT3iuV3G+woWr/y
         5tog==
X-Gm-Message-State: AOAM530EoUwvkQlrIqjc8CU/gClI4kArYZP9zk8VbUMobWOWz+cT48hp
        wAsN2zv/cV3b4f/W0wvLcCgvF29HsajfACG1N6xo774aqm+IgOrN/3uffaCki6tbBSShw1I6dBy
        kbVWq67XmCjGu
X-Received: by 2002:a7b:c40c:: with SMTP id k12mr20014547wmi.185.1642418434412;
        Mon, 17 Jan 2022 03:20:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwJBRfrzBWxBqWuCdx7trdwRGWYNdZTP5PcXzny7OgW1OgDE8/6v4EIiV29TTbWPniTmzekeg==
X-Received: by 2002:a7b:c40c:: with SMTP id k12mr20014529wmi.185.1642418434192;
        Mon, 17 Jan 2022 03:20:34 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id i10sm17358719wmq.45.2022.01.17.03.20.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 03:20:33 -0800 (PST)
Message-ID: <517e8b95-e336-8796-6657-c0f8d554143a@redhat.com>
Date:   Mon, 17 Jan 2022 12:20:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
References: <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
 <20211227183253.45a03ca2@redhat.com>
 <61325b2b-dc93-5db2-2d0a-dd0900d947f2@redhat.com> <87mtkdqm7m.fsf@redhat.com>
 <20220103104057.4dcf7948@redhat.com> <YeCowpPBEHC6GJ59@google.com>
 <20220114095535.0f498707@redhat.com> <87ilummznd.fsf@redhat.com>
 <20220114122237.54fa8c91@redhat.com> <87ee5amrmh.fsf@redhat.com>
 <YeGsKslt7hbhQZPk@google.com> <8735lmn0t1.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <8735lmn0t1.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/17/22 10:55, Vitaly Kuznetsov wrote:
> No, honestly I was thinking about something much simpler: instead of
> forbidding KVM_SET_CPUID{,2} after KVM_RUN completely (what we have now
> in 5.16), we only forbid to change certain data which we know breaks
> some assumptions in MMU, from the comment:
> "
>           * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
>           * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
>           * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
>           * faults due to reusing SPs/SPTEs.
> "
> It seems that CPU hotplug path doesn't need to change these so we don't
> need an opt-in/opt-out, we can just forbid changing certain things for
> the time being. Alternatively, we can silently ignore such changes but I
> don't quite like it because it would mask bugs in VMMs.

I think the version that only allows exactly the same CPUID is the best, 
as it leaves less room for future bugs.

Paolo


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441FE368FC6
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 11:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241889AbhDWJut (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 05:50:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41014 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230036AbhDWJus (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 05:50:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619171412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lttXllC96pjl9peZRGjvJaERkDX34Sq4PB6MZIKq8Dw=;
        b=h8C7ozPilbk0UFkf8ysHgKSjkQmKxARlYoRhujeoBgqZg8x5nbdYRY5oFif9re4j9pvOxN
        zWPX3v4Nw5R5wBbnkSvWB5nEiI8bXPfDuKHACsoB6oohYQoPxXrikA9wpvoAK56Pptz0w/
        wySiPQM+nzKCzdXVkKNahtUUuFdzMK0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-ZI60sE6KNxmpk32agmsyBA-1; Fri, 23 Apr 2021 05:50:10 -0400
X-MC-Unique: ZI60sE6KNxmpk32agmsyBA-1
Received: by mail-ej1-f70.google.com with SMTP id 16-20020a1709063010b029037417ca2d43so8197234ejz.5
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 02:50:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lttXllC96pjl9peZRGjvJaERkDX34Sq4PB6MZIKq8Dw=;
        b=kzGW6E5poRoX6G5lFqt1HEzPmeqgwj+yDBP1ALbdFOc5Iu7ueBIrMgw1rpaq/HEnjz
         biAuZyP09ZkO0sAmTfOfOrE++cZZVW2xpwYEpTMrLUX9XbzVlM4LHobDR5MW3J+JTNJH
         q3MQaziRLGuLQ7mzIS+5Dshd57pHrRyi2ER7V4Q6TsXcVcElyO8jj+QJ7VMbPtiGKPiu
         tQYQrcbiw/A052mibHbbqH6IbHF4pLiT39Amn5jvDERVLovuaVNyjfEj2+/vrqPuB54D
         b3NeKVpzoJaqvoLkRlAGDDntUsGhK0TqeK2BgmpJiJIbnv5c4sMsf1J3UF3PlEzXLS9d
         490A==
X-Gm-Message-State: AOAM530Sftx9jS4z91Ecwa5kykzdrQsgDo1zBhGlt13Se8OGXdQ6CJ5G
        cLXG3Z97SwnADxaCDai27l3etIa1hgSKsTlH57ZlEm/DoZriaKbOJ6E4NfLJXVAEoeaICLpuP1q
        6twlY+Xn6whkW
X-Received: by 2002:a05:6402:254f:: with SMTP id l15mr3443786edb.189.1619171409137;
        Fri, 23 Apr 2021 02:50:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/VCmHTB70961btADlTz5e8A3q9643nHV4cnCUH4ChbCa8x0wJgKu3xOGY/OZrFDWx6sb1Zg==
X-Received: by 2002:a05:6402:254f:: with SMTP id l15mr3443755edb.189.1619171408919;
        Fri, 23 Apr 2021 02:50:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x7sm4260299eds.67.2021.04.23.02.50.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 02:50:08 -0700 (PDT)
Subject: Re: [PATCH] KVM: hyper-v: Add new exit reason HYPERV_OVERLAY
To:     Alexander Graf <graf@amazon.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc:     Evgeny Iakovlev <eyakovl@amazon.de>, Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210423090333.21910-1-sidcha@amazon.de>
 <224d266e-aea3-3b4b-ec25-7bb120c4d98a@amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <213887af-78b8-03ad-b3f9-c2194cb27b13@redhat.com>
Date:   Fri, 23 Apr 2021 11:50:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <224d266e-aea3-3b4b-ec25-7bb120c4d98a@amazon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/04/21 11:24, Alexander Graf wrote:
> I can see how that may get interesting for other overlay pages later, 
> but this one in particular is just an MSR write, no? Is there any reason 
> we can't just use the user space MSR handling logic instead?
> 
> What's missing then is a way to pull the hcall page contents from KVM. 
> But even there I'm not convinced that KVM should be the reference point 
> for its contents. Isn't user space in an as good position to assemble it?

In theory userspace doesn't know how KVM wishes to implement the 
hypercall page, especially if Xen hypercalls are enabled as well.

But userspace has two plausible ways to get the page contents:

1) add a ioctl to write the hypercall page contents to an arbitrary 
userspace address

2) after userspace updates the memslots to add the overlay page at the 
right place, use KVM_SET_MSR from userspace (which won't be filtered 
because it's host initiated)

The second has the advantage of not needing any new code at all, but 
it's a bit more ugly.

Paolo


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62DE41C32F
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 13:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244741AbhI2LPI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 07:15:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56957 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243396AbhI2LPH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Sep 2021 07:15:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632914006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dTZq+ux4mB9YNHTA5OTzVEdASfmrzoHTVqIYcJ0NyoY=;
        b=C9vnBjKPJrEM7llD7zAyOTUdS0k3FPjeKsfQeEgoL+k+HgM8RQS3vi6VJEKMODvRD8BBQg
        84DANab/ecUPzIlkt5uQV2I/qhpKN3BdZFbe3bnrCkir7NDo1cBKyQw0A7Kujp6v+Y0aUg
        0+2GmGD8vKwJuz4khtPbgo54lmRgkFk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-ygI4C6nyPo-YS8mYsNsMLg-1; Wed, 29 Sep 2021 07:13:25 -0400
X-MC-Unique: ygI4C6nyPo-YS8mYsNsMLg-1
Received: by mail-ed1-f72.google.com with SMTP id 1-20020a508741000000b003da559ba1eeso2026972edv.13
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 04:13:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dTZq+ux4mB9YNHTA5OTzVEdASfmrzoHTVqIYcJ0NyoY=;
        b=DgSVrXXHQMEKlzkk1duapEuBLEu9dcv+njZCpWrjB7onlPn41+ShDk3z+X/nq8dvBK
         kBW2Y9a/oBU7mPAtPDEcYGm1NmcanfaiEsJdWHk37BnVgQ2yE+PwDghwYibtnEWkale1
         XQk1JT4sYTnivjwBpa97hv1NHqKAPXS0D79O+JCLquHOa3HIlZWx+LAzLmBU5RwooKz8
         M4muQ33L6gkcVNABihEHGfvKGEP26sKAd6QfSzt1C3k2gwke5bOzGcDoeuVAHcn5r/2D
         uAw7TKhJDV4KHmRqu4yLenqRU0DJwQVbQqZoom7jQcH6GOtvmPQes6ZcBfn9sq4pINpx
         MWEg==
X-Gm-Message-State: AOAM532FjRqQPjfk+orWl+YJ2PY4sDpldvu2Oax3lIPH+rSpL9ie+/Pt
        3riXOA3dVCIsiWs+mx9esnpdjke2bCnAmqusRJURdYWH9ubvL+InlR69Q5vnjCyG36LN13hHzMa
        vuLdZ87XvOzAF
X-Received: by 2002:a17:906:3157:: with SMTP id e23mr13304322eje.29.1632914003985;
        Wed, 29 Sep 2021 04:13:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJ8c5/66N3weJQN+Q75ZY2UDR73SjqQypZMhax7EeuFS93w2FyUhjDjm1n8+TpHXC55CuSLw==
X-Received: by 2002:a17:906:3157:: with SMTP id e23mr13304286eje.29.1632914003709;
        Wed, 29 Sep 2021 04:13:23 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c10sm1180946eje.37.2021.09.29.04.13.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 04:13:23 -0700 (PDT)
Message-ID: <9aec9f47-3390-de0d-e125-c7cef14df894@redhat.com>
Date:   Wed, 29 Sep 2021 13:13:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [RFC PATCH 2/3] nSVM: introduce smv->nested.save to cache save
 area fields
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
References: <20210903102039.55422-1-eesposit@redhat.com>
 <20210903102039.55422-3-eesposit@redhat.com>
 <fbb40bb8c12715c0aa9d6a113784f8a21603e2b3.camel@redhat.com>
 <82acae8f-6b27-928f-0c00-1df8fc9d26b8@redhat.com>
 <YVOV7EucFzF5S6So@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YVOV7EucFzF5S6So@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/09/21 00:23, Sean Christopherson wrote:
> On a related topic, this would be a good opportunity to resolve the naming
> discrepancies between VMX and SVM.  VMX generally refers to vmcs12 as KVM's copy
> of L1's VMCS, whereas SVM generally refers to vmcb12 as the "direct" mapping of
> L1's VMCB.  I'd prefer to go with VMX's terminology, i.e. rework nSVM to refer to
> the copy as vmcb12, but I'm more than a bit biased since I've spent so much time
> in nVMX,

I agree, and I think Emanuele's patches are a step in the right 
direction.  Once we ensure that all state in svm->nested is cached 
vmcb12 content, we can get rid of vmcb12 pointers in the functions.

Paolo


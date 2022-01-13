Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9100A48DB2B
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 16:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbiAMP5D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 10:57:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42683 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234589AbiAMP46 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 10:56:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642089417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iVjjhSTO5jv7G5CNfPQaqxy98s1YUf5RmxMVGvagrRU=;
        b=N3zuWt+qJlJ1/lgg9nWUgBBSVDXlkQwA+tscrTjhQxCvLvipy1cBqOcl09cO+oiJtLkEhA
        /yRg5DnpikhUkVIGoRroOid0Ba0FGb3bxeZutaKFF1b4U2JF9kaMeToc054R0vHhtGmBly
        SgkvZ9PN6NU9zN3Fms76Zbj6SfXv8G8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-64-bkeUPtfaP4a91oQjVdDoCg-1; Thu, 13 Jan 2022 10:56:56 -0500
X-MC-Unique: bkeUPtfaP4a91oQjVdDoCg-1
Received: by mail-ed1-f72.google.com with SMTP id o20-20020a056402439400b003f83cf1e472so5733837edc.18
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 07:56:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=iVjjhSTO5jv7G5CNfPQaqxy98s1YUf5RmxMVGvagrRU=;
        b=ohYOSXlzlysJbG7lMWVXzUzX/NEfim5xtjlcUYGnyBBIBifvqjALKQWYYfLB3ovfK1
         ta6qOhnhYkucUJf+l0Btir9Bo7ip3mdJaluEeVYmDiOxUp8L+nb0bDMewtJ1YDp1rfSO
         Mn1QoMvLYCdNWmCUJsxdIWo0R4qzfRT+xwytJQCFG9SVn4JqlYywl2aIDTNs61diY1Y7
         E0dP01ZNCvihfZTOA5Nu8Eaed16sBT8eHHg0QZLjwocmuUV9ulPlM+zdJe923u2IiCJX
         QJw5Otf2YZlr6SbKBORK2qgpiuyKDFQpy96rvhFlObWEb2GMQQDRvJe+4/E/YrnsAPl4
         6prw==
X-Gm-Message-State: AOAM533TrNJcp2tKXJW569ape4zvPo9qeeQjmPLZCUUX24YQbjn5CcNG
        ttBWqzyNWfHlReYV5MJWxVD01eaF+mgJXdCYx+/GYZFcBD8UYFeT32Mkwxe7cYo3FE7JeHVmixe
        TSWlCDkfpulBV
X-Received: by 2002:a17:907:3ea2:: with SMTP id hs34mr3985606ejc.191.1642089415165;
        Thu, 13 Jan 2022 07:56:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxdEZGBZ+SY0OUOH5+ulUWsavApWdL/E+Vnbzgt7kPf6DLvU3IuDpfFk7n3gAZ11fQX3pswoQ==
X-Received: by 2002:a17:907:3ea2:: with SMTP id hs34mr3985577ejc.191.1642089414855;
        Thu, 13 Jan 2022 07:56:54 -0800 (PST)
Received: from ?IPV6:2003:cb:c703:e200:8511:ed0f:ac2c:42f7? (p200300cbc703e2008511ed0fac2c42f7.dip0.t-ipconnect.de. [2003:cb:c703:e200:8511:ed0f:ac2c:42f7])
        by smtp.gmail.com with ESMTPSA id f29sm986699ejj.209.2022.01.13.07.56.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jan 2022 07:56:54 -0800 (PST)
Message-ID: <0893e873-20c4-7e07-e7e4-3971dbb79118@redhat.com>
Date:   Thu, 13 Jan 2022 16:56:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v3 kvm/queue 01/16] mm/shmem: Introduce
 F_SEAL_INACCESSIBLE
Content-Language: en-US
To:     Chao Peng <chao.p.peng@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        Hugh Dickins <hughd@google.com>,
        Jeff Layton <jlayton@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        luto@kernel.org, john.ji@intel.com, susie.li@intel.com,
        jun.nakajima@intel.com, dave.hansen@intel.com, ak@linux.intel.com
References: <20211223123011.41044-1-chao.p.peng@linux.intel.com>
 <20211223123011.41044-2-chao.p.peng@linux.intel.com>
 <7eb40902-45dd-9193-37f1-efaca381529b@redhat.com>
 <20220106130638.GB43371@chaop.bj.intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220106130638.GB43371@chaop.bj.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06.01.22 14:06, Chao Peng wrote:
> On Tue, Jan 04, 2022 at 03:22:07PM +0100, David Hildenbrand wrote:
>> On 23.12.21 13:29, Chao Peng wrote:
>>> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>>>
>>> Introduce a new seal F_SEAL_INACCESSIBLE indicating the content of
>>> the file is inaccessible from userspace in any possible ways like
>>> read(),write() or mmap() etc.
>>>
>>> It provides semantics required for KVM guest private memory support
>>> that a file descriptor with this seal set is going to be used as the
>>> source of guest memory in confidential computing environments such
>>> as Intel TDX/AMD SEV but may not be accessible from host userspace.
>>>
>>> At this time only shmem implements this seal.
>>>
>>> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>>> Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
>>> ---
>>>  include/uapi/linux/fcntl.h |  1 +
>>>  mm/shmem.c                 | 37 +++++++++++++++++++++++++++++++++++--
>>>  2 files changed, 36 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
>>> index 2f86b2ad6d7e..e2bad051936f 100644
>>> --- a/include/uapi/linux/fcntl.h
>>> +++ b/include/uapi/linux/fcntl.h
>>> @@ -43,6 +43,7 @@
>>>  #define F_SEAL_GROW	0x0004	/* prevent file from growing */
>>>  #define F_SEAL_WRITE	0x0008	/* prevent writes */
>>>  #define F_SEAL_FUTURE_WRITE	0x0010  /* prevent future writes while mapped */
>>> +#define F_SEAL_INACCESSIBLE	0x0020  /* prevent file from accessing */
>>
>> I think this needs more clarification: the file content can still be
>> accessed using in-kernel mechanisms such as MEMFD_OPS for KVM. It
>> effectively disallows traditional access to a file (read/write/mmap)
>> that will result in ordinary MMU access to file content.
>>
>> Not sure how to best clarify that: maybe, prevent ordinary MMU access
>> (e.g., read/write/mmap) to file content?
> 
> Or: prevent userspace access (e.g., read/write/mmap) to file content?

The issue with that phrasing is that userspace will be able to access
that content, just via a different mechanism eventually ... e.g., via
the KVM MMU indirectly. If that makes it clearer what I mean :)

>>
>>>  /* (1U << 31) is reserved for signed error codes */
>>>  
>>>  /*
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> index 18f93c2d68f1..faa7e9b1b9bc 100644
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -1098,6 +1098,10 @@ static int shmem_setattr(struct user_namespace *mnt_userns,
>>>  		    (newsize > oldsize && (info->seals & F_SEAL_GROW)))
>>>  			return -EPERM;
>>>  
>>> +		if ((info->seals & F_SEAL_INACCESSIBLE) &&
>>> +		    (newsize & ~PAGE_MASK))
>>> +			return -EINVAL;
>>> +
>>
>> What happens when sealing and there are existing mmaps?
> 
> I think this is similar to ftruncate, in either case we just allow that.
> The existing mmaps will be unmapped and KVM will be notified to
> invalidate the mapping in the secondary MMU as well. This assume we
> trust the userspace even though it can not access the file content.

Can't we simply check+forbid instead?

-- 
Thanks,

David / dhildenb


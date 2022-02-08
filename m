Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39B504AD3EE
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 09:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351804AbiBHItt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 03:49:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351421AbiBHIto (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 03:49:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BA056C03FEC6
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 00:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644310182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=67PxmAL3Xd8LpaVSVss2M9MADvWamDZ50hstBrm0qA0=;
        b=R3h3Vdboet3dwK/xWxe24DXcvIF4qdwM1rOr0Lrq0DrwpbjbfGchpxWrEuVtKNOug0spuE
        WYFG4wli4H4RQNsuUYvC4cIdCVIaXRz9c1zhaqd64xSev767PEpD8jntGiVcVhSPs3bDuB
        RHUCcbAQd/6huTAtkXaENJuFkjMUVCA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-519-SX_3SSIJPc6JyCovSK5k8w-1; Tue, 08 Feb 2022 03:49:41 -0500
X-MC-Unique: SX_3SSIJPc6JyCovSK5k8w-1
Received: by mail-wr1-f72.google.com with SMTP id e1-20020adfa741000000b001e2e74c3d4eso4077430wrd.12
        for <kvm@vger.kernel.org>; Tue, 08 Feb 2022 00:49:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=67PxmAL3Xd8LpaVSVss2M9MADvWamDZ50hstBrm0qA0=;
        b=w8eU7g4T+pWCcy79o9MCIgF6kn4fJBUPHSO9pHKjYxHnhSGwzr6V0Xjv46Yl3ViEIb
         TZGYCbVoxs43ATjK+n6c8OfakNIxWjx/Uov42NS3mwMJ7dBhhBlqc61qKKkSbpqcV4t1
         wjigk1L8Q+9Cct1YiQohX+XF2uWUvTX+N8JIlguw1uZ0z/Zp+6JEtdu06ognrrW7HRqk
         a752UkJI/C9GxqaTVWTe6ynOhmlOCyADQ+iVx1CaUvsUvNpxKOWywZ8N80IRZBYCKzWN
         +c8b3d8c9VeTO0NhEfGalvRRUVquRj1b/yIPNVhkyMkCYVK7h4rA9sfkvtL7BVhpBZKx
         6TEg==
X-Gm-Message-State: AOAM533OCBrbkRAhHuF3MYlBP2kq66BiJDZEYH3aoXDsduG7zmJUw/Pp
        6PKhkBn809v8mUAZGPWXKSk3zJ2254j14/SVPRFL3ErW3qZ2IHUGY+IErQWmsg+0WJfhkNpVdFy
        ZRHbs3b+3tnnL
X-Received: by 2002:a7b:cd10:: with SMTP id f16mr168364wmj.180.1644310180710;
        Tue, 08 Feb 2022 00:49:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxHPvqe9Mcgm6+Q7EEAETSuMiKnrZQ8yFi6vJk5xylaclj7xAKcrNR6NQiWp2HFxsqZydBSFg==
X-Received: by 2002:a7b:cd10:: with SMTP id f16mr168333wmj.180.1644310180425;
        Tue, 08 Feb 2022 00:49:40 -0800 (PST)
Received: from ?IPV6:2003:cb:c712:a800:a1a0:a823:5301:d1af? (p200300cbc712a800a1a0a8235301d1af.dip0.t-ipconnect.de. [2003:cb:c712:a800:a1a0:a823:5301:d1af])
        by smtp.gmail.com with ESMTPSA id b16sm1728277wrj.26.2022.02.08.00.49.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 00:49:37 -0800 (PST)
Message-ID: <07aae6e7-4042-1c5c-a482-6ad3a34a3b07@redhat.com>
Date:   Tue, 8 Feb 2022 09:49:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Vlastimil Babka <vbabka@suse.cz>,
        Chao Peng <chao.p.peng@linux.intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
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
        luto@kernel.org, jun.nakajima@intel.com, dave.hansen@intel.com,
        ak@linux.intel.com, Mike Rapoport <rppt@linux.ibm.com>
References: <20220118132121.31388-1-chao.p.peng@linux.intel.com>
 <20220118132121.31388-3-chao.p.peng@linux.intel.com>
 <25166513-3074-f3b9-12cc-420ba74f153e@suse.cz>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v4 02/12] mm/memfd: Introduce MFD_INACCESSIBLE flag
In-Reply-To: <25166513-3074-f3b9-12cc-420ba74f153e@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07.02.22 19:51, Vlastimil Babka wrote:
> On 1/18/22 14:21, Chao Peng wrote:
>> Introduce a new memfd_create() flag indicating the content of the
>> created memfd is inaccessible from userspace. It does this by force
>> setting F_SEAL_INACCESSIBLE seal when the file is created. It also set
>> F_SEAL_SEAL to prevent future sealing, which means, it can not coexist
>> with MFD_ALLOW_SEALING.
>>
>> The pages backed by such memfd will be used as guest private memory in
>> confidential computing environments such as Intel TDX/AMD SEV. Since
>> page migration/swapping is not yet supported for such usages so these
>> pages are currently marked as UNMOVABLE and UNEVICTABLE which makes
>> them behave like long-term pinned pages.
> 
> Shouldn't the amount of such memory allocations be restricted? E.g. similar
> to secretmem_mmap() doing mlock_future_check().

I've raised this already in the past and Kirill wanted to look into it [1].

We'll most certainly need a way to limit/control the amount of
unswappable + unmovable ("worse than mlock" memory) a user/process can
consume via this mechanism.


[1]
https://lkml.kernel.org/r/20211122135933.arjxpl7wyskkwvwv@box.shutemov.name


-- 
Thanks,

David / dhildenb


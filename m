Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C89F436477
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 16:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhJUOkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 10:40:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23268 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229878AbhJUOkN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 10:40:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634827077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=owiu0xM2N18G53RsgwMXprPcvaYSLETIhEjRc/evgqg=;
        b=bs/UPO3fabCxKUcSIEzy9PiotdN1Zx5Tz4dQvxiMoCjm7Kcfmp8qVqFX3pYTKLhvJq5jZz
        1ojsPyDpLLcKXNpsw3tUukb9ufxnpT+2nFI3K5w6wcWGjrAgbI8rkVbzAA5vXQQ/aL4Ts7
        kzjPEnSSwqES7QttGIPuVfVh89e2Fj0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-QNu092tqNrqAqvpoBkd0IA-1; Thu, 21 Oct 2021 10:37:56 -0400
X-MC-Unique: QNu092tqNrqAqvpoBkd0IA-1
Received: by mail-ed1-f71.google.com with SMTP id x5-20020a50f185000000b003db0f796903so529185edl.18
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 07:37:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=owiu0xM2N18G53RsgwMXprPcvaYSLETIhEjRc/evgqg=;
        b=uQyopRcyg+9ZgcQ1sMdPOn6zbKTlOG1fDljgS0XUusK6QLhWj6dSgfWZDTjUGZOWc4
         8eAGN84XZItencKEglmjFozcisnEJNYZ6OBEXStCKxnpS/G2SvP1dhNrC9JqujApHQ7K
         BlAIdQqJCJOuNKidOX4WO3HzysEOMfacenNx4LuOLm+pS8cY7FSTrkFxgTysUZm06ZmY
         zEZWRh5JMRNg8WDDTeH7XE6gPES5h6Vw5G5vhatj1hTTvjQSrr2kEzNnVJAtSEnvM2Y9
         SzW5FcjryPdnXzKQnCKq+NDZeyJFDWp5+MYw+kYnrYq9ufzLGXgtxEsYqoGpK5/4F6fc
         wV6A==
X-Gm-Message-State: AOAM531Lzw4tidQdtdeegqjsX4U8uudZANdG6Kj1ma3+IMZML97WJUuC
        oOJDTOth08LrUkKKtQMaL2x8p+d+tplmeRX/sUcOU5cafGn+xYf2kwRyonjJpHBih5Ob9GcfLyr
        JlJElbjlHJq9mmSYzeZCykPbD3hKG3C43Cc8skKEOFePtkxegflWQQ0Tg68l2dzwu
X-Received: by 2002:a05:6402:510c:: with SMTP id m12mr8340515edd.33.1634827074719;
        Thu, 21 Oct 2021 07:37:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwlVq29cUcMTDPYBuRzPtaOYw26bwfhEmANDKznmCBgykV8N4PNcxxPj+qyEtAEPQj2p6rRDQ==
X-Received: by 2002:a05:6402:510c:: with SMTP id m12mr8340476edd.33.1634827074450;
        Thu, 21 Oct 2021 07:37:54 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id z19sm2669180ejp.97.2021.10.21.07.37.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 07:37:53 -0700 (PDT)
Message-ID: <2cb19e3a-a0eb-cf93-3820-a56c522555c6@redhat.com>
Date:   Thu, 21 Oct 2021 16:37:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 kvm-unit-tests 0/8] x86: Move IDT, GDT and TSS to C
 code
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     aaronlewis@google.com, jmattson@google.com, zxwang42@gmail.com,
        marcorr@google.com, seanjc@google.com, jroedel@suse.de,
        varad.gautam@suse.com
References: <20211021114910.1347278-1-pbonzini@redhat.com>
In-Reply-To: <20211021114910.1347278-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/10/21 13:49, Paolo Bonzini wrote:
> Patches 1-4 clean up tss_descr; it is declared as a struct
> descriptor_table_ptr but it is actualy pointing to an _entry_ in the GDT.
> Also it is different per CPU, but tss_descr does not recognize that.
> Fix both by reusing the code (already present e.g. in the vmware_backdoors
> test) that extracts the base from the GDT entry; and also provide a
> helper to retrieve the limit, which is needed in vmx.c.
> 
> Patches 5-9 move the IDT, GDT and TSS to C code.  This was originally done
> by Zixuan Wang for the UEFI port, which is 64-bit only.  The series extends
> this to 32-bit code for consistency and to avoid duplicating code between
> C and assembly.
> 
> Paolo

I'm going to post a v4, since the gitlab CI showed some small issues.

Paolo


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA47149433
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2020 10:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgAYJj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Jan 2020 04:39:28 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44111 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725945AbgAYJj2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 25 Jan 2020 04:39:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579945166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tSakUTi8biBaDO4JGr8rcWBisLF05BHEM8+vn5mJmsg=;
        b=Xo2etNGO3GaY/PnoEg9FHfsXYXe8f37Tx8EB6OSx/wkb4U7XZcDSbCl0dWt0yuXC0qUJud
        aaIJqFIeGRztVJR8b8N7aAU2Fc8R8b4ufSJO8ULOVgO78/jCdhUyoWdtVcKPYmT1tCHaxz
        u0yEe7Rms66XHZ20ls0hj3fwjwjZxYI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-OzJUcOOlNWCRAqF7lmJbkA-1; Sat, 25 Jan 2020 04:39:24 -0500
X-MC-Unique: OzJUcOOlNWCRAqF7lmJbkA-1
Received: by mail-wr1-f70.google.com with SMTP id 90so2756151wrq.6
        for <kvm@vger.kernel.org>; Sat, 25 Jan 2020 01:39:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tSakUTi8biBaDO4JGr8rcWBisLF05BHEM8+vn5mJmsg=;
        b=KIGQCFxp84TvIycaaoggXzT3PxAVvYM1mkJkTIcCCpkF8+sQfVUCQnGfox/rGJS3ap
         hEx4En2XR837B1NwTRQGccyyjUgNZIx4OaLytc6xmxM1GThr3KlW6/4Ldr7VpcT6hwZr
         +F/WrjIuLtLumXNKRHiWKc+o1G6u80vgOyWGBkXrn1PJGHf1x0XU5OCnls1Mzb7x37fj
         9yD1DZNHvR4yay7Ux1wuZYotHNsXFS+vG+aNDVs07m58MNof7gdTJ2mlcU0zPWzyuTtr
         LNXxwHR0np/dU/hXoRtVXGBql7rcbdkaUNF5ol6sCVE/oHjeYAYodXiNC0C0WL2Htwyx
         0lpA==
X-Gm-Message-State: APjAAAXESWVgM3hsF6+V9kahipiSFeQaDrFdp601YNzmdE1UKVN1sb/A
        MzPWBQyHVW9FaCMgq4cvimAsuhxFvr+642J6ZPSzY6qJr/GXgM0zYkS8GB9e78T2gNoFD2kH2Ml
        bktkoVWMOfyPh
X-Received: by 2002:a7b:c450:: with SMTP id l16mr3501978wmi.166.1579945163413;
        Sat, 25 Jan 2020 01:39:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqxXHzToOxP0s/Db+4GnkirH83ip6eSuf/6sQnScHphAbo+jbh853oEfOBR31PKwD5KTWSeosQ==
X-Received: by 2002:a7b:c450:: with SMTP id l16mr3501951wmi.166.1579945163182;
        Sat, 25 Jan 2020 01:39:23 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id f1sm11276551wro.85.2020.01.25.01.39.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jan 2020 01:39:22 -0800 (PST)
Subject: Re: [PATCH v4 07/10] KVM: selftests: Support multiple vCPUs in demand
 paging test
To:     Andrew Jones <drjones@redhat.com>, Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
References: <20200123180436.99487-1-bgardon@google.com>
 <20200123180436.99487-8-bgardon@google.com>
 <20200124104943.6abkjzegmewnoeiv@kamzik.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <df86f0da-366d-bb20-d1d0-125697c660a8@redhat.com>
Date:   Sat, 25 Jan 2020 10:39:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200124104943.6abkjzegmewnoeiv@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/01/20 11:49, Andrew Jones wrote:
>> +
>> +	/*
>> +	 * Reserve twice the ammount of memory needed to map the test region and
>> +	 * the page table / stacks region, at 4k, for page tables. Do the
>> +	 * calculation with 4K page size: the smallest of all archs. (e.g., 64K
>> +	 * page size guest will need even less memory for page tables).
>> +	 */
>> +	pages += (2 * pages) / PTES_PER_4K_PT;
>> +	pages += ((2 * vcpus * vcpu_memory_bytes) >> PAGE_SHIFT_4K) /
>> +		 PTES_PER_4K_PT;
> pages needs to be rounded up to the next multiple of 16 in order for this
> to work on aarch64 machines with 64k pages.

I think this is best done with a generic function that does the rounding
and an arch-specific function that returns the page size.  Can you send
a patch to implement this?

Thanks,

Paolo


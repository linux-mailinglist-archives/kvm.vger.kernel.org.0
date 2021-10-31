Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00176440D64
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 07:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhJaGzO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 02:55:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26414 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229638AbhJaGzN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Oct 2021 02:55:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635663161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aYgTKb60mO7MO0wuvtOlhBspoOKZc5JUMrX5Ed5BNqU=;
        b=eayx7fad/kpFpOfN6aCpUfGcWS4yURv59Rtkzy3NbtccZeZjOavEsYpxYavdWGvv6z6Q/A
        jKeusLbhu9JfTdaft7D8vBfh0EXAuze1/5vcYxyoBJx90eTDxHfscYVtp1QtxMHUrWvrCx
        9OB8wt+C//HDWOM2xs7ScxSnezRVdU4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-ZmIOOQQRNF-6xH6XOGxKxw-1; Sun, 31 Oct 2021 02:52:40 -0400
X-MC-Unique: ZmIOOQQRNF-6xH6XOGxKxw-1
Received: by mail-wr1-f69.google.com with SMTP id a2-20020a5d4d42000000b0017b3bcf41b9so2315388wru.23
        for <kvm@vger.kernel.org>; Sat, 30 Oct 2021 23:52:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aYgTKb60mO7MO0wuvtOlhBspoOKZc5JUMrX5Ed5BNqU=;
        b=oc41pSXkSudIA/Wlf0uCmdOhk5rCtQMjY4BsJjdaTI5oQxIZjDNfk2BT/1CZiouEwk
         xICbD7OvWlMEtp8ArIaU7psz7avLBhyYqpBCMRUa6kklnn+8ppVUPbKnVIFXcNJkwuHs
         LBwjWPks/woaNyExqWvM6gGy/Z2wFfQRhGUu7mbFtUw2yZpejcincErMwKv8SAApVLOp
         JthWTwV1RmqfsjPBbaITqV3SyajdwlUPH5tqMdJoSHIUxWv7ZviqO3dmBUKnn9WOxxpm
         N8TnJEsw9NmNt0dFXfBD2/p5yUXfI7SHO1c2m1INFpJJkxhr7Gf0RNsnBpZXPqOgclzC
         pZcw==
X-Gm-Message-State: AOAM532X3+moWqJOwXc+SmrEo7vJjhCWQmRGWI/7rYfKU5LN+lapH4HZ
        Sy5FlDnwqvukbwlW4A/7y42Z0sy9Qw6VtVIppBjuCVYqrZYTJzg18XcaDc2YCKVLeSd1z//wDvz
        ESob9P27PQ4U7
X-Received: by 2002:a05:6000:12d2:: with SMTP id l18mr15600084wrx.289.1635663158891;
        Sat, 30 Oct 2021 23:52:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4ULJiKhtZbjwvjl5gLCB6FUvjNgqFUn3ABnn0bbQ8n5CBZ09dcENuQz1qWCAJ7MI47PdlXg==
X-Received: by 2002:a05:6000:12d2:: with SMTP id l18mr15600063wrx.289.1635663158694;
        Sat, 30 Oct 2021 23:52:38 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id w15sm1218416wrk.77.2021.10.30.23.52.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Oct 2021 23:52:37 -0700 (PDT)
Message-ID: <c0dd5fcd-343c-1186-0b1b-3a8ce8a797fe@redhat.com>
Date:   Sun, 31 Oct 2021 07:52:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [EXTERNAL] [PATCH] KVM: x86/xen: Fix runstate updates to be
 atomic when preempting vCPU
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raslan, KarimAllah" <karahmed@amazon.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>
Cc:     "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>
References: <3d2a13164cbc61142b16edba85960db9a381bebe.camel@amazon.co.uk>
 <09f4468b-0916-cf2c-1cef-46970a238ce4@redhat.com>
 <a0906628f31e359deb9e9a6cdf15eb72920c5960.camel@infradead.org>
 <2e7bcafe1077d31d8af6cc0cd120a613cc070cfb.camel@infradead.org>
 <95bee081-c744-1586-d4df-0d1e04a8490f@redhat.com>
 <8950681efdae90b089fcbe65fb0f39612b33cea5.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <8950681efdae90b089fcbe65fb0f39612b33cea5.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/10/21 09:58, David Woodhouse wrote:
>> Absolutely!  The fixed version of kvm_map_gfn should not do any
>> map/unmap, it should do it eagerly on MMU notifier operations.
> Staring at this some more... what*currently*  protects a
> gfn_to_pfn_cache when the page tables change — either because userspace
> either mmaps something else over the same HVA, or the underlying page
> is just swapped out and restored?

kvm_cache_gfn_to_pfn calls gfn_to_pfn_memslot, which pins the page.

Paolo


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B68C4033DD
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 07:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347568AbhIHFhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 01:37:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20222 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347550AbhIHFhS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Sep 2021 01:37:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631079370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dFD339gZoGagg4tSSmQme6S+gWZOs2ChudJRNUISs54=;
        b=Aj+qogM8U7hMW3kkNsLKpWPQHHE6ztecx0Q0UvaZ604fZk8zggs9SXRAfM/mLlEF0uOP64
        MxkjUuKosdVZB2tbZwG9YvTF4Le0u3I0jXxI2liv7EZDFhTx52YVEgVFz3b7NuLaD6vXvH
        V5vWpzAD1YUeBWiSE2J4jqTb3lYFDH4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-W9hIYXZZOVuxQLRL-p-xgg-1; Wed, 08 Sep 2021 01:36:09 -0400
X-MC-Unique: W9hIYXZZOVuxQLRL-p-xgg-1
Received: by mail-ed1-f70.google.com with SMTP id s23-20020a508d17000000b003cde1d7562fso19620eds.9
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 22:36:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dFD339gZoGagg4tSSmQme6S+gWZOs2ChudJRNUISs54=;
        b=ad/2zYJG41LZhRlcGM9WpieEJ/5zdMOAfVWxtuVwVbkHsYHMzJq8cJSWFT9aHykeiz
         J6qNOXywnNoBi+LWgQn0r9cIsE0MuAe9G0j0wTE6/aAB8xtq8gs9OR811121PgogzSRd
         hJ48vkp73A8kuoX2Tl7+xUJeEpO8jdDyBASpebmxH2U7VhkTp7jFex8OaFJ4jeEjGtPs
         +AT0QgD4GqA+98AFW4rkG0NI7t637ArBIr/nHf2TmDdO6H3QATmldbYNiDdIVNnmciUs
         fOc8ccyo3bcilxGBO13d/bNPh8rzpwpkqs6EADU5g3Ha3Y0cbwehoHdClB75csXUpPam
         6dXg==
X-Gm-Message-State: AOAM531vfhfMSDfwqnW7KgH7yg9Z7L2ypB5gQME6DLNo8UWY9WRB1fp6
        Q1Uv5Zu+46qQYUe2hwXHavjA7WR/S9cWAAVAjRumi5Jxv3Dpm/BXqTA/IO1onSbYcpr37xI7/aZ
        sdtKUZLOWTZP7
X-Received: by 2002:a50:ab42:: with SMTP id t2mr2084750edc.113.1631079367434;
        Tue, 07 Sep 2021 22:36:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyyc6RwiUcNrrlYLIs4pe6r1E3Z5trGvuncJEIl8W+/WZ0elXTSBFJvbD524S8a0IU4LMkBsQ==
X-Received: by 2002:a50:ab42:: with SMTP id t2mr2084726edc.113.1631079367262;
        Tue, 07 Sep 2021 22:36:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q9sm383547ejf.70.2021.09.07.22.36.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 22:36:06 -0700 (PDT)
Subject: Re: [syzbot] WARNING: kmalloc bug in memslot_rmap_alloc
To:     Sean Christopherson <seanjc@google.com>,
        syzbot <syzbot+e0de2333cbf95ea473e8@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jarkko@kernel.org, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, mingo@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Gardon <bgardon@google.com>
References: <0000000000006096fa05cb454a9c@google.com>
 <YTehmR1+G34uOHh3@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2e6b9e6d-30b4-6cb4-1eb7-c626e5d2adb3@redhat.com>
Date:   Wed, 8 Sep 2021 07:36:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YTehmR1+G34uOHh3@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/09/21 19:30, Sean Christopherson wrote:
> The allocation in question is for KVM's "rmap" to translate a guest pfn to a host
> virtual address.  The size of the rmap in question is an unsigned long per 4kb page
> in a memslot, i.e. on x86-64, 8 bytes per 4096 bytes of guest memory in a memslot.
> With INT_MAX=0x7fffffff, KVM will trip the WARN and fail rmap allocations for
> memslots >= 1tb, and Google already has VMs that create 1.5tb memslots (12tb of
> total guest memory spread across 8 virtual NUMA nodes).

We can just use vmalloc.  The warning was only added on kvmalloc, and 
vmalloc suits the KVM rmap just fine.

The maximum that Red Hat has tested, as far as I know, is about 4TiB 
(and it was back when there was no support for virtual NUMA nodes in 
QEMU, so it was all in a single memslot).

Paolo


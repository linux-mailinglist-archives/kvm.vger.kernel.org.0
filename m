Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0759F37AF50
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 21:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbhEKTad (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 15:30:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38056 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231808AbhEKTab (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 15:30:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620761364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U8VQQPkbOEAUOoAyHQFpuOhcMTPtNaQqkF/sYSE/zpM=;
        b=B/bIyXmmCG5jisfd8ld2Jy1J3qMRichwyBQTaMrcNrBmaB4Cnn0lZ2zN9VSC+qYGlSYdU1
        9TII28oWI2RcFO5qUor/cf+kKFZvIk/62EP6x0fFMSlEWHiNVKKzRa+dxdUhOieoYpyKkV
        eafbQ53O0IJWk2cy2/hD6+lEs2X2fis=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-EW5WDJC6Pjy2vZ9vqwoyVQ-1; Tue, 11 May 2021 15:29:22 -0400
X-MC-Unique: EW5WDJC6Pjy2vZ9vqwoyVQ-1
Received: by mail-ed1-f71.google.com with SMTP id d18-20020aa7d6920000b0290388b4c7ee24so11574498edr.12
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 12:29:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U8VQQPkbOEAUOoAyHQFpuOhcMTPtNaQqkF/sYSE/zpM=;
        b=EvMlK7VAWertKHzSCwweb717eG5CF6YI/ekHlzJNt/TXVFxAl+woazwRzus0+IQzvY
         XgHRqu1sgfjpauUCV5j73wr/7a+5iHdxjqTRhXeOcitOg5GvIwhiHPKbJC/6LSkpswoj
         IqFHGgVhiJn6UwF662q0PdpSpWulpAkowp/flDWprruxAJ/sYSAwm6oEaqFjIUUXNXiw
         4BEzq+pqZxKbuBA4DfxW6mWDsAXX2DNWqVuagDhu6zPPCAFMpIhnBewsGePY4MpA6KVe
         Rw3qXwyE0YtDuP4LN/ZkIHGeLO7OmTMwwspNJ3TsX2ihM1dweBZuOcQA+bzOzO+nthuV
         7UVw==
X-Gm-Message-State: AOAM530IntQL8gEo5jBJj7Tjj0adQt+0aHlV9heKu1ri6DqaOrNN9Vms
        Z5JQxTn8/gfGTQBEtw1FP5J0HeXL7y6wvZ02a8aD33pRDPBf7xlYmHnjtOynKTzDBPaB6GoxD7k
        CVCeWO5Gtf1Yh
X-Received: by 2002:a17:907:1181:: with SMTP id uz1mr33342238ejb.194.1620761361662;
        Tue, 11 May 2021 12:29:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz0Dx7qUS1VH55IC/UGrUERRS9i04SgOldQ9s1zOM6fqquzgDeHq4sdHSqIP00yWitAHY9XFw==
X-Received: by 2002:a17:907:1181:: with SMTP id uz1mr33342216ejb.194.1620761361418;
        Tue, 11 May 2021 12:29:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u4sm1654908eds.1.2021.05.11.12.29.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 12:29:20 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
References: <20210511171610.170160-1-bgardon@google.com>
 <20210511171610.170160-5-bgardon@google.com> <YJrZKkW9Cb9t+fU5@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v4 4/7] KVM: mmu: Add slots_arch_lock for memslot arch
 fields
Message-ID: <ef473b52-0b71-a524-ed36-c2c1a9d0fb03@redhat.com>
Date:   Tue, 11 May 2021 21:29:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YJrZKkW9Cb9t+fU5@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/05/21 21:21, Sean Christopherson wrote:
>> +	/* Released in install_new_memslots. */
> 
> This needs a much more comprehensive comment, either here or above the declaration
> of slots_arch_lock.  I can't find anything that explicitly states the the lock
> must be held from the time the previous memslots are duplicated/copied until the
> new memslots are set.  Without that information, the rules/expecations are not
> clear.

Indeed, this needs basically a description of the races that can happen, 
as you explained them in the v1 review.

> Unfortunately I'm just whining at this point since I
> don't have a better idea 

Yeah, the synchronize_srcu call in install_new_memslots throws a wrench 
in most alternatives.

Paolo


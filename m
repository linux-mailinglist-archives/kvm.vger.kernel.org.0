Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 600E0392D5E
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 13:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234569AbhE0MAu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 08:00:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41184 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234143AbhE0MAt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 08:00:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622116756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sUtiI4Fe1B9qbHTQE1gbPvDhVZY9Emw2okytcwWLhjI=;
        b=bZzJNn9SsJRqMdiUTVkTs9GIkbranWtcgybp1F74t9dmgB6TqvpoGQm0a3pMhltPDJo6aF
        3iZnVs2If/2yk+S4VqELUjcZ/eBVmP3GWVNhSEaPHeuPSXWRxulUvIiQkFjR+JLmkuhh6m
        jL2a6XqHqqHZdjbhvIdDVn0D2I89nYA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-J5rtGjRfPtSM8tVaDM5NYQ-1; Thu, 27 May 2021 07:59:14 -0400
X-MC-Unique: J5rtGjRfPtSM8tVaDM5NYQ-1
Received: by mail-ed1-f70.google.com with SMTP id b8-20020a05640202c8b029038f1782a77eso180659edx.15
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 04:59:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sUtiI4Fe1B9qbHTQE1gbPvDhVZY9Emw2okytcwWLhjI=;
        b=BjYl60SUxqKchI9UmpNbik8YpWUsVFwNpg74CgiwG2YGyj6O73N2a8jWZyh8UBYpqD
         kjr+SnT47OFI4mjGzbQBh28qCXkv/1K/bPAXnU+tlhuQvFolFz6qRSs/xLnA/B8iAKsU
         s/IKdnRgOOFczATygB7Ui4EVZZjtpBqPoM58le0f2Jjtq5p73+RTXvb+7SgcPHtfpzTk
         NvRvrEUbn643IsK/qs9m2rmN2ukvuT5Er9ufn1+FIn2B9+Bk/QMDffm7611Dn+FQGlB5
         NsdzqylHMt5/joM3KOdBe2yvc4Yj3XDRFBSE7vPwt4qymnU/VUKuUhDBNaPt0Y1qfCmN
         O1ow==
X-Gm-Message-State: AOAM533ip0ZbGfZVBKo8D/ALPJTvJ7AqIx+uoyx3KcI7f5Lh64Fh/5sD
        dc4tqJwhhaIlZjHvOQWSMp4vci+VIcD9bEqm55k96NpLvled+RZM9pO/VuL8sX5ekdpgPJ20OXw
        jgYWtIKvMSc2B
X-Received: by 2002:a17:906:b0c9:: with SMTP id bk9mr3355846ejb.517.1622116753374;
        Thu, 27 May 2021 04:59:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzDVNZ+TpAQjfwfgh7qTGh5/HgtsVl2VD1dTRcnEeZCNrWGbTG5oegkGgV7n3nv36uLC64odg==
X-Received: by 2002:a17:906:b0c9:: with SMTP id bk9mr3355829ejb.517.1622116753205;
        Thu, 27 May 2021 04:59:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q4sm972714edv.24.2021.05.27.04.59.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 04:59:12 -0700 (PDT)
Subject: Re: [patch 0/3] VMX: configure posted interrupt descriptor when
 assigning device (v5)
To:     Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Xu <peterx@redhat.com>
References: <20210525134115.135966361@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e0248f95-e003-78fd-63ab-1d00b75b04e6@redhat.com>
Date:   Thu, 27 May 2021 13:59:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210525134115.135966361@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/05/21 15:41, Marcelo Tosatti wrote:
> Configuration of the posted interrupt descriptor is incorrect when devices
> are hotplugged to the guest (and vcpus are halted).
> 
> See patch 3 for details.
> 
> ---
> 
> v5: use KVM_REQ_UNBLOCK instead of kvm_check_block callback (Paolo / Peter Xu)
> 
> v4: remove NULL assignments from kvm_x86_ops (Peter Xu)
>      check for return value of ->start_assignment directly (Peter Xu)
> 
> v3: improved comments (Sean)
>      use kvm_vcpu_wake_up (Sean)
>      drop device_count from start_assignment function (Peter Xu)
> 
> v2: rather than using a potentially racy IPI (vs vcpu->cpu switches),
>      kick the vcpus when assigning a device and let the blocked per-CPU
>      list manipulation happen locally at ->pre_block and ->post_block
>      (Sean Christopherson).
> 
> 
> 

Queued, thanks.

Paolo


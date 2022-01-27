Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6C049E22E
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 13:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240908AbiA0MUa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 07:20:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58188 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236183AbiA0MU2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jan 2022 07:20:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643286028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uzpPscL9z4wKz7qcRqkschJ/Kte7IRMKOsYVxWkBfuo=;
        b=dD9wyTWfF2jVCToiHHjZgVJRU2arm+0aFlD52fTmDicLkv5wiT7W2UV7pAIDCGlJQF1Rmx
        oa/sBao5P1S1syR9O6TrEeDd0SPvgsLN9Z6yzI7fjYNqw6lvFgLbllAre2DyQl/UfXw5jr
        kwKE0vpkxbr/vzw3c1+zjG6VE19Wnik=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-mwbYJzFyNzegA7DWTg6i6w-1; Thu, 27 Jan 2022 07:20:26 -0500
X-MC-Unique: mwbYJzFyNzegA7DWTg6i6w-1
Received: by mail-ed1-f72.google.com with SMTP id en7-20020a056402528700b00404aba0a6ffso1339548edb.5
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 04:20:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uzpPscL9z4wKz7qcRqkschJ/Kte7IRMKOsYVxWkBfuo=;
        b=0pRdfyM2KAjNj/n2sOeY9YSZgHwdgfazbSj09gqYhhAgdcn714RQLVxeqIyy7ZKXjE
         iZE7ZBrRrcqCuDXOLS7aIZCs8mO2PrAQy+aCNOHAZwCVfKgTQvCnqsX8U3KZ6+DJ1xVI
         1JsiFTSjDxd/fCt+943trI8Es1wQ6rzgPnCqDgRY1wZDnrkVH8JPWP4v9M7CjqbQ5v1h
         bbdldppgB/Qemw5cy9LF7cCOzugB401XT8QDsCRs5N78sKThlj32T7DwTDT2E1GB7rPU
         KYJCy9GMwyeIfCOasXf6eeCbiqNznNshmmhiTZguw6RpvsmuPV+xi3NV8+ACWCi8MO9u
         yJIw==
X-Gm-Message-State: AOAM533IMe8kjmyyMZnkE6+fdloOAGThRVdLObGylXq7LWwd/xkPUPsG
        3ss4NIaaL1dkEt4BMrxS7eJ7uof4jPB+lG3H0r4GhR+HBEqnTn8rV38ZQJyEN/h6GDpJ9SSIrPa
        Lc4v2ZkGs/Ew8
X-Received: by 2002:a05:6402:1c95:: with SMTP id cy21mr3510977edb.180.1643286025707;
        Thu, 27 Jan 2022 04:20:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwovAiE8N4jHhYASNZqJZt1yAAMrrkhIsQg2fCzq3+XZzBwoZpG3I1ETIWyayqdACKNNzfFAg==
X-Received: by 2002:a05:6402:1c95:: with SMTP id cy21mr3510962edb.180.1643286025540;
        Thu, 27 Jan 2022 04:20:25 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id c14sm11297432edy.66.2022.01.27.04.20.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 04:20:25 -0800 (PST)
Message-ID: <3f4efc3d-f351-0fcb-e231-b422ea262f66@redhat.com>
Date:   Thu, 27 Jan 2022 13:20:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: use set_page_dirty rather than SetPageDirty
Content-Language: en-US
To:     Chris Mason <clm@fb.com>, Boris Burkov <boris@bur.io>
Cc:     Sean Christopherson <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
References: <08b5b2c516b81788ca411dc031d403de4594755e.1643226777.git.boris@bur.io>
 <YfHEJpP+1c9QZxA0@google.com> <YfHVB5RmLZn2ku5M@zen>
 <3876CE62-6E66-4CCE-ADED-69010EA72394@fb.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <3876CE62-6E66-4CCE-ADED-69010EA72394@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/27/22 01:02, Chris Mason wrote:
> From the btrfs side, bare calls to set_page_dirty() are suboptimal,
> since it doesn’t go through the ->page_mkwrite() dance that we use to
> properly COW things.  It’s still much better than SetPageDirty(), but
> I’d love to understand why kvm needs to dirty the page so we can
> figure out how to go through the normal mmap file io paths.
Shouldn't ->page_mkwrite() occur at the point of get_user_pages, such as 
via handle_mm_fault->handle_pte_fault->do_fault->do_shared_fault?  That 
always happens before SetPageDirty(), or set_page_dirty() after Boris's 
patch.

Thanks,

Paolo


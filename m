Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2073B0AAF
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 18:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhFVQyc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 12:54:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51601 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230076AbhFVQya (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 12:54:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624380733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4P1PfITd6m9CRCYryDXbjzGuOd03lvZO6GwMrQOOd8k=;
        b=RZ3jyMWVgsKGixQcFMbjo5Z+S7U83pEDWFWf4lMkpCbG+R4YDQBDAC5FrithoqJn9oKb5w
        owPvco3JHsZmGLFD/ksbfduX6SzRnW6BXkf2cx05CfN0v+/LEhp35l61OwdVxMJcoGyMv0
        EFS0LpgcXZEie1J8glLLUVa4TiCdlso=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-KNVKk5mPNO2oHlx1x0qg_w-1; Tue, 22 Jun 2021 12:52:12 -0400
X-MC-Unique: KNVKk5mPNO2oHlx1x0qg_w-1
Received: by mail-wm1-f69.google.com with SMTP id w186-20020a1cdfc30000b02901ced88b501dso937374wmg.2
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 09:52:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4P1PfITd6m9CRCYryDXbjzGuOd03lvZO6GwMrQOOd8k=;
        b=a8PfVQ6CeuvEtO6sRUZREslbaTaE6WmvZpmHeS4M+rWtUjQrYgFWnXoQAHgePEhG3F
         ggyyg31E2gbvGCSrX015w1R7v3N7LdppLfZn3RKQLbe6cB8C9vUGLTJ841tyQpLKN+Km
         6Aol/TN1pkkcR4Olgl2+VCPqKo6FL0nIT7eMIcJXNooQezztLijLS5NHU8/YUQU9cAeG
         B4LtyJP9XQBh0RDgII7otWE+bOxFIVH3HMYUmZb5pgn52Ea+lwcTHy+00jDBZtvMt46D
         NxIOQzMviYXiHuQTgvW4UNLqx2eI4SMmM2HAm4smUYZWxObjVUM1qtT9czjAsoWArxD0
         Y/gA==
X-Gm-Message-State: AOAM531g2oVOiOS3IF7CQe8KFiLXYpzTKatf1Q6eopfjY2Ox4o2JAwUg
        plAbPlbxZ5Oh7XVTOJ4wumo7pvgIch+bprSGu3+/WrVOoVWS0kWIDiCEMdK3WB9CiewO+iROYos
        Kxf0uS6UhKzrw
X-Received: by 2002:a5d:4904:: with SMTP id x4mr5938991wrq.202.1624380731194;
        Tue, 22 Jun 2021 09:52:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHwvAETSGbesb6gzKh+dnovh/8/FzEzs9O+mu8f0VjdUXRziEiWzP7ITmfJWkfwxeiQrPAIQ==
X-Received: by 2002:a5d:4904:: with SMTP id x4mr5938982wrq.202.1624380731048;
        Tue, 22 Jun 2021 09:52:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n18sm3132025wmq.41.2021.06.22.09.52.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 09:52:10 -0700 (PDT)
Subject: Re: linux-next: manual merge of the kvm tree with the powerpc tree
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        KVM <kvm@vger.kernel.org>,
        PowerPC <linuxppc-dev@lists.ozlabs.org>
Cc:     Ashish Kalra <ashish.kalra@amd.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20210622152544.74e01567@canb.auug.org.au>
 <9c2dbe56-4c64-0032-0acb-2e2925c7a2ab@redhat.com>
 <871r8u2bqp.fsf@mpe.ellerman.id.au>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <479d2898-07d6-9a40-70e5-f33c91943d52@redhat.com>
Date:   Tue, 22 Jun 2021 18:52:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <871r8u2bqp.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/21 16:51, Michael Ellerman wrote:
>> Please drop the patches at
>> https://www.spinics.net/lists/kvm-ppc/msg18666.html  from the powerpc
>> tree, and merge them through either the kvm-powerpc or kvm trees.
> The kvm-ppc tree is not taking patches at the moment.

If so, let's remove the "T" entry from MAINTAINERS and add an entry for 
the kvm@vger.kernel.org mailing list.

>   https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git/log/?h=topic/ppc-kvm
> 
> The commit Stephen mentioned has been rebased since to squash in a fix.
> But what is in the topic branch is now final, I won't rebase what's
> there.

Thanks, I pulled it.  Anyway, if the workflow is not the one indicated 
by MAINTAINERS it's never a bad idea to Cc more people when applying 
patches.

Paolo


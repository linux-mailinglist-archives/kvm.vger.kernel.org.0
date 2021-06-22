Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D063AFD06
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 08:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhFVGZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 02:25:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21310 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229628AbhFVGZp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 02:25:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624343009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aQqfkvCtBb6g17+HqN0uwZioUK6+vGsvOXTdTvz9LIc=;
        b=fZbAp+kY9Oq/YcndHYZ02y2K9/mDYZvIsJ1pA++0V7SNbrwRzWWf3De51W4uTxu7IbGfQn
        awtaSu6T8DEMJs6H8CYaJP4jjIm6p0iRe8FYbVtjEDNiy55g/qPya7r6sbQGQXl7FfRiLD
        kQmN9PanN+ampm7TuUyBSOrm6XiVArA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-9lEXvDGPO96ZsVOU8x86rw-1; Tue, 22 Jun 2021 02:23:28 -0400
X-MC-Unique: 9lEXvDGPO96ZsVOU8x86rw-1
Received: by mail-wm1-f69.google.com with SMTP id l9-20020a05600c1d09b02901dc060832e2so910689wms.1
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 23:23:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aQqfkvCtBb6g17+HqN0uwZioUK6+vGsvOXTdTvz9LIc=;
        b=WfuVLr5lxF4uoxhsfkZu2EvHpiExWJX/rLdJK6MqhlICBY9TpJA6YAOU3C5X3CslS+
         7VeyFvqIgUWE84QIaqhWivDhXbPGGpr8S4nOpnP7E1n2Qz6zxQ59TL6NxfLz18dXiwDi
         E1foYVt8RcDZghwQvUu13Sr5Rv3Z52Jc/KPAioRydXI5no1IY3FphO1b4LgEr4J1PFSs
         gzGnWKj42z2SL0LEhhMbiaD4TLGm8sZNWbJeaxggPFXR3nSNeIpcL0f8sMQ6cP3+V5qK
         GY9C9mQCWPOX4CHP+BguaxcYbYt3Ck1EM3RFbitHLEteHA4U1u0rEC5rWo6m195zGkse
         k8PQ==
X-Gm-Message-State: AOAM533Dv1U8KY1Fe5kV8lefcIry6nk4hP1mvQ+PRTbROEdmaIWFrzs0
        Ipq1LO7rLkleXIdIG4HB8uJF6TAckTOOzgslBnMFRfACYNsYgfeitcKIelbSasmuGf9FCTkEdRj
        9R8FW6YnP+jBv
X-Received: by 2002:a5d:44d2:: with SMTP id z18mr2678886wrr.358.1624343006203;
        Mon, 21 Jun 2021 23:23:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyH/4w8wmlBb+QUv5p9+m3hdd4Lh4ZTIRS504JjrKAX2ybZM9tGHk+qPRypejrUSPVJj6nMOg==
X-Received: by 2002:a5d:44d2:: with SMTP id z18mr2678861wrr.358.1624343006005;
        Mon, 21 Jun 2021 23:23:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a1sm26072095wra.63.2021.06.21.23.23.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 23:23:25 -0700 (PDT)
Subject: Re: linux-next: manual merge of the kvm tree with the powerpc tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>, KVM <kvm@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
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
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9c2dbe56-4c64-0032-0acb-2e2925c7a2ab@redhat.com>
Date:   Tue, 22 Jun 2021 08:23:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210622152544.74e01567@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/21 07:25, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the kvm tree got a conflict in:
> 
>    include/uapi/linux/kvm.h
> 
> between commit:
> 
>    9bb4a6f38fd4 ("KVM: PPC: Book3S HV: Add KVM_CAP_PPC_RPT_INVALIDATE capability")
> 
> from the powerpc tree and commits:
> 
>    644f706719f0 ("KVM: x86: hyper-v: Introduce KVM_CAP_HYPERV_ENFORCE_CPUID")
>    6dba94035203 ("KVM: x86: Introduce KVM_GET_SREGS2 / KVM_SET_SREGS2")
>    0dbb11230437 ("KVM: X86: Introduce KVM_HC_MAP_GPA_RANGE hypercall")
> 
> from the kvm tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
> 

What are the dependencies of these KVM patches on patches from the bare 
metal trees, and can you guys *please* start using topic branches?

I've been asking you for literally years, but this is the first time I 
remember that Linus will have to resolve conflicts in uAPI changes and 
it is *not* acceptable.

Please drop the patches at 
https://www.spinics.net/lists/kvm-ppc/msg18666.html from the powerpc 
tree, and merge them through either the kvm-powerpc or kvm trees.

Paolo


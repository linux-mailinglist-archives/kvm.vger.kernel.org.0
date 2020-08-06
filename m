Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74CBB23D879
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 11:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbgHFJUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 05:20:19 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30935 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729127AbgHFJUC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Aug 2020 05:20:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596705600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Qbng0KIuhjnrRqPApXRDER8ey72aYykcRLaK9qO7KvA=;
        b=aJoNTiGNVQq/9rsm+zX69b3d7pA2f2jaLzsv18RemmSfJapF4oenDiwwvK8wT0QfD3q2Ut
        Hj5ZyyB+g9Lr/fmV5M4jC7mQHKfKXr455RpBJY8L44GTbqF5ALBPZi+Z/DEU0IOi2R+JQn
        956138YIj5+dCQZQxzhL+Ur46Iyd1JU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-K08FyLgEMxmoyIFJlY5sug-1; Thu, 06 Aug 2020 05:19:58 -0400
X-MC-Unique: K08FyLgEMxmoyIFJlY5sug-1
Received: by mail-ej1-f69.google.com with SMTP id op5so4838383ejb.2
        for <kvm@vger.kernel.org>; Thu, 06 Aug 2020 02:19:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Qbng0KIuhjnrRqPApXRDER8ey72aYykcRLaK9qO7KvA=;
        b=MKXLaP0BVy9XQGCFbmDHKl2ceuRz2lm4rVcQRapCnG6eY1AI5JfpJ8fiNYGjPof1lx
         WhGXCM5O0OiHLsBqRy3xr/2xsbPtzQmTthyogsLPPG7XgHx+vhUqXWSyJBJcAdZ5cB1/
         VCbzHNlq7/FtTk0GB9I1n/nNnfgna91q+TFmTUw0Jc7/Rge3gfDfECUtqO6Y70tmWAwp
         VEVsuw3ORj+PXTlkuhx8zC7mx5nvPsTwsjouAigkdulvXjFP8X+z3sdsLecrIYKuvFWj
         9mep3FgRBAK8OgO116/N/iNKm/aWXQpGSezpHOXHV7oNYFHy2HjauqDBqImfuWDrtVnb
         yoeQ==
X-Gm-Message-State: AOAM53049tSytzRjIXjfzUhJ5P68i03udy9SA0bOa4e3X3+ROJKddGas
        RUPlQul8I6iPGvDqa693OP90OoXKAvTxS3YYtu8gh/xQ3I8D8l8bHg9zf9sb356gY83FQHQ/cv3
        coO8DcgQ5QaOQ
X-Received: by 2002:a17:906:c1c3:: with SMTP id bw3mr3607435ejb.8.1596705596999;
        Thu, 06 Aug 2020 02:19:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxuRhDEaObKZG/m3SESq3Y56+cff+sBnsRhNDN/4SkNQ35QaOrvvNAQiLpZKC54ekRuuLKNEA==
X-Received: by 2002:a17:906:c1c3:: with SMTP id bw3mr3607421ejb.8.1596705596800;
        Thu, 06 Aug 2020 02:19:56 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id i9sm3312397ejb.48.2020.08.06.02.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 02:19:56 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] KVM: x86: KVM_MEM_PCI_HOLE memory
In-Reply-To: <20200805201851-mutt-send-email-mst@kernel.org>
References: <20200728143741.2718593-1-vkuznets@redhat.com> <20200805201851-mutt-send-email-mst@kernel.org>
Date:   Thu, 06 Aug 2020 11:19:55 +0200
Message-ID: <873650p1vo.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:

> On Tue, Jul 28, 2020 at 04:37:38PM +0200, Vitaly Kuznetsov wrote:
>> This is a continuation of "[PATCH RFC 0/5] KVM: x86: KVM_MEM_ALLONES
>> memory" work: 
>> https://lore.kernel.org/kvm/20200514180540.52407-1-vkuznets@redhat.com/
>> and pairs with Julia's "x86/PCI: Use MMCONFIG by default for KVM guests":
>> https://lore.kernel.org/linux-pci/20200722001513.298315-1-jusual@redhat.com/
>> 
>> PCIe config space can (depending on the configuration) be quite big but
>> usually is sparsely populated. Guest may scan it by accessing individual
>> device's page which, when device is missing, is supposed to have 'pci
>> hole' semantics: reads return '0xff' and writes get discarded.
>> 
>> When testing Linux kernel boot with QEMU q35 VM and direct kernel boot
>> I observed 8193 accesses to PCI hole memory. When such exit is handled
>> in KVM without exiting to userspace, it takes roughly 0.000001 sec.
>> Handling the same exit in userspace is six times slower (0.000006 sec) so
>> the overal; difference is 0.04 sec. This may be significant for 'microvm'
>> ideas.
>> 
>> Note, the same speed can already be achieved by using KVM_MEM_READONLY
>> but doing this would require allocating real memory for all missing
>> devices and e.g. 8192 pages gives us 32mb. This will have to be allocated
>> for each guest separately and for 'microvm' use-cases this is likely
>> a no-go.
>> 
>> Introduce special KVM_MEM_PCI_HOLE memory: userspace doesn't need to
>> back it with real memory, all reads from it are handled inside KVM and
>> return '0xff'. Writes still go to userspace but these should be extremely
>> rare.
>> 
>> The original 'KVM_MEM_ALLONES' idea had additional optimizations: KVM
>> was mapping all 'PCI hole' pages to a single read-only page stuffed with
>> 0xff. This is omitted in this submission as the benefits are unclear:
>> KVM will have to allocate SPTEs (either on demand or aggressively) and
>> this also consumes time/memory.
>
> Curious about this: if we do it aggressively on the 1st fault,
> how long does it take to allocate 256 huge page SPTEs?
> And the amount of memory seems pretty small then, right?

Right, this could work but we'll need a 2M region (one per KVM host of
course) filled with 0xff-s instead of a single 4k page.

Generally, I'd like to reach an agreement on whether this feature (and
the corresponding Julia's patch addding PV feature bit) is worthy. In
case it is (meaning it gets merged in this simplest form), we can
suggest further improvements. It would also help if firmware (SeaBIOS,
OVMF) would start recognizing the PV feature bit too, this way we'll be
seeing even bigger improvement and this may or may not be a deal-breaker
when it comes to the 'aggressive PTE mapping' idea.

-- 
Vitaly


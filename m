Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65EE8C8A1B
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 15:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbfJBNqh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 09:46:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43094 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbfJBNqh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 09:46:37 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A247BC05168C
        for <kvm@vger.kernel.org>; Wed,  2 Oct 2019 13:46:36 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id t11so7492775wro.10
        for <kvm@vger.kernel.org>; Wed, 02 Oct 2019 06:46:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kPx8eHGD2bHazCr1CGLJp8Q8NfVHXws6Datb9inEIfY=;
        b=nZHgLlDDPjWbJMltYjf/n5e3OKR4tz6iKbIdHlDgy2RSNPTCYe4jg9ZU0Fu/YDvy9l
         tw2lRZQrtmwhRnfz53Aq2vBkKEkakeWe8YXrK8gv8kSiy3T6MACdFv879/qbJQ5O40h/
         BnIcRWM67U1F8j6L6CcaRMP0sqwYETmQgr8uJeS77+dCuOpuniZChuVH7SpuIqSELIgA
         U4mjBRWItzJTxM8cIP2nykWHD4/9Pa4Wnk562ZId3l++Fw+T9bWPKepfK8AW+W4IgP2F
         SbFAsLBj0qMueH1VepJ/nzwqT/t9S2p6lWrQ18BRRKb02saDzI3Nw1RauYff0jqfazHc
         eyFg==
X-Gm-Message-State: APjAAAWaIkeOmSBsj9ab6qryI6dsGQ2lvvoh4Gw3ZLugowf2Chey4BiY
        XIPeuc8QVKiaTtP8ihu9Le5c1dYiNGDxchueqlGoojJlGARYnO4BEOJqSLzVnCqvmn7ZqsCr6SX
        SfNCnh0ewVq4T
X-Received: by 2002:a1c:1981:: with SMTP id 123mr2922468wmz.88.1570023995240;
        Wed, 02 Oct 2019 06:46:35 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx8qDYPL+VQO03VD6k1hrbeHasztg7iAYo7N7CmPWC4P/WVBb1+qFIK7XJ0Y9eQOY8+Wb3Orw==
X-Received: by 2002:a1c:1981:: with SMTP id 123mr2922450wmz.88.1570023994911;
        Wed, 02 Oct 2019 06:46:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b903:6d6f:a447:e464? ([2001:b07:6468:f312:b903:6d6f:a447:e464])
        by smtp.gmail.com with ESMTPSA id z1sm38078286wre.40.2019.10.02.06.46.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2019 06:46:33 -0700 (PDT)
Subject: Re: DANGER WILL ROBINSON, DANGER
To:     Jerome Glisse <jglisse@redhat.com>,
        Mircea CIRJALIU - MELIU <mcirjaliu@bitdefender.com>
Cc:     =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>,
        Matthew Wilcox <willy@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?Q?Samuel_Laur=c3=a9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-72-alazar@bitdefender.com>
 <20190809162444.GP5482@bombadil.infradead.org>
 <1565694095.D172a51.28640.@15f23d3a749365d981e968181cce585d2dcb3ffa>
 <20190815191929.GA9253@redhat.com> <20190815201630.GA25517@redhat.com>
 <VI1PR02MB398411CA9A56081FF4D1248EBBA40@VI1PR02MB3984.eurprd02.prod.outlook.com>
 <20190905180955.GA3251@redhat.com>
 <5b0966de-b690-fb7b-5a72-bc7906459168@redhat.com>
 <DB7PR02MB3979D1143909423F8767ACE2BBB60@DB7PR02MB3979.eurprd02.prod.outlook.com>
 <20191002192714.GA5020@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ab461f02-e6cd-de0f-b6ce-0f5a95798eaa@redhat.com>
Date:   Wed, 2 Oct 2019 15:46:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191002192714.GA5020@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/19 21:27, Jerome Glisse wrote:
> On Tue, Sep 10, 2019 at 07:49:51AM +0000, Mircea CIRJALIU - MELIU wrote:
>>> On 05/09/19 20:09, Jerome Glisse wrote:
>>>> Not sure i understand, you are saying that the solution i outline
>>>> above does not work ? If so then i think you are wrong, in the above
>>>> solution the importing process mmap a device file and the resulting
>>>> vma is then populated using insert_pfn() and constantly keep
>>>> synchronize with the target process through mirroring which means that
>>>> you never have to look at the struct page ... you can mirror any kind
>>>> of memory from the remote process.
>>>
>>> If insert_pfn in turn calls MMU notifiers for the target VMA (which would be
>>> the KVM MMU notifier), then that would work.  Though I guess it would be
>>> possible to call MMU notifier update callbacks around the call to insert_pfn.
>>
>> Can't do that.
>> First, insert_pfn() uses set_pte_at() which won't trigger the MMU notifier on
>> the target VMA. It's also static, so I'll have to access it thru vmf_insert_pfn()
>> or vmf_insert_mixed().
> 
> Why would you need to target mmu notifier on target vma ?

If the mapping of the source VMA changes, mirroring can update the
target VMA via insert_pfn.  But what ensures that KVM's MMU notifier
dismantles its own existing page tables (so that they can be recreated
with the new mapping from the source VMA)?

Thanks,

Paolo

> You do not need
> that. The workflow is:
> 
>     userspace:
>         ptr = mmap(/dev/kvm-mirroring-device, virtual_addresse_of_target)
> 
> Then when the mirroring process access ptr it triggers page fault that
> endup in the vm_operation_struct->fault() which is just doing:
> 
>     kernel-kvm-mirroring-function:
>         kvm_mirror_page_fault(struct vm_fault *vmf) {
>             struct kvm_mirror_struct *kvmms;
> 
>             kvmms = kvm_mirror_struct_from_file(vmf->vma->vm_file);
>             ...
>         again:
>             hmm_range_register(&range);
>             hmm_range_snapshot(&range);
>             take_lock(kvmms->update);
>             if (!hmm_range_valid(&range)) {
>                 vm_insert_pfn();
>                 drop_lock(kvmms->update);
>                 hmm_range_unregister(&range);
>                 return VM_FAULT_NOPAGE;
>             }
>             drop_lock(kvmms->update);
>             goto again;
>         }
> 
> The notifier callback:
>         kvmms_notifier_start() {
>             take_lock(kvmms->update);
>             clear_pte(start, end);
>             drop_lock(kvmms->update);
>         }
> 
>>
>> Our model (the importing process is encapsulated in another VM) forces us
>> to mirror certain pages from the anon VMA backing one VM's system RAM to 
>> the other VM's anon VMA. 
> 
> The mirror does not have to be an anon vma it can very well be a
> device vma ie mmap of a device file. I do not see any reasons why
> the mirror need to be an anon vma. Please explain why.
> 
>>
>> Using the functions above means setting VM_PFNMAP|VM_MIXEDMAP on 
>> the target anon VMA, but I guess this breaks the VMA. Is this recommended?
> 
> The mirror vma should not be an anon vma.
> 
>>
>> Then, mapping anon pages from one VMA to another without fixing the 
>> refcount and the mapcount breaks the daemons that think they're working 
>> on a pure anon VMA (kcompactd, khugepaged).
> 
> Note here the target vma ie the mirroring one is a mmap of device file
> and thus is skip by all of the above (kcompactd, khugepaged, ...) it is
> fully ignore by core mm.
> 
> Thus you do not need to fix the refcount in any way. If any of the core
> mm try to reclaim memory from the original vma then you will get mmu
> notifier callbacks and all you have to do is clear the page table of your
> device vma.
> 
> I did exactly that as a tools in the past and it works just fine with
> no change to core mm whatsoever.
> 
> Cheers,
> Jérôme
> 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45A54C8E19
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 18:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfJBQSM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 12:18:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57310 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbfJBQSL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 12:18:11 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3235AC004E8D
        for <kvm@vger.kernel.org>; Wed,  2 Oct 2019 16:18:11 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id f63so2279630wma.7
        for <kvm@vger.kernel.org>; Wed, 02 Oct 2019 09:18:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/v3cLVQkUXMFYA41ytcIYtOGrK2O1kisY2oYiPOm+oU=;
        b=GQ8L0rTPOJ+8hPSw4fXIkaQPF+7WW6+6KMbep+k/MsZ2lM8vjC3KHAN6QPNK4ExPvG
         CIL6OnNOqdARebEFf0J3hNYOOwcsBOgC225OgGzHR7QOGLRx1J9NxiAymsDanNb7rX54
         XoNbjBo7X5ITMvJKYX21mgd7LmDGdNgYLiCWj53wnMQ3dW3iiMxPXXx1C7mlufDHWRhN
         ewZaVY5IE4q31GULJDNfb9AHH2NqVIDEP6+S9YajZ/e4cvDpx9unF1pjl02rcJEQufc/
         A/lgN9Y6RY67xepsMQcvjh+Czu2LlKsf9lzg6rJcV1/Y/+W8UPAHibRdk93P/kg51niz
         FMnw==
X-Gm-Message-State: APjAAAVpEmvKUHI/PUDWd1IHDK2tlPeRPkJ2GaiaHNj7AfRklrMqWWuM
        HfwD3GA2dsI+toh5W/sBLicPy8deS5T1IYyIIgsICShv6TEE1DVz90fz3rY3swzuuU+31x40MEU
        WtCMkCqSoIion
X-Received: by 2002:adf:f1d1:: with SMTP id z17mr3285342wro.330.1570033089761;
        Wed, 02 Oct 2019 09:18:09 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzdXxh5wz8G/f4mQKDqgI/sCIg/sY1v8M+KqylLMhEoh0g4kEjcKivr4dgFmTlgMkBHXTJsOw==
X-Received: by 2002:adf:f1d1:: with SMTP id z17mr3285315wro.330.1570033089460;
        Wed, 02 Oct 2019 09:18:09 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id i11sm9448102wrq.48.2019.10.02.09.18.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2019 09:18:08 -0700 (PDT)
Subject: Re: DANGER WILL ROBINSON, DANGER
To:     Jerome Glisse <jglisse@redhat.com>
Cc:     Mircea CIRJALIU - MELIU <mcirjaliu@bitdefender.com>,
        =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>,
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
References: <20190809162444.GP5482@bombadil.infradead.org>
 <1565694095.D172a51.28640.@15f23d3a749365d981e968181cce585d2dcb3ffa>
 <20190815191929.GA9253@redhat.com> <20190815201630.GA25517@redhat.com>
 <VI1PR02MB398411CA9A56081FF4D1248EBBA40@VI1PR02MB3984.eurprd02.prod.outlook.com>
 <20190905180955.GA3251@redhat.com>
 <5b0966de-b690-fb7b-5a72-bc7906459168@redhat.com>
 <DB7PR02MB3979D1143909423F8767ACE2BBB60@DB7PR02MB3979.eurprd02.prod.outlook.com>
 <20191002192714.GA5020@redhat.com>
 <ab461f02-e6cd-de0f-b6ce-0f5a95798eaa@redhat.com>
 <20191002141542.GA5669@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f26710a4-424f-730c-a676-901bae451409@redhat.com>
Date:   Wed, 2 Oct 2019 18:18:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191002141542.GA5669@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/19 16:15, Jerome Glisse wrote:
>>> Why would you need to target mmu notifier on target vma ?
>> If the mapping of the source VMA changes, mirroring can update the
>> target VMA via insert_pfn.  But what ensures that KVM's MMU notifier
>> dismantles its own existing page tables (so that they can be recreated
>> with the new mapping from the source VMA)?
>>
> So just to make sure i follow we have:
>       - qemu process on host with anonymous vma
>             -> host cpu page table
>       - kvm which maps host anonymous vma to guest
>             -> kvm guest page table
>       - kvm inspector process which mirror vma from qemu process
>             -> inspector process page table
> 
> AFAIK the KVM notifier's will clear the kvm guest page table whenever
> necessary (through kvm_mmu_notifier_invalidate_range_start). This is
> what ensure that KVM's dismatles its own mapping, it abides to mmu-
> notifier callbacks. If you did not you would have bugs (at least i
> expect so). Am i wrong here ?

The KVM inspector process is also (or can be) a QEMU that will have to
create its own KVM guest page table.

So if a page in the source VMA is unmapped we want:

- the source KVM to invalidate its guest page table (done by the KVM MMU
notifier)

- the target VMA to be invalidated (easy using mirroring)

- the target KVM to invalidate its guest page table, as a result of
invalidation of the target VMA

Paolo

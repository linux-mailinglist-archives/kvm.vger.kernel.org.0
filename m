Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C67328DB3D
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 10:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbgJNI11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 04:27:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22807 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726554AbgJNI10 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Oct 2020 04:27:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602664047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x4g3JzaJkXiHhjCbtynOGjqdUPHPFvNBFEwUL+601iw=;
        b=adFQLO+6HXybCOmTllml2MZPfdYBm3gMpVLkF6pt6TT6R90d0dqy+KWWOTIY/Gh7qOAqvH
        EvZbnvER5mxBq3gzkN8N1QmQOuDJXWswZ3MgOqNcw/xhx17WuF1kcQm4JETYZUY03NELFY
        1jBIievdg4ue6ou1810Wlex1brYiUcc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-_nQOPrYkPmuJLiwPNQFouQ-1; Wed, 14 Oct 2020 04:27:25 -0400
X-MC-Unique: _nQOPrYkPmuJLiwPNQFouQ-1
Received: by mail-ed1-f70.google.com with SMTP id e14so913604edk.2
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 01:27:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x4g3JzaJkXiHhjCbtynOGjqdUPHPFvNBFEwUL+601iw=;
        b=rwGiEqBBL8FhDIJ3jch/bHATaP5xpnc2MPMXlFkACIzrh8RKlpLIhwoixwb6fJrkG1
         t1UwV0kkt95ZMNmXBZQjKH6FiojQA5mR6kzSthBzQl/belsjsge67Zp+/kHXBS7EkSRm
         ZHiNmG6i1qQTbDR+uaFTArYfpj5Xz0Fhifeqs376bXhNoqCA0wmjoB23JeYEy+FCXkFJ
         Z8lryKioO1AA9z/HBGqho/YryQKF2DGEhuYibT28+zrJHXnvoX5qjhNqbCo7G02799kC
         usiHXtb+fTpSFiME2koAYlhsQJGQDYmCfy/+FgWjAWNAUEjJmwPoemBFBDRHyelq4ib/
         QV1w==
X-Gm-Message-State: AOAM533zDkxP2ioxfTOwuehgl0GPrMt0tyJ0xCG5PzuXDZKtVKD8n+5z
        AH+uJdEvtSaq8822xXUiMT9DcbqJF3/ptoOgOtdlD6QW2E878AojMtBHqqBBfE0vF4qNRRXcvJ5
        eFlgO1BLTrhzu
X-Received: by 2002:aa7:de06:: with SMTP id h6mr3908472edv.31.1602664044092;
        Wed, 14 Oct 2020 01:27:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw0qpIx7WA12LFk5RAxsrrUKAYr738RykIwdqdF0x1Sm/2twJVXzbmig9JdADFGNPyRu/33GA==
X-Received: by 2002:aa7:de06:: with SMTP id h6mr3908439edv.31.1602664043555;
        Wed, 14 Oct 2020 01:27:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e5f7:db3b:55ea:7337? ([2001:b07:6468:f312:e5f7:db3b:55ea:7337])
        by smtp.gmail.com with ESMTPSA id cw15sm1245419ejb.47.2020.10.14.01.27.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2020 01:27:22 -0700 (PDT)
Subject: Re: Why guest physical addresses are not the same as the
 corresponding host virtual addresses in QEMU/KVM? Thanks!
To:     harry harry <hiharryharryharry@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, qemu-devel@nongnu.org,
        mathieu.tarral@protonmail.com, stefanha@redhat.com,
        libvir-list@redhat.com, kvm@vger.kernel.org
References: <CA+-xGqMd4_58_+QKetjOsubBqrDnaYF+YWE3TC3kEcNGxPiPfg@mail.gmail.com>
 <47ead258320536d00f9f32891da3810040875aff.camel@redhat.com>
 <CA+-xGqOm2sWbxR=3W1pWrZNLOt7EE5qiNWxMz=9=gmga15vD2w@mail.gmail.com>
 <20201012165428.GD26135@linux.intel.com>
 <CA+-xGqPkkiws0bxrzud_qKs3ZmKN9=AfN=JGephfGc+2rn6ybw@mail.gmail.com>
 <20201013045245.GA11344@linux.intel.com>
 <CA+-xGqO4DtUs3-jH+QMPEze2GrXwtNX0z=vVUVak5HOpPKaDxQ@mail.gmail.com>
 <CA+-xGqMMa-DB1SND5MRugusDafjNA9CVw-=OBK7q=CK1impmTQ@mail.gmail.com>
 <a163c2d8-d8a1-dc03-6230-a2e104e3b039@redhat.com>
 <CA+-xGqOMKRh+_5vYXeLOiGnTMw4L_gUccqdQ+HGSOzuTosp6tw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <24cdf8f2-7dc7-1232-8d78-86f9b4b8eda3@redhat.com>
Date:   Wed, 14 Oct 2020 10:27:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CA+-xGqOMKRh+_5vYXeLOiGnTMw4L_gUccqdQ+HGSOzuTosp6tw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/20 22:36, harry harry wrote:
> Hi Paolo and Sean,
> 
> Thanks much for your prompt replies and clear explanations.
> 
> On Tue, Oct 13, 2020 at 2:43 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> No, the logic to find the HPA with a given HVA is the same as the
>> hardware logic to translate HVA -> HPA.  That is it uses the host
>> "regular" page tables, not the nested page tables.
>>
>> In order to translate GPA to HPA, instead, KVM does not use the nested
>> page tables.
> 
> I am curious why KVM does not directly use GPAs as HVAs and leverage
> nested page tables to translate HVAs (i.e., GPAs) to HPAs?

GPAs and HVAs are different things.  In fact I'm not aware of any
hypervisor that uses HVA==GPA.  On 32-bit x86 systems HVAs are 32-bit
(obviously) but GPAs are 36-bit.

In the case of KVM, HVAs are controlled by the rest of Linux; for
example, when you do "mmap" to allocate guest memory you cannot ask the
OS to return the guest memory at the exact HVA that is needed by the
guest.  There could be something else at that HVA (or you don't want
anything at that HVA: GPA 0 is valid, but HVA 0 is the NULL pointer!).
There's also cases where the same memory appears in multiple places in
the guest memory map (aliasing).

Paolo


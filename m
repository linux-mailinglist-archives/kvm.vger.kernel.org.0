Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2EA81AAC10
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 17:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1414785AbgDOPkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 11:40:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49071 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2409959AbgDOPkn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 11:40:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586965242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Js7wQzdOKkPlgCjhnOEg3WvsuBEMgF2C/E1tFezZmA=;
        b=CWkDQSqy9lRI+Wi5L2cp8eFC5DcZZTdnmG5/PigoNhGcTBEuLdBLiusjYCQQKWfC//IGUZ
        S6x8/feqq1sZ81TOHEDMMxj+QyN4+5m+DzyEWFGpmptVT7bqxVvJS5dIJhGFd+p+dxIt8t
        cuUCrbw/O8Ner/AZ0KQcolfBbPlJ6WI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-l_wRoEPHOZaC0spWonb_7g-1; Wed, 15 Apr 2020 11:40:35 -0400
X-MC-Unique: l_wRoEPHOZaC0spWonb_7g-1
Received: by mail-wr1-f71.google.com with SMTP id f2so106808wrm.9
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 08:40:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2Js7wQzdOKkPlgCjhnOEg3WvsuBEMgF2C/E1tFezZmA=;
        b=hdfj1Uh3rTkl76zUtOIRZuqxkm1duaaMTwF17DDM0JQWOYbxyjMPv9+zbKyByCsQGB
         Qh3jQmMV+1V9J+DbUe/JDSoAA+YFzzA0tqnedUvVHWF/O219Bw7zEk4PTi30OewX4hlx
         8Qrw1y81a06aT+971fIoEm+gEMCAN9iF7ZP/kG4c1Uq9NKCsecj7Vi31YIn8gDTzrDlM
         ao8mN14vfohKBDZZ/Qq4Xcd7pdMQXB7igchjCQi5Nzfr0lJtuD1F+/WUTfLZSkBAWXDO
         JdwipGaB81EOT52TdEziRK/lozat/W9yzS9TMUuUgZ3fTcbdOgOMMpFXLLEjldf/F3lK
         hpFQ==
X-Gm-Message-State: AGi0PuZ1hEp3IbURJAQKnzajymi7bJahholSpW43v5G7uZ97BDyqMfZv
        6Klyx/dbE0IS6YwfqjM96AjPO03/cknCXTeqm7EUdtgVATsIXeZolyB97u3HGXRBbhHuYZ7si6G
        hdudP5D6j68Uw
X-Received: by 2002:a1c:770e:: with SMTP id t14mr5605318wmi.187.1586965233490;
        Wed, 15 Apr 2020 08:40:33 -0700 (PDT)
X-Google-Smtp-Source: APiQypK+AV2U2fE1j6CX0FhuIqEHhjGsXeckD+Y/3wkDcnfm/n4CR9DC7ChnPzHlPkClT4ZgVUnhQg==
X-Received: by 2002:a1c:770e:: with SMTP id t14mr5605287wmi.187.1586965233184;
        Wed, 15 Apr 2020 08:40:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9066:4f2:9fbd:f90e? ([2001:b07:6468:f312:9066:4f2:9fbd:f90e])
        by smtp.gmail.com with ESMTPSA id k3sm23153779wmf.16.2020.04.15.08.40.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2020 08:40:32 -0700 (PDT)
Subject: Re: [PATCH 00/10] KVM: selftests: Add KVM_SET_MEMORY_REGION tests
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>
References: <20200410231707.7128-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c03fdbd5-2e52-4c58-ae00-2d3309cf7133@redhat.com>
Date:   Wed, 15 Apr 2020 17:40:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200410231707.7128-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/04/20 01:16, Sean Christopherson wrote:
> This is v2-ish of my series to add a "delete" testcase[1], and v5.1 of
> Wainer's series to add a "max" testcase[2].
> 
> I've only tested on x86_64.  I fudged compile testing on !x86_64 by
> inverting the ifdefs, e.g. to squish unused var warnings, but by no means
> is the code actually tested on other architectures.
> 
> I kept Andrew's review for the "max" test.  Other than the 1MB->2MB
> change (see below), it was basically a straight copy-paste of code.
> 
> v1->v2 of delete:
>   - Drop patch to expose primary memslot. [Peter]
>   - Add explicit synchronization to MOVE and DELETE tests. [Peter]
>   - Use list.h instead of open coding linked lists. [Peter]
>   - Clean up the code and separate the testcases into separate functions.
>   - Expand GUEST_ASSERT() to allow passing a value back to the host for
>     printing.
>   - Move to common KVM, with ifdefs to hide the x86_64-only stuff (which
>     is a lot at this point).
>   - Do KVM_SET_NR_MMU_PAGES in the "zero" testcase to get less obscure
>     behavior for KVM_RUN. [Christian]
> 
> v5.1 of max:
>   - Fix a whitespace issue in vm_get_fd(). [checkpatch]
>   - Move the code to set_memory_region_test.  The only _intended_
>     functional change is to create 2MB regions instead of 1MB regions.
>     The only motivation for doing so was to reuse an existing define in
>     set_memory_region_test.
> 
> [1] https://lkml.kernel.org/r/20200320205546.2396-1-sean.j.christopherson@intel.com
> [2] https://lkml.kernel.org/r/20200409220905.26573-1-wainersm@redhat.com
> 
> Sean Christopherson (8):
>   KVM: selftests: Take vcpu pointer instead of id in vm_vcpu_rm()
>   KVM: selftests: Use kernel's list instead of homebrewed replacement
>   KVM: selftests: Add util to delete memory region
>   KVM: selftests: Add GUEST_ASSERT variants to pass values to host
>   KVM: sefltests: Add explicit synchronization to move mem region test
>   KVM: selftests: Add "delete" testcase to set_memory_region_test
>   KVM: selftests: Add "zero" testcase to set_memory_region_test
>   KVM: selftests: Make set_memory_region_test common to all
>     architectures
> 
> Wainer dos Santos Moschetta (2):
>   selftests: kvm: Add vm_get_fd() in kvm_util
>   selftests: kvm: Add testcase for creating max number of memslots
> 
>  tools/testing/selftests/kvm/.gitignore        |   2 +-
>  tools/testing/selftests/kvm/Makefile          |   4 +-
>  .../testing/selftests/kvm/include/kvm_util.h  |  28 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 154 +++----
>  .../selftests/kvm/lib/kvm_util_internal.h     |   8 +-
>  .../selftests/kvm/lib/s390x/processor.c       |   5 +-
>  .../selftests/kvm/set_memory_region_test.c    | 403 ++++++++++++++++++
>  .../kvm/x86_64/set_memory_region_test.c       | 141 ------
>  8 files changed, 520 insertions(+), 225 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/set_memory_region_test.c
>  delete mode 100644 tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
> 

Queued, thanks -- while keeping the zero region test x86-only.

Paolo


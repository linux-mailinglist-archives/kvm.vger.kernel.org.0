Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DADA5BDA1
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 16:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbfGAOHe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 10:07:34 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45162 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729271AbfGAOHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 10:07:34 -0400
Received: by mail-wr1-f65.google.com with SMTP id f9so13996087wre.12
        for <kvm@vger.kernel.org>; Mon, 01 Jul 2019 07:07:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nFgxD9rL23Oz9CPZh09yHtmosD6ueKCUCwoA/+ADGM0=;
        b=EX6GiqCZ1rllUQkL9z9Rp0xsNFb2HjaZGt9oDbrVeBgzj27Gm6FdUhsobt2Kiks6D3
         FtbqM4hFFLd4AsR09oO4MGlYffUYMkiuxmuBbIG05NJ5lIMw2QrivZRSGtZcQdsjo2kn
         zj5GkyoZWaXLSsWRJCTlz4qTZP6XE743cjhY0uuz/kQnyzwSk3UdZzgwgBel6uiepQw6
         wcsAMHl9ARrsGvXcT14nLw0MEf3Pb+wxRM1VPXJ0wOXsVdZexzX3PgC2A1C/QTtEp9ci
         WAACTYItX1mQGyfx7wEh+6zBfcp5K0/U5z7x+/gRHvqEPnv/ta3Ofs4cdYi0yTLlecj4
         0gaQ==
X-Gm-Message-State: APjAAAXacfjOKEuNZSVIvJxi7WJwri6DVx17VarYRvsFZ11MaOILGucd
        LCz0I+R3ErNVSUvnfKOza9aEiA==
X-Google-Smtp-Source: APXvYqyuAvyUqXtxSLleXgKlPKlCIaoTVNUM59318FW5rEe1Qw7U6WXaWQ67sDcZwRJQrwlecV/cOg==
X-Received: by 2002:a5d:6182:: with SMTP id j2mr9142312wru.275.1561990052171;
        Mon, 01 Jul 2019 07:07:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5d4d:4830:bcdf:9bf9? ([2001:b07:6468:f312:5d4d:4830:bcdf:9bf9])
        by smtp.gmail.com with ESMTPSA id t1sm15622481wra.74.2019.07.01.07.07.31
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 07:07:31 -0700 (PDT)
Subject: Re: [GIT PULL 0/7] KVM: s390: add kselftests
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>
References: <20190701125848.276133-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b5f74797-1ff7-26fc-4a5a-1fdabef22671@redhat.com>
Date:   Mon, 1 Jul 2019 16:07:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190701125848.276133-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/07/19 14:58, Christian Borntraeger wrote:
> Paolo, Radim,
> 
> kselftest for s390x. There is a small conflict with Linus tree due to
> 61cfcd545e42 ("kvm: tests: Sort tests in the Makefile alphabetically")
> which is part of kvm/master but not kvm/next.
> Other than that this looks good.

Thanks! I'll delay this to after the first merge window pull request to
avoid the conflict.

Paolo

> 
> The following changes since commit f2c7c76c5d0a443053e94adb9f0918fa2fb85c3a:
> 
>   Linux 5.2-rc3 (2019-06-02 13:55:33 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.3-1
> 
> for you to fetch changes up to 8343ba2d4820b1738bbb7cb40ec18ea0a3b0b331:
> 
>   KVM: selftests: enable pgste option for the linker on s390 (2019-06-04 14:05:38 +0200)
> 
> ----------------------------------------------------------------
> KVM: s390: add kselftests
> 
> This is the initial implementation for KVM selftests on s390.
> 
> ----------------------------------------------------------------
> Christian Borntraeger (1):
>       KVM: selftests: enable pgste option for the linker on s390
> 
> Thomas Huth (6):
>       KVM: selftests: Guard struct kvm_vcpu_events with __KVM_HAVE_VCPU_EVENTS
>       KVM: selftests: Introduce a VM_MODE_DEFAULT macro for the default bits
>       KVM: selftests: Align memory region addresses to 1M on s390x
>       KVM: selftests: Add processor code for s390x
>       KVM: selftests: Add the sync_regs test for s390x
>       KVM: selftests: Move kvm_create_max_vcpus test to generic code
> 
>  MAINTAINERS                                        |   2 +
>  tools/testing/selftests/kvm/Makefile               |  14 +-
>  tools/testing/selftests/kvm/include/kvm_util.h     |   8 +
>  .../selftests/kvm/include/s390x/processor.h        |  22 ++
>  .../kvm/{x86_64 => }/kvm_create_max_vcpus.c        |   3 +-
>  .../testing/selftests/kvm/lib/aarch64/processor.c  |   2 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c         |  23 +-
>  tools/testing/selftests/kvm/lib/s390x/processor.c  | 286 +++++++++++++++++++++
>  tools/testing/selftests/kvm/lib/x86_64/processor.c |   2 +-
>  tools/testing/selftests/kvm/s390x/sync_regs_test.c | 151 +++++++++++
>  10 files changed, 503 insertions(+), 10 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/s390x/processor.h
>  rename tools/testing/selftests/kvm/{x86_64 => }/kvm_create_max_vcpus.c (93%)
>  create mode 100644 tools/testing/selftests/kvm/lib/s390x/processor.c
>  create mode 100644 tools/testing/selftests/kvm/s390x/sync_regs_test.c
> 


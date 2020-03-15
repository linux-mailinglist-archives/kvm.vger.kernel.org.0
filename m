Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 028A2185ED7
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 19:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgCOSPi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Mar 2020 14:15:38 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48570 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729001AbgCOSPi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 15 Mar 2020 14:15:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584296136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vq2kWuZasR+WQA2BBEH7AqgF0yh9m5uiRfdUPcimgXE=;
        b=HOIybUCwDrAjMtS7PnjlNQ3KT/jMngdX/5+9IPDWAPqaPBxF0p56PHs4QKcMyC3XlOXn9s
        VkL6GRe8nmepI5v3UDajYyozFbQU7zC1swJFsxIb/F7fXNxjt6ZhlVTy1asppcM73qa6MX
        t/MBGL/6srONAnrlv/nSYI1o+/ysgJM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-ScdWgNMSM1uRVcEin-Yhnw-1; Sun, 15 Mar 2020 14:15:32 -0400
X-MC-Unique: ScdWgNMSM1uRVcEin-Yhnw-1
Received: by mail-wr1-f69.google.com with SMTP id p5so7645092wrj.17
        for <kvm@vger.kernel.org>; Sun, 15 Mar 2020 11:15:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vq2kWuZasR+WQA2BBEH7AqgF0yh9m5uiRfdUPcimgXE=;
        b=PlHu5w5L5c3qlZyVGSPCaLfBeD4OcD77sZmur06oUh38SNO9Q+G+tHtVvYxEBTw45B
         mr6rRoRGeZltnDuJfjSy8hbuvsTG8P/sbUeDUs3BBKemeGAnTSUsMC1KUOcVoGcH5zvv
         a5T0Nz3tOMexv9jn2IATyny+85jFDOQLBb2OcdMMwjKzHfWXPAvtZdfaRvSPkSNCF22S
         0H5gZ3iPGqCh1Kf392l+KM5CpU8rzr98tqisFUK+nl4OWE1PBHhG+cCSrdXJajOunw+p
         Yw1FwV3nyxIqxcKzSoRUKUwui5Tdb832lVTvyD3dPQAwXGRy/zm0hBvxANmS1aGCgIFw
         Jhmw==
X-Gm-Message-State: ANhLgQ2nuFUTpAKwCqRZnoJ4EhQVpW3veWWzl/s7U3OyqTlGjJdyS95k
        PLIPB0IMo9mhHeio0KkkxE42xYKDA+CHoshSTaALQmfgcqmhrfJcc6wrGIcaX92E8Ff9ZKxikvI
        A9dYZMcNCYweV
X-Received: by 2002:a1c:de41:: with SMTP id v62mr10738137wmg.60.1584296131565;
        Sun, 15 Mar 2020 11:15:31 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvT06PDxKWaXMSuE3KdMdBv7/zkifq93xHvHk+dUXmFvcoVAfWXWq4N8G0L67fPwXRWOoftig==
X-Received: by 2002:a1c:de41:: with SMTP id v62mr10738115wmg.60.1584296131210;
        Sun, 15 Mar 2020 11:15:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:40d4:87da:1ffc:e462? ([2001:b07:6468:f312:40d4:87da:1ffc:e462])
        by smtp.gmail.com with ESMTPSA id w19sm25568848wmc.22.2020.03.15.11.15.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Mar 2020 11:15:30 -0700 (PDT)
Subject: Re: [GIT PULL 00/36] KVM: s390: Features and Enhancements for 5.7
 part1
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Ulrich Weigand <uweigand@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
References: <20200309085126.3334302-1-borntraeger@de.ibm.com>
 <323ef53d-1aab-5971-72cf-0d385f844ea8@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d05efc66-603b-39dd-97e5-65aa91722c47@redhat.com>
Date:   Sun, 15 Mar 2020 19:15:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <323ef53d-1aab-5971-72cf-0d385f844ea8@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/03/20 16:58, Christian Borntraeger wrote:
> ping.

Sorry, I wanted to get kvm/queue sorted out first.  I have now run my
battery of x86 tests and will pull it tomorrow (QEMU soft freeze is also
incoming but I should make it).

Thanks,

Paolo

> On 09.03.20 09:50, Christian Borntraeger wrote:
>> Paolo,
>>
>> an early pull request containing mostly the protected virtualization guest
>> support. Some remarks:
>>
>> 1.To avoid conflicts I would rather add this early. We do have in KVM
>> common code:
>> - a new capability KVM_CAP_S390_PROTECTED = 180
>> - a new ioctl  KVM_S390_PV_COMMAND =  _IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
>> - data structures for KVM_S390_PV_COMMAND
>> - new MEMOP ioctl subfunctions
>> - new files under Documentation
>> - additions to api.rst 4.125 KVM_S390_PV_COMMAND
>>
>> 2. There is an mm patch in Andrews mm tree which is needed for full
>> functionality. The patch is not necessary to build KVM or to run non
>> protected KVM though. So this can go independently.
>>
>> 3. I created a topic branch for the non-kvm s390x parts that I merged
>> in. Vasily, Heiko or myself will pull that into the s390 tree if there
>> will be a conflict.
>>
>>
>> The following changes since commit 11a48a5a18c63fd7621bb050228cebf13566e4d8:
>>
>>   Linux 5.6-rc2 (2020-02-16 13:16:59 -0800)
>>
>> are available in the Git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.7-1
>>
>> for you to fetch changes up to cc674ef252f4750bdcea1560ff491081bb960954:
>>
>>   KVM: s390: introduce module parameter kvm.use_gisa (2020-02-27 19:47:13 +0100)
>>
>> ----------------------------------------------------------------
>> KVM: s390: Features and Enhancements for 5.7 part1
>>
>> 1. Allow to disable gisa
>> 2. protected virtual machines
>>   Protected VMs (PVM) are KVM VMs, where KVM can't access the VM's
>>   state like guest memory and guest registers anymore. Instead the
>>   PVMs are mostly managed by a new entity called Ultravisor (UV),
>>   which provides an API, so KVM and the PV can request management
>>   actions.
>>
>>   PVMs are encrypted at rest and protected from hypervisor access
>>   while running.  They switch from a normal operation into protected
>>   mode, so we can still use the standard boot process to load a
>>   encrypted blob and then move it into protected mode.
>>
>>   Rebooting is only possible by passing through the unprotected/normal
>>   mode and switching to protected again.
>>
>>   One mm related patch will go via Andrews mm tree ( mm/gup/writeback:
>>   add callbacks for inaccessible pages)
>>
>> ----------------------------------------------------------------
>> Christian Borntraeger (5):
>>       Merge branch 'pvbase' of git://git.kernel.org/.../kvms390/linux into HEAD
>>       KVM: s390/mm: Make pages accessible before destroying the guest
>>       KVM: s390: protvirt: Add SCLP interrupt handling
>>       KVM: s390: protvirt: do not inject interrupts after start
>>       KVM: s390: protvirt: introduce and enable KVM_CAP_S390_PROTECTED
>>
>> Claudio Imbrenda (2):
>>       s390/mm: provide memory management functions for protected KVM guests
>>       KVM: s390/mm: handle guest unpin events
>>
>> Janosch Frank (24):
>>       s390/protvirt: Add sysfs firmware interface for Ultravisor information
>>       KVM: s390: protvirt: Add UV debug trace
>>       KVM: s390: add new variants of UV CALL
>>       KVM: s390: protvirt: Add initial vm and cpu lifecycle handling
>>       KVM: s390: protvirt: Secure memory is not mergeable
>>       KVM: s390: protvirt: Handle SE notification interceptions
>>       KVM: s390: protvirt: Instruction emulation
>>       KVM: s390: protvirt: Handle spec exception loops
>>       KVM: s390: protvirt: Add new gprs location handling
>>       KVM: S390: protvirt: Introduce instruction data area bounce buffer
>>       KVM: s390: protvirt: handle secure guest prefix pages
>>       KVM: s390: protvirt: Write sthyi data to instruction data area
>>       KVM: s390: protvirt: STSI handling
>>       KVM: s390: protvirt: disallow one_reg
>>       KVM: s390: protvirt: Do only reset registers that are accessible
>>       KVM: s390: protvirt: Only sync fmt4 registers
>>       KVM: s390: protvirt: Add program exception injection
>>       KVM: s390: protvirt: UV calls in support of diag308 0, 1
>>       KVM: s390: protvirt: Report CPU state to Ultravisor
>>       KVM: s390: protvirt: Support cmd 5 operation state
>>       KVM: s390: protvirt: Mask PSW interrupt bits for interception 104 and 112
>>       KVM: s390: protvirt: Add UV cpu reset calls
>>       DOCUMENTATION: Protected virtual machine introduction and IPL
>>       KVM: s390: protvirt: Add KVM api documentation
>>
>> Michael Mueller (2):
>>       KVM: s390: protvirt: Implement interrupt injection
>>       KVM: s390: introduce module parameter kvm.use_gisa
>>
>> Ulrich Weigand (1):
>>       KVM: s390/interrupt: do not pin adapter interrupt pages
>>
>> Vasily Gorbik (3):
>>       s390/protvirt: introduce host side setup
>>       s390/protvirt: add ultravisor initialization
>>       s390/mm: add (non)secure page access exceptions handlers
>>
>>  Documentation/admin-guide/kernel-parameters.txt |   5 +
>>  Documentation/virt/kvm/api.rst                  |  65 ++-
>>  Documentation/virt/kvm/devices/s390_flic.rst    |  11 +-
>>  Documentation/virt/kvm/index.rst                |   2 +
>>  Documentation/virt/kvm/s390-pv-boot.rst         |  84 ++++
>>  Documentation/virt/kvm/s390-pv.rst              | 116 +++++
>>  MAINTAINERS                                     |   1 +
>>  arch/s390/boot/Makefile                         |   2 +-
>>  arch/s390/boot/uv.c                             |  20 +
>>  arch/s390/include/asm/gmap.h                    |   6 +
>>  arch/s390/include/asm/kvm_host.h                | 113 ++++-
>>  arch/s390/include/asm/mmu.h                     |   2 +
>>  arch/s390/include/asm/mmu_context.h             |   1 +
>>  arch/s390/include/asm/page.h                    |   5 +
>>  arch/s390/include/asm/pgtable.h                 |  35 +-
>>  arch/s390/include/asm/uv.h                      | 251 ++++++++++-
>>  arch/s390/kernel/Makefile                       |   1 +
>>  arch/s390/kernel/entry.h                        |   2 +
>>  arch/s390/kernel/pgm_check.S                    |   4 +-
>>  arch/s390/kernel/setup.c                        |   9 +-
>>  arch/s390/kernel/uv.c                           | 414 +++++++++++++++++
>>  arch/s390/kvm/Makefile                          |   2 +-
>>  arch/s390/kvm/diag.c                            |   6 +-
>>  arch/s390/kvm/intercept.c                       | 122 ++++-
>>  arch/s390/kvm/interrupt.c                       | 399 ++++++++++-------
>>  arch/s390/kvm/kvm-s390.c                        | 567 +++++++++++++++++++++---
>>  arch/s390/kvm/kvm-s390.h                        |  51 ++-
>>  arch/s390/kvm/priv.c                            |  13 +-
>>  arch/s390/kvm/pv.c                              | 303 +++++++++++++
>>  arch/s390/mm/fault.c                            |  78 ++++
>>  arch/s390/mm/gmap.c                             |  65 ++-
>>  include/uapi/linux/kvm.h                        |  43 +-
>>  32 files changed, 2488 insertions(+), 310 deletions(-)
>>  create mode 100644 Documentation/virt/kvm/s390-pv-boot.rst
>>  create mode 100644 Documentation/virt/kvm/s390-pv.rst
>>  create mode 100644 arch/s390/kernel/uv.c
>>  create mode 100644 arch/s390/kvm/pv.c
>>
> 


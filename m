Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD475C1FE
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 19:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfGARbu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 13:31:50 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42975 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727581AbfGARbs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 13:31:48 -0400
Received: by mail-wr1-f68.google.com with SMTP id x17so14720446wrl.9
        for <kvm@vger.kernel.org>; Mon, 01 Jul 2019 10:31:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0oDdampWlKVXNLYu+/89k7YGxDIYT51dqwB+v1WNubU=;
        b=tmDrxaT/Nvji2Hrb+itn+7nZ9o0Ro90yB71mVoJBkQudcJKTJ+7FqnKhWQqW9ge+b8
         y/l2iFNC7ma108YHj+mEg07OImV44EkJ56XkK9zrxT+GwS2ydsCubxIJu9U2WNFWox7Q
         68XOVC8yCrKxIClsVdMuGOu0EwnlTbI2bu+XTu927QocdwXwgFfde1y/WUBdlupdtnzy
         I1r8CcIHmjm5KujLkT9fbs9l5iLuvbPe6FCU5hp2Dot9Ok80QlXwp4dJIIk/XqGr8vgV
         N4AO0cPauSXRkN8rI/0WrmgVIfReldLZBTkbe4tF60wljsxV3nK53wSPxbkOkprWchMD
         9OYw==
X-Gm-Message-State: APjAAAWt6zpadyvVbsh4e4vz/sWpWvclpPHKUUu+WoXTZ/lNZ948ei1/
        e+rJhPgrzYFT8p6U3Mek4D4zsQ==
X-Google-Smtp-Source: APXvYqwg9dhLkF1Iujl0uqE4A3r+uhurZ83HyVWio+gQZWV/JpCFrWQSHRRw7rYBF5ODs2UEfbcD3Q==
X-Received: by 2002:adf:fb10:: with SMTP id c16mr16422856wrr.72.1562002306291;
        Mon, 01 Jul 2019 10:31:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b8:794:183e:9e2a? ([2001:b07:6468:f312:b8:794:183e:9e2a])
        by smtp.gmail.com with ESMTPSA id c1sm22704441wrh.1.2019.07.01.10.31.45
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 10:31:45 -0700 (PDT)
Subject: Re: [GIT PULL 0/7] KVM: s390: add kselftests
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>
References: <20190701125848.276133-1-borntraeger@de.ibm.com>
 <b5f74797-1ff7-26fc-4a5a-1fdabef22671@redhat.com>
 <b1ff22c4-7a2e-158d-e179-d08d3d281a97@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d9697009-cda2-9a22-436d-e80475c5adba@redhat.com>
Date:   Mon, 1 Jul 2019 19:31:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <b1ff22c4-7a2e-158d-e179-d08d3d281a97@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/07/19 17:29, Christian Borntraeger wrote:
> 
> 
> On 01.07.19 16:07, Paolo Bonzini wrote:
>> On 01/07/19 14:58, Christian Borntraeger wrote:
>>> Paolo, Radim,
>>>
>>> kselftest for s390x. There is a small conflict with Linus tree due to
>>> 61cfcd545e42 ("kvm: tests: Sort tests in the Makefile alphabetically")
>>> which is part of kvm/master but not kvm/next.
>>> Other than that this looks good.
>>
>> Thanks! I'll delay this to after the first merge window pull request to
>> avoid the conflict.
> 
> I do not have to do anything, correct?

No, it's done on your side. Just an explanation of why you'll not see
this in kvm/next for a week or so.

Paolo

> As an alternative I could rebase on top of rc6.
>>
>> Paolo
>>
>>>
>>> The following changes since commit f2c7c76c5d0a443053e94adb9f0918fa2fb85c3a:
>>>
>>>   Linux 5.2-rc3 (2019-06-02 13:55:33 -0700)
>>>
>>> are available in the Git repository at:
>>>
>>>   git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.3-1
>>>
>>> for you to fetch changes up to 8343ba2d4820b1738bbb7cb40ec18ea0a3b0b331:
>>>
>>>   KVM: selftests: enable pgste option for the linker on s390 (2019-06-04 14:05:38 +0200)
>>>
>>> ----------------------------------------------------------------
>>> KVM: s390: add kselftests
>>>
>>> This is the initial implementation for KVM selftests on s390.
>>>
>>> ----------------------------------------------------------------
>>> Christian Borntraeger (1):
>>>       KVM: selftests: enable pgste option for the linker on s390
>>>
>>> Thomas Huth (6):
>>>       KVM: selftests: Guard struct kvm_vcpu_events with __KVM_HAVE_VCPU_EVENTS
>>>       KVM: selftests: Introduce a VM_MODE_DEFAULT macro for the default bits
>>>       KVM: selftests: Align memory region addresses to 1M on s390x
>>>       KVM: selftests: Add processor code for s390x
>>>       KVM: selftests: Add the sync_regs test for s390x
>>>       KVM: selftests: Move kvm_create_max_vcpus test to generic code
>>>
>>>  MAINTAINERS                                        |   2 +
>>>  tools/testing/selftests/kvm/Makefile               |  14 +-
>>>  tools/testing/selftests/kvm/include/kvm_util.h     |   8 +
>>>  .../selftests/kvm/include/s390x/processor.h        |  22 ++
>>>  .../kvm/{x86_64 => }/kvm_create_max_vcpus.c        |   3 +-
>>>  .../testing/selftests/kvm/lib/aarch64/processor.c  |   2 +-
>>>  tools/testing/selftests/kvm/lib/kvm_util.c         |  23 +-
>>>  tools/testing/selftests/kvm/lib/s390x/processor.c  | 286 +++++++++++++++++++++
>>>  tools/testing/selftests/kvm/lib/x86_64/processor.c |   2 +-
>>>  tools/testing/selftests/kvm/s390x/sync_regs_test.c | 151 +++++++++++
>>>  10 files changed, 503 insertions(+), 10 deletions(-)
>>>  create mode 100644 tools/testing/selftests/kvm/include/s390x/processor.h
>>>  rename tools/testing/selftests/kvm/{x86_64 => }/kvm_create_max_vcpus.c (93%)
>>>  create mode 100644 tools/testing/selftests/kvm/lib/s390x/processor.c
>>>  create mode 100644 tools/testing/selftests/kvm/s390x/sync_regs_test.c
>>>
>>
> 


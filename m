Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C58DE82409
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 19:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbfHERdQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 13:33:16 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33346 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728824AbfHERdQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 13:33:16 -0400
Received: by mail-pl1-f196.google.com with SMTP id c14so36660226plo.0
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2019 10:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=5K39yqFA1wA539McQKxHXeoZef97I6MYrDjmAzSrYdQ=;
        b=U0AXX4DpvMj4kHG9wgs2+UV/tSuHyC8ot83RZVkpW3mZavMcgwEoS+sQlq+N+okTP9
         S1L/hfXHVMJ607G6GXbq9zAI48zOIKPaFNsDYEMC9AZUzMKCBfxOSaLQFihWTCyRI8fM
         iDwDKFQ2gi+/xEaiGd1SgQlBJdUDq21WHMIPONN47Y2hElK/osWZTaQS5OW2gRI9wVwD
         TOilDzL+8M1YABBEpIG5ep1rNmAVbm2LoJ6vwk+zFd1BEHf9mcU75KfwR+cm9mDiMsns
         9uXjMALBgkBeoGkAVhyrCcvdKKlCrC92BhP5UHsHjwoA+GFgY377NaQB3ej8ZUEtroas
         tNTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=5K39yqFA1wA539McQKxHXeoZef97I6MYrDjmAzSrYdQ=;
        b=gl8Q+CeyA+fIzgseVpGsv2KuohQ5cR6bC1y00sQwXUbmRTQtaufNFzZgeOJCSFSYLw
         bA8Tib/1J9GyCd80l7BDzmlD8jtTGro94p30HIgRtpzslVeT+IUa06MJj1xCTeAnq+re
         mh/IEVOHeJhMi7V3Cczmv0yrNz/95yksaMuXja4AwcwNMQngtm9b2l/eORN/TtROaxDN
         HdP/CEkpuve2lF3jEVbPZjtSNyfEf0MOp5KKhRTIkhCbMKXALHZv2z8uWNUzDhURj/wQ
         VrRljJdflRAcgkrE09x0YV4Ekvw3cH35pOz4yxywRii/i4zsWdpprNPyQ8FAsSc6x8ZR
         mKCA==
X-Gm-Message-State: APjAAAWb1npNHSq1vqOzXr3Tj7jQZg/HA9exfkfc5bx6qgoE1BZ7yBjd
        qi36jaHD0hrV4kWz7pPw6f8=
X-Google-Smtp-Source: APXvYqxBDvpybQwKdoCr6XmsOkn8lMP7ne2P1CKXFGAKVs5rTkNWZqnKa3HCjJ8dO7pdsfALu/bC1Q==
X-Received: by 2002:a17:902:925:: with SMTP id 34mr144506343plm.334.1565026395397;
        Mon, 05 Aug 2019 10:33:15 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id v22sm83953484pgk.69.2019.08.05.10.33.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:33:14 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH v3] x86: Support environments without
 test-devices
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20190723081507.vkostd7cjzxcomes@kamzik.brq.redhat.com>
Date:   Mon, 5 Aug 2019 10:33:08 -0700
Cc:     kvm list <kvm@vger.kernel.org>, Andrew Jones <drjones@redhat.com>
Content-Transfer-Encoding: 7bit
Message-Id: <545E6AD5-BB28-4846-A986-270B95691AAD@gmail.com>
References: <20190722225540.43572-1-nadav.amit@gmail.com>
 <20190723081507.vkostd7cjzxcomes@kamzik.brq.redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jul 23, 2019, at 1:15 AM, Andrew Jones <drjones@redhat.com> wrote:
> 
> On Mon, Jul 22, 2019 at 03:55:40PM -0700, Nadav Amit wrote:
>> Enable to run the tests when test-device is not present (e.g.,
>> bare-metal). Users can provide the number of CPUs and ram size through
>> kernel parameters.
>> 
>> On Ubuntu that uses grub, for example, the tests can be run by copying a
>> test to the boot directory (/boot) and adding a menu-entry to grub
>> (e.g., by editing /etc/grub.d/40_custom):
>> 
>>  menuentry 'idt_test' {
>> 	set root='[ROOT]'
>> 	multiboot [BOOT_RELATIVE]/[TEST].flat [PARAMETERS]
>> 	module params.initrd
>>  }
>> 
>> Replace:
>>  * [ROOT] with `grub-probe --target=bios_hints /boot`
>>  * [BOOT_RELATIVE] with `grub-mkrelpath /boot`
>>  * [TEST] with the test executed
>>  * [PARAMETERS] with the test parameters
>> 
>> params.initrd, which would be located on the boot directory should
>> describe the machine and tell the test infrastructure that a test
>> device is not present and boot-loader was used (the bootloader and qemu
>> deliver test . For example for a 4 core machines with 4GB of
>> memory:
>> 
>>  NR_CPUS=4
>>  MEMSIZE=4096
>>  TEST_DEVICE=0
>>  BOOTLOADER=1
>> 
>> Since we do not really use E820, using more than 4GB is likely to fail
>> due to holes.
>> 
>> Finally, do not forget to run update-grub. Remember that the output goes
>> to the serial port.
>> 
>> Cc: Andrew Jones <drjones@redhat.com>
>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
>> 
>> ---
>> 
>> v2->v3:
>> * Adding argument to argv when bootloader is used [Andrew]
>> * Avoid unnecessary check of test-device availability [Andrew]
>> 
>> v1->v2:
>> * Using initrd to hold configuration override [Andrew]
>> * Adapting vmx, tscdeadline_latency not to ignore the first argument
>>   on native
>> ---
>> lib/argv.c      | 13 +++++++++----
>> lib/argv.h      |  1 +
>> lib/x86/fwcfg.c | 28 ++++++++++++++++++++++++++++
>> lib/x86/fwcfg.h | 10 ++++++++++
>> lib/x86/setup.c |  5 +++++
>> x86/apic.c      |  4 +++-
>> x86/cstart64.S  |  8 ++++++--
>> x86/eventinj.c  | 17 ++++++++++++++---
>> x86/vmx_tests.c |  5 +++++
>> 9 files changed, 81 insertions(+), 10 deletions(-)
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>

Paolo, any further comments?

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93A5C165F04
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 14:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgBTNnW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 08:43:22 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20738 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727298AbgBTNnW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 08:43:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582206200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qD/X+uvdAqiN2J4VmO38lFHYqqOLuyZd9jk531i2vDc=;
        b=VbFX74fFzTvoitwdfmpVRLP4j4HFGnVOHWmnsy0jqShxi/CotYW83lxDVmZThYGo2BSt4/
        BepTF2xJVMj2aJJoynqDZbTso9rCPT13WpcaDLMkzM+BZXChw1Nl1nisQUP0NUGQELgDRk
        pNCqmxB1BNnSH2Y3yOqsepalZj641Bg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273--nkqe9-HOIKNuE4g_MxS5w-1; Thu, 20 Feb 2020 08:43:16 -0500
X-MC-Unique: -nkqe9-HOIKNuE4g_MxS5w-1
Received: by mail-ed1-f69.google.com with SMTP id ay24so2738852edb.0
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 05:43:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qD/X+uvdAqiN2J4VmO38lFHYqqOLuyZd9jk531i2vDc=;
        b=QtyRmUAgBxOBtQExFF8TjXgpv8LO8eHuv73nCPilgYHSuCIZcnYu4NvE9hKdD4dBAU
         47iuLWAdLy3PW7qURbzzaHYOWYUuXYKdwgntNBuzjeOgUYXAS8+Vd+DCThUjc+7sUMJ6
         HEpICzqmbKj/NyLF7eEm9Qhlh8F9T7KYC9VQ5HyvSa3LqYNShCpChEDl30pcIevA1m22
         mPOpGQXjtJW9Q21L44NYg5j20fnTXBh/xlbPJa3hvoohWEkBKiW25v5dh1/I/LhXlVZZ
         HXWnEaE2WsMYsMhHjWEK6ZtrlgT+8y0ZejYLJJKUNNVdUI6TZGTCvet0K1TBUg8XCzIm
         V0SQ==
X-Gm-Message-State: APjAAAVSnSke3JYfW6DAeiqJrqiEW7o6KKMWaW+mPWGIuyphM7mAt26c
        B3rOOVFwQjB1hnptp98Lf7yNT8aM2KopZnPKAKNixnBeCpAi9KL0I5f3AKHUqS6yjl0f4BoyW2g
        MuX1+mvps//AD
X-Received: by 2002:a17:906:af66:: with SMTP id os6mr30252254ejb.87.1582206195521;
        Thu, 20 Feb 2020 05:43:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqy55S2TatA0f5hb66822wtWUhbSwpaXzdFOBOyYbycw17FXpGy5g+OlIEm49yhVSCxJsxpX7A==
X-Received: by 2002:a17:906:af66:: with SMTP id os6mr30252228ejb.87.1582206195221;
        Thu, 20 Feb 2020 05:43:15 -0800 (PST)
Received: from [192.168.1.35] (78.red-88-21-202.staticip.rima-tde.net. [88.21.202.78])
        by smtp.gmail.com with ESMTPSA id ks2sm125224ejb.82.2020.02.20.05.43.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 05:43:14 -0800 (PST)
Subject: Re: [PATCH v3 02/20] hw: Remove unnecessary cast when calling
 dma_memory_read()
To:     Eric Blake <eblake@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>, qemu-devel@nongnu.org
Cc:     Fam Zheng <fam@euphon.net>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>, qemu-block@nongnu.org,
        David Hildenbrand <david@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        =?UTF-8?Q?Herv=c3=a9_Poussineau?= <hpoussin@reactos.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        xen-devel@lists.xenproject.org,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        Richard Henderson <rth@twiddle.net>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Stefan Weil <sw@weilnetz.de>,
        Alistair Francis <alistair@alistair23.me>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paul Durrant <paul@xen.org>,
        Eric Auger <eric.auger@redhat.com>, qemu-s390x@nongnu.org,
        qemu-arm@nongnu.org,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        John Snow <jsnow@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Igor Mitsyanko <i.mitsyanko@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Michael Walle <michael@walle.cc>, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20200220130548.29974-1-philmd@redhat.com>
 <20200220130548.29974-3-philmd@redhat.com>
 <68120807-6f6b-1602-8208-fd76d64e74bc@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <be623afd-0605-0bdf-daae-f38ba5562012@redhat.com>
Date:   Thu, 20 Feb 2020 14:43:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <68120807-6f6b-1602-8208-fd76d64e74bc@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/20/20 2:16 PM, Eric Blake wrote:
> On 2/20/20 7:05 AM, Philippe Mathieu-Daudé wrote:
>> Since its introduction in commit d86a77f8abb, dma_memory_read()
>> always accepted void pointer argument. Remove the unnecessary
>> casts.
>>
>> This commit was produced with the included Coccinelle script
>> scripts/coccinelle/exec_rw_const.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>   scripts/coccinelle/exec_rw_const.cocci | 15 +++++++++++++++
>>   hw/arm/smmu-common.c                   |  3 +--
>>   hw/arm/smmuv3.c                        | 10 ++++------
>>   hw/sd/sdhci.c                          | 15 +++++----------
>>   4 files changed, 25 insertions(+), 18 deletions(-)
>>   create mode 100644 scripts/coccinelle/exec_rw_const.cocci
>>
>> diff --git a/scripts/coccinelle/exec_rw_const.cocci 
>> b/scripts/coccinelle/exec_rw_const.cocci
>> new file mode 100644
>> index 0000000000..a0054f009d
>> --- /dev/null
>> +++ b/scripts/coccinelle/exec_rw_const.cocci
>> @@ -0,0 +1,15 @@
>> +// Usage:
>> +//  spatch --sp-file scripts/coccinelle/exec_rw_const.cocci --dir . 
>> --in-place
> 
> This command line should also use '--macro-file 
> scripts/cocci-macro-file.h' to cover more of the code base (Coccinelle 
> skips portions of the code that uses macros it doesn't recognize).
> 
> 
>> @@ -726,13 +724,10 @@ static void get_adma_description(SDHCIState *s, 
>> ADMADescr *dscr)
>>           }
>>           break;
>>       case SDHC_CTRL_ADMA2_64:
>> -        dma_memory_read(s->dma_as, entry_addr,
>> -                        (uint8_t *)(&dscr->attr), 1);
>> -        dma_memory_read(s->dma_as, entry_addr + 2,
>> -                        (uint8_t *)(&dscr->length), 2);
>> +        dma_memory_read(s->dma_as, entry_addr, (&dscr->attr), 1);
>> +        dma_memory_read(s->dma_as, entry_addr + 2, (&dscr->length), 2);
> 
> The () around &dscr->length are now pointless.

Thanks Eric, patch updated. Peter are you OK if I change the cocci 
header using /* */ as:

-- >8 --
diff --git a/scripts/coccinelle/exec_rw_const.cocci 
b/scripts/coccinelle/exec_rw_const.cocci
index a0054f009d..7e42682240 100644
--- a/scripts/coccinelle/exec_rw_const.cocci
+++ b/scripts/coccinelle/exec_rw_const.cocci
@@ -1,5 +1,13 @@
-// Usage:
-//  spatch --sp-file scripts/coccinelle/exec_rw_const.cocci --dir . 
--in-place
+/*
+  Usage:
+
+    spatch \
+           --macro-file scripts/cocci-macro-file.h \
+           --sp-file scripts/coccinelle/exec_rw_const.cocci \
+           --keep-comments \
+           --in-place \
+           --dir .
+*/

  // Remove useless cast
  @@
@@ -7,9 +15,9 @@ expression E1, E2, E3, E4;
  type T;
  @@
  (
-- dma_memory_read(E1, E2, (T *)E3, E4)
+- dma_memory_read(E1, E2, (T *)(E3), E4)
  + dma_memory_read(E1, E2, E3, E4)
  |
-- dma_memory_write(E1, E2, (T *)E3, E4)
+- dma_memory_write(E1, E2, (T *)(E3), E4)
  + dma_memory_write(E1, E2, E3, E4)
  )
diff --git a/hw/sd/sdhci.c b/hw/sd/sdhci.c
index d5abdaad41..de63ffb037 100644
--- a/hw/sd/sdhci.c
+++ b/hw/sd/sdhci.c
@@ -724,10 +724,10 @@ static void get_adma_description(SDHCIState *s, 
ADMADescr *dscr)
          }
          break;
      case SDHC_CTRL_ADMA2_64:
-        dma_memory_read(s->dma_as, entry_addr, (&dscr->attr), 1);
-        dma_memory_read(s->dma_as, entry_addr + 2, (&dscr->length), 2);
+        dma_memory_read(s->dma_as, entry_addr, &dscr->attr, 1);
+        dma_memory_read(s->dma_as, entry_addr + 2, &dscr->length, 2);
          dscr->length = le16_to_cpu(dscr->length);
-        dma_memory_read(s->dma_as, entry_addr + 4, (&dscr->addr), 8);
+        dma_memory_read(s->dma_as, entry_addr + 4, &dscr->addr, 8);
          dscr->addr = le64_to_cpu(dscr->addr);
          dscr->attr &= (uint8_t) ~0xC0;
          dscr->incr = 12;
---


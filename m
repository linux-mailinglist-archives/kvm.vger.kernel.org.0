Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 085B64EAFA
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 16:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbfFUOq0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 10:46:26 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50495 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbfFUOq0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 10:46:26 -0400
Received: by mail-wm1-f66.google.com with SMTP id c66so6591622wmf.0
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2019 07:46:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wqCpkprBc2J/oBbcTLMofDoxn5v207tp4CUDSZCZr2o=;
        b=tLB7NZtBJ8C/oXTj3b5y1CrtvWtmdlJjo3htcHmyYQd9q+lo7gDh9Y22rs3tcGFzon
         9tEXNaK9GVWJHt/1fbu+Cp8pUbFNXBuJgnjNUYKowBofZN8ofTXgpizkfJAmsZ8ez1jT
         a++oSThyCd5m7pHYFK4Qn9HxMQYDlYjz31BXCLjTtxXRXFeaegBtA0ppeC0ztiSb7wqU
         uFRaCmrqNrL6Ic8Na7VMYPlpiQyQ2zwbjmMrZF9e2KDExb+pI124aP7Uo/PE11cq/pt9
         NrXIREmWuDcJn4tzKPa0Bv0w3ZhshJhizEg9iq3Tsq1fKyWq2xrkV6ZxHSSiRmvH4vCq
         2Bhg==
X-Gm-Message-State: APjAAAWshwC23OBEIVIAD47+CPVyRY+XLYhpH9mQ9bbmTPlI99Ebaphc
        SRnzutjGg6Kg7uusuvCT+/ZaBg==
X-Google-Smtp-Source: APXvYqwbs/aw62Zx0GKxq7ISurV0aIMZU9BnOo5SAgXPhv3Yzak1fFtZhMmZOA250vMgncTiuITw4w==
X-Received: by 2002:a1c:dc07:: with SMTP id t7mr4633705wmg.164.1561128384767;
        Fri, 21 Jun 2019 07:46:24 -0700 (PDT)
Received: from [192.168.1.38] (183.red-88-21-202.staticip.rima-tde.net. [88.21.202.183])
        by smtp.gmail.com with ESMTPSA id 72sm4358583wrk.22.2019.06.21.07.46.23
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 07:46:24 -0700 (PDT)
Subject: Re: [PATCH v2 02/20] hw/i386/pc: Use size_t type to hold/return a
 size of array
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     qemu-devel@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <rth@twiddle.net>,
        Rob Bradford <robert.bradford@intel.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Li Qiang <liq3ea@gmail.com>
References: <20190613143446.23937-1-philmd@redhat.com>
 <20190613143446.23937-3-philmd@redhat.com>
 <20190620112805-mutt-send-email-mst@kernel.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Openpgp: id=89C1E78F601EE86C867495CBA2A3FD6EDEADC0DE;
 url=http://pgp.mit.edu/pks/lookup?op=get&search=0xA2A3FD6EDEADC0DE
Message-ID: <d7215a09-ecc2-9895-a00e-fd12091b3893@redhat.com>
Date:   Fri, 21 Jun 2019 16:46:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190620112805-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/20/19 5:28 PM, Michael S. Tsirkin wrote:
> On Thu, Jun 13, 2019 at 04:34:28PM +0200, Philippe Mathieu-Daudé wrote:
>> Reviewed-by: Li Qiang <liq3ea@gmail.com>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> 
> Motivation? do you expect more than 2^31 entries?

Building with -Wsign-compare:

hw/i386/pc.c:973:36: warning: comparison of integers of different signs:
'unsigned int' and 'int' [-Wsign-compare]
    for (i = 0, array_count = 0; i < e820_get_num_entries(); i++) {
                                 ~ ^ ~~~~~~~~~~~~~~~~~~~~~~

>> ---
>>  hw/i386/pc.c         | 4 ++--
>>  include/hw/i386/pc.h | 2 +-
>>  2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
>> index bb3c74f4ca..ff0f6bbbb3 100644
>> --- a/hw/i386/pc.c
>> +++ b/hw/i386/pc.c
>> @@ -105,7 +105,7 @@ struct e820_table {
>>  
>>  static struct e820_table e820_reserve;
>>  static struct e820_entry *e820_table;
>> -static unsigned e820_entries;
>> +static size_t e820_entries;
>>  struct hpet_fw_config hpet_cfg = {.count = UINT8_MAX};
>>  
>>  /* Physical Address of PVH entry point read from kernel ELF NOTE */
>> @@ -901,7 +901,7 @@ int e820_add_entry(uint64_t address, uint64_t length, uint32_t type)
>>      return e820_entries;
>>  }
>>  
>> -int e820_get_num_entries(void)
>> +size_t e820_get_num_entries(void)
>>  {
>>      return e820_entries;
>>  }
>> diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
>> index 3b3a0d6e59..fc29893624 100644
>> --- a/include/hw/i386/pc.h
>> +++ b/include/hw/i386/pc.h
>> @@ -290,7 +290,7 @@ void pc_madt_cpu_entry(AcpiDeviceIf *adev, int uid,
>>  #define E820_UNUSABLE   5
>>  
>>  int e820_add_entry(uint64_t, uint64_t, uint32_t);
>> -int e820_get_num_entries(void);
>> +size_t e820_get_num_entries(void);
>>  bool e820_get_entry(unsigned int, uint32_t, uint64_t *, uint64_t *);
>>  
>>  extern GlobalProperty pc_compat_4_0_1[];
>> -- 
>> 2.20.1

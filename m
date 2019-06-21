Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAB4B4EB05
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 16:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbfFUOsi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 10:48:38 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53171 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfFUOsi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 10:48:38 -0400
Received: by mail-wm1-f65.google.com with SMTP id s3so6578750wms.2
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2019 07:48:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mni6q2gM6QRV8G+snx7TIr26ZzoLjFy5MNHHDUgwcig=;
        b=QlA90gFufkHBcITfNudCLT32dadKw1dqIGefAFyGae9wCkuvgV4tKkI+fKzDZ1iY53
         YML4md9BVQcSdcuFFcAS5suF7+2ZRj21vBoyCebqz4t0wvTusjlycwT5ay+lCV++Eq6d
         Q/V35CqiujgLqnJskBw16t7in3yJ7baHouGt2q/E5VHXWI13AhvuKMoYzm6TiniC50ly
         VbQh/E6FpgQpGQNJ/aY3EN3zUTQMkWy76h0LpRq+OYDguIvd4OHan9bRCVjcPMSuyQlr
         esAtjt6mgm3RO340ATPhVC1qwApF97TKFuT5yXTnjRm8NHcd/rkZpHnC4dz+kdQKoKSn
         43ag==
X-Gm-Message-State: APjAAAUmtAIySD2AZ7qiETbqO0oJaKyg9LATD+8eg8Jj7MwrEpKLhJS6
        lajVV1bz/qxMYk/ki2KPa/Yubw==
X-Google-Smtp-Source: APXvYqyf45eQwg+BbW/SjWqLGsYW7jTQ+yztokND0TEQ22Lj8Z9vJAXQxaiKLioE0/AGJo+QWZF3EA==
X-Received: by 2002:a1c:808b:: with SMTP id b133mr4139936wmd.160.1561128516167;
        Fri, 21 Jun 2019 07:48:36 -0700 (PDT)
Received: from [192.168.1.38] (183.red-88-21-202.staticip.rima-tde.net. [88.21.202.183])
        by smtp.gmail.com with ESMTPSA id y19sm4074167wmc.21.2019.06.21.07.48.35
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 07:48:35 -0700 (PDT)
Subject: Re: [PATCH v2 04/20] hw/i386/pc: Add the E820Type enum type
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     qemu-devel@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <rth@twiddle.net>,
        Rob Bradford <robert.bradford@intel.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20190613143446.23937-1-philmd@redhat.com>
 <20190613143446.23937-5-philmd@redhat.com>
 <20190620112913-mutt-send-email-mst@kernel.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Openpgp: id=89C1E78F601EE86C867495CBA2A3FD6EDEADC0DE;
 url=http://pgp.mit.edu/pks/lookup?op=get&search=0xA2A3FD6EDEADC0DE
Message-ID: <d54c1df4-5ebb-ad3f-449c-5037ef560270@redhat.com>
Date:   Fri, 21 Jun 2019 16:48:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190620112913-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/20/19 5:31 PM, Michael S. Tsirkin wrote:
> On Thu, Jun 13, 2019 at 04:34:30PM +0200, Philippe Mathieu-Daudé wrote:
>> This ensure we won't use an incorrect value.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> 
> It doesn't actually ensure anything: compiler does not check IIUC.
> 
> And OTOH it's stored in type field in struct e820_entry.

I totally missed that... Thanks!

>> ---
>> v2: Do not cast the enum (Li)
>> ---
>>  hw/i386/pc.c         |  4 ++--
>>  include/hw/i386/pc.h | 16 ++++++++++------
>>  2 files changed, 12 insertions(+), 8 deletions(-)
>>
>> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
>> index 5a7cffbb1a..86ba554439 100644
>> --- a/hw/i386/pc.c
>> +++ b/hw/i386/pc.c
>> @@ -872,7 +872,7 @@ static void handle_a20_line_change(void *opaque, int irq, int level)
>>      x86_cpu_set_a20(cpu, level);
>>  }
>>  
>> -ssize_t e820_add_entry(uint64_t address, uint64_t length, uint32_t type)
>> +ssize_t e820_add_entry(uint64_t address, uint64_t length, E820Type type)
>>  {
>>      unsigned int index = le32_to_cpu(e820_reserve.count);
>>      struct e820_entry *entry;
>> @@ -906,7 +906,7 @@ size_t e820_get_num_entries(void)
>>      return e820_entries;
>>  }
>>  
>> -bool e820_get_entry(unsigned int idx, uint32_t type,
>> +bool e820_get_entry(unsigned int idx, E820Type type,
>>                      uint64_t *address, uint64_t *length)
>>  {
>>      if (idx < e820_entries && e820_table[idx].type == cpu_to_le32(type)) {
>> diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
>> index c56116e6f6..7c07185dd5 100644
>> --- a/include/hw/i386/pc.h
>> +++ b/include/hw/i386/pc.h
>> @@ -282,12 +282,16 @@ void pc_system_firmware_init(PCMachineState *pcms, MemoryRegion *rom_memory);
>>  void pc_madt_cpu_entry(AcpiDeviceIf *adev, int uid,
>>                         const CPUArchIdList *apic_ids, GArray *entry);
>>  
>> -/* e820 types */
>> -#define E820_RAM        1
>> -#define E820_RESERVED   2
>> -#define E820_ACPI       3
>> -#define E820_NVS        4
>> -#define E820_UNUSABLE   5
>> +/**
>> + * E820Type: Type of the e820 address range.
>> + */
>> +typedef enum {
>> +    E820_RAM        = 1,
>> +    E820_RESERVED   = 2,
>> +    E820_ACPI       = 3,
>> +    E820_NVS        = 4,
>> +    E820_UNUSABLE   = 5
>> +} E820Type;
>>  
>>  ssize_t e820_add_entry(uint64_t, uint64_t, uint32_t);
>>  size_t e820_get_num_entries(void);
>> -- 
>> 2.20.1

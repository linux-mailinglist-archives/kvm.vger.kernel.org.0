Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3E1B4EAF0
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 16:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbfFUOpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 10:45:00 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38762 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfFUOpA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 10:45:00 -0400
Received: by mail-wm1-f67.google.com with SMTP id s15so6880983wmj.3
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2019 07:44:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HNfwa9Z1m00gZgcXZz0SAwJCt6xsZguaiHCg+EvN2Jg=;
        b=K5rUpUTMIiDPxKKPyccyStJk5dKFmdVfeKgZoc/q6C5A79LuS74YExx5YBvkpyGH+b
         mzZv6DEx/YQudgkzMKo0qCK5VEU/7qPSh+/XtsgojMNKRZ8W1VfeQ06iQ2t/wZdz3oIs
         wae2KyEcmCGSItVpLUF4kMqh+S3xTnTnzijxf4kQQmX39JijayCdnwSy7ST3LBWDQLP0
         xRRqfHnQshzYylXNDSxGtmtyUwHoXBMOi4tu5aAA/JWRJ/cBim6Y93vr6rX3NMd1gafA
         8M+72jzJxykcxt/VKWo0Eec+66W3IXAq9N2RN3koQXUlQZYn6icckKnJ7P+EcpgyMCIC
         l4lA==
X-Gm-Message-State: APjAAAXk77GK99C70jUqgO3IUvSiwq2ApHzVcAkJpnKV1gVActpIgQb3
        vT9aHiaBUbKe6tzjjv1emru32DPI2S4=
X-Google-Smtp-Source: APXvYqxaB9rOL9R+4t5yWJcrjcqijvd7z5nvhd8kR3Y6/hWhKO9nNHyKuzXxQCl2YzFLuI+JGVvAzw==
X-Received: by 2002:a1c:3b45:: with SMTP id i66mr4588910wma.48.1561128297514;
        Fri, 21 Jun 2019 07:44:57 -0700 (PDT)
Received: from [192.168.1.38] (183.red-88-21-202.staticip.rima-tde.net. [88.21.202.183])
        by smtp.gmail.com with ESMTPSA id 17sm1981542wmx.47.2019.06.21.07.44.56
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 07:44:56 -0700 (PDT)
Subject: Re: [PATCH v2 01/20] hw/i386/pc: Use unsigned type to index arrays
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
 <20190613143446.23937-2-philmd@redhat.com>
 <20190620112729-mutt-send-email-mst@kernel.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Openpgp: id=89C1E78F601EE86C867495CBA2A3FD6EDEADC0DE;
 url=http://pgp.mit.edu/pks/lookup?op=get&search=0xA2A3FD6EDEADC0DE
Message-ID: <791936b7-bd8d-d7fe-531e-f6e850448272@redhat.com>
Date:   Fri, 21 Jun 2019 16:44:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190620112729-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/20/19 5:27 PM, Michael S. Tsirkin wrote:
> On Thu, Jun 13, 2019 at 04:34:27PM +0200, Philippe Mathieu-Daudé wrote:
>> Reviewed-by: Li Qiang <liq3ea@gmail.com>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> 
> Motivation?  Is this a bugfix?

Apparently I started to work on this series after "chardev: Convert
qemu_chr_write() to take a size_t argument" [*] for which I had these
extra warnings:

  --extra-cflags=-Wtype-limits\
                 -Wsign-compare\
                 -Wno-error=sign-compare

[*] https://lists.gnu.org/archive/html/qemu-devel/2019-02/msg05229.html

>> ---
>>  hw/i386/pc.c         | 5 +++--
>>  include/hw/i386/pc.h | 2 +-
>>  2 files changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
>> index 2c5446b095..bb3c74f4ca 100644
>> --- a/hw/i386/pc.c
>> +++ b/hw/i386/pc.c
>> @@ -874,7 +874,7 @@ static void handle_a20_line_change(void *opaque, int irq, int level)
>>  
>>  int e820_add_entry(uint64_t address, uint64_t length, uint32_t type)
>>  {
>> -    int index = le32_to_cpu(e820_reserve.count);
>> +    unsigned int index = le32_to_cpu(e820_reserve.count);
>>      struct e820_entry *entry;
>>  
>>      if (type != E820_RAM) {
>> @@ -906,7 +906,8 @@ int e820_get_num_entries(void)
>>      return e820_entries;
>>  }
>>  
>> -bool e820_get_entry(int idx, uint32_t type, uint64_t *address, uint64_t *length)
>> +bool e820_get_entry(unsigned int idx, uint32_t type,
>> +                    uint64_t *address, uint64_t *length)
>>  {
>>      if (idx < e820_entries && e820_table[idx].type == cpu_to_le32(type)) {
>>          *address = le64_to_cpu(e820_table[idx].address);

And here I wanted to fix:

hw/i386/pc.c:911:13: warning: comparison of integers of different signs:
'int' and 'unsigned int' [-Wsign-compare]
    if (idx < e820_entries && e820_table[idx].type == cpu_to_le32(type)) {
        ~~~ ^ ~~~~~~~~~~~~
hw/i386/pc.c:972:36: warning: comparison of integers of different signs:
'unsigned int' and 'int' [-Wsign-compare]
    for (i = 0, array_count = 0; i < e820_get_num_entries(); i++) {
                                 ~ ^ ~~~~~~~~~~~~~~~~~~~~~~
Is it worthwhile?

>> diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
>> index a7d0b87166..3b3a0d6e59 100644
>> --- a/include/hw/i386/pc.h
>> +++ b/include/hw/i386/pc.h
>> @@ -291,7 +291,7 @@ void pc_madt_cpu_entry(AcpiDeviceIf *adev, int uid,
>>  
>>  int e820_add_entry(uint64_t, uint64_t, uint32_t);
>>  int e820_get_num_entries(void);
>> -bool e820_get_entry(int, uint32_t, uint64_t *, uint64_t *);
>> +bool e820_get_entry(unsigned int, uint32_t, uint64_t *, uint64_t *);
>>  
>>  extern GlobalProperty pc_compat_4_0_1[];
>>  extern const size_t pc_compat_4_0_1_len;
>> -- 
>> 2.20.1

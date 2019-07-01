Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0E25C406
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 21:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfGAT4X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 15:56:23 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33518 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfGAT4W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 15:56:22 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so15183667wru.0
        for <kvm@vger.kernel.org>; Mon, 01 Jul 2019 12:56:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1wfRyxHjaqIfCvUIJ03z9Pt6+BqqMhUX9dFlDyzKWS4=;
        b=ifOcCtBGPm+973a4Qk+IK5lrGbY27fT6DnLArOAWeLDnJU8JEI8YbpX9mxyOjUqKPL
         /e8sjhGjaQNVkcz6qywU8bR9yo35cKd72dXU6Wdcat0GNdGnMrcyLoZYoabFOqiArxbg
         A/aUAEEQJyxCnV8nQiZgJfpxXrz5HiElv6oEG55BGS4Vu0rw5Ln7kuujQ+omvrZ2Y/B5
         m5qWeWEEL4ZWx2kAyuehQKRt9iHA0SQnsyHVAb7BD1rAwMKT2bxF+7B+uRda79Msr3BY
         915r0NATIHyVgPd3/VmBIjJaaGxV6szxVyCOW/OSiAFsj9Spc/unSaSNJ/VGHu0cbiTJ
         w3hQ==
X-Gm-Message-State: APjAAAVxfMcdmBuu9xIdsZUEcAIADRypgoh3BBOPGyMDVZ7Z0G8zOuz1
        gLfKTPNI/7DgPiArvZN2Qvte1A==
X-Google-Smtp-Source: APXvYqxSmcR30ge/EyBOXwxbAdhKB7iKdhT2IxmLNpMTB2qzCpAPeviMne5HP/Gg7blDKXCbYCWV9w==
X-Received: by 2002:a5d:53c2:: with SMTP id a2mr20819742wrw.8.1562010980796;
        Mon, 01 Jul 2019 12:56:20 -0700 (PDT)
Received: from [192.168.1.38] (183.red-88-21-202.staticip.rima-tde.net. [88.21.202.183])
        by smtp.gmail.com with ESMTPSA id e6sm1110355wrw.23.2019.07.01.12.56.19
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 12:56:19 -0700 (PDT)
Subject: Re: [Qemu-devel] [PATCH v3 08/15] hw/i386/pc: Let fw_cfg_init() use
 the generic MachineState
To:     Christophe de Dinechin <dinechin@redhat.com>, qemu-devel@nongnu.org
Cc:     Yang Zhong <yang.zhong@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Rob Bradford <robert.bradford@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <20190701133536.28946-1-philmd@redhat.com>
 <20190701133536.28946-9-philmd@redhat.com> <m1d0ithhhv.fsf@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Openpgp: id=89C1E78F601EE86C867495CBA2A3FD6EDEADC0DE;
 url=http://pgp.mit.edu/pks/lookup?op=get&search=0xA2A3FD6EDEADC0DE
Message-ID: <f3a567a4-496b-9158-1173-7c399a1fa3ee@redhat.com>
Date:   Mon, 1 Jul 2019 21:56:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <m1d0ithhhv.fsf@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/1/19 6:01 PM, Christophe de Dinechin wrote:
> Philippe Mathieu-Daudé writes:
> 
>> We removed the PCMachineState access, we can now let the fw_cfg_init()
>> function to take a generic MachineState object.
> 
> to take -> take
> 
>>
>> Suggested-by: Samuel Ortiz <sameo@linux.intel.com>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>  hw/i386/pc.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
>> index 1e856704e1..60ee71924a 100644
>> --- a/hw/i386/pc.c
>> +++ b/hw/i386/pc.c
>> @@ -929,7 +929,7 @@ static void pc_build_smbios(PCMachineState *pcms)
>>      }
>>  }
>>
>> -static FWCfgState *fw_cfg_arch_create(PCMachineState *pcms,
>> +static FWCfgState *fw_cfg_arch_create(MachineState *ms,
> 
> I don't see where ms is used in the function. Maybe in a later patch,
> I did not receive patches 09-15 yet.

You are right, it is not used (even if the following patches).

>>                                        const CPUArchIdList *cpus,
>>                                        uint16_t boot_cpus,
>>                                        uint16_t apic_id_limit)
>> @@ -1667,6 +1667,7 @@ void pc_memory_init(PCMachineState *pcms,
>>      MemoryRegion *ram_below_4g, *ram_above_4g;
>>      FWCfgState *fw_cfg;
>>      MachineState *machine = MACHINE(pcms);
>> +    MachineClass *mc = MACHINE_GET_CLASS(machine);
>>      PCMachineClass *pcmc = PC_MACHINE_GET_CLASS(pcms);
>>
>>      assert(machine->ram_size == pcms->below_4g_mem_size +
>> @@ -1763,7 +1764,7 @@ void pc_memory_init(PCMachineState *pcms,
>>                                          option_rom_mr,
>>                                          1);
>>
>> -    fw_cfg = fw_cfg_arch_create(pcms, mc->possible_cpu_arch_ids(machine),
>> +    fw_cfg = fw_cfg_arch_create(machine, mc->possible_cpu_arch_ids(machine),
>>                                  pcms->boot_cpus, pcms->apic_id_limit);
>>
>>      rom_set_fw(fw_cfg);

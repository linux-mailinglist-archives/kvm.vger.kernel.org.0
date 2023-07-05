Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92A49748441
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 14:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbjGEMeC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 08:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbjGEMdg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 08:33:36 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1F5139
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 05:33:32 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 46e09a7af769-6b87d505e28so5536679a34.2
        for <kvm@vger.kernel.org>; Wed, 05 Jul 2023 05:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1688560411; x=1691152411;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LR5nJlzSRPDG5ofy0aeeBS76bGKl8nBInZ83Recr1mE=;
        b=EGqN4BJ35V/PWrnpXYXSsjhXZJ6SpCydbRmzvka9w5W5BkC/4L2MtkTY+lGRb08nQ+
         0FdNUqrwQvqVkXLlvDmQFBz2hvdfcB1qusNTmg6l80lWoXBMq41RFcPsV/72+edkZwMT
         nlJmkHdkznCTwewlL6W5/ZYgHGZ0UzXQSdA9/F0f2p94O5qi7lHJ4E48O4CtCDrmSIcr
         ugY1AxJYMQ//CnjzRfxNP0FgqaLKAz3+vWW+pMmQoFDhR7c/6Vq/WMKLyQokMCOcpU6K
         XCXTOGEtkNplwiJIbtPriRjShp+X//JYaxz3x3EoKtD3wIiw42+fdDS7cVDcd3JMHbhJ
         H8MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688560411; x=1691152411;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LR5nJlzSRPDG5ofy0aeeBS76bGKl8nBInZ83Recr1mE=;
        b=ZkzrzFMaQgeMQKV3+IWbvyUJaZPi4HdlFC9sIYmbx8eMHejSpVoGNTrRzK7Zr9O3oN
         6o6tgVFRQGOYuQZuZEiDcDDO3T8otpRp56lIcB8Uq4vq+4AlosX49aaTrmams8lOTX2S
         bevJ3hZ2ybSBAG9VYIaaDjqcZC6lZqeDbkftjxP3jEggcLJHYkKQRBlFjGJFrGQnNTj4
         pvfiP6DZahZzacq/P3xYueSOhHRwVjLX789LidFPl6YmKSOlCzeNOam6f78KN1aiNCpi
         mFWlBp+5qxcoHd14Rqq0A3oDrd5/8iSwHYZ/FNIfRzdI/7V6tZMWTp1v/WgSNA/kmd3x
         KlGg==
X-Gm-Message-State: ABy/qLZMZCZhlFbMxflakdsgDtJN7oN9e2ygTFzVUoE7ixnKgJohRX77
        d9B7CiakQrmrBVqGGgIo+KSVag==
X-Google-Smtp-Source: APBJJlEe5QmRWbFe5VvIhyfS9BgapEugI1LCUwQgs5avsaFH2pSWRL/is1SOBUd5xM6pBjobABfIwQ==
X-Received: by 2002:a05:6870:40cc:b0:1a2:cfd7:bfd0 with SMTP id l12-20020a05687040cc00b001a2cfd7bfd0mr21543911oal.9.1688560411568;
        Wed, 05 Jul 2023 05:33:31 -0700 (PDT)
Received: from [192.168.68.107] (201-69-66-110.dial-up.telesp.net.br. [201.69.66.110])
        by smtp.gmail.com with ESMTPSA id bc30-20020a056820169e00b00565ebacf9cfsm4511309oob.33.2023.07.05.05.33.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 05:33:31 -0700 (PDT)
Message-ID: <029b87e1-d4bc-9deb-316b-b93c5bd2a37f@ventanamicro.com>
Date:   Wed, 5 Jul 2023 09:33:26 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] RISC-V: KVM: provide UAPI for host SATP mode
Content-Language: en-US
To:     Alexandre Ghiti <alex@ghiti.fr>, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
        Conor Dooley <conor.dooley@microchip.com>
Cc:     anup@brainfault.org, atishp@atishpatra.org, ajones@ventanamicro.com
References: <20230705091535.237765-1-dbarboza@ventanamicro.com>
 <994ae720-b3a1-1e67-ca9c-ca00e6525488@ghiti.fr>
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
In-Reply-To: <994ae720-b3a1-1e67-ca9c-ca00e6525488@ghiti.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/5/23 09:18, Alexandre Ghiti wrote:
> 
> On 05/07/2023 11:15, Daniel Henrique Barboza wrote:
>> KVM userspaces need to be aware of the host SATP to allow them to
>> advertise it back to the guest OS.
>>
>> Since this information is used to build the guest FDT we can't wait for
> 
> 
> The thing is the "mmu-type" property in the FDT is never used: the kernel will probe the hardware and choose the largest available mode, or use "no4lvl"/"no5lvl" from the command line to restrict this mode. And FYI the current mode is exposed through cpuinfo. @Conor Can we deprecate this node or something similar?
> 
> Just a remark, not sure that helps :)

It does, thanks. I am aware that the current mode is exposed through cpuinfo.
mvendorid/marchid/mimpid is also exposed there. As far as I understand we should
rely on KVM to provide all CPU related info to configure a vcpu though.

A little background of where I'm coming from. One of the QEMU KVM cpu types (host)
doesn't have an assigned satp_mode. The FDT creation of the 'virt' board relies on
that info being present, and the result is that the board will segfault. I sent a
fix for it that I hope will be queued shortly:

https://lore.kernel.org/qemu-devel/20230630100811.287315-3-dbarboza@ventanamicro.com/

Thus, if it's decided that the satp_mode FDT is deprecated, we can ignore this
patch altogether. Thanks,


Daniel


> 
> 
>> the SATP reg to be readable. We just need to read the SATP mode, thus
>> we can use the existing 'satp_mode' global that represents the SATP reg
>> with MODE set and both ASID and PPN cleared. E.g. for a 32 bit host
>> running with sv32 satp_mode is 0x80000000, for a 64 bit host running
>> sv57 satp_mode is 0xa000000000000000, and so on.
>>
>> Add a new userspace virtual config register 'satp_mode' to allow
>> userspace to read the current SATP mode the host is using with
>> GET_ONE_REG API before spinning the vcpu.
>>
>> 'satp_mode' can't be changed via KVM, so SET_ONE_REG is allowed as long
>> as userspace writes the existing 'satp_mode'.
>>
>> Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
>> ---
>>   arch/riscv/include/asm/csr.h      | 2 ++
>>   arch/riscv/include/uapi/asm/kvm.h | 1 +
>>   arch/riscv/kvm/vcpu.c             | 7 +++++++
>>   3 files changed, 10 insertions(+)
>>
>> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
>> index b6acb7ed115f..be6e5c305e5b 100644
>> --- a/arch/riscv/include/asm/csr.h
>> +++ b/arch/riscv/include/asm/csr.h
>> @@ -46,6 +46,7 @@
>>   #ifndef CONFIG_64BIT
>>   #define SATP_PPN    _AC(0x003FFFFF, UL)
>>   #define SATP_MODE_32    _AC(0x80000000, UL)
>> +#define SATP_MODE_SHIFT    31
>>   #define SATP_ASID_BITS    9
>>   #define SATP_ASID_SHIFT    22
>>   #define SATP_ASID_MASK    _AC(0x1FF, UL)
>> @@ -54,6 +55,7 @@
>>   #define SATP_MODE_39    _AC(0x8000000000000000, UL)
>>   #define SATP_MODE_48    _AC(0x9000000000000000, UL)
>>   #define SATP_MODE_57    _AC(0xa000000000000000, UL)
>> +#define SATP_MODE_SHIFT    60
>>   #define SATP_ASID_BITS    16
>>   #define SATP_ASID_SHIFT    44
>>   #define SATP_ASID_MASK    _AC(0xFFFF, UL)
>> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
>> index f92790c9481a..0493c078e64e 100644
>> --- a/arch/riscv/include/uapi/asm/kvm.h
>> +++ b/arch/riscv/include/uapi/asm/kvm.h
>> @@ -54,6 +54,7 @@ struct kvm_riscv_config {
>>       unsigned long marchid;
>>       unsigned long mimpid;
>>       unsigned long zicboz_block_size;
>> +    unsigned long satp_mode;
>>   };
>>   /* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
>> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
>> index 8bd9f2a8a0b9..b31acf923802 100644
>> --- a/arch/riscv/kvm/vcpu.c
>> +++ b/arch/riscv/kvm/vcpu.c
>> @@ -313,6 +313,9 @@ static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
>>       case KVM_REG_RISCV_CONFIG_REG(mimpid):
>>           reg_val = vcpu->arch.mimpid;
>>           break;
>> +    case KVM_REG_RISCV_CONFIG_REG(satp_mode):
>> +        reg_val = satp_mode >> SATP_MODE_SHIFT;
>> +        break;
>>       default:
>>           return -EINVAL;
>>       }
>> @@ -395,6 +398,10 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
>>           else
>>               return -EBUSY;
>>           break;
>> +    case KVM_REG_RISCV_CONFIG_REG(satp_mode):
>> +        if (reg_val != (satp_mode >> SATP_MODE_SHIFT))
>> +            return -EINVAL;
>> +        break;
>>       default:
>>           return -EINVAL;
>>       }

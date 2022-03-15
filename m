Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B51CD4DA48E
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 22:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243445AbiCOVXP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 17:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243249AbiCOVW6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 17:22:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E29F5B3F3
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 14:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647379304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NXuCGWU9zewjDGKsl7YtKtE7zLqAQ3xKq0SzE1COLFI=;
        b=Vp49a6yKRpw1+pCHdect9+Ln6Oas8WSxyAsq3ZpGf6gJDz7P78ym12RCdMX8HtmMhhdp0b
        OwWEqP0XCuph0hmywFXvVqZ47PIasD3OOk96dV11YqgCotCV/AVuuaP5wgzWnvxhWO978M
        pD+G4bIGkwRymBAKrr9a01WHD9hP5XY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-542-tbItATQmP0ytCkYrNmb0Ug-1; Tue, 15 Mar 2022 17:21:43 -0400
X-MC-Unique: tbItATQmP0ytCkYrNmb0Ug-1
Received: by mail-ej1-f71.google.com with SMTP id de35-20020a1709069be300b006df795e2326so81872ejc.2
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 14:21:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NXuCGWU9zewjDGKsl7YtKtE7zLqAQ3xKq0SzE1COLFI=;
        b=iIY3iunAeFKWbQo9IWE8khuVQsn4gE3M0WnblPL9cdM8zns3BJ9B+ejAaGS7gpZfLk
         DzQkfOV/l8J8AEkFiyDqA6frr1ux/LUqPH8/m0R53O0+rA7sPssl9VBqrGkQ3ahav/Az
         VoQxcLHBs9Xr9uOR7TGJbYbkoiiVb8HAnftXs/tmtsVtps+dpgrsQ/8fXTIgPOfyEPZN
         M62xBjHQQM40GLhWOTKqJbKAT6o70KODpTCFelmwo691R1CCoxwatBPutiRbAYOS87YW
         jJrny08SeoMlRQ1vIcQbuSkSkVgax184V0GZIfdhtPQAt2bHN8Tlo4wqw5KucFruepiY
         kuRQ==
X-Gm-Message-State: AOAM532qGFTNr1ddFSUvrPTJwwwIB8QdzzE0oGfsVa7LbNRB4zkEu3Ww
        aYgy9LsjW4jtEF0bRK4PwH/gayuBbniwm/n05pvkYH8TKmhyh4lywdPETKtNIftl2nZmWi20p/s
        JmdaJmnPL9b9F
X-Received: by 2002:a17:906:4fc7:b0:6da:92b2:f572 with SMTP id i7-20020a1709064fc700b006da92b2f572mr24103914ejw.184.1647379301811;
        Tue, 15 Mar 2022 14:21:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJye+k2UJTgNQv/poK+0J3x/pPcB5kz1U3x1hR6oTFFyJZjNE3X2xHxa3ovb3ZV592gAJ2VXfg==
X-Received: by 2002:a17:906:4fc7:b0:6da:92b2:f572 with SMTP id i7-20020a1709064fc700b006da92b2f572mr24103902ejw.184.1647379301596;
        Tue, 15 Mar 2022 14:21:41 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id q15-20020a1709060e4f00b006cdf4535cf2sm77812eji.67.2022.03.15.14.21.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 14:21:41 -0700 (PDT)
Message-ID: <47f64c5e-fa36-9e87-763b-4e7385713e76@redhat.com>
Date:   Tue, 15 Mar 2022 22:21:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [GIT PULL] KVM/riscv changes for 5.18
Content-Language: en-US
To:     Anup Patel <anup@brainfault.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>
References: <CAAhSdy1cBkGqBLN7iZY-FUx2BFGoXmxd4WZJemPSRKz6my8cZQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAAhSdy1cBkGqBLN7iZY-FUx2BFGoXmxd4WZJemPSRKz6my8cZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/11/22 18:02, Anup Patel wrote:
> Hi Paolo,
> 
> We have three KVM RISC-V changes for 5.18 which are:
> 1) Prevent KVM_COMPAT from being selected
> 2) Refine __kvm_riscv_switch_to() implementation
> 3) RISC-V SBI v0.3 support
> 
> I don't expect any other KVM RISC-V changes for 5.18.
> 
> Please pull.
> 
> Regards,
> Anup
> 
> The following changes since commit 4a204f7895878363ca8211f50ec610408c8c70aa:
> 
>    KVM: SVM: Allow AVIC support on system w/ physical APIC ID > 255
> (2022-03-08 10:59:12 -0500)
> 
> are available in the Git repository at:
> 
>    https://github.com/kvm-riscv/linux.git tags/kvm-riscv-5.18-1
> 
> for you to fetch changes up to 763c8bed8c05ffcce8cba882e69cd6b03df07019:
> 
>    RISC-V: KVM: Implement SBI HSM suspend call (2022-03-11 19:02:39 +0530)
> 
> ----------------------------------------------------------------
> KVM/riscv changes for 5.18
> 
> - Prevent KVM_COMPAT from being selected
> - Refine __kvm_riscv_switch_to() implementation
> - RISC-V SBI v0.3 support

Pulled, thanks.

Paolo

> 
> ----------------------------------------------------------------
> Anup Patel (6):
>        RISC-V: KVM: Upgrade SBI spec version to v0.3
>        RISC-V: KVM: Add common kvm_riscv_vcpu_sbi_system_reset() function
>        RISC-V: KVM: Implement SBI v0.3 SRST extension
>        RISC-V: Add SBI HSM suspend related defines
>        RISC-V: KVM: Add common kvm_riscv_vcpu_wfi() function
>        RISC-V: KVM: Implement SBI HSM suspend call
> 
> Guo Ren (1):
>        KVM: compat: riscv: Prevent KVM_COMPAT from being selected
> 
> Vincent Chen (1):
>        RISC-V: KVM: Refine __kvm_riscv_switch_to() implementation
> 
> Yang Li (1):
>        RISC-V: KVM: remove unneeded semicolon
> 
>   arch/riscv/include/asm/kvm_host.h     |  1 +
>   arch/riscv/include/asm/kvm_vcpu_sbi.h |  5 ++-
>   arch/riscv/include/asm/sbi.h          | 27 +++++++++++++---
>   arch/riscv/kernel/cpu_ops_sbi.c       |  2 +-
>   arch/riscv/kvm/vcpu_exit.c            | 22 +++++++++----
>   arch/riscv/kvm/vcpu_sbi.c             | 19 +++++++++++
>   arch/riscv/kvm/vcpu_sbi_hsm.c         | 18 +++++++++--
>   arch/riscv/kvm/vcpu_sbi_replace.c     | 44 +++++++++++++++++++++++++
>   arch/riscv/kvm/vcpu_sbi_v01.c         | 20 ++----------
>   arch/riscv/kvm/vcpu_switch.S          | 60 ++++++++++++++++++++---------------
>   virt/kvm/Kconfig                      |  2 +-
>   11 files changed, 161 insertions(+), 59 deletions(-)
> 


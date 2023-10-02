Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF147B4F53
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 11:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236217AbjJBJpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 05:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236095AbjJBJpd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 05:45:33 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A3991;
        Mon,  2 Oct 2023 02:45:30 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-536071e79deso6403973a12.1;
        Mon, 02 Oct 2023 02:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696239929; x=1696844729; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KGsTzw39DzKGKK/TLMQfTsY/wGdV95nt+7dMAry0cG0=;
        b=TDhK7+59oyATzsX0GMZ4HQN3pHmJhM9Y+RJwdb/vhdPYQVVbTMKVYSmJ3jqf+UeSp6
         9PHjarO9LiCovK9pHverCd8lemluzB+MmsWhsZM7mh+dlASrlTx3siG7Red0oG7hxjpP
         5lwuMrZBGYYISXX9TCBQISdGF0VvvsLdU+T91TadXCEV5Kpe1GRzkIdJpSyp610Lx/0+
         ODZgbP6uWVG0rk+BjKfAt97NIBBU0NslMo1/W/Y3gxFFEeRRN180DGI49f+2wNuGfOFM
         jadrOKejfJ69LPDFX1HvNnmpmBhD54E1UW6B5VOz8T+mphqC2IzdH2CMPHbjbryAJFb8
         2y1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696239929; x=1696844729;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KGsTzw39DzKGKK/TLMQfTsY/wGdV95nt+7dMAry0cG0=;
        b=sSV4OU/muQEhJ5VUaI6yj5ySlaVf6gHa7w6Ox+hhLtg1LkWv4SNCnXeRb6+2Ngd1HK
         GBZM70gosD5Wzqsp4r1wRnOmtp4vKJvkD1eOrGuhky/Uz62aZVi5j+CZw7yUM9tmYpbn
         biWP7o1TIfT1PKX3MSto0E+U2pbCF5E7mVpkSSOBZ2VcwPdsNhS5Fe0b7aR9rquniODX
         CyExwCHJsv+hh0H4L4wQ5yWgwePus9z9Jr/KZsSR2OJD4J8fFFQKC3qyZz1iWtAdoeb1
         udk+LdIN7WOBBW8UiAtajVJyyDxhWJdFWv54F17QP1QEvbG8BBsd2EfMISyy3qtoOKf2
         sGUA==
X-Gm-Message-State: AOJu0YwSuXbYbbu/4uKDpB7fs2HXRZZdiA5wLUeoflZIJYJGFvyFv7QF
        7y3Mkh++scBVTmt7Wi5siu4=
X-Google-Smtp-Source: AGHT+IEri3HR4lSj1taxtrBzWim+6JEVtI8cMbP3DbQmlY0nMrCNR5dgGLZShhANdijkosfOGPcLww==
X-Received: by 2002:aa7:d1c3:0:b0:52f:a763:aab4 with SMTP id g3-20020aa7d1c3000000b0052fa763aab4mr10819115edp.5.1696239929016;
        Mon, 02 Oct 2023 02:45:29 -0700 (PDT)
Received: from [192.168.5.6] (PC-176-101-165-146.tvk-net.pl. [176.101.165.146])
        by smtp.gmail.com with ESMTPSA id y15-20020aa7cccf000000b0053691cacd95sm5334019edt.87.2023.10.02.02.45.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Oct 2023 02:45:28 -0700 (PDT)
Message-ID: <14e3a4d5-672c-413d-5003-734839674494@gmail.com>
Date:   Mon, 2 Oct 2023 11:45:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC kvmtool 00/31] arm64: Support for Arm Confidential Compute
 Architecture
Content-Language: en-US
To:     Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Steven Price <steven.price@arm.com>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, linux-coco@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127113932.166089-1-suzuki.poulose@arm.com>
From:   Piotr Sawicki <piotr.sawickas@gmail.com>
In-Reply-To: <20230127113932.166089-1-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Suzuki

> This series is an initial version of the support for running VMs under the
> Arm Confidential Compute Architecture. The purpose of the series is to gather
> feedback on the proposed UABI changes for running Confidential VMs with KVM.
> More information on the Arm CCA and instructions for how to get, build and run
> the entire software stack is available here [0].
> 
> A new option, `--realm` is added to the the `run` command to mark the VM as a
> confidential compute VM. This version doesn't use the Guest private memory [1]
> support yet, instead uses normal anonymous/hugetlbfs backed memory. Our aim is
> to switch to the guest private memory for the Realm.
> 
> The host including the kernel and kvmtool, must not access any memory allocated
> to the protected IPA of the Realm.
> 
> The series adds the support for managing the lifecycle of the Realm, which includes:
>     * Configuration
>     * Creation of Realm (RD)
>     * Load initial memory images
>     * Creation of Realm Execution Contexts (RECs aka VCPUs)a
>     * Activation of the Realm.
> 
> Patches are split as follows :
> 
> Patches 1 and 2 are fixes to existing code.
> Patch 3 adds a new option --nocompat to disable compat warnings
> Patches 4 - 6 are some preparations for Realm specific changes.
> 
> The remaining patches adds Realm support and using the --realm option is
> enabled in patch 30.
> 
> The v1.0 of the Realm Management Monitor (RMM) specification doesn't support
> paging protected memory of a Realm. Thus all of the memory backing the RAM
> is locked by the VMM.
> 
> Since the IPA space of a Realm is split into Protected and Unprotected, with
> one alias of the other, the VMM doubles the IPA Size for a Realm VM.
> 
> The KVM support for Arm CCA is advertised with a new cap KVM_CAP_ARM_RME.
> A new "VM type" field is defined in the vm_type for CREATE_VM ioctl to indicate
> that a VM is "Realm". Once the VM is created, the life cycle of the Realm is
> managed via KVM_ENABLE_CAP of KVM_CAP_ARM_RME.
> 
> Command line options are also added to configure the Realm parameters.
> These include :
>   - Hash algorithm for measurements
>   - Realm personalisation value
>   - SVE vector Length (Optional feature in v1.0 RMM spec. Not yet supported
>     by the TF-RMM. coming soon).
> 
> Support for PMU and self-hosted debug (number of watchpoint/breakpoit registers)
> are not supported yet in the KVM/RMM implementation. This will be added soon.
> 
> The UABI doesn't support discovering the "supported" configuration values. In
> real world, the Realm configuration 'affects' the initial measurement of the
> Realms and which may be verified by a remote entity. Thus, the VMM is not at
> liberty to make choices for configurations based on the "host" capabilities.
> Instead, VMM should launch a Realm with the user requested parameters. If this
> cannot be satisfied, there is no point in running the Realm. We are happy to
> change this if there is interest.
> 
> Special actions are required to load the initial memory images (e.g, kernel,
> firmware, DTB, initrd) in to the Realm memory.
> 
> For VCPUs, we add a new feature KVM_ARM_VCPU_REC, which will be used to control
> the creation of the REC object (via KVM_ARM_VCPU_FINALIZE). This must be done
> after the initial register state of the VCPUs are set.
> RMM imposes an order in which the RECs are created. i.e., they must be created
> in the ascending order of the MPIDR. This is for now a responsibility of the
> VMM.
> 
> Once the Realm images are loaded, VCPUs created, Realm is activated before
> the first vCPU is run.
> 
> virtio for the Realms enforces VIRTIO_F_ACCESS_PLATFORM flag.
> 
> Also, added support for injecting SEA into the VM for unhandled MMIO.
> 

I wonder if there is a plan to develop a dedicated (stand-alone) tool 
that allows a realm developer to calculate Realm Initial Measurements 
for realms. I mean a tool that can be compiled and run on a Linux PC 
machine.

As you know, the remote attestation mechanism requires a verifier to be 
provisioned with reference values. In this case, a realm verifier should 
have access to the initial reference measurement (RIM) of a realm that 
is intended to be run on a remote Arm CCA platform.

The algorithm that measures the initial state of realms (RIM) is highly 
sensitive to the content of a realm memory and the order of RMI 
operations. This means that not only the content of populated realm 
memory matters but also the implementation of the host components (e.g. 
kvm, kvmtool/qemu).In the  of kvmtool-cca, the layout of memory and the 
content of DTB highly depend on the provided options (DTB is generated 
in run-time). Unfortunately, the content of DTB also depends on the 
linking order of object files (the order of DTB generation is imposed by 
__attribute__((constructor)) that is used to register devices). This 
complicates development of a separate tool for calculating RIM, as the 
tool would have to emulate all quirks of the kvmtool.

One of the solution of retrieving Realm Initial Measurements seems to be 
running the whole firmware/software (e.g. kvmtool/Linux host/TF-RMM) 
stack on the FVP emulator and gathering the RIM directly from the 
TF-RMM. This would require a realm developer to have access to the whole 
firmware/software stack and the emulator of the CCA platform.

The other solution would require the implementation of a dedicated tool. 
For instance, a sensible approach could be to extend the functionality 
of kvmtool.

Is Arm going to develop a dedicated, stand-alone tool for calculating RIMs?

What is the recommended way of retrieving/calculating RIMs for realms?

Kind regards,
Piotr Sawicki

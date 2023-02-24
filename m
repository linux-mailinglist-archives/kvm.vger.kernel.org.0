Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEF46A1497
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 02:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjBXB1j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 20:27:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBXB1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 20:27:37 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2355B3756A;
        Thu, 23 Feb 2023 17:27:33 -0800 (PST)
Received: from loongson.cn (unknown [10.20.42.120])
        by gateway (Coremail) with SMTP id _____8BxIk6EEvhjT2kEAA--.3172S3;
        Fri, 24 Feb 2023 09:27:32 +0800 (CST)
Received: from [10.20.42.120] (unknown [10.20.42.120])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxK76DEvhjKh46AA--.40084S3;
        Fri, 24 Feb 2023 09:27:32 +0800 (CST)
Subject: Re: [PATCH v2 01/29] LoongArch: KVM: Add kvm related header files
To:     Xi Ruoyao <xry111@xry111.site>, Paolo Bonzini <pbonzini@redhat.com>
References: <20230220065735.1282809-1-zhaotianrui@loongson.cn>
 <20230220065735.1282809-2-zhaotianrui@loongson.cn>
 <ef024d7e4e0207e76c165c1818d1bb21f07235ab.camel@xry111.site>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <004179bf-2d9c-f534-f40a-646bafc1e2bf@loongson.cn>
Date:   Fri, 24 Feb 2023 09:27:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <ef024d7e4e0207e76c165c1818d1bb21f07235ab.camel@xry111.site>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxK76DEvhjKh46AA--.40084S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvdXoW7Xr18GFyrZFy7tF4Dtw4xWFg_yoWfuFX_Zw
        4xAw4kGa1rtrnFqrn2gFn0gF1vga1kt3Wvvw1YvF95Zwn3Xay8Ar4kC34kAasrJ34rtF17
        ur4kta4fWrZ7XjkaLaAFLSUrUUUUnb8apTn2vfkv8UJUUUU8wcxFpf9Il3svdxBIdaVrn0
        xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUO
        17kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3w
        AFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK
        6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j6F4UM28EF7
        xvwVC2z280aVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8JVW8Jr1ln4kS
        14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
        1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv
        67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
        AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE
        7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI8I3I
        0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAI
        cVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcV
        CF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8Dl1DUUUUU==
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年02月21日 12:36, Xi Ruoyao 写道:
> On Mon, 2023-02-20 at 14:57 +0800, Tianrui Zhao wrote:
>
> /* snip */
>
>> +/*
>> + * for KVM_GET_FPU and KVM_SET_FPU
>> + */
>> +struct kvm_fpu {
>> +	__u32 fcsr;
>> +	__u32 none;
>> +	__u64 fcc;    /* 8x8 */
>> +	struct kvm_fpureg {
>> +		__u64 val64[4];	//support max 256 bits
>> +	} fpr[32];
> Do we need __attribute__((__aligned__(16))) for fpureg (like
> sc_extcontext in struct sigcontext)?

Thanks,  the loongarch_fpu variable is already has FPU_ALIGN feature in 
the kvm_vcpu_arch structure, so it need not to use __aligned__(16).

Thanks
Tianrui Zhao

>
>> +};
>> +
>> +/*
>> + * For LOONGARCH, we use KVM_SET_ONE_REG and KVM_GET_ONE_REG to
>            ^^^^^^^^^
>            LoongArch

Thanks, I will fix it

Thanks
Tianrui Zhao

>
>> access various
>> + * registers.  The id field is broken down as follows:
>> + *
>> + *  bits[63..52] - As per linux/kvm.h
>> + *  bits[51..32] - Must be zero.
>> + *  bits[31..16] - Register set.


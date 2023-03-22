Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1702A6C3FD8
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 02:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjCVBf3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 21:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbjCVBfN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 21:35:13 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8121F5A6DF;
        Tue, 21 Mar 2023 18:34:57 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.120])
        by gateway (Coremail) with SMTP id _____8Bxok44WxpkrskPAA--.12096S3;
        Wed, 22 Mar 2023 09:34:48 +0800 (CST)
Received: from [10.20.42.120] (unknown [10.20.42.120])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8BxX+Q2Wxpkt0MJAA--.37863S3;
        Wed, 22 Mar 2023 09:34:46 +0800 (CST)
Subject: Re: [PATCH v4 05/29] LoongArch: KVM: Add vcpu related header files
To:     Xi Ruoyao <xry111@xry111.site>, Paolo Bonzini <pbonzini@redhat.com>
References: <20230321035651.598505-1-zhaotianrui@loongson.cn>
 <20230321035651.598505-6-zhaotianrui@loongson.cn>
 <75f843b2780fc3c3dcc1d0d8f78f2b955956316b.camel@xry111.site>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <554dc19a-cd94-0f94-7e81-9cdc137dac7d@loongson.cn>
Date:   Wed, 22 Mar 2023 09:34:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <75f843b2780fc3c3dcc1d0d8f78f2b955956316b.camel@xry111.site>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8BxX+Q2Wxpkt0MJAA--.37863S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvdXoW7Xr18JrW8JryrtFyfurykKrg_yoWDZFb_Xr
        s8JF15Ca1kWF4xtanIkFWrX347Gr43Zw15Aa1jqws0qr4rKry0qws3Krs2yrs3tw109F17
        Cay5J3sIg3sxujkaLaAFLSUrUUUUnb8apTn2vfkv8UJUUUU8wcxFpf9Il3svdxBIdaVrn0
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
X-Spam-Status: No, score=3.6 required=5.0 tests=NICE_REPLY_A,RCVD_IN_SBL_CSS,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年03月21日 20:30, Xi Ruoyao 写道:
> On Tue, 2023-03-21 at 11:56 +0800, Tianrui Zhao wrote:
>> +/* Tracepoints for VM exits */
>> +#define kvm_trace_symbol_exit_types                    \
>> +       ({ KVM_TRACE_EXIT_IDLE,         "IDLE" },       \
>> +       { KVM_TRACE_EXIT_CACHE,         "CACHE" },      \
>> +       { KVM_TRACE_EXIT_SIGNAL,        "Signal" })
> Looks like there shouldn't be "(" and ")".
>
>> +#define kvm_trace_symbol_aux_op				\
>> +	({ KVM_TRACE_AUX_RESTORE,	"restore" },	\
>> +	{ KVM_TRACE_AUX_SAVE,		"save" },	\
>> +	{ KVM_TRACE_AUX_ENABLE,		"enable" },	\
>> +	{ KVM_TRACE_AUX_DISABLE,	"disable" },	\
>> +	{ KVM_TRACE_AUX_DISCARD,	"discard" })
> Likewise.
>
> See the test robot report, and https://godbolt.org/z/bE8q97z1o.
>
> The lesson: if a text book claims "you should always wrap the content of
> a macro in ( ... )", we should burn it in the fire! :)
>

Thanks, it should remove the "()" statement in the macros. The reason I 
did this before because an error was triggered when I use checkpatch.py 
to check it,  and now I know this error can be ignored.

Thanks
Tianrui Zhao


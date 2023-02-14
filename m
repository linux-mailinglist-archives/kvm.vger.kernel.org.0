Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B20C769642F
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 14:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbjBNNFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 08:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbjBNNFp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 08:05:45 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B0E923860;
        Tue, 14 Feb 2023 05:05:43 -0800 (PST)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8Dx_5clh+tjbogAAA--.428S3;
        Tue, 14 Feb 2023 21:05:41 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Bxzr4kh+tjU9syAA--.40049S3;
        Tue, 14 Feb 2023 21:05:40 +0800 (CST)
Message-ID: <c028b3bd-7f42-49d3-b811-fca680bf86ac@loongson.cn>
Date:   Tue, 14 Feb 2023 21:05:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v1 01/24] LoongArch: KVM: Implement kvm module related
 interface
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>
References: <20230214025648.1898508-1-zhaotianrui@loongson.cn>
 <20230214025648.1898508-2-zhaotianrui@loongson.cn>
 <Y+ssT+W27GxDRAAZ@kroah.com>
 <6fd2ca5a-7243-0627-79e9-8c8bd840adc2@loongson.cn>
 <Y+tbMwXjA0hkiUJA@kroah.com>
From:   maobibo <maobibo@loongson.cn>
In-Reply-To: <Y+tbMwXjA0hkiUJA@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Bxzr4kh+tjU9syAA--.40049S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjvdXoW7JFy8XFWUAFyfJF17CryDZFb_yoWfJFX_ur
        s7Aa1Du3y8GFs3Kan0yF909FWxC3W5Ga40qrs8GFWS93s8Xa1xAFs7WrZ2vFn0ga1SyFs3
        u3sYgFWUX39rXjkaLaAFLSUrUUUU0b8apTn2vfkv8UJUUUU8wcxFpf9Il3svdxBIdaVrn0
        xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUO
        87kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3w
        AFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK
        6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j6F4UM28EF7
        xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr0_GcWln4kS
        14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
        1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv
        67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
        AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE
        7xkEbVWUJVW8JwCFI7km07C267AKxVWUtVW8ZwC20s026c02F40E14v26r1j6r18MI8I3I
        0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAI
        cVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcV
        CF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jFApnUUUUU=
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023/2/14 17:58, Greg Kroah-Hartman 写道:
> On Tue, Feb 14, 2023 at 05:00:56PM +0800, Tianrui Zhao wrote:
>>>> +#define KVM_GET_CSRS		_IOWR(KVMIO, 0xc5, struct kvm_csrs)
>>>> +#define KVM_SET_CSRS		_IOW(KVMIO,  0xc6, struct kvm_csrs)
>>> Why does this arch need new ioctls?
>> We want to use this ioctl to access multiple csrs at one time. If without
>> this, we only access one csr.
> 
> What is wrong with accessing only one csr at a time?  Isn't this what
> other architectures do?
It is ok to access CSR register once at a time, the other platforms do this
except x86 platform. Only that I think that batch method is better such as
KVM_GET/SET_MSRS ioctl cmds in x86. 

Regards
Bibo, Mao
> 
>> There is another function, can we use the KVM_GET/SET_MSRS to access our
>> csrs?
> 
> I do not know, that's up to the KVM developers to answer.
> 
> thanks,
> 
> greg k-h


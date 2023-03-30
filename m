Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7F16CF9A1
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 05:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjC3Dlm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 23:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjC3Dlk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 23:41:40 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 98C3B49EB;
        Wed, 29 Mar 2023 20:41:38 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.120])
        by gateway (Coremail) with SMTP id _____8Cxf83xBCVkCTMUAA--.31062S3;
        Thu, 30 Mar 2023 11:41:37 +0800 (CST)
Received: from [10.20.42.120] (unknown [10.20.42.120])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8BxZbzvBCVklfQQAA--.11367S3;
        Thu, 30 Mar 2023 11:41:36 +0800 (CST)
Subject: Re: [PING PATCH v4 27/29] LoongArch: KVM: Implement vcpu world switch
To:     Paolo Bonzini <pbonzini@redhat.com>
References: <20230328123119.3649361-1-zhaotianrui@loongson.cn>
 <20230328123119.3649361-28-zhaotianrui@loongson.cn>
 <55c79f33-2549-38eb-f868-8e6141d7d322@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <11fefc2b-63e4-a4a8-94c7-c4e312aa4958@loongson.cn>
Date:   Thu, 30 Mar 2023 11:41:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <55c79f33-2549-38eb-f868-8e6141d7d322@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8BxZbzvBCVklfQQAA--.11367S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvdXoW7JFyDZF4xCw1kAr4UKw4UJwb_yoWxCrcEgw
        4DG3ZrGa95Can2k34j9r15Xa18Wa40yr1Yy34xXry5Xry8GrW7WrnY9wn7Zry5J3WjyrW5
        GF1v934UuFyYgjkaLaAFLSUrUUUUnb8apTn2vfkv8UJUUUU8wcxFpf9Il3svdxBIdaVrn0
        xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUO
        n7kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3w
        AFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK
        6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j6F4UM28EF7
        xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJwAa
        w2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44
        I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2
        jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62
        AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCa
        FVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2
        IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI
        42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42
        IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280
        aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8uc_3UUUUU==
X-Spam-Status: No, score=-0.0 required=5.0 tests=NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年03月28日 22:13, Paolo Bonzini 写道:
> On 3/28/23 14:31, Tianrui Zhao wrote:
>> + * prepare switch to guest
>> + * @param:
>> + *  KVM_ARCH: kvm_vcpu_arch, don't touch it until 'ertn'
>> + *  GPRNUM: KVM_ARCH gpr number
>
> Stale comment (should be "a2: kvm_vcpu_arch, don't touch it until 
> 'ertn'").
>
> Since you are at it, I noticed now that tmp and tmp1 aren't too useful 
> because all registers will be overwritten before the end of the macro. 
> You choose whether to keep or remove them.
>
> Paolo

Thanks, I will fix the stale comment and remove the tmp,tmp1 argument 
and replace it with t0,t1 reg.

Thanks
Tianrui Zhao

>
>> + *  tmp, tmp1: temp register
>> + */


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7A46E952F
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 14:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbjDTM76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 08:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbjDTM74 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 08:59:56 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E9AE140E7
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 05:59:54 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.120])
        by gateway (Coremail) with SMTP id _____8CxC9pIN0FkwYYfAA--.55510S3;
        Thu, 20 Apr 2023 20:59:53 +0800 (CST)
Received: from [10.20.42.120] (unknown [10.20.42.120])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8BxmrJHN0Fk+jExAA--.1149S3;
        Thu, 20 Apr 2023 20:59:52 +0800 (CST)
Subject: Re: [PATCH RFC v1 01/10] linux-headers: Add KVM headers for loongarch
To:     Cornelia Huck <cohuck@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        gaosong@loongson.cn
References: <20230420093606.3366969-1-zhaotianrui@loongson.cn>
 <20230420093606.3366969-2-zhaotianrui@loongson.cn>
 <87bkji51e2.fsf@redhat.com>
Cc:     "Michael S . Tsirkin" <mst@redhat.com>, maobibo@loongson.cn
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <202d559e-a244-6855-949b-59ed55470ec0@loongson.cn>
Date:   Thu, 20 Apr 2023 20:59:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <87bkji51e2.fsf@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8BxmrJHN0Fk+jExAA--.1149S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvdXoWrtFW3Kr1kAF4xGFW8GrW3Jrb_yoW3trbE9w
        4xAryDJ3y8G3Z5ta47t3W5WFy3Way0y3Z8ZFWYqF1DWr18trW5Xr48Gw4ru3Z8tr4vyFs8
        Jr95J34rArnrJjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8wcxFpf9Il3svdxBIdaVrn0
        xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUY
        c7kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3w
        AFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK
        6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j6F4UM28EF7
        xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAI
        cxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c
        02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVW8JVWxJwAm72CE
        4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20x
        vY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I
        3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIx
        AIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAI
        cVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26F4j6r4UJwCI42IY6I8E87
        Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU7pnQUUUUU
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年04月20日 17:49, Cornelia Huck 写道:
> On Thu, Apr 20 2023, Tianrui Zhao <zhaotianrui@loongson.cn> wrote:
>
>> Add asm-loongarch/kvm.h for loongarch KVM, and update
>> the linux/kvm.h about loongarch part. The structures in
>> the header are used as kvm_ioctl arguments.
> Just a procedural note: It's probably best to explicitly mark this as a
> placeholder patch until you can replace it with a full headers update.
Thanks, I will mark this as a placeholder patch until it can be merged.

Thanks
Tianrui Zhao
>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   linux-headers/asm-loongarch/kvm.h | 99 +++++++++++++++++++++++++++++++
>>   linux-headers/linux/kvm.h         |  9 +++
>>   2 files changed, 108 insertions(+)
>>   create mode 100644 linux-headers/asm-loongarch/kvm.h


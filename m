Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03DFD79C302
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 04:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236928AbjILCeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 22:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239166AbjILCdu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 22:33:50 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 99C56148AA5;
        Mon, 11 Sep 2023 18:58:31 -0700 (PDT)
Received: from loongson.cn (unknown [10.40.46.158])
        by gateway (Coremail) with SMTP id _____8Cx7+vGxf9kYzAlAA--.5824S3;
        Tue, 12 Sep 2023 09:58:30 +0800 (CST)
Received: from [192.168.124.126] (unknown [10.40.46.158])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxDCOoxf9k1HN4AA--.4956S3;
        Tue, 12 Sep 2023 09:58:27 +0800 (CST)
Subject: Re: [PATCH v20 28/30] LoongArch: KVM: Enable kvm config and add the
 makefile
To:     WANG Xuerui <kernel@xen0n.name>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>,
        kernel test robot <lkp@intel.com>
References: <20230831083020.2187109-1-zhaotianrui@loongson.cn>
 <20230831083020.2187109-29-zhaotianrui@loongson.cn>
 <1c66bd8b-4be7-8296-6fd8-aa206476f017@xen0n.name>
From:   zhaotianrui <zhaotianrui@loongson.cn>
Message-ID: <0e04d1be-be64-c5c3-b167-f28376b7bdc8@loongson.cn>
Date:   Tue, 12 Sep 2023 09:57:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1c66bd8b-4be7-8296-6fd8-aa206476f017@xen0n.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: AQAAf8AxDCOoxf9k1HN4AA--.4956S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj9xXoWrZryUuFWDGr4DKrW7uFW5XFc_yoW3XwcEk3
        4S9FZrCry7Jws7uw1agFnIyasrKFZ5Wryjyr98ta42g3saqrWDCw4qy3ykA34UGw1rGF9I
        k34vyF1Syw13CosvyTuYvTs0mTUanT9S1TB71UUUUbUqnTZGkaVYY2UrUUUUj1kv1TuYvT
        s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
        cSsGvfJTRUUUbq8YFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
        vaj40_Wr0E3s1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
        w2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
        W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
        Cr1j6rxdM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
        kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWr
        XwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
        k0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l
        4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxV
        WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
        7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
        4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
        42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU2pVbDUUUU
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2023/9/11 下午3:30, WANG Xuerui 写道:
> On 8/31/23 16:30, Tianrui Zhao wrote:
>> [snip]
>> +
>> +config AS_HAS_LVZ_EXTENSION
>> +    def_bool $(as-instr,hvcl 0)
>
> Upon closer look it looks like this piece could use some improvement 
> as well: while presence of "hvcl" indeed always implies full support 
> for LVZ instructions, "hvcl" however isn't used anywhere in the 
> series, so it's not trivially making sense. It may be better to test 
> for an instruction actually going to be used like "gcsrrd". What do 
> you think?
Thanks for your advice, and I think both "hvcl" and "gcsrrd" 
instructions which are supported by binutils mean that the cpu support 
LVZ extension, so I think they have the same meaning there.

Thanks
Tianrui Zhao


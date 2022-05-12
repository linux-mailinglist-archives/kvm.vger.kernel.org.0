Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4834524C63
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 14:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353546AbiELMIA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 08:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243140AbiELMH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 08:07:57 -0400
Received: from out203-205-221-209.mail.qq.com (out203-205-221-209.mail.qq.com [203.205.221.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4924C33E9B
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 05:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1652357271;
        bh=dvRqU0wbN9ax2HWQ4MC6c/hLOSalaiLIB+fzDwL1SPE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=NoIx5rBoLwU51AIHrFDk9TAquSlQ3A65e96UZeV4xd+xl250BFOjau292ECTQa6sR
         coaZKZbB+K7ol3JPmxYxH5aCMaPq5X4fkOSkYTxbzx/WfN5VBs1W6V0vc9hL/3n3L1
         aoMu/1aOcfQdmLKbFXzh/Tq2pWAOdQlIoq9iFCu0=
Received: from [192.168.0.110] ([36.57.146.152])
        by newxmesmtplogicsvrszc11.qq.com (NewEsmtp) with SMTP
        id 1EF2C8BA; Thu, 12 May 2022 20:07:47 +0800
X-QQ-mid: xmsmtpt1652357267t0p6u2g7l
Message-ID: <tencent_D40360903A6274DB4A4DA4A93F2DBC01BA05@qq.com>
X-QQ-XMAILINFO: M3Q/Kj4zjy60jyGphjlxBlNc42jR1kzEgeXF/c/IfnVoScKq/vQHRD1i1TQuMK
         Xlw4K4+66+LtW/VflVJbJHX6U7dwLuyRGsbAOpWRSyKTnsEGX7EXGTYHGl4y+EBbAq8EO8KAH2qs
         IzWL97+MJbN/xliUTNbedQ2wC5gEBY8xIWYQnX6tu9nmTNgs7OOA9aJK1WJvMb39wRocUqaChahF
         1yhDkL18jeUqFnDg3GHTlyxwxXdzTHByfhKD42gLXrrdrvmZHuMAJp372at6U1Ux+LtiywbCx8Im
         Ca18wnKvAQtirFz0i5sGRoj42P5tqVpbgl6PJ3fWEjlgck8lVMFeBIrcG0Hxdoynp2JmPJKA6dZS
         tyuI9KOpnNLcIZ0lFGDI7UbTw5bZ4GIud+OpgUP5yU6/wkhKVhhH6jYt4ker78FtFlFOKFXXhtIW
         5gshaaqD+AU/flN2LF3VhI7U8x6Yajinm9alBpHlyZdGPQVUx6l5cIa4tj+1P5fg3+YtxmftFqD7
         jwLKrNgNPFA5BLFnksic8xbBfL+n/52BBcnmKZJ8/Kd+ZGgCUGje+wNuFu+7y9tkuFkmCtM+Awfb
         ZEsMpESkpillcQK2+/l7nZ+Wx2F3u+2V4MUFUbr0nFzAugLVsDV0DapJZ/anAQWyGZAlQLSj+B3q
         0BMYDPKlt9cMLbTAyELK555T61RAfYJe7pR9nG86Npu/XnFU0uHHWMCKAgdbk0M9fAtDIiOAI58a
         PcBL1pNrlhvEJd1aEmglI/zhrOxVDBkv+JPgrBzDiyP2xjUVlFG3DyDAes0t5Fo2T0iP77/qLT8w
         9TOPUwobgHwrJIAueJC589x6UPvFJkAf+SSdjlFtAlCYDzroD6vBgm32ZXO8DlUI3OEd+cEw4Pel
         HG0yPloY9p36dKhPLR18dSxPJryQxb6ntPgSv1j6bgsFYBmgIee2hRDsSO26CUjf7qqJp7r0BOgr
         L/UCAELp67Lli0Z8UPaviVPsDndooeoETQib+l3d3kCjxBNmKFTvjf7AuPhj4Y3m2FNfCYxdla3v
         NEw/gmfw==
Subject: Re: [PATCH] vfio: Remove VFIO_TYPE1_NESTING_IOMMU
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Zhangfei Gao <zhangfei.gao@linaro.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Vivek Kumar Gautam <Vivek.Gautam@arm.com>,
        iommu@lists.linux-foundation.org,
        Robin Murphy <robin.murphy@arm.com>,
        linux-arm-kernel@lists.infradead.org
References: <0-v1-0093c9b0e345+19-vfio_no_nesting_jgg@nvidia.com>
 <0e2f7cb8-f0d9-8209-6bc2-ca87fff57f1f@arm.com>
 <20220510181327.GM49344@nvidia.com>
 <6c6f3ecb-6339-4093-a15a-fcf95a7c61fb@linaro.org>
 <20220512113241.GQ49344@nvidia.com>
 <tencent_64CD1D42838611CFDB6E6A224DF469C10D08@qq.com>
 <20220512115906.GX49344@nvidia.com>
From:   "zhangfei.gao@foxmail.com" <zhangfei.gao@foxmail.com>
X-OQ-MSGID: <9ad4bddb-bd5d-9fbe-c2fe-fbfcc9b0b170@foxmail.com>
Date:   Thu, 12 May 2022 20:07:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220512115906.GX49344@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=0.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,HELO_DYNAMIC_IPADDR,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2022/5/12 下午7:59, Jason Gunthorpe wrote:
> On Thu, May 12, 2022 at 07:57:26PM +0800, zhangfei.gao@foxmail.com wrote:
>>
>> On 2022/5/12 下午7:32, Jason Gunthorpe via iommu wrote:
>>> On Thu, May 12, 2022 at 03:07:09PM +0800, Zhangfei Gao wrote:
>>>>>> I can't help feeling a little wary about removing this until IOMMUFD
>>>>>> can actually offer a functional replacement - is it in the way of
>>>>>> anything upcoming?
>>>>>    From an upstream perspective if someone has a patched kernel to
>>>>> complete the feature, then they can patch this part in as well, we
>>>>> should not carry dead code like this in the kernel and in the uapi.
>>>>>
>>>>> It is not directly in the way, but this needs to get done at some
>>>>> point, I'd rather just get it out of the way.
>>>> We are using this interface for nested mode.
>>> How are you using it? It doesn't do anything. Do you have out of tree
>>> patches as well?
>> Yes, there are some patches out of tree, since they are pending for almost
>> one year.
>>
>> By the way, I am trying to test nesting mode based on iommufd, still
>> requires iommu_enable_nesting,
>> which is removed in this patch as well.
> This is temporary.
>
>> So can we wait for alternative patch then remove them?
> Do you see a problem with patching this along with all the other
> patches you need?
Not yet.

Currently I am using two workarounds, but it can simply work.

1. Hard code to to enable nesting mode, both in kernel and qemu.
Will consider then.

2. Adding VFIOIOASHwpt *hwpt in VFIOIOMMUFDContainer.
And save hwpt when vfio_device_attach_container.

While currently VFIOIOMMUFDContainer has hwpt_list now.
Have asked Yi in another mail.

Thanks



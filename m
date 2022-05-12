Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4B4524C36
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 13:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353472AbiELL5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 07:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344488AbiELL5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 07:57:37 -0400
Received: from out203-205-221-239.mail.qq.com (out203-205-221-239.mail.qq.com [203.205.221.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622A96C569
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 04:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1652356651;
        bh=iY2yJcOLbtsYvLDgfwb1awyh7iPMEY/G3mZOTKxuvSo=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=h5YTEOcUp/cSeBcfW5vICGhwBpZ8fQWphC8O8CNtbO6yCuBJ1TBmABfyA9bfaDlNO
         cskk+Ind6Zj+EED2dxH38Foe6ykWMiAp5rbv9CD2aBmrI/Zo6RcxppLcP59K3TdheD
         mD+Jn+oV3m6hJR70qm6ZHTkO1XMbthvgidLV4dHc=
Received: from [192.168.0.110] ([36.57.146.152])
        by newxmesmtplogicsvrszc8.qq.com (NewEsmtp) with SMTP
        id E5B18659; Thu, 12 May 2022 19:57:27 +0800
X-QQ-mid: xmsmtpt1652356647tckuvhfck
Message-ID: <tencent_64CD1D42838611CFDB6E6A224DF469C10D08@qq.com>
X-QQ-XMAILINFO: N7h1OCCDntujtdw9xm6YqEJCpuOaHp7geMFL7LuaYCdhh86xQ58E5X0S1COleI
         g6J2yMjukbzR7JdZZ6k88mMftRMWnk0gNotf4G9j+N74QRTYmvn4aiiu91evfDmELV2wtPr7IXqd
         Rn6M0R34PwYUxJELpiqjxc1hUot8ADAMJKK5sNSyFWrN33Q33MbSSsUL9zOtVPddDSX3+vrjttoI
         I/fvLzR1puBh5l24yT72z4GvroL1LNrNj3ylsuJp7R6RrPdhvDlexxyoGL5kZb/vgq+n25O/BJn3
         TdES50w336OX53XHuIr89wNpX0gJlv4A4vI8z5Wq8z4SfLaB6WX2siyKI+4RdTmsxcP0P6qTsYxF
         uj/zShH4mLFDxwRc5zI4dXvhxUkB9+SEBdZ2XTkVEGeopZRFwiSpc2wMT+mudDbAgigFD/gbKMhr
         F1n0zENLia7unuI9lC58b9fbEAN9PjtlWKObcIF4FVVAKPwkc5Nz8FwJvsyWaOtcao8dFoEMKeMo
         7FsmA+6JodrlKGxQRixF8evrN30lbm3aNHb2n+6Kbk106J3QRybFlRcMsWaC3nMrj4+ROfwbTRhl
         ObNlAzR2RSm42de5O0zL52a58Z+Gk7zif3KalKCR05GmCIw8oO//SzpHuv+cSGHvJfUPWJBO1hRo
         QMWAxbYot9O8LG0JjO/b+n5sQS/N0WsJINq93VT6EeX0+hP9mPchs22cjH8wEakkKFeXSbDtNKXi
         hB+CPqa9FjGmHezgb3AD3U7Z4xDBRVBfmqyMSrvOESg4mCFdRyIxYf2Pp4aGx3A/MLfGDEuD6ELY
         vPZQNbwmknt7373yOoVGtRPuVkYu3PbWISa8vNSNTecBUiKNts1q4NdUoTdUSHPL0fEjml42DWgf
         Gi4TguWS5OzOmkvPGMivPNVShZxwaNNtFUfdXRjcuTFPw1MoX3czmflR+hq1h/12O8+eq6vy2XZo
         /NE/4UcMFQ6e2dpm8l1Q==
Subject: Re: [PATCH] vfio: Remove VFIO_TYPE1_NESTING_IOMMU
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
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
From:   "zhangfei.gao@foxmail.com" <zhangfei.gao@foxmail.com>
X-OQ-MSGID: <95041b28-c676-4063-9a85-838f1b971b98@foxmail.com>
Date:   Thu, 12 May 2022 19:57:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220512113241.GQ49344@nvidia.com>
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



On 2022/5/12 下午7:32, Jason Gunthorpe via iommu wrote:
> On Thu, May 12, 2022 at 03:07:09PM +0800, Zhangfei Gao wrote:
>>>> I can't help feeling a little wary about removing this until IOMMUFD
>>>> can actually offer a functional replacement - is it in the way of
>>>> anything upcoming?
>>>   From an upstream perspective if someone has a patched kernel to
>>> complete the feature, then they can patch this part in as well, we
>>> should not carry dead code like this in the kernel and in the uapi.
>>>
>>> It is not directly in the way, but this needs to get done at some
>>> point, I'd rather just get it out of the way.
>> We are using this interface for nested mode.
> How are you using it? It doesn't do anything. Do you have out of tree
> patches as well?

Yes, there are some patches out of tree, since they are pending for 
almost one year.

By the way, I am trying to test nesting mode based on iommufd, still 
requires iommu_enable_nesting,
which is removed in this patch as well.

So can we wait for alternative patch then remove them?

Thanks



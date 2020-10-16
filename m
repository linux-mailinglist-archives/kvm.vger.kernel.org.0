Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4C0290231
	for <lists+kvm@lfdr.de>; Fri, 16 Oct 2020 11:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406387AbgJPJtG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Oct 2020 05:49:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39779 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405433AbgJPJtG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Oct 2020 05:49:06 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kTMMB-00054p-U9; Fri, 16 Oct 2020 09:49:03 +0000
Subject: Re: [PATCH] vfio/fsl-mc: fix the return of the uninitialized variable
 ret
To:     Diana Craciun OSS <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201015122226.485911-1-colin.king@canonical.com>
 <20201015125211.3ff46dc1@w520.home>
 <65c7ffdb-fa92-102d-d7d1-29bb7d39fcb7@oss.nxp.com>
From:   Colin Ian King <colin.king@canonical.com>
Message-ID: <556df27a-d4aa-ccbf-7559-52b7c0e05c0f@canonical.com>
Date:   Fri, 16 Oct 2020 10:49:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <65c7ffdb-fa92-102d-d7d1-29bb7d39fcb7@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/2020 10:26, Diana Craciun OSS wrote:
> On 10/15/2020 9:52 PM, Alex Williamson wrote:
>> On Thu, 15 Oct 2020 13:22:26 +0100
>> Colin King <colin.king@canonical.com> wrote:
>>
>>> From: Colin Ian King <colin.king@canonical.com>
>>>
>>> Currently the success path in function vfio_fsl_mc_reflck_attach is
>>> returning an uninitialized value in variable ret. Fix this by setting
>>> this to zero to indicate success.
>>>
>>> Addresses-Coverity: ("Uninitialized scalar variable")
>>> Fixes: f2ba7e8c947b ("vfio/fsl-mc: Added lock support in preparation
>>> for interrupt handling")
>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>>> ---
>>>   drivers/vfio/fsl-mc/vfio_fsl_mc.c | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>>> b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>>> index 80fc7f4ed343..42a5decb78d1 100644
>>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>>> @@ -84,6 +84,7 @@ static int vfio_fsl_mc_reflck_attach(struct
>>> vfio_fsl_mc_device *vdev)
>>>           vfio_fsl_mc_reflck_get(cont_vdev->reflck);
>>>           vdev->reflck = cont_vdev->reflck;
>>>           vfio_device_put(device);
>>> +        ret = 0;
>>>       }
>>>     unlock:
>>
>> Looks correct to me, unless Diana would rather set the initial value to
>> zero instead.  Thanks,
>>
>> Alex
>>
> 
> 
> I prefer to initialize the variable to 0 when it's defined. I'll send a
> patch for it.

Yep, works for me.

> 
> Thanks,
> Diana


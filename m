Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59A79595EB4
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 17:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236082AbiHPPCz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 11:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236050AbiHPPCi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 11:02:38 -0400
Received: from smtp.smtpout.orange.fr (smtp04.smtpout.orange.fr [80.12.242.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB0B6E2D3
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 08:00:56 -0700 (PDT)
Received: from [192.168.1.18] ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id Ny3mo4Dd75V1hNy3moN0rt; Tue, 16 Aug 2022 17:00:51 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 16 Aug 2022 17:00:51 +0200
X-ME-IP: 90.11.190.129
Message-ID: <db505c50-e855-5e94-1f09-173310177bda@wanadoo.fr>
Date:   Tue, 16 Aug 2022 17:00:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] vfio/fsl-mc: Fix a typo in a comment
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        kvm@vger.kernel.org
References: <2b65bf8d2b4d940cafbafcede07c23c35f042f5a.1659815764.git.christophe.jaillet@wanadoo.fr>
 <YvKJTKYv2htxM1n/@ziepe.ca>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <YvKJTKYv2htxM1n/@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Le 09/08/2022 à 18:20, Jason Gunthorpe a écrit :
> On Sat, Aug 06, 2022 at 09:56:13PM +0200, Christophe JAILLET wrote:
>> L and S are swapped/
>> s/VFIO_FLS_MC/VFIO_FSL_MC/
>>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>> All the dev_ logging functions in the file have the "VFIO_FSL_MC: "
>> prefix.
>> As they are dev_ function, the driver should already be displayed.
>>
>> So, does it make sense or could they be all removed?
>> ---
>>   drivers/vfio/fsl-mc/vfio_fsl_mc.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> index 3feff729f3ce..66d01db1d240 100644
>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> @@ -110,7 +110,7 @@ static void vfio_fsl_mc_close_device(struct vfio_device *core_vdev)
>>   
>>   	if (WARN_ON(ret))
>>   		dev_warn(&mc_cont->dev,
>> -			 "VFIO_FLS_MC: reset device has failed (%d)\n", ret);
>> +			 "VFIO_FSL_MC: reset device has failed (%d)\n", ret);
> 
> WARN_ON already prints, this is better written as
> 
> WARN(ret, "VFIO_FSL_MC: reset device has failed (%d)\n", ret);

Or maybe, just:
if (ret)
	dev_warn(&mc_cont->dev,
		 "VFIO_FSL_MC: reset device has failed (%d)\n", ret);

This keep information about the device, avoid the duplicate printing 
related to WARN_ON+dev_warn and is more in line with error handling in 
other files.

Do you agree or do you prefer a v2 as you proposed with WARN()?

CJ


> 
> Jason
> 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F191174BC
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 19:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfLISnt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 13:43:49 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5028 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbfLISnr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Dec 2019 13:43:47 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dee95dd0000>; Mon, 09 Dec 2019 10:43:41 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 09 Dec 2019 10:43:46 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 09 Dec 2019 10:43:46 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 9 Dec
 2019 18:43:46 +0000
Received: from [10.40.101.166] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 9 Dec 2019
 18:43:43 +0000
Subject: Re: [PATCH v3 11/12] samples: vfio-mdev: constify fb ops
To:     Jani Nikula <jani.nikula@intel.com>,
        <dri-devel@lists.freedesktop.org>, <linux-fbdev@vger.kernel.org>
CC:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        <intel-gfx@lists.freedesktop.org>, <kvm@vger.kernel.org>
References: <cover.1575390740.git.jani.nikula@intel.com>
 <ddb10df1316ef585930cda7718643a580f4fe37b.1575390741.git.jani.nikula@intel.com>
 <87tv694myu.fsf@intel.com>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <0d5434e0-3d86-bbb8-6377-94e00b4f0d78@nvidia.com>
Date:   Tue, 10 Dec 2019 00:13:39 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <87tv694myu.fsf@intel.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1575917021; bh=/7RvFJCUG4iQV+IDvVpbMgXKzJOkAMSMaevIPIjioqo=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Y6wZDvVdMVatstmzKu5SutbP2nXXb/rNT7RvDQBaUBpwel/Ppk8RHXTPSUsY2JLEI
         GPHAGnnjRUNVizRoR8Bik/EAkJv1xkvimXAesz8C2O1+4klexm8wQ8Z8yaXj+b1rRe
         c2DJ3atEyFticNm2EfmFogYLEVO30JoyzqWFA7g/xLNwAFICp1XbuysYXsrFqTTaIe
         WnmR99W4Z45WDhf3Hm7c8UcaSe8GU3sTXSiKOMqsR9q0oM/QX/Xk7J1NroSifpKyH4
         6zfoBCmb1xYefKzninwV27B8XFwLuBGgpIkFtsmaBxU/k/iDVguLzezRXylNSPloeg
         F1vJUI8bn7FaQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/9/2019 7:31 PM, Jani Nikula wrote:
> On Tue, 03 Dec 2019, Jani Nikula <jani.nikula@intel.com> wrote:
>> Now that the fbops member of struct fb_info is const, we can start
>> making the ops const as well.
>>
>> v2: fix	typo (Christophe de Dinechin)
>>
>> Cc: Kirti Wankhede <kwankhede@nvidia.com>
>> Cc: kvm@vger.kernel.org
>> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> 
> Kirti, may I have your ack to merge this through drm-misc please?
> 
> BR,
> Jani.
> 
>> ---
>>   samples/vfio-mdev/mdpy-fb.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
>> index 2719bb259653..21dbf63d6e41 100644
>> --- a/samples/vfio-mdev/mdpy-fb.c
>> +++ b/samples/vfio-mdev/mdpy-fb.c
>> @@ -86,7 +86,7 @@ static void mdpy_fb_destroy(struct fb_info *info)
>>   		iounmap(info->screen_base);
>>   }
>>   
>> -static struct fb_ops mdpy_fb_ops = {
>> +static const struct fb_ops mdpy_fb_ops = {
>>   	.owner		= THIS_MODULE,
>>   	.fb_destroy	= mdpy_fb_destroy,
>>   	.fb_setcolreg	= mdpy_fb_setcolreg,
> 

Acked-by : Kirti Wankhede <kwankhede@nvidia.com>


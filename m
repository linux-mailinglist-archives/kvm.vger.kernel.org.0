Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 650A810C6CB
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 11:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfK1Kff (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 05:35:35 -0500
Received: from mga14.intel.com ([192.55.52.115]:39823 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbfK1Kff (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 05:35:35 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Nov 2019 02:35:35 -0800
X-IronPort-AV: E=Sophos;i="5.69,253,1571727600"; 
   d="scan'208";a="199487561"
Received: from jnikula-mobl3.fi.intel.com (HELO localhost) ([10.237.66.161])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Nov 2019 02:35:32 -0800
From:   Jani Nikula <jani.nikula@intel.com>
To:     Christophe de Dinechin <christophe.de.dinechin@gmail.com>
Cc:     linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        ville.syrjala@linux.intel.com, intel-gfx@lists.freedesktop.org,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 13/13] samples: vfio-mdev: constify fb ops
In-Reply-To: <39B62C70-3E60-48AB-8F11-534EF5B8EFBD@dinechin.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <cover.1574871797.git.jani.nikula@intel.com> <fc8342eef9fcd2f55c86fcd78f7df52f7c76fa87.1574871797.git.jani.nikula@intel.com> <39B62C70-3E60-48AB-8F11-534EF5B8EFBD@dinechin.org>
Date:   Thu, 28 Nov 2019 12:35:29 +0200
Message-ID: <87y2w0mgpa.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 28 Nov 2019, Christophe de Dinechin <christophe.de.dinechin@gmail.com> wrote:
>> On 27 Nov 2019, at 17:32, Jani Nikula <jani.nikula@intel.com> wrote:
>> 
>> Now that the fbops member of struct fb_info is const, we can star making
> s/star/start/

Ooops, thanks.

BR,
Jani.

>
>> the ops const as well.
>> 
>> Cc: Kirti Wankhede <kwankhede@nvidia.com>
>> Cc: kvm@vger.kernel.org
>> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
>> ---
>> samples/vfio-mdev/mdpy-fb.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
>> index 2719bb259653..21dbf63d6e41 100644
>> --- a/samples/vfio-mdev/mdpy-fb.c
>> +++ b/samples/vfio-mdev/mdpy-fb.c
>> @@ -86,7 +86,7 @@ static void mdpy_fb_destroy(struct fb_info *info)
>> 		iounmap(info->screen_base);
>> }
>> 
>> -static struct fb_ops mdpy_fb_ops = {
>> +static const struct fb_ops mdpy_fb_ops = {
>> 	.owner		= THIS_MODULE,
>> 	.fb_destroy	= mdpy_fb_destroy,
>> 	.fb_setcolreg	= mdpy_fb_setcolreg,
>> -- 
>> 2.20.1
>> 
>

-- 
Jani Nikula, Intel Open Source Graphics Center

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D201180D3
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 07:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbfLJGxO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 01:53:14 -0500
Received: from mga12.intel.com ([192.55.52.136]:17562 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbfLJGxO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 01:53:14 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Dec 2019 22:53:14 -0800
X-IronPort-AV: E=Sophos;i="5.69,298,1571727600"; 
   d="scan'208";a="203087366"
Received: from wwisnei1-mobl.ger.corp.intel.com (HELO localhost) ([10.249.33.29])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Dec 2019 22:53:11 -0800
From:   Jani Nikula <jani.nikula@intel.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 11/12] samples: vfio-mdev: constify fb ops
In-Reply-To: <0d5434e0-3d86-bbb8-6377-94e00b4f0d78@nvidia.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <cover.1575390740.git.jani.nikula@intel.com> <ddb10df1316ef585930cda7718643a580f4fe37b.1575390741.git.jani.nikula@intel.com> <87tv694myu.fsf@intel.com> <0d5434e0-3d86-bbb8-6377-94e00b4f0d78@nvidia.com>
Date:   Tue, 10 Dec 2019 08:53:15 +0200
Message-ID: <87wob4vfhg.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 10 Dec 2019, Kirti Wankhede <kwankhede@nvidia.com> wrote:
> On 12/9/2019 7:31 PM, Jani Nikula wrote:
>> On Tue, 03 Dec 2019, Jani Nikula <jani.nikula@intel.com> wrote:
>>> Now that the fbops member of struct fb_info is const, we can start
>>> making the ops const as well.
>>>
>>> v2: fix	typo (Christophe de Dinechin)
>>>
>>> Cc: Kirti Wankhede <kwankhede@nvidia.com>
>>> Cc: kvm@vger.kernel.org
>>> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>>> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
>> 
>> Kirti, may I have your ack to merge this through drm-misc please?
>> 
>> BR,
>> Jani.
>> 
>>> ---
>>>   samples/vfio-mdev/mdpy-fb.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
>>> index 2719bb259653..21dbf63d6e41 100644
>>> --- a/samples/vfio-mdev/mdpy-fb.c
>>> +++ b/samples/vfio-mdev/mdpy-fb.c
>>> @@ -86,7 +86,7 @@ static void mdpy_fb_destroy(struct fb_info *info)
>>>   		iounmap(info->screen_base);
>>>   }
>>>   
>>> -static struct fb_ops mdpy_fb_ops = {
>>> +static const struct fb_ops mdpy_fb_ops = {
>>>   	.owner		= THIS_MODULE,
>>>   	.fb_destroy	= mdpy_fb_destroy,
>>>   	.fb_setcolreg	= mdpy_fb_setcolreg,
>> 
>
> Acked-by : Kirti Wankhede <kwankhede@nvidia.com>

Thanks, pushed to drm-misc-next.

BR,
Jani.

-- 
Jani Nikula, Intel Open Source Graphics Center

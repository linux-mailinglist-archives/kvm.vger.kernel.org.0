Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2CD8783BED
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 10:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbjHVIkJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 04:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbjHVIkI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 04:40:08 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997C01AD
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 01:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692693606; x=1724229606;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ltuVfD5B/jcuWstVoucBhzIjKV7eNN6MJ29Zqp3U/m8=;
  b=YnEZ1qpTwMKIX7iPP2633ps6NepMFtX5Yk7ychwr6K1k+eIrvFkdGp5Q
   ljAICb+w/xNWzkEvVcFiJpg1naclO6GmrfXRRdiiMJiT0qoGNPBqWRw4r
   i0coBr5qXoKbtO9uxVK0nB8DBZmHBq0YwElHZcIrR5KxNv9O3sC+Dm1Qu
   +lRl8aAtkSW7A7WRCeO2+7OQbJ5rID0SL5G7Dj8dI7PQqK7wGUyUmEJ39
   LxTnlWP4klVT8hdiSbCkcgg3U4ZLebXYxUiabZXzkKoEp0QNPkb1lrR1u
   MmKvZghZxbMiKEdo04OJ1sp5iDEKGtorzIEeb1lsqUiMQNoS71JLz3HgW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="354157021"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="354157021"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 01:40:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="826246817"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="826246817"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 01:40:00 -0700
Message-ID: <8a44f4fc-edd7-c547-c451-917a964027d5@intel.com>
Date:   Tue, 22 Aug 2023 16:39:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.14.0
Subject: Re: [PATCH v2 15/58] i386/tdx: Add property sept-ve-disable for
 tdx-guest object
Content-Language: en-US
To:     Markus Armbruster <armbru@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-16-xiaoyao.li@intel.com>
 <ZOMnf8n8BksktlGg@redhat.com> <877cpn7ft7.fsf@pond.sub.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <877cpn7ft7.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/22/2023 2:27 PM, Markus Armbruster wrote:
> Daniel P. Berrangé <berrange@redhat.com> writes:
> 
>> On Fri, Aug 18, 2023 at 05:49:58AM -0400, Xiaoyao Li wrote:
>>> Bit 28 of TD attribute, named SEPT_VE_DISABLE. When set to 1, it disables
>>> EPT violation conversion to #VE on guest TD access of PENDING pages.
>>>
>>> Some guest OS (e.g., Linux TD guest) may require this bit as 1.
>>> Otherwise refuse to boot.
>>>
>>> Add sept-ve-disable property for tdx-guest object, for user to configure
>>> this bit.
>>>
>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
>>> ---
>>>   qapi/qom.json         |  4 +++-
>>>   target/i386/kvm/tdx.c | 24 ++++++++++++++++++++++++
>>>   2 files changed, 27 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/qapi/qom.json b/qapi/qom.json
>>> index 2ca7ce7c0da5..cc08b9a98df9 100644
>>> --- a/qapi/qom.json
>>> +++ b/qapi/qom.json
>>> @@ -871,10 +871,12 @@
>>>   #
>>>   # Properties for tdx-guest objects.
>>>   #
>>> +# @sept-ve-disable: bit 28 of TD attributes (default: 0)
>>
>> This description isn't very useful as it forces the user to go off and
>> read the TDX specification to find out what bit 28 means. You've got a
> 
> Seconded.
> 
>> more useful description in the commit message, so please use that
>> in the docs too. eg something like this
>>
>>    @sept-ve-disable: toggle bit 28 of TD attributes to control disabling
>>                      of EPT violation conversion to #VE on guest
>>                      TD access of PENDING pages. Some guest OS (e.g.
>>                      Linux TD guest) may require this set, otherwise
>>                      they refuse to boot.
> 
> But please format like
> 
> # @sept-ve-disable: toggle bit 28 of TD attributes to control disabling
> #     of EPT violation conversion to #VE on guest TD access of PENDING
> #     pages.  Some guest OS (e.g. Linux TD guest) may require this to
> #     be set, otherwise they refuse to boot.
>

Thank you, Daniel and Markus.

Will use above in the next version.

> to blend in with recent commit a937b6aa739 (qapi: Reformat doc comments
> to conform to current conventions).
>
>>> +#
>>>   # Since: 8.2
>>>   ##
>>>   { 'struct': 'TdxGuestProperties',
>>> -  'data': { }}
>>> +  'data': { '*sept-ve-disable': 'bool' } }
>>>   
>>>   ##
>>>   # @ThreadContextProperties:
> 
> [...]
> 


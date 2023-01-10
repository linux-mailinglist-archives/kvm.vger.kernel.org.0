Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3A36645F8
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 17:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234719AbjAJQZv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 11:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238618AbjAJQZo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 11:25:44 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F549BC0D;
        Tue, 10 Jan 2023 08:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673367943; x=1704903943;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eJNdrQV4oRElpWQ+CG8bXg+giTuMt6NAEdhJm7LZmYo=;
  b=AV2gHCKL6SKKyaQZz7ho1hV9a2PLranfPN/0BVG2UqHPZFoGY7RpIKvO
   QH5Ejz5v9F72x4TyapvanzmWjMMmdWHwfE5pIlxYApv4bJSgkqcyl4L5p
   PCnZv6QHZBAypeLRA0QyKjoSFSvIRgHPaQ4epcp8j/o4gQiFrBS+gCfYi
   T180ZWSKzRLL7v7b+1IBhUCn4Jv689+IVSMdn0d9RPLoc7z71u14FldtZ
   YIvBVV/asZ6HKPl3SsSw0N4f93QXN0MoOgOEUX6+xDDG7A88w3YUP8b4u
   Yfl+RNURxEoLU1yTnwuiKjmYWT4V6UPv/P0KjeCXKzusNxDxnf+qUnel3
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="302890704"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="302890704"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 08:25:43 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="607011593"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="607011593"
Received: from svenka7-mobl1.amr.corp.intel.com (HELO [10.209.63.27]) ([10.209.63.27])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 08:25:42 -0800
Message-ID: <755f94aa-a0cc-b7d6-ce8a-a81ff4f598da@intel.com>
Date:   Tue, 10 Jan 2023 08:25:42 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 12/16] x86/virt/tdx: Designate the global KeyID and
 configure the TDX module
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
 <d7b01f396908da796644e58298a34c1f8a140be7.1670566861.git.kai.huang@intel.com>
 <e1a55f50-efc0-5098-1a2d-f0eaa0b51a82@intel.com>
 <748adb0e8df5f804371f0587ed8fef1184177484.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <748adb0e8df5f804371f0587ed8fef1184177484.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/10/23 02:48, Huang, Kai wrote:
>>>
>>> +   /*
>>> +    * Use the first private KeyID as the global KeyID, and pass
>>> +    * it along with the TDMRs to the TDX module.
>>> +    */
>>> +   ret = config_tdx_module(&tdmr_list, tdx_keyid_start);
>>> +   if (ret)
>>> +           goto out_free_pamts;
>> This is "consuming" tdx_keyid_start.  Does it need to get incremented
>> since the first guest can't use this KeyID now?
> 
> It depends on how we treat 'tdx_keyid_start'.  If it means the first _usable_
> KeyID for KVM, then we should increase it; but if it only used for the hardware-
> enabled TDX KeyID range, then we don't need to increase it.
> 
> Currently it is marked as __ro_after_init so my intention is the latter (also in
> the spirit of keeping this series minimal).
> 
> Eventually we will need to have functions to allocate/free TDX KeyIDs anyway for
> KVM, but in that we can just treat 'tdx_keyid_start + 1' as the first usable
> KeyID.

So, basically, you're going to depend on the KVM code (which isn't in
this series) to magically know exactly what this series did?  Then,
you're expecting that this code will never change in a way that breaks
this random KVM code?

That's frankly awful.

Make the variable read/write.  Call it tdx_guest_keyid_start, and
increment it when you make a keyid unavailable for guest use.



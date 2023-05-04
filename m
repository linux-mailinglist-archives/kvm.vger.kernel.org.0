Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85C9A6F6FDE
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 18:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjEDQXC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 12:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjEDQXB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 12:23:01 -0400
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CE3118;
        Thu,  4 May 2023 09:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1683217380; x=1714753380;
  h=message-id:date:mime-version:to:cc:references:from:
   in-reply-to:content-transfer-encoding:subject;
  bh=OHZM3IjlEx2Y7gvAnJLm0b8ngkDus8a8QUl4V1D7ODQ=;
  b=pUqx7f1QlBObv2zJEYDosfLaGg4toa4Yz+KDNFaL54YbwgOOBjLrDttj
   7aWYEZuXGr5+3eW0567Y1x72JG3C1ks3o776XV1wcOD/rUvJ/gIsR1j07
   ajClhXGwHE5e09FHG2zwt0drnLxIsqk/pxcVEcF4eyBJsXkhORY250wMi
   4=;
X-IronPort-AV: E=Sophos;i="5.99,249,1677542400"; 
   d="scan'208";a="1092620"
Subject: Re: [PATCH 0/9] KVM backports to 5.10
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-1box-2bm6-32cf6363.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2023 16:23:00 +0000
Received: from EX19MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-1box-2bm6-32cf6363.us-west-2.amazon.com (Postfix) with ESMTPS id 787D481BD3;
        Thu,  4 May 2023 16:22:59 +0000 (UTC)
Received: from EX19D002UWC004.ant.amazon.com (10.13.138.186) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Thu, 4 May 2023 16:22:57 +0000
Received: from [10.88.145.215] (10.88.145.215) by
 EX19D002UWC004.ant.amazon.com (10.13.138.186) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.26;
 Thu, 4 May 2023 16:22:56 +0000
Message-ID: <d34e0096-7f9e-528e-cbdd-786491fad518@amazon.com>
Date:   Thu, 4 May 2023 09:22:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Lee Jones <lee@kernel.org>
CC:     Sean Christopherson <seanjc@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        "Mike Bacco" <mbacco@amazon.com>, "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>, <kvm@vger.kernel.org>
References: <20220909185557.21255-1-risbhat@amazon.com>
 <A0B41A72-984A-4984-81F3-B512DFF92F59@amazon.com>
 <YynoDtKjvDx0vlOR@kroah.com> <YyrSKtN2VqnAuevk@kroah.com>
 <20230419071711.GA493399@google.com> <ZFFt/ZMqQ1RHnY4e@google.com>
 <20230503073433.GM620451@google.com>
 <2023050446-bulginess-skinny-dd06@gregkh>
Content-Language: en-US
From:   "Bhatnagar, Rishabh" <risbhat@amazon.com>
In-Reply-To: <2023050446-bulginess-skinny-dd06@gregkh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.88.145.215]
X-ClientProxiedBy: EX19D035UWB001.ant.amazon.com (10.13.138.33) To
 EX19D002UWC004.ant.amazon.com (10.13.138.186)
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/3/23 6:10 PM, gregkh@linuxfoundation.org wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>
>
>
> On Wed, May 03, 2023 at 08:34:33AM +0100, Lee Jones wrote:
>> On Tue, 02 May 2023, Sean Christopherson wrote:
>>
>>> On Wed, Apr 19, 2023, Lee Jones wrote:
>>>> On Wed, 21 Sep 2022, gregkh@linuxfoundation.org wrote:
>>>>
>>>>> On Tue, Sep 20, 2022 at 06:19:26PM +0200, gregkh@linuxfoundation.org wrote:
>>>>>> On Tue, Sep 20, 2022 at 03:34:04PM +0000, Bhatnagar, Rishabh wrote:
>>>>>>> Gentle reminder to review this patch series.
>>>>>> Gentle reminder to never top-post :)
>>>>>>
>>>>>> Also, it's up to the KVM maintainers if they wish to review this or not.
>>>>>> I can't make them care about old and obsolete kernels like 5.10.y.  Why
>>>>>> not just use 5.15.y or newer?
>>>>> Given the lack of responses here from the KVM developers, I'll drop this
>>>>> from my mbox and wait for them to be properly reviewed and resend before
>>>>> considering them for a stable release.
>>>> KVM maintainers,
>>>>
>>>> Would someone be kind enough to take a look at this for Greg please?
>>>>
>>>> Note that at least one of the patches in this set has been identified as
>>>> a fix for a serious security issue regarding the compromise of guest
>>>> kernels due to the mishandling of flush operations.
>>> A minor note, the security issue is serious _if_ the bug can be exploited, which
>>> as is often the case for KVM, is a fairly big "if".  Jann's PoC relied on collusion
>>> between host userspace and the guest kernel, and as Jann called out, triggering
>>> the bug on a !PREEMPT host kernel would be quite difficult in practice.
>>>
>>> I don't want to downplay the seriousness of compromising guest security, but CVSS
>>> scores for KVM CVEs almost always fail to account for the multitude of factors in
>>> play.  E.g. CVE-2023-30456 also had a score of 7.8, and that bug required disabling
>>> EPT, which pretty much no one does when running untrusted guest code.
>>>
>>> In other words, take the purported severity with a grain of salt.
>>>
>>>> Please could someone confirm or otherwise that this is relevant for
>>>> v5.10.y and older?
>>> Acked-by: Sean Christopherson <seanjc@google.com>
>> Thanks for taking the time to provide some background information and
>> for the Ack Sean, much appreciated.
>>
>> For anyone taking notice, I expect a little lag on this still whilst
>> Greg is AFK.  I'll follow-up in a few days.
> What am I supposed to do here?  The thread is long-gone from my stable
> review queue, is there some patch I'm supposed to apply?  If so, can I
> get a resend with the proper acks added?
>
> thanks,
>
> greg k-h

Yeah its been half a year since i sent this series and i had mostly 
forgotten about this.
Sure i can resend a new version with acks/tested-by added.

Thanks
Rishabh


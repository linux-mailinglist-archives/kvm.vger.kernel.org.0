Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9414E725EE8
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 14:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240702AbjFGMV1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 08:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240701AbjFGMVO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 08:21:14 -0400
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1241BFD;
        Wed,  7 Jun 2023 05:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.es; i=@amazon.es; q=dns/txt; s=amazon201209;
  t=1686140471; x=1717676471;
  h=message-id:date:mime-version:to:cc:references:from:
   in-reply-to:content-transfer-encoding:subject;
  bh=H+lCeGmcbHRGOxfwB4VQbIsL3x2USb4Et2eGWZ5GoBY=;
  b=fM9M0cg/ohiKDT37b5MwJUJ/LqolH4qoq2rL904eo35BAu23WD5yiE5c
   pQ1YRJBthnspYO4l/EMV86kG9iAjfUFzrqSKiIFjB0z+kU/BZDbBXPbVI
   mYpgau7uEEy4u87LRgFZZ5PeJABgySKpQLgUsAvV2WJSfJPb64MPY3Q0+
   s=;
X-IronPort-AV: E=Sophos;i="6.00,224,1681171200"; 
   d="scan'208";a="8708734"
Subject: Re: [ANNOUNCE] KVM Microconference at LPC 2023
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-00fceed5.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 12:21:08 +0000
Received: from EX19D013EUA003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-00fceed5.us-east-1.amazon.com (Postfix) with ESMTPS id AAD46A2A8C;
        Wed,  7 Jun 2023 12:21:05 +0000 (UTC)
Received: from EX19D037EUB003.ant.amazon.com (10.252.61.119) by
 EX19D013EUA003.ant.amazon.com (10.252.50.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 7 Jun 2023 12:21:05 +0000
Received: from [192.168.30.121] (10.1.212.27) by EX19D037EUB003.ant.amazon.com
 (10.252.61.119) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.26; Wed, 7 Jun
 2023 12:21:02 +0000
Message-ID: <ce7689c9-1c23-68ff-9afb-7d0aeaa9c80a@amazon.es>
Date:   Wed, 7 Jun 2023 14:20:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Alexander Graf <graf@amazon.de>,
        "Cali, Marco" <xmarcalx@amazon.co.uk>
References: <2f19f26e-20e5-8198-294e-27ea665b706f@redhat.com>
 <150e1ad0-3d59-762b-6032-897d5630a3bf@amazon.es>
 <5283b17c-185b-a37f-84e2-dcd08e042ec0@redhat.com>
From:   Babis Chalios <bchalios@amazon.es>
In-Reply-To: <5283b17c-185b-a37f-84e2-dcd08e042ec0@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.1.212.27]
X-ClientProxiedBy: EX19D039UWA002.ant.amazon.com (10.13.139.32) To
 EX19D037EUB003.ant.amazon.com (10.252.61.119)
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/6/23 12:37, Paolo Bonzini wrote:
> CAUTION: This email originated from outside of the organization. Do 
> not click links or open attachments unless you can confirm the sender 
> and know the content is safe.
>
>
>
> On 6/7/23 12:13, Babis Chalios wrote:
>>
>>
>> On our side, we 've been working on providing ways to let VMs (kernel
>>  and user space) know that they have been cloned/snapshotted/restored
>> from snapshots[1].
>>
>> This is tightly coupled with PRNGs both in kernel and user space and
>>  there needs to be some collaboration with random.c to tie everything
>> together [2][3]. It sounds like it could be a good fit for this MC
>> (?).
>
> Does the VM generation ID ACPI device from Microsoft work for you?  It
> is not tied to Hyper-V.
>
> Paolo
>

It's a long story :P

TLDR:

For some use-cases it should be enough [1]. For PRNGs though it doesn't 
seem to work as is. (1) The Linux implementation of VMGENID is racy and 
(2) last year there were long discussions related to the user-space
ABI, which diverged us away from it.

BTW, just saw that you have already submitted the proposal for the MC, 
sorry for being late :)

Cheers,
Babis

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6AAF63E6D8
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 02:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbiLABCA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 20:02:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiLABBy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 20:01:54 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015FA54451
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 17:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669856513; x=1701392513;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FHBXFstONSDDa+8sNdarc62wVjXvjgEo/4Y8sf6oJwM=;
  b=WJmAotGcG+oYAU+5KS4NbjptqpF3JYK8m7Ma70+n8bbQLcV048GckD4h
   HwLELZybgBPr8V+7vMpJyQSyZZi+EOnGUagL4S+EFJlGh1vTFFv6qHQoU
   IhiPCwAVGAXtqCjkVGoMh0b5weDtsOcsKCHHA19+/Nc2rSDMXEJH1ICj7
   q4ebMSULmWx76M5KV3WoXdcUIIlsIzKiLUXFKbaijLqvwQy93rcZZj1l5
   LuB7x9gbN5LOqCOD+W1a1Sk5lhVFQCq6g73PhFjRkge+EAoiunoQFmFIl
   80w3jz0y7uoGUS7cK5V9ZURXVNzWBsMECcsBKKNdfjIr0BmIMCSIWUdvK
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="317406806"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="317406806"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 17:01:53 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="638201778"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="638201778"
Received: from leiwang7-mobl.ccr.corp.intel.com (HELO [10.254.208.162]) ([10.254.208.162])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 17:01:52 -0800
Message-ID: <d3b4725d-cdb5-3837-c4f4-615b349e91c1@intel.com>
Date:   Thu, 1 Dec 2022 09:01:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.0
Subject: Re: [PATCH] KVM: Change non-existent ioctl comment
 "KVM_CREATE_MEMORY_REGION" to "KVM_SET_MEMORY_REGION"
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
References: <20221130064325.386359-1-lei4.wang@intel.com>
 <Y4d4gQd7cYDIjfWB@google.com>
From:   "Wang, Lei" <lei4.wang@intel.com>
In-Reply-To: <Y4d4gQd7cYDIjfWB@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/30/2022 11:36 PM, Sean Christopherson wrote:
> On Tue, Nov 29, 2022, Lei Wang wrote:
>> ioctl "KVM_CREATE_MEMORY_REGION" doesn't exist and should be
>> "KVM_SET_MEMORY_REGION", change the comment.
> 
> Heh, no need, KVM_SET_MEMORY_REGION will soon not exist either.
> 
> https://lore.kernel.org/all/Y4T+SY9SZIRFBdBM@google.com

Oh, didn't notice that, thanks!

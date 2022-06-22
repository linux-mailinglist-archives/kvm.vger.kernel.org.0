Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73D94555346
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 20:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359631AbiFVSaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 14:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiFVSaQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 14:30:16 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578A930576;
        Wed, 22 Jun 2022 11:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655922614; x=1687458614;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BRzTC2ut2r56R1WtccznIDmkHwKaDpfAh5dNdlDBT60=;
  b=jfuI3Z2USxqvHsqokQgXnZqquri8S5wGOXpEscLhErPSdNcSWYxi+heV
   qwn7EVG7oXV+TjyPL+NdEglPA8+78Yy1lGDXUpMiorIkLD2joebXydIQ/
   GI9eTTgw8rDAmHRA4TB4IEO5OHJR5kiz7RxSwQsPl1QCH6YNzoKLmmpAU
   iTq4Lvo5G6UYBpIk/yUVz+IG0GfqPXzDMi/WXcAfEvNvJuOj0AMkR+qo9
   E5D+wZOAuH11vVI3QHpIQRZHAitSO6H72RxsS6fTAlfpomA3GNKAZ6Mz9
   x4dYT8TQtp/hyBspt3RF+71FuKP8JAcIo7MJKSTrqR4q2qvq0H8oxVphK
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10386"; a="278055245"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="278055245"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 11:18:10 -0700
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="677681186"
Received: from bshakya-mobl.amr.corp.intel.com (HELO [10.212.188.76]) ([10.212.188.76])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 11:18:08 -0700
Message-ID: <681e4e45-eff1-600c-9b81-1fa9bdf24232@intel.com>
Date:   Wed, 22 Jun 2022 11:17:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH Part2 v6 05/49] x86/sev: Add RMP entry lookup helpers
Content-Language: en-US
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "slp@redhat.com" <slp@redhat.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>, "bp@alien8.de" <bp@alien8.de>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <8f63961f00fd170ba0e561f499292175f3155d26.1655761627.git.ashish.kalra@amd.com>
 <cc0c6bd1-a1e3-82ee-8148-040be21cad5c@intel.com>
 <BYAPR12MB2759A8F48D6D68EE879EEF648EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <25be3068-be13-a451-86d4-ff4cc12ddb23@intel.com>
 <BYAPR12MB27599BCEA9F692E173911C3B8EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <BYAPR12MB27599BCEA9F692E173911C3B8EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/22/22 11:15, Kalra, Ashish wrote:
> So actually this RPM entry definition is platform dependent and will
> need to be changed for different AMD processors and that change has
> to be handled correspondingly in the dump_rmpentry() code.

So, if the RMP entry format changes in future processors, how do we make
sure that the kernel does not try to use *this* code on those processors?

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 183A05156C5
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 23:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbiD2Vaj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 17:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232449AbiD2Vai (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 17:30:38 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A6C9F398;
        Fri, 29 Apr 2022 14:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651267639; x=1682803639;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iBDXurEoX+VAKyel977MnypOTEgCCqkREVmIpcHL3L8=;
  b=Yqjq1jjpBpBJCHOStlm51fzUd2zor/2geNZLJXdtcmg2gcX7F0Wig7MK
   c3V856oua/NY4tWhvndXL6ffYZhPOmHOSp2moKSSBzk+ZkjUSmA0vSU1g
   WSdlFLD3LeLOQGBtbVRudwkrnR1gYKGpAwK/voPC+Yqq90vl/BsrGtj5+
   8S8+M+U1Yw6LT1ajORiUAec6J+bLVAmYbWBvtRvJWA1tJgX/tt8+P9Rp7
   Ee8Ud40jG8U71abrhs1QIrH/lu/fU8sDOPrCwITiGLVfeZ5DH91wK9XS3
   2gj1tvzlOZP865CmtYzITIJsWtnrGBjX2XxPcakiolBelox7iLCn6SywV
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10332"; a="247333950"
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="247333950"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 14:27:00 -0700
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="582407851"
Received: from jinggu-mobl1.amr.corp.intel.com (HELO [10.212.30.227]) ([10.212.30.227])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 14:26:59 -0700
Message-ID: <915ed339-f5e6-c31f-ffe1-a80402ce78dd@intel.com>
Date:   Fri, 29 Apr 2022 14:27:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 00/21] TDX host kernel support
Content-Language: en-US
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
 <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
 <CAPcyv4g5E_TOow=3pFJXyFr=KLV9pTSnDthgz6TuXvru4xDzaQ@mail.gmail.com>
 <de9b8f4cef5da03226158492988956099199aa60.camel@intel.com>
 <CAPcyv4iGsXkHAVgf+JZ4Pah_fkCZ=VvUmj7s3C6Rkejtdw_sgQ@mail.gmail.com>
 <92af7b22-fa8a-5d42-ae15-8526abfd2622@intel.com>
 <CAPcyv4iG977DErCfYTqhVzuZqjtqFHK3smnaOpO3p+EbxfvXcQ@mail.gmail.com>
 <4a5143cc-3102-5e30-08b4-c07e44f1a2fc@intel.com>
 <CAPcyv4i6X6ODNbOnT7+NEzpicLS4m9bNDybZLvN3gqXFTTf=mg@mail.gmail.com>
 <4d0c7316-3564-ef27-1113-042019d583dc@intel.com>
 <CAPcyv4gYw3k4YMEV1E26fMx-GNCNCb+zJDERfhieCrROWv_Jxg@mail.gmail.com>
 <73ed1e55-7e7c-2995-b411-8e26b711cc22@intel.com>
 <CAPcyv4gzEvMA4F5ncuhVenRDuz7Tq6aCSJR=z7wVqNGOYGS5Kw@mail.gmail.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <CAPcyv4gzEvMA4F5ncuhVenRDuz7Tq6aCSJR=z7wVqNGOYGS5Kw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 14:20, Dan Williams wrote:
> Is there something already like this today for people that, for
> example, attempt to use PCI BAR mappings as memory? Or does KVM simply
> allow for garbage-in garbage-out?

I'm just guessing, but I _assume_ those garbage PCI BAR mappings are how
KVM does device passthrough.

I know that some KVM users even use mem= to chop down the kernel-owned
'struct page'-backed memory, then have a kind of /dev/mem driver to let
the memory get mapped back into userspace.  KVM is happy to pass through
those mappings.

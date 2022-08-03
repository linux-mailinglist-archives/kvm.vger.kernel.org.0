Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E15FB588943
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 11:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236090AbiHCJUn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 05:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234652AbiHCJUl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 05:20:41 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CB74B0ED;
        Wed,  3 Aug 2022 02:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659518440; x=1691054440;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=QdS5RtaD0CycG9Edwc4z5a24SxaDH/1WGpeoyI9KL50=;
  b=mzNn1WL8/w6ikhASdP7Vy7dYoXuUmMb2q3wbg88AofrtzxjYr/jJnjA0
   k4EBj9m3F5u/jEik5S1BsXd+wYzr4f2r9b/JhxYLCGnZOgnGJ13/AHem2
   egRVUuSLGPYC35H+cmLdgxDzTZuI1QUDp6Nrz/HGLE2ANlcdfdBhvzhvS
   83FuIre1bJIsgRDcIn9zHFL333oc95zsTkz6A3v6F+c9S8nAbFGyMQejE
   nCIbkgIWUPa+eeGKsrSypHBahtxHXxUm5aDOV+67YoaieMAQ0XOy1buNf
   SxPw7Ym7T2QG9L6WA4NGTI3JcWav+9PNCo0aMmDkLgI8ZvH8UGogPcG4e
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10427"; a="287187885"
X-IronPort-AV: E=Sophos;i="5.93,213,1654585200"; 
   d="scan'208";a="287187885"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 02:20:40 -0700
X-IronPort-AV: E=Sophos;i="5.93,213,1654585200"; 
   d="scan'208";a="602762965"
Received: from gvenka2-desk.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.85.17])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 02:20:34 -0700
Message-ID: <02f40786caee3ecf9b2bfd90c70317c282dd87e5.camel@intel.com>
Subject: Re: [PATCH v5 02/22] cc_platform: Add new attribute to prevent ACPI
 CPU hotplug
From:   Kai Huang <kai.huang@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-acpi@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, rdunlap@infradead.org, Jason@zx2c4.com,
        juri.lelli@redhat.com, mark.rutland@arm.com, frederic@kernel.org,
        yuehaibing@huawei.com, dongli.zhang@oracle.com
Date:   Wed, 03 Aug 2022 21:20:32 +1200
In-Reply-To: <041f2d03-c32f-c578-f714-5b01bb8bc46b@linux.intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <f4bff93d83814ea1f54494f51ce3e5d954cf0f5b.1655894131.git.kai.huang@intel.com>
         <43a67bfe-9707-33e0-2574-1e6eca6aa24b@intel.com>
         <5ebd7c3cfb3ab9d77a2577c4864befcffe5359d4.camel@intel.com>
         <041f2d03-c32f-c578-f714-5b01bb8bc46b@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-03 at 11:40 +0800, Binbin Wu wrote:
> host kernel is also not in TDX's TCB either, what would happen if kernel=
=20
> doesn't
> do anything in case of buggy BIOS? How does TDX handle the case to=20
> enforce the
> secure of TDs?

TDX doesn't support hot-add or hot-removal CPU from TDX' security perimeter=
 at
runtime.  Even BIOS/kernel can ever bring up new CPUs at runtime, the new C=
PUs
cannot run within TDX's security domain, in which case TDX's security isn't
compromised.  If kernel schedules a TD to a new added CPU, then AFAICT the
behaviour is TDX module implementation specific but not architectural.  A
reasonable behaviour would be the TDENTER should refuse to run when the CPU
isn't verified by TDX during boot.

If any CPU is hot-removed, then the security's TDX isn't compromised, but T=
DX is
not guaranteed to functionally work anymore.

--=20
Thanks,
-Kai



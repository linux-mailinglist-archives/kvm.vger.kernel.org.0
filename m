Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D52588947
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 11:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236021AbiHCJVn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 05:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234652AbiHCJVl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 05:21:41 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1335119C09;
        Wed,  3 Aug 2022 02:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659518501; x=1691054501;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=d6XBXtM845jMdiFmbaDR0+BJGHsJ6Jy8XevdcIT4puE=;
  b=GWCqmXghW/DiUC7ZYaUvYMJLpxmClZtNIA7gF614XWduEeWkXtNQYCev
   uPtcPezLvP3qKxAk57z7a/riGu3SA7SJlUbGCuMvyVGKcVEe6/zIrR0c/
   RlxSoGEbaH5s9XhAaBAq0VIvm8wDNVcsCdsko/BFQXG2k9D6L6Ge6nJcK
   xKuoTbyC8ASAlOk4srwedk5uZi25qSjva408RuI4C5sVzw99CKUXEUYSe
   bgWeDjY5JLkQAxsixBGocURFjaV7yPf1il+Dl6bXEldLKHEB1s0Kbk178
   VXofSPaFkISc9KFOZc5khh+V1lspdaDIZhaNIBYYOV5yfDWW4wQ2pOChA
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10427"; a="289638877"
X-IronPort-AV: E=Sophos;i="5.93,213,1654585200"; 
   d="scan'208";a="289638877"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 02:21:40 -0700
X-IronPort-AV: E=Sophos;i="5.93,213,1654585200"; 
   d="scan'208";a="553255200"
Received: from gvenka2-desk.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.85.17])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 02:21:35 -0700
Message-ID: <d3ec341c4133714f2b8541830fc9fc815c32a59f.camel@intel.com>
Subject: Re: [PATCH v5 02/22] cc_platform: Add new attribute to prevent ACPI
 CPU hotplug
From:   Kai Huang <kai.huang@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-acpi@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, rdunlap@infradead.org, Jason@zx2c4.com,
        juri.lelli@redhat.com, mark.rutland@arm.com, frederic@kernel.org,
        yuehaibing@huawei.com, dongli.zhang@oracle.com
Date:   Wed, 03 Aug 2022 21:21:33 +1200
In-Reply-To: <27de096d-4386-fb46-fd6d-229bea7b7a4a@linux.intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <f4bff93d83814ea1f54494f51ce3e5d954cf0f5b.1655894131.git.kai.huang@intel.com>
         <27de096d-4386-fb46-fd6d-229bea7b7a4a@linux.intel.com>
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

On Wed, 2022-08-03 at 11:55 +0800, Binbin Wu wrote:
> On 2022/6/22 19:15, Kai Huang wrote:
> >  =20
> > @@ -357,6 +358,17 @@ static int acpi_processor_add(struct acpi_device *=
device,
> >   	struct device *dev;
> >   	int result =3D 0;
> >  =20
> > +	/*
> > +	 * If the confidential computing platform doesn't support ACPI
> > +	 * memory hotplug, the BIOS should never deliver such event to
> memory or cpu hotplug?

Sorry typo.  Should be CPU.

Anyway this patch will be dropped in next version.

--=20
Thanks,
-Kai



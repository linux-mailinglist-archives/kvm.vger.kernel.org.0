Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4644CA95D
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 16:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235846AbiCBPq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 10:46:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239848AbiCBPq0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 10:46:26 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24035C3C26;
        Wed,  2 Mar 2022 07:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646235943; x=1677771943;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=exnosfsPOuG3dgKZRtkihqr1VgZvGXrCKlv7W+iMAqc=;
  b=d0VjIZKKsmefK9UoWEFsedJ3nZj3t6V/rpgl/EeUvRuAPYvBFMNEkbkI
   9tm5OMpgy6OYvGbb9v1QE2TTJDcGKKn1ScKU8HYjfAQ+HRCnW9cFyUWEC
   iFq1KrxcLpywUt5CP9PSmDWoEgqBJhX2tbkmqCaaHAg1V3qZe6p+5T6dv
   nbO1tLJ6PTgz3n/Qm6yanyyHuIWIEYVLJsqlMyTu2eWh/yk6IpBopHzqC
   kI0968pTTpSPAswkx3PUmj/V7ih9LqS/xML6gQ8QLOoX6cBJPhNi+h+nI
   FFmRv4W4ch1CGEplnVOKKuJwgZyXsI7PhgUdQ1tcbh/B/TpWqSTtmLb4R
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="252259482"
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="252259482"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 07:44:54 -0800
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="576145777"
Received: from smile.fi.intel.com ([10.237.72.59])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 07:44:50 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nPR91-00AMij-Ss;
        Wed, 02 Mar 2022 17:44:03 +0200
Date:   Wed, 2 Mar 2022 17:44:03 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Michael Mueller <mimu@linux.ibm.com>,
        Yury Norov <yury.norov@gmail.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Subject: Re: [PATCH v1 1/1] KVM: s390: Don't cast parameter in bit operations
Message-ID: <Yh+Qw6Pb+Cd9JDNa@smile.fi.intel.com>
References: <20220223164420.45344-1-andriy.shevchenko@linux.intel.com>
 <20220224123620.57fd6c8b@p-imbrenda>
 <3640a910-60fe-0935-4dfc-55bb65a75ce5@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3640a910-60fe-0935-4dfc-55bb65a75ce5@linux.ibm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 24, 2022 at 01:10:34PM +0100, Michael Mueller wrote:
> On 24.02.22 12:36, Claudio Imbrenda wrote:

...

> we do that at several places

Thanks for pointing out.

> arch/s390/kernel/processor.c:	for_each_set_bit_inv(bit, (long
> *)&stfle_fac_list, MAX_FACILITY_BIT)

This one requires a separate change, not related to this patch.

> arch/s390/kvm/interrupt.c:	set_bit_inv(IPM_BIT_OFFSET + gisc, (unsigned long
> *) gisa);

This is done in the patch. Not sure how it appears in your list.

> arch/s390/kvm/kvm-s390.c:		set_bit_inv(vcpu->vcpu_id, (unsigned long *)
> sca->mcn);
> arch/s390/kvm/kvm-s390.c:		set_bit_inv(vcpu->vcpu_id, (unsigned long *)
> &sca->mcn);

These two should be fixed in a separate change.

Also this kind of stuff:

	bitmap_copy(kvm->arch.cpu_feat, (unsigned long *) data.feat,
	            KVM_S390_VM_CPU_FEAT_NR_BITS);

might require a new API like

bitmap_from_u64_array()
bitmap_to_u64_array()

Yury?

-- 
With Best Regards,
Andy Shevchenko



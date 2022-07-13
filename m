Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4AE557342E
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 12:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235985AbiGMK36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 06:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbiGMK34 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 06:29:56 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1756EE5842;
        Wed, 13 Jul 2022 03:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657708196; x=1689244196;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=xCPTZdPlr/QKclHnOwFieHwilG0LSlbmNN9362YdJ2k=;
  b=MyKRjAo4mnJiCq/UzI/B+Mhr5EoErog+xjUQeBiyWETk9DmLjW8OjUv0
   ebF6J3WRAF26fPfwEUEK90TmbuT4QO80Wvc6u9HQpv0z4XG7rXanygQ77
   jxMp2kSs3wCHPgEO37wJx+eMSDUn/Yojl9QbDkPWFU0MZ6sygfvnMrWC4
   Go5q7eLvlOrYC9mijQHBuxpXcQ+o/klSnf5+fTydBChN4qzPV+GzwZ9h7
   Mwngom/J/7YXhXHC3okFLJEKnVeeUdQVVC0KUevC9BYVUwGN3636VRcjZ
   Jp/dyRqsJbUSWwWdsh15Yi4YycX3P8JPWjJ2huxX4wq6DJusBj2QSErDa
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="371486768"
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="371486768"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 03:29:55 -0700
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="570574395"
Received: from ifatima-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.1.196])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 03:29:54 -0700
Message-ID: <753184425e9d613841f4870a8a69f8cf96832f8d.camel@intel.com>
Subject: Re: [PATCH v7 035/102] KVM: x86/mmu: Explicitly check for MMIO spte
 in fast page fault
From:   Kai Huang <kai.huang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Date:   Wed, 13 Jul 2022 22:29:51 +1200
In-Reply-To: <20220713083515.GQ1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <71e4c19d1dff8135792e6c5a17d3a483bc99875b.1656366338.git.isaku.yamahata@intel.com>
         <cfeb3b8b02646b073d5355495ec8842ac33aeae5.camel@intel.com>
         <20220713083515.GQ1379820@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>=20
> Although it was needed, I noticed the following commit made this patch
> unnecessary.  So I'll drop this patch. Kudos to Sean.
>=20
> edea7c4fc215c7ee1cc98363b016ad505cbac9f7
> "KVM: x86/mmu: Use a dedicated bit to track shadow/MMU-present SPTEs"
>=20

Yes is_shadow_present_pte() always return false for MMIO so this patch isn'=
t
needed anymore.

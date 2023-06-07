Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA724726516
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 17:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241510AbjFGPyU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 11:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235682AbjFGPyT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 11:54:19 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3165A199D;
        Wed,  7 Jun 2023 08:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686153258; x=1717689258;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vBP9kZyvVdAnPGkseD/Y+R3madnb1gkJ2IGK2rOdWzk=;
  b=FXDVf5Nj26fQA4rIxaV+/2BShR9ijgm/QJr+j8D0fpagyF3nkf3MGQDR
   13Hue+bpHDuI7cKzTM641xEoxWylucKIcpxQccPlcqpJFDlV9f323TPDQ
   4rXUfHh4HMmjUN+YPG4q2qV5AGAHknL3SjSrvvuR4TXKRAYDsq66VjQgT
   KNPG4sz7+fgB9ZyvEUq2m/WGARRzohEooCyvd4VDCkU+iqv0X4IVozDVk
   atHX9rhmFgu7Qie7xdZ14cMJUriXEZWz1GRM/3aaeEsiCQ5wzvlzHQE1p
   JgfRJcdYK4YDm/pFYGbc1388J582xpKqnzS5dogX/bhveUaCGl4FaQOpl
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="355882016"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="355882016"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 08:54:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="799433164"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="799433164"
Received: from vsmyers-mobl2.amr.corp.intel.com (HELO [10.212.146.233]) ([10.212.146.233])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 08:54:16 -0700
Message-ID: <2295599a-0f6a-7008-11a0-41767fe420ac@intel.com>
Date:   Wed, 7 Jun 2023 08:54:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 10/20] x86/virt/tdx: Add placeholder to construct
 TDMRs to cover all TDX memory regions
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, kirill.shutemov@linux.intel.com,
        tony.luck@intel.com, peterz@infradead.org, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, david@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1685887183.git.kai.huang@intel.com>
 <f9148e67e968d7aed4707b67ea9b1aa761401255.1685887183.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <f9148e67e968d7aed4707b67ea9b1aa761401255.1685887183.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/4/23 07:27, Kai Huang wrote:
> Constructing the list of TDMRs consists below steps:

<grumble> <grumble> grammar <grumble> <grumble>

Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>

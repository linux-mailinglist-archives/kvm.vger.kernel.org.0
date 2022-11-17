Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEBFC62D791
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 10:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239427AbiKQJ5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 04:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239453AbiKQJ46 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 04:56:58 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26BC1FCF4;
        Thu, 17 Nov 2022 01:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668678948; x=1700214948;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8hAcVyOObK/UEBWT8vYG4Ig5Om7fochBS3TMYDUTsXM=;
  b=B79yjGhAWjpDRjTUT09tvTOuu5EEsLaFYPCV0YE1l39SktxLgxxUCNtR
   jMKMBAvzN+wYYFpw1fbxX7EGRTG1zrOkwVbldk0L4qu1LsKO/gjn4tYCR
   00Rm5cNLXwcOpe6rPyh8kHQNyRYxDPGEJmWLbQuK+4pyuyaW/pGrxBxnv
   x1Rh5HKRDAWOow5nGnekO/bWfWjV6DhWJ1spgaDPlxnjgiU6Q6NK/yu1s
   w52vYadrFwGfLyp03U11rSJui/wfdeQm6IbK2fd7mDlFZIe2X+27xVELg
   8z/ADmG8FdgdWWYtFUzUcuY/wJS3/COUb2MQ88Ad90uS8+l3u9w+wBF9c
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="310440612"
X-IronPort-AV: E=Sophos;i="5.96,171,1665471600"; 
   d="scan'208";a="310440612"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 01:55:47 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="728765804"
X-IronPort-AV: E=Sophos;i="5.96,171,1665471600"; 
   d="scan'208";a="728765804"
Received: from pengqian-mobl.ccr.corp.intel.com (HELO localhost) ([10.254.215.116])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 01:55:45 -0800
Date:   Thu, 17 Nov 2022 17:55:43 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Cleanup VMFUNC handling in KVM.
Message-ID: <20221117095543.ubytzmogjuqfqsee@linux.intel.com>
References: <20221109075413.1405803-1-yu.c.zhang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109075413.1405803-1-yu.c.zhang@linux.intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 09, 2022 at 03:54:11PM +0800, Yu Zhang wrote:

Ping... Thanks!

B.R.
Yu

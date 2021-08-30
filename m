Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6BB3FB93D
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 17:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237622AbhH3PuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 11:50:04 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:7548 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237589AbhH3Pto (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 11:49:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1630338531; x=1661874531;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XeidnQ1zS/0jjphT1MthZFR5eQ57gcnbSDqgVeDiMcY=;
  b=mT/GcTQ1OIfXeLev/UA6/se9aDMhM8UQYX0div2c8J3tjSrb8dO43xdH
   WE9UKrMZpmdsB3cl6S848j3UWGnP7DFE8TGx+ML3kJC+arI/+PmJYrjsa
   qcBLRcVN7eY0/wveMXBJETW7apuivTcXZRAdWdw2n0Oz0lANv6jLne2Yf
   g=;
X-IronPort-AV: E=Sophos;i="5.84,363,1620691200"; 
   d="scan'208";a="133232067"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 30 Aug 2021 15:48:48 +0000
Received: from EX13D46EUB004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com (Postfix) with ESMTPS id C7576A17EA;
        Mon, 30 Aug 2021 15:48:46 +0000 (UTC)
Received: from u90cef543d0ab5a.ant.amazon.com (10.43.162.186) by
 EX13D46EUB004.ant.amazon.com (10.43.166.65) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Mon, 30 Aug 2021 15:48:40 +0000
Date:   Mon, 30 Aug 2021 18:48:35 +0300
From:   George-Aurelian Popescu <popegeo@amazon.com>
To:     Andra Paraschiv <andraprs@amazon.com>
CC:     linux-kernel <linux-kernel@vger.kernel.org>,
        Alexandru Ciobotaru <alcioa@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>,
        Alexandru Vasile <lexnv@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
Subject: Re: [PATCH v3 5/7] nitro_enclaves: Add fixes for checkpatch match
 open parenthesis reports
Message-ID: <20210830154834.GC10224@u90cef543d0ab5a.ant.amazon.com>
References: <20210827154930.40608-1-andraprs@amazon.com>
 <20210827154930.40608-6-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210827154930.40608-6-andraprs@amazon.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.162.186]
X-ClientProxiedBy: EX13D24UWB002.ant.amazon.com (10.43.161.159) To
 EX13D46EUB004.ant.amazon.com (10.43.166.65)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 06:49:28PM +0300, Andra Paraschiv wrote:
> Update the codebase formatting to fix the reports from the checkpatch
> script, to match the open parenthesis.
> 
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> ---
> Changelog
> 
> v1 -> v2
> 
> * No codebase changes, it was split from the patch 3 in the v1 of the
> patch series.
> 
> v2 -> v3
> 
> * Move changelog after the "---" line.
> ---
>  drivers/virt/nitro_enclaves/ne_misc_dev.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
> index e21e1e86ad15f..8939612ee0e08 100644
> --- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
> - * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
> + * Copyright 2020-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
>   */
>  
>  /**
> @@ -284,8 +284,8 @@ static int ne_setup_cpu_pool(const char *ne_cpu_list)
>  	ne_cpu_pool.nr_parent_vm_cores = nr_cpu_ids / ne_cpu_pool.nr_threads_per_core;
>  
>  	ne_cpu_pool.avail_threads_per_core = kcalloc(ne_cpu_pool.nr_parent_vm_cores,
> -					     sizeof(*ne_cpu_pool.avail_threads_per_core),
> -					     GFP_KERNEL);
> +						     sizeof(*ne_cpu_pool.avail_threads_per_core),
> +						     GFP_KERNEL);
>  	if (!ne_cpu_pool.avail_threads_per_core) {
>  		rc = -ENOMEM;
>  
> @@ -735,7 +735,7 @@ static int ne_add_vcpu_ioctl(struct ne_enclave *ne_enclave, u32 vcpu_id)
>   * * Negative return value on failure.
>   */
>  static int ne_sanity_check_user_mem_region(struct ne_enclave *ne_enclave,
> -	struct ne_user_memory_region mem_region)
> +					   struct ne_user_memory_region mem_region)
>  {
>  	struct ne_mem_region *ne_mem_region = NULL;
>  
> @@ -771,7 +771,7 @@ static int ne_sanity_check_user_mem_region(struct ne_enclave *ne_enclave,
>  		u64 userspace_addr = ne_mem_region->userspace_addr;
>  
>  		if ((userspace_addr <= mem_region.userspace_addr &&
> -		    mem_region.userspace_addr < (userspace_addr + memory_size)) ||
> +		     mem_region.userspace_addr < (userspace_addr + memory_size)) ||
>  		    (mem_region.userspace_addr <= userspace_addr &&
>  		    (mem_region.userspace_addr + mem_region.memory_size) > userspace_addr)) {
>  			dev_err_ratelimited(ne_misc_dev.this_device,
> @@ -836,7 +836,7 @@ static int ne_sanity_check_user_mem_region_page(struct ne_enclave *ne_enclave,
>   * * Negative return value on failure.
>   */
>  static int ne_set_user_memory_region_ioctl(struct ne_enclave *ne_enclave,
> -	struct ne_user_memory_region mem_region)
> +					   struct ne_user_memory_region mem_region)
>  {
>  	long gup_rc = 0;
>  	unsigned long i = 0;
> @@ -1014,7 +1014,7 @@ static int ne_set_user_memory_region_ioctl(struct ne_enclave *ne_enclave,
>   * * Negative return value on failure.
>   */
>  static int ne_start_enclave_ioctl(struct ne_enclave *ne_enclave,
> -	struct ne_enclave_start_info *enclave_start_info)
> +				  struct ne_enclave_start_info *enclave_start_info)
>  {
>  	struct ne_pci_dev_cmd_reply cmd_reply = {};
>  	unsigned int cpu = 0;
> @@ -1574,7 +1574,8 @@ static int ne_create_vm_ioctl(struct ne_pci_dev *ne_pci_dev, u64 __user *slot_ui
>  	mutex_unlock(&ne_cpu_pool.mutex);
>  
>  	ne_enclave->threads_per_core = kcalloc(ne_enclave->nr_parent_vm_cores,
> -		sizeof(*ne_enclave->threads_per_core), GFP_KERNEL);
> +					       sizeof(*ne_enclave->threads_per_core),
> +					       GFP_KERNEL);
>  	if (!ne_enclave->threads_per_core) {
>  		rc = -ENOMEM;
>  
> -- 
> 2.20.1 (Apple Git-117)
> 

Reviewed-by: George-Aurelian Popescu <popegeo@amazon.com>

Looks ok,
George



Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.


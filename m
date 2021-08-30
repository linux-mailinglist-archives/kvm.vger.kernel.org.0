Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F523FB936
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 17:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237553AbhH3PsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 11:48:04 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:5148 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237311AbhH3PsB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 11:48:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1630338428; x=1661874428;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=L0syupxn/9GgxVlk0bl8f4Z5IqsanLBn8z9uCV847RQ=;
  b=X5zyfPq21WQ0IlcPN4bRZtBfQMNKbqLNDZT6O3E5vxsfMQA6kUWF7pYh
   8PuDSahQ6gGYqRlhWdvrVAhD4KwCK2s5sIa7o2cnyb1GmMhpX8fnlSWFd
   SdqwXuuqseDDKJNCp8R9ZZUJdU0C2Y7qpAUDoyqBZih9WBXXCWCUnYqoU
   k=;
X-IronPort-AV: E=Sophos;i="5.84,363,1620691200"; 
   d="scan'208";a="133231569"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 30 Aug 2021 15:46:59 +0000
Received: from EX13D46EUB004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com (Postfix) with ESMTPS id D7574A18B0;
        Mon, 30 Aug 2021 15:46:57 +0000 (UTC)
Received: from u90cef543d0ab5a.ant.amazon.com (10.43.161.229) by
 EX13D46EUB004.ant.amazon.com (10.43.166.65) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Mon, 30 Aug 2021 15:46:51 +0000
Date:   Mon, 30 Aug 2021 18:46:46 +0300
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
Subject: Re: [PATCH v3 6/7] nitro_enclaves: Add fixes for checkpatch spell
 check reports
Message-ID: <20210830154645.GB10224@u90cef543d0ab5a.ant.amazon.com>
References: <20210827154930.40608-1-andraprs@amazon.com>
 <20210827154930.40608-7-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210827154930.40608-7-andraprs@amazon.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.161.229]
X-ClientProxiedBy: EX13D28UWC003.ant.amazon.com (10.43.162.48) To
 EX13D46EUB004.ant.amazon.com (10.43.166.65)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 06:49:29PM +0300, Andra Paraschiv wrote:
> Fix the typos in the words spelling as per the checkpatch script
> reports.
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
>  include/uapi/linux/nitro_enclaves.h      | 10 +++++-----
>  samples/nitro_enclaves/ne_ioctl_sample.c |  4 ++--
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/include/uapi/linux/nitro_enclaves.h b/include/uapi/linux/nitro_enclaves.h
> index b945073fe544d..e808f5ba124d4 100644
> --- a/include/uapi/linux/nitro_enclaves.h
> +++ b/include/uapi/linux/nitro_enclaves.h
> @@ -1,6 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>  /*
> - * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
> + * Copyright 2020-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
>   */
>  
>  #ifndef _UAPI_LINUX_NITRO_ENCLAVES_H_
> @@ -60,7 +60,7 @@
>   *
>   * Context: Process context.
>   * Return:
> - * * 0					- Logic succesfully completed.
> + * * 0					- Logic successfully completed.
>   * *  -1				- There was a failure in the ioctl logic.
>   * On failure, errno is set to:
>   * * EFAULT				- copy_from_user() / copy_to_user() failure.
> @@ -95,7 +95,7 @@
>   *
>   * Context: Process context.
>   * Return:
> - * * 0				- Logic succesfully completed.
> + * * 0				- Logic successfully completed.
>   * *  -1			- There was a failure in the ioctl logic.
>   * On failure, errno is set to:
>   * * EFAULT			- copy_from_user() / copy_to_user() failure.
> @@ -118,7 +118,7 @@
>   *
>   * Context: Process context.
>   * Return:
> - * * 0					- Logic succesfully completed.
> + * * 0					- Logic successfully completed.
>   * *  -1				- There was a failure in the ioctl logic.
>   * On failure, errno is set to:
>   * * EFAULT				- copy_from_user() failure.
> @@ -161,7 +161,7 @@
>   *
>   * Context: Process context.
>   * Return:
> - * * 0					- Logic succesfully completed.
> + * * 0					- Logic successfully completed.
>   * *  -1				- There was a failure in the ioctl logic.
>   * On failure, errno is set to:
>   * * EFAULT				- copy_from_user() / copy_to_user() failure.
> diff --git a/samples/nitro_enclaves/ne_ioctl_sample.c b/samples/nitro_enclaves/ne_ioctl_sample.c
> index 480b763142b34..6a60990b2e202 100644
> --- a/samples/nitro_enclaves/ne_ioctl_sample.c
> +++ b/samples/nitro_enclaves/ne_ioctl_sample.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
> - * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
> + * Copyright 2020-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
>   */
>  
>  /**
> @@ -638,7 +638,7 @@ static int ne_start_enclave(int enclave_fd,  struct ne_enclave_start_info *encla
>  }
>  
>  /**
> - * ne_start_enclave_check_booted() - Start the enclave and wait for a hearbeat
> + * ne_start_enclave_check_booted() - Start the enclave and wait for a heartbeat
>   *				     from it, on a newly created vsock channel,
>   *				     to check it has booted.
>   * @enclave_fd :	The file descriptor associated with the enclave.
> -- 
> 2.20.1 (Apple Git-117)
> 

Reviewed-by: George-Aurelian Popescu <popegeo@amazon.com>

Looks ok,
George



Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.


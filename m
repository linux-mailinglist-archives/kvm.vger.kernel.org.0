Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD603FB957
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 17:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237730AbhH3Pyl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 11:54:41 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:53255 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237670AbhH3Pyj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 11:54:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1630338827; x=1661874827;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AVofwnGJ4gDMssI008iwAyHL4iRR+umoM86t4CKuuDo=;
  b=rVw5SAkrx5w6VXxoGCi2FEBQ6sunVhdH4xFr1352H1jyISxwpsPEtQL7
   zIjNlmndibOoPqllaoCKq4htwyF3bicWqntPitaEUT1wuMPKCpbFCWR98
   USuMQE5KtJ7p6dNvoQzy4pH6cdTzGJu9HkfBYvMdJXc5WfynJMxzzSUnb
   Y=;
X-IronPort-AV: E=Sophos;i="5.84,363,1620691200"; 
   d="scan'208";a="144737468"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 30 Aug 2021 15:53:38 +0000
Received: from EX13D46EUB004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com (Postfix) with ESMTPS id 01B7AA0244;
        Mon, 30 Aug 2021 15:53:36 +0000 (UTC)
Received: from u90cef543d0ab5a.ant.amazon.com (10.43.160.41) by
 EX13D46EUB004.ant.amazon.com (10.43.166.65) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Mon, 30 Aug 2021 15:53:31 +0000
Date:   Mon, 30 Aug 2021 18:53:25 +0300
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
Subject: Re: [PATCH v3 3/7] nitro_enclaves: Add fix for the kernel-doc report
Message-ID: <20210830155324.GE10224@u90cef543d0ab5a.ant.amazon.com>
References: <20210827154930.40608-1-andraprs@amazon.com>
 <20210827154930.40608-4-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210827154930.40608-4-andraprs@amazon.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.160.41]
X-ClientProxiedBy: EX13D08UWB002.ant.amazon.com (10.43.161.168) To
 EX13D46EUB004.ant.amazon.com (10.43.166.65)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 06:49:26PM +0300, Andra Paraschiv wrote:
> Fix the reported issue from the kernel-doc script, to have a comment per
> identifier.
> 
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> ---
> Changelog
> 
> v1 -> v2
> 
> * Update comments for send / receive buffer sizes for the NE PCI device.
> 
> v2 -> v3
> 
> * Move changelog after the "---" line.
> ---
>  drivers/virt/nitro_enclaves/ne_pci_dev.h | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.h b/drivers/virt/nitro_enclaves/ne_pci_dev.h
> index 8bfbc66078185..6e9f28971a4e0 100644
> --- a/drivers/virt/nitro_enclaves/ne_pci_dev.h
> +++ b/drivers/virt/nitro_enclaves/ne_pci_dev.h
> @@ -1,6 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  /*
> - * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
> + * Copyright 2020-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
>   */
>  
>  #ifndef _NE_PCI_DEV_H_
> @@ -84,9 +84,13 @@
>   */
>  
>  /**
> - * NE_SEND_DATA_SIZE / NE_RECV_DATA_SIZE - 240 bytes for send / recv buffer.
> + * NE_SEND_DATA_SIZE - Size of the send buffer, in bytes.
>   */
>  #define NE_SEND_DATA_SIZE	(240)
> +
> +/**
> + * NE_RECV_DATA_SIZE - Size of the receive buffer, in bytes.
> + */
>  #define NE_RECV_DATA_SIZE	(240)
>  
>  /**
> -- 
> 2.20.1 (Apple Git-117)
> 

Reviewed-by: George-Aurelian Popescu <popegeo@amazon.com>

Looks good,
George



Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.


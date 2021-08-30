Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6393C3FB934
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 17:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237489AbhH3PqU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 11:46:20 -0400
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:62358 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237311AbhH3PqR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 11:46:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1630338324; x=1661874324;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=i2VKXTlxLcgXfPeYsZQHu6scQ8eGJD8bNYRbQ0Du1XU=;
  b=Fperxl0ErYp0AoG2NXoIe/tPgh0x6LQ2tUE2RLS2e98zA8ayvJSDYmQq
   OQOqTKIC3MbVLrX3Audx+EZ6NvWVcA/zIuIpVotEIwvGdQkNpMfcPNp7A
   auRDT6n/v1b0ozdbCYItkhUB9q3gKTjDS+k+aQcXuFadhN5Wp9rjLq5Jo
   I=;
X-IronPort-AV: E=Sophos;i="5.84,363,1620691200"; 
   d="scan'208";a="22928332"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 30 Aug 2021 15:45:16 +0000
Received: from EX13D46EUB004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id 453F8A072F;
        Mon, 30 Aug 2021 15:45:15 +0000 (UTC)
Received: from u90cef543d0ab5a.ant.amazon.com (10.43.162.52) by
 EX13D46EUB004.ant.amazon.com (10.43.166.65) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Mon, 30 Aug 2021 15:45:09 +0000
Date:   Mon, 30 Aug 2021 18:45:03 +0300
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
Subject: Re: [PATCH v3 7/7] nitro_enclaves: Add fixes for checkpatch blank
 line reports
Message-ID: <20210830154502.GA10224@u90cef543d0ab5a.ant.amazon.com>
References: <20210827154930.40608-1-andraprs@amazon.com>
 <20210827154930.40608-8-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210827154930.40608-8-andraprs@amazon.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.162.52]
X-ClientProxiedBy: EX13D22UWB003.ant.amazon.com (10.43.161.76) To
 EX13D46EUB004.ant.amazon.com (10.43.166.65)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 06:49:30PM +0300, Andra Paraschiv wrote:
> Remove blank lines that are not necessary, fixing the checkpatch script
> reports. While at it, add a blank line after the switch default block,
> similar to the other parts of the codebase.
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
>  samples/nitro_enclaves/ne_ioctl_sample.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/samples/nitro_enclaves/ne_ioctl_sample.c b/samples/nitro_enclaves/ne_ioctl_sample.c
> index 6a60990b2e202..765b131c73190 100644
> --- a/samples/nitro_enclaves/ne_ioctl_sample.c
> +++ b/samples/nitro_enclaves/ne_ioctl_sample.c
> @@ -185,7 +185,6 @@ static int ne_create_vm(int ne_dev_fd, unsigned long *slot_uid, int *enclave_fd)
>  	return 0;
>  }
>  
> -
>  /**
>   * ne_poll_enclave_fd() - Thread function for polling the enclave fd.
>   * @data:	Argument provided for the polling function.
> @@ -560,8 +559,8 @@ static int ne_add_vcpu(int enclave_fd, unsigned int *vcpu_id)
>  
>  		default:
>  			printf("Error in add vcpu [%m]\n");
> -
>  		}
> +
>  		return rc;
>  	}
>  
> -- 
> 2.20.1 (Apple Git-117)
> 

Reviewed-by: George-Aurelian Popescu <popegeo@amazon.com>

Nice,
George



Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.


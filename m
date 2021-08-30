Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3813FB97C
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 17:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237646AbhH3P6B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 11:58:01 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:23905 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237806AbhH3P5z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 11:57:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1630339023; x=1661875023;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tmkgJpbCT6y8GKQE7rLnZO9zRHzZfu1yMIwII7aSzhk=;
  b=FlCxAGB0uyyTSG94Y+8Ec20+rbUl1sifX8uz89hm+fjFGKJtooTtwpvH
   sVS+CFSr8ZZvlLmQUjiiifGN+9sy8wLFV9SqySuJEZZd6LQSkVzeZaPdr
   yR6rghe2rD+ZIfBnfMz53NAh2gNEwXpw9Yeoqt5vwNAz6P1DN0nvLdbLw
   8=;
X-IronPort-AV: E=Sophos;i="5.84,363,1620691200"; 
   d="scan'208";a="136277121"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 30 Aug 2021 15:56:54 +0000
Received: from EX13D46EUB004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com (Postfix) with ESMTPS id A5092A2030;
        Mon, 30 Aug 2021 15:56:52 +0000 (UTC)
Received: from u90cef543d0ab5a.ant.amazon.com (10.43.160.241) by
 EX13D46EUB004.ant.amazon.com (10.43.166.65) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Mon, 30 Aug 2021 15:56:46 +0000
Date:   Mon, 30 Aug 2021 18:56:41 +0300
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
Subject: Re: [PATCH v3 2/7] nitro_enclaves: Update documentation for Arm64
 support
Message-ID: <20210830155640.GF10224@u90cef543d0ab5a.ant.amazon.com>
References: <20210827154930.40608-1-andraprs@amazon.com>
 <20210827154930.40608-3-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210827154930.40608-3-andraprs@amazon.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.160.241]
X-ClientProxiedBy: EX13D44UWB001.ant.amazon.com (10.43.161.32) To
 EX13D46EUB004.ant.amazon.com (10.43.166.65)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 06:49:25PM +0300, Andra Paraschiv wrote:
> Add references for hugepages and booting steps for Arm64.
> 
> Include info about the current supported architectures for the
> NE kernel driver.
> 
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> ---
> Changelog
> 
> v1 -> v2
> 
> * Add information about supported architectures for the NE kernel
> driver.
> 
> v2 -> v3
> 
> * Move changelog after the "---" line.
> ---
>  Documentation/virt/ne_overview.rst | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/virt/ne_overview.rst b/Documentation/virt/ne_overview.rst
> index 39b0c8fe2654a..74c2f5919c886 100644
> --- a/Documentation/virt/ne_overview.rst
> +++ b/Documentation/virt/ne_overview.rst
> @@ -14,12 +14,15 @@ instances [1].
>  For example, an application that processes sensitive data and runs in a VM,
>  can be separated from other applications running in the same VM. This
>  application then runs in a separate VM than the primary VM, namely an enclave.
> +It runs alongside the VM that spawned it. This setup matches low latency
> +applications needs.
>  
> -An enclave runs alongside the VM that spawned it. This setup matches low latency
> -applications needs. The resources that are allocated for the enclave, such as
> -memory and CPUs, are carved out of the primary VM. Each enclave is mapped to a
> -process running in the primary VM, that communicates with the NE driver via an
> -ioctl interface.
> +The current supported architectures for the NE kernel driver, available in the
> +upstream Linux kernel, are x86 and ARM64.
> +
> +The resources that are allocated for the enclave, such as memory and CPUs, are
> +carved out of the primary VM. Each enclave is mapped to a process running in the
> +primary VM, that communicates with the NE kernel driver via an ioctl interface.
>  
>  In this sense, there are two components:
>  
> @@ -43,8 +46,8 @@ for the enclave VM. An enclave does not have persistent storage attached.
>  The memory regions carved out of the primary VM and given to an enclave need to
>  be aligned 2 MiB / 1 GiB physically contiguous memory regions (or multiple of
>  this size e.g. 8 MiB). The memory can be allocated e.g. by using hugetlbfs from
> -user space [2][3]. The memory size for an enclave needs to be at least 64 MiB.
> -The enclave memory and CPUs need to be from the same NUMA node.
> +user space [2][3][7]. The memory size for an enclave needs to be at least
> +64 MiB. The enclave memory and CPUs need to be from the same NUMA node.
>  
>  An enclave runs on dedicated cores. CPU 0 and its CPU siblings need to remain
>  available for the primary VM. A CPU pool has to be set for NE purposes by an
> @@ -61,7 +64,7 @@ device is placed in memory below the typical 4 GiB.
>  The application that runs in the enclave needs to be packaged in an enclave
>  image together with the OS ( e.g. kernel, ramdisk, init ) that will run in the
>  enclave VM. The enclave VM has its own kernel and follows the standard Linux
> -boot protocol [6].
> +boot protocol [6][8].
>  
>  The kernel bzImage, the kernel command line, the ramdisk(s) are part of the
>  Enclave Image Format (EIF); plus an EIF header including metadata such as magic
> @@ -93,3 +96,5 @@ enclave process can exit.
>  [4] https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
>  [5] https://man7.org/linux/man-pages/man7/vsock.7.html
>  [6] https://www.kernel.org/doc/html/latest/x86/boot.html
> +[7] https://www.kernel.org/doc/html/latest/arm64/hugetlbpage.html
> +[8] https://www.kernel.org/doc/html/latest/arm64/booting.html
> -- 
> 2.20.1 (Apple Git-117)
> 

Reviewed-by: George-Aurelian Popescu <popegeo@amazon.com>

Looks good,
George



Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.


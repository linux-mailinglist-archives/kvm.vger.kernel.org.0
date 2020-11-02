Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50F22A2F80
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 17:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgKBQR1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 11:17:27 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:52182 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgKBQR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 11:17:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1604333845; x=1635869845;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=5ebmZkZ6EssFRGEyPn1Qc4ealUOtSh6Bj6ocigTKgzA=;
  b=R0UgwtL5Dva0sSmDYtQ1Xai5HY0lrg+1U70NAS8Q2f4bAVbfGi+GSgy0
   OikazPFTly3a3stOeFvUMDyDKAxeRZWlW9NCUhsGLvKJznlTvgW/fBMoH
   kC6x51zOgC8Ugwwk5K8gMcNRkunKe0KLy6PCi4jUgmwv7lSQl1QXTgC30
   w=;
X-IronPort-AV: E=Sophos;i="5.77,445,1596499200"; 
   d="scan'208";a="89754479"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 02 Nov 2020 16:17:01 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (Postfix) with ESMTPS id 52CA9A1DFF;
        Mon,  2 Nov 2020 16:16:59 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 2 Nov 2020 16:16:58 +0000
Received: from Alexanders-MacBook-Air.local (10.43.160.22) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 2 Nov 2020 16:16:53 +0000
Subject: Re: [PATCH v1] nitro_enclaves: Fixup type of the poll result assigned
 value
To:     Andra Paraschiv <andraprs@amazon.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "David Duncan" <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Karen Noel <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
References: <20201014090500.75678-1-andraprs@amazon.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <e4a34429-1b25-00d5-9bf1-045ca49acb8d@amazon.de>
Date:   Mon, 2 Nov 2020 17:16:51 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201014090500.75678-1-andraprs@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.22]
X-ClientProxiedBy: EX13D35UWC004.ant.amazon.com (10.43.162.180) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14.10.20 11:05, Andra Paraschiv wrote:
> Update the assigned value of the poll result to be EPOLLHUP instead of
> POLLHUP to match the __poll_t type.
> =

> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> Reported-by: kernel test robot <lkp@intel.com>
> ---
>   drivers/virt/nitro_enclaves/ne_misc_dev.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> =

> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nit=
ro_enclaves/ne_misc_dev.c
> index f06622b48d69..9148566455e8 100644
> --- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
> @@ -1508,7 +1508,7 @@ static __poll_t ne_enclave_poll(struct file *file, =
poll_table *wait)
>   	if (!ne_enclave->has_event)
>   		return mask;
>   =

> -	mask =3D POLLHUP;
> +	mask =3D EPOLLHUP;

That whole function looks a bit ... convoluted? How about this? I guess =

you could trim it down even further, but this looks quite readable to me:

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c =

b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index f06622b48d69..5b7f45e2eb4c 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -1505,10 +1505,8 @@ static __poll_t ne_enclave_poll(struct file =

*file, poll_table *wait)

  	poll_wait(file, &ne_enclave->eventq, wait);

-	if (!ne_enclave->has_event)
-		return mask;
-
-	mask =3D POLLHUP;
+	if (ne_enclave->has_event)
+		mask |=3D POLLHUP;

  	return mask;
  }


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879




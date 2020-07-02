Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172DD2127C5
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 17:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730349AbgGBPYf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 11:24:35 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:28765 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730090AbgGBPYc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 11:24:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1593703472; x=1625239472;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=IlEE+mwY2EeET+viiChdK1i+ylGRuwctUmYhriiqkXI=;
  b=IM+poplqmHoSyRuA8fSwGRrdIaYLb9Hatsurd8Tu+JbYX39X8xbesmiX
   M+pq8NJgJyHimxS1xqMb74A5CVvTcQvLxErRsdyPAzy2/ZWiT+/VuclBD
   TEMIUP/aoq05ccbPDgV/FUV8eOmb1Y+MoSUcbkFdWBAucizw/vKLMRSNJ
   I=;
IronPort-SDR: WLisDY8317emsysH4WhGm+ZObGNeudhV3GsL7ETo2aiZC1i5JxiF2bIGMoFVRdYpE7CuZGZA/r
 /SXi9NnHVa/Q==
X-IronPort-AV: E=Sophos;i="5.75,304,1589241600"; 
   d="scan'208";a="55643964"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-e7be2041.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 02 Jul 2020 15:24:31 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-e7be2041.us-west-2.amazon.com (Postfix) with ESMTPS id D98B2A2818;
        Thu,  2 Jul 2020 15:24:29 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 2 Jul 2020 15:24:29 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.65) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 2 Jul 2020 15:24:24 +0000
Subject: Re: [PATCH v4 01/18] nitro_enclaves: Add ioctl interface definition
To:     Andra Paraschiv <andraprs@amazon.com>,
        <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        "Stefano Garzarella" <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200622200329.52996-1-andraprs@amazon.com>
 <20200622200329.52996-2-andraprs@amazon.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <402dca8b-8650-777a-5b34-95057d4a42c4@amazon.de>
Date:   Thu, 2 Jul 2020 17:24:22 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200622200329.52996-2-andraprs@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.65]
X-ClientProxiedBy: EX13D16UWB004.ant.amazon.com (10.43.161.170) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.06.20 22:03, Andra Paraschiv wrote:
> The Nitro Enclaves driver handles the enclave lifetime management. This
> includes enclave creation, termination and setting up its resources such
> as memory and CPU.
> =

> An enclave runs alongside the VM that spawned it. It is abstracted as a
> process running in the VM that launched it. The process interacts with
> the NE driver, that exposes an ioctl interface for creating an enclave
> and setting up its resources.
> =

> Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>

Reviewed-by: Alexander Graf <graf@amazon.com>


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879




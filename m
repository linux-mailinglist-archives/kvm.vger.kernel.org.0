Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6512B214490
	for <lists+kvm@lfdr.de>; Sat,  4 Jul 2020 10:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgGDIJc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Jul 2020 04:09:32 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:19561 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgGDIJb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Jul 2020 04:09:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1593850171; x=1625386171;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=0Mt25RdlfBLf1yTTpRCfwtdInvE0uimWqJVL2uq46vE=;
  b=Lb0L7b2b5zO8FjeJztR6Wb8m8cV5WWFjYM8uw3U2N4YVV75NryRJ2e6n
   MJacH0LNeohpu7/Hb4XVmRKzYr/YPLT9Ba/IajF83wfEeeW+j8+UXiBna
   ArpH1Ce0JpujfKY4oGx2aZNT6Lz5yFijRdjLKkcUOyzeWBtHGot8f1aGW
   Y=;
IronPort-SDR: 2rJ2vdzJFLDDX5KFFMz6Oha//xUQ4vH+nD+6ZkUG02zf4mRTNRiMVovFrW9SRImICpTrjKnLZs
 XutWlE0dDLhQ==
X-IronPort-AV: E=Sophos;i="5.75,311,1589241600"; 
   d="scan'208";a="55989107"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 04 Jul 2020 08:09:25 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 13132A1D2A;
        Sat,  4 Jul 2020 08:09:23 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 4 Jul 2020 08:09:22 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.145) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 4 Jul 2020 08:09:14 +0000
Subject: Re: [PATCH v4 01/18] nitro_enclaves: Add ioctl interface definition
To:     Alexander Graf <graf@amazon.de>, <linux-kernel@vger.kernel.org>
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
 <402dca8b-8650-777a-5b34-95057d4a42c4@amazon.de>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <e8888e4a-7538-3755-80b1-69e7fcac38a8@amazon.com>
Date:   Sat, 4 Jul 2020 11:09:04 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <402dca8b-8650-777a-5b34-95057d4a42c4@amazon.de>
Content-Language: en-US
X-Originating-IP: [10.43.161.145]
X-ClientProxiedBy: EX13D04UWB003.ant.amazon.com (10.43.161.231) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 02/07/2020 18:24, Alexander Graf wrote:
>
>
> On 22.06.20 22:03, Andra Paraschiv wrote:
>> The Nitro Enclaves driver handles the enclave lifetime management. This
>> includes enclave creation, termination and setting up its resources such
>> as memory and CPU.
>>
>> An enclave runs alongside the VM that spawned it. It is abstracted as a
>> process running in the VM that launched it. The process interacts with
>> the NE driver, that exposes an ioctl interface for creating an enclave
>> and setting up its resources.
>>
>> Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
>> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>
> Reviewed-by: Alexander Graf <graf@amazon.com>

Added. Thanks for reviewing the group of patches so far.

Andra



Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.


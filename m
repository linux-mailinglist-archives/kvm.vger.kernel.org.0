Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480702127CA
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 17:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730357AbgGBPYr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 11:24:47 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:15197 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730195AbgGBPYq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 11:24:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1593703486; x=1625239486;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=nkmDXtaePXWcmJSfN1BNlH1GK4LqQIDWcLPiBV5PH2s=;
  b=P5Fo+ozDrtIcA+LN1oaPberN/9P2DEMnMYI9NX3U6cXbaOvwShyZc635
   xi2hndz6zs86EpPSUXFRY7STZFjCmHqKTibL5feInPPtnPFmL6ZwGl41h
   LAfAtmPvwOdSqUu8g9v48MFO6EwW/58LV7tUPk/c/e7oiRo/TSIbGhNXB
   k=;
IronPort-SDR: 7OfPpNa0i//+CwtAHQ5YfMb5h/bANcQOcdVPx0MyXiJDDqxyK4u4tF7aixXGOvJ9IHM11RMSsu
 atVPHNMy+t8g==
X-IronPort-AV: E=Sophos;i="5.75,304,1589241600"; 
   d="scan'208";a="56915989"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-e7be2041.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 02 Jul 2020 15:24:40 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-e7be2041.us-west-2.amazon.com (Postfix) with ESMTPS id 1639EA1F30;
        Thu,  2 Jul 2020 15:24:40 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 2 Jul 2020 15:24:39 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.65) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 2 Jul 2020 15:24:32 +0000
Subject: Re: [PATCH v4 03/18] nitro_enclaves: Define enclave info for internal
 bookkeeping
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
 <20200622200329.52996-4-andraprs@amazon.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <cc84e2ee-1a85-c92e-9d29-2f4a33148a61@amazon.de>
Date:   Thu, 2 Jul 2020 17:24:30 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200622200329.52996-4-andraprs@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.65]
X-ClientProxiedBy: EX13D21UWA001.ant.amazon.com (10.43.160.154) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.06.20 22:03, Andra Paraschiv wrote:
> The Nitro Enclaves driver keeps an internal info per each enclave.
> =

> This is needed to be able to manage enclave resources state, enclave
> notifications and have a reference of the PCI device that handles
> command requests for enclave lifetime management.
> =

> Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
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




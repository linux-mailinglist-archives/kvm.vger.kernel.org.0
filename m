Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E52421566A
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 13:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbgGFLaW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 07:30:22 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:13866 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728806AbgGFLaW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 07:30:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1594035022; x=1625571022;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=xykWh2KaExnb8gik6sipS8/bbonzC2VJWRPnDJWOx0Y=;
  b=tcx209TaT0CUr8o3+Kwm1k+naG3mKCKZo6Cqc32P7EksOwrBgUHMbMvx
   /nfv1Mru7cR6M+M4xOHPysXtZPwCVf7riSZRmRrL3AvvvtGCpNgOfI/ml
   486U8k3Qi5WlbgLfe6IFLFTC5uh0Ubb9RdDH/0peG2n8XpL3oy81gC7dc
   Y=;
IronPort-SDR: /b+zh7FpTMrp6E6ONl0KMtfjqIc04HwDNB3WZl8ZjBKQYwZKkTZI5ysaOF5zskFFyeWPqZd9LL
 C5JFnBeq9jtw==
X-IronPort-AV: E=Sophos;i="5.75,318,1589241600"; 
   d="scan'208";a="57612954"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-9ec21598.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 06 Jul 2020 11:30:21 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-9ec21598.us-east-1.amazon.com (Postfix) with ESMTPS id DEADCA23F4;
        Mon,  6 Jul 2020 11:30:18 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 11:30:18 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.26) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 11:30:11 +0000
Subject: Re: [PATCH v4 15/18] nitro_enclaves: Add Makefile for the Nitro
 Enclaves driver
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
 <20200622200329.52996-16-andraprs@amazon.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <2ec8a2f6-0084-bb70-4436-24afc39069b9@amazon.de>
Date:   Mon, 6 Jul 2020 13:30:07 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200622200329.52996-16-andraprs@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.26]
X-ClientProxiedBy: EX13D44UWC004.ant.amazon.com (10.43.162.209) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.06.20 22:03, Andra Paraschiv wrote:
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




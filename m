Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9ABF1E157B
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 23:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388968AbgEYVDK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 17:03:10 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:61765 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388432AbgEYVDJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 17:03:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590440589; x=1621976589;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Hd6XK+Y9/c5MBVnJOnoOjR/apdAqUvjUoZNnnxuY0cw=;
  b=i/eGOESTJ/sYEQiwZnZeeDjQ/YNgniKsrLuyvF5Bh4Ge1lHghP42/MWa
   JBaegy3NVw0ZQ382Wh+9SBsIb76cRczLCU6Mq8R7eF/KF9XexajVgglf9
   jxZHmGGXHJHS33CmvE2cZWXIEEbJjw1OOIJPZGLQJnIsDQYClUq+a+FIx
   c=;
IronPort-SDR: zduMkEsVALpbqwIL+d7chJpTukXKEJA3nL/ATOHMB+4xhhymXo5D93+A7CGsEmvpIYMONtlXSR
 2PnImn/DFRoQ==
X-IronPort-AV: E=Sophos;i="5.73,434,1583193600"; 
   d="scan'208";a="45833415"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 25 May 2020 21:03:08 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com (Postfix) with ESMTPS id 5C077A2362;
        Mon, 25 May 2020 21:03:08 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 25 May 2020 21:03:07 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.50) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 25 May 2020 21:02:58 +0000
Subject: Re: [PATCH v2 15/18] nitro_enclaves: Add Makefile for the Nitro
 Enclaves driver
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        "Alexander Graf" <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200522062946.28973-1-andraprs@amazon.com>
 <20200522062946.28973-16-andraprs@amazon.com>
 <20200522070927.GG771317@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <82bea29c-e5c4-60e6-76f3-d5662ff37ad2@amazon.com>
Date:   Tue, 26 May 2020 00:02:53 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200522070927.GG771317@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.50]
X-ClientProxiedBy: EX13D34UWA004.ant.amazon.com (10.43.160.177) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMi8wNS8yMDIwIDEwOjA5LCBHcmVnIEtIIHdyb3RlOgo+IE9uIEZyaSwgTWF5IDIyLCAy
MDIwIGF0IDA5OjI5OjQzQU0gKzAzMDAsIEFuZHJhIFBhcmFzY2hpdiB3cm90ZToKPj4gU2lnbmVk
LW9mZi1ieTogQW5kcmEgUGFyYXNjaGl2IDxhbmRyYXByc0BhbWF6b24uY29tPgo+IENoYW5nZWxv
ZyBpcyBuZWVkZWQKCkkgaW5jbHVkZWQgaXQgaW4gdjMuCgpUaGFua3MsCkFuZHJhCgoKCgpBbWF6
b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6
IDI3QSBTZi4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwg
NzAwMDQ1LCBSb21hbmlhLiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1i
ZXIgSjIyLzI2MjEvMjAwNS4K


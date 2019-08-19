Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A746920D0
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 11:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfHSJ50 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 05:57:26 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:55961 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfHSJ50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 05:57:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1566208645; x=1597744645;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=iveYkg8kU/7ePY7D1PCLQ4/L7oW5zWX3wxHw6b4m958=;
  b=OXw2OhL9Jt8sS34SOOmkcz5qnle3lPjo4a+0dWQ1KLgmn5GHf/hoWuwK
   tHHE7NMFlb5AgbO4I/UDMdsaaWwlcDr8h9FyeHmnsiS1vtfLGIw9oQvWe
   wAJhL7jQcLGu0J02hT+VOOuAAEGFHp/A5cwnN+JoSZ2SLFGlXFiaawmXO
   I=;
X-IronPort-AV: E=Sophos;i="5.64,403,1559520000"; 
   d="scan'208";a="747344503"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 19 Aug 2019 09:57:19 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id 380BFA1D77;
        Mon, 19 Aug 2019 09:57:19 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 19 Aug 2019 09:57:18 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.67) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 19 Aug 2019 09:57:16 +0000
Subject: Re: [PATCH v2 04/15] kvm: x86: Add per-VM APICv state debugfs
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
References: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1565886293-115836-5-git-send-email-suravee.suthikulpanit@amd.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <a48080a5-7ece-280d-2c1f-9d3f4c273a8d@amazon.com>
Date:   Mon, 19 Aug 2019 11:57:13 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1565886293-115836-5-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.67]
X-ClientProxiedBy: EX13D13UWB001.ant.amazon.com (10.43.161.156) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 15.08.19 18:25, Suthikulpanit, Suravee wrote:
> Currently, there is no way to tell whether APICv is active
> on a particular VM. This often cause confusion since APICv
> can be deactivated at runtime.
> 
> Introduce a debugfs entry to report APICv state of a VM.
> This creates a read-only file:
> 
>     /sys/kernel/debug/kvm/70860-14/apicv-state
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Shouldn't this first and foremost be a VM ioctl so that user space can 
inquire its own state?


Alex

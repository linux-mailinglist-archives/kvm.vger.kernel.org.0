Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9686465388
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 11:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbfGKJLd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 05:11:33 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:11462 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbfGKJLd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 05:11:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1562836292; x=1594372292;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=h8vAXLNxehuDWXScQMk21N/ACrv7qH3LXJjPEb6jmc4=;
  b=VCzGysPckMUnsyQMBRQ3J08ooR6b3VwXYAgoU6EH77NWRaxdQfeFauTD
   /jY+HlMLG+boXGkmHq8IM6EW0PLfF2kMDpEX26nVtBSNwcKI9JwCJOJI6
   j2aFgmveT2dgl6DUmyyusnGdnBmm3KHnJ+lM9jUkvTZn+s2X/alE/TgK3
   0=;
X-IronPort-AV: E=Sophos;i="5.62,478,1554768000"; 
   d="scan'208";a="404489163"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 11 Jul 2019 09:11:31 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id 4682EA226A;
        Thu, 11 Jul 2019 09:11:29 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 11 Jul 2019 09:11:29 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.67) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 11 Jul 2019 09:11:27 +0000
Subject: Re: [PATCH kvm-unit-tests] arm: Add PL031 test
To:     Peter Maydell <peter.maydell@linaro.org>
CC:     kvm-devel <kvm@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        <kvmarm@lists.cs.columbia.edu>
References: <20190710132724.28350-1-graf@amazon.com>
 <CAFEAcA81mQ780H5EY8uV6AvbXzeZA60eCHoE_n9yzeZgw+ru4w@mail.gmail.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <a29ea772-0565-98cb-61d8-3042b2df39b1@amazon.com>
Date:   Thu, 11 Jul 2019 11:11:25 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAFEAcA81mQ780H5EY8uV6AvbXzeZA60eCHoE_n9yzeZgw+ru4w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.162.67]
X-ClientProxiedBy: EX13P01UWB004.ant.amazon.com (10.43.161.213) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11.07.19 10:51, Peter Maydell wrote:
> On Wed, 10 Jul 2019 at 14:35, Alexander Graf <graf@amazon.com> wrote:
>>
>> This patch adds a unit test for the PL031 RTC that is used in the virt machine.
>> It just pokes basic functionality. I've mostly written it to familiarize myself
>> with the device, but I suppose having the test around does not hurt, as it also
>> exercises the GIC SPI interrupt path.
> 
> 
> Have you tested this against a real hardware pl031? I appreciate
> that the scaffolding to let you do that is probably pretty
> painful, but it would be interesting to test, because I'm
> not really all that confident in the accuracy of QEMU's
> pl031 model. (Notably there are some places where it absolutely
> does not work like the real h/w; in some ways it's a bit
> like "a pl031 that some imaginary firmware has initialized
> and enabled"...)

Do you have any pointers to devices I might own that have one?

Alex

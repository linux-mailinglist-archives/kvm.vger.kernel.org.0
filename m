Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 932484E93A
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 15:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbfFUNd7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 09:33:59 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:29336 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfFUNd6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 09:33:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1561124037; x=1592660037;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=0yQN3yHpskbW+/W2HU8P40dv9EAVdVGELkTZepiuCaQ=;
  b=MQFTorpzmPiTIPj1+OlM7qWYxzVMc/8x41bukRpu+zp0+Y9cEjkFbYsu
   mQC4NLFo8vZLzJpzrTXWcI+RlYS7fAz4GbvBxir64gqvstqjN8MMRwK94
   xQVrEjawMpg1SXKzZKNl5G/MVzblKTJp8RU0kB2rI5HqjH4xzqUIhTsNc
   8=;
X-IronPort-AV: E=Sophos;i="5.62,400,1554768000"; 
   d="scan'208";a="771423491"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 21 Jun 2019 13:33:55 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id 44C67A2311;
        Fri, 21 Jun 2019 13:33:51 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 21 Jun 2019 13:33:50 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.225) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 21 Jun 2019 13:33:46 +0000
Subject: Re: [v2, 1/4] Build target for emulate.o as a userspace binary
To:     Sam Caccavale <samcacc@amazon.de>
CC:     <samcaccavale@gmail.com>, <nmanthey@amazon.de>,
        <wipawel@amazon.de>, <dwmw@amazon.co.uk>, <mpohlack@amazon.de>,
        <karahmed@amazon.de>, <andrew.cooper3@citrix.com>,
        <JBeulich@suse.com>, <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <paullangton4@gmail.com>,
        <anirudhkaushik@google.com>, <x86@kernel.org>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20190612153600.13073-1-samcacc@amazon.de>
 <20190612153600.13073-2-samcacc@amazon.de>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <32e39f46-68ef-c27a-d81a-510ca7e61c89@amazon.com>
Date:   Fri, 21 Jun 2019 15:33:44 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190612153600.13073-2-samcacc@amazon.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.43.162.225]
X-ClientProxiedBy: EX13D25UWB003.ant.amazon.com (10.43.161.33) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12.06.19 17:35, Sam Caccavale wrote:
> This commit contains the minimal set of functionality to build
> afl-harness around arch/x86/emulate.c which allows exercising code
> in that source file, like x86_emulate_insn.  Resolving the
> dependencies was done via GCC's -H flag by get_headers.py.
>
> CR: https://code.amazon.com/reviews/CR-8325546


I'm fairly sure that nobody on the LKML can access this page or even 
remotely cares about it ;).

Also, your patches are missing an SoB line.


Alex


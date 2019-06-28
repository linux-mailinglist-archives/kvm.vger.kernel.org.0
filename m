Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2CC59612
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 10:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfF1I1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 04:27:46 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:16802 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfF1I1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 04:27:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1561710465; x=1593246465;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=oIjjlNBlwRk0e8pvJQOPWBRb0qZbjdv8AQ9bfQPJjOM=;
  b=MmI04jRs5RB4pVOLH+CeZDCKbUr1BmxCRVbEgTJVd6TkUgqV8+vblP07
   JXVlzWL9EKTXHqUTKtxqbjG5bvFO5b71E/rj9JyW+khC7iSPwY7IFrVfE
   1iT01EsUHK4pcLd6AaiKKt8jjT1O7ojWtPn93oXTk92D6Z+nNqpBptWgM
   I=;
X-IronPort-AV: E=Sophos;i="5.62,426,1554768000"; 
   d="scan'208";a="682652138"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 28 Jun 2019 08:27:37 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com (Postfix) with ESMTPS id A1129A20B5;
        Fri, 28 Jun 2019 08:27:36 +0000 (UTC)
Received: from EX13D20UWC004.ant.amazon.com (10.43.162.41) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 28 Jun 2019 08:27:36 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D20UWC004.ant.amazon.com (10.43.162.41) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 28 Jun 2019 08:27:35 +0000
Received: from u6cf1b7119fa15b.ant.amazon.com (10.28.85.98) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 28 Jun 2019 08:27:32 +0000
Subject: Re: [PATCH v3 4/5] Added build and install scripts
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <graf@amazon.com>,
        Sam Caccavale <samcacc@amazon.de>
CC:     <samcaccavale@gmail.com>, <nmanthey@amazon.de>,
        <wipawel@amazon.de>, <dwmw@amazon.co.uk>, <mpohlack@amazon.de>,
        <karahmed@amazon.de>, <andrew.cooper3@citrix.com>,
        <JBeulich@suse.com>, <rkrcmar@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <paullangton4@gmail.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20190624142414.22096-1-samcacc@amazon.de>
 <20190624142414.22096-5-samcacc@amazon.de>
 <e0b29f4d-7471-c5d8-c9d4-2a352831a4bd@amazon.com>
 <6fa5e9de-7b66-76ba-0b98-e11f890e076a@amazon.com>
 <4438c94e-a0ed-0e5c-0a74-02aed8949b24@redhat.com>
From:   <samcacc@amazon.com>
Message-ID: <8f9e2dd8-f83f-0685-5939-33e77d97a6c6@amazon.com>
Date:   Fri, 28 Jun 2019 10:27:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <4438c94e-a0ed-0e5c-0a74-02aed8949b24@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/28/19 10:17 AM, Paolo Bonzini wrote:
> On 28/06/19 09:59, samcacc@amazon.com wrote:
>>> Surely if it's important to generate core dumps, it's not only important
>>> during installation, no?
>> Yep... missed this.  I'll move it to run.sh right before alf-many is
>> invoked.  It would be nice to not have to sudo but it seems the only
>> alternative is an envvar AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES which
>> just ignores AFL's warning if your system isn't going to produce core
>> dumps (which will cause AFL to miss some crashes, as the name suggests).
> 
> Can you do this only if /proc/sys/kernel/core_pattern starts with a pipe
> sign?
> 

I think I'll just remove the `echo > ...core_pattern` step from both the
build.sh and run.sh scripts and instead document it as a setup step in
the README.  This also sidesteps the sudo use.

- Sam

> Thanks,
> 
> Paolo
> 


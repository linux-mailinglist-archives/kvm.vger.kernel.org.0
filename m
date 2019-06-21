Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 261624E92C
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 15:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbfFUNa1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 09:30:27 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:54651 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfFUNa1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 09:30:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1561123826; x=1592659826;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=SKySCs7j8cyYDZiLXPPcbo5tvJi2ii0pqqcOJAm/4wg=;
  b=B2yCTaB8aNYBX51ya8IoFoIs/2EePRgaEuzovjbse6bwlnT4lr4P0t09
   J8+bBIurvDUdl8ldVXXwBHFPgqhWn1ahI30iAa9Hw8YfiPGJub03+5NNo
   YjU1qhG1d45jzXe7wPJMi83648aOJk6slyiYucurH9mFCKG+Oop2Dhr4n
   A=;
X-IronPort-AV: E=Sophos;i="5.62,400,1554768000"; 
   d="scan'208";a="401780754"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 21 Jun 2019 13:30:24 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (Postfix) with ESMTPS id 078D9A2A35;
        Fri, 21 Jun 2019 13:30:19 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 21 Jun 2019 13:30:19 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.166) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 21 Jun 2019 13:30:13 +0000
Subject: Re: [v2, 0/4] x86 instruction emulator fuzzing
To:     Sam Caccavale <samcacc@amazon.de>
CC:     <samcaccavale@gmail.com>, <nmanthey@amazon.de>,
        <wipawel@amazon.de>, <dwmw@amazon.co.uk>, <mpohlack@amazon.de>,
        <graf@amazon.de>, <karahmed@amazon.de>,
        <andrew.cooper3@citrix.com>, <JBeulich@suse.com>,
        <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <paullangton4@gmail.com>, <anirudhkaushik@google.com>,
        <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20190612153600.13073-1-samcacc@amazon.de>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <305788a1-afe8-add8-10ee-d738b76867bc@amazon.com>
Date:   Fri, 21 Jun 2019 15:30:11 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190612153600.13073-1-samcacc@amazon.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.43.161.166]
X-ClientProxiedBy: EX13d09UWC004.ant.amazon.com (10.43.162.114) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12.06.19 17:35, Sam Caccavale wrote:
> Dear all,
>
> This series aims to provide an entrypoint for, and fuzz KVM's x86 instruction
> emulator from userspace.  It mirrors Xen's application of the AFL fuzzer to
> it's instruction emulator in the hopes of discovering vulnerabilities.
> Since this entrypoint also allows arbitrary execution of the emulators code
> from userspace, it may also be useful for testing.
>
> The current 4 patches build the emulator and 2 harnesses: simple-harness is
> an example of unit testing; afl-harness is a frontend for the AFL fuzzer.
>
> Patches
> =======
>
> - 01: Builds and links afl-harness with the required kernel objects.
> - 02: Introduces the minimal set of emulator operations and supporting code
> to emulate simple instructions.
> - 03: Demonstrates simple-harness as a unit test.
> - 04: Adds scripts for install, running, and crash triage.
>
> Any comments/suggestions are greatly appreciated.


The cover letter as well as the individual patches are missing a change 
log from v1 to v2.



Alex



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9462B25AB0F
	for <lists+kvm@lfdr.de>; Wed,  2 Sep 2020 14:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgIBMX2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Sep 2020 08:23:28 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:57076 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbgIBMXV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Sep 2020 08:23:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599049401; x=1630585401;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=aaMnmyUtzKB+LBJO6DfMwrUDuuweN8BDnKWIu/3fO5k=;
  b=sqapOSSFi4U07DZM0xBsLGbSgUlnU5pw0fc+fQlzjoWUnr5iLr2tMYjZ
   u5s9IxVEmHp5idAEH73pwZgzSym/7wQ7PxG+1Xhhb4Cn6BrcJQ78Vn1cH
   Oxq1Ccyu/cYKmkXOq6czemntEGdbe6mrmtRJ5TOQdSCIegnBz/MAdKY7Y
   8=;
X-IronPort-AV: E=Sophos;i="5.76,383,1592870400"; 
   d="scan'208";a="51447181"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-e7be2041.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 02 Sep 2020 12:23:09 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-e7be2041.us-west-2.amazon.com (Postfix) with ESMTPS id E8310A1991;
        Wed,  2 Sep 2020 12:23:07 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 2 Sep 2020 12:23:07 +0000
Received: from Alexanders-MacBook-Air.local (10.43.160.6) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 2 Sep 2020 12:23:04 +0000
Subject: Re: [PATCH v2 1/2] KVM: arm64: Add PMU event filtering infrastructure
To:     Marc Zyngier <maz@kernel.org>
CC:     Auger Eric <eric.auger@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>, <kvm@vger.kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Robin Murphy <robin.murphy@arm.com>,
        <kvmarm@lists.cs.columbia.edu>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20200309124837.19908-1-maz@kernel.org>
 <20200309124837.19908-2-maz@kernel.org>
 <70e712fc-6789-2384-c21c-d932b5e1a32f@redhat.com>
 <0027398587e8746a6a7459682330855f@kernel.org>
 <7c9e2e55-95c8-a212-e566-c48f5d3bc417@redhat.com>
 <470c88271ef8c4f92ecf990b7b86658e@kernel.org>
 <0647b63c-ac27-8ec9-c9da-9a5e5163cb5d@amazon.com>
 <18b9ff6f9a65546f55dd2e7019d48986@kernel.org>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <e9d669ee-5e95-e526-fc0e-ccb4ce0bc7e1@amazon.com>
Date:   Wed, 2 Sep 2020 14:23:02 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.0
MIME-Version: 1.0
In-Reply-To: <18b9ff6f9a65546f55dd2e7019d48986@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.43.160.6]
X-ClientProxiedBy: EX13D50UWA004.ant.amazon.com (10.43.163.5) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20.08.20 09:37, Marc Zyngier wrote:
> =

> On 2020-08-19 00:24, Alexander Graf wrote:
>> Hi Marc,
> =

> [...]
> =

>> I haven't seen a v3 follow-up after this. Do you happen to have that
>> somewhere in a local branch and just need to send it out or would you
>> prefer if I pick up v2 and address the comments?
> =

> I'll look into it.

Thank you :)


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879




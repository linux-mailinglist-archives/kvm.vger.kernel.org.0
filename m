Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98C6EA0A8A
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 21:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfH1Tgz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 15:36:55 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:14643 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbfH1Tgz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 15:36:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1567021015; x=1598557015;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version:content-transfer-encoding;
  bh=/ieIgDg1e+Xm67zWPlwQnf9WuQYrrH8QP9NJLlLyXq0=;
  b=rjORbW3ojaP5kcZdTla74pAA1uCpzUQTXogtc4l0dTS01piCX4DdfRXT
   CwspEAGlF+vILmdxsdME1kxNqmcP4VOMrmYIwHtf5wU+mJt+pKhX5M49F
   0BezJPQ2tnYArGkPbzrCjmReERnWMWWBhUn+U9KlS2XukTXpgHtq7OtQW
   U=;
X-IronPort-AV: E=Sophos;i="5.64,442,1559520000"; 
   d="scan'208";a="698505670"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2b-81e76b79.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 28 Aug 2019 19:36:07 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-81e76b79.us-west-2.amazon.com (Postfix) with ESMTPS id BFA01A2399;
        Wed, 28 Aug 2019 19:36:06 +0000 (UTC)
Received: from EX13D01EUB001.ant.amazon.com (10.43.166.194) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 28 Aug 2019 19:36:06 +0000
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13D01EUB001.ant.amazon.com (10.43.166.194) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 28 Aug 2019 19:36:05 +0000
Received: from EX13D20UWC001.ant.amazon.com ([10.43.162.244]) by
 EX13D20UWC001.ant.amazon.com ([10.43.162.244]) with mapi id 15.00.1367.000;
 Wed, 28 Aug 2019 19:36:03 +0000
From:   "Graf (AWS), Alexander" <graf@amazon.de>
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Schoenherr, Jan H." <jschoenh@amazon.de>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        "Lukaszewicz, Rimas" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
Subject: Re: [PATCH v2 04/15] kvm: x86: Add per-VM APICv state debugfs
Thread-Topic: [PATCH v2 04/15] kvm: x86: Add per-VM APICv state debugfs
Thread-Index: AQHVU4YAxicok8C98kOOsiSZW3JVFacCQeaAgAujmoCAANQngIACP0YAgAAPr4U=
Date:   Wed, 28 Aug 2019 19:36:03 +0000
Message-ID: <9A47CE02-18B0-40C3-962A-D317A32F2073@amazon.de>
References: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1565886293-115836-5-git-send-email-suravee.suthikulpanit@amd.com>
 <a48080a5-7ece-280d-2c1f-9d3f4c273a8d@amazon.com>
 <049c0f98-bd89-ee3c-7869-92972f2d7c31@amd.com>
 <f9c62280-efb4-197d-1444-fce8f3d15132@amazon.com>,<1bfccb79-5ace-0dba-a201-e069f77f740a@amd.com>
In-Reply-To: <1bfccb79-5ace-0dba-a201-e069f77f740a@amd.com>
Accept-Language: en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> Am 28.08.2019 um 20:41 schrieb Suthikulpanit, Suravee <Suravee.Suthikulpa=
nit@amd.com>:
> =

> Alex,
> =

>> On 8/27/19 3:20 AM, Alexander Graf wrote:
>> =

>> =

>>> On 26.08.19 21:41, Suthikulpanit, Suravee wrote:
>>> Alex,
>>> =

>>>> On 8/19/2019 4:57 AM, Alexander Graf wrote:
>>>> =

>>>> =

>>>>> On 15.08.19 18:25, Suthikulpanit, Suravee wrote:
>>>>> Currently, there is no way to tell whether APICv is active
>>>>> on a particular VM. This often cause confusion since APICv
>>>>> can be deactivated at runtime.
>>>>> =

>>>>> Introduce a debugfs entry to report APICv state of a VM.
>>>>> This creates a read-only file:
>>>>> =

>>>>>      /sys/kernel/debug/kvm/70860-14/apicv-state
>>>>> =

>>>>> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>>>> =

>>>> Shouldn't this first and foremost be a VM ioctl so that user space =

>>>> can inquire its own state?
>>>> =

>>>> =

>>>> Alex
>>> =

>>> I introduce this mainly for debugging similar to how KVM is currently =

>>> provides
>>> some per-VCPU information:
>>> =

>>>       /sys/kernel/debug/kvm/15957-14/vcpu0/
>>>           lapic_timer_advance_ns
>>>           tsc-offset
>>>           tsc-scaling-ratio
>>>           tsc-scaling-ratio-frac-bits
>>> =

>>> I'm not sure if this needs to be VM ioctl at this point. If this =

>>> information is
>>> useful for user-space tool to inquire via ioctl, we can also provide it.
>> =

>> I'm mostly thinking of something like "info apic" in QEMU which to me =

>> seems like the natural place for APIC information exposure to a user.
> =

> I could not find QEMU "info apic". I assume you meant "info lapic", =

> which provides information specific to each local APIC (i.e. per-vcpu).

Or maybe even "info kvm" :). I think you get the point.

> =

>> The problem with debugfs is that it's not accessible to the user that =

>> created the VM, but only root, right?
> =

> Hm, you are right. I'll also look into also adding ioctl interface then.

Thanks!

Alex




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879




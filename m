Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9737F20B14
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 17:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfEPPZH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 11:25:07 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:25987 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbfEPPZH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 11:25:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1558020306; x=1589556306;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:mime-version:
   content-transfer-encoding;
  bh=kUZ9rEq+loBEpuV/agF7lMwxuKWMwuSBBWGCLZkR43o=;
  b=gj0/FSOvM4dQoxmEbvnqIs8YNp1mgLWUaf3Vp92IlAIsZ6DjphFkww0s
   JEUFn/d5bhbxCp0y/SW7k89wFTjNgywB/rU/oKeoAFdLatmU5PgZEBgkv
   /VinmJlon51HeH1HGBZoqVTLlqxBzNpQ7GUK23WhqWwveNz/a81QxxPpP
   g=;
X-IronPort-AV: E=Sophos;i="5.60,477,1549929600"; 
   d="scan'208";a="733383237"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-3714e498.us-west-2.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 16 May 2019 15:25:03 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-3714e498.us-west-2.amazon.com (8.14.7/8.14.7) with ESMTP id x4GFOu5J042984
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 16 May 2019 15:25:02 GMT
Received: from EX13D02EUC002.ant.amazon.com (10.43.164.14) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 16 May 2019 15:25:01 +0000
Received: from EX13D02EUC001.ant.amazon.com (10.43.164.92) by
 EX13D02EUC002.ant.amazon.com (10.43.164.14) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 16 May 2019 15:25:00 +0000
Received: from EX13D02EUC001.ant.amazon.com ([10.43.164.92]) by
 EX13D02EUC001.ant.amazon.com ([10.43.164.92]) with mapi id 15.00.1367.000;
 Thu, 16 May 2019 15:25:00 +0000
From:   "Sironi, Filippo" <sironi@amazon.de>
To:     "Graf, Alexander" <graf@amazon.com>
CC:     LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "vasu.srinivasan@oracle.com" <vasu.srinivasan@oracle.com>
Subject: Re: [PATCH v2 2/2] KVM: x86: Implement the arch-specific hook to
 report the VM UUID
Thread-Topic: [PATCH v2 2/2] KVM: x86: Implement the arch-specific hook to
 report the VM UUID
Thread-Index: AQHVCmgxSNZRVPU/lkacpReSlg9JAaZtyWCAgAAY24A=
Date:   Thu, 16 May 2019 15:25:00 +0000
Message-ID: <7395EFE9-0B38-4B61-81D4-E8450561AABE@amazon.de>
References: <1539078879-4372-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-3-git-send-email-sironi@amazon.de>
 <f51a6a84-b21c-ab75-7e30-bfbe2ac6b98b@amazon.com>
In-Reply-To: <f51a6a84-b21c-ab75-7e30-bfbe2ac6b98b@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.108]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <322B72780715F949BC86D7AC0C1B0C37@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On 16. May 2019, at 15:56, Graf, Alexander <graf@amazon.com> wrote:
> =

> On 14.05.19 08:16, Filippo Sironi wrote:
>> On x86, we report the UUID in DMI System Information (i.e., DMI Type 1)
>> as VM UUID.
>> =

>> Signed-off-by: Filippo Sironi <sironi@amazon.de>
>> ---
>> arch/x86/kernel/kvm.c | 7 +++++++
>> 1 file changed, 7 insertions(+)
>> =

>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>> index 5c93a65ee1e5..441cab08a09d 100644
>> --- a/arch/x86/kernel/kvm.c
>> +++ b/arch/x86/kernel/kvm.c
>> @@ -25,6 +25,7 @@
>> #include <linux/kernel.h>
>> #include <linux/kvm_para.h>
>> #include <linux/cpu.h>
>> +#include <linux/dmi.h>
>> #include <linux/mm.h>
>> #include <linux/highmem.h>
>> #include <linux/hardirq.h>
>> @@ -694,6 +695,12 @@ bool kvm_para_available(void)
>> }
>> EXPORT_SYMBOL_GPL(kvm_para_available);
>> =

>> +const char *kvm_para_get_uuid(void)
>> +{
>> +	return dmi_get_system_info(DMI_PRODUCT_UUID);
> =

> This adds a new dependency on CONFIG_DMI. Probably best to guard it with
> an #if IS_ENABLED(CONFIG_DMI).
> =

> The concept seems sound though.
> =

> Alex

include/linux/dmi.h contains a dummy implementation of
dmi_get_system_info that returns NULL if CONFIG_DMI isn't defined.
This is enough unless we decide to return "<denied>" like in Xen.
If then, we can have the check in the generic code to turn NULL
into "<denied>".

Filippo


>> +}
>> +EXPORT_SYMBOL_GPL(kvm_para_get_uuid);
>> +
>> unsigned int kvm_arch_para_features(void)
>> {
>> 	return cpuid_eax(kvm_cpuid_base() | KVM_CPUID_FEATURES);




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrer: Christian Schlaeger, Ralf Herbrich
Ust-ID: DE 289 237 879
Eingetragen am Amtsgericht Charlottenburg HRB 149173 B



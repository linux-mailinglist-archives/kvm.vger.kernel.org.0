Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E653820E1F
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 19:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbfEPRlU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 13:41:20 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:21607 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbfEPRlT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 13:41:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1558028479; x=1589564479;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:mime-version:
   content-transfer-encoding;
  bh=EeOQ/Wytv7i1KUb9By3pdfsSR47KzNNS8UhnNVxMV0c=;
  b=XG3L1ZDQJWGZ5SuWV2k7qRXcNxOWObaBWd3Fx1tL+6oU5Vs1olC6fZSh
   KySUG1zvZKYHfa9nhOkH0nks20O4D83IHmfm3pHhBkr/ZEytKw6t1aZN6
   OdPd+t6xMLx/pyao9b3PljtAuqnoklS0kEDGvWjo8/K+RAb5HNbnw9BrP
   I=;
X-IronPort-AV: E=Sophos;i="5.60,477,1549929600"; 
   d="scan'208";a="674734250"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 16 May 2019 17:41:16 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (8.14.7/8.14.7) with ESMTP id x4GHfGfX061565
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 16 May 2019 17:41:16 GMT
Received: from EX13D02EUC001.ant.amazon.com (10.43.164.92) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 16 May 2019 17:41:15 +0000
Received: from EX13D02EUC001.ant.amazon.com (10.43.164.92) by
 EX13D02EUC001.ant.amazon.com (10.43.164.92) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 16 May 2019 17:41:14 +0000
Received: from EX13D02EUC001.ant.amazon.com ([10.43.164.92]) by
 EX13D02EUC001.ant.amazon.com ([10.43.164.92]) with mapi id 15.00.1367.000;
 Thu, 16 May 2019 17:41:14 +0000
From:   "Sironi, Filippo" <sironi@amazon.de>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC:     "Graf, Alexander" <graf@amazon.com>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "vasu.srinivasan@oracle.com" <vasu.srinivasan@oracle.com>
Subject: Re: [PATCH v2 2/2] KVM: x86: Implement the arch-specific hook to
 report the VM UUID
Thread-Topic: [PATCH v2 2/2] KVM: x86: Implement the arch-specific hook to
 report the VM UUID
Thread-Index: AQHVCmgxSNZRVPU/lkacpReSlg9JAaZtyWCAgAAY24CAAAJ4gIAAErUAgAAQ44A=
Date:   Thu, 16 May 2019 17:41:13 +0000
Message-ID: <DD0087B6-094D-4D07-9C85-827881E3DDD0@amazon.de>
References: <1539078879-4372-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-3-git-send-email-sironi@amazon.de>
 <f51a6a84-b21c-ab75-7e30-bfbe2ac6b98b@amazon.com>
 <7395EFE9-0B38-4B61-81D4-E8450561AABE@amazon.de>
 <8c6a2de2-f080-aad5-16af-c4a5eafb31af@amazon.com>
 <3a9762a2-24e8-a842-862d-fadae563361d@oracle.com>
In-Reply-To: <3a9762a2-24e8-a842-862d-fadae563361d@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.224]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <26EC1043BA52854DA988B6F84C5E0C27@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On 16. May 2019, at 18:40, Boris Ostrovsky <boris.ostrovsky@oracle.com> w=
rote:
> =

> On 5/16/19 11:33 AM, Alexander Graf wrote:
>> On 16.05.19 08:25, Sironi, Filippo wrote:
>>>> On 16. May 2019, at 15:56, Graf, Alexander <graf@amazon.com> wrote:
>>>> =

>>>> On 14.05.19 08:16, Filippo Sironi wrote:
>>>>> On x86, we report the UUID in DMI System Information (i.e., DMI Type =
1)
>>>>> as VM UUID.
>>>>> =

>>>>> Signed-off-by: Filippo Sironi <sironi@amazon.de>
>>>>> ---
>>>>> arch/x86/kernel/kvm.c | 7 +++++++
>>>>> 1 file changed, 7 insertions(+)
>>>>> =

>>>>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>>>>> index 5c93a65ee1e5..441cab08a09d 100644
>>>>> --- a/arch/x86/kernel/kvm.c
>>>>> +++ b/arch/x86/kernel/kvm.c
>>>>> @@ -25,6 +25,7 @@
>>>>> #include <linux/kernel.h>
>>>>> #include <linux/kvm_para.h>
>>>>> #include <linux/cpu.h>
>>>>> +#include <linux/dmi.h>
>>>>> #include <linux/mm.h>
>>>>> #include <linux/highmem.h>
>>>>> #include <linux/hardirq.h>
>>>>> @@ -694,6 +695,12 @@ bool kvm_para_available(void)
>>>>> }
>>>>> EXPORT_SYMBOL_GPL(kvm_para_available);
>>>>> =

>>>>> +const char *kvm_para_get_uuid(void)
>>>>> +{
>>>>> +	return dmi_get_system_info(DMI_PRODUCT_UUID);
>>>> This adds a new dependency on CONFIG_DMI. Probably best to guard it wi=
th
>>>> an #if IS_ENABLED(CONFIG_DMI).
>>>> =

>>>> The concept seems sound though.
>>>> =

>>>> Alex
>>> include/linux/dmi.h contains a dummy implementation of
>>> dmi_get_system_info that returns NULL if CONFIG_DMI isn't defined.
>> =

>> Oh, I missed that bit. Awesome! Less work :).
>> =

>> =

>>> This is enough unless we decide to return "<denied>" like in Xen.
>>> If then, we can have the check in the generic code to turn NULL
>>> into "<denied>".
>> =

>> Yes. Waiting for someone from Xen to answer this :)
> =

> Not sure I am answering your question but on Xen we return UUID value
> zero if access permissions are not sufficient. Not <denied>.
> =

> http://xenbits.xen.org/gitweb/?p=3Dxen.git;a=3Dblob;f=3Dxen/common/kernel=
.c;h=3D612575430f1ce7faf5bd66e7a99f1758c63fb3cb;hb=3DHEAD#l506
> =

> -boris

Then, I believe that returning 00000000-0000-0000-0000-000000000000
instead of NULL in the weak implementation of 1/2 and translating
NULL into 00000000-0000-0000-0000-000000000000 is the better approach.

I'll repost.

Filippo





Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrer: Christian Schlaeger, Ralf Herbrich
Ust-ID: DE 289 237 879
Eingetragen am Amtsgericht Charlottenburg HRB 149173 B



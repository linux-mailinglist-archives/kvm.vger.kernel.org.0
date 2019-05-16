Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C77420AE7
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 17:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbfEPPOY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 11:14:24 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:20354 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbfEPPOY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 11:14:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1558019662; x=1589555662;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:mime-version:
   content-transfer-encoding;
  bh=aig0jPNztAGTfLrveYmFoH55ckuO8R7q/yjW4HU7drI=;
  b=iLghvfw7DmDA9oQ8+pD3fZJ8tfQBAcqoTsSof03pQz5NQtxfIF5gZNze
   77VeFBmdUtotNCjrQa0lMLfgbEp/m1BkHc2jKKfHt8pyY0T+/84schARa
   7RNr3cdBwry6M0njpPMlqe1BxVLxXLmBvLAi/oQPqpwUiET3aCQynh8x0
   o=;
X-IronPort-AV: E=Sophos;i="5.60,477,1549929600"; 
   d="scan'208";a="800025988"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 16 May 2019 15:14:18 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com (8.14.7/8.14.7) with ESMTP id x4GFEEo0036922
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 16 May 2019 15:14:18 GMT
Received: from EX13D02EUC003.ant.amazon.com (10.43.164.10) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 16 May 2019 15:14:17 +0000
Received: from EX13D02EUC001.ant.amazon.com (10.43.164.92) by
 EX13D02EUC003.ant.amazon.com (10.43.164.10) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 16 May 2019 15:14:16 +0000
Received: from EX13D02EUC001.ant.amazon.com ([10.43.164.92]) by
 EX13D02EUC001.ant.amazon.com ([10.43.164.92]) with mapi id 15.00.1367.000;
 Thu, 16 May 2019 15:14:16 +0000
From:   "Sironi, Filippo" <sironi@amazon.de>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC:     "Graf, Alexander" <graf@amazon.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: Re: [Xen-devel] [PATCH v2 1/2] KVM: Start populating /sys/hypervisor
 with KVM entries
Thread-Topic: [Xen-devel] [PATCH v2 1/2] KVM: Start populating /sys/hypervisor
 with KVM entries
Thread-Index: AQHVCmguTMwTmVyYP0+tMrT8Z/dQMaZtx8qAgAADQgCAAAG8gIAADxmAgAADWQA=
Date:   Thu, 16 May 2019 15:14:16 +0000
Message-ID: <649AEBAC-8408-4BC0-AA22-F721CC23648D@amazon.de>
References: <1539078879-4372-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-2-git-send-email-sironi@amazon.de>
 <e976f31b-2ccd-29ba-6a32-2edde49f867f@amazon.com>
 <7aae3e49-5b1c-96d1-466e-5b061305dc9d@citrix.com>
 <22fadfb1-e48d-ccb6-0e42-c105b7335d7a@amazon.com>
 <92f2f186-2e29-d798-84bd-7209e874f103@oracle.com>
In-Reply-To: <92f2f186-2e29-d798-84bd-7209e874f103@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.224]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6E2A8B9BB2A14F4E92BDE4A9FB721974@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On 16. May 2019, at 17:02, Boris Ostrovsky <boris.ostrovsky@oracle.com> w=
rote:
> =

> On 5/16/19 10:08 AM, Alexander Graf wrote:
>> =

>> My point is mostly that we should be as common
>> as possible when it comes to /sys/hypervisor, so that tools don't have
>> to care about the HV they're working against.
> =

> It might make sense to have a common sys-hypervisor.c file
> (drivers/hypervisor/sys-hypervisor.c or some such), with
> hypervisor-specific ops/callbacks/etc.
> =

> -boris


Yes, it definitely does. I would follow up with future patches to make it
happen.

Filippo





Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrer: Christian Schlaeger, Ralf Herbrich
Ust-ID: DE 289 237 879
Eingetragen am Amtsgericht Charlottenburg HRB 149173 B



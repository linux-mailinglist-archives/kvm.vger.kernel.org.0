Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4878E38332
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 05:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfFGDri (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 23:47:38 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:12851 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbfFGDri (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 23:47:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559879257; x=1591415257;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=f7lUzX077j1bK+7o5EYCdBbsguKVU9Cl/73eEhYfufY=;
  b=F/Hv+9K1rip4ShMRQ0xBIoEBBC9AJp+TtVaTnxweQaO0GHiiVt4o1YfO
   RCIMiNMaNOjS6AKZur7GqwZsyzPlHlPsKMFBnImUGJEXRKVeaPCKN9ddy
   BH2UwrVJmuV5q6PPvIMzxWfvBAtZQQjMNZ2noHungzMn1g79wZ5D2+1ES
   w=;
X-IronPort-AV: E=Sophos;i="5.60,561,1549929600"; 
   d="scan'208";a="405435519"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 07 Jun 2019 03:47:36 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com (Postfix) with ESMTPS id AE93FA2494;
        Fri,  7 Jun 2019 03:47:33 +0000 (UTC)
Received: from EX13D01EUB003.ant.amazon.com (10.43.166.248) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 7 Jun 2019 03:47:32 +0000
Received: from EX13D02UWC004.ant.amazon.com (10.43.162.236) by
 EX13D01EUB003.ant.amazon.com (10.43.166.248) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 7 Jun 2019 03:47:31 +0000
Received: from EX13D02UWC004.ant.amazon.com ([10.43.162.236]) by
 EX13D02UWC004.ant.amazon.com ([10.43.162.236]) with mapi id 15.00.1367.000;
 Fri, 7 Jun 2019 03:47:30 +0000
From:   "Saidi, Ali" <alisaidi@amazon.com>
To:     Marc Zyngier <marc.zyngier@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        Julien Thierry <julien.thierry@arm.com>,
        "Christoffer Dall" <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        "James Morse" <james.morse@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 1/8] KVM: arm/arm64: vgic: Add LPI translation cache
 definition
Thread-Topic: [PATCH 1/8] KVM: arm/arm64: vgic: Add LPI translation cache
 definition
Thread-Index: AQHVHIi1OiXXp0Fy/EqmaDNzW4giDKaPOpGA
Date:   Fri, 7 Jun 2019 03:47:29 +0000
Message-ID: <3698E5F4-6E33-4175-9EA0-7CB961705264@amazon.com>
References: <20190606165455.162478-1-marc.zyngier@arm.com>
 <20190606165455.162478-2-marc.zyngier@arm.com>
In-Reply-To: <20190606165455.162478-2-marc.zyngier@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.160.73]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C746183BA199164FBEAB119812CB66A1@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQrvu79PbiA2LzYvMTksIDExOjU1IEFNLCAiTWFyYyBaeW5naWVyIiA8bWFyYy56eW5naWVyQGFy
bS5jb20+IHdyb3RlOg0KDQogICAgQWRkIHRoZSBiYXNpYyBkYXRhIHN0cnVjdHVyZSB0aGF0IGV4
cHJlc3NlcyBhbiBNU0kgdG8gTFBJDQogICAgdHJhbnNsYXRpb24gYXMgd2VsbCBhcyB0aGUgYWxs
b2NhdGlvbi9yZWxlYXNlIGhvb2tzLg0KICAgIA0KICAgIFRIZSBzaXplIG9mIHRoZSBjYWNoZSBp
cyBhcmJpdHJhcmlseSBkZWZpbmVkIGFzIDQqbnJfdmNwdXMuDQoNCkEgY2FjaGUgc2l6ZSBvZiA4
L3ZDUFUgc2hvdWxkIHJlc3VsdCBpbiBjYWNoZSBoaXRzIGluIG1vc3QgY2FzZXMgYW5kIDE2L3ZD
UFUgd2lsbCBwcmV0dHkgbXVjaCBhbHdheXMgcmVzdWx0IGluIGEgY2FjaGUgaGl0Lg0KDQpBbGkN
Cg0KDQo=

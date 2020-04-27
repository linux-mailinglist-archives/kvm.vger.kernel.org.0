Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F0A1B9920
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 09:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgD0H5L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 03:57:11 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:37736 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgD0H5K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 03:57:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587974229; x=1619510229;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=r6kxjfVdGRB2Y5Se4e/fZ3NmsmVLSqy1TQ/xjnJh7n4=;
  b=nNXHUYXTkqM19KUVRTzK49HEvSYsncDqST5Lj3eEgqACR3gEiwsBoSvV
   vXVxSqVVoAboCfeZSLb3PMFN56uB3PX4rhzMlPE7weXE65Tuc0/90M3ne
   QBAPWeU5jP8Dpzf+x4yDzr1uke3ig4IA0tEY5rOwUyg5IZ8DErl0wKs88
   c=;
IronPort-SDR: qsmjE1jGly+zLYPOVIE5xUO/EK6EtncPOjLGM6oE73vskBirxK/cOXF+8nWn33ePwUgKEnFCF2
 M3D6RsPifr4Q==
X-IronPort-AV: E=Sophos;i="5.73,323,1583193600"; 
   d="scan'208";a="27496939"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-168cbb73.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 27 Apr 2020 07:56:51 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-168cbb73.us-west-2.amazon.com (Postfix) with ESMTPS id 4E821A1898;
        Mon, 27 Apr 2020 07:56:50 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 27 Apr 2020 07:56:49 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.70) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 27 Apr 2020 07:56:41 +0000
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
To:     Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>, Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200421184150.68011-1-andraprs@amazon.com>
 <18406322-dc58-9b59-3f94-88e6b638fe65@redhat.com>
 <ff65b1ed-a980-9ddc-ebae-996869e87308@amazon.com>
 <5c514de6-52a8-8532-23d9-e6b0cc9ac7eb@oracle.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <eb92ba4e-113e-d7ec-4633-f6b5ac54796b@amazon.com>
Date:   Mon, 27 Apr 2020 10:56:31 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <5c514de6-52a8-8532-23d9-e6b0cc9ac7eb@oracle.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.70]
X-ClientProxiedBy: EX13D31UWA004.ant.amazon.com (10.43.160.217) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNS8wNC8yMDIwIDE4OjI1LCBMaXJhbiBBbG9uIHdyb3RlOgo+Cj4gT24gMjMvMDQvMjAy
MCAxNjoxOSwgUGFyYXNjaGl2LCBBbmRyYS1JcmluYSB3cm90ZToKPj4KPj4gVGhlIG1lbW9yeSBh
bmQgQ1BVcyBhcmUgY2FydmVkIG91dCBvZiB0aGUgcHJpbWFyeSBWTSwgdGhleSBhcmUgCj4+IGRl
ZGljYXRlZCBmb3IgdGhlIGVuY2xhdmUuIFRoZSBOaXRybyBoeXBlcnZpc29yIHJ1bm5pbmcgb24g
dGhlIGhvc3QgCj4+IGVuc3VyZXMgbWVtb3J5IGFuZCBDUFUgaXNvbGF0aW9uIGJldHdlZW4gdGhl
IHByaW1hcnkgVk0gYW5kIHRoZSAKPj4gZW5jbGF2ZSBWTS4KPiBJIGhvcGUgeW91IHByb3Blcmx5
IHRha2UgaW50byBjb25zaWRlcmF0aW9uIEh5cGVyLVRocmVhZGluZyAKPiBzcGVjdWxhdGl2ZSBz
aWRlLWNoYW5uZWwgdnVsbmVyYWJpbGl0aWVzIGhlcmUuCj4gaS5lLiBVc3VhbGx5IGNsb3VkIHBy
b3ZpZGVycyBkZXNpZ25hdGUgZWFjaCBDUFUgY29yZSB0byBiZSBhc3NpZ25lZCB0byAKPiBydW4g
b25seSB2Q1BVcyBvZiBzcGVjaWZpYyBndWVzdC4gVG8gYXZvaWQgc2hhcmluZyBhIHNpbmdsZSBD
UFUgY29yZSAKPiBiZXR3ZWVuIG11bHRpcGxlIGd1ZXN0cy4KPiBUbyBoYW5kbGUgdGhpcyBwcm9w
ZXJseSwgeW91IG5lZWQgdG8gdXNlIHNvbWUga2luZCBvZiBjb3JlLXNjaGVkdWxpbmcgCj4gbWVj
aGFuaXNtIChTdWNoIHRoYXQgZWFjaCBDUFUgY29yZSBlaXRoZXIgcnVucyBvbmx5IHZDUFVzIG9m
IGVuY2xhdmUgCj4gb3Igb25seSB2Q1BVcyBvZiBwcmltYXJ5IFZNIGF0IGFueSBnaXZlbiBwb2lu
dCBpbiB0aW1lKS4KPgo+IEluIGFkZGl0aW9uLCBjYW4geW91IGVsYWJvcmF0ZSBtb3JlIG9uIGhv
dyB0aGUgZW5jbGF2ZSBtZW1vcnkgaXMgCj4gY2FydmVkIG91dCBvZiB0aGUgcHJpbWFyeSBWTT8K
PiBEb2VzIHRoaXMgaW52b2x2ZSBwZXJmb3JtaW5nIGEgbWVtb3J5IGhvdC11bnBsdWcgb3BlcmF0
aW9uIGZyb20gCj4gcHJpbWFyeSBWTSBvciBqdXN0IHVubWFwIGVuY2xhdmUtYXNzaWduZWQgZ3Vl
c3QgcGh5c2ljYWwgcGFnZXMgZnJvbSAKPiBwcmltYXJ5IFZNJ3MgU0xBVCAoRVBUL05QVCkgYW5k
IG1hcCB0aGVtIG5vdyBvbmx5IGluIGVuY2xhdmUncyBTTEFUPwoKCkNvcnJlY3QsIHdlIHRha2Ug
aW50byBjb25zaWRlcmF0aW9uIHRoZSBIVCBzZXR1cC4gVGhlIGVuY2xhdmUgZ2V0cyAKZGVkaWNh
dGVkIHBoeXNpY2FsIGNvcmVzLiBUaGUgcHJpbWFyeSBWTSBhbmQgdGhlIGVuY2xhdmUgVk0gZG9u
J3QgcnVuIG9uIApDUFUgc2libGluZ3Mgb2YgYSBwaHlzaWNhbCBjb3JlLgoKUmVnYXJkaW5nIHRo
ZSBtZW1vcnkgY2FydmUgb3V0LCB0aGUgbG9naWMgaW5jbHVkZXMgcGFnZSB0YWJsZSBlbnRyaWVz
IApoYW5kbGluZy4KCklJUkMsIG1lbW9yeSBob3QtdW5wbHVnIGNhbiBiZSB1c2VkIGZvciB0aGUg
bWVtb3J5IGJsb2NrcyB0aGF0IHdlcmUgCnByZXZpb3VzbHkgaG90LXBsdWdnZWQuCgpodHRwczov
L3d3dy5rZXJuZWwub3JnL2RvYy9odG1sL2xhdGVzdC9hZG1pbi1ndWlkZS9tbS9tZW1vcnktaG90
cGx1Zy5odG1sCgo+Cj4+Cj4+IExldCBtZSBrbm93IGlmIGZ1cnRoZXIgY2xhcmlmaWNhdGlvbnMg
YXJlIG5lZWRlZC4KPj4KPiBJIGRvbid0IHF1aXRlIHVuZGVyc3RhbmQgd2h5IEVuY2xhdmUgVk0g
bmVlZHMgdG8gYmUgCj4gcHJvdmlzaW9uZWQvdGVhcmRvd24gZHVyaW5nIHByaW1hcnkgVk0ncyBy
dW50aW1lLgo+Cj4gRm9yIGV4YW1wbGUsIGFuIGFsdGVybmF0aXZlIGNvdWxkIGhhdmUgYmVlbiB0
byBqdXN0IHByb3Zpc2lvbiBib3RoIAo+IHByaW1hcnkgVk0gYW5kIEVuY2xhdmUgVk0gb24gcHJp
bWFyeSBWTSBzdGFydHVwLgo+IFRoZW4sIHdhaXQgZm9yIHByaW1hcnkgVk0gdG8gc2V0dXAgYSBj
b21tdW5pY2F0aW9uIGNoYW5uZWwgd2l0aCAKPiBFbmNsYXZlIFZNIChFLmcuIHZpYSB2aXJ0aW8t
dnNvY2spLgo+IFRoZW4sIHByaW1hcnkgVk0gaXMgZnJlZSB0byByZXF1ZXN0IEVuY2xhdmUgVk0g
dG8gcGVyZm9ybSB2YXJpb3VzIAo+IHRhc2tzIHdoZW4gcmVxdWlyZWQgb24gdGhlIGlzb2xhdGVk
IGVudmlyb25tZW50Lgo+Cj4gU3VjaCBzZXR1cCB3aWxsIG1pbWljIGEgY29tbW9uIEVuY2xhdmUg
c2V0dXAuIFN1Y2ggYXMgTWljcm9zb2Z0IAo+IFdpbmRvd3MgVkJTIEVQVC1iYXNlZCBFbmNsYXZl
cyAoVGhhdCBhbGwgcnVucyBvbiBWVEwxKS4gSXQgaXMgYWxzbyAKPiBzaW1pbGFyIHRvIFRFRXMg
cnVubmluZyBvbiBBUk0gVHJ1c3Rab25lLgo+IGkuZS4gSW4gbXkgYWx0ZXJuYXRpdmUgcHJvcG9z
ZWQgc29sdXRpb24sIHRoZSBFbmNsYXZlIFZNIGlzIHNpbWlsYXIgdG8gCj4gVlRMMS9UcnVzdFpv
bmUuCj4gSXQgd2lsbCBhbHNvIGF2b2lkIHJlcXVpcmluZyBpbnRyb2R1Y2luZyBhIG5ldyBQQ0kg
ZGV2aWNlIGFuZCBkcml2ZXIuCgpUcnVlLCB0aGlzIGNhbiBiZSBhbm90aGVyIG9wdGlvbiwgdG8g
cHJvdmlzaW9uIHRoZSBwcmltYXJ5IFZNIGFuZCB0aGUgCmVuY2xhdmUgVk0gYXQgbGF1bmNoIHRp
bWUuCgpJbiB0aGUgcHJvcG9zZWQgc2V0dXAsIHRoZSBwcmltYXJ5IFZNIHN0YXJ0cyB3aXRoIHRo
ZSBpbml0aWFsIGFsbG9jYXRlZCAKcmVzb3VyY2VzIChtZW1vcnksIENQVXMpLiBUaGUgbGF1bmNo
IHBhdGggb2YgdGhlIGVuY2xhdmUgVk0sIGFzIGl0J3MgCnNwYXduZWQgb24gdGhlIHNhbWUgaG9z
dCwgaXMgZG9uZSB2aWEgdGhlIGlvY3RsIGludGVyZmFjZSAtIFBDSSBkZXZpY2UgLSAKaG9zdCBo
eXBlcnZpc29yIHBhdGguIFNob3J0LXJ1bm5pbmcgb3IgbG9uZy1ydW5uaW5nIGVuY2xhdmUgY2Fu
IGJlIApib290c3RyYXBwZWQgZHVyaW5nIHByaW1hcnkgVk0gbGlmZXRpbWUuIERlcGVuZGluZyBv
biB0aGUgdXNlIGNhc2UsIGEgCmN1c3RvbSBzZXQgb2YgcmVzb3VyY2VzIChtZW1vcnkgYW5kIENQ
VXMpIGlzIHNldCBmb3IgYW4gZW5jbGF2ZSBhbmQgdGhlbiAKZ2l2ZW4gYmFjayB3aGVuIHRoZSBl
bmNsYXZlIGlzIHRlcm1pbmF0ZWQ7IHRoZXNlIHJlc291cmNlcyBjYW4gYmUgdXNlZCAKZm9yIGFu
b3RoZXIgZW5jbGF2ZSBzcGF3bmVkIGxhdGVyIG9uIG9yIHRoZSBwcmltYXJ5IFZNIHRhc2tzLgoK
VGhhbmtzLApBbmRyYQoKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkgUy5S
LkwuIHJlZ2lzdGVyZWQgb2ZmaWNlOiAyN0EgU2YuIExhemFyIFN0cmVldCwgVUJDNSwgZmxvb3Ig
MiwgSWFzaSwgSWFzaSBDb3VudHksIDcwMDA0NSwgUm9tYW5pYS4gUmVnaXN0ZXJlZCBpbiBSb21h
bmlhLiBSZWdpc3RyYXRpb24gbnVtYmVyIEoyMi8yNjIxLzIwMDUuCg==


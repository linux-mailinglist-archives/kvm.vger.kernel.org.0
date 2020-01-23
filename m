Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 972C8146BA0
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 15:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbgAWOqL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 09:46:11 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:18454 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728205AbgAWOqL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 09:46:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1579790770; x=1611326770;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=8iuoyaZY0uhB5Dk0ZO8aEJBypoKz0MVsyc9jmjlm1ZY=;
  b=t9/pvbdcUfeAEYUbrVn+ZJ/JNW9F88RuRjM94AydbexjieWysay775y2
   xIEs/Zsh+uuFXWfjd4ITlqyVM101LgUQgOWkgIiZoGW40hz0QSaqzFynL
   AVcPoIP6WnBNiQaZh9Yks1zrN4bipEU4mrYguISnNYxD05gsx0BRbd0CV
   Y=;
IronPort-SDR: P+YvJC+y7TgosKBe4UiA+nX+ocjvmLYLkcBwSCDe/UXTrJDZKEO4CQdOPWe+iCKhS386HFAHjO
 C2GMoC1HoACw==
X-IronPort-AV: E=Sophos;i="5.70,354,1574121600"; 
   d="scan'208";a="12199300"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 23 Jan 2020 14:45:51 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com (Postfix) with ESMTPS id 1B8C3A17A8;
        Thu, 23 Jan 2020 14:45:50 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 23 Jan 2020 14:45:49 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.176) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 23 Jan 2020 14:45:47 +0000
Subject: Re: [PATCH 2/2] kvm: Add ioctl for gathering debug counters
To:     Paolo Bonzini <pbonzini@redhat.com>, <milanpa@amazon.com>,
        Milan Pandurov <milanpa@amazon.de>, <kvm@vger.kernel.org>
CC:     <rkrcmar@redhat.com>, <borntraeger@de.ibm.com>
References: <20200115134303.30668-1-milanpa@amazon.de>
 <18820df0-273a-9592-5018-c50a85a75205@amazon.de>
 <8584d6c2-323c-14e2-39c0-21a47a91bbda@amazon.com>
 <ab84ee05-7e2b-e0cc-6994-fc485012a51a@amazon.de>
 <668ea6d3-06ae-4586-9818-cdea094419fe@redhat.com>
 <e77a2477-6010-ae1d-0afd-0c5498ba2117@amazon.de>
 <30358a22-084c-6b0b-ae67-acfb7e69ba8e@amazon.com>
 <7f206904-be2b-7901-1a88-37ed033b4de3@amazon.de>
 <7e6093f1-1d80-8278-c843-b4425ce098bf@redhat.com>
 <6f13c197-b242-90a5-3f53-b75aa8a0e5aa@amazon.de>
 <b69546be-a25c-bbea-7e37-c07f019dcf85@redhat.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <c3b61fff-b40e-07f8-03c4-b177fbaab1a3@amazon.de>
Date:   Thu, 23 Jan 2020 15:45:45 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <b69546be-a25c-bbea-7e37-c07f019dcf85@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.176]
X-ClientProxiedBy: EX13D30UWB004.ant.amazon.com (10.43.161.51) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMy4wMS4yMCAxNToxOSwgUGFvbG8gQm9uemluaSB3cm90ZToKPiBPbiAyMy8wMS8yMCAx
MzozMiwgQWxleGFuZGVyIEdyYWYgd3JvdGU6Cj4+PiBTZWUgYWJvdmU6IEkgYW0gbm90IHN1cmUg
dGhleSBhcmUgdGhlIHNhbWUgc3RvcnkgYmVjYXVzZSB0aGVpciBjb25zdW1lcnMKPj4+IG1pZ2h0
IGJlIHZlcnkgZGlmZmVyZW50IGZyb20gcmVnaXN0ZXJzLsKgIFJlZ2lzdGVycyBhcmUgZ2VuZXJh
bGx5Cj4+PiBjb25zdW1lZCBieSBwcm9ncmFtcyAodG8gbWlncmF0ZSBWTXMsIGZvciBleGFtcGxl
KSBhbmQgb25seSBvY2Nhc2lvbmFsbHkKPj4+IGJ5IGh1bWFucywgd2hpbGUgc3RhdHMgYXJlIG1l
YW50IHRvIGJlIGNvbnN1bWVkIGJ5IGh1bWFucy7CoCBXZSBtYXkKPj4+IGRpc2FncmVlIG9uIHdo
ZXRoZXIgdGhpcyBqdXN0aWZpZXMgYSBjb21wbGV0ZWx5IGRpZmZlcmVudCBBUEkuLi4KPj4KPj4g
SSBkb24ndCBmdWxseSBhZ3JlZSBvbiB0aGUgImh1bWFuIiBwYXJ0IGhlcmUuCj4gCj4gSSBhZ3Jl
ZSBpdCdzIG5vdCBlbnRpcmVseSBhYm91dCBodW1hbnMsIGJ1dCBpbiBnZW5lcmFsIGl0J3MgZ29p
bmcgdG8gYmUKPiBydWxlcyBhbmQgcXVlcmllcyBvbiBtb25pdG9yaW5nIHRvb2xzLCB3aGVyZSAx
KSB0aGUgbW9uaXRvcmluZyB0b29scycKPiBvdXRwdXQgaXMgZ2VuZXJhbGx5IG5vdCBLVk0tc3Bl
Y2lmaWMsIDIpIHRoZSBydWxlcyBhbmQgcXVlcmllcyB3aWxsIGJlCj4gd3JpdHRlbiBieSBodW1h
bnMuCj4gCj4gU28gaWYgdGhlIGtlcm5lbCBwcm9kdWNlcyBpbnNuX2VtdWxhdGlvbl9mYWlsLCB0
aGUgcGx1Z2luIGZvciB0aGUKPiBtb25pdG9yaW5nIHRvb2wgd2lsbCBqdXN0IGxvZyBrdm0uaW5z
bl9lbXVsYXRpb25fZmFpbC4gIElmIHRoZSBrZXJuZWwKPiBwcm9kdWNlcyAweDEwMDQyLCB0aGUg
cGx1Z2luIHdpbGwgaGF2ZSB0byBjb252ZXJ0IGl0IGFuZCB0aGVuIGxvZyBpdC4KPiBUaGlzIGlz
IHdoeSBJJ20gbm90IHN1cmUgdGhhdCBwcm92aWRpbmcgc3RyaW5ncyBpcyBhY3R1YWxseSBsZXNz
IHdvcmsKPiBmb3IgdXNlcnNwYWNlLgoKSSB0aGluayB3ZSdyZSBpbiBhZ3JlZW1lbnQgdGhlbiwg
anVzdCBsZWFuaW5nIG9udG8gdGhlIG90aGVyIHNpZGUgb2YgdGhlIApzYW1lIGZlbmNlLiBNeSB0
YWtlIGlzIHRoYXQgaWYgSSBkb24ndCBrbm93IHdoZXRoZXIgYSBzdHJpbmcgaXMgCm5lY2Vzc2Fy
eSwgSSdkIHJhdGhlciBub3QgaGF2ZSBhIHN0cmluZyA6KS4KCkkgZ3Vlc3MgYXMgbG9uZyBhcyB3
ZSBkbyBnZXQgc3RhdCBpbmZvcm1hdGlvbiBvdXQgcGVyLXZtIGFzIHdlbGwgYXMgCnBlci12Y3B1
IHRocm91Z2ggdm1mZCBhbmQgdmNwdWZkLCBJJ20gaGFwcHkgb3ZlcmFsbC4KClNvIGhvdyBzdHJv
bmdseSBkbyB5b3UgZmVlbCBhYm91dCB0aGUgc3RyaW5nIGJhc2VkIGFwcHJvYWNoPwoKCkFsZXgK
ClBTOiBZb3UgY291bGQgYnR3IGVhc2lseSBhZGQgYSAiZ2l2ZSBtZSB0aGUgc3RyaW5nIGZvciBh
IE9ORV9SRUcgaWQiIAppbnRlcmZhY2UgaW4gS1ZNIHRvIHRyYW5zbGF0ZSBmcm9tIDB4MTAwNDIg
dG8gImluc25fZW11bGF0aW9uX2ZhaWwiIDopLgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVy
IEdlcm1hbnkgR21iSApLcmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhy
dW5nOiBDaHJpc3RpYW4gU2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBB
bXRzZ2VyaWNodCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGlu
ClVzdC1JRDogREUgMjg5IDIzNyA4NzkKCgo=


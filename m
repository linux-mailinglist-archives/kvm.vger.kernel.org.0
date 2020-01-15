Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D23C13C4DC
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 15:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbgAOOEa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 09:04:30 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:65165 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbgAOOE3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 09:04:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1579097068; x=1610633068;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=mD134d1dhAL2wTm6GBiSo5X+tf1YR1o2BkcpCUOTDOs=;
  b=S2TF2yR3OTH2YeutfsUCHy73Mraf7aofuQ5JQy25kpeoV0bfjUuT047x
   ICt9B0TLkzlRUt1X066vnwKIoKh480I4wC6ua/0d8r6rlOwV40mcHb8Uq
   Mzsv3KrU6vyK0YzNwVzrw/mkCQIpj+rcOr3T4MfGJYU5k2TgAuAANTeS+
   w=;
IronPort-SDR: Nsog/85Rs1RO/q67ac3JqaAmsvYoVcLz0je9tcakeK1cuuftCcLbhf8VcXj1eI/2QEyd4Dwy4t
 pbCjcEsWf01A==
X-IronPort-AV: E=Sophos;i="5.70,322,1574121600"; 
   d="scan'208";a="11652016"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 15 Jan 2020 14:04:27 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id 068E6A3834;
        Wed, 15 Jan 2020 14:04:26 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 15 Jan 2020 14:04:26 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.253) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 15 Jan 2020 14:04:24 +0000
Subject: Re: [PATCH 2/2] kvm: Add ioctl for gathering debug counters
To:     Milan Pandurov <milanpa@amazon.de>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <borntraeger@de.ibm.com>
References: <20200115134303.30668-1-milanpa@amazon.de>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <18820df0-273a-9592-5018-c50a85a75205@amazon.de>
Date:   Wed, 15 Jan 2020 15:04:22 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200115134303.30668-1-milanpa@amazon.de>
Content-Language: en-US
X-Originating-IP: [10.43.161.253]
X-ClientProxiedBy: EX13D34UWC001.ant.amazon.com (10.43.162.112) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAxNS4wMS4yMCAxNDo0MywgTWlsYW4gUGFuZHVyb3Ygd3JvdGU6Cj4gS1ZNIGV4cG9zZXMg
ZGVidWcgY291bnRlcnMgdGhyb3VnaCBpbmRpdmlkdWFsIGRlYnVnZnMgZmlsZXMuCj4gTW9uaXRv
cmluZyB0aGVzZSBjb3VudGVycyByZXF1aXJlcyBkZWJ1Z2ZzIHRvIGJlIGVuYWJsZWQvYWNjZXNz
aWJsZSBmb3IKPiB0aGUgYXBwbGljYXRpb24sIHdoaWNoIG1pZ2h0IG5vdCBiZSBhbHdheXMgdGhl
IGNhc2UuCj4gQWRkaXRpb25hbGx5LCBwZXJpb2RpYyBtb25pdG9yaW5nIG11bHRpcGxlIGRlYnVn
ZnMgZmlsZXMgZnJvbQo+IHVzZXJzcGFjZSByZXF1aXJlcyBtdWx0aXBsZSBmaWxlIG9wZW4vcmVh
ZC9jbG9zZSArIGF0b2kgY29udmVyc2lvbgo+IG9wZXJhdGlvbnMsIHdoaWNoIGlzIG5vdCB2ZXJ5
IGVmZmljaWVudC4KPiAKPiBMZXQncyBleHBvc2UgbmV3IGludGVyZmFjZSB0byB1c2Vyc3BhY2Ug
Zm9yIGdhcmhlcmluZyB0aGVzZQo+IHN0YXRpc3RpY3Mgd2l0aCBvbmUgaW9jdGwuCj4gCj4gVHdv
IG5ldyBpb2N0bCBtZXRob2RzIGFyZSBhZGRlZDoKPiAgIC0gS1ZNX0dFVF9TVVBQT1JURURfREVC
VUdGU19TVEFUIDogUmV0dXJucyBsaXN0IG9mIGF2YWlsYWJsZSBjb3VudGVyCj4gICBuYW1lcy4g
TmFtZXMgY29ycmVzcG9uZCB0byB0aGUgZGVidWdmcyBmaWxlIG5hbWVzCj4gICAtIEtWTV9HRVRf
REVCVUdGU19WQUxVRVMgOiBSZXR1cm5zIGxpc3Qgb2YgdTY0IHZhbHVlcyBlYWNoCj4gICBjb3Jy
ZXNwb25kaW5nIHRvIGEgdmFsdWUgZGVzY3JpYmVkIGluIEtWTV9HRVRfU1VQUE9SVEVEX0RFQlVH
RlNfU1RBVC4KPiAKPiBVc2Vyc3BhY2UgYXBwbGljYXRpb24gY2FuIHJlYWQgY291bnRlciBkZXNj
cmlwdGlvbiBvbmNlIHVzaW5nCj4gS1ZNX0dFVF9TVVBQT1JURURfREVCVUdGU19TVEFUIGFuZCBw
ZXJpb2RpY2FsbHkgaW52b2tlIHRoZQo+IEtWTV9HRVRfREVCVUdGU19WQUxVRVMgdG8gZ2V0IHZh
bHVlIHVwZGF0ZS4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBNaWxhbiBQYW5kdXJvdiA8bWlsYW5wYUBh
bWF6b24uZGU+CgpUaGFua3MgYSBsb3QhIEkgcmVhbGx5IGxvdmUgdGhlIGlkZWEgdG8gZ2V0IHN0
YXRzIGRpcmVjdGx5IGZyb20gdGhlIGt2bSAKdm0gZmQgb3duZXIuIFRoaXMgaXMgc28gbXVjaCBi
ZXR0ZXIgdGhhbiBwb2tpbmcgYXQgZmlsZXMgZnJvbSBhIHJhbmRvbSAKdW5yZWxhdGVkIGRlYnVn
IG9yIHN0YXQgZmlsZSBzeXN0ZW0uCgpJIGhhdmUgYSBmZXcgY29tbWVudHMgb3ZlcmFsbCB0aG91
Z2g6CgoKMSkKClRoaXMgaXMgYW4gaW50ZXJmYWNlIHRoYXQgcmVxdWlyZXMgYSBsb3Qgb2YgbG9n
aWMgYW5kIGJ1ZmZlcnMgZnJvbSB1c2VyIApzcGFjZSB0byByZXRyaWV2ZSBpbmRpdmlkdWFsLCBl
eHBsaWNpdCBjb3VudGVycy4gV2hhdCBpZiBJIGp1c3Qgd2FudGVkIAp0byBtb25pdG9yIHRoZSBu
dW1iZXIgb2YgZXhpdHMgb24gZXZlcnkgdXNlciBzcGFjZSBleGl0PwoKQWxzbywgd2UncmUgc3Vk
ZGVubHkgbWFraW5nIHRoZSBkZWJ1Z2ZzIG5hbWVzIGEgZnVsbCBBQkksIGJlY2F1c2UgCnRocm91
Z2ggdGhpcyBpbnRlcmZhY2Ugd2Ugb25seSBpZGVudGlmeSB0aGUgaW5kaXZpZHVhbCBzdGF0cyB0
aHJvdWdoIAp0aGVpciBuYW1lcy4gVGhhdCBtZWFucyB3ZSBjYW4gbm90IHJlbW92ZSBzdGF0cyBv
ciBjaGFuZ2UgdGhlaXIgbmFtZXMsIApiZWNhdXNlIHBlb3BsZSBtYXkgcmVseSBvbiB0aGVtLCBu
bz8gVGhpbmluZyBhYm91dCB0aGlzIGFnYWluLCBtYXliZSAKdGhleSBhbHJlYWR5IGFyZSBhbiBB
QkkgYmVjYXVzZSBwZW9wbGUgcmVseSBvbiB0aGVtIGluIGRlYnVnZnMgdGhvdWdoPwoKSSBzZWUg
dHdvIGFsdGVybmF0aXZlcyB0byB0aGlzIGFwcHJvYWNoIGhlcmU6CgphKSBPTkVfUkVHCgpXZSBj
YW4ganVzdCBhZGQgYSBuZXcgREVCVUcgYXJjaCBpbiBPTkVfUkVHIGFuZCBleHBvc2UgT05FX1JF
RyBwZXIgVk0gYXMgCndlbGwgKGlmIHdlIHJlYWxseSBoYXZlIHRvPykuIFRoYXQgZ2l2ZXMgdXMg
ZXhwbGljaXQgaWRlbnRpZmllcnMgZm9yIAplYWNoIHN0YXQgd2l0aCBhbiBleHBsaWNpdCBwYXRo
IHRvIGludHJvZHVjZSBuZXcgb25lcyB3aXRoIHZlcnkgdW5pcXVlIAppZGVudGlmaWVycy4KClRo
YXQgd291bGQgZ2l2ZSB1cyBhIHZlcnkgZWFzaWx5IHN0cnVjdHVyZWQgYXBwcm9hY2ggdG8gcmV0
cmlldmUgCmluZGl2aWR1YWwgY291bnRlcnMuCgpiKSBwYXJ0IG9mIHRoZSBtbWFwJ2VkIHZjcHUg
c3RydWN0CgpXZSBjb3VsZCBzaW1wbHkgbW92ZSB0aGUgY291bnRlcnMgaW50byB0aGUgc2hhcmVk
IHN0cnVjdCB0aGF0IHdlIGV4cG9zZSAKdG8gdXNlciBzcGFjZSB2aWEgbW1hcC4gSUlSQyB3ZSBv
bmx5IGhhdmUgdGhhdCBwZXItdmNwdSwgYnV0IHRoZW4gYWdhaW4gCm1vc3QgY291bnRlcnMgYXJl
IHBlci12Y3B1IGFueXdheSwgc28gd2Ugd291bGQgcHVzaCB0aGUgYWdncmVnYXRpb24gdG8gCnVz
ZXIgc3BhY2UuCgpGb3IgcGVyLXZtIG9uZXMsIG1heWJlIHdlIGNhbiBqdXN0IGFkZCBhbm90aGVy
IG1tYXAnZWQgc2hhcmVkIHBhZ2UgZm9yIAp0aGUgdm0gZmQ/CgoKMikgdmNwdSBjb3VudGVycwoK
TW9zdCBvZiB0aGUgY291bnRlcnMgY291bnQgb24gdmNwdSBncmFudWxhcml0eSwgYnV0IGRlYnVn
ZnMgb25seSBnaXZlcyAKdXMgYSBmdWxsIFZNIHZpZXcuIFdoYXRldmVyIHdlIGRvIHRvIGltcHJv
dmUgdGhlIHNpdHVhdGlvbiwgd2Ugc2hvdWxkIApkZWZpbml0ZWx5IHRyeSB0byBidWlsZCBzb21l
dGhpbmcgdGhhdCBhbGxvd3MgdXMgdG8gZ2V0IHRoZSBjb3VudGVycyBwZXIgCnZjcHUgKGFzIHdl
bGwpLgoKVGhlIG1haW4gcHVycG9zZSBvZiB0aGVzZSBjb3VudGVycyBpcyBtb25pdG9yaW5nLiBJ
dCBjYW4gYmUgcXVpdGUgCmltcG9ydGFudCB0byBrbm93IHRoYXQgb25seSBhIHNpbmdsZSB2Q1BV
IGlzIGdvaW5nIHdpbGQsIGNvbXBhcmVkIHRvIGFsbCAKb2YgdGhlbSBmb3IgZXhhbXBsZS4KCgpU
aGFua3MsCgpBbGV4CgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICkty
YXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBT
Y2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJs
b3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkg
MjM3IDg3OQoKCg==


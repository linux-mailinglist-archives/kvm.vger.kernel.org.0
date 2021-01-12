Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5DE2F2ED4
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 13:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732675AbhALMRa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 07:17:30 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:21019 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732299AbhALMRa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 07:17:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1610453847; x=1641989847;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tF+5LWSipsSfv/MpNTU2XOkSQBgOPGBmsF5sLnQRVvI=;
  b=A1FvrYH7NKrhzLt0kkpD9RYxfl9Kqi8AjptzODDcmyd4npmojVXPTz7f
   /bqegMuf1w7twUocRHBoDVOOzzR0JC0zwbr3caiA7J4D2N2QQELs8FKHz
   8Arr1ecsIGLGBLNA0b9rb388vbOQH0gnrwIbj7/+80zrDcMhDQ/IIS3x5
   o=;
X-IronPort-AV: E=Sophos;i="5.79,341,1602547200"; 
   d="scan'208";a="77011747"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-16425a8d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 12 Jan 2021 12:16:39 +0000
Received: from EX13D08EUB004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-16425a8d.us-east-1.amazon.com (Postfix) with ESMTPS id 1E6F6100F90;
        Tue, 12 Jan 2021 12:16:29 +0000 (UTC)
Received: from uf6ed9c851f4556.ant.amazon.com (10.43.161.68) by
 EX13D08EUB004.ant.amazon.com (10.43.166.158) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 12 Jan 2021 12:16:15 +0000
From:   Adrian Catangiu <acatan@amazon.com>
To:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <linux-s390@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <graf@amazon.com>, <arnd@arndb.de>,
        <ebiederm@xmission.com>, <rppt@kernel.org>, <0x7f454c46@gmail.com>,
        <borntraeger@de.ibm.com>, <Jason@zx2c4.com>, <jannh@google.com>,
        <w@1wt.eu>, <colmmacc@amazon.com>, <luto@kernel.org>,
        <tytso@mit.edu>, <ebiggers@kernel.org>, <dwmw@amazon.co.uk>,
        <bonzini@gnu.org>, <sblbir@amazon.com>, <raduweis@amazon.com>,
        <corbet@lwn.net>, <mst@redhat.com>, <mhocko@kernel.org>,
        <rafael@kernel.org>, <pavel@ucw.cz>, <mpe@ellerman.id.au>,
        <areber@redhat.com>, <ovzxemul@gmail.com>, <avagin@gmail.com>,
        <ptikhomirov@virtuozzo.com>, <gil@azul.com>, <asmehra@redhat.com>,
        <dgunigun@redhat.com>, <vijaysun@ca.ibm.com>, <oridgar@gmail.com>,
        <ghammer@redhat.com>, Adrian Catangiu <acatan@amazon.com>
Subject: [PATCH v4 0/2] System Generation ID driver and VMGENID backend
Date:   Tue, 12 Jan 2021 14:15:58 +0200
Message-ID: <1610453760-13812-1-git-send-email-acatan@amazon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
X-Originating-IP: [10.43.161.68]
X-ClientProxiedBy: EX13D50UWC001.ant.amazon.com (10.43.162.96) To
 EX13D08EUB004.ant.amazon.com (10.43.166.158)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VGhpcyBmZWF0dXJlIGlzIGFpbWVkIGF0IHZpcnR1YWxpemVkIG9yIGNvbnRhaW5lcml6ZWQgZW52
aXJvbm1lbnRzCndoZXJlIFZNIG9yIGNvbnRhaW5lciBzbmFwc2hvdHRpbmcgZHVwbGljYXRlcyBt
ZW1vcnkgc3RhdGUsIHdoaWNoIGlzIGEKY2hhbGxlbmdlIGZvciBhcHBsaWNhdGlvbnMgdGhhdCB3
YW50IHRvIGdlbmVyYXRlIHVuaXF1ZSBkYXRhIHN1Y2ggYXMKcmVxdWVzdCBJRHMsIFVVSURzLCBh
bmQgY3J5cHRvZ3JhcGhpYyBub25jZXMuCgpUaGUgcGF0Y2ggc2V0IGludHJvZHVjZXMgYSBtZWNo
YW5pc20gdGhhdCBwcm92aWRlcyBhIHVzZXJzcGFjZQppbnRlcmZhY2UgZm9yIGFwcGxpY2F0aW9u
cyBhbmQgbGlicmFyaWVzIHRvIGJlIG1hZGUgYXdhcmUgb2YgdW5pcXVlbmVzcwpicmVha2luZyBl
dmVudHMgc3VjaCBhcyBWTSBvciBjb250YWluZXIgc25hcHNob3R0aW5nLCBhbmQgYWxsb3cgdGhl
bSB0bwpyZWFjdCBhbmQgYWRhcHQgdG8gc3VjaCBldmVudHMuCgpTb2x2aW5nIHRoZSB1bmlxdWVu
ZXNzIHByb2JsZW0gc3Ryb25nbHkgZW5vdWdoIGZvciBjcnlwdG9ncmFwaGljCnB1cnBvc2VzIHJl
cXVpcmVzIGEgbWVjaGFuaXNtIHdoaWNoIGNhbiBkZXRlcm1pbmlzdGljYWxseSByZXNlZWQKdXNl
cnNwYWNlIFBSTkdzIHdpdGggbmV3IGVudHJvcHkgYXQgcmVzdG9yZSB0aW1lLiBUaGlzIG1lY2hh
bmlzbSBtdXN0CmFsc28gc3VwcG9ydCB0aGUgaGlnaC10aHJvdWdocHV0IGFuZCBsb3ctbGF0ZW5j
eSB1c2UtY2FzZXMgdGhhdCBsZWQKcHJvZ3JhbW1lcnMgdG8gcGljayBhIHVzZXJzcGFjZSBQUk5H
IGluIHRoZSBmaXJzdCBwbGFjZTsgYmUgdXNhYmxlIGJ5CmJvdGggYXBwbGljYXRpb24gY29kZSBh
bmQgbGlicmFyaWVzOyBhbGxvdyB0cmFuc3BhcmVudCByZXRyb2ZpdHRpbmcKYmVoaW5kIGV4aXN0
aW5nIHBvcHVsYXIgUFJORyBpbnRlcmZhY2VzIHdpdGhvdXQgY2hhbmdpbmcgYXBwbGljYXRpb24K
Y29kZTsgaXQgbXVzdCBiZSBlZmZpY2llbnQsIGVzcGVjaWFsbHkgb24gc25hcHNob3QgcmVzdG9y
ZTsgYW5kIGJlCnNpbXBsZSBlbm91Z2ggZm9yIHdpZGUgYWRvcHRpb24uCgpUaGUgZmlyc3QgcGF0
Y2ggaW4gdGhlIHNldCBpbXBsZW1lbnRzIGEgZGV2aWNlIGRyaXZlciB3aGljaCBleHBvc2VzIGEK
cmVhZC1vbmx5IGRldmljZSAvZGV2L3N5c2dlbmlkIHRvIHVzZXJzcGFjZSwgd2hpY2ggY29udGFp
bnMgYQptb25vdG9uaWNhbGx5IGluY3JlYXNpbmcgdTMyIGdlbmVyYXRpb24gY291bnRlci4gTGli
cmFyaWVzIGFuZAphcHBsaWNhdGlvbnMgYXJlIGV4cGVjdGVkIHRvIG9wZW4oKSB0aGUgZGV2aWNl
LCBhbmQgdGhlbiBjYWxsIHJlYWQoKQp3aGljaCBibG9ja3MgdW50aWwgdGhlIFN5c0dlbklkIGNo
YW5nZXMuIEZvbGxvd2luZyBhbiB1cGRhdGUsIHJlYWQoKQpjYWxscyBubyBsb25nZXIgYmxvY2sg
dW50aWwgdGhlIGFwcGxpY2F0aW9uIGFja25vd2xlZGdlcyB0aGUgbmV3ClN5c0dlbklkIGJ5IHdy
aXRlKClpbmcgaXQgYmFjayB0byB0aGUgZGV2aWNlLiBOb24tYmxvY2tpbmcgcmVhZCgpIGNhbGxz
CnJldHVybiBFQUdBSU4gd2hlbiB0aGVyZSBpcyBubyBuZXcgU3lzR2VuSWQgYXZhaWxhYmxlLiBB
bHRlcm5hdGl2ZWx5LApsaWJyYXJpZXMgY2FuIG1tYXAoKSB0aGUgZGV2aWNlIHRvIGdldCBhIHNp
bmdsZSBzaGFyZWQgcGFnZSB3aGljaApjb250YWlucyB0aGUgbGF0ZXN0IFN5c0dlbklkIGF0IG9m
ZnNldCAwLgoKU3lzR2VuSWQgYWxzbyBzdXBwb3J0cyBhIG5vdGlmaWNhdGlvbiBtZWNoYW5pc20g
ZXhwb3NlZCBhcyB0d28gSU9DVExzCm9uIHRoZSBkZXZpY2UuIFNZU0dFTklEX0dFVF9PVVREQVRF
RF9XQVRDSEVSUyBpbW1lZGlhdGVseSByZXR1cm5zIHRoZQpudW1iZXIgb2YgZmlsZSBkZXNjcmlw
dG9ycyB0byB0aGUgZGV2aWNlIHRoYXQgd2VyZSBvcGVuIGR1cmluZyB0aGUgbGFzdApTeXNHZW5J
ZCBjaGFuZ2UgYnV0IGhhdmUgbm90IHlldCBhY2tub3dsZWRnZWQgdGhlIG5ldyBpZC4KU1lTR0VO
SURfV0FJVF9XQVRDSEVSUyBibG9ja3MgdW50aWwgdGhlcmUgYXJlIG5vIG9wZW4gZmlsZSBoYW5k
bGVzIG9uCnRoZSBkZXZpY2Ugd2hpY2ggaGF2ZW7igJl0IGFja25vd2xlZGdlZCB0aGUgbmV3IGlk
LiBUaGVzZSB0d28gaW50ZXJmYWNlcwphcmUgaW50ZW5kZWQgZm9yIHNlcnZlcmxlc3MgYW5kIGNv
bnRhaW5lciBjb250cm9sIHBsYW5lcywgd2hpY2ggd2FudCB0bwpjb25maXJtIHRoYXQgYWxsIGFw
cGxpY2F0aW9uIGNvZGUgaGFzIGRldGVjdGVkIGFuZCByZWFjdGVkIHRvIHRoZSBuZXcKU3lzR2Vu
SWQgYmVmb3JlIHNlbmRpbmcgYW4gaW52b2tlIHRvIHRoZSBuZXdseS1yZXN0b3JlZCBzYW5kYm94
LgoKVGhlIHNlY29uZCBwYXRjaCBpbiB0aGUgc2V0IGFkZHMgYSBWbUdlbklkIGRyaXZlciB3aGlj
aCBtYWtlcyB1c2Ugb2YKdGhlIEFDUEkgdm1nZW5pZCBkZXZpY2UgdG8gZHJpdmUgU3lzR2VuSWQg
YW5kIHRvIHJlc2VlZCBrZXJuZWwgZW50cm9weQpvbiBWTSBzbmFwc2hvdHMuCgotLS0KCnYzIC0+
IHY0OgoKICAtIHNwbGl0IGZ1bmN0aW9uYWxpdHkgaW4gdHdvIHNlcGFyYXRlIGtlcm5lbCBtb2R1
bGVzOiAKICAgIDEuIGRyaXZlcnMvbWlzYy9zeXNnZW5pZC5jIHdoaWNoIHByb3ZpZGVzIHRoZSBn
ZW5lcmljIHVzZXJzcGFjZQogICAgICAgaW50ZXJmYWNlIGFuZCBtZWNoYW5pc21zCiAgICAyLiBk
cml2ZXJzL3ZpcnQvdm1nZW5pZC5jIGFzIFZNR0VOSUQgYWNwaSBkZXZpY2UgZHJpdmVyIHRoYXQg
c2VlZHMKICAgICAgIGtlcm5lbCBlbnRyb3B5IGFuZCBhY3RzIGFzIGEgZHJpdmluZyBiYWNrZW5k
IGZvciB0aGUgZ2VuZXJpYwogICAgICAgc3lzZ2VuaWQKICAtIHJlbmFtZWQgL2Rldi92bWdlbmlk
IC0+IC9kZXYvc3lzZ2VuaWQKICAtIHJlbmFtZWQgdWFwaSBoZWFkZXIgZmlsZSB2bWdlbmlkLmgg
LT4gc3lzZ2VuaWQuaAogIC0gcmVuYW1lZCBpb2N0bHMgVk1HRU5JRF8qIC0+IFNZU0dFTklEXyoK
ICAtIGFkZGVkIOKAmG1pbl9nZW7igJkgcGFyYW1ldGVyIHRvIFNZU0dFTklEX0ZPUkNFX0dFTl9V
UERBVEUgaW9jdGwKICAtIGZpeGVkIHJhY2VzIGluIGRvY3VtZW50YXRpb24gZXhhbXBsZXMKICAt
IHZhcmlvdXMgc3R5bGUgbml0cwogIC0gcmViYXNlZCBvbiB0b3Agb2YgbGludXMgbGF0ZXN0Cgp2
MiAtPiB2MzoKCiAgLSBzZXBhcmF0ZSB0aGUgY29yZSBkcml2ZXIgbG9naWMgYW5kIGludGVyZmFj
ZSwgZnJvbSB0aGUgQUNQSSBkZXZpY2UuCiAgICBUaGUgQUNQSSB2bWdlbmlkIGRldmljZSBpcyBu
b3cgb25lIHBvc3NpYmxlIGJhY2tlbmQuCiAgLSBmaXggaXNzdWUgd2hlbiB0aW1lb3V0PTAgaW4g
Vk1HRU5JRF9XQUlUX1dBVENIRVJTCiAgLSBhZGQgbG9ja2luZyB0byBhdm9pZCByYWNlcyBiZXR3
ZWVuIGZzIG9wcyBoYW5kbGVycyBhbmQgaHcgaXJxCiAgICBkcml2ZW4gZ2VuZXJhdGlvbiB1cGRh
dGVzCiAgLSBjaGFuZ2UgVk1HRU5JRF9XQUlUX1dBVENIRVJTIGlvY3RsIHNvIGlmIHRoZSBjdXJy
ZW50IGNhbGxlciBpcwogICAgb3V0ZGF0ZWQgb3IgYSBnZW5lcmF0aW9uIGNoYW5nZSBoYXBwZW5z
IHdoaWxlIHdhaXRpbmcgKHRodXMgbWFraW5nCiAgICBjdXJyZW50IGNhbGxlciBvdXRkYXRlZCks
IHRoZSBpb2N0bCByZXR1cm5zIC1FSU5UUiB0byBzaWduYWwgdGhlCiAgICB1c2VyIHRvIGhhbmRs
ZSBldmVudCBhbmQgcmV0cnkuIEZpeGVzIGJsb2NraW5nIG9uIG9uZXNlbGYuCiAgLSBhZGQgVk1H
RU5JRF9GT1JDRV9HRU5fVVBEQVRFIGlvY3RsIGNvbmRpdGlvbmVkIGJ5CiAgICBDQVBfQ0hFQ0tQ
T0lOVF9SRVNUT1JFIGNhcGFiaWxpdHksIHRocm91Z2ggd2hpY2ggc29mdHdhcmUgY2FuIGZvcmNl
CiAgICBnZW5lcmF0aW9uIGJ1bXAuCgp2MSAtPiB2MjoKCiAgLSBleHBvc2UgdG8gdXNlcnNwYWNl
IGEgbW9ub3RvbmljYWxseSBpbmNyZWFzaW5nIHUzMiBWbSBHZW4gQ291bnRlcgogICAgaW5zdGVh
ZCBvZiB0aGUgaHcgVm1HZW4gVVVJRAogIC0gc2luY2UgdGhlIGh3L2h5cGVydmlzb3ItcHJvdmlk
ZWQgMTI4LWJpdCBVVUlEIGlzIG5vdCBwdWJsaWMKICAgIGFueW1vcmUsIGFkZCBpdCB0byB0aGUg
a2VybmVsIFJORyBhcyBkZXZpY2UgcmFuZG9tbmVzcwogIC0gaW5zZXJ0IGRyaXZlciBwYWdlIGNv
bnRhaW5pbmcgVm0gR2VuIENvdW50ZXIgaW4gdGhlIHVzZXIgdm1hIGluCiAgICB0aGUgZHJpdmVy
J3MgbW1hcCBoYW5kbGVyIGluc3RlYWQgb2YgdXNpbmcgYSBmYXVsdCBoYW5kbGVyCiAgLSB0dXJu
IGRyaXZlciBpbnRvIGEgbWlzYyBkZXZpY2UgZHJpdmVyIHRvIGF1dG8tY3JlYXRlIC9kZXYvdm1n
ZW5pZAogIC0gY2hhbmdlIGlvY3RsIGFyZyB0byBhdm9pZCBsZWFraW5nIGtlcm5lbCBzdHJ1Y3Rz
IHRvIHVzZXJzcGFjZQogIC0gdXBkYXRlIGRvY3VtZW50YXRpb24KICAtIHZhcmlvdXMgbml0cwog
IC0gcmViYXNlIG9uIHRvcCBvZiBsaW51cyBsYXRlc3QKCkFkcmlhbiBDYXRhbmdpdSAoMik6CiAg
ZHJpdmVycy9taXNjOiBzeXNnZW5pZDogYWRkIHN5c3RlbSBnZW5lcmF0aW9uIGlkIGRyaXZlcgog
IGRyaXZlcnMvdmlydDogdm1nZW5pZDogYWRkIHZtIGdlbmVyYXRpb24gaWQgZHJpdmVyCgogRG9j
dW1lbnRhdGlvbi9taXNjLWRldmljZXMvc3lzZ2VuaWQucnN0IHwgMjQwICsrKysrKysrKysrKysr
KysrKysrKysrKysKIERvY3VtZW50YXRpb24vdmlydC92bWdlbmlkLnJzdCAgICAgICAgICB8ICAz
NCArKysrCiBkcml2ZXJzL21pc2MvS2NvbmZpZyAgICAgICAgICAgICAgICAgICAgfCAgMTYgKysK
IGRyaXZlcnMvbWlzYy9NYWtlZmlsZSAgICAgICAgICAgICAgICAgICB8ICAgMSArCiBkcml2ZXJz
L21pc2Mvc3lzZ2VuaWQuYyAgICAgICAgICAgICAgICAgfCAyOTggKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysKIGRyaXZlcnMvdmlydC9LY29uZmlnICAgICAgICAgICAgICAgICAgICB8
ICAxNCArKwogZHJpdmVycy92aXJ0L01ha2VmaWxlICAgICAgICAgICAgICAgICAgIHwgICAxICsK
IGRyaXZlcnMvdmlydC92bWdlbmlkLmMgICAgICAgICAgICAgICAgICB8IDE1MyArKysrKysrKysr
KysrKysrCiBpbmNsdWRlL3VhcGkvbGludXgvc3lzZ2VuaWQuaCAgICAgICAgICAgfCAgMTggKysK
IDkgZmlsZXMgY2hhbmdlZCwgNzc1IGluc2VydGlvbnMoKykKIGNyZWF0ZSBtb2RlIDEwMDY0NCBE
b2N1bWVudGF0aW9uL21pc2MtZGV2aWNlcy9zeXNnZW5pZC5yc3QKIGNyZWF0ZSBtb2RlIDEwMDY0
NCBEb2N1bWVudGF0aW9uL3ZpcnQvdm1nZW5pZC5yc3QKIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2
ZXJzL21pc2Mvc3lzZ2VuaWQuYwogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvdmlydC92bWdl
bmlkLmMKIGNyZWF0ZSBtb2RlIDEwMDY0NCBpbmNsdWRlL3VhcGkvbGludXgvc3lzZ2VuaWQuaAoK
LS0gCjIuNy40CgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4g
cmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJ
YXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlhLiBSZWdpc3RlcmVkIGluIFJvbWFuaWEu
IFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAwNS4K


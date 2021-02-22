Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D9D32134F
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 10:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbhBVJnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 04:43:17 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:59981 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbhBVJmx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Feb 2021 04:42:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1613986971; x=1645522971;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kck/xR2x6Hs/rrwKMHWfVaM9BsndkG+d3cLhoGv+WGM=;
  b=ZpYxSjBGErX/6ywPAwILw2JNeCetiRGdYvFU4lTwOzpGtr1PzHfpbi/E
   WxhVY66g54q1ALw9hkwEEORFpjGcbColdHkwX791hlF6hSWqtUM5CEKty
   Dr/1yZr4UPoq3XvZlz8o2qQSZ4rUWC22iw4KfIRiypZIU0cVAOwWxnzbF
   g=;
X-IronPort-AV: E=Sophos;i="5.81,196,1610409600"; 
   d="scan'208";a="89090694"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-81e76b79.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 22 Feb 2021 09:41:59 +0000
Received: from EX13D08EUB004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-81e76b79.us-west-2.amazon.com (Postfix) with ESMTPS id DBAA4A03F3;
        Mon, 22 Feb 2021 09:41:55 +0000 (UTC)
Received: from uf6ed9c851f4556.ant.amazon.com (10.43.161.87) by
 EX13D08EUB004.ant.amazon.com (10.43.166.158) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 22 Feb 2021 09:41:41 +0000
From:   Adrian Catangiu <acatan@amazon.com>
To:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <linux-s390@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <graf@amazon.com>,
        <rdunlap@infradead.org>, <arnd@arndb.de>, <ebiederm@xmission.com>,
        <rppt@kernel.org>, <0x7f454c46@gmail.com>,
        <borntraeger@de.ibm.com>, <Jason@zx2c4.com>, <jannh@google.com>,
        <w@1wt.eu>, <colmmacc@amazon.com>, <luto@kernel.org>,
        <tytso@mit.edu>, <ebiggers@kernel.org>, <dwmw@amazon.co.uk>,
        <bonzini@gnu.org>, <sblbir@amazon.com>, <raduweis@amazon.com>,
        <corbet@lwn.net>, <mst@redhat.com>, <mhocko@kernel.org>,
        <rafael@kernel.org>, <pavel@ucw.cz>, <mpe@ellerman.id.au>,
        <areber@redhat.com>, <ovzxemul@gmail.com>, <avagin@gmail.com>,
        <ptikhomirov@virtuozzo.com>, <gil@azul.com>, <asmehra@redhat.com>,
        <dgunigun@redhat.com>, <vijaysun@ca.ibm.com>, <oridgar@gmail.com>,
        <ghammer@redhat.com>, <acatan@amazon.com>
Subject: [PATCH v6 0/2] System Generation ID driver and VMGENID backend
Date:   Mon, 22 Feb 2021 11:41:24 +0200
Message-ID: <1613986886-29493-1-git-send-email-acatan@amazon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
X-Originating-IP: [10.43.161.87]
X-ClientProxiedBy: EX13D41UWC004.ant.amazon.com (10.43.162.31) To
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
dGhlIC9kZXYvc3lzZ2VuaWQgY2hhciBkZXZpY2UgdG8gdXNlcnNwYWNlLiBJdHMgYXNzb2NpYXRl
ZCBmaWxlc3lzdGVtCm9wZXJhdGlvbnMgb3BlcmF0aW9ucyBjYW4gYmUgdXNlZCB0byBidWlsZCBh
IHN5c3RlbSBsZXZlbCBzYWZlIHdvcmtmbG93CnRoYXQgZ3Vlc3Qgc29mdHdhcmUgY2FuIGZvbGxv
dyB0byBwcm90ZWN0IGl0c2VsZiBmcm9tIG5lZ2F0aXZlIHN5c3RlbQpzbmFwc2hvdCBlZmZlY3Rz
LgoKVGhlIHNlY29uZCBwYXRjaCBpbiB0aGUgc2V0IGFkZHMgYSBWbUdlbklkIGRyaXZlciB3aGlj
aCBtYWtlcyB1c2Ugb2YKdGhlIEFDUEkgdm1nZW5pZCBkZXZpY2UgdG8gZHJpdmUgU3lzR2VuSWQg
YW5kIHRvIHJlc2VlZCBrZXJuZWwgZW50cm9weQpmb2xsb3dpbmcgVk0gc25hcHNob3RzLgoKKipQ
bGVhc2Ugbm90ZSoqLCBTeXNHZW5JRCBhbG9uZSBkb2VzIG5vdCBndWFyYW50ZWUgY29tcGxldGUg
c25hcHNob3QKc2FmZXR5IHRvIGFwcGxpY2F0aW9ucyB1c2luZyBpdC4gQSBjZXJ0YWluIHdvcmtm
bG93IG5lZWRzIHRvIGJlCmZvbGxvd2VkIGF0IHRoZSBzeXN0ZW0gbGV2ZWwsIGluIG9yZGVyIHRv
IG1ha2UgdGhlIHN5c3RlbQpzbmFwc2hvdC1yZXNpbGllbnQuIFBsZWFzZSBzZWUgdGhlICJTbmFw
c2hvdCBTYWZldHkgUHJlcmVxdWlzaXRlcyIKc2VjdGlvbiBpbiB0aGUgaW5jbHVkZWQgU3lzR2Vu
SUQgZG9jdW1lbnRhdGlvbi4KCi0tLQoKdjUgLT4gdjY6CgogIC0gc3lzZ2VuaWQ6IHdhdGNoZXIg
dHJhY2tpbmcgZGlzYWJsZWQgYnkgZGVmYXVsdAogIC0gc3lzZ2VuaWQ6IGFkZCBTWVNHRU5JRF9T
RVRfV0FUQ0hFUl9UUkFDS0lORyBpb2N0bCB0byBhbGxvdyBlYWNoCiAgICBmaWxlIGRlc2NyaXB0
b3IgdG8gc2V0IHdoZXRoZXIgdGhleSBzaG91bGQgYmUgdHJhY2tlZCBhcyB3YXRjaGVycwogIC0g
cmVuYW1lIFNZU0dFTklEX0ZPUkNFX0dFTl9VUERBVEUgLT4gU1lTR0VOSURfVFJJR0dFUl9HRU5f
VVBEQVRFCiAgLSByZXdvcmsgYWxsIGRvY3VtZW50YXRpb24gdG8gY2xlYXJseSBjYXB0dXJlIGFs
bCBwcmVyZXF1aXNpdGVzIGZvcgogICAgYWNoaWV2aW5nIHNuYXBzaG90IHNhZmV0eSB3aGVuIHVz
aW5nIHRoZSBwcm92aWRlZCBtZWNoYW5pc20KICAtIHN5c2dlbmlkIGRvY3VtZW50YXRpb246IHJl
cGxhY2UgaW5kaXZpZHVhbCBmaWxlc3lzdGVtIG9wZXJhdGlvbnMKICAgIGV4YW1wbGVzIHdpdGgg
YSBoaWdoZXIgbGV2ZWwgZXhhbXBsZSBzaG93Y2FzaW5nIHN5c3RlbS1sZXZlbAogICAgc25hcHNo
b3Qtc2FmZSB3b3JrZmxvdwoKdjQgLT4gdjU6CgogIC0gc3lzZ2VuaWQ6IGdlbmVyYXRpb24gY2hh
bmdlcyBhcmUgYWxzbyBleHBvcnRlZCB0aHJvdWdoIHVldmVudHMKICAtIHJlbW92ZSBTWVNHRU5J
RF9HRVRfT1VUREFURURfV0FUQ0hFUlMgaW9jdGwKICAtIGRvY3VtZW50IHN5c2dlbmlkIGlvY3Rs
IG1ham9yL21pbm9yIG51bWJlcnMKCnYzIC0+IHY0OgoKICAtIHNwbGl0IGZ1bmN0aW9uYWxpdHkg
aW4gdHdvIHNlcGFyYXRlIGtlcm5lbCBtb2R1bGVzOiAKICAgIDEuIGRyaXZlcnMvbWlzYy9zeXNn
ZW5pZC5jIHdoaWNoIHByb3ZpZGVzIHRoZSBnZW5lcmljIHVzZXJzcGFjZQogICAgICAgaW50ZXJm
YWNlIGFuZCBtZWNoYW5pc21zCiAgICAyLiBkcml2ZXJzL3ZpcnQvdm1nZW5pZC5jIGFzIFZNR0VO
SUQgYWNwaSBkZXZpY2UgZHJpdmVyIHRoYXQgc2VlZHMKICAgICAgIGtlcm5lbCBlbnRyb3B5IGFu
ZCBhY3RzIGFzIGEgZHJpdmluZyBiYWNrZW5kIGZvciB0aGUgZ2VuZXJpYwogICAgICAgc3lzZ2Vu
aWQKICAtIHJlbmFtZSAvZGV2L3ZtZ2VuaWQgLT4gL2Rldi9zeXNnZW5pZAogIC0gcmVuYW1lIHVh
cGkgaGVhZGVyIGZpbGUgdm1nZW5pZC5oIC0+IHN5c2dlbmlkLmgKICAtIHJlbmFtZSBpb2N0bHMg
Vk1HRU5JRF8qIC0+IFNZU0dFTklEXyoKICAtIGFkZCDigJhtaW5fZ2Vu4oCZIHBhcmFtZXRlciB0
byBTWVNHRU5JRF9GT1JDRV9HRU5fVVBEQVRFIGlvY3RsCiAgLSBmaXggcmFjZXMgaW4gZG9jdW1l
bnRhdGlvbiBleGFtcGxlcwoKdjIgLT4gdjM6CgogIC0gc2VwYXJhdGUgdGhlIGNvcmUgZHJpdmVy
IGxvZ2ljIGFuZCBpbnRlcmZhY2UsIGZyb20gdGhlIEFDUEkgZGV2aWNlCiAgICBUaGUgQUNQSSB2
bWdlbmlkIGRldmljZSBpcyBub3cgb25lIHBvc3NpYmxlIGJhY2tlbmQKICAtIGZpeCBpc3N1ZSB3
aGVuIHRpbWVvdXQ9MCBpbiBWTUdFTklEX1dBSVRfV0FUQ0hFUlMKICAtIGFkZCBsb2NraW5nIHRv
IGF2b2lkIHJhY2VzIGJldHdlZW4gZnMgb3BzIGhhbmRsZXJzIGFuZCBodyBpcnEKICAgIGRyaXZl
biBnZW5lcmF0aW9uIHVwZGF0ZXMKICAtIGNoYW5nZSBWTUdFTklEX1dBSVRfV0FUQ0hFUlMgaW9j
dGwgc28gaWYgdGhlIGN1cnJlbnQgY2FsbGVyIGlzCiAgICBvdXRkYXRlZCBvciBhIGdlbmVyYXRp
b24gY2hhbmdlIGhhcHBlbnMgd2hpbGUgd2FpdGluZyAodGh1cyBtYWtpbmcKICAgIGN1cnJlbnQg
Y2FsbGVyIG91dGRhdGVkKSwgdGhlIGlvY3RsIHJldHVybnMgLUVJTlRSIHRvIHNpZ25hbCB0aGUK
ICAgIHVzZXIgdG8gaGFuZGxlIGV2ZW50IGFuZCByZXRyeS4gRml4ZXMgYmxvY2tpbmcgb24gb25l
c2VsZgogIC0gYWRkIFZNR0VOSURfRk9SQ0VfR0VOX1VQREFURSBpb2N0bCBjb25kaXRpb25lZCBi
eQogICAgQ0FQX0NIRUNLUE9JTlRfUkVTVE9SRSBjYXBhYmlsaXR5LCB0aHJvdWdoIHdoaWNoIHNv
ZnR3YXJlIGNhbiBmb3JjZQogICAgZ2VuZXJhdGlvbiBidW1wCgp2MSAtPiB2MjoKCiAgLSBleHBv
c2UgdG8gdXNlcnNwYWNlIGEgbW9ub3RvbmljYWxseSBpbmNyZWFzaW5nIHUzMiBWbSBHZW4gQ291
bnRlcgogICAgaW5zdGVhZCBvZiB0aGUgaHcgVm1HZW4gVVVJRAogIC0gc2luY2UgdGhlIGh3L2h5
cGVydmlzb3ItcHJvdmlkZWQgMTI4LWJpdCBVVUlEIGlzIG5vdCBwdWJsaWMKICAgIGFueW1vcmUs
IGFkZCBpdCB0byB0aGUga2VybmVsIFJORyBhcyBkZXZpY2UgcmFuZG9tbmVzcwogIC0gaW5zZXJ0
IGRyaXZlciBwYWdlIGNvbnRhaW5pbmcgVm0gR2VuIENvdW50ZXIgaW4gdGhlIHVzZXIgdm1hIGlu
CiAgICB0aGUgZHJpdmVyJ3MgbW1hcCBoYW5kbGVyIGluc3RlYWQgb2YgdXNpbmcgYSBmYXVsdCBo
YW5kbGVyCiAgLSB0dXJuIGRyaXZlciBpbnRvIGEgbWlzYyBkZXZpY2UgZHJpdmVyIHRvIGF1dG8t
Y3JlYXRlIC9kZXYvdm1nZW5pZAogIC0gY2hhbmdlIGlvY3RsIGFyZyB0byBhdm9pZCBsZWFraW5n
IGtlcm5lbCBzdHJ1Y3RzIHRvIHVzZXJzcGFjZQogIC0gdXBkYXRlIGRvY3VtZW50YXRpb24KCkFk
cmlhbiBDYXRhbmdpdSAoMik6CiAgZHJpdmVycy9taXNjOiBzeXNnZW5pZDogYWRkIHN5c3RlbSBn
ZW5lcmF0aW9uIGlkIGRyaXZlcgogIGRyaXZlcnMvdmlydDogdm1nZW5pZDogYWRkIHZtIGdlbmVy
YXRpb24gaWQgZHJpdmVyCgogRG9jdW1lbnRhdGlvbi9taXNjLWRldmljZXMvc3lzZ2VuaWQucnN0
ICAgICAgICAgICAgfCAyMzQgKysrKysrKysrKysrKysKIERvY3VtZW50YXRpb24vdXNlcnNwYWNl
LWFwaS9pb2N0bC9pb2N0bC1udW1iZXIucnN0IHwgICAxICsKIERvY3VtZW50YXRpb24vdmlydC92
bWdlbmlkLnJzdCAgICAgICAgICAgICAgICAgICAgIHwgIDM2ICsrKwogTUFJTlRBSU5FUlMgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgMTUgKwogZHJpdmVycy9taXNj
L0tjb25maWcgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgMTUgKwogZHJpdmVycy9t
aXNjL01ha2VmaWxlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDEgKwogZHJpdmVy
cy9taXNjL3N5c2dlbmlkLmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAzMzggKysrKysr
KysrKysrKysrKysrKysrCiBkcml2ZXJzL3ZpcnQvS2NvbmZpZyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICB8ICAxMyArCiBkcml2ZXJzL3ZpcnQvTWFrZWZpbGUgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICB8ICAgMSArCiBkcml2ZXJzL3ZpcnQvdm1nZW5pZC5jICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICB8IDE1MyArKysrKysrKysrCiBpbmNsdWRlL3VhcGkvbGludXgvc3lz
Z2VuaWQuaCAgICAgICAgICAgICAgICAgICAgICB8ICAxOCArKwogMTEgZmlsZXMgY2hhbmdlZCwg
ODI1IGluc2VydGlvbnMoKykKIGNyZWF0ZSBtb2RlIDEwMDY0NCBEb2N1bWVudGF0aW9uL21pc2Mt
ZGV2aWNlcy9zeXNnZW5pZC5yc3QKIGNyZWF0ZSBtb2RlIDEwMDY0NCBEb2N1bWVudGF0aW9uL3Zp
cnQvdm1nZW5pZC5yc3QKIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL21pc2Mvc3lzZ2VuaWQu
YwogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvdmlydC92bWdlbmlkLmMKIGNyZWF0ZSBtb2Rl
IDEwMDY0NCBpbmNsdWRlL3VhcGkvbGludXgvc3lzZ2VuaWQuaAoKLS0gCjIuNy40CgoKCgpBbWF6
b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6
IDI3QSBTZi4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwg
NzAwMDQ1LCBSb21hbmlhLiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1i
ZXIgSjIyLzI2MjEvMjAwNS4K


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15FC9285F36
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 14:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgJGMch (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 08:32:37 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:28748 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727253AbgJGMcg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 08:32:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1602073957; x=1633609957;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=mDLvIoEHFTik5FJpqWeNpLs5bMTKxqGcsO8pGtT38Zo=;
  b=kKDmwugXjG4Uy6O2rBvqQu8qVtXJuJt6pnG50S6yzZHcSITDA1FYXLIJ
   EOzIjyz9L7ZqQN6k4sEctT61dIMMY7AmzzaTzED1h7/LSE3CkGjh96f6h
   t/tIpTcE3BhtQGhj7+60feggZS3IIL8MQzfwTFhqaMRszUQk3nY1R8Lp8
   o=;
X-IronPort-AV: E=Sophos;i="5.77,346,1596499200"; 
   d="scan'208";a="58566009"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 07 Oct 2020 12:32:35 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id 11C55A1906;
        Wed,  7 Oct 2020 12:32:33 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 7 Oct 2020 12:32:33 +0000
Received: from Alexanders-MacBook-Air.local (10.43.161.23) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 7 Oct 2020 12:32:31 +0000
Subject: Re: [PATCH 2/4] selftests: kvm: Clear uc so UCALL_NONE is being
 properly reported
To:     Aaron Lewis <aaronlewis@google.com>
CC:     <pshier@google.com>, <jmattson@google.com>, <kvm@vger.kernel.org>,
        "Andrew Jones" <drjones@redhat.com>
References: <20201006210444.1342641-1-aaronlewis@google.com>
 <20201006210444.1342641-3-aaronlewis@google.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <89729ade-1361-5b77-ca34-239d9ab2c18a@amazon.com>
Date:   Wed, 7 Oct 2020 14:32:29 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201006210444.1342641-3-aaronlewis@google.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.23]
X-ClientProxiedBy: EX13D30UWB004.ant.amazon.com (10.43.161.51) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwNi4xMC4yMCAyMzowNCwgQWFyb24gTGV3aXMgd3JvdGU6Cj4gCj4gRW5zdXJlIHRoZSBv
dXQgdmFsdWUgJ3VjJyBpbiBnZXRfdWNhbGwoKSBpcyBwcm9wZXJseSByZXBvcnRpbmcKPiBVQ0FM
TF9OT05FIGlmIHRoZSBjYWxsIGZhaWxzLiAgVGhlIHJldHVybiB2YWx1ZSB3aWxsIGJlIGNvcnJl
Y3RseQo+IHJlcG9ydGVkLCBob3dldmVyLCB0aGUgb3V0IHBhcmFtZXRlciAndWMnIHdpbGwgbm90
IGJlLiAgQ2xlYXIgdGhlIHN0cnVjdAo+IHRvIGVuc3VyZSB0aGUgY29ycmVjdCB2YWx1ZSBpcyBi
ZWluZyByZXBvcnRlZCBpbiB0aGUgb3V0IHBhcmFtZXRlci4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBB
YXJvbiBMZXdpcyA8YWFyb25sZXdpc0Bnb29nbGUuY29tPgo+IFJldmlld2VkLWJ5OiBBbmRyZXcg
Sm9uZXMgPGRyam9uZXNAcmVkaGF0LmNvbT4KClJldmlld2VkLWJ5OiBBbGV4YW5kZXIgR3JhZiA8
Z3JhZkBhbWF6b24uY29tPgoKCkFsZXgKCj4gLS0tCj4gICB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0
cy9rdm0vbGliL2FhcmNoNjQvdWNhbGwuYyB8IDMgKysrCj4gICB0b29scy90ZXN0aW5nL3NlbGZ0
ZXN0cy9rdm0vbGliL3MzOTB4L3VjYWxsLmMgICB8IDMgKysrCj4gICB0b29scy90ZXN0aW5nL3Nl
bGZ0ZXN0cy9rdm0vbGliL3g4Nl82NC91Y2FsbC5jICB8IDMgKysrCj4gICAzIGZpbGVzIGNoYW5n
ZWQsIDkgaW5zZXJ0aW9ucygrKQo+IAo+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0
ZXN0cy9rdm0vbGliL2FhcmNoNjQvdWNhbGwuYyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2
bS9saWIvYWFyY2g2NC91Y2FsbC5jCj4gaW5kZXggYzhlMGVjMjBkM2JmLi4yZjM3YjkwZWUxYTkg
MTAwNjQ0Cj4gLS0tIGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2xpYi9hYXJjaDY0L3Vj
YWxsLmMKPiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vbGliL2FhcmNoNjQvdWNh
bGwuYwo+IEBAIC05NCw2ICs5NCw5IEBAIHVpbnQ2NF90IGdldF91Y2FsbChzdHJ1Y3Qga3ZtX3Zt
ICp2bSwgdWludDMyX3QgdmNwdV9pZCwgc3RydWN0IHVjYWxsICp1YykKPiAgICAgICAgICBzdHJ1
Y3Qga3ZtX3J1biAqcnVuID0gdmNwdV9zdGF0ZSh2bSwgdmNwdV9pZCk7Cj4gICAgICAgICAgc3Ry
dWN0IHVjYWxsIHVjYWxsID0ge307Cj4gCj4gKyAgICAgICBpZiAodWMpCj4gKyAgICAgICAgICAg
ICAgIG1lbXNldCh1YywgMCwgc2l6ZW9mKCp1YykpOwo+ICsKPiAgICAgICAgICBpZiAocnVuLT5l
eGl0X3JlYXNvbiA9PSBLVk1fRVhJVF9NTUlPICYmCj4gICAgICAgICAgICAgIHJ1bi0+bW1pby5w
aHlzX2FkZHIgPT0gKHVpbnQ2NF90KXVjYWxsX2V4aXRfbW1pb19hZGRyKSB7Cj4gICAgICAgICAg
ICAgICAgICB2bV92YWRkcl90IGd2YTsKPiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxm
dGVzdHMva3ZtL2xpYi9zMzkweC91Y2FsbC5jIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3Zt
L2xpYi9zMzkweC91Y2FsbC5jCj4gaW5kZXggZmQ1ODlkYzliZmFiLi45ZDNiMGYxNTI0OWEgMTAw
NjQ0Cj4gLS0tIGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2xpYi9zMzkweC91Y2FsbC5j
Cj4gKysrIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2xpYi9zMzkweC91Y2FsbC5jCj4g
QEAgLTM4LDYgKzM4LDkgQEAgdWludDY0X3QgZ2V0X3VjYWxsKHN0cnVjdCBrdm1fdm0gKnZtLCB1
aW50MzJfdCB2Y3B1X2lkLCBzdHJ1Y3QgdWNhbGwgKnVjKQo+ICAgICAgICAgIHN0cnVjdCBrdm1f
cnVuICpydW4gPSB2Y3B1X3N0YXRlKHZtLCB2Y3B1X2lkKTsKPiAgICAgICAgICBzdHJ1Y3QgdWNh
bGwgdWNhbGwgPSB7fTsKPiAKPiArICAgICAgIGlmICh1YykKPiArICAgICAgICAgICAgICAgbWVt
c2V0KHVjLCAwLCBzaXplb2YoKnVjKSk7Cj4gKwo+ICAgICAgICAgIGlmIChydW4tPmV4aXRfcmVh
c29uID09IEtWTV9FWElUX1MzOTBfU0lFSUMgJiYKPiAgICAgICAgICAgICAgcnVuLT5zMzkwX3Np
ZWljLmljcHRjb2RlID09IDQgJiYKPiAgICAgICAgICAgICAgKHJ1bi0+czM5MF9zaWVpYy5pcGEg
Pj4gOCkgPT0gMHg4MyAmJiAgICAvKiAweDgzIG1lYW5zIERJQUdOT1NFICovCj4gZGlmZiAtLWdp
dCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9saWIveDg2XzY0L3VjYWxsLmMgYi90b29s
cy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vbGliL3g4Nl82NC91Y2FsbC5jCj4gaW5kZXggZGE0ZDg5
YWQ1NDE5Li5hMzQ4OTk3M2UyOTAgMTAwNjQ0Cj4gLS0tIGEvdG9vbHMvdGVzdGluZy9zZWxmdGVz
dHMva3ZtL2xpYi94ODZfNjQvdWNhbGwuYwo+ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3Rz
L2t2bS9saWIveDg2XzY0L3VjYWxsLmMKPiBAQCAtNDAsNiArNDAsOSBAQCB1aW50NjRfdCBnZXRf
dWNhbGwoc3RydWN0IGt2bV92bSAqdm0sIHVpbnQzMl90IHZjcHVfaWQsIHN0cnVjdCB1Y2FsbCAq
dWMpCj4gICAgICAgICAgc3RydWN0IGt2bV9ydW4gKnJ1biA9IHZjcHVfc3RhdGUodm0sIHZjcHVf
aWQpOwo+ICAgICAgICAgIHN0cnVjdCB1Y2FsbCB1Y2FsbCA9IHt9Owo+IAo+ICsgICAgICAgaWYg
KHVjKQo+ICsgICAgICAgICAgICAgICBtZW1zZXQodWMsIDAsIHNpemVvZigqdWMpKTsKPiArCj4g
ICAgICAgICAgaWYgKHJ1bi0+ZXhpdF9yZWFzb24gPT0gS1ZNX0VYSVRfSU8gJiYgcnVuLT5pby5w
b3J0ID09IFVDQUxMX1BJT19QT1JUKSB7Cj4gICAgICAgICAgICAgICAgICBzdHJ1Y3Qga3ZtX3Jl
Z3MgcmVnczsKPiAKPiAtLQo+IDIuMjguMC44MDYuZzg1NjEzNjVlODgtZ29vZwo+IAoKCgpBbWF6
b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApLcmF1c2Vuc3RyLiAzOAoxMDExNyBC
ZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2NobGFlZ2VyLCBKb25hdGhhbiBX
ZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIg
MTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMjg5IDIzNyA4NzkKCgo=


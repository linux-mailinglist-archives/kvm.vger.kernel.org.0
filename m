Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7159428B406
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 13:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388219AbgJLLoP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 07:44:15 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:56143 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388135AbgJLLoP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 07:44:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1602503055; x=1634039055;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=U84fx8pVm+Z2TmCsTavucgq6/dcFyJSIgiuXXQfUYnw=;
  b=NJXNR02jrCfMWNSWee6WR6rFwUrY3piqOapmRfiZHqX5RgNOHvAk9ZqL
   j4lDU0crzfvWFZ6CnF0eCcVWqIaK4q/jBZiO09ELJgGGpoDJur8Zbh69C
   qigFQpqADMWF9izzBdcNbQMRkhTbCbu1cvH/cR1utl6IOXBdjaDWPLBn1
   Y=;
X-IronPort-AV: E=Sophos;i="5.77,366,1596499200"; 
   d="scan'208";a="60728688"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 12 Oct 2020 11:44:09 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id 37610A1F25;
        Mon, 12 Oct 2020 11:44:07 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 12 Oct 2020 11:44:06 +0000
Received: from freeip.amazon.com (10.43.160.116) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 12 Oct 2020 11:44:05 +0000
Subject: Re: [PATCH v2 3/4] selftests: kvm: Add exception handling to
 selftests
To:     Aaron Lewis <aaronlewis@google.com>
CC:     Peter Shier <pshier@google.com>, Jim Mattson <jmattson@google.com>,
        "kvm list" <kvm@vger.kernel.org>
References: <20201009114615.2187411-1-aaronlewis@google.com>
 <20201009114615.2187411-4-aaronlewis@google.com>
 <fbaf1a2d-04b2-6c19-d80f-6fc0459a8583@amazon.com>
 <CAAAPnDFTwb3o44gxdC7ONTJLob44BLus0zEza--j0exhsys=aA@mail.gmail.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <954837b0-884e-26c3-988e-487dffa9e894@amazon.com>
Date:   Mon, 12 Oct 2020 13:44:03 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <CAAAPnDFTwb3o44gxdC7ONTJLob44BLus0zEza--j0exhsys=aA@mail.gmail.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.116]
X-ClientProxiedBy: EX13D46UWC003.ant.amazon.com (10.43.162.119) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwOS4xMC4yMCAxNzozMiwgQWFyb24gTGV3aXMgd3JvdGU6Cj4gCj4+PiArI2lmZGVmIF9f
eDg2XzY0X18KPj4+ICsgICAgICAgYXNzZXJ0X29uX3VuaGFuZGxlZF9leGNlcHRpb24odm0sIHZj
cHVpZCk7Cj4+PiArI2VuZGlmCj4+Cj4+IENhbiB3ZSBhdm9pZCB0aGUgI2lmZGVmIGFuZCBpbnN0
ZWFkIGp1c3QgaW1wbGVtZW50IGEgc3R1YiBmdW5jdGlvbiBmb3IKPj4gdGhlIG90aGVyIGFyY2hz
PyBUaGVuIG1vdmUgdGhlIHByb3RvdHlwZSB0aGUgdGhlIGZ1bmN0aW9uIHRvIGEgZ2VuZXJpYwo+
PiBoZWFkZXIgb2YgY291cnNlLgo+Pgo+PiBBbGV4Cj4gCj4gSSBjb25zaWRlcmVkIHRoYXQsIEkg
ZXZlbiBpbXBsZW1lbnRlZCBpdCB0aGF0IHdheSBhdCBmaXJzdCwgYnV0IHdoZW4gSQo+IGxvb2tl
ZCBhcm91bmQgSSBzYXcgbm8gZXhhbXBsZXMgb2Ygc3R1YnMgaW4gdGhlIG90aGVyIGFyY2hzLCBh
bmQgSSBzYXcKPiBhbiBleGFtcGxlIG9mIGxlYXZpbmcgdGhlICNpZmRlZiB3aXRoIGEgY29ycmVz
cG9uZGluZyBhcmNoIHNwZWNpZmljCj4gaW1wbGVtZW50YXRpb24gIChpZToga3ZtX2dldF9jcHVf
YWRkcmVzc193aWR0aCgpKS4gIFRoYXQncyB3aHkgSSB3ZW50Cj4gd2l0aCBpdCB0aGlzIHdheS4g
IElmIHRoZSBzdHViIGlzIHByZWZlcnJlZCBJIGNhbiBjaGFuZ2UgaXQuCgpXZSB1c3VhbGx5IGRv
IHRoZSBzdHViIHdheSBpbiBub3JtYWwgS1ZNIGNvZGUuIEknZCBwcmVmZXIgdG8gY29weSB0aGF0
IApkZXNpZ24gcGF0dGVybiBpbiB0aGUgc2VsZnRlc3QgY29kZSBhcyB3ZWxsIC0gaXQgbWFrZXMg
dGhpbmdzIGVhc2llciB0byAKZm9sbG93IElNSE8uCgpUaGFua3MsCgpBbGV4CgoKCgpBbWF6b24g
RGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApLcmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJs
aW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2NobGFlZ2VyLCBKb25hdGhhbiBXZWlz
cwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5
MTczIEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMjg5IDIzNyA4NzkKCgo=


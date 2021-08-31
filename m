Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 525973FC3F2
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 10:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240022AbhHaHwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 03:52:38 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:31394 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239790AbhHaHwh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 03:52:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1630396303; x=1661932303;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=/npeHnSmtMQ6KY59GUKY2CTtRRzd744hv+lFFf40l5o=;
  b=VsTRctcIXSVumFb1GK5753P13dwvtqqqkY4sPoeE9xNEow9b8HcH0nit
   cVOwNDKzPuUpUT5ol6pIbSQEQncmH/d9vnXUKs/jfsfu1+iWe9pU2rM6a
   2+n/nG4NjvFIZutRVtuU00WBUtqOUujPzvSi5EnN5HxQsVrsPLxz3sn3I
   o=;
X-IronPort-AV: E=Sophos;i="5.84,365,1620691200"; 
   d="scan'208";a="156263196"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 31 Aug 2021 07:51:35 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 4C5DFA2273;
        Tue, 31 Aug 2021 07:51:32 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.176) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Tue, 31 Aug 2021 07:51:25 +0000
Subject: Re: [PATCH v3 1/7] nitro_enclaves: Enable Arm64 support
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     George-Aurelian Popescu <popegeo@amazon.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexandru Ciobotaru <alcioa@amazon.com>,
        Kamal Mostafa <kamal@canonical.com>,
        Alexandru Vasile <lexnv@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
References: <20210827154930.40608-1-andraprs@amazon.com>
 <20210827154930.40608-2-andraprs@amazon.com>
 <20210830155907.GG10224@u90cef543d0ab5a.ant.amazon.com>
 <f57fd0eb-271c-b8d7-ee9b-276c0f0c62ba@amazon.com>
 <YS3Peu/ax4gAVb6P@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <2320e152-e2bf-14dd-e427-d26b936b6a83@amazon.com>
Date:   Tue, 31 Aug 2021 10:51:14 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YS3Peu/ax4gAVb6P@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.176]
X-ClientProxiedBy: EX13D40UWC004.ant.amazon.com (10.43.162.175) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAzMS8wOC8yMDIxIDA5OjQzLCBHcmVnIEtIIHdyb3RlOgo+IE9uIE1vbiwgQXVnIDMwLCAy
MDIxIGF0IDA5OjMwOjA0UE0gKzAzMDAsIFBhcmFzY2hpdiwgQW5kcmEtSXJpbmEgd3JvdGU6Cj4+
Cj4+IE9uIDMwLzA4LzIwMjEgMTg6NTksIEdlb3JnZS1BdXJlbGlhbiBQb3Blc2N1IHdyb3RlOgo+
Pj4gT24gRnJpLCBBdWcgMjcsIDIwMjEgYXQgMDY6NDk6MjRQTSArMDMwMCwgQW5kcmEgUGFyYXNj
aGl2IHdyb3RlOgo+Pj4+IFVwZGF0ZSB0aGUga2VybmVsIGNvbmZpZyB0byBlbmFibGUgdGhlIE5p
dHJvIEVuY2xhdmVzIGtlcm5lbCBkcml2ZXIgZm9yCj4+Pj4gQXJtNjQgc3VwcG9ydC4KPj4+Pgo+
Pj4+IFNpZ25lZC1vZmYtYnk6IEFuZHJhIFBhcmFzY2hpdiA8YW5kcmFwcnNAYW1hem9uLmNvbT4K
Pj4+PiBBY2tlZC1ieTogU3RlZmFubyBHYXJ6YXJlbGxhIDxzZ2FyemFyZUByZWRoYXQuY29tPgo+
Pj4+IC0tLQo+Pj4+IENoYW5nZWxvZwo+Pj4+Cj4+Pj4gdjEgLT4gdjIKPj4+Pgo+Pj4+ICogTm8g
Y2hhbmdlcy4KPj4+Pgo+Pj4+IHYyIC0+IHYzCj4+Pj4KPj4+PiAqIE1vdmUgY2hhbmdlbG9nIGFm
dGVyIHRoZSAiLS0tIiBsaW5lLgo+Pj4+IC0tLQo+Pj4+ICAgIGRyaXZlcnMvdmlydC9uaXRyb19l
bmNsYXZlcy9LY29uZmlnIHwgOCArKy0tLS0tLQo+Pj4+ICAgIDEgZmlsZSBjaGFuZ2VkLCAyIGlu
c2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCj4+Pj4KPj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy92aXJ0L25pdHJvX2VuY2xhdmVzL0tjb25maWcgYi9kcml2ZXJzL3ZpcnQvbml0cm9fZW5jbGF2
ZXMvS2NvbmZpZwo+Pj4+IGluZGV4IDhjOTM4N2EyMzJkZjguLmY1Mzc0MGI5NDFjMGYgMTAwNjQ0
Cj4+Pj4gLS0tIGEvZHJpdmVycy92aXJ0L25pdHJvX2VuY2xhdmVzL0tjb25maWcKPj4+PiArKysg
Yi9kcml2ZXJzL3ZpcnQvbml0cm9fZW5jbGF2ZXMvS2NvbmZpZwo+Pj4+IEBAIC0xLDE3ICsxLDEz
IEBACj4+Pj4gICAgIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMAo+Pj4+ICAgICMK
Pj4+PiAtIyBDb3B5cmlnaHQgMjAyMCBBbWF6b24uY29tLCBJbmMuIG9yIGl0cyBhZmZpbGlhdGVz
LiBBbGwgUmlnaHRzIFJlc2VydmVkLgo+Pj4+ICsjIENvcHlyaWdodCAyMDIwLTIwMjEgQW1hem9u
LmNvbSwgSW5jLiBvciBpdHMgYWZmaWxpYXRlcy4gQWxsIFJpZ2h0cyBSZXNlcnZlZC4KPj4+PiAg
ICAjIEFtYXpvbiBOaXRybyBFbmNsYXZlcyAoTkUpIHN1cHBvcnQuCj4+Pj4gICAgIyBOaXRybyBp
cyBhIGh5cGVydmlzb3IgdGhhdCBoYXMgYmVlbiBkZXZlbG9wZWQgYnkgQW1hem9uLgo+Pj4+IC0j
IFRPRE86IEFkZCBkZXBlbmRlbmN5IGZvciBBUk02NCBvbmNlIE5FIGlzIHN1cHBvcnRlZCBvbiBB
cm0gcGxhdGZvcm1zLiBGb3Igbm93LAo+Pj4+IC0jIHRoZSBORSBrZXJuZWwgZHJpdmVyIGNhbiBi
ZSBidWlsdCBmb3IgYWFyY2g2NCBhcmNoLgo+Pj4+IC0jIGRlcGVuZHMgb24gKEFSTTY0IHx8IFg4
NikgJiYgSE9UUExVR19DUFUgJiYgUENJICYmIFNNUAo+Pj4+IC0KPj4+PiAgICBjb25maWcgTklU
Uk9fRU5DTEFWRVMKPj4+PiAgICAgICAgICAgIHRyaXN0YXRlICJOaXRybyBFbmNsYXZlcyBTdXBw
b3J0Igo+Pj4+IC0gZGVwZW5kcyBvbiBYODYgJiYgSE9UUExVR19DUFUgJiYgUENJICYmIFNNUAo+
Pj4+ICsgZGVwZW5kcyBvbiAoQVJNNjQgfHwgWDg2KSAmJiBIT1RQTFVHX0NQVSAmJiBQQ0kgJiYg
U01QCj4+Pj4gICAgICAgICAgICBoZWxwCj4+Pj4gICAgICAgICAgICAgIFRoaXMgZHJpdmVyIGNv
bnNpc3RzIG9mIHN1cHBvcnQgZm9yIGVuY2xhdmUgbGlmZXRpbWUgbWFuYWdlbWVudAo+Pj4+ICAg
ICAgICAgICAgICBmb3IgTml0cm8gRW5jbGF2ZXMgKE5FKS4KPj4+PiAtLQo+Pj4+IDIuMjAuMSAo
QXBwbGUgR2l0LTExNykKPj4+Pgo+Pj4gUmV2aWV3ZWQtYnk6IEdlb3JnZS1BdXJlbGlhbiBQb3Bl
c2N1IDxwb3BlZ2VvQGFtYXpvbi5jb20+Cj4+Pgo+PiBUaGFua3MsIEdlb3JnZSwgZm9yIHJldmll
dy4KPj4KPj4gR3JlZywgbGV0IG1lIGtub3cgaWYgb3RoZXIgdXBkYXRlcyBhcmUgbmVlZGVkIGZv
ciB0aGUgcGF0Y2ggc2VyaWVzLgo+PiBPdGhlcndpc2UsIHBsZWFzZSBpbmNsdWRlIHRoZSBwYXRj
aGVzIGluIHRoZSBjaGFyLW1pc2MgdHJlZSBhbmQgd2UgY2FuCj4+IHRhcmdldCB0aGUgY3VycmVu
dCBtZXJnZSB3aW5kb3csIGZvciB2NS4xNS4gVGhhbmsgeW91Lgo+IEl0J3MgdG9vIGxhdGUgZm9y
IDUuMTUtcmMxLCBJIHdpbGwgcXVldWUgdGhlbSB1cCBhZnRlciA1LjE1LXJjMSBpcyBvdXQsCj4g
dGhhbmtzLgoKQWNrLCB0aGFua3MgZm9yIGluZm8uIFRoZW4gd291bGQgYmUgdGhlIG5leHQgcmMs
IG5vIGZ1bmN0aW9uYWwgY29kZWJhc2UgCmNoYW5nZXMgYmVpbmcgaW5jbHVkZWQuIE9yIGp1c3Qg
bGV0IG1lIGtub3cgaWYgb3RoZXIgcmVsZWFzZSBwaGFzZSB3b3VsZCAKYmUgdGFyZ2V0ZWQuCgpU
aGFua3MsCkFuZHJhCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5M
LiByZWdpc3RlcmVkIG9mZmljZTogMjdBIFNmLiBMYXphciBTdHJlZXQsIFVCQzUsIGZsb29yIDIs
IElhc2ksIElhc2kgQ291bnR5LCA3MDAwNDUsIFJvbWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9tYW5p
YS4gUmVnaXN0cmF0aW9uIG51bWJlciBKMjIvMjYyMS8yMDA1Lgo=


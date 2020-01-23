Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 873F8146BD9
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 15:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgAWOxF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 09:53:05 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:6510 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728205AbgAWOxE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 09:53:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1579791184; x=1611327184;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=2VQokRCHziAuiLVO2+k8TJt4qyueJnIeoeEPU27KRmA=;
  b=mD+YpZ+It3m2XTX11aJULEzGAPntC48F1PHhuLnlGIqYXC8pP1uvK0aK
   NsTpqx43MTSALM/IWyUTgHmGHO1SCR77ftuuWUzSEA/MpIKEvFOjxomBL
   TlTjDTc6CtPRlL7duCQjLvvkvREsWj5tUGL+9Pie+oLBd9JThA3xdVv73
   Q=;
IronPort-SDR: ebn1XtRkZnkd0e1K20PIM0snewRWQEndkQu+eWzI81+IaaN6aRrbvMSHXKA9ZpmCwTdKoQNuHa
 Y5gPpqZfKLvQ==
X-IronPort-AV: E=Sophos;i="5.70,354,1574121600"; 
   d="scan'208";a="12947622"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-55156cd4.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 23 Jan 2020 14:53:00 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-55156cd4.us-west-2.amazon.com (Postfix) with ESMTPS id 446DFA1B26;
        Thu, 23 Jan 2020 14:52:57 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 23 Jan 2020 14:52:56 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.18) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 23 Jan 2020 14:52:50 +0000
Subject: Re: [PATCH v16.1 0/9] mm / virtio: Provide support for free page
 reporting
To:     David Hildenbrand <david@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        <kvm@vger.kernel.org>, <mst@redhat.com>,
        <linux-kernel@vger.kernel.org>, <willy@infradead.org>,
        <mhocko@kernel.org>, <linux-mm@kvack.org>,
        <akpm@linux-foundation.org>, <mgorman@techsingularity.net>,
        <vbabka@suse.cz>
CC:     <yang.zhang.wz@gmail.com>, <nitesh@redhat.com>,
        <konrad.wilk@oracle.com>, <pagupta@redhat.com>, <riel@surriel.com>,
        <lcapitulino@redhat.com>, <dave.hansen@intel.com>,
        <wei.w.wang@intel.com>, <aarcange@redhat.com>,
        <pbonzini@redhat.com>, <dan.j.williams@intel.com>,
        <alexander.h.duyck@linux.intel.com>, <osalvador@suse.de>,
        "Paterson-Jones, Roland" <rolandp@amazon.com>,
        <hannes@cmpxchg.org>, <hare@suse.com>
References: <20200122173040.6142.39116.stgit@localhost.localdomain>
 <914aa4c3-c814-45e0-830b-02796b00b762@amazon.com>
 <0e2d04a8-af74-e2db-cab0-c67286e33a2a@redhat.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <5d2daec8-985c-c0a4-4832-8e5493316306@amazon.com>
Date:   Thu, 23 Jan 2020 15:52:48 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <0e2d04a8-af74-e2db-cab0-c67286e33a2a@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.18]
X-ClientProxiedBy: EX13D22UWC003.ant.amazon.com (10.43.162.250) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMy4wMS4yMCAxNTowNSwgRGF2aWQgSGlsZGVuYnJhbmQgd3JvdGU6Cj4gT24gMjMuMDEu
MjAgMTE6MjAsIEFsZXhhbmRlciBHcmFmIHdyb3RlOgo+PiBIaSBBbGV4LAo+Pgo+PiBPbiAyMi4w
MS4yMCAxODo0MywgQWxleGFuZGVyIER1eWNrIHdyb3RlOgo+Pj4gVGhpcyBzZXJpZXMgcHJvdmlk
ZXMgYW4gYXN5bmNocm9ub3VzIG1lYW5zIG9mIHJlcG9ydGluZyBmcmVlIGd1ZXN0IHBhZ2VzCj4+
PiB0byBhIGh5cGVydmlzb3Igc28gdGhhdCB0aGUgbWVtb3J5IGFzc29jaWF0ZWQgd2l0aCB0aG9z
ZSBwYWdlcyBjYW4gYmUKPj4+IGRyb3BwZWQgYW5kIHJldXNlZCBieSBvdGhlciBwcm9jZXNzZXMg
YW5kL29yIGd1ZXN0cyBvbiB0aGUgaG9zdC4gVXNpbmcKPj4+IHRoaXMgaXQgaXMgcG9zc2libGUg
dG8gYXZvaWQgdW5uZWNlc3NhcnkgSS9PIHRvIGRpc2sgYW5kIGdyZWF0bHkgaW1wcm92ZQo+Pj4g
cGVyZm9ybWFuY2UgaW4gdGhlIGNhc2Ugb2YgbWVtb3J5IG92ZXJjb21taXQgb24gdGhlIGhvc3Qu
Cj4+Pgo+Pj4gV2hlbiBlbmFibGVkIHdlIHdpbGwgYmUgcGVyZm9ybWluZyBhIHNjYW4gb2YgZnJl
ZSBtZW1vcnkgZXZlcnkgMiBzZWNvbmRzCj4+PiB3aGlsZSBwYWdlcyBvZiBzdWZmaWNpZW50bHkg
aGlnaCBvcmRlciBhcmUgYmVpbmcgZnJlZWQuIEluIGVhY2ggcGFzcyBhdAo+Pj4gbGVhc3Qgb25l
IHNpeHRlZW50aCBvZiBlYWNoIGZyZWUgbGlzdCB3aWxsIGJlIHJlcG9ydGVkLiBCeSBkb2luZyB0
aGlzIHdlCj4+PiBhdm9pZCByYWNpbmcgYWdhaW5zdCBvdGhlciB0aHJlYWRzIHRoYXQgbWF5IGJl
IGNhdXNpbmcgYSBoaWdoIGFtb3VudCBvZgo+Pj4gbWVtb3J5IGNodXJuLgo+Pj4KPj4+IFRoZSBs
b3dlc3QgcGFnZSBvcmRlciBjdXJyZW50bHkgc2Nhbm5lZCB3aGVuIHJlcG9ydGluZyBwYWdlcyBp
cwo+Pj4gcGFnZWJsb2NrX29yZGVyIHNvIHRoYXQgdGhpcyBmZWF0dXJlIHdpbGwgbm90IGludGVy
ZmVyZSB3aXRoIHRoZSB1c2Ugb2YKPj4+IFRyYW5zcGFyZW50IEh1Z2UgUGFnZXMgaW4gdGhlIGNh
c2Ugb2YgdmlydHVhbGl6YXRpb24uCj4+Pgo+Pj4gQ3VycmVudGx5IHRoaXMgaXMgb25seSBpbiB1
c2UgYnkgdmlydGlvLWJhbGxvb24gaG93ZXZlciB0aGVyZSBpcyB0aGUgaG9wZQo+Pj4gdGhhdCBh
dCBzb21lIHBvaW50IGluIHRoZSBmdXR1cmUgb3RoZXIgaHlwZXJ2aXNvcnMgbWlnaHQgYmUgYWJs
ZSB0byBtYWtlCj4+PiB1c2Ugb2YgaXQuIEluIHRoZSB2aXJ0aW8tYmFsbG9vbi9RRU1VIGltcGxl
bWVudGF0aW9uIHRoZSBoeXBlcnZpc29yIGlzCj4+PiBjdXJyZW50bHkgdXNpbmcgTUFEVl9ET05U
TkVFRCB0byBpbmRpY2F0ZSB0byB0aGUgaG9zdCBrZXJuZWwgdGhhdCB0aGUgcGFnZQo+Pj4gaXMg
Y3VycmVudGx5IGZyZWUuIEl0IHdpbGwgYmUgemVyb2VkIGFuZCBmYXVsdGVkIGJhY2sgaW50byB0
aGUgZ3Vlc3QgdGhlCj4+PiBuZXh0IHRpbWUgdGhlIHBhZ2UgaXMgYWNjZXNzZWQuCj4+Pgo+Pj4g
VG8gdHJhY2sgaWYgYSBwYWdlIGlzIHJlcG9ydGVkIG9yIG5vdCB0aGUgVXB0b2RhdGUgZmxhZyB3
YXMgcmVwdXJwb3NlZCBhbmQKPj4+IHVzZWQgYXMgYSBSZXBvcnRlZCBmbGFnIGZvciBCdWRkeSBw
YWdlcy4gV2Ugd2FsayB0aG91Z2ggdGhlIGZyZWUgbGlzdAo+Pj4gaXNvbGF0aW5nIHBhZ2VzIGFu
ZCBhZGRpbmcgdGhlbSB0byB0aGUgc2NhdHRlcmxpc3QgdW50aWwgd2UgZWl0aGVyCj4+PiBlbmNv
dW50ZXIgdGhlIGVuZCBvZiB0aGUgbGlzdCwgcHJvY2Vzc2VkIGFzIG1hbnkgcGFnZXMgYXMgd2Vy
ZSBsaXN0ZWQgaW4KPj4+IG5yX2ZyZWUgcHJpb3IgdG8gdXMgc3RhcnRpbmcsIG9yIGhhdmUgZmls
bGVkIHRoZSBzY2F0dGVybGlzdCB3aXRoIHBhZ2VzIHRvCj4+PiBiZSByZXBvcnRlZC4gSWYgd2Ug
ZmlsbCB0aGUgc2NhdHRlcmxpc3QgYmVmb3JlIHdlIHJlYWNoIHRoZSBlbmQgb2YgdGhlCj4+PiBs
aXN0IHdlIHJvdGF0ZSB0aGUgbGlzdCBzbyB0aGF0IHRoZSBmaXJzdCB1bnJlcG9ydGVkIHBhZ2Ug
d2UgZW5jb3VudGVyIGlzCj4+PiBtb3ZlZCB0byB0aGUgaGVhZCBvZiB0aGUgbGlzdCBhcyB0aGF0
IGlzIHdoZXJlIHdlIHdpbGwgcmVzdW1lIGFmdGVyIHdlCj4+PiBoYXZlIGZyZWVkIHRoZSByZXBv
cnRlZCBwYWdlcyBiYWNrIGludG8gdGhlIHRhaWwgb2YgdGhlIGxpc3QuCj4+Pgo+Pj4gQmVsb3cg
YXJlIHRoZSByZXN1bHRzIGZyb20gdmFyaW91cyBiZW5jaG1hcmtzLiBJIHByaW1hcmlseSBmb2N1
c2VkIG9uIHR3bwo+Pj4gdGVzdHMuIFRoZSBmaXJzdCBpcyB0aGUgd2lsbC1pdC1zY2FsZS9wYWdl
X2ZhdWx0MiB0ZXN0LCBhbmQgdGhlIG90aGVyIGlzCj4+PiBhIG1vZGlmaWVkIHZlcnNpb24gb2Yg
d2lsbC1pdC1zY2FsZS9wYWdlX2ZhdWx0MSB0aGF0IHdhcyBlbmFibGVkIHRvIHVzZQo+Pj4gVEhQ
LiBJIGRpZCB0aGlzIGFzIGl0IGFsbG93cyBmb3IgYmV0dGVyIHZpc2liaWxpdHkgaW50byBkaWZm
ZXJlbnQgcGFydHMKPj4+IG9mIHRoZSBtZW1vcnkgc3Vic3lzdGVtLiBUaGUgZ3Vlc3QgaXMgcnVu
bmluZyB3aXRoIDMyRyBmb3IgUkFNIG9uIG9uZQo+Pj4gbm9kZSBvZiBhIEU1LTI2MzAgdjMuIFRo
ZSBob3N0IGhhcyBoYWQgc29tZSBmZWF0dXJlcyBzdWNoIGFzIENQVSB0dXJibwo+Pj4gZGlzYWJs
ZWQgaW4gdGhlIEJJT1MuCj4+Pgo+Pj4gVGVzdCAgICAgICAgICAgICAgICAgICBwYWdlX2ZhdWx0
MSAoVEhQKSAgICBwYWdlX2ZhdWx0Mgo+Pj4gTmFtZSAgICAgICAgICAgIHRhc2tzICBQcm9jZXNz
IEl0ZXIgIFNUREVWICBQcm9jZXNzIEl0ZXIgIFNUREVWCj4+PiBCYXNlbGluZSAgICAgICAgICAg
IDEgICAgMTAxMjQwMi41MCAgMC4xNCUgICAgIDM2MTg1NS4yNSAgMC44MSUKPj4+ICAgICAgICAg
ICAgICAgICAgICAgIDE2ICAgIDg4Mjc0NTcuMjUgIDAuMDklICAgIDMyODIzNDcuMDAgIDAuMzQl
Cj4+Pgo+Pj4gUGF0Y2hlcyBBcHBsaWVkICAgICAxICAgIDEwMDc4OTcuMDAgIDAuMjMlICAgICAz
NjE4ODcuMDAgIDAuMjYlCj4+PiAgICAgICAgICAgICAgICAgICAgICAxNiAgICA4Nzg0NzQxLjc1
ICAwLjM5JSAgICAzMjQwNjY5LjI1ICAwLjQ4JQo+Pj4KPj4+IFBhdGNoZXMgRW5hYmxlZCAgICAg
MSAgICAxMDEwMjI3LjUwICAwLjM5JSAgICAgMzU5NzQ5LjI1ICAwLjU2JQo+Pj4gICAgICAgICAg
ICAgICAgICAgICAgMTYgICAgODc1NjIxOS4wMCAgMC4yNCUgICAgMzIyNjYwOC43NSAgMC45NyUK
Pj4+Cj4+PiBQYXRjaGVzIEVuYWJsZWQgICAgIDEgICAgMTA1MDk4Mi4wMCAgNC4yNiUgICAgIDM1
Nzk2Ni4yNSAgMC4xNCUKPj4+ICAgIHBhZ2Ugc2h1ZmZsZSAgICAgIDE2ICAgIDg2NzI2MDEuMjUg
IDAuNDklICAgIDMyMjMxNzcuNzUgIDAuNDAlCj4+Pgo+Pj4gUGF0Y2hlcyBlbmFibGVkICAgICAx
ICAgIDEwMDMyMzguMDAgIDAuMjIlICAgICAzNjAyMTEuMDAgIDAuMjIlCj4+PiAgICBzaHVmZmxl
IHcvIFJGQyAgICAxNiAgICA4NzY3MDEwLjUwICAwLjMyJSAgICAzMTk5ODc0LjAwICAwLjcxJQo+
Pj4KPj4+IFRoZSByZXN1bHRzIGFib3ZlIGFyZSBmb3IgYSBiYXNlbGluZSB3aXRoIGEgbGludXgt
bmV4dC0yMDE5MTIxOSBrZXJuZWwsCj4+PiB0aGF0IGtlcm5lbCB3aXRoIHRoaXMgcGF0Y2ggc2V0
IGFwcGxpZWQgYnV0IHBhZ2UgcmVwb3J0aW5nIGRpc2FibGVkIGluCj4+PiB2aXJ0aW8tYmFsbG9v
biwgdGhlIHBhdGNoZXMgYXBwbGllZCBhbmQgcGFnZSByZXBvcnRpbmcgZnVsbHkgZW5hYmxlZCwg
dGhlCj4+PiBwYXRjaGVzIGVuYWJsZWQgd2l0aCBwYWdlIHNodWZmbGluZyBlbmFibGVkLCBhbmQg
dGhlIHBhdGNoZXMgYXBwbGllZCB3aXRoCj4+PiBwYWdlIHNodWZmbGluZyBlbmFibGVkIGFuZCBh
biBSRkMgcGF0Y2ggdGhhdCBtYWtlcyB1c2VkIG9mIE1BRFZfRlJFRSBpbgo+Pj4gUUVNVS4gVGhl
c2UgcmVzdWx0cyBpbmNsdWRlIHRoZSBkZXZpYXRpb24gc2VlbiBiZXR3ZWVuIHRoZSBhdmVyYWdl
IHZhbHVlCj4+PiByZXBvcnRlZCBoZXJlIHZlcnN1cyB0aGUgaGlnaCBhbmQvb3IgbG93IHZhbHVl
LiBJIG9ic2VydmVkIHRoYXQgZHVyaW5nIHRoZQo+Pj4gdGVzdCBtZW1vcnkgdXNhZ2UgZm9yIHRo
ZSBmaXJzdCB0aHJlZSB0ZXN0cyBuZXZlciBkcm9wcGVkIHdoZXJlYXMgd2l0aCB0aGUKPj4+IHBh
dGNoZXMgZnVsbHkgZW5hYmxlZCB0aGUgVk0gd291bGQgZHJvcCB0byB1c2luZyBvbmx5IGEgZmV3
IEdCIG9mIHRoZQo+Pj4gaG9zdCdzIG1lbW9yeSB3aGVuIHN3aXRjaGluZyBmcm9tIG1lbWhvZyB0
byBwYWdlIGZhdWx0IHRlc3RzLgo+Pj4KPj4+IEFueSBvZiB0aGUgb3ZlcmhlYWQgdmlzaWJsZSB3
aXRoIHRoaXMgcGF0Y2ggc2V0IGVuYWJsZWQgc2VlbXMgZHVlIHRvIHBhZ2UKPj4+IGZhdWx0cyBj
YXVzZWQgYnkgYWNjZXNzaW5nIHRoZSByZXBvcnRlZCBwYWdlcyBhbmQgdGhlIGhvc3QgemVyb2lu
ZyB0aGUgcGFnZQo+Pj4gYmVmb3JlIGdpdmluZyBpdCBiYWNrIHRvIHRoZSBndWVzdC4gVGhpcyBv
dmVyaGVhZCBpcyBtdWNoIG1vcmUgdmlzaWJsZSB3aGVuCj4+PiB1c2luZyBUSFAgdGhhbiB3aXRo
IHN0YW5kYXJkIDRLIHBhZ2VzLiBJbiBhZGRpdGlvbiBwYWdlIHNodWZmbGluZyBzZWVtZWQgdG8K
Pj4+IGluY3JlYXNlIHRoZSBhbW91bnQgb2YgZmF1bHRzIGdlbmVyYXRlZCBkdWUgdG8gYW4gaW5j
cmVhc2UgaW4gbWVtb3J5IGNodXJuLgo+Pj4gVGhlIG92ZXJoZWFkIGlzIHJlZHVjZWQgd2hlbiB1
c2luZyBNQURWX0ZSRUUgYXMgd2UgY2FuIGF2b2lkIHRoZSBleHRyYQo+Pj4gemVyb2luZyBvZiB0
aGUgcGFnZXMgd2hlbiB0aGV5IGFyZSByZWludHJvZHVjZWQgdG8gdGhlIGhvc3QsIGFzIGNhbiBi
ZSBzZWVuCj4+PiB3aGVuIHRoZSBSRkMgaXMgYXBwbGllZCB3aXRoIHNodWZmbGluZyBlbmFibGVk
Lgo+Pj4KPj4+IFRoZSBvdmVyYWxsIGd1ZXN0IHNpemUgaXMga2VwdCBmYWlybHkgc21hbGwgdG8g
b25seSBhIGZldyBHQiB3aGlsZSB0aGUgdGVzdAo+Pj4gaXMgcnVubmluZy4gSWYgdGhlIGhvc3Qg
bWVtb3J5IHdlcmUgb3ZlcnN1YnNjcmliZWQgdGhpcyBwYXRjaCBzZXQgc2hvdWxkCj4+PiByZXN1
bHQgaW4gYSBwZXJmb3JtYW5jZSBpbXByb3ZlbWVudCBhcyBzd2FwcGluZyBtZW1vcnkgaW4gdGhl
IGhvc3QgY2FuIGJlCj4+PiBhdm9pZGVkLgo+Pgo+Pgo+PiBJIHJlYWxseSBsaWtlIHRoZSBhcHBy
b2FjaCBvdmVyYWxsLiBWb2x1bnRhcmlseSBwcm9wYWdhdGluZyBmcmVlIG1lbW9yeQo+PiBmcm9t
IGEgZ3Vlc3QgdG8gdGhlIGhvc3QgaGFzIGJlZW4gYSBzb3JlIHBvaW50IGV2ZXIgc2luY2UgS1ZN
IHdhcwo+PiBhcm91bmQuIFRoaXMgc29sdXRpb24gbG9va3MgbGlrZSBhIHZlcnkgZWxlZ2FudCB3
YXkgdG8gZG8gc28uCj4+Cj4+IFRoZSBiaWcgcGllY2UgSSdtIG1pc3NpbmcgaXMgdGhlIHBhZ2Ug
Y2FjaGUuIExpbnV4IHdpbGwgYnkgZGVmYXVsdCB0cnkKPj4gdG8ga2VlcCB0aGUgZnJlZSBsaXN0
IGFzIHNtYWxsIGFzIGl0IGNhbiBpbiBmYXZvciBvZiBwYWdlIGNhY2hlLCBzbyBtb3N0Cj4+IG9m
IHRoZSBiZW5lZml0IG9mIHRoaXMgcGF0Y2ggc2V0IHdpbGwgYmUgdm9pZCBpbiByZWFsIHdvcmxk
IHNjZW5hcmlvcy4KPiAKPiBPbmUgYXBwcm9hY2ggaXMgdG8gbW92ZSAocGFydHMgb2YpIHRoZSBw
YWdlIGNhY2hlIGZyb20gdGhlIGd1ZXN0IHRvIHRoZQo+IGh5cGVydmlzb3IgLSBlLmcuLCB1c2lu
ZyBlbXVsYXRlZCBOVkRJTU0gb3IgdmlydGlvLXBtZW0uCgpXaGV0aGVyIHlvdSBjYW4gZG8gdGhh
dCBkZXBlbmRzIGhlYXZpbHkgb24geW91ciB2aXJ0dWFsaXphdGlvbiAKZW52aXJvbm1lbnQuIE9u
IGEgaG9zdCB3aXRoIHNpbmdsZSB0ZW5hbnQgVk1zLCB0aGF0J3MgZGVmaW5pdGVseSAKZmVhc2li
bGUuIEluIGEgS3ViZXJuZXRlcyBlbnZpcm9ubWVudCwgaXQgbWlnaHQgYWxzbyBiZSBmZWFzaWJs
ZS4KCkJ1dCB3aGVuIHlvdSBoYXZlIFZNcyB0aGF0IGFzc3VtZSB0aGF0IHRoZSBob3N0IGlzIGlu
dGVyZmVyaW5nIHdpdGggdGhlbSAKYXMgbGl0dGxlIGFzIHBvc3NpYmxlLCBpdCBiZWNvbWVzIGhh
cmRlcjoKCkhvdyBkbyB5b3UgZW5zdXJlIGZhaXJuZXNzIGFjcm9zcyBkaWZmZXJlbnQgVk1zJyBw
YWdlIGNhY2hlIHRoYXQgaXMgCm11bmdlZCBpbnRvIGEgc2luZ2xlIGJpZyBob3N0IG9uZT8KCkRv
IHlvdSBldmVuIGhhdmUgaG9zdCBwYWdlIGNhY2hlIG9yIGFyZSB5b3UgdXNpbmcgU1ItSU9WIC8g
bWRldiBmb3IgCnN0b3JhZ2UgZm9yIHBlcmZvcm1hbmNlIHJlYXNvbnM/CgoKVGhlIHB1enpsZSBp
cyBzdGlsbCBpbmNvbXBsZXRlLCBldmVuIHdpdGggTlZESU1NIGV4cG9zdXJlIHRvIHRoZSBndWVz
dCAKYXMgYW4gb3B0aW9uIHVuZm9ydHVuYXRlbHkgOikuCgoKQWxleAoKCgpBbWF6b24gRGV2ZWxv
cG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApLcmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2Vz
Y2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5n
ZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIK
U2l0ejogQmVybGluClVzdC1JRDogREUgMjg5IDIzNyA4NzkKCgo=


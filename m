Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF1ABCE1B0
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 14:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbfJGM3Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 08:29:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35650 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727467AbfJGM3Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 08:29:25 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 08E49C058CA4;
        Mon,  7 Oct 2019 12:29:25 +0000 (UTC)
Received: from [10.18.17.163] (dhcp-17-163.bos.redhat.com [10.18.17.163])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 550E31001B05;
        Mon,  7 Oct 2019 12:29:07 +0000 (UTC)
Subject: Re: [PATCH v11 0/6] mm / virtio: Provide support for unused page
 reporting
To:     LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        Oscar Salvador <osalvador@suse.de>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Rik van Riel <riel@surriel.com>, lcapitulino@redhat.com,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>
References: <20191001152441.27008.99285.stgit@localhost.localdomain>
 <7233498c-2f64-d661-4981-707b59c78fd5@redhat.com>
 <1ea1a4e11617291062db81f65745b9c95fd0bb30.camel@linux.intel.com>
 <8bd303a6-6e50-b2dc-19ab-4c3f176c4b02@redhat.com>
 <CAKgT0Uf37xAFK2CWqUZJgn7bWznSAi6qncLxBpC55oSpBMG1HQ@mail.gmail.com>
 <c06b68cb-5e94-ae3e-f84e-48087d675a8f@redhat.com>
 <CAKgT0Ud6TT=XxqFx6ePHzbUYqMp5FHVPozRvnNZK3tKV7j2xjg@mail.gmail.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <0a16b11e-ec3b-7196-5b7f-e7395876cf28@redhat.com>
Date:   Mon, 7 Oct 2019 08:29:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0Ud6TT=XxqFx6ePHzbUYqMp5FHVPozRvnNZK3tKV7j2xjg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Mon, 07 Oct 2019 12:29:25 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ck9uIDEwLzIvMTkgMTA6MjUgQU0sIEFsZXhhbmRlciBEdXljayB3cm90ZToKClsuLi5dCj4+
PiBNeSBzdWdnZXN0aW9uIHdvdWxkIGJlIHRvIGxvb2sgYXQgcmV3b3JraW5nIHRoZSBwYXRj
aCBzZXQgYW5kCj4+PiBwb3N0IG51bWJlcnMgZm9yIG15IHBhdGNoIHNldCB2ZXJzdXMgdGhl
IGJpdG1hcCBhcHByb2FjaCBhbmQgd2UgY2FuCj4+PiBsb29rIGF0IHRoZW0gdGhlbi4KPj4g
QWdyZWVkLiBIb3dldmVyLCBpbiBvcmRlciB0byBmaXggYW4gaXNzdWUgSSBoYXZlIHRvIHJl
cHJvZHVjZSBpdCBmaXJzdC4KPiBXaXRoIHRoZSB0d2VhayBJIGhhdmUgc3VnZ2VzdGVkIGFi
b3ZlIGl0IHNob3VsZCBtYWtlIGl0IG11Y2ggZWFzaWVyIHRvCj4gcmVwcm9kdWNlLiBCYXNp
Y2FsbHkgYWxsIHlvdSBuZWVkIGlzIHRvIGhhdmUgdGhlIGFsbG9jYXRpb24gY29tcGV0aW5n
Cj4gYWdhaW5zdCBoaW50aW5nLiBDdXJyZW50bHkgdGhlIGhpbnRpbmcgaXNuJ3QgZG9pbmcg
dGhpcyBiZWNhdXNlIHRoZQo+IGFsbG9jYXRpb25zIGFyZSBtb3N0bHkgY29taW5nIG91dCBv
ZiA0SyBwYWdlcyBpbnN0ZWFkIG9mIGhpZ2hlciBvcmRlcgo+IG9uZXMuCj4KPiBBbHRlcm5h
dGl2ZWx5IHlvdSBjb3VsZCBqdXN0IG1ha2UgdGhlIHN1Z2dlc3Rpb24gSSBoYWQgcHJvcG9z
ZWQgYWJvdXQKPiB1c2luZyBzcGluX2xvY2svdW5sb2NrX2lycSBpbiB5b3VyIHdvcmtlciB0
aHJlYWQgYW5kIHRoYXQgcmVzb2x2ZWQgaXQKPiBmb3IgbWUuCj4KPj4+ICBJIHdvdWxkIHBy
ZWZlciBub3QgdG8gc3BlbmQgbXkgdGltZSBmaXhpbmcgYW5kCj4+PiB0dW5pbmcgYSBwYXRj
aCBzZXQgdGhhdCBJIGFtIHN0aWxsIG5vdCBjb252aW5jZWQgaXMgdmlhYmxlLgo+PiBZb3Ug
IGRvbid0IGhhdmUgdG8sIEkgY2FuIGZpeCB0aGUgaXNzdWVzIGluIG15IHBhdGNoLXNldC4g
OikKPiBTb3VuZHMgZ29vZC4gSG9wZWZ1bGx5IHRoZSBzdHVmZiBJIHBvaW50ZWQgb3V0IGFi
b3ZlIGhlbHBzIHlvdSB0byBnZXQKPiBhIHJlcHJvZHVjdGlvbiBhbmQgcmVzb2x2ZSB0aGUg
aXNzdWVzLgoKClNvIEkgZGlkIG9ic2VydmUgYSBzaWduaWZpY2FudCBkcm9wIGluIHJ1bm5p
bmcgbXkgdjEyIHBhdGgtc2V0IFsxXSB3aXRoIHRoZQpzdWdnZXN0ZWQgdGVzdCBzZXR1cC4g
SG93ZXZlciwgb24gbWFraW5nIGNlcnRhaW4gY2hhbmdlcyB0aGUgcGVyZm9ybWFuY2UKaW1w
cm92ZWQgc2lnbmlmaWNhbnRseS4KCkkgdXNlZCBteSB2MTIgcGF0Y2gtc2V0IHdoaWNoIEkg
aGF2ZSBwb3N0ZWQgZWFybGllciBhbmQgbWFkZSB0aGUgZm9sbG93aW5nCmNoYW5nZXM6CjEu
IFN0YXJ0ZWQgcmVwb3J0aW5nIG9ubHkgKE1BWF9PUkRFUiAtIDEpIHBhZ2VzIGFuZCBpbmNy
ZWFzZWQgdGhlIG51bWJlciBvZgrCoMKgwqAgcGFnZXMgdGhhdCBjYW4gYmUgcmVwb3J0ZWQg
YXQgYSB0aW1lIHRvIDMyIGZyb20gMTYuIFRoZSBpbnRlbnQgb2YgbWFraW5nCsKgwqDCoCB0
aGVzZSBjaGFuZ2VzIHdhcyB0byBicmluZyBteSBjb25maWd1cmF0aW9uIGNsb3NlciB0byB3
aGF0IEFsZXhhbmRlciBpcwrCoMKgwqAgdXNpbmcuCjIuIEkgbWFkZSBhbiBhZGRpdGlvbmFs
IGNoYW5nZSBpbiBteSBiaXRtYXAgc2Nhbm5pbmcgbG9naWMgdG8gcHJldmVudCBhY3F1aXJp
bmcKwqDCoMKgIHNwaW5sb2NrIGlmIHRoZSBwYWdlIGlzIGFscmVhZHkgYWxsb2NhdGVkLgoK
ClNldHVwOgpPbiBhIDE2IHZDUFUgMzAgR0Igc2luZ2xlIE5VTUEgZ3Vlc3QgYWZmaW5lZCB0
byBhIHNpbmdsZSBob3N0IE5VTUEsIEkgcmFuIHRoZQptb2RpZmllZCB3aWxsLWl0LXNjYWxl
L3BhZ2VfZmF1bHQgbnVtYmVyIG9mIHRpbWVzIGFuZCBjYWxjdWxhdGVkIHRoZSBhdmVyYWdl
Cm9mIHRoZSBudW1iZXIgb2YgcHJvY2VzcyBhbmQgdGhyZWFkcyBsYXVuY2hlZCBvbiB0aGUg
MTZ0aCBjb3JlIHRvIGNvbXBhcmUgdGhlCmltcGFjdCBvZiBteSBwYXRjaC1zZXQgYWdhaW5z
dCBhbiB1bm1vZGlmaWVkIGtlcm5lbC4KCgpDb25jbHVzaW9uOgolRHJvcCBpbiBudW1iZXIg
b2YgcHJvY2Vzc2VzIGxhdW5jaGVkIG9uIDE2dGggdkNQVSA9wqDCoMKgwqAgMS0yJQolRHJv
cCBpbiBudW1iZXIgb2YgdGhyZWFkcyBsYXVuY2hlZCBvbiAxNnRoIHZDUFXCoMKgwqDCoCA9
wqDCoMKgwqAgNS02JQoKCk90aGVyIG9ic2VydmF0aW9uczoKLSBJIGFsc28gdHJpZWQgcnVu
bmluZyBBbGV4YW5kZXIncyBsYXRlc3QgdjExIHBhZ2UtcmVwb3J0aW5nIHBhdGNoIHNldCBh
bmQKwqAgb2JzZXJ2ZSBhIHNpbWlsYXIgYW1vdW50IG9mIGF2ZXJhZ2UgZGVncmFkYXRpb24g
aW4gdGhlIG51bWJlciBvZiBwcm9jZXNzZXMKwqAgYW5kIHRocmVhZHMuCi0gSSBkaWRuJ3Qg
aW5jbHVkZSB0aGUgbGluZWFyIGNvbXBvbmVudCByZWNvcmRlZCBieSB3aWxsLWl0LXNjYWxl
IGJlY2F1c2UgZm9yCsKgIHNvbWUgcmVhc29uIGl0IHdhcyBmbHVjdHVhdGluZyB0b28gbXVj
aCBldmVuIHdoZW4gSSB3YXMgdXNpbmcgYW4gdW5tb2RpZmllZArCoCBrZXJuZWwuIElmIHJl
cXVpcmVkIEkgY2FuIGludmVzdGlnYXRlIHRoaXMgZnVydGhlci4KCk5vdGU6IElmIHRoZXJl
IGlzIGEgYmV0dGVyIHdheSB0byBhbmFseXplIHRoZSB3aWxsLWl0LXNjYWxlL3BhZ2VfZmF1
bHQgcmVzdWx0cwp0aGVuIHBsZWFzZSBkbyBsZXQgbWUga25vdy4KCgpPdGhlciBzZXR1cCBk
ZXRhaWxzOgpGb2xsb3dpbmcgYXJlIHRoZSBjb25maWd1cmF0aW9ucyB3aGljaCBJIGVuYWJs
ZWQgdG8gcnVuIG15IHRlc3RzOgotIEVuYWJsZWQ6IENPTkZJR19TTEFCX0ZSRUVMSVNUX1JB
TkRPTSAmIENPTkZJR19TSFVGRkxFX1BBR0VfQUxMT0NBVE9SCi0gU2V0IGhvc3QgVEhQIHRv
IGFsd2F5cwotIFNldCBndWVzdCBUSFAgdG8gbWFkdmlzZQotIEFkZGVkIHRoZSBzdWdnZXN0
ZWQgbWFkdmlzZSBjYWxsIGluIHBhZ2VfZmF1bHQgc291cmNlIGNvZGUuCkBBbGV4YW5kZXIg
cGxlYXNlIGxldCBtZSBrbm93IGlmIEkgbWlzc2VkIHNvbWV0aGluZy4KCgpUaGUgY3VycmVu
dCBzdGF0ZSBvZiBteSB2MTM6Ckkgc3RpbGwgaGF2ZSB0byBsb29rIGludG8gTWljaGFsJ3Mg
c3VnZ2VzdGlvbiBvZiB1c2luZyBwYWdlLWlzb2xhdGlvbiBBUEkncwppbnN0ZWFkIG9mIGlz
b2xhdGluZyB0aGUgcGFnZS4gSG93ZXZlciwgSSBiZWxpZXZlIGF0IHRoaXMgbW9tZW50IG91
ciBvYmplY3RpdmUKaXMgdG8gZGVjaWRlIHdpdGggd2hpY2ggYXBwcm9hY2ggd2UgY2FuIHBy
b2NlZWQgYW5kIHRoYXQncyB3aHkgSSBkZWNpZGVkIHRvCnBvc3QgdGhlIG51bWJlcnMgYnkg
bWFraW5nIHNtYWxsIHJlcXVpcmVkIGNoYW5nZXMgaW4gdjEyIGluc3RlYWQgb2YgcG9zdGlu
ZyBhCm5ldyBzZXJpZXMuCgoKRm9sbG93aW5nIGFyZSB0aGUgY2hhbmdlcyB3aGljaCBJIGhh
dmUgbWFkZSBvbiB0b3Agb2YgbXkgdjEyOgoKcGFnZV9yZXBvcnRpbmcuaCBjaGFuZ2U6Ci0j
ZGVmaW5lIFBBR0VfUkVQT1JUSU5HX01JTl9PUkRFUsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgKE1BWF9PUkRFUiAtIDIpCi0jZGVmaW5lIFBBR0VfUkVQT1JUSU5HX01BWF9QQUdF
U8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgMTYKKyNkZWZpbmUgUEFHRV9SRVBPUlRJ
TkdfTUlOX09SREVSwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKE1BWF9PUkRFUiAtIDEp
CisjZGVmaW5lIFBBR0VfUkVQT1JUSU5HX01BWF9QQUdFU8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIDMyCgpwYWdlX3JlcG9ydGluZy5jIGNoYW5nZToKQEAgLTEwMSw4ICsxMDEsMTIg
QEAgc3RhdGljIHZvaWQgc2Nhbl96b25lX2JpdG1hcChzdHJ1Y3QgcGFnZV9yZXBvcnRpbmdf
Y29uZmlnCipwaGNvbmYsCsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAvKiBQcm9j
ZXNzIG9ubHkgaWYgdGhlIHBhZ2UgaXMgc3RpbGwgb25saW5lICovCsKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBwYWdlID0gcGZuX3RvX29ubGluZV9wYWdlKChzZXRiaXQgPDwg
UEFHRV9SRVBPUlRJTkdfTUlOX09SREVSKSArCsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgem9uZS0+YmFzZV9wZm4pOwotwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAo
IXBhZ2UpCivCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmICghcGFnZSB8fCAhUGFn
ZUJ1ZGR5KHBhZ2UpKSB7CivCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBjbGVhcl9iaXQoc2V0Yml0LCB6b25lLT5iaXRtYXApOworwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYXRvbWljX2RlYygmem9uZS0+ZnJl
ZV9wYWdlcyk7CsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgY29udGludWU7CivCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIH0KCkBBbGV4YW5k
ZXIgaW4gY2FzZSB5b3UgZGVjaWRlIHRvIGdpdmUgaXQgYSB0cnkgYW5kIGZpbmQgZGlmZmVy
ZW50IHJlc3VsdHMsCnBsZWFzZSBkbyBsZXQgbWUga25vdy4KClsxXSBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9sa21sLzIwMTkwODEyMTMxMjM1LjI3MjQ0LTEtbml0ZXNoQHJlZGhhdC5j
b20vCgoKLS0gClRoYW5rcwpOaXRlc2gK

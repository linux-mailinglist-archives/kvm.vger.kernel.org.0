Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB8C78D950
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 20:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbjH3Scu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 14:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242174AbjH3HU4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 03:20:56 -0400
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B021BB;
        Wed, 30 Aug 2023 00:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1693380052; x=1724916052;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WqdW8Qj2xK46E3UyrwcROMadSGBZGtNxIQEEI9MRaS0=;
  b=edMQRAdCRmENkOwDAZnd63tncJDJRIIen2VqxP90EJPjRnPkG2+3QjHF
   Ftdl65nk7sXQ/YVvLUWLVmVubT12ozcNF9EzF6+15sOvJSuv/L8Vkhizq
   QLBTq/xx5SUgukPCDAXQB9sbl8ZR1SnY4HhtxvUkvxbKz77+V36B321Fl
   I=;
X-IronPort-AV: E=Sophos;i="6.02,212,1688428800"; 
   d="scan'208";a="25907343"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2023 07:20:50 +0000
Received: from EX19MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com (Postfix) with ESMTPS id 319AF806B6;
        Wed, 30 Aug 2023 07:20:49 +0000 (UTC)
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Wed, 30 Aug 2023 07:20:41 +0000
Received: from [0.0.0.0] (10.253.83.51) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.37; Wed, 30 Aug
 2023 07:20:37 +0000
Message-ID: <82416797-01aa-471a-a737-471297e37c4c@amazon.de>
Date:   Wed, 30 Aug 2023 09:20:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] Introduce persistent memory pool
Content-Language: en-GB
To:     Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
CC:     "Gowans, James" <jgowans@amazon.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "madvenka@linux.microsoft.com" <madvenka@linux.microsoft.com>,
        "anthony.yznaga@oracle.com" <anthony.yznaga@oracle.com>,
        "steven.sistare@oracle.com" <steven.sistare@oracle.com>,
        "stanislav.kinsburskii@gmail.com" <stanislav.kinsburskii@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "anrayabh@linux.microsoft.com" <anrayabh@linux.microsoft.com>,
        "dragan.cvetic@amd.com" <dragan.cvetic@amd.com>,
        "jinankjain@linux.microsoft.com" <jinankjain@linux.microsoft.com>,
        "derek.kiernan@amd.com" <derek.kiernan@amd.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <kexec@lists.infradead.org>, <iommu@lists.linux.dev>,
        kvm <kvm@vger.kernel.org>
References: <64e7cbf7.050a0220.114c7.b70dSMTPIN_ADDED_BROKEN@mx.google.com>
 <2023082506-enchanted-tripping-d1d5@gregkh>
 <c26ad989dcc6737dd295e980c78ef53740098810.camel@amazon.com>
 <20230823024500.GA25462@skinsburskii.>
 <e0ed9fb9-8e7a-44ad-976a-27362f6e537a@amazon.de>
 <20230829220740.GA26605@skinsburskii.>
From:   Alexander Graf <graf@amazon.de>
In-Reply-To: <20230829220740.GA26605@skinsburskii.>
X-Originating-IP: [10.253.83.51]
X-ClientProxiedBy: EX19D038UWC001.ant.amazon.com (10.13.139.213) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,T_SPF_PERMERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgU3RhbmlzbGF2LAoKT24gMzAuMDguMjMgMDA6MDcsIFN0YW5pc2xhdiBLaW5zYnVyc2tpaSB3
cm90ZToKPgo+IE9uIE1vbiwgQXVnIDI4LCAyMDIzIGF0IDEwOjUwOjE5UE0gKzAyMDAsIEFsZXhh
bmRlciBHcmFmIHdyb3RlOgo+PiAra2V4ZWMsIGlvbW11LCBrdm0KPj4KPj4gT24gMjMuMDguMjMg
MDQ6NDUsIFN0YW5pc2xhdiBLaW5zYnVyc2tpaSB3cm90ZToKPj4+ICtha3BtLCArbGludXgtbW0K
Pj4+Cj4+PiBPbiBGcmksIEF1ZyAyNSwgMjAyMyBhdCAwMTozMjo0MFBNICswMDAwLCBHb3dhbnMs
IEphbWVzIHdyb3RlOgo+Pj4+IE9uIEZyaSwgMjAyMy0wOC0yNSBhdCAxMDowNSArMDIwMCwgR3Jl
ZyBLcm9haC1IYXJ0bWFuIHdyb3RlOgo+Pj4+Cj4+Pj4gVGhhbmtzIGZvciBhZGRpbmcgbWUgdG8g
dGhpcyB0aHJlYWQgR3JlZyEKPj4+Pgo+Pj4+PiBPbiBUdWUsIEF1ZyAyMiwgMjAyMyBhdCAxMToz
NDozNEFNIC0wNzAwLCBTdGFuaXNsYXYgS2luc2J1cnNraWkgd3JvdGU6Cj4+Pj4+PiBUaGlzIHBh
dGNoIGFkZHJlc3NlcyB0aGUgbmVlZCBmb3IgYSBtZW1vcnkgYWxsb2NhdG9yIGRlZGljYXRlZCB0
bwo+Pj4+Pj4gcGVyc2lzdGVudCBtZW1vcnkgd2l0aGluIHRoZSBrZXJuZWwuIFRoaXMgYWxsb2Nh
dG9yIHdpbGwgcHJlc2VydmUKPj4+Pj4+IGtlcm5lbC1zcGVjaWZpYyBzdGF0ZXMgbGlrZSBETUEg
cGFzc3Rocm91Z2ggZGV2aWNlIHN0YXRlcywgSU9NTVUgc3RhdGUsIGFuZAo+Pj4+Pj4gbW9yZSBh
Y3Jvc3Mga2V4ZWMuCj4+Pj4+PiBUaGUgcHJvcG9zZWQgc29sdXRpb24gb2ZmZXJzIGEgZm91bmRh
dGlvbmFsIGltcGxlbWVudGF0aW9uIGZvciBwb3RlbnRpYWwKPj4+Pj4+IGN1c3RvbSBzb2x1dGlv
bnMgdGhhdCBtaWdodCBmb2xsb3cuIFRob3VnaCB0aGUgaW1wbGVtZW50YXRpb24gaXMKPj4+Pj4+
IGludGVudGlvbmFsbHkga2VwdCBjb25jaXNlIGFuZCBzdHJhaWdodGZvcndhcmQgdG8gZm9zdGVy
IGRpc2N1c3Npb24gYW5kCj4+Pj4+PiBmZWVkYmFjaywgaXQncyBmdWxseSBmdW5jdGlvbmFsIGlu
IGl0cyBjdXJyZW50IHN0YXRlLgo+Pj4+IEhpIFN0YW5pc2xhdiwgaXQgbG9va3MgbGlrZSB3ZSdy
ZSB3b3JraW5nIG9uIHNpbWlsYXIgdGhpbmdzLiBJJ20gbG9va2luZwo+Pj4+IHRvIGRldmVsb3Ag
YSBtZWNoYW5pc20gdG8gc3VwcG9ydCBoeXBlcnZpc29yIGxpdmUgdXBkYXRlIGZvciB3aGVuIEtW
TSBpcwo+Pj4+IHJ1bm5pbmcgVk1zIHdpdGggUENJIGRldmljZSBwYXNzdGhyb3VnaC4gVk1zIHdp
dGggZGV2aWNlIHBhc3N0aHJvdWdoCj4+Pj4gYWxzbyBuZWNlc3NpdGF0ZXMgcGFzc2luZyBhbmQg
cmUtaHlkcmF0aW5nIElPTU1VIHN0YXRlIHNvIHRoYXQgRE1BIGNhbgo+Pj4+IGNvbnRpbnVlIGR1
cmluZyBsaXZlIHVwZGF0ZS4KPj4+Pgo+Pj4+IFBsYW5uaW5nIG9uIGhhdmluZyBhbiBMUEMgc2Vz
c2lvbiBvbiB0aGlzIHRvcGljOgo+Pj4+IGh0dHBzOi8vbHBjLmV2ZW50cy9ldmVudC8xNy9hYnN0
cmFjdHMvMTYyOS8gKGN1cnJlbnRseSBpdCdzIG9ubHkgYQo+Pj4+IHN1Ym1pdHRlZCBhYnN0cmFj
dCBzbyBub3Qgc3VyZSBpZiB2aXNpYmxlLCBob3BlZnVsbHkgaXQgd2lsbCBiZSBzb29uKS4KPj4+
Pgo+Pj4+IFdlIGFyZSBsb29raW5nIGF0IGltcGxlbWVudGluZyBwZXJzaXN0ZW5jZSBhY3Jvc3Mg
a2V4ZWMgdmlhIGFuIGluLW1lbW9yeQo+Pj4+IGZpbGVzeXN0ZW0gb24gdG9wIG9mIHJlc2VydmVk
IG1lbW9yeS4gVGhpcyB3b3VsZCBoYXZlIGZpbGVzIGZvciBhbnl0aGluZwo+Pj4+IHRoYXQgbmVl
ZHMgdG8gYmUgcGVyc2lzdGVkLiBUaGF0IGluY2x1ZGVzIGZpbGVzIGZvciBJT01NVSBwZ3RhYmxl
cywgZm9yCj4+Pj4gZ3Vlc3QgbWVtb3J5IG9yIHVzZXJzcGFjZS1hY2Nlc3NpYmxlIG1lbW9yeS4K
Pj4+Pgo+Pj4+IEl0IG1heSBiZSBuaWNlIHRvIHNvbHZlIGFsbCBrZXhlYyBwZXJzaXN0ZW5jZSBy
ZXF1aXJlbWVudHMgd2l0aCBvbmUKPj4+PiBzb2x1dGlvbiwgYnV0IHdlIGNhbiBjb25zaWRlciBJ
T01NVSBzZXBhcmF0ZWx5LiBUaGVyZSBhcmUgYXQgbGVhc3QgdGhyZWUKPj4+PiB3YXlzIHRoYXQg
dGhpcyBjYW4gYmUgZG9uZToKPj4+PiBhKSBjYXJ2aW5nIG91dCByZXNlcnZlZCBtZW1vcnkgZm9y
IHBndGFibGVzLiBUaGlzIGlzIGRvbmUgYnkgeW91cgo+Pj4+IHByb3Bvc2FsIGhlcmUsIGFzIHdl
bGwgYXMgbXkgc3VnZ2VzdGlvbiBvZiBhIGZpbGVzeXN0ZW0uCj4+Pj4gYikgcHJlL3Bvc3Qga2V4
ZWMgaG9va3MgZm9yIGRyaXZlcnMgdG8gc2VyaWFsaXNlIHN0YXRlIGFuZCBwYXNzIGl0Cj4+Pj4g
YWNyb3NzIGluIGEgc3RydWN0dXJlZCBmb3JtYXQgZnJvbSBvbGQgdG8gbmV3IGtlcm5lbC4KPj4+
PiBjKSBSZWNvbnN0cnVjdGluZyBJT01NVSBzdGF0ZSBpbiB0aGUgbmV3IGtlcm5lbCBieSBzdGFy
dGluZyBhdCB0aGUKPj4+PiBoYXJkd2FyZSByZWdpc3RlcnMgYW5kIHdhbGtpbmcgdGhlIHBhZ2Ug
dGFibGVzLiBObyBzdGF0ZSBwYXNzaW5nIG5lZWRlZC4KPj4+Pgo+Pj4+IEhhdmUgeW91IGNvbnNp
ZGVyZWQgb3B0aW9uIChiKSBhbmQgKGMpIGhlcmU/IE9uZSBvZiB0aGUgaW1wbGljYXRpb25zIG9m
Cj4+Pj4gKGIpIGFuZCAoYykgYXJlIHRoYXQgdGhleSB3b3VsZCBuZWVkIHRvIGhvb2sgaW50byB0
aGUgYnVkZHkgYWxsb2NhdG9yCj4+Pj4gcmVhbGx5IGVhcmx5IHRvIGJlIGFibGUgdG8gY2FydmUg
b3V0IHRoZSByZWNvbnN0cnVjdGVkIHBhZ2UgdGFibGVzCj4+Pj4gYmVmb3JlIHRoZSBhbGxvY2F0
b3IgaXMgdXNlZC4gU2ltaWxhciB0byBob3cgcGtyYW0gWzBdIGhvb2tzIGluIGVhcmx5IHRvCj4+
Pj4gY2FydmUgb3V0IHBhZ2VzIHVzZWQgZm9yIGl0cyBmaWxlc3lzdGVtLgo+Pj4+Cj4+PiBIaSBK
YW1lcywKPj4+Cj4+PiBXZSBhcmUgaW5kZWVkIHdvcmtpbmcgb24gc2ltaWxhciB0aGluZ3MsIHNv
IHRoYW5rcyBmb3IgY2hpbWluZyBpbi4KPj4+IEkndmUgc2VlbiBwa3JhbSBwcm9wb3NhbCBhcyB3
ZWxsIGFzIHlvdXIgY29tbWVudHMgdGhlcmUuCj4+Pgo+Pj4gSSB0aGluayAoYikgd2lsbCBuZWVk
IHNvbWUgcGVyc2lzdGVudC1vdmVyLWtleGVjIG1lbW9yeSB0byBwYXNzIHRoZQo+Pj4gc3RhdGUg
YWNyb3NzIGtleGVjIGFzIHdlbGwgYXMgc29tZSBrZXktdmFsdWUgc3RvcmUgcGVyc2lzdGVkIGFz
IHdlbGwuCj4+PiBBbmQgdGhlIHByb3Bvc2VkIHBlcnNpc3RlbnQgbWVtb3J5IHBvb2wgaXMgYWlt
ZWQgZXhhY3RseSBmb3IgdGhpcwo+Pj4gcHVycG9zZS4KPj4+IE9yIGRvIHlvdSBpbXBseSBzb21l
IG90aGVyIHdheSB0byBwYXNzIGRyaXZlcidzIGRhdGEgYWNjcm9zcyBrZXhlYz8KPj4KPj4gSWYg
SSBoYWQgdG8gYnVpbGQgdGhpcywgSSdkIHByb2JhYmx5IGRvIGl0IGp1c3QgbGlrZSBkZXZpY2Ug
dHJlZSBwYXNzaW5nIG9uCj4+IEFSTS4gSXQncyBhIHNpbmdsZSwgcGh5c2ljYWxseSBjb250aWd1
b3VzIGJsb2Igb2YgZGF0YSB3aG9zZSBlbnRyeSBwb2ludCB5b3UKPj4gcGFzcyB0byB0aGUgdGFy
Z2V0IGtlcm5lbC4gSUlSQyBBQ1BJIHBhc3Npbmcgd29ya3Mgc2ltaWxhcmx5LiBUaGlzIHdvdWxk
Cj4+IGp1c3QgYmUgb25lIG1vcmUgb3BhcXVlIGRhdGEgc3RydWN0dXJlIHRoYXQgdGhlbiBuZWVk
cyB2ZXJ5IHN0cmljdAo+PiB2ZXJzaW9uaW5nIGFuZCBmb3J3YXJkL2JhY2t3YXJkIGNvbXBhdCBn
dWFyYW50ZWVzLgo+Pgo+IERldmljZSB0cmVlIG9yIEFDUEkgYXJlIG9wdGlvbnMgaW5kZWVkLiBI
b3dldmVyIEFGQUlVIGluIGNhc2Ugb2YgRFQgdXNlcgo+IHNwYWNlIGhhcyB0byBpbnZvbHZlZCBp
bnRvIHRoZSBwaWN0dXJlIHRvIG1vZGlmeSBhbmQgY29tcGxpZSBpdCwgd2hpbGUKPiBBQ1BJIGlz
bid0IGZsZXhpYmxlIG9yIGVhc2lseSBleHRlbmRhYmxlLgo+IEFsc28sIEFGQUlVIGJvdGggdGhl
c2Ugc3RhbmRhcmRzIHdlcmUgZGVzaWduZWQgd2l0aCBwYXNzaW5nCj4gaGFyZHdhcmUtc3BlY2lm
aWMgZGF0YSBpbiBtaW5kIGZyb20gYm9vdHN0cmFwIHNvZnR3YXJlIHRvIGFuIE9TIGtlcm5lbAo+
IGFuZCB0aHVzIHdlcmUgbmV2ZXIgcmVhbGx5IGludGVuZGVkIHRvIGJlIHVzZWQgZm9yIGNyZWF0
aW5nIGEgcGVyc2lzdGVudAo+IHN0YXRlIGFjY3Jvc3Mga2V4ZWMuCj4gVG8gbWUsIGFuIGF0dGVt
cHQgdG8gdXNlIGVpdGhlciBvZiB0aGVtIHRvIHBhc3Mga2VybmVsLXNwZWNpZmljIGRhdGEgbG9v
a3MKPiBsaWtlIGFuIGFidXNlIChvciBtaXN1c2UpIGV4Y3VzZWQgYnkgdGhlIHNpbXBsaWNpdHkg
b2YgaW1wbGVtZW50YXRpb24uCgoKV2hhdCBJIHdhcyBkZXNjcmliaW5nIGFib3ZlIGlzIHRoYXQg
dGhlIExpbnV4IGJvb3QgcHJvdG9jb2wgYWxyZWFkeSBoYXMgCm5hdHVyYWwgd2F5cyB0byBwYXNz
IGEgRFQgKGFybSkgb3Igc2V0IG9mIEFDUEkgdGFibGVzICh4ODYpIHRvIHRoZSAKdGFyZ2V0IGtl
cm5lbC4gV2hhdGV2ZXIgd2UgZG8gaGVyZSBzaG91bGQgZWl0aGVyIHBpZ2d5IGJhY2sgb24gdG9w
IG9mIAp0aG9zZSBuYXR1cmFsIG1lY2hhbmlzbXMgKGUuZy4gL2Nob3NlbiBub2RlIGluIERUKSBv
ciBiZSBvbiB0aGUgc2FtZSAKbGV2ZWwgKGUuZy4gcGFzcyBEVCBpbiBvbmUgcmVnaXN0ZXIsIHBh
c3MgbWV0YWRhdGEgc3RydWN0dXJlIGluIGFub3RoZXIgCnJlZ2lzdGVyKS4KCldoZW4gaXQgY29t
ZXMgdG8gdGhlIGFjdHVhbCBjb250ZW50IG9mIHRoZSBtZXRhZGF0YSwgSSdtIHBlcnNvbmFsbHkg
YWxzbyAKbGVhbmluZyB0b3dhcmRzIERULiBXZSBhbHJlYWR5IGhhdmUgbGliZmR0IGluc2lkZSB0
aGUga2VybmVsLiBJdCBnaXZlcyAKaXMgYSB2ZXJ5IHNpbXBsZSwgd2VsbCB1bmRlcnN0b29kIHN0
cnVjdHVyZWQgZmlsZSBmb3JtYXQgdGhhdCB5b3UgY2FuIApleHRlbmQsIHZlcnNpb24sIGV0YyBl
dGMuIEFuZCB0aGUga2VybmVsIGhhcyBtZWNoYW5pc21zIHRvIG1vZGlmeSBmZHQgCmNvbnRlbnRz
LgoKCj4KPj4+IEkgZGluZCd0IGNvbnNpZGVyIChjKSB5ZXQsIHRoYW5rcyBmb3IgZm9yIHRoZSBw
b2ludGVyLgo+Pj4KPj4+IEkgaGF2ZSBhIHF1ZXN0aW9uIGluIHRoaXMgc2NvcGU6IGhvdyBpcyBQ
Q0kgZGV2aWNlcyByZWdpc3RlcnMgc3RhdGUgaXMgcGVyc2lzdGVkCj4+PiBhY3Jvc3Mga2V4ZWMg
d2l0aCB0aGUgZmlsZXMgc3lzdGVtIHlvdSBhcmUgd29ya2luZyBvbj8gSS5lLiBob3cgZG9lcwo+
Pj4gZHJpdmVyIGtub3csIHRoYXQgdGhlIGRldmljZSBzaG91bGRuJ3Qgbm90IGJlIHJlaW5pdGlh
bGl6ZWQ/Cj4+Cj4+IFRoZSBlYXNpZXN0IHdheSB0byBkbyBpdCBpbml0aWFsbHkgd291bGQgYmUg
a2VybmVsIGNvbW1hbmQgbGluZSBvcHRpb25zIHRoYXQKPj4gaGFjayB1cCB0aGUgZHJpdmVycy4g
QnV0IEkgc3VwcG9zZSBkZXBlbmRpbmcgb24gdGhlIG9wdGlvbiB3ZSBnbyB3aXRoLCB5b3UKPj4g
Y2FuIGFsc28gdXNlIHRoZSByZXNwZWN0aXZlICJuYXR1cmFsIiBwYXRoOgo+Pgo+PiAoYSkgQSBz
cGVjaWFsIG1ldGFkYXRhIGZpbGUgdGhhdCBleHBsYWlucyB0aGUgc3RhdGUgdG8gdGhlIGRyaXZl
cgo+PiAoYikgQW4gZW50cnkgaW4gdGhlIHN0cnVjdHVyZWQgZmlsZSBmb3JtYXQgdGhhdCBleHBs
YWlucyB0aGUgc3RhdGUgdG8gdGhlCj4+IHRhcmdldCBkcml2ZXIKPj4gKGMpIENvbXBhdGlibGUg
dGFyZ2V0IGRyaXZlcnMgdHJ5IHRvIGVudW1lcmF0ZSBzdGF0ZSBmcm9tIHRoZSB0YXJnZXQKPj4g
ZGV2aWNlJ3MgcmVnaXN0ZXIgZmlsZQo+Pgo+IENvbW1hbmQgbGluZSBvcHRpb24gaXMgdGhlIHNp
bXBsZXN0IHdheSB0byBnbyBpbmRlZWQsIGJ1dCBmcm9tIG15IFBPVgo+IGl0J3MgZ29vZCBvbmx5
IGZvciBwb2ludGluZyB0byBhIHBhcnRpY3VhbHIgb2JqZWN0LCB3aGljaCBpcyBwZXJzaXN0ZWQK
PiBzb21laG93IGVsc2UuIEJ1dCBpdCB3ZSBoYXZlIGEgcGVyc2lzdGVuY2UgbWVjaGFuaXNtLCB0
aGVuIEkgdGhpbmsgd2UKPiBjYW4gbWFrZSBhbm90aGVyIHN0ZXAgZm9yd2FyZCBhbmQgZG9uJ3Qg
dXNlIGNvbW1hbmQgbGluZSBhdCBhbGwgKHdoaWNoCj4gaXMgYSBiaXQgY3VtYmVyc29tZSBhbmQg
ZXJyb3Jwcm9uZSBkdWUgdG8gaXQncyBodW1hbi1yZWFkYWJsZSBhbmQKPiBzZXJpYWxpemVkIG5h
dHVyZSkuCj4KPiBJJ20gbGVhbmluZyB0b3dhcmRzIHNvbWUga2luZCBvZiAibmF0dXJhbCIgcGF0
aCB5b3UgbWVudGlvbmVkLi4uIEkgZ3Vlc3MKPiBJJ20gYSBiaXQgY29uZnVzZWQgd2l0aCB0aGUg
d29yZCAiZmlsZSIgaGVyZSwgYXMgaXQgc291bmRzIGxpbmUgaXQKPiBpbXBsaWVzIGEgZmlsZSBz
eXN0ZW0gZHJpdmVyLCBhbmQgSSdtIG5vdCBzdXJlIHRoYXQncyB3aGF0IHdlIHdhbnQgZm9yCj4g
ZHJpdmVyIHNwZWNpZmljIGRhdGEuCgoKT2gsIEkgd2FzIGp1c3QgcmVmZXJyaW5nIHRvIHRoZSBz
ZXQgb2YgcmVnaXN0ZXJzIGEgZGV2aWNlIGV4cG9zZXMgOikuCgoKPgo+Pj4+Pj4gUG90ZW50aWFs
IGFwcGxpY2F0aW9ucyBpbmNsdWRlOgo+Pj4+Pj4KPj4+Pj4+ICAgICAxLiBBbGxvd2luZyB2YXJp
b3VzIGluLWtlcm5lbCBlbnRpdGllcyB0byBhbGxvY2F0ZSBwZXJzaXN0ZW50IHBhZ2VzIGZyb20K
Pj4+Pj4+ICAgICAgICBhIHNpbmd1bGFyIG1lbW9yeSBwb29sLCBlbGltaW5hdGluZyB0aGUgbmVl
ZCBmb3IgbXVsdGlwbGUgcmVnaW9uCj4+Pj4+PiAgICAgICAgcmVzZXJ2YXRpb25zLgo+Pj4+Pj4K
Pj4+Pj4+ICAgICAyLiBGb3IgaW4ta2VybmVsIGNvbXBvbmVudHMgdGhhdCByZXF1aXJlIHRoZSBh
bGxvY2F0aW9uIGFkZHJlc3MgdG8gYmUKPj4+Pj4+ICAgICAgICBhdmFpbGFibGUgb24ga2VybmVs
IGtleGVjLCB0aGlzIGFkZHJlc3MgY2FuIGJlIGV4cG9zZWQgdG8gdXNlciBzcGFjZSBhbmQKPj4+
Pj4+ICAgICAgICB0aGVuIHBhc3NlZCB2aWEgdGhlIGNvbW1hbmQgbGluZS4KPj4+PiBEbyB5b3Ug
aGF2ZSBzcGVjaWZpYyBleGFtcGxlcyBvZiBvdGhlciBzdGF0ZSB0aGF0IG5lZWRzIHRvIGJlIHBh
c3NlZAo+Pj4+IGFjcm9zcz8gVHJ5aW5nIHRvIHNlZSB3aGV0aGVyIHRhaWxvcmluZyBzcGVjaWZp
Y2FsbHkgdG8gdGhlIElPTU1VIGNhc2UKPj4+PiBpcyBva2F5LiBDb25jZXB0dWFsbHkgSU9NTVUg
c3RhdGUgY2FuIGJlIHJlY29uc3RydWN0ZWQgc3RhcnRpbmcgd2l0aAo+Pj4+IGhhcmR3YXJlIHJl
Z2lzdGVycywgbm90IG5lZWRpbmcgcmVzZXJ2ZWQgbWVtb3J5LiBPdGhlciB1c2UtY2FzZXMgbWF5
IG5vdAo+Pj4+IGhhdmUgdGhpcyBvcHRpb24uCj4+Pj4KPj4+IFdlbGwsIGJhc2ljYWxseSBpdCdz
IElPTU1VIHN0YXRlIGFuZCBQQ0kgZGV2aWNlcyB0byBza2lwL2F2b2lkCj4+PiBpbml0aWFsaXpp
bmcuCj4+PiBJIGJldCB0aGVyZSBjYW4gYmUgb3RoZXIgbWlzYyAoYW5kIHVucmVsYXRlZCB0aGlu
Z3MpIGxpa2UgcGVyc2lzdGVudAo+Pj4gZmlsZXN5c3RlbXMsIGJsb2NrIGRldmljZXMsIGV0Yy4g
QnV0IEkgZG9uJ3QgaGF2ZSBhIHNvbGlkIHNldCBvZiB1c2UKPj4+IGNhc2VzIHRvIHByZXNlbnQu
Cj4+Cj4+IFdvdWxkIGJlIGdyZWF0IGlmIHlvdSBjb3VsZCB0aGluayB0aHJvdWdoIHRoZSBwcm9i
bGVtIHNwYWNlIHVudGlsIExQQyBzbyB3ZQo+PiBjYW4gaGF2ZSBhIHNvbGlkIGNvbnZlcnNhdGlv
biB0aGVyZSA6KQo+Pgo+IFllYWgsIEkgaGF2ZSBhIGZldyBpZGVhcyBJJ2xsIHRyeSB0byBpbXBs
ZW1lbnQgYW5kIHNoYXJlIGJlZm9yZSBMUEMuCj4gVW5mb3J0dW5hdGVsbHkgSSdtIG5vdCBwbGFu
bmluZyB0byBhdHRlbmQgaXQgdGhpcyB5ZWFyLCBzbyB0aGlzCj4gY29udmVyc2F0aW9uIHdpbGwg
YmUgd2l0aG91dCBtZS4KPiBCdXQgSSdsbCBkbyBteSBiZXN0IHRvIHByb3ZpZGUgYXMgbXVjaCBj
b250ZW50IHRvIGRpc2N1c3MgYXMgSSBjYW4uCgoKVGhhbmtzLCBsb29raW5nIGZvcndhcmQgdG8g
aXQhIDopCgoKQWxleAoKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgK
S3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFu
IFNjaGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hh
cmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4
OSAyMzcgODc5CgoK


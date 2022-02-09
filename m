Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD384AF469
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 15:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235225AbiBIOuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 09:50:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiBIOuE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 09:50:04 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1892FC06157B
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 06:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1644418207; x=1675954207;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/bfbQkCawyVD0Ipk28+pQL6ukmzMlMP2Lcis4XdM7BU=;
  b=qsDCReVbEkM85UX1d0zkxXYZsoOm+cJS9PUuN3Uf/L7d4OTxZglKla60
   dgTHfhSalDEN6gbe9E01ImhOINii5ztYQrbDNt+2/2oRUpG6IE3MYhgdV
   FY6DQrE8JzFwEXVUnYdLOtYkdwtVSpi/ebV0SJ8CY7JBoVP3odDFnqfHk
   8=;
X-IronPort-AV: E=Sophos;i="5.88,356,1635206400"; 
   d="scan'208";a="175413329"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-92ba9394.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 09 Feb 2022 14:49:55 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-92ba9394.us-west-2.amazon.com (Postfix) with ESMTPS id D3DEB41276;
        Wed,  9 Feb 2022 14:49:53 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Wed, 9 Feb 2022 14:49:53 +0000
Received: from [0.0.0.0] (10.43.160.114) by EX13D20UWC001.ant.amazon.com
 (10.43.162.244) with Microsoft SMTP Server (TLS) id 15.0.1497.28; Wed, 9 Feb
 2022 14:49:48 +0000
Message-ID: <244647ca-a247-cfc1-d0df-b8c74d434a77@amazon.com>
Date:   Wed, 9 Feb 2022 15:49:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
To:     Stefan Hajnoczi <stefanha@gmail.com>,
        qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>
CC:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Hannes Reinecke <hare@suse.de>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        "Florescu, Andreea" <fandree@amazon.com>, <hreitz@redhat.com>,
        Alex Agache <aagch@amazon.com>,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        John Snow <jsnow@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>, <ohering@suse.de>,
        "Eftime, Petre" <epetre@amazon.com>, <andraprs@amazon.com>
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
X-Originating-IP: [10.43.160.114]
X-ClientProxiedBy: EX13D16UWB002.ant.amazon.com (10.43.161.234) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ck9uIDI4LjAxLjIyIDE2OjQ3LCBTdGVmYW4gSGFqbm9jemkgd3JvdGU6Cj4gRGVhciBRRU1VLCBL
Vk0sIGFuZCBydXN0LXZtbSBjb21tdW5pdGllcywKPiBRRU1VIHdpbGwgYXBwbHkgZm9yIEdvb2ds
ZSBTdW1tZXIgb2YgQ29kZSAyMDIyCj4gKGh0dHBzOi8vc3VtbWVyb2Zjb2RlLndpdGhnb29nbGUu
Y29tLykgYW5kIGhhcyBiZWVuIGFjY2VwdGVkIGludG8KPiBPdXRyZWFjaHkgTWF5LUF1Z3VzdCAy
MDIyIChodHRwczovL3d3dy5vdXRyZWFjaHkub3JnLykuIFlvdSBjYW4gbm93Cj4gc3VibWl0IGlu
dGVybnNoaXAgcHJvamVjdCBpZGVhcyBmb3IgUUVNVSwgS1ZNLCBhbmQgcnVzdC12bW0hCj4KPiBJ
ZiB5b3UgaGF2ZSBleHBlcmllbmNlIGNvbnRyaWJ1dGluZyB0byBRRU1VLCBLVk0sIG9yIHJ1c3Qt
dm1tIHlvdSBjYW4KPiBiZSBhIG1lbnRvci4gSXQncyBhIGdyZWF0IHdheSB0byBnaXZlIGJhY2sg
YW5kIHlvdSBnZXQgdG8gd29yayB3aXRoCj4gcGVvcGxlIHdobyBhcmUganVzdCBzdGFydGluZyBv
dXQgaW4gb3BlbiBzb3VyY2UuCj4KPiBQbGVhc2UgcmVwbHkgdG8gdGhpcyBlbWFpbCBieSBGZWJy
dWFyeSAyMXN0IHdpdGggeW91ciBwcm9qZWN0IGlkZWFzLgo+Cj4gR29vZCBwcm9qZWN0IGlkZWFz
IGFyZSBzdWl0YWJsZSBmb3IgcmVtb3RlIHdvcmsgYnkgYSBjb21wZXRlbnQKPiBwcm9ncmFtbWVy
IHdobyBpcyBub3QgeWV0IGZhbWlsaWFyIHdpdGggdGhlIGNvZGViYXNlLiBJbgo+IGFkZGl0aW9u
LCB0aGV5IGFyZToKPiAtIFdlbGwtZGVmaW5lZCAtIHRoZSBzY29wZSBpcyBjbGVhcgo+IC0gU2Vs
Zi1jb250YWluZWQgLSB0aGVyZSBhcmUgZmV3IGRlcGVuZGVuY2llcwo+IC0gVW5jb250cm92ZXJz
aWFsIC0gdGhleSBhcmUgYWNjZXB0YWJsZSB0byB0aGUgY29tbXVuaXR5Cj4gLSBJbmNyZW1lbnRh
bCAtIHRoZXkgcHJvZHVjZSBkZWxpdmVyYWJsZXMgYWxvbmcgdGhlIHdheQo+Cj4gRmVlbCBmcmVl
IHRvIHBvc3QgaWRlYXMgZXZlbiBpZiB5b3UgYXJlIHVuYWJsZSB0byBtZW50b3IgdGhlIHByb2pl
Y3QuCj4gSXQgZG9lc24ndCBodXJ0IHRvIHNoYXJlIHRoZSBpZGVhIQoKCkkgaGF2ZSBvbmUgdGhh
dCBJJ2QgYWJzb2x1dGVseSAqbG92ZSogdG8gc2VlIGJ1dCBub3QgZ290dGVuIGFyb3VuZCAKaW1w
bGVtZW50aW5nIG15c2VsZiB5ZXQgOikKCgpTdW1tYXJ5OgoKSW1wbGVtZW50IC1NIG5pdHJvLWVu
Y2xhdmUgaW4gUUVNVQoKTml0cm8gRW5jbGF2ZXMgYXJlIHRoZSBmaXJzdCB3aWRlbHkgYWRvcHRl
ZCBpbXBsZW1lbnRhdGlvbiBvZiBoeXBlcnZpc29yIAphc3Npc3RlZCBjb21wdXRlIGlzb2xhdGlv
bi4gU2ltaWxhciB0byB0ZWNobm9sb2dpZXMgbGlrZSBTR1gsIGl0IGFsbG93cyAKdG8gc3Bhd24g
YSBzZXBhcmF0ZSBjb250ZXh0IHRoYXQgaXMgaW5hY2Nlc3NpYmxlIGJ5IHRoZSBwYXJlbnQgT3Bl
cmF0aW5nIApTeXN0ZW0uIFRoaXMgaXMgaW1wbGVtZW50ZWQgYnkgImdpdmluZyB1cCIgcmVzb3Vy
Y2VzIG9mIHRoZSBwYXJlbnQgVk0gCihDUFUgY29yZXMsIG1lbW9yeSkgdG8gdGhlIGh5cGVydmlz
b3Igd2hpY2ggdGhlbiBzcGF3bnMgYSBzZWNvbmQgdm1tIHRvIApleGVjdXRlIGEgY29tcGxldGVs
eSBzZXBhcmF0ZSB2aXJ0dWFsIG1hY2hpbmUuIFRoYXQgbmV3IFZNIG9ubHkgaGFzIGEgCnZzb2Nr
IGNvbW11bmljYXRpb24gY2hhbm5lbCB0byB0aGUgcGFyZW50IGFuZCBoYXMgYSBidWlsdC1pbiBs
aWdodHdlaWdodCAKVFBNLgoKT25lIGJpZyBjaGFsbGVuZ2Ugd2l0aCBOaXRybyBFbmNsYXZlcyBp
cyB0aGF0IGR1ZSB0byBpdHMgcm9vdHMgaW4gCnNlY3VyaXR5LCB0aGVyZSBhcmUgdmVyeSBmZXcg
ZGVidWdnaW5nIC8gaW50cm9zcGVjdGlvbiBjYXBhYmlsaXRpZXMuIApUaGF0IG1ha2VzIE9TIGJy
aW5ndXAsIGRlYnVnZ2luZyBhbmQgYm9vdHN0cmFwcGluZyB2ZXJ5IGRpZmZpY3VsdC4gCkhhdmlu
ZyBhIGxvY2FsIGRldiZ0ZXN0IGVudmlyb25tZW50IHRoYXQgbG9va3MgbGlrZSBhbiBFbmNsYXZl
LCBidXQgaXMgCjEwMCUgY29udHJvbGxlZCBieSB0aGUgZGV2ZWxvcGVyIGFuZCBpbnRyb3NwZWN0
YWJsZSB3b3VsZCBtYWtlIGxpZmUgYSAKbG90IGVhc2llciBmb3IgZXZlcnlvbmUgd29ya2luZyBv
biB0aGVtLiBJdCBhbHNvIG1heSBwYXZlIHRoZSB3YXkgdG8gc2VlIApOaXRybyBFbmNsYXZlcyBh
ZG9wdGVkIGluIFZNIGVudmlyb25tZW50cyBvdXRzaWRlIG9mIEVDMi4KClRoaXMgcHJvamVjdCB3
aWxsIGNvbnNpc3Qgb2YgYWRkaW5nIGEgbmV3IG1hY2hpbmUgbW9kZWwgdG8gUUVNVSB0aGF0IApt
aW1pY3MgYSBOaXRybyBFbmNsYXZlIGVudmlyb25tZW50LCBpbmNsdWRpbmcgdGhlIGxpZ2h0d2Vp
Z2h0IFRQTSwgdGhlIAp2c29jayBjb21tdW5pY2F0aW9uIGNoYW5uZWwgYW5kIGJ1aWxkaW5nIGZp
cm13YXJlIHdoaWNoIGxvYWRzIHRoZSAKc3BlY2lhbCAiRUlGIiBmaWxlIGZvcm1hdCB3aGljaCBj
b250YWlucyBrZXJuZWwsIGluaXRyYW1mcyBhbmQgbWV0YWRhdGEgCmZyb20gYSAta2VybmVsIGlt
YWdlLgoKTGlua3M6CgpodHRwczovL2F3cy5hbWF6b24uY29tL2VjMi9uaXRyby9uaXRyby1lbmNs
YXZlcy8KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8yMDIwMDkyMTEyMTczMi40NDI5MS0x
MC1hbmRyYXByc0BhbWF6b24uY29tL1QvCgpEZXRhaWxzOgoKU2tpbGwgbGV2ZWw6IGludGVybWVk
aWF0ZSAtIGFkdmFuY2VkIChzb21lIHVuZGVyc3RhbmRpbmcgb2YgUUVNVSBtYWNoaW5lIAptb2Rl
bGluZyB3b3VsZCBiZSBnb29kKQpMYW5ndWFnZTogQwpNZW50b3I6IE1heWJlIG1lIChBbGV4YW5k
ZXIgR3JhZiksIGRlcGVuZHMgb24gdGltZWxpbmVzIGFuZCBob2xpZGF5IApzZWFzb24uIExldCdz
IGZpbmQgYW4gaW50ZXJuIGZpcnN0IC0gSSBwcm9taXNlIHRvIGZpbmQgYSBtZW50b3IgdGhlbiA6
KQpTdWdnZXN0ZWQgYnk6IEFsZXhhbmRlciBHcmFmCgoKTm90ZTogSSBkb24ndCBrbm93IGVub3Vn
aCBhYm91dCBydXN0LXZtbSdzIGRlYnVnZ2luZyBjYXBhYmlsaXRpZXMuIElmIGl0IApoYXMgZ2Ri
c3R1YiBhbmQgYSBsb2NhbCBVQVJUIHRoYXQncyBlYXNpbHkgdXNhYmxlLCB0aGUgcHJvamVjdCBt
aWdodCBiZSAKcGVyZmVjdGx5IHZpYWJsZSB1bmRlciBpdHMgdW1icmVsbGEgYXMgd2VsbCAtIHdy
aXR0ZW4gaW4gUnVzdCB0aGVuIG9mIApjb3Vyc2UuCgpBbGV4CgoKCgpBbWF6b24gRGV2ZWxvcG1l
bnQgQ2VudGVyIEdlcm1hbnkgR21iSApLcmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hh
ZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRy
YWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0
ejogQmVybGluClVzdC1JRDogREUgMjg5IDIzNyA4NzkKCgo=


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 153CD14CBF6
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 14:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgA2N7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 08:59:40 -0500
Received: from sender4-of-o51.zoho.com ([136.143.188.51]:21187 "EHLO
        sender4-of-o51.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgA2N7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 08:59:40 -0500
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jan 2020 08:59:39 EST
Received: from [172.17.0.3] (23.253.156.214 [23.253.156.214]) by mx.zohomail.com
        with SMTPS id 1580305450158902.4365573341403; Wed, 29 Jan 2020 05:44:10 -0800 (PST)
Reply-To: <qemu-devel@nongnu.org>
In-Reply-To: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
Subject: Re: [RFC v3 00/25] intel_iommu: expose Shared Virtual Addressing to VMs
Message-ID: <158030544868.2504.1674859271822373142@a1bbccc8075a>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
From:   no-reply@patchew.org
To:     yi.l.liu@intel.com
Cc:     qemu-devel@nongnu.org, david@gibson.dropbear.id.au,
        pbonzini@redhat.com, alex.williamson@redhat.com, peterx@redhat.com,
        kevin.tian@intel.com, yi.l.liu@intel.com, kvm@vger.kernel.org,
        mst@redhat.com, jun.j.tian@intel.com, eric.auger@redhat.com,
        yi.y.sun@intel.com, hao.wu@intel.com
Date:   Wed, 29 Jan 2020 05:44:10 -0800 (PST)
X-ZohoMailClient: External
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UGF0Y2hldyBVUkw6IGh0dHBzOi8vcGF0Y2hldy5vcmcvUUVNVS8xNTgwMzAwMjE2LTg2MTcyLTEt
Z2l0LXNlbmQtZW1haWwteWkubC5saXVAaW50ZWwuY29tLwoKCgpIaSwKClRoaXMgc2VyaWVzIGZh
aWxlZCB0aGUgZG9ja2VyLW1pbmd3QGZlZG9yYSBidWlsZCB0ZXN0LiBQbGVhc2UgZmluZCB0aGUg
dGVzdGluZyBjb21tYW5kcyBhbmQKdGhlaXIgb3V0cHV0IGJlbG93LiBJZiB5b3UgaGF2ZSBEb2Nr
ZXIgaW5zdGFsbGVkLCB5b3UgY2FuIHByb2JhYmx5IHJlcHJvZHVjZSBpdApsb2NhbGx5LgoKPT09
IFRFU1QgU0NSSVBUIEJFR0lOID09PQojISAvYmluL2Jhc2gKZXhwb3J0IEFSQ0g9eDg2XzY0Cm1h
a2UgZG9ja2VyLWltYWdlLWZlZG9yYSBWPTEgTkVUV09SSz0xCnRpbWUgbWFrZSBkb2NrZXItdGVz
dC1taW5nd0BmZWRvcmEgSj0xNCBORVRXT1JLPTEKPT09IFRFU1QgU0NSSVBUIEVORCA9PT0KCiAg
ICAgICAgICAgICAgICAgZnJvbSAvdG1wL3FlbXUtdGVzdC9zcmMvaW5jbHVkZS9ody9wY2kvcGNp
X2J1cy5oOjQsCiAgICAgICAgICAgICAgICAgZnJvbSAvdG1wL3FlbXUtdGVzdC9zcmMvaW5jbHVk
ZS9ody9wY2ktaG9zdC9pNDQwZnguaDoxNSwKICAgICAgICAgICAgICAgICBmcm9tIC90bXAvcWVt
dS10ZXN0L3NyYy9zdHVicy9wY2ktaG9zdC1waWl4LmM6MjoKL3RtcC9xZW11LXRlc3Qvc3JjL2lu
Y2x1ZGUvaHcvaW9tbXUvZHVhbF9zdGFnZV9pb21tdS5oOjI2OjEwOiBmYXRhbCBlcnJvcjogbGlu
dXgvaW9tbXUuaDogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQogI2luY2x1ZGUgPGxpbnV4L2lv
bW11Lmg+CiAgICAgICAgICBefn5+fn5+fn5+fn5+fn4KY29tcGlsYXRpb24gdGVybWluYXRlZC4K
bWFrZTogKioqIFsvdG1wL3FlbXUtdGVzdC9zcmMvcnVsZXMubWFrOjY5OiBzdHVicy9wY2ktaG9z
dC1waWl4Lm9dIEVycm9yIDEKbWFrZTogKioqIFdhaXRpbmcgZm9yIHVuZmluaXNoZWQgam9icy4u
Li4KVHJhY2ViYWNrIChtb3N0IHJlY2VudCBjYWxsIGxhc3QpOgogIEZpbGUgIi4vdGVzdHMvZG9j
a2VyL2RvY2tlci5weSIsIGxpbmUgNjYyLCBpbiA8bW9kdWxlPgotLS0KICAgIHJhaXNlIENhbGxl
ZFByb2Nlc3NFcnJvcihyZXRjb2RlLCBjbWQpCnN1YnByb2Nlc3MuQ2FsbGVkUHJvY2Vzc0Vycm9y
OiBDb21tYW5kICdbJ3N1ZG8nLCAnLW4nLCAnZG9ja2VyJywgJ3J1bicsICctLWxhYmVsJywgJ2Nv
bS5xZW11Lmluc3RhbmNlLnV1aWQ9OGE0MTUwNDM5ZGJjNGM2MmFiZGVlNDM2Njk2MGFjOWEnLCAn
LXUnLCAnMTAwMycsICctLXNlY3VyaXR5LW9wdCcsICdzZWNjb21wPXVuY29uZmluZWQnLCAnLS1y
bScsICctZScsICdUQVJHRVRfTElTVD0nLCAnLWUnLCAnRVhUUkFfQ09ORklHVVJFX09QVFM9Jywg
Jy1lJywgJ1Y9JywgJy1lJywgJ0o9MTQnLCAnLWUnLCAnREVCVUc9JywgJy1lJywgJ1NIT1dfRU5W
PScsICctZScsICdDQ0FDSEVfRElSPS92YXIvdG1wL2NjYWNoZScsICctdicsICcvaG9tZS9wYXRj
aGV3Mi8uY2FjaGUvcWVtdS1kb2NrZXItY2NhY2hlOi92YXIvdG1wL2NjYWNoZTp6JywgJy12Jywg
Jy92YXIvdG1wL3BhdGNoZXctdGVzdGVyLXRtcC1xZG93bXRkeC9zcmMvZG9ja2VyLXNyYy4yMDIw
LTAxLTI5LTA4LjQyLjA0LjIxMDY0Oi92YXIvdG1wL3FlbXU6eixybycsICdxZW11OmZlZG9yYScs
ICcvdmFyL3RtcC9xZW11L3J1bicsICd0ZXN0LW1pbmd3J10nIHJldHVybmVkIG5vbi16ZXJvIGV4
aXQgc3RhdHVzIDIuCmZpbHRlcj0tLWZpbHRlcj1sYWJlbD1jb20ucWVtdS5pbnN0YW5jZS51dWlk
PThhNDE1MDQzOWRiYzRjNjJhYmRlZTQzNjY5NjBhYzlhCm1ha2VbMV06ICoqKiBbZG9ja2VyLXJ1
bl0gRXJyb3IgMQptYWtlWzFdOiBMZWF2aW5nIGRpcmVjdG9yeSBgL3Zhci90bXAvcGF0Y2hldy10
ZXN0ZXItdG1wLXFkb3dtdGR4L3NyYycKbWFrZTogKioqIFtkb2NrZXItcnVuLXRlc3QtbWluZ3dA
ZmVkb3JhXSBFcnJvciAyCgpyZWFsICAgIDJtNS4yMzRzCnVzZXIgICAgMG03LjY2MnMKCgpUaGUg
ZnVsbCBsb2cgaXMgYXZhaWxhYmxlIGF0Cmh0dHA6Ly9wYXRjaGV3Lm9yZy9sb2dzLzE1ODAzMDAy
MTYtODYxNzItMS1naXQtc2VuZC1lbWFpbC15aS5sLmxpdUBpbnRlbC5jb20vdGVzdGluZy5kb2Nr
ZXItbWluZ3dAZmVkb3JhLz90eXBlPW1lc3NhZ2UuCi0tLQpFbWFpbCBnZW5lcmF0ZWQgYXV0b21h
dGljYWxseSBieSBQYXRjaGV3IFtodHRwczovL3BhdGNoZXcub3JnL10uClBsZWFzZSBzZW5kIHlv
dXIgZmVlZGJhY2sgdG8gcGF0Y2hldy1kZXZlbEByZWRoYXQuY29t

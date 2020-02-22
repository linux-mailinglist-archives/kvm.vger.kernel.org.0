Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B106168D94
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2020 09:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgBVIVr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Feb 2020 03:21:47 -0500
Received: from sender4-of-o51.zoho.com ([136.143.188.51]:21164 "EHLO
        sender4-of-o51.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727030AbgBVIVr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Feb 2020 03:21:47 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1582359680; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=oJ69S9iccE+/0yfnM907i4lHQGbXp32NwpkDFsUWefl00M5SmAVf/dlWCJEi15yiJ+FHPLhNspBm/GTRXPmYwNMz7UC2ZE64j446S+QwDKsFJLy+jDrlliCiGobDXoJdYARzi1rPfXCusezE5IMkSW+F9cMSdd4dbY9szUnieFc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1582359680; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:Subject:To; 
        bh=+zYunpCjb+KJBdmeX8gCJSjyFXV6k5Le34onIYldCK4=; 
        b=CAgHm7MCdoG7p9gvMhT/L8XgRxq3ugD7+kq0j0SX9h3MVOkuS2pGXJdv+LUNq+zq5AJ8CNzozdHt6N5o3Dxfp4kQEQYdruaanBTwezBfPRKRWcTzWc4qIy5+3WiM9K/9s7cNmrxwm4W9OMTthoda40D25t4b6/MdzM9+Cb78He0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=patchew.org;
        spf=pass  smtp.mailfrom=no-reply@patchew.org;
        dmarc=pass header.from=<no-reply@patchew.org> header.from=<no-reply@patchew.org>
Received: from [172.17.0.3] (23.253.156.214 [23.253.156.214]) by mx.zohomail.com
        with SMTPS id 1582359677494242.66904634238847; Sat, 22 Feb 2020 00:21:17 -0800 (PST)
Reply-To: <qemu-devel@nongnu.org>
In-Reply-To: <1582358843-51931-1-git-send-email-yi.l.liu@intel.com>
Subject: Re: [RFC v3.1 00/22] intel_iommu: expose Shared Virtual Addressing to VMs
Message-ID: <158235967568.7375.1474598751029970014@a1bbccc8075a>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
From:   no-reply@patchew.org
To:     yi.l.liu@intel.com
Cc:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        kvm@vger.kernel.org, mst@redhat.com, jun.j.tian@intel.com,
        eric.auger@redhat.com, yi.y.sun@intel.com, pbonzini@redhat.com,
        david@gibson.dropbear.id.au
Date:   Sat, 22 Feb 2020 00:21:17 -0800 (PST)
X-ZohoMailClient: External
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UGF0Y2hldyBVUkw6IGh0dHBzOi8vcGF0Y2hldy5vcmcvUUVNVS8xNTgyMzU4ODQzLTUxOTMxLTEt
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
Y2x1ZGUvaHcvaW9tbXUvaG9zdF9pb21tdV9jb250ZXh0Lmg6MjY6MTA6IGZhdGFsIGVycm9yOiBs
aW51eC9pb21tdS5oOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5CiAjaW5jbHVkZSA8bGludXgv
aW9tbXUuaD4KICAgICAgICAgIF5+fn5+fn5+fn5+fn5+fgpjb21waWxhdGlvbiB0ZXJtaW5hdGVk
LgptYWtlOiAqKiogWy90bXAvcWVtdS10ZXN0L3NyYy9ydWxlcy5tYWs6Njk6IHN0dWJzL3BjaS1o
b3N0LXBpaXgub10gRXJyb3IgMQptYWtlOiAqKiogV2FpdGluZyBmb3IgdW5maW5pc2hlZCBqb2Jz
Li4uLgpUcmFjZWJhY2sgKG1vc3QgcmVjZW50IGNhbGwgbGFzdCk6CiAgRmlsZSAiLi90ZXN0cy9k
b2NrZXIvZG9ja2VyLnB5IiwgbGluZSA2NjQsIGluIDxtb2R1bGU+Ci0tLQogICAgcmFpc2UgQ2Fs
bGVkUHJvY2Vzc0Vycm9yKHJldGNvZGUsIGNtZCkKc3VicHJvY2Vzcy5DYWxsZWRQcm9jZXNzRXJy
b3I6IENvbW1hbmQgJ1snc3VkbycsICctbicsICdkb2NrZXInLCAncnVuJywgJy0tbGFiZWwnLCAn
Y29tLnFlbXUuaW5zdGFuY2UudXVpZD03OTdiZTJlNWQ2Mjg0ZGY4YTI4MjMyMzY4ZDVlYTcwNCcs
ICctdScsICcxMDAzJywgJy0tc2VjdXJpdHktb3B0JywgJ3NlY2NvbXA9dW5jb25maW5lZCcsICct
LXJtJywgJy1lJywgJ1RBUkdFVF9MSVNUPScsICctZScsICdFWFRSQV9DT05GSUdVUkVfT1BUUz0n
LCAnLWUnLCAnVj0nLCAnLWUnLCAnSj0xNCcsICctZScsICdERUJVRz0nLCAnLWUnLCAnU0hPV19F
TlY9JywgJy1lJywgJ0NDQUNIRV9ESVI9L3Zhci90bXAvY2NhY2hlJywgJy12JywgJy9ob21lL3Bh
dGNoZXcyLy5jYWNoZS9xZW11LWRvY2tlci1jY2FjaGU6L3Zhci90bXAvY2NhY2hlOnonLCAnLXYn
LCAnL3Zhci90bXAvcGF0Y2hldy10ZXN0ZXItdG1wLWMzd2FvX2lrL3NyYy9kb2NrZXItc3JjLjIw
MjAtMDItMjItMDMuMTguNDUuMjAzODk6L3Zhci90bXAvcWVtdTp6LHJvJywgJ3FlbXU6ZmVkb3Jh
JywgJy92YXIvdG1wL3FlbXUvcnVuJywgJ3Rlc3QtbWluZ3cnXScgcmV0dXJuZWQgbm9uLXplcm8g
ZXhpdCBzdGF0dXMgMi4KZmlsdGVyPS0tZmlsdGVyPWxhYmVsPWNvbS5xZW11Lmluc3RhbmNlLnV1
aWQ9Nzk3YmUyZTVkNjI4NGRmOGEyODIzMjM2OGQ1ZWE3MDQKbWFrZVsxXTogKioqIFtkb2NrZXIt
cnVuXSBFcnJvciAxCm1ha2VbMV06IExlYXZpbmcgZGlyZWN0b3J5IGAvdmFyL3RtcC9wYXRjaGV3
LXRlc3Rlci10bXAtYzN3YW9faWsvc3JjJwptYWtlOiAqKiogW2RvY2tlci1ydW4tdGVzdC1taW5n
d0BmZWRvcmFdIEVycm9yIDIKCnJlYWwgICAgMm0zMC45NjJzCnVzZXIgICAgMG03LjczN3MKCgpU
aGUgZnVsbCBsb2cgaXMgYXZhaWxhYmxlIGF0Cmh0dHA6Ly9wYXRjaGV3Lm9yZy9sb2dzLzE1ODIz
NTg4NDMtNTE5MzEtMS1naXQtc2VuZC1lbWFpbC15aS5sLmxpdUBpbnRlbC5jb20vdGVzdGluZy5k
b2NrZXItbWluZ3dAZmVkb3JhLz90eXBlPW1lc3NhZ2UuCi0tLQpFbWFpbCBnZW5lcmF0ZWQgYXV0
b21hdGljYWxseSBieSBQYXRjaGV3IFtodHRwczovL3BhdGNoZXcub3JnL10uClBsZWFzZSBzZW5k
IHlvdXIgZmVlZGJhY2sgdG8gcGF0Y2hldy1kZXZlbEByZWRoYXQuY29t

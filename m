Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12FC218E91E
	for <lists+kvm@lfdr.de>; Sun, 22 Mar 2020 14:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgCVN00 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Mar 2020 09:26:26 -0400
Received: from sender4-of-o51.zoho.com ([136.143.188.51]:21125 "EHLO
        sender4-of-o51.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgCVN00 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Mar 2020 09:26:26 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1584883560; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=PUA2rav7S464oaj27BsBRp71D1qRUXFbRLRSRvYU169HOSVXE3B5ZhAH6ft2uZWZF+poPKyGizITaFCQxzP/DvIK0bEqEckuAXXzqBvB37wa1kA3uYmVZhGoh6I/Oiu+y4N8liPz7fKFiHSPnV3necyCHt/KNJIkOjMMrJStMt8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1584883560; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:Subject:To; 
        bh=XkVQVYMwoMmya8jsH4/MrXVATQWsBdeWppgcbaofbYc=; 
        b=Fri8IlmYIY4TFfz64pTjbFetWslTSXubWly3uTG18r6M8deocUGVS03+z/p31rvbSbav/vmgcyaBbWENZxtA1xyutiaTU09UCA1bASeAVyXiem0zfJMltRNa3bLpFDwq7I3hN6lMWnUu7f6gr80k3IznRqrCVnj4tUsE9qXFGEU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        spf=pass  smtp.mailfrom=no-reply@patchew.org;
        dmarc=pass header.from=<no-reply@patchew.org> header.from=<no-reply@patchew.org>
Received: from [172.17.0.3] (23.253.156.214 [23.253.156.214]) by mx.zohomail.com
        with SMTPS id 1584883557386510.8700688990451; Sun, 22 Mar 2020 06:25:57 -0700 (PDT)
In-Reply-To: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
Subject: Re: [PATCH v1 00/22] intel_iommu: expose Shared Virtual Addressing to VMs
Reply-To: <qemu-devel@nongnu.org>
Message-ID: <158488355518.31203.1202436273292692388@39012742ff91>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
From:   no-reply@patchew.org
To:     yi.l.liu@intel.com
Cc:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com, jean-philippe@linaro.org, kevin.tian@intel.com,
        yi.l.liu@intel.com, kvm@vger.kernel.org, mst@redhat.com,
        jun.j.tian@intel.com, eric.auger@redhat.com, yi.y.sun@intel.com,
        pbonzini@redhat.com, hao.wu@intel.com, david@gibson.dropbear.id.au
Date:   Sun, 22 Mar 2020 06:25:57 -0700 (PDT)
X-ZohoMailClient: External
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UGF0Y2hldyBVUkw6IGh0dHBzOi8vcGF0Y2hldy5vcmcvUUVNVS8xNTg0ODgwNTc5LTEyMTc4LTEt
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
Y2x1ZGUvaHcvaW9tbXUvaG9zdF9pb21tdV9jb250ZXh0Lmg6Mjg6MTA6IGZhdGFsIGVycm9yOiBs
aW51eC9pb21tdS5oOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5CiAjaW5jbHVkZSA8bGludXgv
aW9tbXUuaD4KICAgICAgICAgIF5+fn5+fn5+fn5+fn5+fgpjb21waWxhdGlvbiB0ZXJtaW5hdGVk
LgptYWtlOiAqKiogWy90bXAvcWVtdS10ZXN0L3NyYy9ydWxlcy5tYWs6Njk6IHN0dWJzL3BjaS1o
b3N0LXBpaXgub10gRXJyb3IgMQptYWtlOiAqKiogV2FpdGluZyBmb3IgdW5maW5pc2hlZCBqb2Jz
Li4uLgpUcmFjZWJhY2sgKG1vc3QgcmVjZW50IGNhbGwgbGFzdCk6CiAgRmlsZSAiLi90ZXN0cy9k
b2NrZXIvZG9ja2VyLnB5IiwgbGluZSA2NjQsIGluIDxtb2R1bGU+Ci0tLQogICAgcmFpc2UgQ2Fs
bGVkUHJvY2Vzc0Vycm9yKHJldGNvZGUsIGNtZCkKc3VicHJvY2Vzcy5DYWxsZWRQcm9jZXNzRXJy
b3I6IENvbW1hbmQgJ1snc3VkbycsICctbicsICdkb2NrZXInLCAncnVuJywgJy0tbGFiZWwnLCAn
Y29tLnFlbXUuaW5zdGFuY2UudXVpZD1mNDViNTNhMDFjOGE0NDZkYmE1MTIwZGE3YzNmNjNlMics
ICctdScsICcxMDAzJywgJy0tc2VjdXJpdHktb3B0JywgJ3NlY2NvbXA9dW5jb25maW5lZCcsICct
LXJtJywgJy1lJywgJ1RBUkdFVF9MSVNUPScsICctZScsICdFWFRSQV9DT05GSUdVUkVfT1BUUz0n
LCAnLWUnLCAnVj0nLCAnLWUnLCAnSj0xNCcsICctZScsICdERUJVRz0nLCAnLWUnLCAnU0hPV19F
TlY9JywgJy1lJywgJ0NDQUNIRV9ESVI9L3Zhci90bXAvY2NhY2hlJywgJy12JywgJy9ob21lL3Bh
dGNoZXcyLy5jYWNoZS9xZW11LWRvY2tlci1jY2FjaGU6L3Zhci90bXAvY2NhY2hlOnonLCAnLXYn
LCAnL3Zhci90bXAvcGF0Y2hldy10ZXN0ZXItdG1wLWdxbXlwNnBlL3NyYy9kb2NrZXItc3JjLjIw
MjAtMDMtMjItMDkuMjQuMTEuMTI2Mzg6L3Zhci90bXAvcWVtdTp6LHJvJywgJ3FlbXU6ZmVkb3Jh
JywgJy92YXIvdG1wL3FlbXUvcnVuJywgJ3Rlc3QtbWluZ3cnXScgcmV0dXJuZWQgbm9uLXplcm8g
ZXhpdCBzdGF0dXMgMi4KZmlsdGVyPS0tZmlsdGVyPWxhYmVsPWNvbS5xZW11Lmluc3RhbmNlLnV1
aWQ9ZjQ1YjUzYTAxYzhhNDQ2ZGJhNTEyMGRhN2MzZjYzZTIKbWFrZVsxXTogKioqIFtkb2NrZXIt
cnVuXSBFcnJvciAxCm1ha2VbMV06IExlYXZpbmcgZGlyZWN0b3J5IGAvdmFyL3RtcC9wYXRjaGV3
LXRlc3Rlci10bXAtZ3FteXA2cGUvc3JjJwptYWtlOiAqKiogW2RvY2tlci1ydW4tdGVzdC1taW5n
d0BmZWRvcmFdIEVycm9yIDIKCnJlYWwgICAgMW00My4zMDBzCnVzZXIgICAgMG04LjE4M3MKCgpU
aGUgZnVsbCBsb2cgaXMgYXZhaWxhYmxlIGF0Cmh0dHA6Ly9wYXRjaGV3Lm9yZy9sb2dzLzE1ODQ4
ODA1NzktMTIxNzgtMS1naXQtc2VuZC1lbWFpbC15aS5sLmxpdUBpbnRlbC5jb20vdGVzdGluZy5k
b2NrZXItbWluZ3dAZmVkb3JhLz90eXBlPW1lc3NhZ2UuCi0tLQpFbWFpbCBnZW5lcmF0ZWQgYXV0
b21hdGljYWxseSBieSBQYXRjaGV3IFtodHRwczovL3BhdGNoZXcub3JnL10uClBsZWFzZSBzZW5k
IHlvdXIgZmVlZGJhY2sgdG8gcGF0Y2hldy1kZXZlbEByZWRoYXQuY29t

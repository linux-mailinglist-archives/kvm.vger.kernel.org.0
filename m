Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B6027946B
	for <lists+kvm@lfdr.de>; Sat, 26 Sep 2020 00:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729058AbgIYW6L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 18:58:11 -0400
Received: from sender4-of-o57.zoho.com ([136.143.188.57]:21758 "EHLO
        sender4-of-o57.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbgIYW6L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 18:58:11 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1601074679; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=kZKgJt5iNy54n81MIwBi6ge401g8Jx0XjODJO2vrnxfKKJ3JFBWODmhHDFNbkBcauXAQqWjb8VWf0b6nzGKFImzniX6zF5UxTvUM9oiEW7IYubuYiNM+e59RMXXXpdCaX+nomNlPvYR/Y9uhBpkLBXX6e883vdmFa0VzCECREDE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1601074679; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:Subject:To; 
        bh=7jYJb4UCuN3HKMTiIcPMyOK0JBjcIMZHxNulBkfarVs=; 
        b=OfQnSUBZDuwjbL6oJ7FBNORz31UcNPXYZYj45qq+Co8dFAkkEt1cMy490YtwrVaIHy/Qf3KKMcY1uU1NmsASrgUnbAeCaeEIoM7dlalEySNjkWiUNd2CKm8WpAPGqsv4UG5jmYFEpde7gAx+ihJfIHofFDCz+D7GsX89nGKm0x4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        spf=pass  smtp.mailfrom=no-reply@patchew.org;
        dmarc=pass header.from=<no-reply@patchew.org> header.from=<no-reply@patchew.org>
Received: from [172.17.0.3] (23.253.156.214 [23.253.156.214]) by mx.zohomail.com
        with SMTPS id 1601074677971243.91342495746062; Fri, 25 Sep 2020 15:57:57 -0700 (PDT)
Subject: Re: [PATCH v4 0/6] Qemu SEV-ES guest support
Message-ID: <160107467617.10465.16659228009221665839@66eaa9a8a123>
Reply-To: <qemu-devel@nongnu.org>
In-Reply-To: <cover.1601060620.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
From:   no-reply@patchew.org
To:     thomas.lendacky@amd.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, brijesh.singh@amd.com,
        ehabkost@redhat.com, mst@redhat.com, ckuehl@redhat.com,
        mtosatti@redhat.com, dgilbert@redhat.com, pbonzini@redhat.com,
        jslaby@suse.cz, rth@twiddle.net
Date:   Fri, 25 Sep 2020 15:57:57 -0700 (PDT)
X-ZohoMailClient: External
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UGF0Y2hldyBVUkw6IGh0dHBzOi8vcGF0Y2hldy5vcmcvUUVNVS9jb3Zlci4xNjAxMDYwNjIwLmdp
dC50aG9tYXMubGVuZGFja3lAYW1kLmNvbS8KCgoKSGksCgpUaGlzIHNlcmllcyBmYWlsZWQgdGhl
IGRvY2tlci1xdWlja0BjZW50b3M3IGJ1aWxkIHRlc3QuIFBsZWFzZSBmaW5kIHRoZSB0ZXN0aW5n
IGNvbW1hbmRzIGFuZAp0aGVpciBvdXRwdXQgYmVsb3cuIElmIHlvdSBoYXZlIERvY2tlciBpbnN0
YWxsZWQsIHlvdSBjYW4gcHJvYmFibHkgcmVwcm9kdWNlIGl0CmxvY2FsbHkuCgo9PT0gVEVTVCBT
Q1JJUFQgQkVHSU4gPT09CiMhL2Jpbi9iYXNoCm1ha2UgZG9ja2VyLWltYWdlLWNlbnRvczcgVj0x
IE5FVFdPUks9MQp0aW1lIG1ha2UgZG9ja2VyLXRlc3QtcXVpY2tAY2VudG9zNyBTSE9XX0VOVj0x
IEo9MTQgTkVUV09SSz0xCj09PSBURVNUIFNDUklQVCBFTkQgPT09CgpDIGxpbmtlciBmb3IgdGhl
IGhvc3QgbWFjaGluZTogY2MgbGQuYmZkIDIuMjctNDMKSG9zdCBtYWNoaW5lIGNwdSBmYW1pbHk6
IHg4Nl82NApIb3N0IG1hY2hpbmUgY3B1OiB4ODZfNjQKLi4vc3JjL21lc29uLmJ1aWxkOjEwOiBX
QVJOSU5HOiBNb2R1bGUgdW5zdGFibGUta2V5dmFsIGhhcyBubyBiYWNrd2FyZHMgb3IgZm9yd2Fy
ZHMgY29tcGF0aWJpbGl0eSBhbmQgbWlnaHQgbm90IGV4aXN0IGluIGZ1dHVyZSByZWxlYXNlcy4K
UHJvZ3JhbSBzaCBmb3VuZDogWUVTClByb2dyYW0gcHl0aG9uMyBmb3VuZDogWUVTICgvdXNyL2Jp
bi9weXRob24zKQpDb25maWd1cmluZyBuaW5qYXRvb2wgdXNpbmcgY29uZmlndXJhdGlvbgotLS0K
ICBURVNUICAgIGlvdGVzdC1xY293MjogMDI5CnNvY2tldF9hY2NlcHQgZmFpbGVkOiBSZXNvdXJj
ZSB0ZW1wb3JhcmlseSB1bmF2YWlsYWJsZQoqKgpFUlJPUjouLi9zcmMvdGVzdHMvcXRlc3QvbGli
cXRlc3QuYzozMDE6cXRlc3RfaW5pdF93aXRob3V0X3FtcF9oYW5kc2hha2U6IGFzc2VydGlvbiBm
YWlsZWQ6IChzLT5mZCA+PSAwICYmIHMtPnFtcF9mZCA+PSAwKQouLi9zcmMvdGVzdHMvcXRlc3Qv
bGlicXRlc3QuYzoxNjY6IGtpbGxfcWVtdSgpIHRyaWVkIHRvIHRlcm1pbmF0ZSBRRU1VIHByb2Nl
c3MgYnV0IGVuY291bnRlcmVkIGV4aXQgc3RhdHVzIDEgKGV4cGVjdGVkIDApCkVSUk9SIHF0ZXN0
LXg4Nl82NDogYmlvcy10YWJsZXMtdGVzdCAtIEJhaWwgb3V0ISBFUlJPUjouLi9zcmMvdGVzdHMv
cXRlc3QvbGlicXRlc3QuYzozMDE6cXRlc3RfaW5pdF93aXRob3V0X3FtcF9oYW5kc2hha2U6IGFz
c2VydGlvbiBmYWlsZWQ6IChzLT5mZCA+PSAwICYmIHMtPnFtcF9mZCA+PSAwKQptYWtlOiAqKiog
W3J1bi10ZXN0LTEzOF0gRXJyb3IgMQptYWtlOiAqKiogV2FpdGluZyBmb3IgdW5maW5pc2hlZCBq
b2JzLi4uLgpDb3VsZCBub3QgYWNjZXNzIEtWTSBrZXJuZWwgbW9kdWxlOiBObyBzdWNoIGZpbGUg
b3IgZGlyZWN0b3J5CnFlbXUtc3lzdGVtLXg4Nl82NDogLWFjY2VsIGt2bTogZmFpbGVkIHRvIGlu
aXRpYWxpemUga3ZtOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5Ci0tLQogICAgcmFpc2UgQ2Fs
bGVkUHJvY2Vzc0Vycm9yKHJldGNvZGUsIGNtZCkKc3VicHJvY2Vzcy5DYWxsZWRQcm9jZXNzRXJy
b3I6IENvbW1hbmQgJ1snc3VkbycsICctbicsICdkb2NrZXInLCAncnVuJywgJy0tcm0nLCAnLS1s
YWJlbCcsICdjb20ucWVtdS5pbnN0YW5jZS51dWlkPWFjOGRlODE2Mzg2ZjQzZmJiZDM1ZThlZWY3
NzEwMzg1JywgJy11JywgJzEwMDEnLCAnLS1zZWN1cml0eS1vcHQnLCAnc2VjY29tcD11bmNvbmZp
bmVkJywgJy1lJywgJ1RBUkdFVF9MSVNUPScsICctZScsICdFWFRSQV9DT05GSUdVUkVfT1BUUz0n
LCAnLWUnLCAnVj0nLCAnLWUnLCAnSj0xNCcsICctZScsICdERUJVRz0nLCAnLWUnLCAnU0hPV19F
TlY9MScsICctZScsICdDQ0FDSEVfRElSPS92YXIvdG1wL2NjYWNoZScsICctdicsICcvaG9tZS9w
YXRjaGV3Ly5jYWNoZS9xZW11LWRvY2tlci1jY2FjaGU6L3Zhci90bXAvY2NhY2hlOnonLCAnLXYn
LCAnL3Zhci90bXAvcGF0Y2hldy10ZXN0ZXItdG1wLWhtZjhwbzNnL3NyYy9kb2NrZXItc3JjLjIw
MjAtMDktMjUtMTguNDAuMzIuMjQwMDU6L3Zhci90bXAvcWVtdTp6LHJvJywgJ3FlbXUvY2VudG9z
NycsICcvdmFyL3RtcC9xZW11L3J1bicsICd0ZXN0LXF1aWNrJ10nIHJldHVybmVkIG5vbi16ZXJv
IGV4aXQgc3RhdHVzIDIuCmZpbHRlcj0tLWZpbHRlcj1sYWJlbD1jb20ucWVtdS5pbnN0YW5jZS51
dWlkPWFjOGRlODE2Mzg2ZjQzZmJiZDM1ZThlZWY3NzEwMzg1Cm1ha2VbMV06ICoqKiBbZG9ja2Vy
LXJ1bl0gRXJyb3IgMQptYWtlWzFdOiBMZWF2aW5nIGRpcmVjdG9yeSBgL3Zhci90bXAvcGF0Y2hl
dy10ZXN0ZXItdG1wLWhtZjhwbzNnL3NyYycKbWFrZTogKioqIFtkb2NrZXItcnVuLXRlc3QtcXVp
Y2tAY2VudG9zN10gRXJyb3IgMgoKcmVhbCAgICAxN20yMy40MTRzCnVzZXIgICAgMG0yMS45NTNz
CgoKVGhlIGZ1bGwgbG9nIGlzIGF2YWlsYWJsZSBhdApodHRwOi8vcGF0Y2hldy5vcmcvbG9ncy9j
b3Zlci4xNjAxMDYwNjIwLmdpdC50aG9tYXMubGVuZGFja3lAYW1kLmNvbS90ZXN0aW5nLmRvY2tl
ci1xdWlja0BjZW50b3M3Lz90eXBlPW1lc3NhZ2UuCi0tLQpFbWFpbCBnZW5lcmF0ZWQgYXV0b21h
dGljYWxseSBieSBQYXRjaGV3IFtodHRwczovL3BhdGNoZXcub3JnL10uClBsZWFzZSBzZW5kIHlv
dXIgZmVlZGJhY2sgdG8gcGF0Y2hldy1kZXZlbEByZWRoYXQuY29t

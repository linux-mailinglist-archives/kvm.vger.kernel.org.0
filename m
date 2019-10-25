Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05B7CE4383
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 08:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390925AbfJYGWA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 02:22:00 -0400
Received: from sender4-of-o54.zoho.com ([136.143.188.54]:21431 "EHLO
        sender4-of-o54.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfJYGWA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 02:22:00 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1571984498; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=lMsL5aURGeoF+OIMigFruL5I4cyrZ0Rv9qKsuemNLxyRYnBjfcETu6Dh8fRg5TDtPhzDxjsB4sf2vc2S6wbvmiaRKYYASbk52EEXGC8pTCYOgg8pOoLXgfbuUj9J94XuMvXOd1YtNcThrH1+AHHp4Sdwt75/K+dKiTi2v7lB2mk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1571984498; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:Subject:To; 
        bh=21Kty8O781Lb+S9ZG+maCGjc2+figRrW3+QIcQJStYo=; 
        b=Qc730j4brNN8s6TOYu+E/TRwONX8zX50RmSNeVrXmspuIosI/EmO9NZ8V9I5R56Qgk/ubMgwX+7XWNRmRYIYP0DbX7PpGh3QLSJwj2aEidBiJZNdNO5roDSNrlY8uO+HHYrJFmpLnZVmVPI7YsbBGkUfqwWcvcodx2f5NAllWwM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=patchew.org;
        spf=pass  smtp.mailfrom=no-reply@patchew.org;
        dmarc=pass header.from=<no-reply@patchew.org> header.from=<no-reply@patchew.org>
Received: from [172.17.0.3] (23.253.156.214 [23.253.156.214]) by mx.zohomail.com
        with SMTPS id 1571984496849216.40821625631452; Thu, 24 Oct 2019 23:21:36 -0700 (PDT)
In-Reply-To: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
Reply-To: <qemu-devel@nongnu.org>
Subject: Re: [RFC v2 00/22] intel_iommu: expose Shared Virtual Addressing to VM
Message-ID: <157198449500.8606.5481357465414698106@37313f22b938>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
From:   no-reply@patchew.org
To:     yi.l.liu@intel.com
Cc:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        kvm@vger.kernel.org, jun.j.tian@intel.com, eric.auger@redhat.com,
        yi.y.sun@intel.com, jacob.jun.pan@linux.intel.com,
        david@gibson.dropbear.id.au
Date:   Thu, 24 Oct 2019 23:21:36 -0700 (PDT)
X-ZohoMailClient: External
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UGF0Y2hldyBVUkw6IGh0dHBzOi8vcGF0Y2hldy5vcmcvUUVNVS8xNTcxOTIwNDgzLTMzODItMS1n
aXQtc2VuZC1lbWFpbC15aS5sLmxpdUBpbnRlbC5jb20vCgoKCkhpLAoKVGhpcyBzZXJpZXMgZmFp
bGVkIHRoZSBkb2NrZXItcXVpY2tAY2VudG9zNyBidWlsZCB0ZXN0LiBQbGVhc2UgZmluZCB0aGUg
dGVzdGluZyBjb21tYW5kcyBhbmQKdGhlaXIgb3V0cHV0IGJlbG93LiBJZiB5b3UgaGF2ZSBEb2Nr
ZXIgaW5zdGFsbGVkLCB5b3UgY2FuIHByb2JhYmx5IHJlcHJvZHVjZSBpdApsb2NhbGx5LgoKPT09
IFRFU1QgU0NSSVBUIEJFR0lOID09PQojIS9iaW4vYmFzaAptYWtlIGRvY2tlci1pbWFnZS1jZW50
b3M3IFY9MSBORVRXT1JLPTEKdGltZSBtYWtlIGRvY2tlci10ZXN0LXF1aWNrQGNlbnRvczcgU0hP
V19FTlY9MSBKPTE0IE5FVFdPUks9MQo9PT0gVEVTVCBTQ1JJUFQgRU5EID09PQoKICBDQyAgICAg
IGh3L3BjaS9wY2lfaG9zdC5vCiAgQ0MgICAgICBody9wY2kvcGNpZS5vCi90bXAvcWVtdS10ZXN0
L3NyYy9ody9wY2ktaG9zdC9kZXNpZ253YXJlLmM6IEluIGZ1bmN0aW9uICdkZXNpZ253YXJlX3Bj
aWVfaG9zdF9yZWFsaXplJzoKL3RtcC9xZW11LXRlc3Qvc3JjL2h3L3BjaS1ob3N0L2Rlc2lnbndh
cmUuYzo2OTM6NTogZXJyb3I6IGluY29tcGF0aWJsZSB0eXBlIGZvciBhcmd1bWVudCAyIG9mICdw
Y2lfc2V0dXBfaW9tbXUnCiAgICAgcGNpX3NldHVwX2lvbW11KHBjaS0+YnVzLCBkZXNpZ253YXJl
X2lvbW11X29wcywgcyk7CiAgICAgXgpJbiBmaWxlIGluY2x1ZGVkIGZyb20gL3RtcC9xZW11LXRl
c3Qvc3JjL2luY2x1ZGUvaHcvcGNpL21zaS5oOjI0OjAsCi0tLQovdG1wL3FlbXUtdGVzdC9zcmMv
aW5jbHVkZS9ody9wY2kvcGNpLmg6NDk1OjY6IG5vdGU6IGV4cGVjdGVkICdjb25zdCBzdHJ1Y3Qg
UENJSU9NTVVPcHMgKicgYnV0IGFyZ3VtZW50IGlzIG9mIHR5cGUgJ1BDSUlPTU1VT3BzJwogdm9p
ZCBwY2lfc2V0dXBfaW9tbXUoUENJQnVzICpidXMsIGNvbnN0IFBDSUlPTU1VT3BzICppb21tdV9v
cHMsIHZvaWQgKm9wYXF1ZSk7CiAgICAgIF4KbWFrZTogKioqIFtody9wY2ktaG9zdC9kZXNpZ253
YXJlLm9dIEVycm9yIDEKbWFrZTogKioqIFdhaXRpbmcgZm9yIHVuZmluaXNoZWQgam9icy4uLi4K
VHJhY2ViYWNrIChtb3N0IHJlY2VudCBjYWxsIGxhc3QpOgogIEZpbGUgIi4vdGVzdHMvZG9ja2Vy
L2RvY2tlci5weSIsIGxpbmUgNjYyLCBpbiA8bW9kdWxlPgotLS0KICAgIHJhaXNlIENhbGxlZFBy
b2Nlc3NFcnJvcihyZXRjb2RlLCBjbWQpCnN1YnByb2Nlc3MuQ2FsbGVkUHJvY2Vzc0Vycm9yOiBD
b21tYW5kICdbJ3N1ZG8nLCAnLW4nLCAnZG9ja2VyJywgJ3J1bicsICctLWxhYmVsJywgJ2NvbS5x
ZW11Lmluc3RhbmNlLnV1aWQ9MDkyYzBmOTc1MGU2NDU0NzgwZGNlYWQ0MzZlNmJjMmMnLCAnLXUn
LCAnMTAwMScsICctLXNlY3VyaXR5LW9wdCcsICdzZWNjb21wPXVuY29uZmluZWQnLCAnLS1ybScs
ICctZScsICdUQVJHRVRfTElTVD0nLCAnLWUnLCAnRVhUUkFfQ09ORklHVVJFX09QVFM9JywgJy1l
JywgJ1Y9JywgJy1lJywgJ0o9MTQnLCAnLWUnLCAnREVCVUc9JywgJy1lJywgJ1NIT1dfRU5WPTEn
LCAnLWUnLCAnQ0NBQ0hFX0RJUj0vdmFyL3RtcC9jY2FjaGUnLCAnLXYnLCAnL2hvbWUvcGF0Y2hl
dy8uY2FjaGUvcWVtdS1kb2NrZXItY2NhY2hlOi92YXIvdG1wL2NjYWNoZTp6JywgJy12JywgJy92
YXIvdG1wL3BhdGNoZXctdGVzdGVyLXRtcC1paDN6aHpzMy9zcmMvZG9ja2VyLXNyYy4yMDE5LTEw
LTI1LTAyLjE4LjI2LjMyMDU4Oi92YXIvdG1wL3FlbXU6eixybycsICdxZW11OmNlbnRvczcnLCAn
L3Zhci90bXAvcWVtdS9ydW4nLCAndGVzdC1xdWljayddJyByZXR1cm5lZCBub24temVybyBleGl0
IHN0YXR1cyAyLgpmaWx0ZXI9LS1maWx0ZXI9bGFiZWw9Y29tLnFlbXUuaW5zdGFuY2UudXVpZD0w
OTJjMGY5NzUwZTY0NTQ3ODBkY2VhZDQzNmU2YmMyYwptYWtlWzFdOiAqKiogW2RvY2tlci1ydW5d
IEVycm9yIDEKbWFrZVsxXTogTGVhdmluZyBkaXJlY3RvcnkgYC92YXIvdG1wL3BhdGNoZXctdGVz
dGVyLXRtcC1paDN6aHpzMy9zcmMnCm1ha2U6ICoqKiBbZG9ja2VyLXJ1bi10ZXN0LXF1aWNrQGNl
bnRvczddIEVycm9yIDIKCnJlYWwgICAgM204Ljc4M3MKdXNlciAgICAwbTguMDkzcwoKClRoZSBm
dWxsIGxvZyBpcyBhdmFpbGFibGUgYXQKaHR0cDovL3BhdGNoZXcub3JnL2xvZ3MvMTU3MTkyMDQ4
My0zMzgyLTEtZ2l0LXNlbmQtZW1haWwteWkubC5saXVAaW50ZWwuY29tL3Rlc3RpbmcuZG9ja2Vy
LXF1aWNrQGNlbnRvczcvP3R5cGU9bWVzc2FnZS4KLS0tCkVtYWlsIGdlbmVyYXRlZCBhdXRvbWF0
aWNhbGx5IGJ5IFBhdGNoZXcgW2h0dHBzOi8vcGF0Y2hldy5vcmcvXS4KUGxlYXNlIHNlbmQgeW91
ciBmZWVkYmFjayB0byBwYXRjaGV3LWRldmVsQHJlZGhhdC5jb20=


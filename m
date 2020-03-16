Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6646A187611
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 00:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732870AbgCPXKs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 19:10:48 -0400
Received: from sender4-of-o51.zoho.com ([136.143.188.51]:21133 "EHLO
        sender4-of-o51.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732846AbgCPXKr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 19:10:47 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1584400231; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=lTJo3Ft9H5/oJfM+tkL+eNvI0GBJEAdoSc+zlpAho5RpIkrVp7peED+4HzJ1hV6llj2x5IvILV8Y/ZcfCQ0D4VfHaUruILnwuKQnCRg+0g8yNBPgs5t9JFvEKAwbBG1eRfhznqoKSCxs6d+IuYSw3HbmwSS87YQZBFKhnbJMCo0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1584400231; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:Subject:To; 
        bh=ALw4DAB7Cs8zNB9H3tmmwtuvBjRFkW2rCw2X+VUNNy4=; 
        b=NXUYzKG5seVchkE4a6BjKWi63GFLSNY35n5m1MQTDrD04K4W34r6LKgSP4ZTh26I16rEH8FWG9svZGSJMFiT9mYwiFKBnOLRzCQuahTWLGFh6TH4327zP2uGVnSzG8Wcyd2kW8p5doNTAA1cUiC9EYEOVGBASLeZ4KML/QjYQqg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        spf=pass  smtp.mailfrom=no-reply@patchew.org;
        dmarc=pass header.from=<no-reply@patchew.org> header.from=<no-reply@patchew.org>
Received: from [172.17.0.3] (23.253.156.214 [23.253.156.214]) by mx.zohomail.com
        with SMTPS id 1584400229998294.08700547819376; Mon, 16 Mar 2020 16:10:29 -0700 (PDT)
In-Reply-To: <20200316160634.3386-1-philmd@redhat.com>
Subject: Re: [PATCH v3 00/19] Support disabling TCG on ARM (part 2)
Reply-To: <qemu-devel@nongnu.org>
Message-ID: <158440022829.17104.10073980639396004207@39012742ff91>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
From:   no-reply@patchew.org
To:     philmd@redhat.com
Cc:     qemu-devel@nongnu.org, fam@euphon.net, peter.maydell@linaro.org,
        thuth@redhat.com, kvm@vger.kernel.org, alex.bennee@linaro.org,
        richard.henderson@linaro.org, qemu-arm@nongnu.org,
        pbonzini@redhat.com, philmd@redhat.com
Date:   Mon, 16 Mar 2020 16:10:29 -0700 (PDT)
X-ZohoMailClient: External
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UGF0Y2hldyBVUkw6IGh0dHBzOi8vcGF0Y2hldy5vcmcvUUVNVS8yMDIwMDMxNjE2MDYzNC4zMzg2
LTEtcGhpbG1kQHJlZGhhdC5jb20vCgoKCkhpLAoKVGhpcyBzZXJpZXMgZmFpbGVkIHRoZSBkb2Nr
ZXItcXVpY2tAY2VudG9zNyBidWlsZCB0ZXN0LiBQbGVhc2UgZmluZCB0aGUgdGVzdGluZyBjb21t
YW5kcyBhbmQKdGhlaXIgb3V0cHV0IGJlbG93LiBJZiB5b3UgaGF2ZSBEb2NrZXIgaW5zdGFsbGVk
LCB5b3UgY2FuIHByb2JhYmx5IHJlcHJvZHVjZSBpdApsb2NhbGx5LgoKPT09IFRFU1QgU0NSSVBU
IEJFR0lOID09PQojIS9iaW4vYmFzaAptYWtlIGRvY2tlci1pbWFnZS1jZW50b3M3IFY9MSBORVRX
T1JLPTEKdGltZSBtYWtlIGRvY2tlci10ZXN0LXF1aWNrQGNlbnRvczcgU0hPV19FTlY9MSBKPTE0
IE5FVFdPUks9MQo9PT0gVEVTVCBTQ1JJUFQgRU5EID09PQoKbWlzc2luZyBvYmplY3QgdHlwZSAn
b3ItaXJxJwpCcm9rZW4gcGlwZQovdG1wL3FlbXUtdGVzdC9zcmMvdGVzdHMvcXRlc3QvbGlicXRl
c3QuYzoxNzU6IGtpbGxfcWVtdSgpIGRldGVjdGVkIFFFTVUgZGVhdGggZnJvbSBzaWduYWwgNiAo
QWJvcnRlZCkgKGNvcmUgZHVtcGVkKQpFUlJPUiAtIHRvbyBmZXcgdGVzdHMgcnVuIChleHBlY3Rl
ZCA2LCBnb3QgNSkKbWFrZTogKioqIFtjaGVjay1xdGVzdC1hYXJjaDY0XSBFcnJvciAxCm1ha2U6
ICoqKiBXYWl0aW5nIGZvciB1bmZpbmlzaGVkIGpvYnMuLi4uCkNvdWxkIG5vdCBhY2Nlc3MgS1ZN
IGtlcm5lbCBtb2R1bGU6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkKcWVtdS1zeXN0ZW0teDg2
XzY0OiAtYWNjZWwga3ZtOiBmYWlsZWQgdG8gaW5pdGlhbGl6ZSBrdm06IE5vIHN1Y2ggZmlsZSBv
ciBkaXJlY3RvcnkKLS0tCiAgICByYWlzZSBDYWxsZWRQcm9jZXNzRXJyb3IocmV0Y29kZSwgY21k
KQpzdWJwcm9jZXNzLkNhbGxlZFByb2Nlc3NFcnJvcjogQ29tbWFuZCAnWydzdWRvJywgJy1uJywg
J2RvY2tlcicsICdydW4nLCAnLS1sYWJlbCcsICdjb20ucWVtdS5pbnN0YW5jZS51dWlkPWQ1MWZl
NzMxNjA2NDRlMGJhNmEwZjNjZjFjMWQ2MjA4JywgJy11JywgJzEwMDMnLCAnLS1zZWN1cml0eS1v
cHQnLCAnc2VjY29tcD11bmNvbmZpbmVkJywgJy0tcm0nLCAnLWUnLCAnVEFSR0VUX0xJU1Q9Jywg
Jy1lJywgJ0VYVFJBX0NPTkZJR1VSRV9PUFRTPScsICctZScsICdWPScsICctZScsICdKPTE0Jywg
Jy1lJywgJ0RFQlVHPScsICctZScsICdTSE9XX0VOVj0xJywgJy1lJywgJ0NDQUNIRV9ESVI9L3Zh
ci90bXAvY2NhY2hlJywgJy12JywgJy9ob21lL3BhdGNoZXcyLy5jYWNoZS9xZW11LWRvY2tlci1j
Y2FjaGU6L3Zhci90bXAvY2NhY2hlOnonLCAnLXYnLCAnL3Zhci90bXAvcGF0Y2hldy10ZXN0ZXIt
dG1wLXU4anU0c3NwL3NyYy9kb2NrZXItc3JjLjIwMjAtMDMtMTYtMTguNTcuMTMuMjEwMDc6L3Zh
ci90bXAvcWVtdTp6LHJvJywgJ3FlbXU6Y2VudG9zNycsICcvdmFyL3RtcC9xZW11L3J1bicsICd0
ZXN0LXF1aWNrJ10nIHJldHVybmVkIG5vbi16ZXJvIGV4aXQgc3RhdHVzIDIuCmZpbHRlcj0tLWZp
bHRlcj1sYWJlbD1jb20ucWVtdS5pbnN0YW5jZS51dWlkPWQ1MWZlNzMxNjA2NDRlMGJhNmEwZjNj
ZjFjMWQ2MjA4Cm1ha2VbMV06ICoqKiBbZG9ja2VyLXJ1bl0gRXJyb3IgMQptYWtlWzFdOiBMZWF2
aW5nIGRpcmVjdG9yeSBgL3Zhci90bXAvcGF0Y2hldy10ZXN0ZXItdG1wLXU4anU0c3NwL3NyYycK
bWFrZTogKioqIFtkb2NrZXItcnVuLXRlc3QtcXVpY2tAY2VudG9zN10gRXJyb3IgMgoKcmVhbCAg
ICAxM20xNi4yMjhzCnVzZXIgICAgMG04Ljc2M3MKCgpUaGUgZnVsbCBsb2cgaXMgYXZhaWxhYmxl
IGF0Cmh0dHA6Ly9wYXRjaGV3Lm9yZy9sb2dzLzIwMjAwMzE2MTYwNjM0LjMzODYtMS1waGlsbWRA
cmVkaGF0LmNvbS90ZXN0aW5nLmRvY2tlci1xdWlja0BjZW50b3M3Lz90eXBlPW1lc3NhZ2UuCi0t
LQpFbWFpbCBnZW5lcmF0ZWQgYXV0b21hdGljYWxseSBieSBQYXRjaGV3IFtodHRwczovL3BhdGNo
ZXcub3JnL10uClBsZWFzZSBzZW5kIHlvdXIgZmVlZGJhY2sgdG8gcGF0Y2hldy1kZXZlbEByZWRo
YXQuY29t

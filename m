Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 702C9EE045
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 13:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbfKDMoB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 07:44:01 -0500
Received: from sender4-of-o58.zoho.com ([136.143.188.58]:21879 "EHLO
        sender4-of-o58.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbfKDMoA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 07:44:00 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1572871412; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=ZGGX4IiQmFpfjgydc5Xn3ayaHUnZg5ayc1LgN+2EPAEWadlQ72zdOWTHjWwWf463miX0+AQduBQOwrZZGDWGqGQg9RXjYQU/UgNLOTWKMHHGwVhJAg9XdayW3ORX/ipIds8MeKjQhM9LJCYoJCwmZ0pT2Q7XjsREIdqT1UkQTYs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1572871412; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:Subject:To; 
        bh=6Ln4BdVwFHO2I5x/J3dmCMdBNcZGsmz/4+6/IHcamSs=; 
        b=OXHSlHABKLoE/hqE1f3/eQLMEHQH+AidsnP2yoeYe4Qz5s3+azo1sI0zcMwQEpMxEKYXYqKdTAGrp1j35ct3daqdXcwBags9mh6M4a5BqzIHRxGHBO4zaAlBTofir9euc9yn3DpsM7i+6pE+Qegqzwhyq/2ev0FbQnnXK9GOLWA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=patchew.org;
        spf=pass  smtp.mailfrom=no-reply@patchew.org;
        dmarc=pass header.from=<no-reply@patchew.org> header.from=<no-reply@patchew.org>
Received: from [172.17.0.3] (23.253.156.214 [23.253.156.214]) by mx.zohomail.com
        with SMTPS id 1572871409656174.88674502333663; Mon, 4 Nov 2019 04:43:29 -0800 (PST)
In-Reply-To: <20191104121458.29208-1-zhengxiang9@huawei.com>
Reply-To: <qemu-devel@nongnu.org>
Subject: Re: [PATCH v21 0/6] Add ARMv8 RAS virtualization support in QEMU
Message-ID: <157287140443.27285.11755911437215821061@37313f22b938>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
From:   no-reply@patchew.org
To:     zhengxiang9@huawei.com
Cc:     pbonzini@redhat.com, mst@redhat.com, imammedo@redhat.com,
        shannon.zhaosl@gmail.com, peter.maydell@linaro.org,
        lersek@redhat.com, james.morse@arm.com, gengdongjiu@huawei.com,
        mtosatti@redhat.com, rth@twiddle.net, ehabkost@redhat.com,
        jonathan.cameron@huawei.com, xuwei5@huawei.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        linuxarm@huawei.com, wanghaibin.wang@huawei.com,
        zhengxiang9@huawei.com
Date:   Mon, 4 Nov 2019 04:43:29 -0800 (PST)
X-ZohoMailClient: External
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UGF0Y2hldyBVUkw6IGh0dHBzOi8vcGF0Y2hldy5vcmcvUUVNVS8yMDE5MTEwNDEyMTQ1OC4yOTIw
OC0xLXpoZW5neGlhbmc5QGh1YXdlaS5jb20vCgoKCkhpLAoKVGhpcyBzZXJpZXMgZmFpbGVkIHRo
ZSBkb2NrZXItcXVpY2tAY2VudG9zNyBidWlsZCB0ZXN0LiBQbGVhc2UgZmluZCB0aGUgdGVzdGlu
ZyBjb21tYW5kcyBhbmQKdGhlaXIgb3V0cHV0IGJlbG93LiBJZiB5b3UgaGF2ZSBEb2NrZXIgaW5z
dGFsbGVkLCB5b3UgY2FuIHByb2JhYmx5IHJlcHJvZHVjZSBpdApsb2NhbGx5LgoKPT09IFRFU1Qg
U0NSSVBUIEJFR0lOID09PQojIS9iaW4vYmFzaAptYWtlIGRvY2tlci1pbWFnZS1jZW50b3M3IFY9
MSBORVRXT1JLPTEKdGltZSBtYWtlIGRvY2tlci10ZXN0LXF1aWNrQGNlbnRvczcgU0hPV19FTlY9
MSBKPTE0IE5FVFdPUks9MQo9PT0gVEVTVCBTQ1JJUFQgRU5EID09PQoKICBURVNUICAgIGNoZWNr
LXVuaXQ6IHRlc3RzL3Rlc3QtdGhyb3R0bGUKICBURVNUICAgIGNoZWNrLXVuaXQ6IHRlc3RzL3Rl
c3QtdGhyZWFkLXBvb2wKKioKRVJST1I6L3RtcC9xZW11LXRlc3Qvc3JjL3Rlc3RzL21pZ3JhdGlv
bi10ZXN0LmM6OTAzOndhaXRfZm9yX21pZ3JhdGlvbl9mYWlsOiBhc3NlcnRpb24gZmFpbGVkOiAo
IXN0cmNtcChzdGF0dXMsICJzZXR1cCIpIHx8ICFzdHJjbXAoc3RhdHVzLCAiZmFpbGVkIikgfHwg
KGFsbG93X2FjdGl2ZSAmJiAhc3RyY21wKHN0YXR1cywgImFjdGl2ZSIpKSkKRVJST1IgLSBCYWls
IG91dCEgRVJST1I6L3RtcC9xZW11LXRlc3Qvc3JjL3Rlc3RzL21pZ3JhdGlvbi10ZXN0LmM6OTAz
OndhaXRfZm9yX21pZ3JhdGlvbl9mYWlsOiBhc3NlcnRpb24gZmFpbGVkOiAoIXN0cmNtcChzdGF0
dXMsICJzZXR1cCIpIHx8ICFzdHJjbXAoc3RhdHVzLCAiZmFpbGVkIikgfHwgKGFsbG93X2FjdGl2
ZSAmJiAhc3RyY21wKHN0YXR1cywgImFjdGl2ZSIpKSkKbWFrZTogKioqIFtjaGVjay1xdGVzdC1h
YXJjaDY0XSBFcnJvciAxCm1ha2U6ICoqKiBXYWl0aW5nIGZvciB1bmZpbmlzaGVkIGpvYnMuLi4u
CiAgVEVTVCAgICBjaGVjay11bml0OiB0ZXN0cy90ZXN0LWhiaXRtYXAKICBURVNUICAgIGlvdGVz
dC1xY293MjogMDEzCi0tLQogICAgcmFpc2UgQ2FsbGVkUHJvY2Vzc0Vycm9yKHJldGNvZGUsIGNt
ZCkKc3VicHJvY2Vzcy5DYWxsZWRQcm9jZXNzRXJyb3I6IENvbW1hbmQgJ1snc3VkbycsICctbics
ICdkb2NrZXInLCAncnVuJywgJy0tbGFiZWwnLCAnY29tLnFlbXUuaW5zdGFuY2UudXVpZD0yNjA3
YWIzYWExOGY0ZTY1OGUyMWVjMjQ4ZGQ4MGMwYycsICctdScsICcxMDAxJywgJy0tc2VjdXJpdHkt
b3B0JywgJ3NlY2NvbXA9dW5jb25maW5lZCcsICctLXJtJywgJy1lJywgJ1RBUkdFVF9MSVNUPScs
ICctZScsICdFWFRSQV9DT05GSUdVUkVfT1BUUz0nLCAnLWUnLCAnVj0nLCAnLWUnLCAnSj0xNCcs
ICctZScsICdERUJVRz0nLCAnLWUnLCAnU0hPV19FTlY9MScsICctZScsICdDQ0FDSEVfRElSPS92
YXIvdG1wL2NjYWNoZScsICctdicsICcvaG9tZS9wYXRjaGV3Ly5jYWNoZS9xZW11LWRvY2tlci1j
Y2FjaGU6L3Zhci90bXAvY2NhY2hlOnonLCAnLXYnLCAnL3Zhci90bXAvcGF0Y2hldy10ZXN0ZXIt
dG1wLWd6MnQ4eTZtL3NyYy9kb2NrZXItc3JjLjIwMTktMTEtMDQtMDcuMzIuMjAuOTU3NTovdmFy
L3RtcC9xZW11Onoscm8nLCAncWVtdTpjZW50b3M3JywgJy92YXIvdG1wL3FlbXUvcnVuJywgJ3Rl
c3QtcXVpY2snXScgcmV0dXJuZWQgbm9uLXplcm8gZXhpdCBzdGF0dXMgMi4KZmlsdGVyPS0tZmls
dGVyPWxhYmVsPWNvbS5xZW11Lmluc3RhbmNlLnV1aWQ9MjYwN2FiM2FhMThmNGU2NThlMjFlYzI0
OGRkODBjMGMKbWFrZVsxXTogKioqIFtkb2NrZXItcnVuXSBFcnJvciAxCm1ha2VbMV06IExlYXZp
bmcgZGlyZWN0b3J5IGAvdmFyL3RtcC9wYXRjaGV3LXRlc3Rlci10bXAtZ3oydDh5Nm0vc3JjJwpt
YWtlOiAqKiogW2RvY2tlci1ydW4tdGVzdC1xdWlja0BjZW50b3M3XSBFcnJvciAyCgpyZWFsICAg
IDExbTQuNjkzcwp1c2VyICAgIDBtOC45MTRzCgoKVGhlIGZ1bGwgbG9nIGlzIGF2YWlsYWJsZSBh
dApodHRwOi8vcGF0Y2hldy5vcmcvbG9ncy8yMDE5MTEwNDEyMTQ1OC4yOTIwOC0xLXpoZW5neGlh
bmc5QGh1YXdlaS5jb20vdGVzdGluZy5kb2NrZXItcXVpY2tAY2VudG9zNy8/dHlwZT1tZXNzYWdl
LgotLS0KRW1haWwgZ2VuZXJhdGVkIGF1dG9tYXRpY2FsbHkgYnkgUGF0Y2hldyBbaHR0cHM6Ly9w
YXRjaGV3Lm9yZy9dLgpQbGVhc2Ugc2VuZCB5b3VyIGZlZWRiYWNrIHRvIHBhdGNoZXctZGV2ZWxA
cmVkaGF0LmNvbQ==


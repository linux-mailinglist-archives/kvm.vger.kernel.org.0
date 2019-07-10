Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0625764350
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 10:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbfGJIGg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 04:06:36 -0400
Received: from sender4-of-o55.zoho.com ([136.143.188.55]:21569 "EHLO
        sender4-of-o55.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbfGJIGg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 04:06:36 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jul 2019 04:06:35 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1562745989; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=YeTZIQuqmjKsZEQBy6IqEc63FBUhJ3M8ApJVsS40M2+3h13fK1OxqwIDFMT9mAABPf2rUqsyzJA3mFYiuBFFvXQ6apMFFFQdc/WXDYwzE20ovsnQPLxx3xYbskgfEj8GkZiED+0glg/iFjbk00w6Zup2QA/vDf8evh5ayVBO44s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1562745989; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:Subject:To:ARC-Authentication-Results; 
        bh=2o3NbJBqyZXDiXzEVTVyfYsBLx2fIPEjwBbFcyGFK5Q=; 
        b=b+9FQAgYAuL9W9l0a6AVC06QIA6dTn5+a4ykqh8BxW411Lcc1KxyO0zv6AW1OOlecREdUggG1GeIXyDHGPUj/Sh0MhPoGuyQ1Lh2uPBSAblgdTBAzUxhidgeIsnOlVX7RrkNUXL5a9kPacp/t+JgYst4Y8xvrOJE7xEzdWJtvXg=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=patchew.org;
        spf=pass  smtp.mailfrom=no-reply@patchew.org;
        dmarc=pass header.from=<no-reply@patchew.org> header.from=<no-reply@patchew.org>
Received: from [172.17.0.3] (23.253.156.214 [23.253.156.214]) by mx.zohomail.com
        with SMTPS id 1562745988520894.8566524668529; Wed, 10 Jul 2019 01:06:28 -0700 (PDT)
Message-ID: <156274598730.3735.39776049536903184@c4a48874b076>
Subject: Re: [Qemu-devel] [PATCH] target-i386: adds PV_SCHED_YIELD CPUID feature bit
In-Reply-To: <1562745044-7838-1-git-send-email-wanpengli@tencent.com>
Reply-To: <qemu-devel@nongnu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
From:   no-reply@patchew.org
To:     kernellwp@gmail.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        ehabkost@redhat.com, rkrcmar@redhat.com
Date:   Wed, 10 Jul 2019 01:06:28 -0700 (PDT)
X-ZohoMailClient: External
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UGF0Y2hldyBVUkw6IGh0dHBzOi8vcGF0Y2hldy5vcmcvUUVNVS8xNTYyNzQ1MDQ0LTc4MzgtMS1n
aXQtc2VuZC1lbWFpbC13YW5wZW5nbGlAdGVuY2VudC5jb20vCgoKCkhpLAoKVGhpcyBzZXJpZXMg
ZmFpbGVkIGJ1aWxkIHRlc3Qgb24gczM5MHggaG9zdC4gUGxlYXNlIGZpbmQgdGhlIGRldGFpbHMg
YmVsb3cuCgo9PT0gVEVTVCBTQ1JJUFQgQkVHSU4gPT09CiMhL2Jpbi9iYXNoCiMgVGVzdGluZyBz
Y3JpcHQgd2lsbCBiZSBpbnZva2VkIHVuZGVyIHRoZSBnaXQgY2hlY2tvdXQgd2l0aAojIEhFQUQg
cG9pbnRpbmcgdG8gYSBjb21taXQgdGhhdCBoYXMgdGhlIHBhdGNoZXMgYXBwbGllZCBvbiB0b3Ag
b2YgImJhc2UiCiMgYnJhbmNoCnNldCAtZQoKZWNobwplY2hvICI9PT0gRU5WID09PSIKZW52Cgpl
Y2hvCmVjaG8gIj09PSBQQUNLQUdFUyA9PT0iCnJwbSAtcWEKCmVjaG8KZWNobyAiPT09IFVOQU1F
ID09PSIKdW5hbWUgLWEKCkNDPSRIT01FL2Jpbi9jYwpJTlNUQUxMPSRQV0QvaW5zdGFsbApCVUlM
RD0kUFdEL2J1aWxkCm1rZGlyIC1wICRCVUlMRCAkSU5TVEFMTApTUkM9JFBXRApjZCAkQlVJTEQK
JFNSQy9jb25maWd1cmUgLS1jYz0kQ0MgLS1wcmVmaXg9JElOU1RBTEwKbWFrZSAtajQKIyBYWFg6
IHdlIG5lZWQgcmVsaWFibGUgY2xlYW4gdXAKIyBtYWtlIGNoZWNrIC1qNCBWPTEKbWFrZSBpbnN0
YWxsCj09PSBURVNUIFNDUklQVCBFTkQgPT09CgogIENDICAgICAgYXJtLXNvZnRtbXUvcWFwaS9x
YXBpLXZpc2l0LW1pc2MtdGFyZ2V0Lm8KICBDQyAgICAgIGkzODYtc29mdG1tdS90YXJnZXQvaTM4
Ni9jcHUubwogIENDICAgICAgYXJtLXNvZnRtbXUvcWFwaS9xYXBpLXZpc2l0Lm8KL3Zhci90bXAv
cGF0Y2hldy10ZXN0ZXItdG1wLXJfOGxwdWRxL3NyYy90YXJnZXQvaTM4Ni9jcHUuYzo5MDk6MTk6
IGVycm9yOiBtaXNzaW5nIHRlcm1pbmF0aW5nICIgY2hhcmFjdGVyIFstV2Vycm9yXQogIDkwOSB8
ICAgICAgICAgICAgIE5VTEwsICJrdm0tcHYtc2NoZWQteWllbGQnLCBOVUxMLCBOVUxMLAogICAg
ICB8ICAgICAgICAgICAgICAgICAgIF4KL3Zhci90bXAvcGF0Y2hldy10ZXN0ZXItdG1wLXJfOGxw
dWRxL3NyYy90YXJnZXQvaTM4Ni9jcHUuYzo5MDk6MTk6IGVycm9yOiBtaXNzaW5nIHRlcm1pbmF0
aW5nICIgY2hhcmFjdGVyCiAgOTA5IHwgICAgICAgICAgICAgTlVMTCwgImt2bS1wdi1zY2hlZC15
aWVsZCcsIE5VTEwsIE5VTEwsCiAgICAgIHwgICAgICAgICAgICAgICAgICAgXn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+CmNjMTogYWxsIHdhcm5pbmdzIGJlaW5nIHRyZWF0ZWQgYXMg
ZXJyb3JzCgoKVGhlIGZ1bGwgbG9nIGlzIGF2YWlsYWJsZSBhdApodHRwOi8vcGF0Y2hldy5vcmcv
bG9ncy8xNTYyNzQ1MDQ0LTc4MzgtMS1naXQtc2VuZC1lbWFpbC13YW5wZW5nbGlAdGVuY2VudC5j
b20vdGVzdGluZy5zMzkweC8/dHlwZT1tZXNzYWdlLgotLS0KRW1haWwgZ2VuZXJhdGVkIGF1dG9t
YXRpY2FsbHkgYnkgUGF0Y2hldyBbaHR0cHM6Ly9wYXRjaGV3Lm9yZy9dLgpQbGVhc2Ugc2VuZCB5
b3VyIGZlZWRiYWNrIHRvIHBhdGNoZXctZGV2ZWxAcmVkaGF0LmNvbQ==


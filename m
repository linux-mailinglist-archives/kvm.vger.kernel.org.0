Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3B9EF257B
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 03:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732790AbfKGCgO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 21:36:14 -0500
Received: from m17618.mail.qiye.163.com ([59.111.176.18]:51571 "EHLO
        m17618.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbfKGCgO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 21:36:14 -0500
X-Greylist: delayed 549 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Nov 2019 21:36:12 EST
Received: from P80254710 (unknown [121.12.147.249])
        by m17618.mail.qiye.163.com (Hmail) with ESMTPA id 90E004E17EE;
        Thu,  7 Nov 2019 10:27:01 +0800 (CST)
Date:   Thu, 7 Nov 2019 10:27:06 +0800
From:   "Peng Hao" <richard.peng@oppo.com>
To:     pbonzini <pbonzini@redhat.com>, rkrcmar <rkrcmar@redhat.com>
Cc:     kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] kvm/x86 : Replace BUG_ON(1) with BUG()
X-Priority: 3
X-GUID: 608D3069-12C2-46ED-919C-21192C18CDB7
X-Has-Attach: no
X-Mailer: Foxmail 7.2.10.151[en]
Mime-Version: 1.0
Message-ID: <201911071027048908705@oppo.com>
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: base64
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVk9VTE5OS0tKTk9PQk5JSEJZV1koWU
        FJSUtLSjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mwg6ITo6CDg6DBgMSlYYLy9M
        SjZPCTJVSlVKTkxIS0JITUlJSU5KVTMWGhIXVQkSGBMaCR9VCx4VHDsUCwsUVRgUFkVZV1kSC1lB
        WUpJSlVKSVVKT0xVSU9CWVdZCAFZQUpOQ0M3Bg++
X-HM-Tid: 0a6e43afc0f59376kuws90e004e17ee
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

U2lnbmVkLW9mZi1ieTogUGVuZyBIYW8gPHJpY2hhcmQucGVuZ0BvcHBvLmNvbT4KLS0tCsKgYXJj
aC94ODYva3ZtL3ZteC9uZXN0ZWQuYyB8IDMgKy0tCsKgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0
aW9uKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvbmVz
dGVkLmMgYi9hcmNoL3g4Ni9rdm0vdm14L25lc3RlZC5jCmluZGV4IGU3NmViNGYuLmQwZTZjNDAg
MTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2t2bS92bXgvbmVzdGVkLmMKKysrIGIvYXJjaC94ODYva3Zt
L3ZteC9uZXN0ZWQuYwpAQCAtNDk0NSw4ICs0OTQ1LDcgQEAgc3RhdGljIGludCBoYW5kbGVfaW52
ZXB0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKwqAJICovCsKgCQlicmVhazsKwqAJZGVmYXVsdDoK
LQkJQlVHX09OKDEpOwotCQlicmVhazsKKwkJQlVHKCk7CsKgCX0KwqAKwqAJcmV0dXJuIG5lc3Rl
ZF92bXhfc3VjY2VlZCh2Y3B1KTsKLS3CoAoyLjcuNA==


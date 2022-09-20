Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C23B5BDBF3
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 07:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiITFBV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 01:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiITFBT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 01:01:19 -0400
X-Greylist: delayed 532 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 19 Sep 2022 22:01:06 PDT
Received: from mail11.tencent.com (mail11.tencent.com [14.18.178.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AFD7474D9
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 22:01:06 -0700 (PDT)
Received: from EX-SZ018.tencent.com (unknown [10.28.6.39])
        by mail11.tencent.com (Postfix) with ESMTP id 98006FC44F;
        Tue, 20 Sep 2022 12:52:12 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tencent.com;
        s=s202002; t=1663649532;
        bh=2OClKsb90VLaQQJWEV0lCTO4uHlQIyojnjmw8/U+sNA=;
        h=From:To:CC:Subject:Date;
        b=LSovyd1oikiT+ai+AMX10tzYxE7suuM9659Z7d5pXQMHm6K02XsMjjECArzrrOAyf
         spu3UHBTTwrGl3C2Euu+NZL2Gnl7Se1PAVDwnzeMrfwNAsi5mhvECYm0TKh1/TnzEp
         z1zhaQ0iu+qZLHrB28vK94r9nbrRaV6GfR56L2uQ=
Received: from EX-SZ047.tencent.com (10.28.6.98) by EX-SZ018.tencent.com
 (10.28.6.39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 20 Sep
 2022 12:52:12 +0800
Received: from EX-SZ049.tencent.com (10.28.6.102) by EX-SZ047.tencent.com
 (10.28.6.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 20 Sep
 2022 12:52:12 +0800
Received: from EX-SZ049.tencent.com ([fe80::e0be:89c3:ec1:bef7]) by
 EX-SZ049.tencent.com ([fe80::e0be:89c3:ec1:bef7%8]) with mapi id
 15.01.2242.008; Tue, 20 Sep 2022 12:52:12 +0800
From:   =?utf-8?B?Zmx5aW5ncGVuZyjlva3mtakp?= <flyingpeng@tencent.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [PATCH]  kvm: vmx: keep constant definition format consistent
Thread-Topic: [PATCH]  kvm: vmx: keep constant definition format consistent
Thread-Index: AQHYzKy/4bgPQpiWUEi+Xs9L9bP2sQ==
Date:   Tue, 20 Sep 2022 04:52:12 +0000
Message-ID: <E2C645A3-8160-41A7-A8D3-F605946DFEF2@tencent.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.99.48.13]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E52298581F800148BDF7A736E21DCD8B@tencent.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_PASS,T_SPF_HELO_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

S2VlcCBhbGwgY29uc3RhbnRzIHVzaW5nIGxvd2VyY2FzZSAieCIuDQoNClNpZ25lZC1vZmYtYnk6
IFBlbmcgSGFvIDxmbHlpbmdwZW5nQHRlbmNlbnQuY29tPg0KLS0tDQogYXJjaC94ODYvaW5jbHVk
ZS9hc20vdm14LmggfCAyICstDQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRl
bGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS92bXguaCBiL2Fy
Y2gveDg2L2luY2x1ZGUvYXNtL3ZteC5oDQppbmRleCAwZmZhYTMxNTZhNGUuLmQxNzkxYjYxMjE3
MCAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3ZteC5oDQorKysgYi9hcmNoL3g4
Ni9pbmNsdWRlL2FzbS92bXguaA0KQEAgLTI5Niw3ICsyOTYsNyBAQCBlbnVtIHZtY3NfZmllbGQg
ew0KICAgICAgICBHVUVTVF9MRFRSX0FSX0JZVEVTICAgICAgICAgICAgID0gMHgwMDAwNDgyMCwN
CiAgICAgICAgR1VFU1RfVFJfQVJfQllURVMgICAgICAgICAgICAgICA9IDB4MDAwMDQ4MjIsDQog
ICAgICAgIEdVRVNUX0lOVEVSUlVQVElCSUxJVFlfSU5GTyAgICAgPSAweDAwMDA0ODI0LA0KLSAg
ICAgICBHVUVTVF9BQ1RJVklUWV9TVEFURSAgICAgICAgICAgID0gMFgwMDAwNDgyNiwNCisgICAg
ICAgR1VFU1RfQUNUSVZJVFlfU1RBVEUgICAgICAgICAgICA9IDB4MDAwMDQ4MjYsDQogICAgICAg
IEdVRVNUX1NZU0VOVEVSX0NTICAgICAgICAgICAgICAgPSAweDAwMDA0ODJBLA0KICAgICAgICBW
TVhfUFJFRU1QVElPTl9USU1FUl9WQUxVRSAgICAgID0gMHgwMDAwNDgyRSwNCiAgICAgICAgSE9T
VF9JQTMyX1NZU0VOVEVSX0NTICAgICAgICAgICA9IDB4MDAwMDRjMDAsDQotLQ0KMi4yNy4wDQoN
Cg==

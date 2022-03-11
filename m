Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605AE4D5735
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 02:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245569AbiCKBNo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 20:13:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbiCKBNn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 20:13:43 -0500
Received: from baidu.com (mx24.baidu.com [111.206.215.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 493982C123
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 17:12:38 -0800 (PST)
Received: from BC-Mail-Ex15.internal.baidu.com (unknown [172.31.51.55])
        by Forcepoint Email with ESMTPS id 87F44E18D9C7DD0F7DF4;
        Fri, 11 Mar 2022 09:12:29 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BC-Mail-Ex15.internal.baidu.com (172.31.51.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Fri, 11 Mar 2022 09:12:29 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.020; Fri, 11 Mar 2022 09:12:29 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Nathan Chancellor <nathan@kernel.org>,
        kernel test robot <lkp@intel.com>
CC:     "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        "Danmei Wei" <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: =?gb2312?B?tPC4tDogW2t2bTpxdWV1ZSAxODIvMjA1XSA8aW5saW5lIGFzbT46NDA6MjA4?=
 =?gb2312?Q?:_error:_expected_relocatable_expression?=
Thread-Topic: [kvm:queue 182/205] <inline asm>:40:208: error: expected
 relocatable expression
Thread-Index: AQHYNB5PBIObN5SLb0WBGJKx313uRKy4gA+AgADgzhA=
Date:   Fri, 11 Mar 2022 01:12:29 +0000
Message-ID: <a9c62b83c3a342b88eb7600694cdfbf6@baidu.com>
References: <202203100905.1o88Cp2l-lkp@intel.com>
 <YipVB6MiWdjY3HI3@dev-arch.thelio-3990X>
In-Reply-To: <YipVB6MiWdjY3HI3@dev-arch.thelio-3990X>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.206.33]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiANCj4gSXQgbG9va3MgbGlrZSB0aGVyZSBpcyBhIG5ldyByZXZpc2lvbiBvZiB0aGUgcGF0Y2gg
dGhhdCBzaG91bGQgcmVzb2x2ZSB0aGlzLg0KPiANCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
ci8xNjQ2ODkxNjg5LTUzMzY4LTEtZ2l0LXNlbmQtZW1haWwtbGlyb25ncWluZ0BiYWlkdQ0KPiAu
Y29tLw0KPiANCj4gSXQgaGFwcGVucyB3aXRoIEdDQyAvIEdOVSBhcyB0b28uDQo+IA0KPiAvdG1w
L2NjNmdyaEt2LnM6IEFzc2VtYmxlciBtZXNzYWdlczoNCj4gL3RtcC9jYzZncmhLdi5zOjUyOiBF
cnJvcjogaW52YWxpZCBvcGVyYW5kcyAoKlVORCogYW5kIC5kYXRhIHNlY3Rpb25zKSBmb3IgYCsn
DQo+IA0KDQpJIGFtIHNvcnJ5IGFib3V0IHRoaXMsIEkgc2VuZCBhIG5ldyB2ZXJzaW9uLCBpdCBz
aG91bGQgYmUgZml4ZWQNCg0KVGhhbmtzDQoNCi1MaXJvbmdxaW5nDQoNCj4gQ2hlZXJzLA0KPiBO
YXRoYW4NCg==

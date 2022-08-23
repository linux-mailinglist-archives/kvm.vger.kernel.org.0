Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C64E59E46D
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 15:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239380AbiHWNJQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 09:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238887AbiHWNIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 09:08:51 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B45133658
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 03:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661249437; x=1692785437;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IhNKUXft9Tt78OglgBg/VJGQG3xCcASGU2IW/K8VyOw=;
  b=Idfe/6eUN9X6mu1HHZs8YYztNjGMMZWZjEREJTd0NVY6RJVMbdFpOZoJ
   IX5ciqQMnY+RW7chEUiRMJXVzBuBjpBgph+5yZ9CPD/OTCRMUxr3bZMVD
   5v9hFyZVhVnVOv7M2V5CbtFCuSvIHEiF4P32MpTZ69qU/ygPpMVI4n+WK
   riF8cax3sOV6l9Nm9D1HUPK3bNwKa/pPiEaLF6dbCX/78qRMjluITAlA0
   TSgIgnSmS4xO4e+jIecp5eD4TPOWS1CLkARzUGPRooAIHHRBa2toK1zUC
   G5LFeT9+p/7bLqSM8UhH99GuOXm9n5spdPaPLUrAQ6p7JH+BhJKaL6ARq
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="280619195"
X-IronPort-AV: E=Sophos;i="5.93,257,1654585200"; 
   d="scan'208";a="280619195"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 03:09:18 -0700
X-IronPort-AV: E=Sophos;i="5.93,257,1654585200"; 
   d="scan'208";a="638593407"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.238.0.207]) ([10.238.0.207])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 03:09:16 -0700
Message-ID: <d98ebb6a-26e5-a9ae-a725-21539c391ac5@intel.com>
Date:   Tue, 23 Aug 2022 18:09:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [PATCH v5 1/3] Update linux headers to 6.0-rc1
Content-Language: en-US
To:     =?UTF-8?B?TWljaGFsIFByw612b3puw61r?= <mprivozn@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220817020845.21855-1-chenyi.qiang@intel.com>
 <20220817020845.21855-2-chenyi.qiang@intel.com>
 <f3bc61c8-d491-f79c-15d7-191208c57224@redhat.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <f3bc61c8-d491-f79c-15d7-191208c57224@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDgvMjIvMjAyMiAxMTowMCBQTSwgTWljaGFsIFByw612b3puw61rIHdyb3RlOg0K
PiBPbiA4LzE3LzIyIDA0OjA4LCBDaGVueWkgUWlhbmcgd3JvdGU6DQo+PiBjb21taXQgNTY4
MDM1YjAxY2ZiMTA3YWY4ZDJlNGJkMmZiOWFlYTIyY2Y1Yjg2OA0KPj4NCj4+IFNpZ25lZC1v
ZmYtYnk6IENoZW55aSBRaWFuZyA8Y2hlbnlpLnFpYW5nQGludGVsLmNvbT4NCj4+IC0tLQ0K
Pj4gICBpbmNsdWRlL3N0YW5kYXJkLWhlYWRlcnMvYXNtLXg4Ni9ib290cGFyYW0uaCAgfCAg
IDcgKy0NCj4+ICAgaW5jbHVkZS9zdGFuZGFyZC1oZWFkZXJzL2RybS9kcm1fZm91cmNjLmgg
ICAgIHwgIDczICsrKysrKystDQo+PiAgIGluY2x1ZGUvc3RhbmRhcmQtaGVhZGVycy9saW51
eC9ldGh0b29sLmggICAgICB8ICAyOSArLS0NCj4+ICAgaW5jbHVkZS9zdGFuZGFyZC1oZWFk
ZXJzL2xpbnV4L2lucHV0LmggICAgICAgIHwgIDEyICstDQo+PiAgIGluY2x1ZGUvc3RhbmRh
cmQtaGVhZGVycy9saW51eC9wY2lfcmVncy5oICAgICB8ICAzMCArKy0NCj4+ICAgaW5jbHVk
ZS9zdGFuZGFyZC1oZWFkZXJzL2xpbnV4L3Zob3N0X3R5cGVzLmggIHwgIDE3ICstDQo+PiAg
IGluY2x1ZGUvc3RhbmRhcmQtaGVhZGVycy9saW51eC92aXJ0aW9fOXAuaCAgICB8ICAgMiAr
LQ0KPj4gICAuLi4vc3RhbmRhcmQtaGVhZGVycy9saW51eC92aXJ0aW9fY29uZmlnLmggICAg
fCAgIDcgKy0NCj4+ICAgaW5jbHVkZS9zdGFuZGFyZC1oZWFkZXJzL2xpbnV4L3ZpcnRpb19p
ZHMuaCAgIHwgIDE0ICstDQo+PiAgIGluY2x1ZGUvc3RhbmRhcmQtaGVhZGVycy9saW51eC92
aXJ0aW9fbmV0LmggICB8ICAzNCArKystDQo+PiAgIGluY2x1ZGUvc3RhbmRhcmQtaGVhZGVy
cy9saW51eC92aXJ0aW9fcGNpLmggICB8ICAgMiArDQo+PiAgIGxpbnV4LWhlYWRlcnMvYXNt
LWFybTY0L2t2bS5oICAgICAgICAgICAgICAgICB8ICAyNyArKysNCj4+ICAgbGludXgtaGVh
ZGVycy9hc20tZ2VuZXJpYy91bmlzdGQuaCAgICAgICAgICAgIHwgICA0ICstDQo+PiAgIGxp
bnV4LWhlYWRlcnMvYXNtLXJpc2N2L2t2bS5oICAgICAgICAgICAgICAgICB8ICAyMiArKysN
Cj4+ICAgbGludXgtaGVhZGVycy9hc20tcmlzY3YvdW5pc3RkLmggICAgICAgICAgICAgIHwg
ICAzICstDQo+PiAgIGxpbnV4LWhlYWRlcnMvYXNtLXMzOTAva3ZtLmggICAgICAgICAgICAg
ICAgICB8ICAgMSArDQo+PiAgIGxpbnV4LWhlYWRlcnMvYXNtLXg4Ni9rdm0uaCAgICAgICAg
ICAgICAgICAgICB8ICAzMyArKy0tDQo+PiAgIGxpbnV4LWhlYWRlcnMvYXNtLXg4Ni9tbWFu
LmggICAgICAgICAgICAgICAgICB8ICAxNCAtLQ0KPj4gICBsaW51eC1oZWFkZXJzL2xpbnV4
L2t2bS5oICAgICAgICAgICAgICAgICAgICAgfCAxNzIgKysrKysrKysrKysrKysrKystDQo+
PiAgIGxpbnV4LWhlYWRlcnMvbGludXgvdXNlcmZhdWx0ZmQuaCAgICAgICAgICAgICB8ICAx
MCArLQ0KPj4gICBsaW51eC1oZWFkZXJzL2xpbnV4L3ZkdXNlLmggICAgICAgICAgICAgICAg
ICAgfCAgNDcgKysrKysNCj4+ICAgbGludXgtaGVhZGVycy9saW51eC92ZmlvLmggICAgICAg
ICAgICAgICAgICAgIHwgICA0ICstDQo+PiAgIGxpbnV4LWhlYWRlcnMvbGludXgvdmZpb196
ZGV2LmggICAgICAgICAgICAgICB8ICAgNyArDQo+PiAgIGxpbnV4LWhlYWRlcnMvbGludXgv
dmhvc3QuaCAgICAgICAgICAgICAgICAgICB8ICAzNSArKystDQo+PiAgIDI0IGZpbGVzIGNo
YW5nZWQsIDUyMyBpbnNlcnRpb25zKCspLCA4MyBkZWxldGlvbnMoLSkNCj4+DQo+IA0KPiAN
Cj4+IGRpZmYgLS1naXQgYS9saW51eC1oZWFkZXJzL2FzbS14ODYva3ZtLmggYi9saW51eC1o
ZWFkZXJzL2FzbS14ODYva3ZtLmgNCj4+IGluZGV4IGJmNmU5NjAxMWQuLjQ2ZGUxMGE4MDkg
MTAwNjQ0DQo+PiAtLS0gYS9saW51eC1oZWFkZXJzL2FzbS14ODYva3ZtLmgNCj4+ICsrKyBi
L2xpbnV4LWhlYWRlcnMvYXNtLXg4Ni9rdm0uaA0KPj4gQEAgLTE5OCwxMyArMTk4LDEzIEBA
IHN0cnVjdCBrdm1fbXNycyB7DQo+PiAgIAlfX3UzMiBubXNyczsgLyogbnVtYmVyIG9mIG1z
cnMgaW4gZW50cmllcyAqLw0KPj4gICAJX191MzIgcGFkOw0KPj4gICANCj4+IC0Jc3RydWN0
IGt2bV9tc3JfZW50cnkgZW50cmllc1swXTsNCj4+ICsJc3RydWN0IGt2bV9tc3JfZW50cnkg
ZW50cmllc1tdOw0KPj4gICB9Ow0KPj4gICANCj4gDQo+IEkgZG9uJ3QgdGhpbmsgaXQncyB0
aGlzIHNpbXBsZS4gSSB0aGluayB0aGlzIG5lZWRzIHRvIGdvIGhhbmQgaW4gaGFuZCB3aXRo
IGt2bV9hcmNoX2dldF9zdXBwb3J0ZWRfbXNyX2ZlYXR1cmUoKS4NCj4gDQo+IEFsc28sIHRo
aXMgYnJlYWtzIGNsYW5nIGJ1aWxkOg0KPiANCj4gY2xhbmcgLW02NCAtbWN4MTYgLUlsaWJx
ZW11LXg4Nl82NC1zb2Z0bW11LmZhLnAgLUkuIC1JLi4gLUl0YXJnZXQvaTM4NiAtSS4uL3Rh
cmdldC9pMzg2IC1JcWFwaSAtSXRyYWNlIC1JdWkgLUl1aS9zaGFkZXIgLUkvdXNyL2luY2x1
ZGUvcGl4bWFuLTEgLUkvdXNyL2luY2x1ZGUvc3BpY2Utc2VydmVyIC1JL3Vzci9pbmNsdWRl
L3NwaWNlLTEgLUkvdXNyL2luY2x1ZGUvZ2xpYi0yLjAgLUkvdXNyL2xpYjY0L2dsaWItMi4w
L2luY2x1ZGUgLWZjb2xvci1kaWFnbm9zdGljcyAtV2FsbCAtV2ludmFsaWQtcGNoIC1XZXJy
b3IgLXN0ZD1nbnUxMSAtTzAgLWcgLWlzeXN0ZW0gL2hvbWUvemlwcHkvd29yay9xZW11L3Fl
bXUuZ2l0L2xpbnV4LWhlYWRlcnMgLWlzeXN0ZW0gbGludXgtaGVhZGVycyAtaXF1b3RlIC4g
LWlxdW90ZSAvaG9tZS96aXBweS93b3JrL3FlbXUvcWVtdS5naXQgLWlxdW90ZSAvaG9tZS96
aXBweS93b3JrL3FlbXUvcWVtdS5naXQvaW5jbHVkZSAtaXF1b3RlIC9ob21lL3ppcHB5L3dv
cmsvcWVtdS9xZW11LmdpdC90Y2cvaTM4NiAtcHRocmVhZCAtRF9HTlVfU09VUkNFIC1EX0ZJ
TEVfT0ZGU0VUX0JJVFM9NjQgLURfTEFSR0VGSUxFX1NPVVJDRSAtV3N0cmljdC1wcm90b3R5
cGVzIC1XcmVkdW5kYW50LWRlY2xzIC1XdW5kZWYgLVd3cml0ZS1zdHJpbmdzIC1XbWlzc2lu
Zy1wcm90b3R5cGVzIC1mbm8tc3RyaWN0LWFsaWFzaW5nIC1mbm8tY29tbW9uIC1md3JhcHYg
LVdvbGQtc3R5bGUtZGVmaW5pdGlvbiAtV3R5cGUtbGltaXRzIC1XZm9ybWF0LXNlY3VyaXR5
IC1XZm9ybWF0LXkyayAtV2luaXQtc2VsZiAtV2lnbm9yZWQtcXVhbGlmaWVycyAtV2VtcHR5
LWJvZHkgLVduZXN0ZWQtZXh0ZXJucyAtV2VuZGlmLWxhYmVscyAtV2V4cGFuc2lvbi10by1k
ZWZpbmVkIC1Xbm8taW5pdGlhbGl6ZXItb3ZlcnJpZGVzIC1Xbm8tbWlzc2luZy1pbmNsdWRl
LWRpcnMgLVduby1zaGlmdC1uZWdhdGl2ZS12YWx1ZSAtV25vLXN0cmluZy1wbHVzLWludCAt
V25vLXR5cGVkZWYtcmVkZWZpbml0aW9uIC1Xbm8tdGF1dG9sb2dpY2FsLXR5cGUtbGltaXQt
Y29tcGFyZSAtV25vLXBzYWJpIC1mc3RhY2stcHJvdGVjdG9yLXN0cm9uZyAtTzAgLWdnZGIg
LWZQSUUgLWlzeXN0ZW0uLi9saW51eC1oZWFkZXJzIC1pc3lzdGVtbGludXgtaGVhZGVycyAt
RE5FRURfQ1BVX0ggJy1EQ09ORklHX1RBUkdFVD0ieDg2XzY0LXNvZnRtbXUtY29uZmlnLXRh
cmdldC5oIicgJy1EQ09ORklHX0RFVklDRVM9Ing4Nl82NC1zb2Z0bW11LWNvbmZpZy1kZXZp
Y2VzLmgiJyAtTUQgLU1RIGxpYnFlbXUteDg2XzY0LXNvZnRtbXUuZmEucC90YXJnZXRfaTM4
Nl9rdm1fa3ZtLmMubyAtTUYgbGlicWVtdS14ODZfNjQtc29mdG1tdS5mYS5wL3RhcmdldF9p
Mzg2X2t2bV9rdm0uYy5vLmQgLW8gbGlicWVtdS14ODZfNjQtc29mdG1tdS5mYS5wL3Rhcmdl
dF9pMzg2X2t2bV9rdm0uYy5vIC1jIC4uL3RhcmdldC9pMzg2L2t2bS9rdm0uYw0KPiAuLi90
YXJnZXQvaTM4Ni9rdm0va3ZtLmM6NDcwOjI1OiBlcnJvcjogZmllbGQgJ2luZm8nIHdpdGgg
dmFyaWFibGUgc2l6ZWQgdHlwZSAnc3RydWN0IGt2bV9tc3JzJyBub3QgYXQgdGhlIGVuZCBv
ZiBhIHN0cnVjdCBvciBjbGFzcyBpcyBhIEdOVSBleHRlbnNpb24gWy1XZXJyb3IsLVdnbnUt
dmFyaWFibGUtc2l6ZWQtdHlwZS1ub3QtYXQtZW5kXQ0KPiAgICAgICAgICBzdHJ1Y3Qga3Zt
X21zcnMgaW5mbzsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgIF4NCj4gLi4vdGFyZ2V0
L2kzODYva3ZtL2t2bS5jOjE3MDE6Mjc6IGVycm9yOiBmaWVsZCAnY3B1aWQnIHdpdGggdmFy
aWFibGUgc2l6ZWQgdHlwZSAnc3RydWN0IGt2bV9jcHVpZDInIG5vdCBhdCB0aGUgZW5kIG9m
IGEgc3RydWN0IG9yIGNsYXNzIGlzIGEgR05VIGV4dGVuc2lvbiBbLVdlcnJvciwtV2dudS12
YXJpYWJsZS1zaXplZC10eXBlLW5vdC1hdC1lbmRdDQo+ICAgICAgICAgIHN0cnVjdCBrdm1f
Y3B1aWQyIGNwdWlkOw0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICBeDQo+IC4uL3Rh
cmdldC9pMzg2L2t2bS9rdm0uYzoyODY4OjI1OiBlcnJvcjogZmllbGQgJ2luZm8nIHdpdGgg
dmFyaWFibGUgc2l6ZWQgdHlwZSAnc3RydWN0IGt2bV9tc3JzJyBub3QgYXQgdGhlIGVuZCBv
ZiBhIHN0cnVjdCBvciBjbGFzcyBpcyBhIEdOVSBleHRlbnNpb24gWy1XZXJyb3IsLVdnbnUt
dmFyaWFibGUtc2l6ZWQtdHlwZS1ub3QtYXQtZW5kXQ0KPiAgICAgICAgICBzdHJ1Y3Qga3Zt
X21zcnMgaW5mbzsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgIF4NCj4gMyBlcnJvcnMg
Z2VuZXJhdGVkLg0KPiANCg0KT0ssIEkgb25seSBnZW5lcmF0ZWQgdGhpcyBwYXRjaCB3aXRo
IHVwZGF0ZS1saW51eC1oZWFkZXJzLnNoIGFuZCBidWlsdCANCml0IHdpdGggZ2NjLiBJdCBz
ZWVtcyBjbGFuZyByZXF1aXJlcyBzb21lIG90aGVyIGFkanVzdG1lbnQuIEknbGwgaGF2ZSBh
IA0KY2hlY2suIFRoYW5rcyBmb3IgcG9pbnRpbmcgaXQgb3V0Lg0KDQo+IA0KPiBNaWNoYWwN
Cj4gDQo=

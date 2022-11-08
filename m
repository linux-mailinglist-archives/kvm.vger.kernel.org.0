Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D826621CDC
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 20:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiKHTSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 14:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiKHTS2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 14:18:28 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFF2E0BB;
        Tue,  8 Nov 2022 11:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1667935107; x=1699471107;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6BKb+dUqONSEkaugyzdpmCsjm10RfxghitQMmA9uZM4=;
  b=jXvwMEyj/Wb+wjpT7DK1yvOSpFrb5bGcPcl9eNtklxlW+QB/JT3JR6Z9
   ysJVLDjKArQvuoB+AY1GKyYrH9HYChz48pbCzYyLgWCE2SMARfr/u1hzQ
   Qm1soJWHFii39OGmi9rBJ72rUb5SLjyClwGCMZzYOOM+HTM2nSZfVaE8y
   4=;
X-IronPort-AV: E=Sophos;i="5.96,148,1665446400"; 
   d="scan'208";a="148956021"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-7fa2de02.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 19:18:25 +0000
Received: from EX13D50EUA003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-7fa2de02.us-west-2.amazon.com (Postfix) with ESMTPS id F09624171D;
        Tue,  8 Nov 2022 19:18:23 +0000 (UTC)
Received: from EX19D016EUA004.ant.amazon.com (10.252.50.4) by
 EX13D50EUA003.ant.amazon.com (10.43.165.81) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Tue, 8 Nov 2022 19:18:22 +0000
Received: from [192.168.25.119] (10.43.161.14) by
 EX19D016EUA004.ant.amazon.com (10.252.50.4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.15; Tue, 8 Nov 2022 19:18:17 +0000
Message-ID: <e99fe620-3510-aa1f-ff02-8f3c0c74e812@amazon.com>
Date:   Tue, 8 Nov 2022 21:18:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH v1] MAINTAINERS: Update entries from the Nitro Enclaves
 section
Content-Language: en-US
To:     linux-kernel <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     Alexandru Ciobotaru <alcioa@amazon.com>,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Stefano Garzarella" <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>,
        The AWS Nitro Enclaves Team 
        <aws-nitro-enclaves-devel@amazon.com>
References: <20221108185912.15792-1-andraprs@amazon.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
In-Reply-To: <20221108185912.15792-1-andraprs@amazon.com>
X-Originating-IP: [10.43.161.14]
X-ClientProxiedBy: EX13D42UWB001.ant.amazon.com (10.43.161.35) To
 EX19D016EUA004.ant.amazon.com (10.252.50.4)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwOC4xMS4yMDIyIDIwOjU5LCBBbmRyYSBQYXJhc2NoaXYgd3JvdGU6Cj4gVXBkYXRlIHRo
ZSBsaXN0IG9mIG1haW50YWluZXJzIGZvciB0aGUgTml0cm8gRW5jbGF2ZXMgcHJvamVjdC4gQWxl
eAo+IChsZXhudkApIGlzIG5vdCB3b3JraW5nIGF0IEFtYXpvbiBhbnltb3JlIGFuZCB0aGVyZSB3
aWxsIGJlIHRoZSBzYW1lCj4gY2FzZSBmb3IgbWUgc3RhcnRpbmcgd2l0aCAyMDIzLgo+IAo+IEFk
ZCBhIHJlZmVyZW5jZSB0byB0aGUgbWFpbGluZyBsaXN0IG9mIHRoZSBOaXRybyBFbmNsYXZlcyBk
ZXZlbG9wbWVudAo+IHRlYW0uCj4gCj4gU2lnbmVkLW9mZi1ieTogQW5kcmEgUGFyYXNjaGl2IDxh
bmRyYXByc0BhbWF6b24uY29tPgo+IC0tLQo+ICAgTUFJTlRBSU5FUlMgfCAzICstLQo+ICAgMSBm
aWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAyIGRlbGV0aW9ucygtKQoKR3JlZywgcGxlYXNl
IGxldCBtZSBrbm93IGlmIHRoZXJlIGFyZSBhbnkgdXBkYXRlcyBuZWVkZWQgZm9yIHRoZSBwYXRj
aC4gCk90aGVyd2lzZSwgcGxlYXNlIGluY2x1ZGUgdGhlIHBhdGNoIGluIHRoZSBjaGFyLW1pc2Mg
dHJlZS4KClRoYW5rIHlvdSB2ZXJ5IG11Y2ggdG8gYWxsIHRoZSBwZW9wbGUgd2hvIGhhdmUgaGVs
cGVkIHdpdGggZGVzaWduIApkaXNjdXNzaW9ucywgaW1wbGVtZW50YXRpb24gYW5kIHRlc3Rpbmcs
IGNvZGUgcmV2aWV3cywgaXNzdWVzIGZpeGluZywgCmRpc3Ryb3MgaW50ZWdyYXRpb24gYW5kIG92
ZXJhbGwgbWFpbnRlbmFuY2UgZHVyaW5nIHRoZSBwYXN0IHllYXJzLiBUaGlzIApoYXMgYmVlbiBh
IHVzZWZ1bCBleHBlcmllbmNlIGFuZCBJJ2xsIGtlZXAgdXAgaW1wcm92aW5nLgoKQW5kcmEKCj4g
Cj4gZGlmZiAtLWdpdCBhL01BSU5UQUlORVJTIGIvTUFJTlRBSU5FUlMKPiBpbmRleCAwNDZmZjA2
ZmY5N2YuLmFmMmMxNzhiYTBkYyAxMDA2NDQKPiAtLS0gYS9NQUlOVEFJTkVSUwo+ICsrKyBiL01B
SU5UQUlORVJTCj4gQEAgLTE0NTY0LDEwICsxNDU2NCw5IEBAIFQ6CWdpdCBnaXQ6Ly9naXQua2Vy
bmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZGluZ3V5ZW4vbGludXguZ2l0Cj4gICBG
OglhcmNoL25pb3MyLwo+ICAgCj4gICBOSVRSTyBFTkNMQVZFUyAoTkUpCj4gLU06CUFuZHJhIFBh
cmFzY2hpdiA8YW5kcmFwcnNAYW1hem9uLmNvbT4KPiAtTToJQWxleGFuZHJ1IFZhc2lsZSA8bGV4
bnZAYW1hem9uLmNvbT4KPiAgIE06CUFsZXhhbmRydSBDaW9ib3RhcnUgPGFsY2lvYUBhbWF6b24u
Y29tPgo+ICAgTDoJbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZwo+ICtMOglUaGUgQVdTIE5p
dHJvIEVuY2xhdmVzIFRlYW0gPGF3cy1uaXRyby1lbmNsYXZlcy1kZXZlbEBhbWF6b24uY29tPgo+
ICAgUzoJU3VwcG9ydGVkCj4gICBXOglodHRwczovL2F3cy5hbWF6b24uY29tL2VjMi9uaXRyby9u
aXRyby1lbmNsYXZlcy8KPiAgIEY6CURvY3VtZW50YXRpb24vdmlydC9uZV9vdmVydmlldy5yc3QK
CgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkgUy5SLkwuIHJlZ2lzdGVyZWQg
b2ZmaWNlOiAyN0EgU2YuIExhemFyIFN0cmVldCwgVUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBD
b3VudHksIDcwMDA0NSwgUm9tYW5pYS4gUmVnaXN0ZXJlZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRp
b24gbnVtYmVyIEoyMi8yNjIxLzIwMDUuCg==

